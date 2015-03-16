'---------------------------------------------------------------------------------------------------
'STRING MANIPULATION
'---------------------------------------------------------------------------------------------------
'SUMMARY:
	'Purpose: A library of custom functions that transform strings.
	'Author: Dustinian Camburides (dustinian@gmail.com)
	'Platform: FreeBASIC (www.freebasic.net)
	'Revision: 2.0
	'Updated: 12/18/2014
'---------------------------------------------------------------------------------------------------
'REVISION HISTORY'
	'2.0: Fixed:
				'Logic error in [Replace_From] that caused subsequent instances of a [Precedent] not to be recognized.
	'1.9: Updated:
				'Added scope control (ByVal, ByRef) to each parameter in each function.
				'Made the [Start] parameter optional for [Replace_Once] function.
				'Made the [Start] parameter optional for [Between] function.
				'Made the [Start] parameter optional for [Before] function.
				'Made the [Start] parameter optional for [After] function.
				'Cleaned up indentations.
	'1.8: Updated:
				'Migrated from QB64 (www.qb64.net) to FreeBASIC (www.freebasic.net).
	'1.7: Fixed:
				'Logic error in [Replace_Subsequent].
	'1.6: Updated:
				'Used pointers (rather than INSTR functions) in While statements (increased efficiency).
				'Removed procedure-level [strText] variable (reduced memory footprint).
				'Removed "If" statements from pointer calculations (increased efficiency).
	'1.5: Fixed:
				'Made all pointers (Location, Start, Length, etc.) Long instead of Integer for strings greater than 32kb.
	'1.4: Updated:
				'[Replace] renamed to [Replace_Once], and [Replace_All] renamed to [Replace] for clarity.
	'1.3: Fixed:
				'Infinite loop in [Replace_From] when [Substitute] sub-string was zero-length.
				'Infinite loop in [Replace_Between] when [Substitute] sub-string was zero-length.
				'Infinite loop in [Replace_Subsequent] when [Substitute] sub-string was zero-length.
				'Logic error in [Replace_If_Between] where only the first [Find] was replaced.
	'1.2: Added:
				'Detailed comments on the purpose, inputs, and outputs added to each function.
	'1.1: Added:
				'[Start] parameter for the [Between] function.
				'[Start] parameter for the [Before] function.
				'[Start] parameter for the [After] function.
				'[Start] parameter for the [Replace_Once] function.
			'Fixed:
				'Runtime error in [Replace_From] function when [Precedant] or [Antecedant] did not appear.
				'Runtime error in [Replace_Between] function when [Precedant] or [Antecedant] did not appear.
				'Runtime error in [Replace_Before_Next] function when [Precedant] or [Antecedant] did not appear.
				'Runtime error in [Replace_Subsequent] function when [Precedant] or [Antecedant] did not appear.
				'Runtime error in [Replace_If_Between] function when [Precedant] or [Antecedant] did not appear.
				'Runtime error in [Between] function when [Precedant] or [Antecedant] did not appear.
				'Invalid output from [Before] function when [Find] did not appear.
				'Invalid output from [After] function when [Find] did not appear.
				'Invalid output from [Between] function when [Find] did not appear.
				'Invalid output from [Replace_Once] function when [Find] did not appear.
	'1.0: First working version.
'---------------------------------------------------------------------------------------------------
'PLANNED ENHNACEMENTS
	'Major:
		'Fix infinite loop in [Replace] when [Substitute] appears in [Find].
	'Minor:
		'None at this time.
'---------------------------------------------------------------------------------------------------
'PROCEDURES
	Declare Function Replace (ByVal Text As String, ByVal Find As String, ByVal Substitute As String) As String
	Declare Function Replace_From (ByVal Text As String, ByVal Precedant As String, ByVal Antecedant As String, ByVal Substitute As String) As String
	Declare Function Replace_Between (ByVal Text As String, ByVal Precedant As String, ByVal Antecedant As String, ByVal Substitute As String) As String
	Declare Function Replace_Subsequent (ByVal Text As String, ByVal Precedant As String, ByVal Find As String, ByVal Substitute As String) As String
	Declare Function Replace_If_Between (ByVal Text As String, ByVal Precedant As String, ByVal Antecedant As String, ByVal Find As String, ByVal Substitute As String) As String
	Declare Function Between (ByVal Text As String, ByVal Precedant As String, ByVal Antecedant As String, ByVal Start As Long = 1) As String
	Declare Function Before (ByVal Text As String, ByVal Find As String, ByVal Start As Long = 1) As String
	Declare Function After (ByVal Text As String, ByVal Find As String, ByVal Start As Long = 1) As String
	Declare Function Filter (ByVal Text As String, ByVal Allowed As String) As String
'---------------------------------------------------------------------------------------------------
Function Replace (ByVal Text As String, ByVal Find As String, ByVal Substitute As String) As String
	'SUMMARY:
		'[Replace] replaces all instances of the [Find] sub-string with the [Substitute] sub-string within the [Text] string.
	'INPUT:
		'Text: The input string; the text that's being manipulated.
		'Find: The specified sub-string; the string sought within the [Text] string.
		'Substitute: The sub-string that's being added to the [Text] string.
	'VARIABLES:
		Dim lngLocation As Long 'The address of the [Find] substring within the [Text] string.
		Dim strBefore As String 'The characters before the string to be replaced.
		Dim strAfter As String 'The characters after the string to be replaced.
	'INITIALIZE:
		lngLocation = Instr(1, Text, Find)
	'PROCESSING:
		'While [Find] appears in [Text]...
			While lngLocation
				'Extract all text before the [Find] substring:
					strBefore = Left$(Text, lngLocation - 1)
				'Extract all text after the [Find] substring:
					strAfter = Right$(Text, ((Len(Text) - (lngLocation + Len(Find) - 1))))
				'Return the substring:
					Text = strBefore + Substitute + strAfter
				'Locate the Next instance of [Find]:
					lngLocation = Instr(1, Text, Find)
		'Next instance of [Find]...
			Wend
	'OUTPUT:
		Replace = Text
End Function

Function Replace_From (ByVal Text As String, ByVal Precedant As String, ByVal Antecedant As String, ByVal Substitute As String) As String
	'SUMMARY:
		'[Replace_From] replaces characters in the [Text] string from the start of the [Precedant] sub-string to the end of the [Antecedant] sub-string with the [Substitute] sub-string.
	'INPUT:
		'Text: The input string; the text that's being manipulated.
		'Precedant: The sub-string that denotes the start of the change within [Text].
		'Antecedant: The sub-string that denotes the end of the change within [Text].
		'Substitute: The sub-string that's being added to the [Text] string.
	'VARIABLES:
		Dim lngLocation As Long 'The address of the [Find] substring within the [Text] string.
		Dim lngStart As Long 'The location of the [Precedant] sub-string within the [Text] string.
		Dim lngStop As Long 'The location of the [Antecedant] sub-string within the [Text] string.
	'INITIALIZE:
		'Locate the [Precedant]:
			lngStart = Instr(1, Text, Precedant)
	'PROCESSING:
		'While the [Precedant] appears in the [Text]...
			While lngStart
				'Locate the [Antecedant]:
					lngStop = Instr((lngStart + Len(Precedant)), Text, Antecedant)
				'If the [Antecedant] appears in the [Text]...
					If lngStop Then
						'Locate the last character of the [Antecedant]:
							lngStop = lngStop + Len(Antecedant) - 1
						'Replace the text:
							Text = Left$(Text, (lngStart - 1)) + Substitute + Right$(Text, (Len(Text) - lngStop))
					Else
						'Increment the start point:
							lngStart = lngStart + Instr((lngStart + 1), Text, Precedant)
					End If
				'Increment the start point:
					lngStart = Instr(lngStart + 1, Text, Precedant)
		'Next instance of [Precedant]...
			Wend
	'OUTPUT:
		Replace_From = Text
End Function

Function Replace_Between (ByVal Text As String, ByVal Precedant As String, ByVal Antecedant As String, ByVal Substitute As String) As String
	'SUMMARY:
		'[Replace_Between] replaces characters in the [Text] string from the end of the [Precedant] sub-string to the start of the [Antecedant] sub-string with the [Substitute] sub-string.
	'INPUT:
		'Text: The input string; the text that's being manipulated.
		'Precedant: The sub-string that denotes the start of the change within [Text].
		'Antecedant: The sub-string that denotes the end of the change within [Text].
		'Substitute: The sub-string that's being added to the [Text] string.
	'VARIABLES:
		Dim lngLocation As Long 'The address of the [Find] substring within the [Text] string.
		Dim lngStart As Long 'The location of the [Precedant] sub-string within the [Text] string.
		Dim lngStop As Long 'The location of the [Antecedant] sub-string within the [Text] string.
	'INITIALIZE:
		'Locate the [Precedant]:
			lngStart = Instr(1, Text, Precedant)
	'PROCESSING:
		'While the [Precedant] appears in the [Text]...
			While lngStart
				'Locate the [Antecedant] in the [Text]...
					lngStop = Instr((lngStart + Len(Precedant)), Text, Antecedant)
				'If the [Antecedant] appears in the [Text]...
					If lngStop Then
						'Locate the last character of the [Antecedant]:
							lngStop = lngStop - 1
						'Replace the text:
							Text = Left$(Text, (lngStart + Len(Precedant) - 1)) + Substitute + Right$(Text, (Len(Text) - lngStop))
					Else
						'Increment the start point:
							lngStart = Instr((lngStart + 1), Text, Precedant)
					End If
				'Increment the start point:
					lngStart = Instr((lngStart + Len(Precedant) + Len(Substitute) + Len(Antecedant)), Text, Precedant)
		'Next instance of [Precedant]...
			Wend
	'OUTPUT:
		Replace_Between = Text
End Function

Function Replace_Subsequent (ByVal Text As String, ByVal Precedant As String, ByVal Find As String, ByVal Substitute As String) As String
	'SUMMARY:
		'[Replace_Subsequent] replaces the first [Find] sub-string after the [Precedant] sub-string with the [Substitute] sub-string within the [Text] string.
	'INPUT:
		'Text: The input string; the text that's being manipulated.
		'Precedant: The sub-string that denotes the start of the change within [Text].
		'Find: The specified sub-string; the string sought within the [Text] string.
		'Substitute: The sub-string that's being added to the [Text] string.
	'VARIABLES:
		Dim lngStart As Long 'The location of the [Precedant] sub-string within the [Text] string.
		Dim lngStop As Long 'The location of the last character of the [Find] sub-string within the [Text] string.
		Dim lngLocation As Long 'The address of the [Find] substring within the [Text] string.
	'INITIALIZE:
		lngStart = Instr(1, Text, Precedant)
	'PROCESSING:
		'While the [Precedant] appears in the [Text]...
			While lngStart
				'Locate the [Find] sub-string:
					lngLocation = Instr((lngStart + Len(Precedant) - 1), Text, Find)
				'If [Find] appears in the [Text]...
					If lngLocation Then
						'Locate the last character of [Find]:
							lngStop = lngLocation + Len(Find) - 1
						'Replace the text:
							Text = Left$(Text, (lngLocation - 1)) + Substitute + Right$(Text, (Len(Text) - lngStop))
						'Increment the start point:
							lngStart = Instr((lngStart + Len(Precedant) + Len(Substitute)), Text, Precedant)
					Else
						'Increment the start point:
							lngStart = Instr((lngStart + 1), Text, Precedant)
					End If
		'Next instance of [Precedant]...
			Wend
	'OUTPUT:
		Replace_Subsequent = Text
End Function

Function Replace_If_Between (ByVal Text As String, ByVal Precedant As String, ByVal Antecedant As String, ByVal Find As String, ByVal Substitute As String) As String
	'SUMMARY:
		'[Replace_If_Between] Replaces all instances of the [Find] sub-string that appear between the [Precedant] and [Antecedant] sub-strings with the [Substitute] sub-string in the [Text] string.
	'INPUT:
		'Text: The input string; the text that's being manipulated.
		'Precedant: The sub-string that denotes the start of the change within [Text].
		'Antecedant: The sub-string that denotes the end of the change within [Text].
		'Find: The specified sub-string; the string sought within the [Text] string.
		'Substitute: The sub-string that's being added to the [Text] string.
	'VARIABLES:
		Dim lngStart As Long 'The location of the [Precedant] sub-string within the [Text] string.
		Dim lngLocation As Long 'The address of the [Find] substring within the [Text] string.
		Dim strSubString As String 'The text between the [Precedant] and [Antecedant] sub-strings within the [Text] string.
	'INITIALIZE:
		'Locate the [Precedant] string within the [Text] string:
			lngStart = Instr(1, Text, Precedant)
	'PROCESSING:
		'While the [Precedant] appears in the [Text]...
			While lngStart
				'Locate the [Antecedant]:
					lngLocation = Instr((lngStart + Len(Precedant)), Text, Antecedant)
				'If the [Antecedant] appears in the [Text]...
					If lngLocation Then
						'Extract the substring:
							strSubString = Mid$(Text, (lngStart + Len(Precedant)), (lngLocation - (lngStart + Len(Precedant))))
						'Replace the text within the substring:
							strSubString = Replace(strSubString, Find, Substitute)
						'Insert the new substring into the text:
							Text = Left$(Text, ((lngStart + Len(Precedant)) - 1)) + strSubString + Right$(Text, (Len(Text) + 1 - lngLocation))
					Else
						'Increment the start point:
							lngStart = Instr(lngLocation, Text, Precedant)
					End If
				'Increment the start point:
					lngStart = Instr(lngStart + Len(Precedant) + Len(strSubString) + Len(Antecedant), Text, Precedant)
		'Next instance of [Precedant]...
			Wend
	'OUTPUT:
		Replace_If_Between = Text
End Function

Function Between (ByVal Text As String, ByVal Precedant As String, ByVal Antecedant As String, ByVal Start As Long = 1) As String
	'SUMMARY:
		'[Between] returns all the characters from the [Text] string that appear between the [Precedant] and [Antecedant] sub-strings.
	'INPUT:
		'Text: The input string; the text that's being manipulated.
		'Precedant: The sub-string that denotes the start of the change within [Text].
		'Antecedant: The sub-string that denotes the end of the change within [Text].
		'Start: The first location within the [Text] string where the [Find] string is sought.
	'VARIABLES:
		Dim lngLocation As Long 'The address of the [Find] substring within the [Text] string.
		Dim lngStart As Long 'The address of the end of the [Precedant].
		Dim lngStop As Long 'The address of the beginning of the [Antecedant].
		Dim lngLength As Long 'The length of the sub-string to be extracted.
	'PROCESSING:
		'Locate the [Precedant]:
			lngLocation = Instr(Start, Text, Precedant)
		'If the [Precedant] string was present...
			If lngLocation Then
				'Move the pointer ot the end of the [Precedant]:
					lngStart = lngLocation + Len(Precedant)
				'Locate the [Antecedant]:
					lngLocation = InStr(lngStart + 1, Text, Antecedant)
				'If the [Antecedant] was present...
					If lngLocation Then
						'Calculate the characters to keep:
							 lngLength = (lngLocation - lngStart)
						'Return the substring:
							 Between = Mid$(Text, lngStart, lngLength)
					Else
						'Return a null string:
							 Between = ""
					End If
			Else
				'Return a null string:
					Between = ""
			End If
End Function

Function Before (ByVal Text As String, ByVal Find As String, ByVal Start As Long = 1) As String
	'SUMMARY:
		'[Before] returns all the characters from the [Text] string that appear before the [Find] sub-string.
	'INPUT:
		'Text: The input string; the text that's being manipulated.
		'Find: The specified sub-string; the string sought within the [Text] string.
		'Start: The first location within the [Text] string where the [Find] string is sought.
	'VARIABLES:
		Dim lngLocation As Long 'The address of the [Find] substring within the [Text] string.
		Dim lngLength As Long 'The length of the sub-string to be extracted.
	'PROCESSING:
		'Locate the [Find] string within the [Text] string:
			lngLocation = Instr(Start, Text, Find)
		'If the [Find] string was present...
			If lngLocation Then
				'Calculate the characters to keep:
					lngLength = lngLocation - 1
				'Return the substring:
					Before = Left$(Text, lngLength)
			Else
				'Return a null string:
					Before = ""
			End If
End Function

Function After (ByVal Text As String, ByVal Find As String, ByVal Start As Long = 1) As String
	'SUMMARY:
		'[After] returns all the characters from the [Text] string that appear after the [Find] sub-string.
	'INPUT:
		'Text: The input string; the text that's being manipulated.
		'Find: The specified sub-string; the string sought within the [Text] string.
		'Start: The first location within the [Text] string where the [Find] string is sought.
	'VARIABLES:
		Dim lngLocation As Long 'The address of the [Find] substring within the [Text] string.
		Dim lngLength As Long 'The length of the [Output] substring.
	'PROCESSING:
		'Locate the [Find] string within the [Text] string:
			lngLocation = Instr(Start, Text, Find)
		'If the [Find] string was present...
			If lngLocation Then
				'Calculate the characters to keep:
					lngLength = Len(Text) - (lngLocation + Len(Find) - 1)
				'Return the substring:
					After = Right$(Text, lngLength)
			Else
				'Return a null string:
					After = ""
			End If
End Function

Function Filter (ByVal Text As String, ByVal Allowed As String) As String
	'SUMMARY:
		'[Filter] removes all characters from the [Text] string that do not appear in the [Allowed] string.
	'INPUT:
		'Text: The input string; the text that's being manipulated.
		'Allowed: The characters allowed in the output.
	'VARIABLES:
		Dim strTemporary As String 'The [Temporary] string that holds the [Output] string as it is assembled.
		Dim strCharacter As String * 1 'The [Character] substring extracted from the [Text] string.
		Dim lngCharacter As Long 'The address of the current [Character] in the [Text] string.
	'INITIALIZE:
		strTemporary = ""
	'PROCESSING:
		'For each [Character]...
			For lngCharacter = 1 To Len(Text)
				'Extract the character:
					strCharacter = Mid$(Text, lngCharacter, 1)
				'If the character appears in the [Allowed] string...
					If Instr(1, Allowed, strCharacter) Then
						'Add [Character] to the [Temporary] string:
							strTemporary = strTemporary + strCharacter
					End If
		'Next [Character]...
			Next lngCharacter
	'OUTPUT:
		Filter = strTemporary
End Function
