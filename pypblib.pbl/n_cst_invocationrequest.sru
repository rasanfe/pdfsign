forward
global type n_cst_invocationrequest from nonvisualobject
end type
end forward

global type n_cst_invocationrequest from nonvisualobject
end type
global n_cst_invocationrequest n_cst_invocationrequest

type variables
dotnetobject idn_host

end variables

forward prototypes
public subroutine of_addargument (dotnetobject adn_object)
public subroutine of_addargument (integer ai_arg)
public subroutine of_addargument (string as_arg)
public subroutine of_addargument (long al_arg)
public subroutine of_addargument (n_cst_pypbobject anv_object)
public subroutine of_addargument (double ad_arg)
public subroutine of_addargument (boolean ab_arg)
public subroutine of_cleararguments ()
public subroutine of_addargument (datetime adt_datetime)
public subroutine of_addargument (date ad_arg)
public subroutine of_addnamedargument (string as_name, long value)
public subroutine of_addnamedargument (string as_name, string value)
public subroutine of_addnamedargument (string as_name, boolean value)
public subroutine of_addnamedargument (string as_name, n_cst_pypbobject value)
public subroutine of_addnamedargument (string as_name, date value)
public subroutine of_addnamedargument (string as_name, datetime value)
public subroutine of_addnamedargument (string as_name, dotnetobject value)
public subroutine of_addnamedargument (string as_name, double value)
public subroutine of_settargetname (string as_targetname)
end prototypes

public subroutine of_addargument (dotnetobject adn_object);idn_host.AddArgument(adn_object)
end subroutine

public subroutine of_addargument (integer ai_arg);idn_host.AddArgument(ai_arg)

end subroutine

public subroutine of_addargument (string as_arg);idn_host.AddArgument(as_arg)
end subroutine

public subroutine of_addargument (long al_arg);idn_host.AddArgument(al_arg)
end subroutine

public subroutine of_addargument (n_cst_pypbobject anv_object);idn_host.AddArgument(anv_object.idn_host)
end subroutine

public subroutine of_addargument (double ad_arg);idn_host.AddArgument(ad_arg)
end subroutine

public subroutine of_addargument (boolean ab_arg);idn_host.AddArgument(ab_arg)
end subroutine

public subroutine of_cleararguments ();idn_host.ClearArguments()
end subroutine

public subroutine of_addargument (datetime adt_datetime);idn_host.AddArgument(adt_datetime)
end subroutine

public subroutine of_addargument (date ad_arg);idn_host.AddArgument(ad_arg)
end subroutine

public subroutine of_addnamedargument (string as_name, long value);idn_host.AddNamedArgument(as_name, value)
end subroutine

public subroutine of_addnamedargument (string as_name, string value);idn_host.AddNamedArgument(as_name, value)
end subroutine

public subroutine of_addnamedargument (string as_name, boolean value);idn_host.AddNamedArgument(as_name, value)
end subroutine

public subroutine of_addnamedargument (string as_name, n_cst_pypbobject value);idn_host.AddNamedArgument(as_name, value.idn_host)
end subroutine

public subroutine of_addnamedargument (string as_name, date value);idn_host.AddNamedArgument(as_name, value)
end subroutine

public subroutine of_addnamedargument (string as_name, datetime value);idn_host.AddNamedArgument(as_name, value)
end subroutine

public subroutine of_addnamedargument (string as_name, dotnetobject value);idn_host.AddNamedArgument(as_name, value)
end subroutine

public subroutine of_addnamedargument (string as_name, double value);idn_host.AddNamedArgument(as_name, value)
end subroutine

public subroutine of_settargetname (string as_targetname);idn_host.TargetName = as_targetname
end subroutine

on n_cst_invocationrequest.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_invocationrequest.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

