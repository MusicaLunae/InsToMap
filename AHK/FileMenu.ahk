#Requires AutoHotkey v2.0-
#SingleInstance Ignore
; File menu functions


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
