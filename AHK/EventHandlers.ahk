#Requires AutoHotkey v2.0-
#SingleInstance Ignore

; Event handlers


; main window
; When the selected key changes, stores the current row's values into the respective arrays, and loads the new row's values
; this also raises a Change event in the 
editKeyValue.OnEvent("Change", changeCurRowVals(editKeyVal.Value))		; Commits the old row's values to the Arrays, and loads the new ones
editPatchVal.OnEvent("Change", changeStatusBarPatch(editChanVal.Value, editPatchVal.Value)		; Changes the Status Bar underneath to reflect the patch currently being selected

; checks if any of the values in the edit Group Box change
editKeyVal.OnEvent("Change", unsavedChangesMade())
editNoteNameVal.OnEvent("Change", unsavedChangesMade())
editChangeVal.OnEvent("Change", unsavedChangesMade())
editDivVal.OnEvent("Change", unsavedChangesMade())
editChanVal.OnEvent("Change", unsavedChangesMade())
editPatchVal.OnEvent("Change", unsavedChangesMade())




; patch assignment window

; if any of the to-be-assigned values change, quietly has them added/edited in a hidden array
bassStandardVal.OnEvent("Change", updateToAssignArray(1))
accompStandardVal.OnEvent("Change", updateToAssignArray(2))
melStandardVal.OnEvent("Change", updateToAssignArray(3))
cMelStandardVal.OnEvent("Change", updateToAssignArray(4))
3melStandardVal.OnEvent("Change", updateToAssignArray(5))

; if the Apply button is clicked, unsaved changes flag is up
applyPatchAssignButton.OnEvent("Click", applyPatchAssignments())
cancelPatchAssignButton.OnEvent("Click", 