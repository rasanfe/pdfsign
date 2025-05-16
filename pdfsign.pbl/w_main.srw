forward
global type w_main from window
end type
type st_nombreyapellidos from statichyperlink within w_main
end type
type st_dni from statichyperlink within w_main
end type
type sle_nombreyapellidos from singlelineedit within w_main
end type
type sle_dni from singlelineedit within w_main
end type
type pb_ver from picturebutton within w_main
end type
type p_2 from picture within w_main
end type
type cbx_visible from checkbox within w_main
end type
type em_x2 from editmask within w_main
end type
type em_y2 from editmask within w_main
end type
type shl_4 from statichyperlink within w_main
end type
type shl_3 from statichyperlink within w_main
end type
type shl_2 from statichyperlink within w_main
end type
type shl_1 from statichyperlink within w_main
end type
type em_y1 from editmask within w_main
end type
type em_x1 from editmask within w_main
end type
type cb_3 from commandbutton within w_main
end type
type st_6 from statictext within w_main
end type
type sle_imagen from singlelineedit within w_main
end type
type p_1 from picture within w_main
end type
type st_info from statictext within w_main
end type
type sle_clave from singlelineedit within w_main
end type
type st_4 from statictext within w_main
end type
type st_myversion from statictext within w_main
end type
type st_platform from statictext within w_main
end type
type cb_sign from commandbutton within w_main
end type
type sle_archivo from singlelineedit within w_main
end type
type st_2 from statictext within w_main
end type
type cb_2 from commandbutton within w_main
end type
type cb_1 from commandbutton within w_main
end type
type st_1 from statictext within w_main
end type
type sle_firma from singlelineedit within w_main
end type
type r_2 from rectangle within w_main
end type
end forward

global type w_main from window
integer width = 2363
integer height = 2056
boolean titlebar = true
string title = "PdfSignV"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
string icon = "AppIcon!"
boolean center = true
st_nombreyapellidos st_nombreyapellidos
st_dni st_dni
sle_nombreyapellidos sle_nombreyapellidos
sle_dni sle_dni
pb_ver pb_ver
p_2 p_2
cbx_visible cbx_visible
em_x2 em_x2
em_y2 em_y2
shl_4 shl_4
shl_3 shl_3
shl_2 shl_2
shl_1 shl_1
em_y1 em_y1
em_x1 em_x1
cb_3 cb_3
st_6 st_6
sle_imagen sle_imagen
p_1 p_1
st_info st_info
sle_clave sle_clave
st_4 st_4
st_myversion st_myversion
st_platform st_platform
cb_sign cb_sign
sle_archivo sle_archivo
st_2 st_2
cb_2 cb_2
cb_1 cb_1
st_1 st_1
sle_firma sle_firma
r_2 r_2
end type
global w_main w_main

type prototypes

end prototypes

type variables
nvo_FirmaDigital in_pdf
end variables

forward prototypes
public subroutine wf_version (statictext ast_version, statictext ast_patform)
end prototypes

public subroutine wf_version (statictext ast_version, statictext ast_patform);String ls_version, ls_platform
environment env
integer rtn

rtn = GetEnvironment(env)

IF rtn <> 1 THEN 
	ls_version = string(year(today()))
	ls_platform="32"
ELSE
	ls_version = "20"+ string(env.pbmajorrevision)+ "." + string(env.pbbuildnumber)
	ls_platform=string(env.ProcessBitness)
END IF

ls_platform += " Bits"

ast_version.text=ls_version
ast_patform.text=ls_platform

end subroutine

on w_main.create
this.st_nombreyapellidos=create st_nombreyapellidos
this.st_dni=create st_dni
this.sle_nombreyapellidos=create sle_nombreyapellidos
this.sle_dni=create sle_dni
this.pb_ver=create pb_ver
this.p_2=create p_2
this.cbx_visible=create cbx_visible
this.em_x2=create em_x2
this.em_y2=create em_y2
this.shl_4=create shl_4
this.shl_3=create shl_3
this.shl_2=create shl_2
this.shl_1=create shl_1
this.em_y1=create em_y1
this.em_x1=create em_x1
this.cb_3=create cb_3
this.st_6=create st_6
this.sle_imagen=create sle_imagen
this.p_1=create p_1
this.st_info=create st_info
this.sle_clave=create sle_clave
this.st_4=create st_4
this.st_myversion=create st_myversion
this.st_platform=create st_platform
this.cb_sign=create cb_sign
this.sle_archivo=create sle_archivo
this.st_2=create st_2
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_1=create st_1
this.sle_firma=create sle_firma
this.r_2=create r_2
this.Control[]={this.st_nombreyapellidos,&
this.st_dni,&
this.sle_nombreyapellidos,&
this.sle_dni,&
this.pb_ver,&
this.p_2,&
this.cbx_visible,&
this.em_x2,&
this.em_y2,&
this.shl_4,&
this.shl_3,&
this.shl_2,&
this.shl_1,&
this.em_y1,&
this.em_x1,&
this.cb_3,&
this.st_6,&
this.sle_imagen,&
this.p_1,&
this.st_info,&
this.sle_clave,&
this.st_4,&
this.st_myversion,&
this.st_platform,&
this.cb_sign,&
this.sle_archivo,&
this.st_2,&
this.cb_2,&
this.cb_1,&
this.st_1,&
this.sle_firma,&
this.r_2}
end on

on w_main.destroy
destroy(this.st_nombreyapellidos)
destroy(this.st_dni)
destroy(this.sle_nombreyapellidos)
destroy(this.sle_dni)
destroy(this.pb_ver)
destroy(this.p_2)
destroy(this.cbx_visible)
destroy(this.em_x2)
destroy(this.em_y2)
destroy(this.shl_4)
destroy(this.shl_3)
destroy(this.shl_2)
destroy(this.shl_1)
destroy(this.em_y1)
destroy(this.em_x1)
destroy(this.cb_3)
destroy(this.st_6)
destroy(this.sle_imagen)
destroy(this.p_1)
destroy(this.st_info)
destroy(this.sle_clave)
destroy(this.st_4)
destroy(this.st_myversion)
destroy(this.st_platform)
destroy(this.cb_sign)
destroy(this.sle_archivo)
destroy(this.st_2)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.sle_firma)
destroy(this.r_2)
end on

event open;in_pdf = CREATE nvo_FirmaDigital

wf_version(st_myversion, st_platform)

//Guardo en el Archivo INI de la App
sle_archivo.text = trim(ProFileString(gs_ini, "INICIO", "ruta", ""))
sle_firma.text =trim(ProFileString(gs_ini, "INICIO", "firma", ""))
sle_imagen.text =trim(ProFileString(gs_ini, "INICIO", "imagen", ""))

p_1.PictureName=sle_imagen.text

em_x1.text =trim(ProFileString(gs_ini, "INICIO", "x1", "228"))
em_y1.text =trim(ProFileString(gs_ini, "INICIO", "y1", "45"))
em_x2.text =trim(ProFileString(gs_ini, "INICIO", "x2", "378"))
em_y2.text =trim(ProFileString(gs_ini, "INICIO", "y2", "125"))

sle_nombreyapellidos.text =trim(ProFileString(gs_ini, "INICIO", "nombre", ""))
sle_dni.text =trim(ProFileString(gs_ini, "INICIO", "dni", ""))

String ls_clave

ls_clave = trim(ProFileString(gs_ini, "INICIO", "clave", ""))

sle_clave.text=ls_clave

end event

event closequery;//Guardo en el Archivo INI de la App
SetProFileString(gs_ini, "INICIO", "ruta",trim(sle_archivo.text))
SetProFileString(gs_ini, "INICIO", "firma",trim(sle_firma.text))
SetProFileString(gs_ini, "INICIO", "clave", trim(sle_clave.text))
SetProFileString(gs_ini, "INICIO", "imagen", trim(sle_imagen.text))
SetProFileString(gs_ini, "INICIO", "x1", em_x1.text)
SetProFileString(gs_ini, "INICIO", "y1", em_y1.text)
SetProFileString(gs_ini, "INICIO", "x2", em_x2.text)
SetProFileString(gs_ini, "INICIO", "y2", em_y2.text)
SetProFileString(gs_ini, "INICIO", "nombre", sle_nombreyapellidos.text)
SetProFileString(gs_ini, "INICIO", "dni", sle_dni.text)

Destroy in_pdf
end event

type st_nombreyapellidos from statichyperlink within w_main
integer x = 553
integer y = 1712
integer width = 443
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "HyperLink!"
long textcolor = 134217856
string text = "Nombre y Apellidos:"
boolean focusrectangle = false
end type

type st_dni from statichyperlink within w_main
integer x = 882
integer y = 1624
integer width = 105
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "HyperLink!"
long textcolor = 134217856
string text = "Dni:"
boolean focusrectangle = false
end type

type sle_nombreyapellidos from singlelineedit within w_main
integer x = 1001
integer y = 1696
integer width = 704
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
borderstyle borderstyle = stylelowered!
end type

type sle_dni from singlelineedit within w_main
integer x = 1001
integer y = 1592
integer width = 704
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
borderstyle borderstyle = stylelowered!
end type

type pb_ver from picturebutton within w_main
integer x = 1934
integer y = 620
integer width = 110
integer height = 96
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "RunProject!"
alignment htextalign = left!
string powertiptext = "Ver Clave"
end type

event clicked;if sle_clave.Password=True then
	sle_clave.Password=False
	this.PictureName = "Open1!"
else
	sle_clave.Password=True
	this.PictureName ="RunProject!"
	
end if	
end event

type p_2 from picture within w_main
integer x = 5
integer y = 4
integer width = 1253
integer height = 248
boolean originalsize = true
string picturename = "logo.jpg"
boolean focusrectangle = false
end type

type cbx_visible from checkbox within w_main
integer x = 379
integer y = 864
integer width = 293
integer height = 80
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 553648127
string text = "Visible"
boolean checked = true
end type

event clicked;if this.checked=true then
	st_info.y=1858
	st_6.visible=true
	sle_imagen.visible=true
	cb_3.visible=true
	p_1.visible=true
	shl_1.visible=true
	shl_2.visible=true
	shl_3.visible=true
	shl_4.visible=true
	em_x1.visible=true
	em_y1.visible=true
	em_x2.visible=true
	em_y2.visible=true
	parent.height =2092
	cb_sign.y =1440
	st_dni.visible=true
	sle_dni.visible=true
	st_nombreyapellidos.visible=true
	sle_nombreyapellidos.visible=true
else
	st_info.y=920
	st_6.visible=false
	sle_imagen.visible=false
	cb_3.visible=false
	p_1.visible=false
	shl_1.visible=false
	shl_2.visible=false
	shl_3.visible=false
	shl_4.visible=false
	em_x1.visible=false
	em_y1.visible=false
	em_x2.visible=false
	em_y2.visible=false
	parent.height =1150
	cb_sign.y=800
	st_dni.visible=false
	sle_dni.visible=false
	st_nombreyapellidos.visible=false
	sle_nombreyapellidos.visible=false
end if

end event

type em_x2 from editmask within w_main
integer x = 1518
integer y = 856
integer width = 197
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "150"
borderstyle borderstyle = stylelowered!
string mask = "###"
boolean spin = true
double increment = 1
end type

type em_y2 from editmask within w_main
integer x = 1847
integer y = 976
integer width = 197
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "80"
borderstyle borderstyle = stylelowered!
string mask = "###"
boolean spin = true
double increment = 1
end type

type shl_4 from statichyperlink within w_main
integer x = 1746
integer y = 992
integer width = 101
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "HyperLink!"
long textcolor = 134217856
string text = "Y2"
boolean focusrectangle = false
end type

type shl_3 from statichyperlink within w_main
integer x = 1417
integer y = 884
integer width = 91
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "HyperLink!"
long textcolor = 134217856
string text = "X2"
boolean focusrectangle = false
end type

type shl_2 from statichyperlink within w_main
integer x = 274
integer y = 1588
integer width = 91
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "HyperLink!"
long textcolor = 134217856
string text = "X1"
boolean focusrectangle = false
end type

type shl_1 from statichyperlink within w_main
integer x = 69
integer y = 1468
integer width = 101
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "HyperLink!"
long textcolor = 134217856
string text = "Y1"
boolean focusrectangle = false
end type

type em_y1 from editmask within w_main
integer x = 169
integer y = 1452
integer width = 197
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "45"
borderstyle borderstyle = stylelowered!
string mask = "###"
boolean spin = true
double increment = 1
end type

type em_x1 from editmask within w_main
integer x = 375
integer y = 1560
integer width = 197
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "228"
borderstyle borderstyle = stylelowered!
string mask = "###"
boolean spin = true
double increment = 1
end type

type cb_3 from commandbutton within w_main
integer x = 1934
integer y = 728
integer width = 174
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "..."
end type

event clicked;integer li_rtn
string ls_path, ls_ruta
string  ls_current

ls_ruta=gs_dir
ls_current=GetCurrentDirectory ( )
li_rtn = GetFileOpenName("Archivo a cargar", sle_imagen.text, ls_path, "jpg", "Jpg Files (*.jpg), *.jpg", ls_ruta)
ChangeDirectory ( ls_current )

p_1.PictureName =  sle_imagen.text


end event

type st_6 from statictext within w_main
integer x = 64
integer y = 748
integer width = 279
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "Imagen:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_imagen from singlelineedit within w_main
integer x = 361
integer y = 728
integer width = 1563
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
borderstyle borderstyle = stylelowered!
end type

type p_1 from picture within w_main
integer x = 375
integer y = 968
integer width = 1358
integer height = 576
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_info from statictext within w_main
integer x = 1033
integer y = 1888
integer width = 1289
integer height = 52
integer textsize = -7
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 553648127
string text = "Copyright © Ramón San Félix Ramón  rsrsystem.soft@gmail.com"
boolean focusrectangle = false
end type

type sle_clave from singlelineedit within w_main
integer x = 361
integer y = 616
integer width = 1563
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean password = true
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_main
integer x = 64
integer y = 636
integer width = 279
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "Calve:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_myversion from statictext within w_main
integer x = 1810
integer y = 56
integer width = 489
integer height = 84
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 33521664
string text = "Versión"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_platform from statictext within w_main
integer x = 1810
integer y = 144
integer width = 489
integer height = 84
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 33521664
string text = "Bits"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_sign from commandbutton within w_main
integer x = 1765
integer y = 1440
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Firmar PDF"
end type

event clicked;if trim(sle_archivo.text)="" then return

String ls_file, ls_firma, ls_clave, ls_imagen, ls_nombre, ls_dni
boolean lb_result, lb_visible
Integer li_x1, li_x2, li_y1, li_y2

ls_file=sle_archivo.text
ls_firma=sle_firma.text
ls_clave=sle_clave.text
ls_imagen = sle_imagen.text
li_x1 = integer(em_x1.text)
li_y1 =  integer(em_y1.text)
li_x2 = integer(em_x2.text)
li_y2 =  integer(em_y2.text)
ls_nombre=sle_nombreyapellidos.text
ls_dni=sle_dni.text

lb_visible=cbx_visible.checked
 
//Para firmar Usando la app de Consola TestNetPdfService.exe 
lb_result =  in_pdf.of_firmar_app(ls_file, ls_firma, ls_clave, ls_imagen, li_x1, li_y1, li_x2, li_y2, ls_nombre, ls_dni, lb_visible)

//Para firmar usando la libreria NetPdfService.dll importada en nvo_pdfservice
//lb_result =  in_pdf.of_firmar_net(ls_file, ls_firma, ls_clave, ls_imagen, li_x1, li_y1, li_x2, li_y2, ls_nombre, ls_dni, lb_visible)
	
if lb_result=true then
	Messagebox("Exito","Archivos PDF Firmado")
end if	
end event

type sle_archivo from singlelineedit within w_main
integer x = 361
integer y = 372
integer width = 1563
integer height = 92
integer taborder = 10
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_main
integer x = 64
integer y = 384
integer width = 279
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "Pdf:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_main
integer x = 1934
integer y = 372
integer width = 174
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "..."
end type

event clicked;integer li_rtn
string ls_path, ls_ruta
string  ls_current

ls_ruta=gs_dir
ls_current=GetCurrentDirectory ( )
li_rtn = GetFileOpenName("Archivo a cargar", sle_archivo.text, ls_path, "pdf", "Pdf Files (*.pdf), *.pdf", ls_ruta)
ChangeDirectory ( ls_current )



end event

type cb_1 from commandbutton within w_main
integer x = 1934
integer y = 500
integer width = 174
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "..."
end type

event clicked;integer li_rtn
string ls_path, ls_ruta
string  ls_current

ls_ruta=gs_dir
ls_current=GetCurrentDirectory ( )
li_rtn = GetFileOpenName("Archivo a cargar", sle_firma.text, ls_path, "pfx", "Firma Digital (*.pfx), *.Pfx", ls_ruta)
ChangeDirectory ( ls_current )



end event

type st_1 from statictext within w_main
integer x = 64
integer y = 512
integer width = 279
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "Firma (PFX):"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_firma from singlelineedit within w_main
integer x = 361
integer y = 500
integer width = 1563
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type r_2 from rectangle within w_main
long linecolor = 33554432
linestyle linestyle = transparent!
integer linethickness = 4
long fillcolor = 33521664
integer width = 2331
integer height = 260
end type

