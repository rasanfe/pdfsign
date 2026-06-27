forward
global type n_cst_pypbcontext from n_cst_pypbentity
end type
end forward

global type n_cst_pypbcontext from n_cst_pypbentity
end type
global n_cst_pypbcontext n_cst_pypbcontext

type variables
dotnetobject idn_host 

end variables

forward prototypes
public subroutine of_terminate ()
public function string of_getruntimepath ()
public function boolean of_isinit ()
public subroutine of_reseterror ()
public function integer of_executeinpythonexe (string as_args)
public function integer of_executestatement (string as_statement, ref n_cst_pypbobject as_result)
public function integer of_executestatement (string as_statement, n_cst_invocationrequest anv_req, ref n_cst_pypbobject as_result)
public function integer of_fromimportmodule (string as_from, string as_import, ref n_cst_pypbmodule anv_module)
public function integer of_fromimportobject (string as_from, string as_import, ref n_cst_pypbobject anv_object)
public function integer of_import (string as_modulename, ref n_cst_pypbmodule anv_module)
public function integer of_loadmodule (string as_path, ref n_cst_pypbmodule anv_module)
public function integer of_registerforconsoleoutput (powerobject ao_callbackinstance, string as_callbackobject, string as_callbackevent)
public function integer of_unregisterfromconsoleoutput (string as_callbackobject, string as_callbackevent)
public function n_cst_pypbmodule of_import (string as_modulename)
public function n_cst_pypbmodule of_fromimportmodule (string as_from, string as_import)
public function n_cst_pypbmodule of_loadmodule (string as_path)
public function n_cst_pypbobject of_executestatement (string as_statement, n_cst_invocationrequest anv_req)
public function n_cst_pypbobject of_executestatement (string as_statement)
public function string of_lasterrormessage ()
public function n_cst_pypbobject of_fromimportobject (string as_from, string as_import)
end prototypes

public subroutine of_terminate ();/// of_terminate
///
/// Terminates the Python engine. It cannot be reinitialized after it's been terminated.
///

idn_host.Terminate()
end subroutine

public function string of_getruntimepath ();/// of_getruntimepath
///
/// returns: the path of the Python Runtime used to create this Context
return idn_host.RuntimePath
end function

public function boolean of_isinit ();Return idn_host.IsInit()
end function

public subroutine of_reseterror ();str_pypberror str

istr_error = str
end subroutine

public function integer of_executeinpythonexe (string as_args);string ls_error
int res

of_reseterror( )

res = idn_host.ExecuteInPythonExe(as_args, Ref ls_error)
istr_error = f_parseerror(ls_error)

Return res
end function

public function integer of_executestatement (string as_statement, ref n_cst_pypbobject as_result);int res 
string ls_error
dotnetobject ldn_aux

SetNull(as_result)
of_reseterror()

res = idn_host.ExecuteStatement(as_statement, Ref ldn_aux, Ref ls_error)

If res <> 0 Then 
	istr_error = f_parseerror(ls_error)
	Return -1
End If

as_result = f_wrapobject(ldn_aux)

Return 0
end function

public function integer of_executestatement (string as_statement, n_cst_invocationrequest anv_req, ref n_cst_pypbobject as_result);int res 
string ls_error
dotnetobject ldn_aux

SetNull(as_result)

of_reseterror( )

res = idn_host.ExecuteStatement(as_statement, anv_req.idn_host, ldn_aux, Ref ls_error)

If res <> 0 Then 
	istr_error = f_parseerror(ls_error)
	Return -1
End If

as_result = f_wrapobject(ldn_aux)

Return 0
end function

public function integer of_fromimportmodule (string as_from, string as_import, ref n_cst_pypbmodule anv_module);/// of_fromimport
///
/// Loads and returns a submodule inside a module
/// Equivalent to the 'from x import y' Python statement
///
/// string as_from: the name of the module
/// string as_import: the name of the object
/// ref n_cst_pypbmodule anv_module: the module if successful, null otherwise
///
/// returns: 0 on success

dotnetobject ldn_result
n_cst_pypbmodule lnv_module
int res
string ls_error

SetNull(anv_module)
of_reseterror()

Try
	ldn_result = idn_host.FromImportModule(as_from, as_import, Ref ls_error)
	
	If Not IsNull(ldn_result) Then 
		lnv_module = Create n_cst_pypbmodule
		
		lnv_module.idn_host = ldn_result
		
		anv_module = lnv_module
		
		Return 0
	Else
		istr_error = f_parseerror(ls_error)
		Return -1
	End If	
Catch (Throwable e)
	istr_error.s_message = e.GetMessage()
	Return -1
End Try
end function

public function integer of_fromimportobject (string as_from, string as_import, ref n_cst_pypbobject anv_object);/// of_fromimport
///
/// Loads and returns an object inside a module
/// Equivalent to the 'from x import y' Python statement
///
/// string as_from: the name of the module
/// string as_import: the name of the object
/// ref n_cst_pypbobject anv_object: the object if successful, null otherwise
///
/// returns: 0 on success

dotnetobject ldn_result
n_cst_pypbobject lnv_module
int res
string ls_error

SetNull(lnv_module)
of_reseterror()

Try
	ldn_result = idn_host.FromImportObject(as_from, as_import, Ref ls_error)
	
	If Not IsNull(ldn_result) Then 
		lnv_module = Create n_cst_pypbobject
		
		lnv_module.idn_host = ldn_result
		anv_object = lnv_module
		Return 0
	Else
		istr_error = f_parseerror(ls_error)
		Return -1
	End If	
Catch (Throwable e)
	istr_error.s_message = "Could not call FromImport on the .NET Object: " + e.GetMessage()
	Return -1
End Try
end function

public function integer of_import (string as_modulename, ref n_cst_pypbmodule anv_module);/// of_import
///
/// Loads and returns a python module in the Python Runtime's module paths
/// Equivalent to the 'import' Python statement
///
/// string as_modulename: the name of the module
/// ref n_cst_pypbmodule anv_module: the module if successful, null otherwise
///
/// returns: 0 on success

dotnetobject ldn_ret
n_cst_pypbmodule lnv_ret
string ls_error
SetNull(ldn_ret)
SetNull(lnv_ret)

of_reseterror()

ldn_ret = idn_host.Import(as_modulename, ref ls_error)

If IsNull(ls_error) Then
	lnv_ret = Create n_cst_pypbmodule
	lnv_ret.idn_host = ldn_ret
	anv_module = lnv_ret
	Return 0
Else
	istr_error = f_parseerror(ls_error)
	Return -1
End If

end function

public function integer of_loadmodule (string as_path, ref n_cst_pypbmodule anv_module);/// of_loadmodule
///
/// Loads and returns a python module in the specified as_path
/// Supports py, pyc and pyd files
///
/// string as_path: the path to the module
/// ref n_cst_pypbmodule anv_module: the module if successful, null otherwise
///
/// returns: 0 on success

dotnetobject ldn_ret
n_cst_pypbmodule lnv_ret
string ls_error

of_reseterror()

SetNull(ldn_ret)
SetNull(lnv_ret)

ldn_ret = idn_host.LoadModule(as_path, ref ls_error)

if IsNull(ls_error) then
	lnv_ret = create n_cst_pypbmodule
	lnv_ret.idn_host = ldn_ret
	
	anv_module = lnv_ret
	Return 0
Else
	istr_error = f_parseerror(ls_error)
	Return -1
End If

end function

public function integer of_registerforconsoleoutput (powerobject ao_callbackinstance, string as_callbackobject, string as_callbackevent);/// of_registerforconsoleoutput
///
/// Registers a callback event that will receive all Python standard output
///
/// powerobject ao_callbackinstance: object instance that owns the event that will be called
/// string as_callbackobject: name that will be used to identify the callback 
/// string as_callbackevent: the name of the event. Must have 1 string parameter
/// out string as_error: the error if one occurs
///
/// returns: -1 if registration failed, 0 otherwise
string ls_key
string ls_error
int res

of_reseterror()

ls_key = as_callbackObject + "_" + as_callbackevent

idn_host.Registerobject(ls_key, ao_callbackinstance)

res = idn_host.RegisterForConsoleOutput(ls_key, as_callbackObject, as_callbackEvent, ref ls_error)

If res <> 0 Then 
	istr_error = f_parseerror(ls_error)
End If

Return res
end function

public function integer of_unregisterfromconsoleoutput (string as_callbackobject, string as_callbackevent);/// of_unregisterfromconsoleoutput
///
/// Unregisters the specified callback from Python stdout redirection
///
/// string as_callbackobject: the name used to register the callback
/// string as_callbackevent: the name of the event used to register the callback
/// ref string as_error: an error if it occurs
///
/// returns: 0 if operation succeeds, -1 otherwise

string ls_key 
int res

ls_key = as_callbackObject + "_" + as_callbackevent

idn_host.Unregisterobject(ls_key)

res = idn_host.UnregisterFromConsoleOutput(ls_key)

Return res
end function

public function n_cst_pypbmodule of_import (string as_modulename);/// of_import
///
/// Loads and returns a python module in the Python Runtime's module paths, throws a runtime error if not successful
/// Equivalent to the 'import' Python statement
///
/// string as_modulename: the name of the module
///
/// returns: the module

int res
n_cst_pypbmodule lnv
n_cst_pypbruntimeerror re

res = of_import(as_modulename, Ref lnv)
If res <> 0 Then
	re = Create n_cst_pypbruntimeerror
	re.SetError(istr_error)
	Throw re
End If

Return lnv
end function

public function n_cst_pypbmodule of_fromimportmodule (string as_from, string as_import);/// of_fromimport
///
/// Loads and returns a submodule inside a module and throws if unsuccessful
/// Equivalent to the 'from x import y' Python statement
///
/// string as_from: the name of the module
/// string as_import: the name of the object
///
/// returns: the module

int res
n_cst_pypbmodule lnv
n_cst_pypbruntimeerror re

res = of_fromimportmodule( as_from, as_import, ref lnv)
If res <> 0 Then
	re = Create n_cst_pypbruntimeerror
	re.SetError(istr_error)
	Throw re
End If

Return lnv
end function

public function n_cst_pypbmodule of_loadmodule (string as_path);/// of_loadmodule
///
/// Loads and returns a python module in the specified as_path and throws a n_cst_pypbruntimeerror if not successful
/// Supports py, pyc and pyd files
///
/// string as_path: the path to the module
///
/// returns: the module

int res
n_cst_pypbmodule lnv
n_cst_pypbruntimeerror re

res = of_loadmodule(as_path, Ref lnv)
If res <> 0 Then
	re = Create n_cst_pypbruntimeerror
	re.SetError(istr_error)
	Throw re
End If

Return lnv
end function

public function n_cst_pypbobject of_executestatement (string as_statement, n_cst_invocationrequest anv_req);int res 
n_cst_pypbobject lnv
n_cst_pypbruntimeerror re

res = of_executestatement(as_statement, anv_req, ref lnv)

If res <> 0 Then
	re = Create n_cst_pypbruntimeerror
	re.SetError(istr_error)
	Throw re
End If

Return lnv


end function

public function n_cst_pypbobject of_executestatement (string as_statement);int res 
n_cst_pypbruntimeerror re
n_cst_pypbobject lnv

res = of_executestatement( as_statement, Ref lnv)
If Res <> 0 Then
	re = Create n_cst_pypbruntimeerror
	re.SetError(istr_error)
	Throw re
End If

Return lnv
end function

public function string of_lasterrormessage ();Return istr_error.s_message
end function

public function n_cst_pypbobject of_fromimportobject (string as_from, string as_import);/// of_fromimport
///
/// Loads and returns an object inside a module
/// Equivalent to the 'from x import y' Python statement
///
/// string as_from: the name of the module
/// string as_import: the name of the object
/// ref n_cst_pypbobject anv_object: the object if successful, null otherwise
///
/// returns: 0 on success

int res
n_cst_pypbobject lnv
n_cst_pypbruntimeerror re

res = of_fromimportobject(as_from, as_import, ref lnv)
If res <> 0 Then
	re = Create n_cst_pypbruntimeerror
	re.Setmessage( istr_error.s_message)
End If

Return lnv
end function

on n_cst_pypbcontext.create
call super::create
end on

on n_cst_pypbcontext.destroy
call super::destroy
end on

event constructor;str_pypberror str

istr_error = str
end event

