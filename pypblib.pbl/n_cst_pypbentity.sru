forward
global type n_cst_pypbentity from nonvisualobject
end type
end forward

global type n_cst_pypbentity from nonvisualobject
end type
global n_cst_pypbentity n_cst_pypbentity

type variables
protected str_pypberror istr_error

end variables

forward prototypes
public function string of_lasterrormessage ()
public function string of_lasterrorstack ()
public function string of_lasterrortarget ()
public function string of_lasterrorarguments ()
end prototypes

public function string of_lasterrormessage ();Return istr_error.s_message
end function

public function string of_lasterrorstack ();Return istr_error.s_stack

end function

public function string of_lasterrortarget ();Return istr_error.s_pypbfunction
end function

public function string of_lasterrorarguments ();Return istr_error.s_arguments
end function

on n_cst_pypbentity.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_pypbentity.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

