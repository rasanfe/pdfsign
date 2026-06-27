forward
global type n_cst_pypbruntimeerror from runtimeerror
end type
end forward

global type n_cst_pypbruntimeerror from runtimeerror
string objectname = "n_cst_pypbruntimeerror"
string class = "n_cst_pypbruntimeerror"
string routinename = "create"
integer line = -1
end type
global n_cst_pypbruntimeerror n_cst_pypbruntimeerror

type variables
str_pypberror istr_error
end variables

forward prototypes
public function string getstack ()
public function string gettarget ()
public function string getarguments ()
public function string getmessage ()
public subroutine seterror (str_pypberror astr_error)
public subroutine setmessage (string newmessage)
end prototypes

public function string getstack ();Return istr_error.s_stack
end function

public function string gettarget ();Return istr_error.s_pypbfunction
end function

public function string getarguments ();Return istr_error.s_arguments
end function

public function string getmessage ();Return istr_error.s_message
end function

public subroutine seterror (str_pypberror astr_error);istr_error = astr_error
end subroutine

public subroutine setmessage (string newmessage);istr_error = f_parseerror(newmessage)
end subroutine

on n_cst_pypbruntimeerror.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_pypbruntimeerror.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

