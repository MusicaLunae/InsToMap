#Requires AutoHotkey v2.0-
#SingleInstance Ignore

; Create the main GUI
createMainGui()
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
	editMenu.Add("Assign &Divisions", menuEditAssignDivisions)				; assign divisions and their note counts
	editMenu.Add("Assign &Patches", menuEditAssignPatches)					; assign patches and values

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
	editPatchBud := mapMakerGui.Add("UpDown", "vPatchValUpDown Range0-127 Disabled")
	editPatchTitle := mapMakerGui.Add("Text", "vPatchValTitle x+10 Section", 

	; show patch name underneath
	bottomStatusBar := mapMakerGui.Add("StatusBar",, "Welcome to InsToMap")
}


; Patches window
createPatchesWindow()
{
	patchAssignerGui := Gui("+AlwaysOnTop +OwnDialogs +Owner", "Assign patches to " . mapMakerTitle)
	
	standardPatchGroupBox := patchAssignerGui.Add("GroupBox", "r5 w450 y+10 vStandardPatches", "Standard patches")
	
	; set standard patches
	; bass, channel 3
	bassStandardName := patchAssignerGui.Add("Text", "xp+5 yp+5", "Standard bass patch: ")
	bassStandardVal := patchAssignerGui.Add("ComboBox", "r7 x+10 Section", patchNamesStandardArray)
	
	; accomp, channel 4
	accompStandardName := patchAssignerGui.Add("Text", "xs", "Standard accompaniment patch: ")
	accompStandardVal := patchAssignerGui.Add("ComboBox"), "r7 x+10 Section", patchNamesStandardArray)
	
	; melody, channel 5
	melStandardName := patchAssignerGui.Add("Text", "xs", "Standard melody patch: ")
	melStandardVal := patchAssignerGui.Add("ComboBox", "r7 x+10 Section", patchNamesStandardArray)
	
	; counter melody, channel 6
	cMelStandardName := patchAssignerGui.Add("Text", "xs", "Standard counter melody patch: ")
	cMelStandardVal := patchAssignerGui.Add("ComboBox", "r7 x+10 Section", patchNamesStandardArray)
	
	; third melody, channel 7
	3melStandardName := patchAssignerGui.Add("Text", "xs", "Standard third melody patch: ")
	3melStandardVal := patchAssignerGui.Add("ComboBox", "r7 x+10 Section", patchNamesStandardArray)
	
	
	
	; apply/cancel buttons
	
	applyPatchAssignButton := patchAssignerGui.Add("Button", "Default w80", "&Apply")
	cancelPatchAssignButton := patchAssignerGui.Add("Button", "w80 xp+m", "&Cancel")
}