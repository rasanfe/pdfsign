# -*- coding: utf-8 -*-
r"""
sign_pdf.py  -  Firma digital de PDF con pyHanko, llamado desde PowerBuilder via
PyPb. Runtime Python EMBEBIDO: el usuario no instala nada.

Firma en formato **PAdES** (ETSI.CAdES.detached) con **sello de tiempo (TSA)** y,
cuando es posible, **LTV** (validacion a largo plazo, PAdES-B-LTA). Si el LTV o el
sello no se pueden obtener (red, TSA caida...), degrada con gracia:

    B-LTA  (PAdES + sello + LTV)   ->   B-T  (PAdES + sello)   ->   B-B  (PAdES)

siempre produciendo una firma PAdES valida. Devuelve "Done! (<nivel>)".

API principal (la que invoca PowerBuilder):

    sign(infile, outfile, certfile, password,
         reason="", location="", contact="",
         imgfile="", x1=0, y1=0, x2=0, y2=0,
         nombre="", dni="", visible=True, page=None,
         tsa_url=DEFAULT_TSA, ltv=True)  -> "Done! (NIVEL)" | "ERROR: ..."

La capa PB comprueba  pos(resultado, "Done!") > 0.

COORDENADAS: misma semantica que iText7  Rectangle(x, y, ANCHO, ALTO):
    x1, y1 = esquina inferior-izquierda (puntos PDF, origen abajo-izq)
    x2, y2 = ANCHO y ALTO de la caja
Asi las casillas X1/Y1/X2/Y2 de PB dan el MISMO recuadro que el metodo consola/iText.

APARIENCIA VISIBLE: se compone con Pillow (firma manuscrita centrada + nombre/DNI
pequeno abajo-izquierda), imitando el sello de iText. Fuente DejaVuSans embebida.

CONFIANZA / LTV: el material de confianza (raices del TSA, CA demo, CRL) se carga de
la carpeta  python.runtime\trust\  por convencion de nombres:
    *.root.pem -> anclas de confianza | *.int.pem -> intermedios | *.crl -> CRLs

TSA por defecto: DigiCert (sellado de tiempo GRATUITO). Cambiable con tsa_url.

Notas:
- Los argumentos string se fuerzan con str() y los numericos con int() porque PyPb
  puede entregar System.String / System.Int32 de .NET.
- La firma INVISIBLE no crea caja ni apariencia; solo firma criptograficamente.
- DEMO: el certificado de ejemplo (firma_legal.pfx) NO es cualificado. Para validez
  legal real, usar un certificado cualificado de un prestador de confianza.
"""
import os
import sys
from datetime import datetime

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
FONT_PATH = os.path.join(SCRIPT_DIR, "DejaVuSans.ttf")
TRUST_DIR = os.path.join(SCRIPT_DIR, "trust")
SCALE = 5                                  # px de lienzo por punto PDF
DEFAULT_TSA = "http://timestamp.digicert.com"   # TSA RFC3161 gratuita


def _appearance_image(imgfile, nombre, dni, w_pt, h_pt):
    """Apariencia visible (RGBA) imitando el sello de iText: firma centrada
    (blanco -> transparente) + nombre/DNI pequeno abajo-izquierda."""
    from PIL import Image, ImageDraw, ImageFont

    W, H = max(1, int(w_pt * SCALE)), max(1, int(h_pt * SCALE))
    canvas = Image.new("RGBA", (W, H), (255, 255, 255, 0))

    if imgfile and os.path.exists(imgfile):
        sig = Image.open(imgfile).convert("RGBA")
        sig.putdata([(r, g, b, 0) if r > 235 and g > 235 and b > 235 else (r, g, b, a)
                     for (r, g, b, a) in sig.getdata()])
        ratio = sig.width / sig.height
        sw, sh = W, int(W / ratio)
        if sh > H:
            sh, sw = H, int(H * ratio)
        sig = sig.resize((sw, sh))
        canvas.alpha_composite(sig, ((W - sw) // 2, (H - sh) // 2))

    lineas = [t for t in (nombre, dni) if t]
    if lineas:
        draw = ImageDraw.Draw(canvas)
        fs = max(8, int(H * 0.11))
        try:
            font = ImageFont.truetype(FONT_PATH, fs)
        except Exception:
            font = ImageFont.load_default()
        lh = int(fs * 1.2)
        margin = max(2, int(W * 0.01))
        y = H - len(lineas) * lh - margin
        for linea in lineas:
            draw.text((margin, y), linea, fill=(0, 0, 0, 255), font=font)
            y += lh

    return canvas


def _validation_context():
    """ValidationContext para LTV: carga trust/ (raices, intermedios, CRLs) y
    permite descargar OCSP/CRL del TSA (allow_fetching). soft-fail para no abortar
    si falta revocacion de alguna parte."""
    import glob
    from pyhanko_certvalidator import ValidationContext
    from asn1crypto import pem, x509 as ax509, crl as acrl

    def load_certs(path):
        data = open(path, "rb").read()
        out = []
        if pem.detect(data):
            for _, _, der in pem.unarmor(data, multiple=True):
                out.append(ax509.Certificate.load(der))
        else:
            out.append(ax509.Certificate.load(data))
        return out

    roots, others, crls = [], [], []
    if os.path.isdir(TRUST_DIR):
        for f in glob.glob(os.path.join(TRUST_DIR, "*.root.pem")):
            roots += load_certs(f)
        for f in glob.glob(os.path.join(TRUST_DIR, "*.int.pem")):
            others += load_certs(f)
        for f in glob.glob(os.path.join(TRUST_DIR, "*.crl")):
            crls.append(acrl.CertificateList.load(open(f, "rb").read()))

    return ValidationContext(trust_roots=roots, other_certs=others, crls=crls,
                             allow_fetching=True, revocation_mode="soft-fail")


def sign(infile, outfile, certfile, password,
         reason="", location="", contact="",
         imgfile="", x1=0, y1=0, x2=0, y2=0,
         nombre="", dni="", visible=True, page=None,
         tsa_url=DEFAULT_TSA, ltv=True):
    try:
        from pyhanko.sign import signers, fields, timestamps
        from pyhanko.sign.fields import SigSeedSubFilter
        from pyhanko.pdf_utils.incremental_writer import IncrementalPdfFileWriter

        # --- Normalizar tipos (PyPb puede pasar System.String / System.Int32) ---
        infile, outfile = str(infile), str(outfile)
        certfile, password = str(certfile), str(password)
        reason, location, contact = str(reason), str(location), str(contact)
        imgfile, nombre, dni = str(imgfile), str(nombre), str(dni)
        x1, y1, x2, y2 = int(x1), int(y1), int(x2), int(y2)
        tsa_url = (str(tsa_url).strip() if tsa_url is not None else "")
        if page is None or (isinstance(page, str) and str(page).strip() == ""):
            page = None
        else:
            page = int(page)
        if isinstance(visible, str):
            visible = visible.strip().lower() in ("1", "true", "yes", "si", "s")
        else:
            visible = bool(visible)
        if isinstance(ltv, str):
            ltv = ltv.strip().lower() in ("1", "true", "yes", "si", "s")
        else:
            ltv = bool(ltv)

        if not reason or not reason.strip():
            reason = "proof of authenticity"        # por defecto, como iText

        # --- Cargar el firmante desde el .pfx/.p12 ---
        signer = signers.SimpleSigner.load_pkcs12(
            certfile, passphrase=password.encode("utf-8") if password else None
        )
        if signer is None:
            return "ERROR: no se pudo cargar el certificado (clave incorrecta o PFX invalido)"

        # Nombre de campo unico estilo iText: sig_<dni>_<fecha>
        field_name = "sig_" + dni + "_" + datetime.now().strftime("%Y%m%d%H%M%S")

        # Apariencia visible (se calcula una vez)
        appearance = _appearance_image(imgfile, nombre, dni, x2, y2) if visible else None

        def _attempt(use_ltv, use_tsa):
            from pyhanko.stamp import TextStampStyle
            from pyhanko.pdf_utils.images import PdfImage
            timestamper = timestamps.HTTPTimeStamper(tsa_url) if (use_tsa and tsa_url) else None
            with open(infile, "rb") as inf:
                w = IncrementalPdfFileWriter(inf)
                if page is None:
                    try:
                        pg = max(0, int(w.root["/Pages"]["/Count"]) - 1)   # ultima pagina
                    except Exception:
                        pg = 0
                else:
                    pg = page
                stamp_style = None
                if visible:
                    box = (x1, y1, x1 + x2, y1 + y2)   # semantica iText (ancho/alto)
                    fields.append_signature_field(
                        w, sig_field_spec=fields.SigFieldSpec(
                            sig_field_name=field_name, box=box, on_page=pg))
                    stamp_style = TextStampStyle(
                        stamp_text="", border_width=0,
                        background=PdfImage(appearance), background_opacity=1.0)
                kw = dict(field_name=field_name, reason=(reason or None),
                          location=(location or None), subfilter=SigSeedSubFilter.PADES)
                if use_ltv:
                    kw.update(embed_validation_info=True, use_pades_lta=True,
                              validation_context=_validation_context())
                meta = signers.PdfSignatureMetadata(**kw)
                pdf_signer = signers.PdfSigner(meta, signer=signer,
                                               stamp_style=stamp_style, timestamper=timestamper)
                with open(outfile, "wb") as outf:
                    pdf_signer.sign_pdf(w, output=outf)

        # Cascada: lo mejor posible, degradando con gracia.
        plan = [("B-LTA", True, True), ("B-T", False, True), ("B-B", False, False)]
        last_err = None
        for nivel, use_ltv, use_tsa in plan:
            if use_ltv and not ltv:
                continue
            if use_tsa and not tsa_url:
                continue
            try:
                _attempt(use_ltv, use_tsa)
                return "Done! (%s)" % nivel
            except Exception as e:
                last_err = e
                continue

        return "ERROR: " + repr(last_err)
    except Exception as e:
        return "ERROR: " + repr(e)


# --- Modo CLI para pruebas (mismo orden de argumentos que TestNetPdfService.exe) ---
# python sign_pdf.py in out cert pass reason loc contact [img x1 y1 x2 y2 nombre dni]
if __name__ == "__main__":
    a = sys.argv[1:]
    if len(a) < 4:
        print("Uso: sign_pdf.py in out cert pass [reason loc contact "
              "[img x1 y1 x2 y2 nombre dni]]")
        sys.exit(1)

    infile, outfile, certfile, password = a[0], a[1], a[2], a[3]
    reason = a[4] if len(a) > 4 else ""
    location = a[5] if len(a) > 5 else ""
    contact = a[6] if len(a) > 6 else ""

    if len(a) >= 14:  # firma visible
        res = sign(infile, outfile, certfile, password, reason, location, contact,
                   imgfile=a[7], x1=a[8], y1=a[9], x2=a[10], y2=a[11],
                   nombre=a[12], dni=a[13], visible=True)
    else:             # firma invisible
        res = sign(infile, outfile, certfile, password, reason, location, contact,
                   visible=False)

    print(res)
    sys.exit(0 if res.startswith("Done!") else 2)
