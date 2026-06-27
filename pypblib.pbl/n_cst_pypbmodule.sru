forward
global type n_cst_pypbmodule from n_cst_pypbentity
end type
end forward

global type n_cst_pypbmodule from n_cst_pypbentity
end type
global n_cst_pypbmodule n_cst_pypbmodule

type variables
dotnetobject idn_host

end variables

forward prototypes
public function n_cst_invocationrequest of_createinvocationrequest (string as_target)
public subroutine of_reseterror ()
public function long of_get (string as_property, ref boolean ab_value)
public function boolean of_getboolean (string as_property)
public function long of_get (string as_property, ref dotnetobject adn_value)
public function long of_get (string as_property, ref long al_value)
public function long of_getlong (string as_property)
public function long of_get (string as_property, ref n_cst_pypbobject anv_value)
public function n_cst_pypbobject of_getobject (string as_property)
public function long of_get (string as_property, ref string as_value)
public function string of_getstring (string as_property)
public function n_cst_pypbobject of_getmember (string as_membername)
public function integer of_getmember (string as_membername, ref n_cst_pypbobject anv_object)
public function long of_instantiate (readonly n_cst_invocationrequest anv_request, ref n_cst_pypbobject anv_result)
public function n_cst_pypbobject of_instantiate (readonly n_cst_invocationrequest anv_request)
public function long of_instantiate (readonly string as_class, ref n_cst_pypbobject anv_result)
public function n_cst_pypbobject of_instantiate (readonly string as_class)
public function integer of_invoke (readonly n_cst_invocationrequest anv_req, ref n_cst_pypbobject anv_result)
public function n_cst_pypbobject of_invoke (n_cst_invocationrequest anv_req)
public function integer of_invoke (readonly string as_name, ref n_cst_pypbobject anv_result)
public function n_cst_pypbobject of_invoke (string as_name)
public function long of_set (string as_property, boolean ab_value)
public function long of_set (string as_property, dotnetobject adn_value)
public function long of_set (string as_property, long al_value)
public function long of_set (string as_property, n_cst_pypbobject anv_value)
public function long of_set (string as_property, string as_value)
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

public function long of_get (string as_property, ref boolean ab_value);long res
dotnetobject ldn
n_cst_pypbobject lnv
string ls_error

of_reseterror()

res = idn_host.Get(as_property, ref ldn, ref ls_error)
If Not IsNull(ldn) Then
	lnv = f_wrapobject(ldn)
	
	res = lnv.of_tobool(ref ab_value)
Else
	istr_error = f_parseerror(ls_error)
End If

return res
end function

public function boolean of_getboolean (string as_property);int res
boolean lb_result
string ls_error
n_cst_pypbruntimeerror e

of_reseterror( )

res = of_get(as_property, Ref lb_result)

If res <> 0 Then
	e = Create n_cst_pypbruntimeerror
	e.SetError(istr_error)
	Throw e
End If

return lb_result
end function

public function long of_get (string as_property, ref dotnetobject adn_value);long res
dotnetobject ldn
n_cst_pypbobject lnv
string ls_error

of_reseterror( )

res = idn_host.Get(as_property, ref ldn, ref ls_error)
If res <> 0 Then
	istr_error = f_parseerror(ls_error)
	Return -1
End If

adn_value = ldn

return res
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
n_cst_pypbruntimeerror e

res = of_get(as_property, Ref result)

If res <> 0 Then
	e = Create n_cst_pypbruntimeerror
	e.SetError(istr_error)
	Throw e
End If

return result
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

of_reseterror()

res = of_get(as_property, Ref result)

If res <> 0 Then
	e = Create n_cst_pypbruntimeerror
	e.SetError(istr_error)
	Throw e
End If

return result
end function

public function n_cst_pypbobject of_getmember (string as_membername);string ls_error
int sc 
n_Cst_pypbobject value
n_cst_pypbruntimeerror e

of_reseterror( )

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

of_reseterror()

res = idn_host.GetMember(as_memberName, Ref ldn_member, Ref ls_error)

If res <> 0 Then
	istr_error = f_parseerror(ls_error)
	Return -1
End If

anv_object = f_wrapobject(ldn_member)
Return 0
end function

public function long of_instantiate (readonly n_cst_invocationrequest anv_request, ref n_cst_pypbobject anv_result);/// of_instantiate
///
/// Creates an instance of the class specified on anv_request
///
/// readonly n_cst_invocationrequest anv_request: the invocation request that configures the instantiation target and arguments
/// ref n_cst_pypbobject anv_result: the object resulting from the instantiation. Null if instantiation failed.
/// ref string as_error: the error if instantiation failed
///
/// returns: 0 on success, -1 on failure

dotnetobject ldn_result
n_cst_pypbobject lnv_resultWrapper
long res
string ls_error

SetNull(lnv_resultWrapper)

of_reseterror()

res = idn_host.Instantiate(anv_request.idn_host, Ref ldn_result, Ref ls_error)

If res = 0 Then
	lnv_resultWrapper = create n_cst_pypbobject
	lnv_resultWrapper.idn_host = ldn_result
Else
	istr_error = f_parseerror(ls_error)
End If

anv_result = lnv_resultWrapper

return res
end function

public function n_cst_pypbobject of_instantiate (readonly n_cst_invocationrequest anv_request);/// of_instantiate
///
/// Creates an instance of the class specified by as_class without parameters
///
/// readonly string as_class: the name of the class to instantiate.
///
/// throws: exception if error occurred 
///
/// returns: the created instance

n_cst_pypbobject result
int sc
string ls_error
n_cst_pypbruntimeerror e

of_resetError()

sc = of_instantiate(anv_request, Ref result)

If sc <> 0 Then
	e = Create n_cst_pypbruntimeerror
	e.SetError(istr_error)
	Throw e
End If

return result
end function

public function long of_instantiate (readonly string as_class, ref n_cst_pypbobject anv_result);/// of_instantiate
///
/// Creates an instance of the class specified by as_class without parameters
///
/// readonly string as_class: the name of the class to instantiate.
/// ref n_cst_pypbobject anv_result: the object resulting from the instantiation. Null if instantiation failed.
/// ref string as_error: the error if instantiation failed
///
/// returns: 0 on success, -1 on failure

dotnetobject ldn_result
n_cst_pypbobject lnv_resultWrapper
long res
string ls_error

SetNull(lnv_resultWrapper)

of_reseterror()

res = idn_host.Instantiate(as_class, Ref ldn_result, Ref ls_error)
If res = 0 Then
	lnv_resultWrapper = create n_cst_pypbobject
	lnv_resultWrapper.idn_host = ldn_result
Else
	istr_error = f_parseerror(ls_error)
End If

anv_result = lnv_resultWrapper

return res
end function

public function n_cst_pypbobject of_instantiate (readonly string as_class);/// of_instantiate
///
/// Creates an instance of the class specified by as_class without parameters
///
/// readonly string as_class: the name of the class to instantiate.
///
/// throws: exception if error occurred 
///
/// returns: the created instance

n_cst_pypbobject result
int sc
string ls_error
n_cst_pypbruntimeerror e

sc = of_instantiate(as_class, Ref result)

If sc <> 0 Then
	e = Create n_cst_pypbruntimeerror
	e.SetError(istr_error)
	Throw e
End If

return result
end function

public function integer of_invoke (readonly n_cst_invocationrequest anv_req, ref n_cst_pypbobject anv_result);/// of_invoke
///
/// Invokes a free function in the current module using the configuration in anv_req
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

SetNull(lnv_resWrapper)

of_reseterror()

res = idn_host.Invoke(anv_req.idn_host, Ref lnv_result, Ref ls_error)

If res = 0 Then
	lnv_resWrapper = create n_cst_pypbobject
	lnv_resWrapper.idn_host = lnv_result
Else
	istr_error = f_parseerror(ls_error)
End If

anv_result = lnv_resWrapper 

return res
end function

public function n_cst_pypbobject of_invoke (n_cst_invocationrequest anv_req);/// of_invoke
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

of_reseterror()

sc = of_invoke(anv_req, Ref result)

If sc <> 0 Then
	e = Create n_cst_pypbruntimeerror
	e.SetError(istr_error)
	Throw e
End If

return result
end function

public function integer of_invoke (readonly string as_name, ref n_cst_pypbobject anv_result);/// of_invoke
///
/// Invokes a free function with the name as_name in the current module
///
/// readonly string as_name: the name of the function
/// ref n_cst_pypbobject anv_result: the object resulting from the invocation. Null if invocation failed.
/// ref string as_error: the error if invocation failed
///
/// returns: 0 on success, -1 on failure

dotnetobject lnv_result
long res
n_cst_pypbobject lnv_resWrapper
string ls_error

SetNull(lnv_resWrapper)

of_reseterror()

res = idn_host.Invoke(as_name, Ref lnv_result, Ref ls_error)

If res = 0 Then
	lnv_resWrapper = create n_cst_pypbobject
	lnv_resWrapper.idn_host = lnv_result
Else
	istr_error = f_parseerror(ls_error)
End If

anv_result = lnv_resWrapper 

return res
end function

public function n_cst_pypbobject of_invoke (string as_name);/// of_invoke
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

of_reseterror()

res = idn_host.Set(as_property, ab_value, ref ls_error)

If res <> 0 Then
	istr_error = f_Parseerror(ls_error)
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

public function long of_set (string as_property, n_cst_pypbobject anv_value);long res
string ls_error

of_reseterror( )

res = idn_host.Set(as_property, anv_value, ref ls_error)

If res <> 0 Then
	istr_error = f_parseerror(ls_error)
End If

return res

end function

public function long of_set (string as_property, string as_value);long res
string ls_error

of_reseterror( )

res = idn_host.Set(as_property, as_value, ref ls_error)

If res <> 0 Then
	istr_error = f_parseerror(ls_error)
End If

return res

end function

public function string of_lasterrormessage ();Return istr_error.s_message
end function

on n_cst_pypbmodule.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_pypbmodule.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;str_pypberror str

istr_error = str
end event

