Set WshArguments = Wscript.Arguments	 'Create the Arguments object

If WshArguments.Count > 0 Then
		file_path = WshArguments.Item(0)		'Get the argument that we gave when we run the script
		root_place = Instr(1, file_path, "wwwroot", 1)		'Find the place of wwwroot string inside the path

		If not root_place = 0 Then
			separate_from = root_place+8		'If we find wwwroot string, extend selection with 8 chars to the next \ that we will separate the path from
		Else
			dot_place = Instr(1, file_path, ":", 1) 	 'If we can't find wwwroot then seacrh for : char
			separate_from = dot_place+2 	 'Then extend selection with 2 chars to the next \ that we will separate the path from
		End If

		If not separate_from = 0 Then
			file_path = Mid(file_path, separate_from) 	 'Separate path from the point that we got
			file_path = Replace(file_path, "\", "/", 1, -1, 1)		'Replace \ chars with / chars since we will open the path in the browser
			file_path = Replace(file_path, " ", "%20", 1, -1, 1)		'Replace space chars with %20 chars since we will open the path in the browser
			page = " http://localhost/" & file_path		'Add server address to the file path to run our server side script
		End If

		Set WshShell = WScript.CreateObject("WScript.Shell")
		firefox_path = """C:\Program Files (x86)\Firefox\firefox.exe"""
		Return = WshShell.Run (firefox_path & page,1)
Else
	 MsgBox "No parameter given."
End If
