forward
global type n_cst_pypbcontextwrapper from dotnetobject
end type
end forward

global type n_cst_pypbcontextwrapper from dotnetobject
end type
global n_cst_pypbcontextwrapper n_cst_pypbcontextwrapper

type variables

PUBLIC:
String is_assemblypath = "bin.pypb.appeon\Appeon.PyPb.PbWrapper.dll"
String is_classname = "Appeon.PyPb.PyPbContextWrapper.PyPbContextWrapper"

/*      Error types       */
Constant Int SUCCESS        =  0 // No error since latest reset
Constant Int LOAD_FAILURE   = -1 // Failed to load assembly
Constant Int CREATE_FAILURE = -2 // Failed to create .NET object
Constant Int CALL_FAILURE   = -3 // Call to .NET function failed

/* Latest error -- Public reset via of_ResetError */
PRIVATEWRITE Long il_ErrorType   
PRIVATEWRITE Long il_ErrorNumber 
PRIVATEWRITE String is_ErrorText 

PRIVATE:
/*  .NET object creation */
Boolean ib_objectCreated
end variables

forward prototypes
public subroutine of_setassemblyerror (long al_errortype, string as_actiontext, long al_errornumber, string as_errortext)
public subroutine of_reseterror ()
public function boolean of_createondemand ()
public function long of_init(string as_dllpath,ref dotnetobject anv_result,ref string as_error)
public function long of_initwithlocalruntime(string as_dependencies[],ref dotnetobject anv_context,ref string as_error)
public function boolean of_isinitialized()
public function dotnetobject of_currentinstance()
public function boolean of_getfilelock()
public function boolean of_releasefilelock()
public function n_cst_pypbcontext of_init (string as_dllpath)
public function n_cst_pypbcontext of_initwithlocalruntime (string as_dependencies[])
end prototypes

public subroutine of_setassemblyerror (long al_errortype, string as_actiontext, long al_errornumber, string as_errortext);
//*----------------------------------------------------------------------------------------------*/
//* PRIVATE of_setAssemblyError
//* Sets error description for specified error condition report by an assembly function
//*
//* Error description layout
//* 		| <actionText> failed.<EOL>
//* 		| Error Number: <errorNumber><EOL>
//* 		| Error Text: <errorText> (*)
//*  (*): Line skipped when <ErrorText> is empty
//*----------------------------------------------------------------------------------------------*/

/*    Format description */
String ls_error
ls_error = as_actionText + " failed.~r~n"
ls_error += "Error Number: " + String(al_errorNumber) + "."
If Len(Trim(as_errorText)) > 0 Then
	ls_error += "~r~nError Text: " + as_errorText
End If

/*  Retain state in instance variables */
This.il_ErrorType = al_errorType
This.is_ErrorText = ls_error
This.il_ErrorNumber = al_errorNumber
end subroutine

public subroutine of_reseterror ();
//*--------------------------------------------*/
//* PUBLIC of_ResetError
//* Clears previously registered error
//*--------------------------------------------*/

This.il_ErrorType = This.SUCCESS
This.is_ErrorText = ''
This.il_ErrorNumber = 0
end subroutine

public function boolean of_createondemand ();
//*--------------------------------------------------------------*/
//*  PUBLIC   of_createOnDemand( )
//*  Return   True:  .NET object created
//*               False: Failed to create .NET object
//*  Loads .NET assembly and creates instance of .NET class.
//*  Uses .NET when loading .NET assembly.
//*  Signals error If an error occurs.
//*  Resets any prior error when load + create succeeds.
//*--------------------------------------------------------------*/

This.of_ResetError( )
If This.ib_objectCreated Then Return True // Already created => DONE

Long ll_status 
String ls_action

/* Load assembly using .NET */
ls_action = 'Load ' + This.is_AssemblyPath
DotNetAssembly lnv_assembly
lnv_assembly = Create DotNetAssembly
ll_status = lnv_assembly.LoadWithDotNet(This.is_AssemblyPath)

/* Abort when load fails */
If ll_status <> 1 Then
	This.of_SetAssemblyError(This.LOAD_FAILURE, ls_action, ll_status, lnv_assembly.ErrorText)
	Return False // Load failed => ABORT
End If

/*   Create .NET object */
ls_action = 'Create ' + This.is_ClassName
ll_status = lnv_assembly.CreateInstance(is_ClassName, This)

/* Abort when create fails */
If ll_status <> 1 Then
	This.of_SetAssemblyError(This.CREATE_FAILURE, ls_action, ll_status, lnv_assembly.ErrorText)
	Return False // Load failed => ABORT
End If

This.ib_objectCreated = True
Return True
end function

public function long of_init(string as_dllpath,ref dotnetobject anv_result,ref string as_error);
//*-----------------------------------------------------------------*/
//*  .NET function : Init
//*   Argument:
//*              String as_dllpath
//*              Dotnetobject anv_result
//*              String as_error
//*   Return : Long
//*-----------------------------------------------------------------*/
/* Store the Return value from dotnet function */
Long ll_result

/* Create .NET object */
If Not This.of_createOnDemand( ) Then
	SetNull(ll_result)
	Return ll_result
End If

/* Trigger the dotnet function */
ll_result = This.init(as_dllpath,ref anv_result,ref as_error)
Return ll_result
end function

public function long of_initwithlocalruntime(string as_dependencies[],ref dotnetobject anv_context,ref string as_error);
//*-----------------------------------------------------------------*/
//*  .NET function : InitWithLocalRuntime
//*   Argument:
//*              String as_dependencies[]
//*              Dotnetobject anv_context
//*              String as_error
//*   Return : Long
//*-----------------------------------------------------------------*/
/* Store the Return value from dotnet function */
Long ll_result

/* Create .NET object */
If Not This.of_createOnDemand( ) Then
	SetNull(ll_result)
	Return ll_result
End If

/* Trigger the dotnet function */
ll_result = This.initwithlocalruntime(as_dependencies,ref anv_context,ref as_error)
Return ll_result
end function

public function boolean of_isinitialized();
//*-----------------------------------------------------------------*/
//*  .NET function : IsInitialized
//*   Return : Boolean
//*-----------------------------------------------------------------*/
/* Store the Return value from dotnet function */
Boolean lbln_result

/* Create .NET object */
If Not This.of_createOnDemand( ) Then
	SetNull(lbln_result)
	Return lbln_result
End If

/* Trigger the dotnet function */
lbln_result = This.isinitialized()
Return lbln_result
end function

public function dotnetobject of_currentinstance();
//*-----------------------------------------------------------------*/
//*  .NET function : CurrentInstance
//*   Return : Dotnetobject
//*-----------------------------------------------------------------*/
/* Store the Return value from dotnet function */
Dotnetobject lnv_result

/* Create .NET object */
If Not This.of_createOnDemand( ) Then
	SetNull(lnv_result)
	Return lnv_result
End If

/* Trigger the dotnet function */
lnv_result = This.currentinstance()
Return lnv_result
end function

public function boolean of_getfilelock();
//*-----------------------------------------------------------------*/
//*  .NET function : GetFileLock
//*   Return : Boolean
//*-----------------------------------------------------------------*/
/* Store the Return value from dotnet function */
Boolean lbln_result

/* Create .NET object */
If Not This.of_createOnDemand( ) Then
	SetNull(lbln_result)
	Return lbln_result
End If

/* Trigger the dotnet function */
lbln_result = This.getfilelock()
Return lbln_result
end function

public function boolean of_releasefilelock();
//*-----------------------------------------------------------------*/
//*  .NET function : ReleaseFileLock
//*   Return : Boolean
//*-----------------------------------------------------------------*/
/* Store the Return value from dotnet function */
Boolean lbln_result

/* Create .NET object */
If Not This.of_createOnDemand( ) Then
	SetNull(lbln_result)
	Return lbln_result
End If

/* Trigger the dotnet function */
lbln_result = This.releasefilelock()
Return lbln_result
end function

public function n_cst_pypbcontext of_init (string as_dllpath);dotnetobject ldn
n_cst_pypbcontext lnv
string ls_error
long res
RuntimeError re

res = of_init(as_dllpath, Ref ldn, Ref ls_error)

If res <> 0 Then 
	re = create runtimeerror
	re.SetMessage(ls_error)
	throw re
End If


lnv = create n_cst_pypbcontext
lnv.idn_host = ldn

Return lnv
end function

public function n_cst_pypbcontext of_initwithlocalruntime (string as_dependencies[]);dotnetobject ldn
n_cst_pypbcontext lnv
string ls_error
long res
RuntimeError re

res = of_initWithLocalRuntime(as_dependencies, Ref ldn, Ref ls_error)

If res <> 0 Then 
	re = create runtimeerror
	re.SetMessage(ls_error)
	throw re
End If


lnv = create n_cst_pypbcontext
lnv.idn_host = ldn

Return lnv
end function

on n_cst_pypbcontextwrapper.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_pypbcontextwrapper.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

