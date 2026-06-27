forward
global type n_cst_pyton_pdfsign from nonvisualobject
end type
end forward

global type n_cst_pyton_pdfsign from nonvisualobject
end type
global n_cst_pyton_pdfsign n_cst_pyton_pdfsign

type variables
//===========================================================================
// n_cst_pyton_pdfsign  -  Firma digital de PDF con pyHanko via PyPb.
// USA n_cst_pyton por dentro e invoca la funcion sign() de sign_pdf.py.
// Sin excepciones hacia fuera: of_firmar() devuelve la cadena de resultado
// ("Done!" en exito) y deja el detalle en of_lasterror().
//===========================================================================
n_cst_pyton        inv_py
n_cst_pypbmodule   inv_mod         // modulo sign_pdf
string             is_lasterror
end variables

forward prototypes
public function integer of_init (string as_pythonpath)
public function string of_firmar (string as_infile, string as_outfile, string as_certfile, string as_password, string as_reason, string as_location, string as_contact, string as_imgfile, long al_x1, long al_y1, long al_x2, long al_y2, string as_nombre, string as_dni, boolean ab_visible)
public function string of_lasterror ()
end prototypes

public function integer of_init (string as_pythonpath);/// of_init
///
/// Arranca el runtime de Python (delegando en n_cst_pyton) e importa sign_pdf.
///
/// string as_pythonpath: ruta al pythonXXX.dll ("" = runtime local).
///
/// returns: 0 si OK, -1 si error (ver of_lasterror()).

is_lasterror = ""

inv_py = CREATE n_cst_pyton

If inv_py.of_init(as_pythonpath) <> 0 Then
	is_lasterror = inv_py.of_lasterror()
	Return -1
End If

If inv_py.of_import("sign_pdf", Ref inv_mod) <> 0 Then
	is_lasterror = inv_py.of_lasterror()
	Return -1
End If

Return 0
end function

public function string of_firmar (string as_infile, string as_outfile, string as_certfile, string as_password, string as_reason, string as_location, string as_contact, string as_imgfile, long al_x1, long al_y1, long al_x2, long al_y2, string as_nombre, string as_dni, boolean ab_visible);/// of_firmar
///
/// Invoca sign_pdf.sign(...) con argumentos NOMBRADOS (kwargs) y devuelve la
/// cadena de resultado de Python ("Done!" en exito, "ERROR: ..." en fallo).
///
/// returns: cadena de resultado de Python ("" si no se pudo convertir).

n_cst_invocationrequest lnv_req
n_cst_pypbobject lnv_res
string ls_result

is_lasterror = ""

If IsNull(inv_mod) Or Not inv_py.of_isinit() Then
	is_lasterror = "El modulo sign_pdf no esta iniciado. Llame antes a of_init()."
	Return "ERROR: " + is_lasterror
End If

lnv_req = inv_mod.of_createinvocationrequest("sign")
lnv_req.of_addnamedargument("infile", as_infile)
lnv_req.of_addnamedargument("outfile", as_outfile)
lnv_req.of_addnamedargument("certfile", as_certfile)
lnv_req.of_addnamedargument("password", as_password)
lnv_req.of_addnamedargument("reason", as_reason)
lnv_req.of_addnamedargument("location", as_location)
lnv_req.of_addnamedargument("contact", as_contact)
lnv_req.of_addnamedargument("imgfile", as_imgfile)
lnv_req.of_addnamedargument("x1", al_x1)
lnv_req.of_addnamedargument("y1", al_y1)
lnv_req.of_addnamedargument("x2", al_x2)
lnv_req.of_addnamedargument("y2", al_y2)
lnv_req.of_addnamedargument("nombre", as_nombre)
lnv_req.of_addnamedargument("dni", as_dni)
lnv_req.of_addnamedargument("visible", ab_visible)

If inv_mod.of_invoke(lnv_req, Ref lnv_res) <> 0 Then
	is_lasterror = inv_mod.of_lasterrormessage()
	Return "ERROR: " + is_lasterror
End If

ls_result = ""
If Not IsNull(lnv_res) Then
	If lnv_res.of_tostring(Ref ls_result) <> 0 Then ls_result = ""
End If

Return ls_result
end function

public function string of_lasterror ();Return is_lasterror
end function

on n_cst_pyton_pdfsign.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_pyton_pdfsign.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;// El contexto Python es global (PyPb lo reutiliza); destruir el helper
// NO termina Python, solo libera este objeto.
If IsValid(inv_py) Then DESTROY inv_py
end event
