on saveToFile(content, filePath)
	try
		set fileDescriptor to (open for access filePath with write permission)
		set eof of fileDescriptor to 0
		write content to fileDescriptor as «class utf8»
		close access fileDescriptor
	on error errorMessage number errorNumber
		display alert "Error: " & errorMessage & " (" & errorNumber & ") occurred while saving file " & filePath
	end try
end saveToFile

tell application "Notes"
	activate
	
	set outputFolder to (path to desktop) as string
	
	repeat with anAccount in accounts
		repeat with aFolder in folders of anAccount
			repeat with aNote in notes of aFolder
				set noteTitle to the name of aNote
				set noteContent to the body of aNote
				
				set fileExtension to ".txt"
				
				set fileName to my replaceIllegalCharacters(noteTitle) & fileExtension
				set filePath to outputFolder & fileName
				
				try
					my saveToFile(noteContent, filePath)
				on error
					display alert "Error: Could not save note " & noteTitle
				end try
			end repeat
		end repeat
	end repeat
end tell

on replaceIllegalCharacters(input)
	set illegalCharacters to {":", "/", "\\", "?", "*", "|", "<", ">", "\""}
	set output to input
	repeat with anIllegalCharacter in illegalCharacters
		set output to my findAndReplace(anIllegalCharacter, "_", output)
	end repeat
	return output
end replaceIllegalCharacters

on findAndReplace(find, replace, input)
	set {tempTID, AppleScript's text item delimiters} to {AppleScript's text item delimiters, find}
	set input to text items of input
	set AppleScript's text item delimiters to replace
	set input to "" & input
	set AppleScript's text item delimiters to tempTID
	return input
end findAndReplace
