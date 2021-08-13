#Requires AutoHotkey v2.0-
#SingleInstance Ignore

keyArray := Array()
noteNameArray := Array()
changeArray := Array()
divArray := Array()
chanArray := Array()
patchArray := Array()





loadScaleIntoArrays(scale)
{
	rowNo := 1				; max rowNo = keyCount + 1
	
	while rowNo <= (keyCount + 1)
	{
		if (scaleMap[(rowNo - 1)] = "X")
		{
			keyArray.Push((rowNo - 1))		; key index (from 0)
			noteNameArray.Push("Spare")		; note name "spare"
			changeArray.Push(-1)				; note gets changed to -1
			divArray.Push("Spare")			; division "spare"
			chanArray.Push(1)					; channel 1
			patchArray.Push(-1)				; patch -1
		}
		else
		{
			keyArray.Push((rowNo - 1))			; key index (from 0)
			noteNameArray.Push(scaleMap[(rowNo -1)])		; note name at key index (from 0)
			changeArray.Push("")
			
		}
		rowNo++
	}
}
