//objectcomments Generated Application Object
forward
global type pdfsign from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
String gs_dir, gs_ini
end variables

global type pdfsign from application
string appname = "pdfsign"
string displayname = "PdfSign"
string themepath = "C:\Program Files (x86)\Appeon\PowerBuilder 25.0\IDE\theme"
string themename = "Do Not Use Themes"
boolean nativepdfvalid = false
boolean nativepdfincludecustomfont = false
string nativepdfappname = ""
long richtextedittype = 5
long richtexteditx64type = 5
long richtexteditversion = 3
string richtexteditkey = ""
string appicon = "icono.ico"
string appruntimeversion = "25.1.0.6430"
boolean manualsession = false
boolean unsupportedapierror = false
boolean bignoreservercertificate = false
uint ignoreservercertificate = 0
integer highdpimode = 0
end type
global pdfsign pdfsign

type prototypes

end prototypes

on pdfsign.create
appname="pdfsign"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on pdfsign.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;gs_dir= GetCurrentDirectory() +"\"

gs_ini=gs_dir+"pdfsign.ini"

// Pre-cargar PyPb al arranque: su runtime .NET debe inicializarse ANTES que el
// dotnetobject de iText (NetPdfService). PowerBuilder carga el runtime .NET una
// sola vez por proceso; si iText va primero, PyPb puede fallar al cargar su
// assembly. El contexto de Python es global y persiste tras el DESTROY.
n_cst_pyton lnv_pyinit
lnv_pyinit = CREATE n_cst_pyton
lnv_pyinit.of_init(gs_dir + "python.runtime\python313.dll")
DESTROY lnv_pyinit

Open(w_main)
end event

