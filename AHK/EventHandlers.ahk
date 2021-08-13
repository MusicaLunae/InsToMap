#Requires AutoHotkey v2.0-
#SingleInstance Ignore

; Event handlers

; store current row values into the respective Arrays
editKeyValue.OnEvent("Change", changeCurRowVals(editKeyVal.Value))		; Commits the old row's values to the Arrays, and loads the new ones into the ListView
editPatchVal.OnEvent("Change", changeStatusBarPatch(editChanVal.Value, editPatchVal.Value)		; Changes the Status Bar underneath to reflect the patch currently being selected

; checks if any of the values in the Group Box change
editKeyVal.OnEvent("Change", unsavedChangesMade())
editNoteNameVal.OnEvent("Change", unsavedChangesMade())
editChangeVal.OnEvent("Change", unsavedChangesMade())
editDivVal.OnEvent("Change", unsavedChangesMade())
editChanVal.OnEvent("Change", unsavedChangesMade())
editPatchVal.OnEvent("Change", unsavedChangesMade())