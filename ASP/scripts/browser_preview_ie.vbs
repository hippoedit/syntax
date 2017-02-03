Set objArguments = Wscript.Arguments	 'Create the Arguments object

If objArguments.Count > 0 Then
		file_path = objArguments.Item(0)		'Get the argument that we gave when we run the script
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
			page = "http://localhost/" & file_path		'Add server address to the file path to run our server side script
		End If

		'Create other necessary objects.
		Set objShell = WScript.CreateObject("WScript.Shell")
		Set objShellApplication = WScript.CreateObject("Shell.Application")
		Set objShellWindows = objShellApplication.Windows
		Set objIE = WScript.CreateObject("InternetExplorer.Application")

		'Find the old window if it is opened already.
		For n = 0 to objShellWindows.Count - 1		'Search among the open IE windows
			Set IE = objShellWindows.Item(n)
			URL = IE.LocationURL	 'Get the URL of IE window that we currently work on
			If URL = page Then		'If the URL of the window is equal to our file path. Then we found the old window that we search for
				IE.Quit 	 'Close the old IE window since we will open a new one
			End If
		Next

		objIE.Navigate page 	 'Open a new IE window and navigate to our page.
		IEName = objIE.Name 	 'Get the name of the window that we just opened
		objShell.AppActivate IEName 	 'Activate the window to focus and bring it to front.
Else
	 MsgBox "No parameter given."
End If