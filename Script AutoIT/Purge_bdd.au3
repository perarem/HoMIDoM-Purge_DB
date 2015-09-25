#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icone_script.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.13.19 (Beta)
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#include <ButtonConstants.au3>
#include <DateTimeConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <FontConstants.au3>
#include "Includes\GUIScrollbars_Ex.au3"
#include "Includes\_XMLDomWrapper.au3"
#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <Date.au3>

TraySetIcon ( "icone_script.ico" )
Local $aResult, $iRows, $iColumns, $iRval
Local $Backup = false

#cs
#Region ### START Koda GUI section ### Form=C:\HoMIDoM\Scripts\Purge-bdd_avert.kxf
$Form1 = GUICreate("", 326, 254, 302, 218)
GUISetIcon("C:\HoMIDoM\Scripts\icone.ico", -1)
$GroupBox1 = GUICtrlCreateGroup("", 8, 8, 305, 185)
$Edit1 = GUICtrlCreateEdit("Cet outil n'a pas été mis au point par les développeurs d'HoMIDoM mais par un simple utilisateur.Son utilisation, bien qu'ayant subit de nombreux test, ne peut être garantie."&@CRLF&@CRLF&"Il est donc fortement recommandé de sauvegarder la base de données d'HoMIDoM avant d'utiliser cet outil.", 24, 64, 276, 113,BitOR($ES_WANTRETURN,$ES_READONLY,$ES_AUTOVSCROLL,$WS_VSCROLL))
GUICtrlSetFont(-1, 10, 800, 0, "Calibri")
GUICtrlCreateLabel("AVERTISSEMENT :", 24, 24, 277, 25, $SS_CENTER)
GUICtrlSetFont(-1, 16, 800, 0, "Calibri")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Button1 = GUICtrlCreateButton("&OK", 124, 208, 75, 25, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $Button1
			ExitLoop

	EndSwitch
WEnd
#ce


$Form2 = GUICreate("", 540, 420);,-1,-1, BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU,$ES_AUTOVSCROLL,$WS_VSCROLL))
$Icon1 = GUICtrlCreateIcon("icone.ico", -1, 24, 24, 48, 48)
$Label1 = GUICtrlCreateLabel("Base de donnée HoMIDoM", 100, 32, 360, 45)
GUICtrlSetFont(-1, 24, 800, 0, "Calibri")
$Date = _NowDate()
$Datearray = StringSplit($date,"/")
$Date = $Datearray[3]&"/"&$Datearray[2]&"/"&$Datearray[1]&" 00:00:00"
$Date1 = GUICtrlCreateDate(_DateAdd ( "Y", "-1", $Date ), 260, 96, 200, 23, BitOR ($DTS_SHORTDATEFORMAT, $DTS_RIGHTALIGN))
;GUICtrlSetFont(-1, 10, 400, 0, "Calibri")
$Label2 = GUICtrlCreateLabel("Supprimer les données antérieures au :", 50, 100, 200, 19)
;GUICtrlSetFont(-1, 10, 400, 0, "Calibri")
$Button1 = GUICtrlCreateButton("Go", 470, 95, 50, 25)
;GUICtrlSetFont(-1, 10, 400, 0, "Calibri")
$Button2 = GUICtrlCreateButton("Quitter", 470, 380, 50, 25)
;GUICtrlSetFont(-1, 10, 400, 0, "Calibri")
;$Group1 = GUICtrlCreateGroup("Composant : ", 20, 130, 500, 240, BitOR($ES_AUTOVSCROLL,$WS_VSCROLL))
;GUICtrlSetFont(-1, 10, 400, 0, "Calibri")
;$hAperture = GUICreate("Composant : ", 20, 130, 500, 240, $WS_POPUP, $WS_EX_MDICHILD, $Form2)
GUISetState(@SW_SHOW)
$hAperture = GUICreate("", 500, 220, 20, 140, $WS_POPUP, $WS_EX_MDICHILD, $Form2)
$Label3 = GUICtrlCreateLabel("Sélectionner tout", 350, 10, 97, 19)
;GUICtrlSetFont(-1, 10, 400, 0, "Calibri")
$Checkbox1 = GUICtrlCreateCheckbox("Checkbox1", 470, 10, 17, 17)

;#cs
If @OSArch = "X86" Then
	Local $HoMIDoM_Tmp = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\HoMIDoM","InstallDir")
Else
	Local $HoMIDoM_Tmp = RegRead("HKEY_LOCAL_MACHINE64\SOFTWARE\HoMIDoM","InstallDir")
EndIf
Global Const $HoMIDoM = $HoMIDoM_Tmp
;Global Const $HoMIDoM = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\HoMIDoM","InstallDir")
Local $XmlConfFile = $HoMIDoM&"\Config\HoMIDoM.xml"
Local $XMLTmpFile = _XMLFileOpen($XmlConfFile)
If $XMLTmpFile = -1 Then
	MsgBox(0,"Erreur","HoMIDoM.xml n'a pas été trouvé")
	Exit(1)
EndIf

$nodecount=_XMLGetNodeCount("/homidom/devices/device")
If $nodecount = -1 Then
	$nodecount = $nodecount + 1
EndIf
;#ce

SplashTextOn("","Ouverture de la base de données HoMIDoM",300,80,-1,-1,0,"Calibri","14",$FW_BOLD)
_SQLite_Startup()
If @error Then
	MsgBox($MB_SYSTEMMODAL, "SQLite Error", "SQLite.dll Can't be Loaded!")
	Exit -1
EndIf
_SQLite_Open($HoMIDoM&"\bdd\homidom.db")
If @error Then
	MsgBox($MB_SYSTEMMODAL, "SQLite Error", "Can't Load Database!")
	Exit -1
EndIf
;SplashTextOn("","Lecture de la base de données HoMIDoM",300,80,-1,-1,0,"Calibri","14",$FW_BOLD)
;$iRval = _SQLite_GetTable(-1, "SELECT DISTINCT device_id FROM historiques LIMIT 100;", $aResult, $iRows, $iColumns)
;$nodecount = $aResult[0]-2
SplashOff()

If $nodecount <> -1 Then
	Dim $Input_dev[$nodecount],$Input_id[$nodecount],$Checkbox[$nodecount]

	For $i = 1 To $nodecount
	;	ConsoleWrite($i&@CRLF)
		$Id_Device = _XMLGetAttrib("/homidom/devices/device["&$i&"]","id")
	;	$Id_Device = $aResult[$i+1]
		$Name_Device = _XMLGetAttrib("/homidom/devices/device["&$i&"]","name")
	;	$Name_Device = "-"
		$Input_dev[$i-1] = GUICtrlCreateInput($Name_Device, 10, 10+$i*30, 220, 23, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
	;	GUICtrlSetFont(-1, 10, 400, 0, "Calibri")
		$Input_id[$i-1] = GUICtrlCreateInput($Id_Device, 240, 10+$i*30, 220, 23, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
	;	GUICtrlSetFont(-1, 10, 400, 0, "Calibri")
		$Checkbox[$i-1] = GUICtrlCreateCheckbox("Checkbox"&$i, 470, 12+$i*30, 17, 17)
	Next

	;GUICtrlCreateGroup("", -99, -99, 1, 1)
	_GUIScrollbars_Generate($hAperture, 480, 20+$nodecount*30)
	GUISetState(@SW_SHOW)

	MsgBox(64,"INFORMATION","!!! ATTENTION !!!"&@CRLF&"Veuillez arreter le service Homidom AVANT d'utiliser cet utilitaire !...")
	MsgBox(16,"ATTENTION","!!! ATTENTION !!!"&@CRLF&"Cet utilitaire est encore en phase de test."&@CRLF&@CRLF&"Par mesure de sécurité, effectuez une sauvegarde de la base de donnée AVANT d'utiliser cet utilitaire !...")
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $Button2
				ExitLoop
			Case $Checkbox1
				If GUICtrlRead($Checkbox1)=1 Then
				For $i = 1 to $nodecount
					GUICtrlSetState($Checkbox[$i-1],$GUI_CHECKED )
				Next
				Else
				For $i = 1 to $nodecount
					GUICtrlSetState($Checkbox[$i-1],$GUI_UNCHECKED )
				Next
				EndIf
			Case $Button1
				$Date = GUICtrlRead($Date1)
				$Datearray = StringSplit($date,"/")
				$Date = $Datearray[3]&"-"&$Datearray[2]&"-"&$Datearray[1]&" 00:00:00"
				If $Backup = false Then
					SplashTextOn("","Sauvegarde de la base de données HoMIDoM.",300,120,-1,-1,0,"Calibri","14",$FW_BOLD)
					$Backup = True
					FileCopy($HoMIDoM&"\bdd\homidom.db",$HoMIDoM&"\bdd\homidom.bak",1)
					SplashOff()
				EndIf

				If GUICtrlRead($Checkbox1)=1 Then
					SplashTextOn("","Suppression des données historiques HoMIDoM antérieures à "&$Date,300,120,-1,-1,0,"Calibri","14",$FW_BOLD)
					$iRval = _SQLite_Exec(-1, "DELETE FROM  `historiques` WHERE `dateheure`<'"&$Date&"';")
					If $iRval <> $SQLITE_OK Then
						MsgBox($MB_SYSTEMMODAL, "SQLite Error: " & $iRval, _SQLite_ErrMsg())
					EndIf
					SplashOff()
				Else
					For $i = 1 to $nodecount
						If GUICtrlRead($Checkbox[$i-1]) = 1 Then
							SplashTextOn("","Suppression des données historiques du composant """&GUICtrlRead($Input_id[$i-1])&""" HoMIDoM antérieures à "&$Date,400,120,-1,-1,0,"Calibri","14",$FW_BOLD)
							$iRval = _SQLite_Exec(-1, "DELETE FROM `historiques` WHERE `dateheure`<'"&$Date&"' AND  device_id  LIKE '"&GUICtrlRead($Input_id[$i-1])&"';");, $aResult, $iRows, $iColumns)
							If $iRval <> $SQLITE_OK Then
								MsgBox($MB_SYSTEMMODAL, "SQLite Error: " & $iRval, _SQLite_ErrMsg())
							EndIf
							SplashOff()
						EndIf
					Next
				EndIf
				GUICtrlSetState($Checkbox1,$GUI_UNCHECKED)
				For $i = 1 to $nodecount
					GUICtrlSetState($Checkbox[$i-1],$GUI_UNCHECKED )
				Next
		EndSwitch
	WEnd
	SplashTextOn("","Fermeture de la base de données HoMIDoM",300,80,-1,-1,0,"Calibri","14",$FW_BOLD)
	$iRval = _SQLite_Exec(-1, "REINDEX;")
	$iRval = _SQLite_Exec(-1, "VACUUM;")
Else
	MsgBox(0,"","La base de données HoMIDoM est vide !"&@CRLF&@CRLF&"=> Fin du programme.")
EndIf
SplashTextOn("","Fermeture de la base de données HoMIDoM",300,80,-1,-1,0,"Calibri","14",$FW_BOLD)
_SQLite_Close()
_SQLite_Shutdown()
Sleep(500)
SplashOff()
