#Requires AutoHotkey v2.0-
#SingleInstance Ignore
#Include "%A_ScriptDir%\AHK\LoadScale.ahk"


lowBass := 0
hiBass := 0
lowAcc := 0
hiAcc := 0
lowMel := 0
hiMel := 0
lowCmel := 0
hiCmel := 0
low3mel := 0
hi3mel := 0




; 				VARIABLE DECLARATIONS
; booleans
freeToContinue := False
openFile := False
editStatus := False
unsavedChangesBool := False

; integers
columNo := 1
chanNo := 0
keyCount := 0
totalKeyIndex := 0
mapperExportInc := 1
saveOrLoad := 0			; 1 is loading (*.itm, type CSV), 2 is saving (*.itm, type CSV), 3 is import (*.ins, type INI), 4 is export (*.map, type INI)
selectedRow := 0
oldKeyVal := 0
newKeyVal := 0

; maps and arrays
scaleMap := Map()
patchNamesSectionArray := Array()
curRowNoteNameArray := Array()
curRowChangeArray := Array()
curRowDivArray := Array()
curRowChanArray := Array()
curRowPatchArray := Array()
settings := Array()

; strings
currentFileName := ""
fileToUse := ""
mapMakerTitle := "InsToMap"
mapMakerGui := ""
scaleName := ""
scaleToImport := ""
saveFileString := ""
userRootDir := ""		; root directory of the user, used for selecting files
changesMade := ""

; column strings
col1String := ""


onStart()
{
	loadSettings()
	loadPatchNames()
	createGui()
}

; load the program settings
loadSettings()
{
	
}

loadPatchNames()
{
	patchNamesSectionArray := StrSplit(IniRead("A_WorkingDir\Dependencies\Midi Instruments.ini"), "`n")
}

; Create GUI
createGui()
{
	mapMakerGui := Gui("+Resize", mapMakerTitle)		; main window GUI

	; Create submenus
	; File menu
	fileMenu := Menu()
	fileMenu.Add("&New", menuFileNew)			; create a new file
	fileMenu.Add("&Open", menuFileOpen)			; open a working copy of an unexported mapper
	fileMenu.Add("&Save", menuFileSave)			; save a working copy of the unexported mapper
	fileMenu.Add("Save &As", menuFileSaveAs)		; save a working copy as the specified filename
	fileMenu.Add()									; blank line
	fileMenu.Add("&Import", menuFileImport)		; import an INS file
	fileMenu.Add("&Export", menuFileExport)		; export as MAP file
	fileMenu.Add()									; blank line
	fileMenu.Add("E&xit", menuFileExit)			; exit the program

	; Edit menu
	editMenu := Menu()
	editMenu.Add("&Edit Scale", menuEditEditScale)							; Edit the scale, toggle switch with visible checkmark in the menu
	editMenu.Add("Assign &Patches", menuEditAssignPatches)					; assign patches and values
	editMenu.Add("Assign &Divisions", menuEditAssignDivisions)				; assign divisions and their note counts

	; Help menu
	helpMenu := Menu()
	helpMenu.Add("&About InsToMap", menuHelpAbout)			; About the program
	helpMenu.Add("&Help Files", menuHelpHelp)				; displays the help files

	; create the main menu bar and add the buttons
	mainMenuBar := MenuBar()
	mainMenuBar.Add("&File", fileMenu)			; main file menu
	mainMenuBar.Add("&Edit", editMenu)			; main edit menu
	mainMenuBar.Add("&Help", helpMenu)			; main help menu

	; attach the main menu bar to the window
	mapMakerGui.MenuBar := mainMenuBar()
	
	; create a table to show the scale
	scaleTable := mapMakerGui.Add("ListView", "r20 w700 Checked NoSortHdr VScroll HScroll", "Key", "Note Name", "Change to", "Division", "Channel", "Standard patch")
	
	; edit the values of the current key
	editGroupBox := mapMakerGui.Add("GroupBox", "r6 w550 y+25", "Edit values")

	; key selector, col 1
	editKeyName := mapMakerGui.Add("Text", "xp+5 yp+5", "Key: ")
	editKeyVal := mapMakerGui.Add("Edit", "r1 vKeyValEdit x+10 Disabled")
	editKeyBud := mapMakerGui.Add("UpDown", "vKeyValUpDown Range0-127 Section Disabled", 0)

	; edit note name, col 2
	editNoteNameName := mapMakerGui.Add("Text", "xs", "Note Name: ")
	editNoteNameVal := mapMakerGui.Add("Edit", "r1 vNoteNameValEdit Limit30 x+10 Section Disabled", curRowNoteNameArray[(editKeyVal + 1)])

	; edit change to, col 3
	editChangeName := mapMakerGui.Add("Text", "xs", "Change to: ")
	editChangeVal := mapMakerGui.Add("Edit", "r1 vChangeValEdit x+10 Disabled", curRowChangeArray[(editKeyVal + 1)])
	editChangeBud := mapMakerGui.Add("UpDown", "vChangeValUpDown Range0-127 Section Disabled")

	; edit note division, col 4
	editDivName := mapMakerGui.Add("Text", "xs", "Division: ")
	editDivVal := mapMakerGui.Add("DropDownList", "Choose" . curRowDivArray[(editKeyVal + 1)] . " vDivValEdit x+10 Section Disabled", ["Bass", "Accompaniment", "Melody", "Counter Melody", "Third melody", "Register", "Percussion", "Spare", "Undefined"])

	; edit note channel, col 5
	editChanName := mapMakerGui.Add("Text", "xs", "Channel: ")
	editChanVal := mapMakerGui.Add("Edit", "r1 vChanValEdit x+10 Disabled", curRowChanArray[(editKeyVal + 1)])
	editChanBud := mapMakerGui.Add("UpDown", "vChanValUpDown Range0-15 Section Disabled")

	; edit patch, col 6
	editPatchName := mapMakerGui.Add("Text", "xs", "Patch: ")
	editPatchVal := mapMakerGui.Add("Edit", "r1 vPatchValEdit x+10", curRowPatchArray[(editKeyVal + 1)])
	editPatchBud := mapMakerGui.Add("UpDown", "vPatchValUpDown Range0-127 Section Disabled")

	; show patch name underneath
	bottomStatusBar := mapMakerGui.Add("StatusBar",, "Welcome to InsToMap")
}



; Enable drop-file events
mapMakerGui.OnEvent("DropFiles", gui_DropFiles)






; store current row values
editKeyValue.OnEvent("Change", changeCurRowVals(editKeyVal.Value))

editPatchVal.OnEvent("Change", changeStatusBarPatch(editChanVal.Value, editPatchVal.Value)

changeStatusBarPatch(channel, patch)
{
	if channel = 10
	{
		bottomStatusBar.SetText(patch . " - " . IniRead("A_WorkingDir\Dependencies\Midi Instruments.ini", patchNamesSectionArray[2], patch)
	}
	else
	{
		bottomStatusBar.SetText(patch . " - " . IniRead("A_WorkingDir\Dependencies\Midi Instruments.ini", patchNamesSectionArray[1], patch)
	}
}


changeCurRowVals(selectedRow)
{
	newKeyVal := editKeyVal.Value
	
	storeOldRowVals(oldKeyVal)
	retrieveNewRowVals(newKeyVal)
	
	global curRowNoteName := 
	global curRowChange :=
	global curRowDiv :=
	global curRowChan :=
	global curRowPatch :=
	
	
}

storeOldRowVals(keyVal)
{
	scaleTable.Modify((keyVal + 1), "Col2", editNoteNameVal.Value, editChangeVal.Value, editDivVal.Value, editChanVal.Value, editPatchVal.Value)
}

retrieveNewRowVals(keyVal)
{
	editNoteNameVal := scaleTable.GetText((keyVal + 1), 2)
	editChangeVal := scaleTable.GetText((keyVal + 1), 3)
	editDivVal := scaleTable.GetText((keyVal + 1), 4)
	editChanVal := scaleTable.GetText((keyVal + 1), 5)
	editPatchVal := scaleTable.GetText((keyVal + 1), 6)
}




; change events to check for modified files
editNoteNameVal.OnEvent("Change", unsavedChangesMade())
editChangeVal.OnEvent("Change", unsavedChangesMade())
editDivVal.OnEvent("Change", unsavedChangesMade())
editChanVal.OnEvent("Change", unsavedChangesMade())
editPatchVal.OnEvent("Change", unsavedChangesMade())


unsavedChangesMade()
{
	if !unsavedChangesBool
	{
		unsavedChangesBool := True
		mapMakerTitle := "* " . mapMakerTitle
	}
}



; set the window title after saving
setWindowTitle(scaleName)
{
	mapMakerTitle := "InsToMap - " . scaleName
	unsavedChangesBool := False
}


; create the unsaved changes box
unsavedChangesBox := Gui("+Owner +ToolWindow", "Unsaved Changes")		; Unsaved changes GUI box

unSaveChBoxSave := unsavedChangesBox.Add("Button", "Default w80", "&Save")		; save
unSaveChBoxSave.OnEvent("Click", menuFileSaveAs)

unSaveChBoxNoSave := unsavedChangesBox.Add("Button", "w80", "&Don't save")		; don't save
unSaveChBoxNoSave.OnEvent("Click", noSaveUnsavedChanges)

unSaveChBoxCancel := unsavedChangesBox.Add("Button", "w80", "&Cancel")			; cancel
unSaveChBoxCancel.OnEvent("Click", cancelUnsaveCh)

; unsaved changes functions

unsavedChanges(*)		
{
	unsavedChangesBox.Show()
}

saveUnsavedChanges()
{
	
}

noSaveUnsavedChanges()
{
	global freeToContinue := True
	unsavedChangesBox.Destroy()
}

cancelUnsaveCh()
{
	global freeToContinue := False
	unsavedChangesBox.Destroy()
}

;blankSlate()				; start the program with a blank file
mapMakerGui.Show()		; display the window



; MENU FUNCTIONS
; File
{
; creates a new file
menuFileNew(*)
{
	if unsavedChangesBool
	{
		unsavedChanges()
	}
	
	if freeToContinue
	{
		mapMakerTitle := "InsToMap - New File"
		unsavedChangesBool := False
		setEditStatusFalse()
		scaleTable.Delete()
		scaleTable.Show()
	}
}

; open an existing itm file
menuFileOpen(*)
{
	mapMakerGui.Opt("+OwnDialogs")			; force the user to dismiss the FileSelect dialog before returning to the main window
	
	if unsavedChangesBool
	{
		unsavedChanges()
	}
	
	if freeToContinue
	{
		saveOrLoad := 1
		try
		{
			selectedFileName := pickFileName(saveOrLoad)
		}
		
		catch Error as err
		{
			MsgBox err, "Error"
			Exit
		}
		
		if selectedFileName = ""	; no file was selected
			return
		global currentFileName := readContent(selectedFileName)
		
		setEditStatusFalse()
		setWindowTitle(currentFileName)
	}
}

; save an itm file
menuFileSave(*)
{
	if currentFileName = ""
	{
		saveOrLoad := 2					; 2 = save itm
		try
		{
			currentFileName := pickFileName(saveOrLoad)			; if no filename has been entererd (new file), pick filename
		}
		
		catch Error as err
		{
			MsgBox err, "Error"
			Exit
		}
	}
	saveContent(currentFileName)
	global mapMakerTitle := "insToMap - " . currentFileName
	unsavedChangesBool := False
}

; save itm file as
menuFileSaveAs(*)
{
	mapMakerGui.Opt("+OwnDialogs")			; force the user to dismiss the FileSelect dialog before returning to the main window
	saveOrLoad := 2				; 2 = save itm
	try
		{
			selectedFileName := pickFileName(saveOrLoad)
		}
		
		catch Error as err
		{
			MsgBox err, "Error"
			Exit
		}
	if selectedFileName = "" 	; No file selected
		return
	global currentFileName := saveContent(selectedFileName)
	global mapMakerTitle := "InsToMap - " . currentFileName
	unsavedChangesBool := False
}

; import a new INS file to convert to Mapper
menuFileImport(*)
{
	if unsavedChangesBool
	{
		unsavedChanges()
	}
	
	if freeToContinue
	{
		scaleToImportFilenameNoPath := ""
		scaleToImport := actualImport()
		scaleSplitter(scaleToImport)
		setEditStatusFalse()
		SplitPath scaleToImport, &scaleToImportFilenameNoPath
		bottomStatusBar := scaleToImportFilenameNoPath . " was succesfully imported!"
	}
}

; export mapper
menuFileExport(*)
{
	;generateMapper(scaleMap)
}

; exit the application
menuFileExit(*)
{
	if unsavedChangesBool
	{
		unsavedChanges()
	}
	
	if freeToContinue
	{
		WinClose()
	}
}

}




; Edit
{
; edit the scale
menuEditEditScale()
{
	if !editStatus
	{
		setEditStatusTrue()
	}
	else
	{
		setEditStatusFalse()
	}
}

; assign patches to channels/notes
menuEditAssignPatches()
{
	showPatchesWindow()
}



menuEditAssignDivisions()
}


menuHelpAbout()
menuHelpHelp()





;				Actual functions

/*
; Generate a mapper based on the entered inputs
generateMapper(scaleToConvert)
{
	global finalMapper := ""
	Loop			; loop through the columns
	{
		while columNo < 9
		{
			Loop				; loop through the channels
			{
				while chanNo < 16
				{
					Loop			; loop through the indexes
					{
						
					}
					Until mapperExportInc = 130
					chanNo++
				}
			}
			Until chanNo = 16
		
			chanNo := 0
			columNo++
		}
	}
	Until columNo = 9
}
*/

; handles drop-file events in the GUI
gui_DropFiles()
{

}


; check the save state to determine what file selection to offer
pickFileName(saveState)
{
	Switch saveState
	{
		Case 1:				; load itm
			selectedFileName := FileSelect(3, userRootDir, "Open file", "InsToMap project files (*.itm)")
			return selectedFileName
		
		Case 2:				; save itm
			selectedFileName := FileSelect("S16", userRootDir, "Save file", "InsToMap project files (*.itm)")
			return selectedFileName
		
		Case 3:				; import ins
			selectedFileName := FileSelect(3, userRootDir, "Import INS", "Cakewalk Instrument Layouts (*.ins)")
			return selectedFileName
			
		Case 4:				; export map
			selectedFileName := FileSelect("S16", userRootDir, "Export mapper", "Mapper (*.map)")
			return selectedFileName
			
		Default:
			throw saveError := Error("An error has occurred. Please try again.")
	}
}


; read content from a loaded file
/*
readContent(fileName)
{
	try
		fileContent := FileRead(fileName)		; read the file's contents into the variable
	catch
	{
		MsgBox("Opening " . fileName " was unsuccessful.")
		return
	}
	loadContent()				; load the file's contents into the table
	fileMenu.Enable("3&")		; re-enable &Save
	mapMakerTitle := "InsToMap - " . fileName
	return fileName
}
*/




; save
saveContent(fileName)
{
	try
	{
		if FileExist(fileName)
			FileDelete(fileName)
			
		fileAppend saveFileString, fileName
	}
	catch
	{
		MsgBox("Saving to " . fileName . " was unsuccessful.")
		return
	}
}

createMapSave(fileName)
{
	totalRows := scaleTable.GetCount()
	totalColumns := scaleTable.GetCount("Col")
	rowNo := 0
	Loop totalRows
	{
		columNo := 1
		Loop totalColumns
		{
			textToAdd := scaleTable.GetText(rowNo, columNo)				; retrieves the text to be added from the table
			
			if columNo = totalColumns
			{
				saveFileString := saveFileString . "`"" . textToAdd . "`"`n", fileName 					; last column inserts a linefeed character at the end instead of a comma
			}
			else
			{
				saveFileString := saveFileString . "`"" . textToAdd . "`",", fileName						; not the last column, so just a comma at the end 												
				columNo++
			}
		}
		rowNo++
	}
	return saveFileString
	
}




; Opening/Importing functions

; Opening


; Importing

; actually imports INS
actualImport(*)
{
	mapMakerGui.Opt("+OwnDialogs")		; Force the user to dismiss FileSelect before returning to the main window
	
	saveOrLoad := 3		; ins import
	try
		{
			scaleToImport := pickFileName(saveOrLoad)
		}
		
		catch Error as err
		{
			MsgBox err, "Error"
			Exit
		}
	if scaleToImport = "" 		; no file has been selected
	{
		return
	}
	else
	{
		if MsgBox(scaleToImport . " will be imported. Continue?", "Import?", 4) = "No"
			MsgBox("Import cancelled")
		else
		{
			return scaleToImport
		}
	}
}

; splits the scale to a map
scaleSplitter(scaleToSplit)
{
	global scaleName := IniRead(scaleToSplit)
	keyCount := 0
	while keyCount < 128
	{
		keyName := IniRead(scaleToSplit, scaleName, keyCount, "ERROR")
		if (keyName = "ERROR")
		{
			keyCount--			; make sure keyCount equals the highest numbered key in the scale, including 0
			break
		}
		else
		{
			scaleMap[keyCount] := keyName
			keyCount++
		}
	}
	
	rowNo := 1		; rowNo = keyCount + 1
	while rowNo <= (keyCount + 1)
	{
		if (scaleMap[(rowNo - 1)] = "X")
		{
			editDivVal.Choose(0)
			spareKeyImportedDiv := editDivVal.Choose(8)
			spareKeyImportedNoteName := "Spare"
			scaleTable.Add(, (keyCount - 1), spareKeyImportedNoteName, "-1", spareKeyImportedDiv, "1", "-1")			; add pre-set spare to scale table
			curRowDivArray.Push(8)			; add as spare to curRowDivArray
		}
		else
		{
			scaleTable.Add(, (keyCount - 1), scaleMap[(keyCount - 1)], "", "", "", "")				; add as key with no other values to scale table
			curRowDivArray.Push(9)			; add as unspecified to curRowDivArray
		}
		rowNo++
	}
	
	global totalKeyIndex := rowNo
	
	MsgBox "Import of " scaleName . " was succesful. " . rowNo . " keys were read", "Import successful", 1
}

setEditStatusFalse()
{
	editMenu.Uncheck("1&")				; remove check mark from the "edit scale" row in the Edit meny
	editStatus := False
	
	; re-disable all the edit options in the group box
	editKeyVal.Opt("+Disabled")
	editKeyBud.Opt("+Disabled")
	
	editNoteNameVal.Opt("+Disabled")
	
	editChangeVal.Opt("+Disabled")
	editChangeBud.Opt("+Disabled")
	
	editDivVal.Opt("+Disabled")
	
	editChanVal.Opt("+Disabled")
	editChanBud.Opt("+Disabled")
	
	editPatchVal.Opt("+Disabled")
	editPatchBud.Opt("+Disabled")
}

setEditStatusTrue()
{
	editMenu.Check("1&")					; add a check mark to the "edit scale" row in the Edit menu
	editStatus := True
	unsavedChangesBool := True			; unsaved changes made
	
	; un-disable all the edit options in the group box
	editKeyVal.Opt("-Disabled")
	editKeyBud.Opt("-Disabled")
	
	editNoteNameVal.Opt("-Disabled")
	
	editChangeVal.Opt("-Disabled")
	editChangeBud.Opt("-Disabled")
	
	editDivVal.Opt("-Disabled")
	
	editChanVal.Opt("-Disabled")
	editChanBud.Opt("-Disabled")
	
	editPatchVal.Opt("-Disabled")
	editPatchBud.Opt("-Disabled")
}




/* DEPRECATED
scaleSplitter(scaleToSplit)
{
	Loop read scaleToSplit
	{
		keyCount := A_Index - 2 			; first key (0) on line 2, where A_Index equals 2
		Loop parse A_LoopReadLine, "="
		{
			scaleMap[keyCount] := A_LoopField
		}
	}
	
	for tempKey, tempVal in scaleMap
	{
		if (tempKey < 0)
		{	
			continue
		}
		scaleTable.Add(, tempKey, tempVal, "")
	}
	
	global scaleName := SubStr(scaleMap[-1], 2, -1)		; Sets the Scale Name to be the INS header, without the []
	MsgBox scaleMap[-1]
}



; construct the columns
columnConstructor(*)
{
	col1Constructor()
}

; construct column one, store in the string col1String
col1Constructor(*)
{
	global chanNo := 0
	global mapperExportInc := -1
	while chanNo < 16 			; loop trough the channels, 0-15
	{
		if chanNo = 0
		{
			while mapperExportInc < 129
			{
				if mapperExportInc = -1
				{
					global col1String := col1String . "[Col 1, Chan" . chanNo . "]`n"
				}
				else
				{
					global col1String := col1String . mapperExportInc . "=" ; . VALUE OF MIDI NOTE OR WHATEVS
				}
				mapperExportInc++
			}
			mapperExportInc := -1
		}
		chanNo++
	}
}



*/


/*

	*** TODO ***

	O	Parse the scale into Key-Value pairs, discarding the header
	O	Split the Key and the Value into an array
	---	o	Display "X" as something else, eg. "Unused"
	
	O	Multi-select for divisions?
	O	Scale presets? i.e. 10 accomp, g-f# without g# and d#?
	
	O	Ask (MsgBox) if user wants to continue if already opened file


*/