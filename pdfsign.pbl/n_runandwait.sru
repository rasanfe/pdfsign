forward
global type n_runandwait from nonvisualobject
end type
type process_information from structure within n_runandwait
end type
type startupinfo from structure within n_runandwait
end type
type shellexecuteinfo from structure within n_runandwait
end type
type security_attributes from structure within n_runandwait
end type
end forward

type process_information from structure
	longptr		hprocess
	longptr		hthread
	unsignedlong		dwprocessid
	unsignedlong		dwthreadid
end type

type startupinfo from structure
	unsignedlong		cb
	string		lpreserved
	string		lpdesktop
	string		lptitle
	unsignedlong		dwx
	unsignedlong		dwy
	unsignedlong		dwxsize
	unsignedlong		dwysize
	unsignedlong		dwxcountchars
	unsignedlong		dwycountchars
	unsignedlong		dwfillattribute
	unsignedlong		dwflags
	unsignedinteger		wshowwindow
	unsignedinteger		cbreserved2
	longptr		lpreserved2
	longptr		hstdinput
	longptr		hstdoutput
	longptr		hstderror
end type

type shellexecuteinfo from structure
	unsignedlong		cbsize
	unsignedlong		fmask
	longptr		hwnd
	string		lpverb
	string		lpfile
	string		lpparameters
	string		lpdirectory
	longptr		nshow
	longptr		hinstapp
	longptr		lpidlist
	string		lpclass
	longptr		hkeyclass
	longptr		hicon
	longptr		hmonitor
	longptr		hprocess
end type

type security_attributes from structure
	unsignedlong		nlength
	longptr		lpsecuritydescriptor
	boolean		binherithandle
end type

global type n_runandwait from nonvisualobject autoinstantiate
end type

type prototypes
Function ulong GetLastError( &
	) Library "kernel32.dll"

Function ulong FormatMessage( &
	ulong dwFlags, &
	ulong lpSource, &
	ulong dwMessageId, &
	ulong dwLanguageId, &
	Ref string lpBuffer, &
	ulong nSize, &
	ulong Arguments &
	) Library "kernel32.dll" Alias For "FormatMessageW"

Function long ShellExecute ( &
	longptr hwnd, &
	string lpOperation, &
	string lpFile, &
	long lpParameters, &
	long lpDirectory, &
	long nShowCmd &
	) Library "Shell32.dll" Alias For "ShellExecuteW"
	
Function boolean ShellExecuteEx ( &
	Ref SHELLEXECUTEINFO lpExecInfo &
	) Library "shell32.dll" Alias For "ShellExecuteExW"

Function boolean CreateProcess ( &
	longptr lpApplicationName, &
	Ref string lpCommandLine, &
	longptr lpProcessAttributes, &
	longptr lpThreadAttributes, &
	boolean bInheritHandles, &
	ulong dwCreationFlags, &
	longptr lpEnvironment, &
	longptr lpCurrentDirectory, &
	STARTUPINFO lpStartupInfo, &
	Ref PROCESS_INFORMATION lpProcessInformation &
	) Library "kernel32.dll" Alias For "CreateProcessW"

Function ulong WaitForSingleObject ( &
	longptr hHandle, &
	long dwMilliseconds &
	) Library "kernel32.dll"

Function boolean CloseHandle ( &
	longptr hObject &
	) Library "kernel32.dll"

Function boolean GetExitCodeProcess ( &
	longptr hProcess, &
	Ref long lpExitCode &
	) Library "kernel32.dll"

Function boolean TerminateProcess ( &
	longptr hProcess, &
	long uExitCode &
	) Library "kernel32.dll"

Function boolean CreatePipe ( &
	Ref longptr hReadPipe, &
	Ref longptr hWritePipe, &
	SECURITY_ATTRIBUTES lpPipeAttributes, &
	long nSize &
	) Library "kernel32.dll"

Function boolean ReadFile ( &
	longptr hFile, &
	Ref blob lpBuffer, &
	ulong nNumberOfBytesToRead, &
	Ref ulong lpNumberOfBytesRead, &
	ulong lpOverlapped &
	) Library "kernel32.dll"

Subroutine ZeroMemory ( &
	Ref blob dest, &
	long size &
	) Library "kernel32.dll" Alias For "RtlZeroMemory"

Function boolean PeekNamedPipe ( &
	longptr hNamedPipe, &
	ulong lpBuffer, &
	ulong nBufferSize, &
	ulong lpBytesRead, &
	Ref ulong lpTotalBytesAvail, &
	ulong lpBytesLeftThisMessage &
	) Library "kernel32.dll"

end prototypes

type variables
Private:

// Common options
Constant Long NULL = 0
Constant Long INFINITE			= -1
Constant Long WAIT_TIMEOUT		= 258
Constant Long STARTF_USESHOWWINDOW = 1
Constant Long STARTF_USESTDHANDLES = 256
Constant Long CREATE_NEW_CONSOLE = 16
Constant Long NORMAL_PRIORITY_CLASS = 32

Boolean Process64Bit

Public:

// nShowCmd options
Constant Long SW_HIDE				= 0
Constant Long SW_SHOWNORMAL		= 1
Constant Long SW_SHOWMINIMIZED	= 2
Constant Long SW_SHOWMAXIMIZED	= 3

Boolean Terminate
Long LastExitCode
Long WaitTimeout
String LastErrorText
ULong LastErrorNum

end variables

forward prototypes
public function boolean of_shellrun (string as_filename, string as_shellverb, long al_showcmd)
public function boolean of_shellrunandwait (string as_filename, string as_shellverb, long al_showcmd)
public function boolean of_runandwait (string as_exefullpath, long al_showcmd)
public function boolean of_runandcapture (string as_exefullpath, ref string as_output)
public function boolean of_run (string as_exefullpath, windowstate a_windowstate)
public function string of_getlasterrortext ()
end prototypes

public function boolean of_shellrun (string as_filename, string as_shellverb, long al_showcmd);// -----------------------------------------------------------------------------
// SCRIPT:     ShellRun
//
// PURPOSE:    This function performs a shell operation on a file.
//
// ARGUMENTS:  as_filename		- Full path file name
//					as_shellverb	- Shell verb (open, edit, print, runas)
//					al_showcmd		- How the application will be displayed.
//											(use nShowCmd instance constants)
//
// RETURN:     True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/31/2022	RolandS		Initial Coding
//06/20/2022    Ramón        I rename function. I put the prefix of_
// -----------------------------------------------------------------------------

Long ll_return

ll_return = ShellExecute(Handle(this), as_shellverb, &
					as_filename, NULL, NULL, al_showcmd)
If ll_return <= 32 Then
	// ShellExecute failed
	LastErrorNum  = GetLastError()
	LastErrorText = of_GetLastErrorText()
	Return False
End If

Return True

end function

public function boolean of_shellrunandwait (string as_filename, string as_shellverb, long al_showcmd);// -----------------------------------------------------------------------------
// SCRIPT:     ShellRunAndWait
//
// PURPOSE:    This function performs a shell operation on a file and waits
//					for it to finish.
//
// ARGUMENTS:  as_filename		- Full path file name
//					as_shellverb	- Shell verb (open, edit, print, runas)
//					al_showcmd		- How the program will be displayed.
//											(use nShowCmd instance constants)
//
//	NOTES:		LastExitCode: Set to the exit code from the program
//					WaitTimeout:  Milliseconds to stop waiting
//					Terminate:    If true, kill the program after timeout
//
// RETURN:     True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/31/2022	RolandS		Initial Coding
//06/20/2022    Ramón        I rename function. I put the prefix of_
// -----------------------------------------------------------------------------

CONSTANT Long SEE_MASK_NOCLOSEPROCESS = 64
SHELLEXECUTEINFO lstr_sei
ULong lul_Reason

// initialize SHELLEXECUTEINFO structure
If Process64Bit Then
	lstr_sei.cbSize = 112
Else
	lstr_sei.cbSize = 60
End If
lstr_sei.fMask  = SEE_MASK_NOCLOSEPROCESS
lstr_sei.hWnd   = Handle(this)
lstr_sei.lpVerb = as_shellverb
lstr_sei.lpFile = as_filename
lstr_sei.nShow  = al_showcmd

If ShellExecuteEx(lstr_sei) Then
	// wait for the process to complete
	If WaitTimeout > 0 Then
		// wait until process ends or timeout period expires
		lul_Reason = WaitForSingleObject(lstr_sei.hProcess, WaitTimeout)
		// terminate process if not finished
		If Terminate And lul_Reason = WAIT_TIMEOUT Then
			TerminateProcess(lstr_sei.hProcess, -1)
			LastExitCode = WAIT_TIMEOUT
		Else
			// check for exit code
			GetExitCodeProcess(lstr_sei.hProcess, LastExitCode)
		End If
	Else
		// wait until process ends
		WaitForSingleObject(lstr_sei.hProcess, INFINITE)
		// check for exit code
		GetExitCodeProcess(lstr_sei.hProcess, LastExitCode)
	End If
	// close process and thread handles
	CloseHandle(lstr_sei.hProcess)
Else
	// ShellExecuteEx failed
	LastErrorNum  = GetLastError()
	LastErrorText = of_GetLastErrorText()
	LastExitCode = -1
	Return False
End If

Return True

end function

public function boolean of_runandwait (string as_exefullpath, long al_showcmd);// -----------------------------------------------------------------------------
// SCRIPT:     RunAndWait
//
// PURPOSE:    This function runs a program and waits	for it to finish.
//
// ARGUMENTS:  as_exefullpath	- Full path file name of the program.
//					al_showcmd		- How the program will be displayed.
//											(use nShowCmd instance constants)
//
//	NOTES:		LastExitCode: Set to the exit code from the program
//					WaitTimeout:  Milliseconds to stop waiting
//					Terminate:    If true, kill the program after timeout
//
// RETURN:     True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/31/2022	RolandS		Initial Coding
//06/20/2022    Ramón        I rename function. I put the prefix of_
// -----------------------------------------------------------------------------

STARTUPINFO lstr_si
PROCESS_INFORMATION lstr_pi
ULong lul_Reason

// initialize STARTUPINFO structure
If Process64Bit Then
	lstr_si.cb = 104
Else
	lstr_si.cb = 68
End If
lstr_si.dwFlags = STARTF_USESHOWWINDOW
lstr_si.wShowWindow = al_showcmd

// create process/thread and execute the passed program
If CreateProcess(NULL, as_exefullpath, NULL, NULL, &
			False, 0, NULL, NULL, lstr_si, lstr_pi) Then
	// wait for the process to complete
	If WaitTimeout > 0 Then
		// wait until process ends or timeout period expires
		lul_Reason = WaitForSingleObject(lstr_pi.hProcess, WaitTimeout)
		// terminate process if not finished
		If Terminate And lul_Reason = WAIT_TIMEOUT Then
			TerminateProcess(lstr_pi.hProcess, -1)
			LastExitCode = WAIT_TIMEOUT
		Else
			// check for exit code
			GetExitCodeProcess(lstr_pi.hProcess, LastExitCode)
		End If
	Else
		// wait until process ends
		WaitForSingleObject(lstr_pi.hProcess, INFINITE)
		// check for exit code
		GetExitCodeProcess(lstr_pi.hProcess, LastExitCode)
	End If
	// close process and thread handles
	CloseHandle(lstr_pi.hProcess)
	CloseHandle(lstr_pi.hThread)
Else
	// ShellExecuteEx failed
	LastErrorNum  = GetLastError()
	LastErrorText = of_GetLastErrorText()
	LastExitCode = -1
	Return False
End If

Return True

end function

public function boolean of_runandcapture (string as_exefullpath, ref string as_output);// -----------------------------------------------------------------------------
// SCRIPT:     RunAndCapture
//
// PURPOSE:    This function runs a program and waits	for it to finish. Once
//					done, it captures the console output.
//
// ARGUMENTS:  as_exefullpath	- Full path file name of the program.
//					as_output		- By ref string containing the console output.
//
// RETURN:     True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/31/2022	RolandS		Initial Coding
//06/20/2022    Ramón        I rename function. I put the prefix of_
// -----------------------------------------------------------------------------

Constant ULong BUFFERSIZE = 1024 * 8
SECURITY_ATTRIBUTES lstr_sa
STARTUPINFO lstr_si
PROCESS_INFORMATION lstr_pi
Blob lbl_Output
Boolean lb_Return
Longptr ll_PipeRead, ll_PipeWrite
ULong lul_Reason, lul_BytesRead, lul_BytesAvail

// allocate buffer space
lbl_Output = Blob(Space(BUFFERSIZE), EncodingAnsi!)

// initialize SECURITY_ATTRIBUTES structure
If Process64Bit Then
	lstr_sa.nLength = 24
Else
	lstr_sa.nLength = 12
End If
lstr_sa.bInheritHandle = True
lstr_sa.lpSecurityDescriptor = NULL

// create a pipe
If Not CreatePipe(ll_PipeRead, ll_PipeWrite, lstr_sa, 0) Then
	LastErrorNum  = GetLastError()
	LastErrorText = of_GetLastErrorText()
	Return False
End If

// initialize STARTUPINFO structure
If Process64Bit Then
	lstr_si.cb = 104
Else
	lstr_si.cb = 68
End If
lstr_si.dwFlags = STARTF_USESHOWWINDOW + STARTF_USESTDHANDLES
lstr_si.wShowWindow = SW_HIDE
lstr_si.hStdOutput = ll_PipeWrite
lstr_si.hStdError = ll_PipeWrite

// run the program
If CreateProcess(NULL, as_exefullpath, NULL, NULL, &
		True, 0, NULL, NULL, lstr_si, lstr_pi) Then
	do
		// wait on the process
		lul_Reason = WaitForSingleObject(lstr_pi.hProcess, 1)
		do
			// check to see if there is any data in the pipe
			PeekNamedPipe(ll_PipeRead, NULL, 0, NULL, lul_BytesAvail, NULL)

			// read data from the pipe
			If lul_BytesAvail > 0 Then
				ZeroMemory(lbl_Output, BUFFERSIZE)
				ReadFile(ll_PipeRead, lbl_Output, BUFFERSIZE, lul_BytesRead, NULL)
				If lul_BytesRead > 0 Then
					as_Output += String(lbl_Output, EncodingAnsi!)
				End If
			End If
		loop while lul_BytesRead = BUFFERSIZE
	loop while lul_Reason = WAIT_TIMEOUT
	lb_Return = True
Else
	// CreateProcess failed
	LastErrorNum  = GetLastError()
	LastErrorText = of_GetLastErrorText()
	lb_Return = False
End If

// close open handles
CloseHandle(lstr_pi.hProcess)
CloseHandle(lstr_pi.hThread)
CloseHandle(ll_PipeRead)
CloseHandle(ll_PipeWrite)

Return lb_Return

end function

public function boolean of_run (string as_exefullpath, windowstate a_windowstate);// -----------------------------------------------------------------------------
// SCRIPT:     n_runandwait.of_Run
//
// PURPOSE:    This function takes the Normal!, Maximized and
//					Minimized! enumerated values and passes the
//             corresponding value to the form of the function
//					that actually does the processing.
//
// ARGUMENTS:  as_exepath		- Path of program to execute
//             a_windowstate	- Show window option
//
// RETURN:     True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 07/16/2003	RolandS		Initial Coding
// 06/20/2022    Ramón       I put back this function that RolandS removed 
//									when rewriting this object.	
// -----------------------------------------------------------------------------

Boolean lb_rtn

CHOOSE CASE a_windowstate
	CASE Normal!
		lb_rtn = this.of_RunAndWait(as_exefullpath, SW_SHOWNORMAL)
	CASE Maximized!
		lb_rtn = this.of_RunAndWait(as_exefullpath, SW_SHOWMAXIMIZED)
	CASE Minimized!
		lb_rtn = this.of_RunAndWait(as_exefullpath, SW_SHOWMINIMIZED)
END CHOOSE

Return lb_rtn

end function

public function string of_getlasterrortext ();// -----------------------------------------------------------------------------
// SCRIPT:     of_GetLastErrorText
//
// PURPOSE:    This function returns the last Windows API error.
//
// RETURN:     Error message text
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/31/2022	RolandS		Initial Coding
//06/20/2022    Ramón        I rename function. I put the prefix of_
// -----------------------------------------------------------------------------

Constant ULong FORMAT_MESSAGE_FROM_SYSTEM = 4096
Constant ULong LANG_NEUTRAL = 0
Constant Long BUFFER_SIZE = 260
String ls_buffer

ls_buffer = Space(BUFFER_SIZE)

FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, 0, &
		LastErrorNum, LANG_NEUTRAL, ls_buffer, BUFFER_SIZE, 0)

Return ls_buffer

end function

on n_runandwait.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_runandwait.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;Environment le_env

GetEnvironment(le_env)

If le_env.ProcessBitness = 64 Then
	Process64Bit = True
Else
	Process64Bit = False
End If

end event

