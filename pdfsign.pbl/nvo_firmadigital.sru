forward
global type nvo_firmadigital from nonvisualobject
end type
end forward

global type nvo_firmadigital from nonvisualobject
end type
global nvo_firmadigital nvo_firmadigital

type variables

end variables

forward prototypes
public function boolean of_controles_previos (string as_ruta, string as_firma, string as_clave)
public function boolean of_firmar_net (string as_ruta, string as_firma, string as_clave, string as_imagen, integer ai_x1, integer ai_y1, integer ai_x2, integer ai_y2, string as_nombre, string as_dni, boolean ab_visible)
public function boolean of_firmar_app (string as_ruta, string as_firma, string as_clave, string as_imagen, integer ai_x1, integer ai_y1, integer ai_x2, integer ai_y2, string as_nombre, string as_dni, boolean ab_visible)
public function boolean of_control_dependencias (string as_dll)
end prototypes

public function boolean of_controles_previos (string as_ruta, string as_firma, string as_clave);if as_ruta = "" then
	gf_mensaje ("Atención", "¡ Tiene que pasar la ruta completa del PDF a firmar !")
	Return false
end if	

if not FileExists(as_ruta) then
	gf_mensaje ("Atención", "¡ No Existe el PDF  " +as_ruta + " !")
	Return false
end if	

if as_firma = "" then
	gf_mensaje ("Atención", "¡ Tiene que pasar la ruta completa de la Firmal PFX !")
	Return false
end if	
		
if not FileExists(as_firma) then
	gf_mensaje ("Atención", "¡ No Existe el Certificado  " +as_firma + " !")
	Return false
end if	

if trim(as_clave)="" or isnull(as_clave) then
	gf_mensaje ("Atención", "¡ Error en Clave del Certificado !")
	Return false
end if	
			
return true		
end function

public function boolean of_firmar_net (string as_ruta, string as_firma, string as_clave, string as_imagen, integer ai_x1, integer ai_y1, integer ai_x2, integer ai_y2, string as_nombre, string as_dni, boolean ab_visible);//Función para firmar usando la libreria importada con NetDLLLImporter "NetPdfService.dll" --> nvo_pdfservice
// Con esta opción se produce una excepción: The type initializer for 'iText.IO.Util.ResourceUtil' threw an exception.
string ls_signed, ls_dir, ls_file, ls_firma, ls_extension
Boolean lb_Result=True
String ls_reason, ls_location, ls_contact
String ls_error, ls_dll
nvo_pdfservice lo_fd
nvo_fileservice lo_file

ls_dll = "NetPdfService.dll"

 if not of_control_dependencias(ls_dll) then return false

if not of_controles_previos(as_ruta, as_firma, as_clave) then return false
 
 lo_fd =  CREATE nvo_pdfservice
 lo_file = CREATE nvo_FileService
 
ls_file=lo_File.of_GetFileName(as_ruta)

ls_firma=lo_File.of_GetFileName(as_firma)
	
ls_dir=lo_File.of_GetDirectoryName(as_ruta)+"\"

ls_signed =ls_dir+lo_File.of_GetFileNameWithoutExtension(ls_file)+"_sign.pdf"  

ls_reason="proof of authenticity"
ls_location=""
ls_contact=""

IF ab_visible= TRUE then
	lo_fd.of_firmar(as_ruta, ls_signed, as_firma, as_clave, ls_reason, ls_location, ls_contact, as_imagen, ai_x1, ai_y1, ai_x2, ai_y2, as_nombre, as_dni)
else
	lo_fd.of_firmar(as_ruta, ls_signed, as_firma, as_clave, ls_reason, ls_location, ls_contact)
end if	

ls_error=lo_fd.of_getlasterror()

if isnull(ls_error) then ls_error = "Unknown"

//Checks the result
IF lo_fd.il_ErrorType < 0 THEN
  ls_error =  lo_fd.is_ErrorText
END IF
	
if ls_error = ""  then
	FileDelete(as_ruta)
	lb_Result = lo_File.of_filerename(  ls_signed, as_ruta)
else
	gf_mensaje ("Atención", "¡ Error firmando "+ls_file+" !" + "~n~r"+ "~n~r"+ls_dll+" Error: "+ls_error)
	lb_Result =FALSE
end if	
	
Destroy lo_File
Destroy lo_fd
RETURN lb_Result
end function

public function boolean of_firmar_app (string as_ruta, string as_firma, string as_clave, string as_imagen, integer ai_x1, integer ai_y1, integer ai_x2, integer ai_y2, string as_nombre, string as_dni, boolean ab_visible);//Función para firmar ejecutando la aplicación de consola.
string ls_signed, ls_extension
Boolean lb_Result=True
String ls_reason, ls_location, ls_contact
n_runandwait  ln_rwait
nvo_fileservice lo_file
String ls_cmd, ls_programa, ls_result, ls_error, ls_file, ls_firma, ls_Dir, ls_dll
String ls_args[]

ls_dll ="TestNetPdfService.dll"

if not of_control_dependencias(ls_dll) then return false

if not of_controles_previos(as_ruta, as_firma, as_clave) then return false
 
lo_file = CREATE nvo_FileService
 
ls_file=lo_File.of_GetFileName(as_ruta)

ls_firma=lo_File.of_GetFileName(as_firma)
	
ls_dir=lo_File.of_GetDirectoryName(as_ruta)+"\"

ls_signed =ls_dir+lo_File.of_GetFileNameWithoutExtension(ls_file)+"_sign.pdf"  

ls_reason="proof of authenticity"
ls_location=""
ls_contact=""


ls_programa = gs_dir+"DotNet\NetPdfService\TestNetPdfService.exe"

ls_args[1]=as_ruta
ls_args[2]=ls_signed
ls_args[3]=as_firma
ls_args[4]=as_clave
ls_args[5]=ls_reason
ls_args[6]=ls_location
ls_args[7]=ls_contact
	
IF ab_visible= TRUE then
	ls_args[8]=as_imagen
	ls_args[9]=string(ai_x1)
	ls_args[10]=string(ai_y1)
	ls_args[11]=string(ai_x2)
	ls_args[12]=string(ai_y2)
	ls_args[13]=as_nombre
	ls_args[14]=as_dni
	ls_cmd =ls_programa + " "+char(34)+ls_args[1] +char(34)+ " "+char(34)+ls_args[2] +char(34)+ " "+char(34)+ls_args[3] +char(34)+ " "+char(34)+ls_args[4] +char(34)+ " "+char(34)+ls_args[5] +char(34)+ " "+char(34)+ls_args[6] +char(34)+ " "+char(34)+ls_args[7] +char(34)+ " "+char(34)+ls_args[8] +char(34)+ " "+char(34)+ls_args[9] +char(34)+ " "+char(34)+ls_args[10] +char(34)+ " "+char(34)+ls_args[11] +char(34)+ " "+char(34)+ls_args[12] +char(34)+ " "+char(34)+ls_args[13] +char(34)+ " "+char(34)+ls_args[14] +char(34)
else
		ls_cmd =ls_programa + " "+char(34)+ls_args[1] +char(34)+ " "+char(34)+ls_args[2] +char(34)+ " "+char(34)+ls_args[3] +char(34)+ " "+char(34)+ls_args[4] +char(34)+ " "+char(34)+ls_args[5] +char(34)+ " "+char(34)+ls_args[6] +char(34)+ " "+char(34)+ls_args[7] +char(34)
end if	


lb_Result  = ln_rwait.of_runandcapture(ls_cmd, ls_result)


if lb_result=true then
	if pos(ls_result, "Done!")=0 then
		ls_error = ls_result
	else
		ls_error =""
	end if	
else
	ls_error = ln_rwait.of_getlasterrortext()
end if
	
if ls_error = ""  then
	FileDelete(as_ruta)
	lb_Result = lo_File.of_filerename(  ls_signed, as_ruta)
else
	gf_mensaje ("Atención", "¡ Error firmando "+ls_file+" !" + "~n~r"+ "~n~r"+ls_dll+" "+ls_error)
	 lb_Result =FALSE
end if	
	
Destroy lo_File
RETURN lb_Result
end function

public function boolean of_control_dependencias (string as_dll);String ls_archivos[]
Int li_idx, li_totalArchivos

ls_archivos[]={"BouncyCastle.Crypto.dll", "itext.barcodes.dll", "itext.commons.dll", "itext.forms.dll", "itext.io.dll", "itext.kernel.dll", "itext.layout.dll", "itext.pdfa.dll", "itext.sign.dll", "itext.styledxmlparser.dll", "itext.svg.dll", "Microsoft.DotNet.PlatformAbstractions.dll", "Microsoft.Extensions.DependencyInjection.Abstractions.dll", "Microsoft.Extensions.DependencyInjection.dll", "Microsoft.Extensions.DependencyModel.dll", "Microsoft.Extensions.Logging.Abstractions.dll", "Microsoft.Extensions.Logging.dll", "Microsoft.Extensions.Options.dll", "Microsoft.Extensions.Primitives.dll", "Newtonsoft.Json.dll", as_dll }

li_totalArchivos = UpperBound(ls_archivos[])

//For conslole app
if as_dll ="TestNetPdfService.dll" then
	li_totalArchivos ++
	ls_archivos[li_totalArchivos]="TestNetPdfService.exe"
end if	

FOR li_idx = 1 TO li_totalArchivos
	IF NOT FileExists(gs_dir+"DotNet\NetPdfService\"+ls_archivos[li_idx]) THEN
		messagebox ("Atención", "¡ Necesita el Archivo "+ls_archivos[li_idx]+" !", Exclamation!)
		Return FALSE
	END IF
NEXT	
end function

on nvo_firmadigital.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_firmadigital.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

