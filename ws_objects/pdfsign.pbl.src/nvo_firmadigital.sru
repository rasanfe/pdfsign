$PBExportHeader$nvo_firmadigital.sru
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
public function boolean of_firmar (string as_ruta, string as_firma, string as_clave, string as_imagen, integer ai_x1, integer ai_y1, integer ai_x2, integer ai_y2, string as_nombre, string as_dni, boolean ab_visible)
end prototypes

public function boolean of_firmar (string as_ruta, string as_firma, string as_clave, string as_imagen, integer ai_x1, integer ai_y1, integer ai_x2, integer ai_y2, string as_nombre, string as_dni, boolean ab_visible);string ls_signed, ls_dir, ls_file, ls_firma, ls_extension
Boolean lb_Result=True
String ls_reason, ls_location, ls_contact
String ls_error
nvo_pdfservice lo_fd
nvo_fileservice lo_file
 
 lo_fd =  CREATE nvo_pdfservice
 lo_file = CREATE nvo_FileService
 
ls_file=lo_File.of_GetFileName(as_ruta)

if ls_file = "" then
	gf_mensaje ("Atención", "¡ Tiene que pasar la ruta completa del PDF !")
	Return false
end if	

ls_extension = lo_File.of_GetExtension(as_ruta)

if ls_extension <> ".pdf" then
	gf_mensaje ("Atención", "¡ El archivo "+ls_file+ " no es un PDF !")
	Return false
end if	

ls_firma=lo_File.of_GetFileName(as_firma)

if ls_firma = "" then
	gf_mensaje ("Atención", "¡ Tiene que pasar la ruta completa de la Firmal PFX !")
	Return false
end if	
		
ls_extension = lo_File.of_GetExtension(ls_firma)

if ls_extension <> ".pfx" then
	gf_mensaje ("Atención", "¡ El archivo "+ls_firma+ " no es un PFX !")
	Return false
end if	
			
ls_dir=lo_File.of_GetDirectoryName(as_ruta)+"\"

ls_signed =ls_dir+lo_File.of_GetFileNameWithoutExtension(ls_file)+"_sign.pdf"  
			
if not FileExists(gs_dir+"NetPdfService.dll") then
	gf_mensaje ("Atención", "¡ Necesita el Archivo NetPdfService.dll para firmar digitalmente los PDF !")
	Return false
end if	


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
			
if ls_error = ""  then
	FileDelete(as_ruta)
	lb_Result = lo_File.of_filerename(  ls_signed, as_ruta)
else
	gf_mensaje ("Atención", "¡ Error firmando "+ls_file+" !" + "~n~r"+ "~n~r"+"NetPdfService.dll Error: "+ls_error)
	lb_Result = false
end if	
	
Destroy lo_File
Destroy lo_fd
RETURN lb_Result
end function

on nvo_firmadigital.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_firmadigital.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

