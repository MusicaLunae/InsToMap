#Requires AutoHotkey v2.0-
#SingleInstance Ignore
#Include "%A_ScriptDir%\Core\VarDeclar.ahk"		; temporary: until settings are stored in INI files
#Include "%A_ScriptDir%\AHK\FileMenu.ahk"
#Include "%A_ScriptDir%\AHK\LoadScale.ahk"
#Include "%A_ScriptDir%\AHK\EventHandlers.ahk"
#Include "%A_ScriptDir%\AHK\GuiGeneration.ahk"

onStart()
{
	loadSettings()
	loadPatchNames()
	createMainGui()
}

; load the program settings
loadSettings()
{
	
}

loadPatchNames()
{
	patchNamesSectionArray := StrSplit(IniRead("%A_WorkingDir%\Dependencies\Midi Instruments.ini"), "`n")
	fillPatchNamesMaps(patchNamesSectionArray)
}

fillPatchNamesMaps(patchSection)
{
	fillStandardMap(patchSection[1])
	fillDrumMap(patchSection[2])
}

fillStandardMap(patchSection[1])
{
	mapInc := 1	; incrementer for the map key
	iniInc := 0	; incrementer for the ini key
	patchNamesStandardArray.Push("-1 None")
	
	patchNamesStandardMap.Capacity := 128
	loop 128
	{
		patchNamesStandardMap[mapInc] := IniRead("%A_WorkingDir%\Dependencies\Midi Instruments.ini", sectionName, iniInc)
		patchNamesStandardArray.Push(iniInc . " " . IniRead("%A_WorkingDir%\Dependencies\Midi Instruments.ini", sectionName, iniInc))
		iniInc++
		mapInc++
	}
}

fillDrumMap(sectionName)
{
	mapInc := 1	; incrementer for the map key
	iniInc := 27	; incrementer for the ini key
	patchNamesDrumsArray.Push("-1 None")
	
	patchNamesDrumsMap.Capacity := 61
	loop 61
	{
		patchNamesDrumsMap[mapInc] := IniRead("%A_WorkingDir%\Dependencies\Midi Instruments.ini", sectionName, iniInc)
		patchNamesDrumsArray.Push(iniInc . " " . IniRead("%A_WorkingDir%\Dependencies\Midi Instruments.ini", sectionName, iniInc))
		iniInc++
		mapInc++
	}
}

patchNamesMapFiller(scale)
{
	IniRead("%A_WorkingDir%\Dependencies\Midi Instruments.ini", patchNamesSectionArray
}



; Enable drop-file events
mapMakerGui.OnEvent("DropFiles", gui_DropFiles)

changeStatusBarPatch(channel, patch)
{
	if channel = 10
	{
		bottomStatusBar.SetText(patch . " - " . IniRead("%A_WorkingDir%\Dependencies\Midi Instruments.ini", patchNamesSectionArray[2], patch)
	}
	else
	{
		bottomStatusBar.SetText(patch . " - " . IniRead("%A_WorkingDir%\Dependencies\Midi Instruments.ini", patchNamesSectionArray[1], patch)
	}
}



changeCurRowVals(selectedRow)
{
	newKeyVal := editKeyVal.Value
	
	storeOldRowVals(oldKeyVal)
	retrieveNewRowVals(newKeyVal)
	
	oldKeyVal := editKeyVal.Value
}

storeOldRowVals(keyVal)
{
	rowNo := keyVal + 1
	; delete the old entries
	noteNameArray.RemoveAt(rowNo)
	changeArray.RemoveAt(rowNo)
	divArray.RemoveAt(rowNo)
	chanArray.RemoveAt(rowNo)
	patchArray.RemoveAt(rowNo)
	
	; re-add the new entries to the same index
	noteNameArray.InsertAt(rowNo, editNoteNameVal.Value)
	changeArray.InsertAt(rowNo, editChangeVal.Value)
	divArray.InsertAt(rowNo, editDivVal.Value)
	chanArray.InsertAt(rowN), editChanVal.Value)
	patchArray.InsertAt(rowNo, editPatchVal.Value)
}

retrieveNewRowVals(keyVal)
{
	rowNo := keyVal + 1
	; pre-sets the fields in the group box to reflect the values as already stored in the arrays
	editNoteNameVal := noteNameArray[rowNo]
	editChangeVal := changeArray[rowNo]
	editDivVal := divArray[rowNo]
	editChanVal := chanArray[rowNo]
	editPatchVal := patchArray[rowNo]
}


/* old store/retrieve row vals
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

*/






unsavedChangesMade()
{
	if !unsavedChangesBool
	{
		mapMakerTitle := "* " . mapMakerTitle
		unsavedChangesBool := True
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


; Edit

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



menuEditAssignDivisions()


; create window to assign patches to channels/notes
menuEditAssignPatches()
{
	createPatchesWindow()
	showPatchesWindow()
}

; updates the To Assign-array
; patch 0 has index 2 in the standard array, so 2 is subtracted to insert the correct patch value
updateToAssignArray(toUpdate)
{
	Switch toUpdate
	{
		Case 1:		; bass
			toAssignArray.RemoveAt(toUpdate)
			toAssignArray.InsertAt(toUpdate, bassStandardVal.Value - 2)
		
		Case 2:		; accomp
			toAssignArray.RemoveAt(toUpdate)
			toAssignArray.InsertAt(toUpdate, accompStandardVal.Value - 2)
		
		Case 3:		; melody
			toAssignArray.RemoveAt(toUpdate)
			toAssignArray.InsertAt(toUpdate, melStandardVal.Value - 2)
		
		Case 4:		; counter melody
			toAssignArray.RemoveAt(toUpdate)
			toAssignArray.InsertAt(toUpdate, cMelStandardVal.Value - 2)
		
		Case 5:		; third melody
			toAssignArray.RemoveAt(toUpdate)
			toAssignArray.InsertAt(toUpdate, 3melStandardVal.Value - 2)
		
		Default:
			MsgBox "Default behaviour"
	}
}

; actually apply the patch assignments
applyPatchAssignments()
{
	unsavedChangesBool := True
	
	; add the patches to assign to an array
	; midi patch 0 is at array index 2, so subtract 2 to get the actual value to assign
	
	loop curRowDivArray.Length
	{
		Switch curRowDivArray[A_Index]
		{
			Case 1:		; bass
				curRowPatchArray.RemoveAt(A_Index)
				curRowPatchArray.InsertAt(A_Index, toAssignArray[1])			
			
			Case 2:		; accompaniment
				curRowPatchArray.RemoveAt(A_Index)
				curRowPatchArray.InsertAt(A_Index, toAssignArray[2])
			
			Case 3:		; melody
				curRowPatchArray.RemoveAt(A_Index)
				curRowPatchArray.InsertAt(A_Index, toAssignArray[3])
				
			Case 4:		; counter melody
				curRowPatchArray.RemoveAt(A_Index)
				curRowPatchArray.InsertAt(A_Index, toAssignArray[4])
			
			Case 5:		; third melody
				curRowPatchArray.RemoveAt(A_Index)
				curRowPatchArray.InsertAt(A_Index, toAssignArray[5])
			
			Case 7:		; percussion
				curRowPatchArray.RemoveAt(A_Index)
				curRowPatchArray.InsertAt(A_Index, -1)
			
			Case 8:		; spare
				curRowPatchArray.RemoveAt(A_Index)
				curRowPatchArray.InsertAt(A_Index, -1)
			
			Case 9:		; undefined
				curRowPatchArray.RemoveAt(A_Index)
				curRowPatchArray.InsertAt(A_Index, -1)
			
			Default:
				MsgBox "Default option"
		}
	}
}

cancelPatchAssignments()
{
	if MsgBox("Unapplied changes will be lost.", "Continue?", 1) = "OK"
	{	
		patchAssignerGui.Destroy()
	}
	else
	{
		return
	}
}

applyDivAssignment()
{
	unsavedChangesBool := True
	divAssignmentArrayCreation()
}

divAssignmentArrayCreation()
{
	bassDivArray.Push(bassNumBud.Value, bassStartVal.Value, bass
}



menuHelpAbout()
menuHelpHelp()


showPatchesWindow()
{
	mapMakerGui.Opt("+Disabled")
}


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
	scaleMap.Capacity := 128 ; the scale can contain at most 128 different key-value pairs, indexed from 1
	global scaleName := IniRead(scaleToSplit)
	keyCount := 0
	mapIndex := 1				; initially, mapIndex == keyCount + 1
	while keyCount < 128
	{
		keyName := IniRead(scaleToSplit, scaleName, keyCount, "ERROR")
		if (keyName = "ERROR")
		{
			totalKeys := keyCount			; total number of keys, indexed from 1
			scaleMap.Capacity := totalKeys		; set the max amount of key-value pairs to the amount of keys, indexed from 1
			break
		}
		else
		{
			scaleMap[mapIndex] := keyName
			keyCount++
			mapIndex++
		}
	}
	
	keyCount := 0
	mapIndex := 1		; initially, mapIndex == keyCount + 1
	
	while mapIndex <= totalKeys
	{
		if (scaleMap[mapIndex] = "X")
		{
			; pre-adds all the relevant spare values to the respective curRow arrays
			curRowKeyNumberArray.Push(keyCount)
			curRowNoteNameArray.Push("Spare")
			curRowChangeArray.Push(-1)
			curRowDivArray.Push(8)
			curRowChanArray.Push(1)
			curRowPatchArray.Push(-1)
		}
		else
		{
			curRowKeyNumberArray.Push(keyCount)
			curRowNoteNameArray.Push(scaleMap[mapIndex])
			curRowChangeArray.Push(0)
			curRowDivArray.Push(9)
			curRowChanArray.Push(1)
			curRowPatchArray.Push(-1)
		}
		mapIndex++
		keyCount++
	}
	
	MsgBox "Import of " . scaleName . " was succesful. " . totalKeys . " keys were read", "Import successful", 1
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