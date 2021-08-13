#Requires AutoHotkey v2.0-
#SingleInstance Ignore

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