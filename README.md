# pdfsign — Firma digital de PDF en PowerBuilder

Ejemplo de **firma digital de PDF** (visible e invisible) con certificado `.pfx` desde
**PowerBuilder 2025**, con **tres motores de firma** que el usuario elige con unos radio buttons:

| Método | Motor | Cómo firma | Estado |
|--------|-------|-----------|--------|
| **Consola (.EXE)** | iText7 (.NET 8) | Lanza `TestNetPdfService.exe` y captura su salida | ✅ |
| **.NET librería** | iText7 (.NET 8) | Carga `NetPdfService.dll` como `dotnetobject` (en proceso) | ✅ (ver *fix* abajo) |
| **Python (pyHanko)** | pyHanko (PAdES) | Llama a un script Python vía **PyPb**, con runtime **embebido** | ✅ |

> El método elegido se recuerda entre sesiones en `pdfsign.ini` (`metodo=consola|net|python`).
> Por defecto: **Consola**.

Mismo botón **"Firmar PDF"**: según el radio marcado, despacha a uno u otro motor.

Los **tres motores producen firma PAdES** (eIDAS) con **sello de tiempo (TSA)** y, cuando hay
conexión, **LTV** (validación a largo plazo). Ver [«Firma legal»](#firma-legal--pades--sello-de-tiempo-tsa--ltv) abajo.

---

## Parámetros de firma (ventana `w_main`)

- **Pdf**: documento a firmar.
- **Firma (PFX)**: certificado digital `.pfx` / `.p12`.
- **Clave**: contraseña del certificado.
- **Visible** (check): si está marcado, la firma es **visible** (imagen + nombre/DNI); si no, **invisible** (solo criptográfica).
- **Imagen**: firma manuscrita (`.jpg`) que se estampa.
- **X1, Y1, X2, Y2**: rectángulo de la firma visible.
- **Nombre y apellidos**, **DNI**: texto que acompaña a la firma.

### ⚠️ Coordenadas (importante)
Las 4 casillas se interpretan como en **iText**: `Rectangle(x, y, ancho, alto)`.
- **X1, Y1** = esquina **inferior-izquierda** (puntos PDF, origen abajo-izquierda).
- **X2, Y2** = **ANCHO y ALTO** de la caja (¡no la esquina opuesta!).

El motor Python replica esta semántica (`box = (x1, y1, x1+x2, y1+y2)`) para que las
mismas casillas den el **mismo recuadro** en los tres métodos.

---

## Firma legal — PAdES + sello de tiempo (TSA) + LTV

Los tres motores firman en formato **PAdES** (`ETSI.CAdES.detached`, el estándar eIDAS para PDF),
añaden un **sello de tiempo** de una **TSA gratuita** (DigiCert) y, cuando se puede, **LTV**
(validación a largo plazo, **PAdES-B-LTA**: `/DSS` con cadena+revocación + sello de documento).

### Cascada con degradación (clave si NO hay internet)

```
B-LTA  (PAdES + sello + LTV)  →  B-T  (PAdES + sello)  →  B-B  (PAdES sin sello)
```

Si el LTV o el sello no se pueden obtener (sin red, TSA caída…), **degrada solo** y la firma
**siempre se produce** (en el peor caso, PAdES B-B sin sello). **No falla por estar offline.**
*(Único pero: el cliente TSA puede tardar unos segundos en dar timeout antes de degradar.)*

### Certificado demo legal

El `firma.pfx` original es **autofirmado** (demo básica → solo llega a B-T). Para firma legal se
incluye **`firma_legal.pfx`** (clave `PDFSIGN`): cadena CA + certificado firmante con KeyUsage
`digitalSignature + nonRepudiation` + su CRL. **Selecciona este certificado** en la app para PAdES-B-LTA.

> ⚠️ `firma_legal.pfx` es **DEMO**, NO un certificado cualificado. Para validez legal real, usar un
> certificado cualificado de un prestador de confianza (FNMT, etc.).

### Material de confianza (autocontenido)

- `python.runtime/trust/` — raíces del TSA + CA demo + CRL (motor Python).
- `DotNet/NetPdfService/demo.crl` — CRL del cert demo (motores iText: librería y consola).
- **TSA por defecto**: `http://timestamp.digicert.com` (sellado de tiempo **gratuito**).

---

## Método Python — autocontenido (el usuario no instala Python)

El camino Python reutiliza el puente **[PyPb](https://github.com/Appeon/PyPb)** (beta de Appeon
sobre Python.NET) y un **Python 3.13 *embeddable*** que viaja con la app. Nada que instalar.

| Pieza | Qué es |
|-------|--------|
| `pypblib.pbl` | Librería del puente PyPb (en la *library list*) |
| `n_cst_pyton.sru` | Fachada fina sobre PyPb (`of_init`/`of_import`/`of_invoke`) |
| `n_cst_pyton_pdfsign.sru` | Objeto de negocio: invoca `sign_pdf.sign(...)` |
| `python.runtime/` | Python 3.13 embeddable **+ pyHanko + Pillow + DejaVuSans.ttf** |
| `python.runtime/sign_pdf.py` | Firma PAdES+TSA+LTV; compone la apariencia con Pillow |
| `python.runtime/trust/` | Raíces TSA + CA demo + CRL (para validar/embeber LTV) |
| `bin.pypb.appeon/` | *Assemblies* .NET de PyPb |

- **Firma**: pyHanko en **PAdES + sello de tiempo + LTV** (cascada B-LTA→B-T→B-B), válida y con cobertura de todo el fichero.
- **Apariencia visible**: se **compone con Pillow** (firma centrada + nombre/DNI en `DejaVuSans`
  embebida, abajo-izquierda, sin recuadro), imitando el sello de iText. El sello de texto nativo de
  pyHanko se descartó (salía con borde, Courier y datos de más).
- **Gotcha PyPb**: PowerBuilder carga el runtime .NET una sola vez por proceso. Por eso se
  **pre-carga PyPb** en el `open` del objeto aplicación, antes de abrir la ventana.

### Despliegue del motor Python
Junto al `.exe` deben viajar las carpetas **`python.runtime/`** y **`bin.pypb.appeon/`**.

---

## 🔑 El "misterio" del modo librería iText (resuelto)

Durante mucho tiempo, el método **.NET librería** fallaba con:

```
The type initializer for 'iText.IO.Util.ResourceUtil' threw an exception.
```

…mientras que el **mismo** `NetPdfService.dll` funcionaba en modo **consola**.

**Causa real:** al hospedar PowerBuilder el CLR, **`AppDomain.CurrentDomain.BaseDirectory`
queda VACÍO (`""`)**. El constructor estático de `iText.IO.Util.ResourceUtil` hace
`Directory.GetFiles(BaseDirectory, "*.dll")` y solo comprueba `== null`, no cadena vacía
→ `Directory.GetFiles("")` → `ArgumentException: The path is empty`. En consola no pasa porque
ahí `BaseDirectory` es la carpeta del `.exe`.

> El mensaje externo de iText es genérico para *cualquier* fallo en ese constructor, lo que
> despistaba. La *inner exception* real (`ArgumentException: The path is empty`) fue la clave.

**Fix** (en las fuentes de `NetPdfService`): un constructor estático en `PdfService` que, antes
de que iText arranque, le da un `BaseDirectory` válido (la carpeta de la propia DLL):

```csharp
static PdfService()
{
    string dir = System.IO.Path.GetDirectoryName(typeof(PdfService).Assembly.Location) ?? "";
    if (string.IsNullOrEmpty(AppContext.BaseDirectory) && dir != "")
        AppContext.SetData("APP_CONTEXT_BASE_DIRECTORY", dir.EndsWith("\\") ? dir : dir + "\\");
    // (+ carga de las dependencias transitivas desde 'dir' por si el host no las resolviera)
}
```

Se ejecuta al instanciar `PdfService` (al `CREATE nvo_pdfservice`), antes de `Firmar`.

---

## Requisitos

- **PowerBuilder 2025** (con PyPb para el método Python).
- **.NET 8.0** (para los motores iText).
- Python **no** se instala: viaja embebido en `python.runtime/`.

## Cómo ejecutarlo

1. Abre el *workspace* en el IDE de PowerBuilder.
2. Asegúrate de que `pdfsign.pbl`, `dotnet.pbl` y `pypblib.pbl` están en la *library list*.
3. Compila y ejecuta.
4. Elige PDF, certificado y clave; marca/desmarca **Visible**; elige el método y pulsa **Firmar PDF**.

## Estructura

```
pdfsign/
├── pdfsign.pbl/            # App, ventana, objetos de firma (incl. n_cst_pyton*)
├── dotnet.pbl/             # Proxy dotnetobject de iText (nvo_pdfservice)
├── pypblib.pbl/            # Puente PyPb
├── DotNet/NetPdfService/   # iText7 8.0.5 + NetPdfService.dll + TestNetPdfService.exe + demo.crl
├── python.runtime/         # Python embeddable + pyHanko + Pillow + sign_pdf.py + DejaVuSans.ttf + trust/
├── bin.pypb.appeon/        # Assemblies .NET de PyPb
├── firma.pfx / firma.jpg   # Certificado autofirmado (demo básica) e imagen de firma
├── firma_legal.pfx         # Certificado demo LEGAL (CA + nonRepudiation + CRL), clave PDFSIGN
├── firma_legal_ca.cer      # CA raíz demo (para confiar/validar)
├── firma_legal.crl         # CRL del cert demo (LTV)
└── pdfsign.ini             # Preferencias (rutas, coordenadas, método)
```

## Proyecto .NET (iText)

Las fuentes de `NetPdfService` (Visual Studio, .NET 8 + iText7) están en:

- Local: `Blog/Net8/NetPdfService/`
- GitHub: https://github.com/rasanfe/NetPdfService

---

Para estar al tanto de lo que publico puedes seguir mi blog:
<https://rsrsystem.blogspot.com/>
