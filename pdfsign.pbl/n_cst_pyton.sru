forward
global type n_cst_pyton from nonvisualobject
end type
end forward

global type n_cst_pyton from nonvisualobject
end type
global n_cst_pyton n_cst_pyton

type variables
//===========================================================================
// n_cst_pyton  -  Fachada fina sobre PyPb (pypblib.pbd/pbl)
// Esconde el ciclo de vida del contexto Python y normaliza los errores al
// estilo del ERP: NADA de excepciones hacia fuera; codigo 0/-1 + of_lasterror().
//===========================================================================
n_cst_pypbcontext  inv_context
boolean            ib_iniciado = false
string             is_lasterror

// Cache de modulos ya importados (arrays paralelos nombre -> modulo)
string             is_modnames[]
n_cst_pypbmodule   inv_modules[]
end variables

forward prototypes
public function integer of_init (string as_pythonpath)
public function boolean of_isinit ()
public function string of_lasterror ()
public function integer of_import (string as_modulename, ref n_cst_pypbmodule anv_module)
public function integer of_run (string as_statement, ref string as_result)
public function integer of_invoke (string as_modulename, string as_function, ref string as_result)
public function integer of_exec_req (string as_statement, n_cst_invocationrequest anv_req, ref n_cst_pypbobject anv_result)
end prototypes

public function integer of_init (string as_pythonpath);/// of_init
///
/// Arranca (o reutiliza) el runtime de Python.
///
/// string as_pythonpath: ruta completa al pythonXXX.dll (p.ej. "C:\Python313\python313.dll").
///                       "" => usa el runtime local autodetectado por PyPb.
///
/// returns: 0 si OK, -1 si error (ver of_lasterror()).

string ls_error
string ls_path

is_lasterror = ""

// Ya iniciado en esta instancia: nada que hacer
If ib_iniciado And Not IsNull(inv_context) Then Return 0

ls_path = as_pythonpath
If ls_path = "" Then SetNull(ls_path)   // null => f_pypbcontextinit usa el runtime local

inv_context = f_pypbcontextinit(ls_path, Ref ls_error)

// El gate de error es IsNull(contexto): cuando REUTILIZA un contexto ya
// creado, f_pypbcontextinit deja as_error="reusing" pero devuelve uno valido.
If IsNull(inv_context) Then
	is_lasterror = ls_error
	ib_iniciado  = false
	Return -1
End If

ib_iniciado = true
Return 0
end function

public function boolean of_isinit ();/// of_isinit
///
/// returns: TRUE si el contexto Python esta listo para usarse.

Return ib_iniciado And Not IsNull(inv_context)
end function

public function string of_lasterror ();/// of_lasterror
///
/// returns: el ultimo mensaje de error capturado por la fachada.

Return is_lasterror
end function

public function integer of_import (string as_modulename, ref n_cst_pypbmodule anv_module);/// of_import
///
/// Importa un modulo Python. Cachea el resultado para no reimportar.
///
/// string as_modulename: nombre del modulo (p.ej. "platform", "openpyxl").
/// ref n_cst_pypbmodule anv_module: el modulo si OK, null si error.
///
/// returns: 0 si OK, -1 si error (ver of_lasterror()).

integer li_i, li_n
integer li_res

is_lasterror = ""
SetNull(anv_module)

If Not of_isinit() Then
	is_lasterror = "El contexto Python no esta iniciado. Llame antes a of_init()."
	Return -1
End If

// ¿Ya esta en cache?
li_n = UpperBound(is_modnames[])
For li_i = 1 To li_n
	If is_modnames[li_i] = as_modulename Then
		anv_module = inv_modules[li_i]
		Return 0
	End If
Next

li_res = inv_context.of_import(as_modulename, Ref anv_module)
If li_res <> 0 Then
	is_lasterror = inv_context.of_lasterrormessage()
	Return -1
End If

// Guardar en cache
li_n ++
is_modnames[li_n] = as_modulename
inv_modules[li_n]  = anv_module

Return 0
end function

public function integer of_run (string as_statement, ref string as_result);/// of_run
///
/// Ejecuta una sentencia / expresion Python suelta sobre el contexto.
/// Si la expresion devuelve un valor, lo deja convertido a string en as_result.
///
/// string as_statement: codigo Python (p.ej. "2 ** 10" o "import sys; sys.version").
/// ref string as_result: resultado en texto ("" si la sentencia no devuelve valor).
///
/// returns: 0 si OK, -1 si error (ver of_lasterror()).

integer li_res
n_cst_pypbobject lnv_obj

is_lasterror = ""
as_result = ""

If Not of_isinit() Then
	is_lasterror = "El contexto Python no esta iniciado. Llame antes a of_init()."
	Return -1
End If

li_res = inv_context.of_executestatement(as_statement, Ref lnv_obj)
If li_res <> 0 Then
	is_lasterror = inv_context.of_lasterrormessage()
	Return -1
End If

// Si la sentencia devolvio un objeto, intentamos representarlo como texto.
// Que no sea convertible no es error fatal (p.ej. "x = 5" no devuelve nada).
If Not IsNull(lnv_obj) Then
	If lnv_obj.of_tostring(Ref as_result) <> 0 Then as_result = ""
End If

Return 0
end function

public function integer of_invoke (string as_modulename, string as_function, ref string as_result);/// of_invoke
///
/// Atajo: importa as_modulename e invoca la funcion as_function SIN argumentos,
/// devolviendo el resultado convertido a string. Para casos simples.
/// (Para args posicionales/kwargs se usa directamente n_cst_invocationrequest.)
///
/// string as_modulename: modulo (p.ej. "platform").
/// string as_function: funcion de modulo (p.ej. "python_version").
/// ref string as_result: resultado en texto.
///
/// returns: 0 si OK, -1 si error (ver of_lasterror()).

integer li_res
n_cst_pypbmodule lnv_mod
n_cst_pypbobject lnv_obj

is_lasterror = ""
as_result = ""

If of_import(as_modulename, Ref lnv_mod) <> 0 Then Return -1

li_res = lnv_mod.of_invoke(as_function, Ref lnv_obj)
If li_res <> 0 Then
	is_lasterror = lnv_mod.of_lasterrormessage()
	Return -1
End If

If Not IsNull(lnv_obj) Then
	If lnv_obj.of_tostring(Ref as_result) <> 0 Then as_result = ""
End If

Return 0
end function

public function integer of_exec_req (string as_statement, n_cst_invocationrequest anv_req, ref n_cst_pypbobject anv_result);/// of_exec_req
///
/// Ejecuta una sentencia Python pasando variables LOCALES via invocationrequest:
/// los argumentos NOMBRADOS del request se inyectan como locals (el target se ignora).
/// Util para MUTAR objetos, p.ej. "ws.title = t" con ws y t como locales,
/// cuando of_set sobre una property no es fiable.
///
/// returns: 0 si OK, -1 si error (ver of_lasterror()).

integer li_res

is_lasterror = ""
SetNull(anv_result)

If Not of_isinit() Then
	is_lasterror = "El contexto Python no esta iniciado. Llame antes a of_init()."
	Return -1
End If

li_res = inv_context.of_executestatement(as_statement, anv_req, Ref anv_result)
If li_res <> 0 Then
	is_lasterror = inv_context.of_lasterrormessage()
	Return -1
End If

Return 0
end function

on n_cst_pyton.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_pyton.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

