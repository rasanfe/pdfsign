forward
global type n_cst_pypbobject from n_cst_pypbentity
end type
end forward

global type n_cst_pypbobject from n_cst_pypbentity
end type
global n_cst_pypbobject n_cst_pypbobject

type variables
dotnetobject idn_host

end variables

forward prototypes
public function n_cst_invocationrequest of_createinvocationrequest (string as_target)
public subroutine of_reseterror ()
public function integer of_tobool (ref boolean ab_bool)
public function boolean of_tobool ()
public function integer of_toint (ref long al_int)
public function long of_toint ()
public function long of_get (string as_property, ref long al_value)
public function long of_getlong (string as_property)
public function boolean of_getboolean (string as_property)
public function long of_get (string as_property, ref boolean ab_value)
public function long of_get (string as_property, ref n_cst_pypbobject anv_value)
public function n_cst_pypbobject of_getobject (string as_property)
public function integer of_tostring (ref string as_string)
public function long of_get (string as_property, ref string as_value)
public function string of_getstring (string as_property)
public function string of_tostring ()
public function n_cst_pypbobject of_atindex (long al_index)
public function integer of_atindex (long al_index, ref n_cst_pypbobject anv_object)
public function integer of_atkey (string as_key, ref n_cst_pypbobject anv_object)
public function integer of_call (ref n_cst_pypbobject anv_result)
public function integer of_call (n_cst_invocationrequest anv_request, ref n_cst_pypbobject anv_result)
public function n_cst_pypbobject of_call ()
public function n_cst_pypbobject of_getmember (string as_membername)
public function integer of_getmember (string as_membername, ref n_cst_pypbobject anv_object)
public function long of_invoke (readonly n_cst_invocationrequest anv_req, ref n_cst_pypbobject anv_result)
public function n_cst_pypbobject of_invoke (readonly n_cst_invocationrequest anv_req)
public function long of_invoke (readonly string as_name, ref n_cst_pypbobject anv_result)
public function n_cst_pypbobject of_invoke (readonly string as_name)
public function long of_set (string as_property, boolean ab_value)
public function long of_set (string as_property, dotnetobject adn_value)
public function long of_set (string as_property, long al_value)
public function long of_set (string as_property, readonly n_cst_pypbobject anv_value)
public function long of_set (string as_property, readonly string as_value)
public function integer of_setatindex (long al_index, readonly any anv_object)
public function integer of_setatkey (string as_index, any anv_object)
public function integer of_todouble (ref double adbl_double)
public function double of_todouble ()
public function long of_get (string as_property, ref dotnetobject adn_value)
public function n_cst_pypbobject of_atkey (string as_key)
public function string of_lasterrormessage ()
end prototypes

public function n_cst_invocationrequest of_createinvocationrequest (string as_target);/// of_Createinvocationrequest
///
/// Creates an n_cst_invocationrequest object for the specified target 
///
/// string as_target: the invocation target's name
///
/// returns: an n_cst_invocationrequest instance

dotnetobject ldn_req
n_cst_invocationrequest lno_request

lno_request = Create n_cst_invocationrequest

ldn_req = idn_host.CreateInvocationRequest(as_target)

lno_request.idn_host = ldn_req


Return lno_request
end function

public subroutine of_reseterror ();str_pypberror str

istr_error = str
end subroutine

public function integer of_tobool (ref boolean ab_bool);/// of_tobool
///
/// Attempts to convert the current object to a boolean 
///
/// ref boolean ab_bool: the boolean value if conversion succeeded, null otherwise
/// ref string as_error: the error if one occurred
///
/// returns: 0 on success, -1 on failure
string ls_error
int res

of_reseterror( )

res = idn_host.ToBool(ref ab_bool, ref ls_error)

If res <> 0 Then
	istr_error = f_parseerror(ls_error)
End If

Return res
end function

public function boolean of_tobool ();/// of_tobool
///
/// Attempts to convert the current object to a boolean 
///
/// throws: an exception if the object cannot be converted 
///
/// returns: the value

int sc 
boolean value
n_cst_pypbruntimeerror e

of_reseterror( )

sc = of_tobool(Ref value)

If sc <> 0 Then
	e = Create n_cst_pypbruntimeerror
	e.SetError(istr_error)
	Throw e
End If

return value


end function

public function integer of_toint (ref long al_int);/// of_toint
///
/// Attempts to convert the current object to a Python int (32 bit, long in PowerBuilder)
///
/// ref long al_int: the long value if conversion succeeded, null otherwise
/// ref string as_error: the error if one occurred
///
/// returns: 0 on success, -1 on failure

int res
string ls_error

of_reseterror()

res = idn_host.ToInt(ref al_int, ref ls_error)

If res <> 0 Then
	istr_error = f_parseerror(ls_error)
End If

Return res
end function

public function long of_toint ();/// of_toint
///
/// Attempts to convert the current object to a Python int (32 bit, long in PowerBuilder)
///
/// throws: an exception if the object cannot be converted 
///
/// returns: the value


string ls_error
int sc 
long value
n_cst_pypbruntimeerror e

of_reseterror()

sc = of_toint(Ref value)

If sc <> 0 Then
	e = Create n_cst_pypbruntimeerror
	e.SetError(istr_error)
	Throw e
End If

return value
end function

public function long of_get (string as_property, ref long al_value);long res
dotnetobject ldn
n_cst_pypbobject lnv
string ls_error

of_reseterror( )

res = idn_host.Get(as_property, ref ldn, ref ls_error)
If Not IsNull(ldn) Then
	lnv = f_wrapobject(ldn)
	
	res = lnv.of_toint(ref al_value)
Else
	istr_error = f_parseerror(ls_error)
End If

return res
end function

public function long of_getlong (string as_property);int res
long result
string ls_error
n_cst_pypbruntimeerror e

of_reseterror()

res = of_get(as_property, Ref result)

If res <> 0 Then
	e = Create n_cst_pypbruntimeerror
	e.SetError(istr_error)
	Throw e
End If

return result
end function

public function boolean of_getboolean (string as_property);int res
boolean lb_result
string ls_error
n_cst_pypbruntimeerror e

of_reseterror()

res = of_get(as_property, Ref lb_result)

If res <> 0 Then
	e = Create n_cst_pypbruntimeerror
	e.SetError(istr_error)
	Throw e
End If

return lb_result
end function

public function long of_get (string as_property, ref boolean ab_value);long res
dotnetobject ldn
n_cst_pypbobject lnv
string ls_error


of_reseterror( )

res = idn_host.Get(as_property, ref ldn, ref ls_error)

If Not IsNull(ldn) Then
	lnv = f_wrapobject(ldn)
	
	res = lnv.of_tobool(ref ab_value)
Else
	istr_error = f_parseerror(ls_error)
End If

return res
end function

public function long of_get (string as_property, ref n_cst_pypbobject anv_value);long res
dotnetobject ldn
n_cst_pypbobject lnv
string ls_error

of_reseterror()

res = idn_host.Get(as_property, ref ldn, ref ls_error)
If Not IsNull(ldn) Then
	lnv = f_wrapobject(ldn)
	
	anv_value = lnv
Else
	istr_error = f_parseerror(ls_error)
End If

return res
end function

public function n_cst_pypbobject of_getobject (string as_property);int res
n_cst_pypbobject result
string ls_error
n_cst_pypbruntimeerror e

of_reseterror()

res = of_get(as_property, Ref result)

If res <> 0 Then
	e = Create n_cst_pypbruntimeerror
	e.SetError(istr_error)
	Throw e
End If

return result
end function

public function integer of_tostring (ref string as_string);/// of_tostring
///
/// Attempts to convert the current object to a string
///
/// ref string as_string: the string value if conversion succeeded, null otherwise
/// ref string as_error: the error if one occurred
///
/// returns: 0 on success, -1 on failure
string ls_error
int res

of_reseterror()

res = idn_host.ToString(ref as_string, ref ls_error)

If res <> 0 Then
	istr_error = f_parseerror(ls_error)
End If

Return res
end function

public function long of_get (string as_property, ref string as_value);long res
dotnetobject ldn
n_cst_pypbobject lnv
string ls_error

of_reseterror()

res = idn_host.Get(as_property, ref ldn, ref ls_error)
If Not IsNull(ldn) Then
	lnv = f_wrapobject(ldn)
	
	res = lnv.of_tostring(ref as_value)
Else
	istr_error = f_parseerror(ls_error)
End If

return res
end function

public function string of_getstring (string as_property);int res
string result
string ls_error
n_cst_pypbruntimeerror e

of_resetError()

res = of_get(as_property, Ref result)

If res <> 0 Then
	e = Create n_cst_pypbruntimeerror
	e.SetError(istr_error)
	Throw e
End If

return result
end function

public function string of_tostring ();/// of_tostring
///
/// throws: an exception if the object cannot be converted 
///
/// returns: the value


string ls_error
int sc 
string value
n_cst_pypbruntimeerror e

of_reseterror()

sc = of_tostring(Ref value)

If sc <> 0 Then
	e = Create n_cst_pypbruntimeerror
	e.SetError(istr_error)
	Throw e
End If

return value
end function

public function n_cst_pypbobject of_atindex (long al_index);int res
n_cst_pypbobject lnv
string ls_error
n_cst_pypbruntimeerror e

of_reseterror()

res = of_atindex(al_index, Ref lnv)

If res <> 0 Then 
	e = Create n_cst_pypbruntimeerror
	e.SetError(istr_error)
	Throw e
End If


Return lnv

end function

public function integer of_atindex (long al_index, ref n_cst_pypbobject anv_object);int res
dotnetobject ldn
string ls_error

of_ResetError()
Try
	res = idn_host.AtIndex(al_index, Ref ldn, Ref ls_error)
Catch (Throwable e)
	istr_error.s_message = e.GetMessage()
	Return -1
End Try

If res <> 0 Then
	istr_error = f_parseerror(ls_error)
	Return -1
End If

anv_object = f_wrapobject(ldn)

return 0
end function

public function integer of_atkey (string as_key, ref n_cst_pypbobject anv_object);int res
dotnetobject ldn
string ls_error

of_reseterror()

Try
	res = idn_host.AtKey(as_key, Ref ldn, Ref ls_error)
Catch (Throwable e)
	istr_error.s_message = e.GetMessage()
	Return -1
End Try

If res <> 0 Then
	istr_error = f_parseerror(ls_error)
	Return -1
End If

anv_object = f_wrapobject(ldn)

return 0
end function

public function integer of_call (ref n_cst_pypbobject anv_result);/// of_call
///
/// Invokes the current object assuming it's a callable
///
/// ref n_cst_pypbobject anv_result: the object resulting from the invocation. Null if invocation failed.
/// ref string as_error: the error if invocation failed
///
/// returns: 0 on success, -1 on failure


dotnetobject ldn_object
int res 
string ls_error

of_reseterror()

res = idn_host.Call(Ref ldn_object, Ref ls_error)

If res <> 0 Then 
	istr_error = f_parseerror(ls_error)
	Return -1
End If

anv_result = f_wrapobject(ldn_object)

Return 0
end function

public function integer of_call (n_cst_invocationrequest anv_request, ref n_cst_pypbobject anv_result);/// of_call
///
/// Invokes the current object assuming it's a callable
///
/// ref n_cst_invocationrequest anv_request: the invocation request with the call's arguments. The target value is ignored
/// ref n_cst_pypbobject anv_result: the object resulting from the invocation. Null if invocation failed.
/// ref string as_error: the error if invocation failed
///
/// returns: 0 on success, -1 on failure


dotnetobject ldn_object
int res 
string ls_error

of_reseterror( )

res = idn_host.Call(anv_request.idn_host, Ref ldn_object, Ref ls_error)

If res <> 0 Then
	istr_error = f_parseerror(ls_error)
	Return -1
End If

anv_result = f_wrapobject(ldn_object)

Return 0
end function

public function n_cst_pypbobject of_call ();/// of_call
///
/// Invokes the current object assuming it's a callable
///
/// throws: exception if an error occurs
///
/// returns: the result

n_cst_pypbobject lnv_result
string ls_error
int res
n_cst_pypbruntimeerror e

of_reseterror()

res = of_call(Ref lnv_result)

If res <> 0 Then
	e = Create n_cst_pypbruntimeerror
	
	e.SetError(istr_error)
	Throw e
End If

return lnv_result


end function

public function n_cst_pypbobject of_getmember (string as_membername);string ls_error
int sc 
n_Cst_pypbobject value
n_cst_pypbruntimeerror e

of_reseterror()

sc = of_getmember(as_membername, Ref value)

If sc <> 0 Then
	e = Create n_cst_pypbruntimeerror
	e.SetError(istr_error)
	Throw e
End If

return value
end function

public function integer of_getmember (string as_membername, ref n_cst_pypbobject anv_object);dotnetobject ldn_member
n_cst_pypbobject lnv_object
int res
string ls_error

SetNull(anv_object)

of_reseterror( )

res = idn_host.GetMember(as_memberName, Ref ldn_member, Ref ls_error)

If res <> 0 Then
	istr_error = f_parseerror(ls_error)
	Return -1
End If

anv_object = f_wrapobject(ldn_member)
Return 0
end function

public function long of_invoke (readonly n_cst_invocationrequest anv_req, ref n_cst_pypbobject anv_result);/// of_invoke
///
/// Invokes a method in the current object using the configuration in anv_req
///
/// readonly n_cst_invocationrequest anv_req: the invocation request that configures the invocation target and arguments
/// ref n_cst_pypbobject anv_result: the object resulting from the invocation. Null if invocation failed.
/// ref string as_error: the error if invocation failed
///
/// returns: 0 on success, -1 on failure

dotnetobject lnv_result
long res
n_cst_pypbobject lnv_resWrapper
string ls_error

of_reseterror( )

SetNull(lnv_resWrapper)

res = idn_host.Invoke(anv_req.idn_host, ref lnv_result, ref ls_error)

if res = 0 then
	lnv_resWrapper = create n_cst_pypbobject
	lnv_resWrapper.idn_host = lnv_result
Else
	istr_error = f_parseerror(ls_error)
end if

anv_result = lnv_resWrapper 

return res
end function

public function n_cst_pypbobject of_invoke (readonly n_cst_invocationrequest anv_req);/// of_invoke
///
/// Invokes a method in the current object using the configuration in anv_req
///
/// readonly n_cst_invocationrequest anv_req: the invocation request that configures the invocation target and arguments
/// 
/// throws: exception if invocation fails
///
/// returns: the resulting object
n_cst_pypbobject result
int sc
string ls_error
n_cst_pypbruntimeerror e

sc = of_invoke(anv_req, Ref result)

If sc <> 0 Then
	e = Create n_cst_pypbruntimeerror
	e.SetError(istr_error)
	Throw e
End If

return result
end function

public function long of_invoke (readonly string as_name, ref n_cst_pypbobject anv_result);/// of_invoke
///
/// Invokes a method in the current object with the name as_name
///
/// readonly string as_name: the name of the method
/// ref n_cst_pypbobject anv_result: the object resulting from the invocation. Null if invocation failed.
/// ref string as_error: the error if invocation failed
///
/// returns: 0 on success, -1 on failure


dotnetobject lnv_result
long res
n_cst_pypbobject lnv_resWrapper
string ls_error

SetNull(lnv_resWrapper)

of_reseterror( )

res = idn_host.Invoke(as_name, ref lnv_result, ref ls_error)

if res = 0 then
	lnv_resWrapper = create n_cst_pypbobject
	lnv_resWrapper.idn_host = lnv_result
Else
	istr_error = f_parseerror(ls_error)
end if

anv_result = lnv_resWrapper 

return res
end function

public function n_cst_pypbobject of_invoke (readonly string as_name);/// of_invoke
///
/// Invokes a method in the current object with the name as_name
///
/// readonly string as_name: the name of the method
/// 
/// throws: exception if the invocation fails
///
/// returns: the resulting object

n_cst_pypbobject result
int sc
string ls_error
n_cst_pypbruntimeerror e

sc = of_invoke(as_name, Ref result)

If sc <> 0 Then
	e = Create n_cst_pypbruntimeerror
	e.SetError(istr_error)
	Throw e
End If

return result
end function

public function long of_set (string as_property, boolean ab_value);long res
string ls_error

of_reseterror( )

res = idn_host.Set(as_property, ab_value, ref ls_error)

If res <> 0 Then
	istr_error = f_parseerror(ls_error)
End If

return res
end function

public function long of_set (string as_property, dotnetobject adn_value);long res
string ls_error

of_reseterror( )

res = idn_host.Set(as_property, adn_value, ref ls_error)

If res <> 0 Then
	istr_error = f_parseerror(ls_error)
End If

return res
end function

public function long of_set (string as_property, long al_value);long res
string ls_error

of_reseterror( )

res = idn_host.Set(as_property, al_value, ref ls_error)

If res <> 0 Then
	istr_error = f_parseerror(ls_error)
End If

return res
end function

public function long of_set (string as_property, readonly n_cst_pypbobject anv_value);long res
string ls_error

of_reseterror( )

res = idn_host.Set(as_property, anv_value.idn_host, ref ls_error)

If res <> 0 Then
	istr_error = f_parseerror(ls_error)
End If

return res

end function

public function long of_set (string as_property, readonly string as_value);long res
string ls_error

of_reseterror( )

res = idn_host.Set(as_property, as_value, ref ls_error)

If res <> 0 Then
	istr_error = f_parseerror(ls_error)
End If

return res

end function

public function integer of_setatindex (long al_index, readonly any anv_object);int res
dotnetobject ldn
string ls_error
n_cst_pypbobject lnv

of_reseterror()

Try
	If ClassName(anv_object) = "n_cst_pypbobject" Then
		lnv = anv_object
		res = idn_host.SetAtIndex(al_index, lnv.idn_host, Ref ls_error)
	Else
		res = idn_host.SetAtIndex(al_index, anv_object, Ref ls_error)
	End If
Catch (Throwable e)
	istr_error.s_message = e.GetMessage()
	Return -1
End Try

If res <> 0 Then
	istr_error = f_parseerror(ls_error)
	Return -1
End If

return 0
end function

public function integer of_setatkey (string as_index, any anv_object);int res
dotnetobject ldn
string ls_error
n_cst_pypbobject pypb

of_reseterror()

Try
	If ClassName(anv_object) = "n_cst_pypbobject" Then
		pypb = anv_object
		res = idn_host.SetAtKey(as_index, pypb.idn_host, Ref ls_error)		
	Else
		res = idn_host.SetAtKey(as_index, anv_object, Ref ls_error)
	End If
Catch (Throwable e)
	istr_error.s_message = e.GetMessage()
	Return -1
End Try

If res <> 0 Then
	istr_error = f_parseerror(ls_error)
	Return -1
End If

Return 0
end function

public function integer of_todouble (ref double adbl_double);/// of_todouble
///
/// Attempts to convert the current object to a double
///
/// ref adbl_double: the double value if conversion succeeded, null otherwise
/// ref string as_error: the error if one occurred
///
/// returns: 0 on success, -1 on failure

int res
string ls_error

of_reseterror( )

res = idn_host.ToDouble(ref adbl_double, ref ls_error)

If res <> 0 Then 
	istr_error = f_parseerror(ls_error)
End If

return res
end function

public function double of_todouble ();/// of_todouble
///
/// Attempts to convert the current object to a double
///
/// throws: an exception if the object cannot be converted 
///
/// returns: the value


string ls_error
int sc 
double value
n_cst_pypbruntimeerror e

of_reseterror( )

sc = of_todouble(Ref value)

If sc <> 0 Then
	e = Create n_cst_pypbruntimeerror
	e.SetError(istr_error)
	Throw e
End If

return value
end function

public function long of_get (string as_property, ref dotnetobject adn_value);long res
dotnetobject ldn
n_cst_pypbobject lnv
string ls_error

of_reseterror( )

res = idn_host.Get(as_property, ref ldn, ref ls_error)

If Res <> 0 Then
	istr_error = f_parseerror(ls_error)
End If

adn_value = ldn

return res
end function

public function n_cst_pypbobject of_atkey (string as_key);int res
n_cst_pypbobject lnv
string ls_error
n_cst_pypbruntimeerror e

of_reseterror( )

res = of_atkey(as_key, Ref lnv)

If res <> 0 Then 
	e = Create n_cst_pypbruntimeerror
	e.SetError(istr_error)
	Throw e
End If


Return lnv

end function

public function string of_lasterrormessage ();Return istr_error.s_message
end function

on n_cst_pypbobject.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_pypbobject.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;str_pypberror str

istr_error = str
end event

