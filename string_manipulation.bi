'--------------------------------------------------------------------------------
'STRING MANIPULATION Copyright 2012-2015 Dustinian Camburides
'--------------------------------------------------------------------------------
'SUMMARY:
	'Purpose: A library of custom functions that transform strings.
	'Author: Dustinian Camburides (dustinian@dustinian.com)
	'Platform: FreeBASIC (www.freebasic.net)
	'Revision: 2.7
	'Updated: 3/31/2017
	'License: GNU GPL3
'--------------------------------------------------------------------------------
'REVISION HISTORY'
	'2.8: Added
				'Added [Replace_Previous].
	'2.7: Added
				'Added [Replace_If_Between_Once].
	'2.6: Fixed
				'Logic errors introduced with the speed fixes from 2.3.
	'2.5: Fixed
				'Logic error where [Replace_From] misses two back-to-back occurrences of [Precedent].
				'Logic error where [Replace_From] misses two back-to-back occurrences of [Precedent].
	'2.4: Fixed
				'Speed issues in [Replace_From], [Replace_Between], [Replace_Subsequent], and [Replace_If_Between].
	'2.3: Fixed:
				'Logic error where [Replace_Between] would miss back-to-back instances of [Precedent] to [Antecedent].
				'Speed issue where [Replace] would start over at the beginning of the string rather than at the last location. Hopefully this will speed up [Replace] commands.
	'2.2: Fixed:
				'Infinite loop in [Replace_Subsequent].
	'2.1: Fixed:
				'Infinite loop in [Replace_Between] and [Replace_From] when [Antecedent] wasn't found.
			'Added:
				'[Replace_Once] function to facilitate simple find-and-replace with no regard to recursion.
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
				'Used pointers (rather than InStr functions) in While statements (increased efficiency).
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
				'Runtime error in [Replace_From] function when [Precedent] or [Antecedent] did not appear.
				'Runtime error in [Replace_Between] function when [Precedent] or [Antecedent] did not appear.
				'Runtime error in [Replace_Before_Next] function when [Precedent] or [Antecedent] did not appear.
				'Runtime error in [Replace_Subsequent] function when [Precedent] or [Antecedent] did not appear.
				'Runtime error in [Replace_If_Between] function when [Precedent] or [Antecedent] did not appear.
				'Runtime error in [Between] function when [Precedent] or [Antecedent] did not appear.
				'Invalid output from [Before] function when [Find] did not appear.
				'Invalid output from [After] function when [Find] did not appear.
				'Invalid output from [Between] function when [Find] did not appear.
				'Invalid output from [Replace_Once] function when [Find] did not appear.
	'1.0: First working version.
'--------------------------------------------------------------------------------
'PLANNED ENHNACEMENTS
	'Major:
		'None at this time.
	'Minor:
		'None at this time.
'--------------------------------------------------------------------------------
'LICENSE (GNU GPL3)
	'This file is part of Text Transformation Language.
	'Text Transformation Language is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
	'Text Transformation Language is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
	'You should have received a copy of the GNU General Public License along with Text Transformation Language.  If not, see <http://www.gnu.org/licenses/>.
'--------------------------------------------------------------------------------
'PROCEDURES
	Declare Function Replace (ByVal Text As String, ByVal Find As String, ByVal Substitute As String) As String
	Declare Function Replace_Once (ByVal Text As String, ByVal Find As String, ByVal Substitute As String) As String
	Declare Function Replace_From (ByVal Text As String, ByVal Precedent As String, ByVal Antecedent As String, ByVal Substitute As String) As String
	Declare Function Replace_Between (ByVal Text As String, ByVal Precedent As String, ByVal Antecedent As String, ByVal Substitute As String) As String
	Declare Function Replace_Subsequent (ByVal Text As String, ByVal Precedent As String, ByVal Find As String, ByVal Substitute As String) As String
	Declare Function Replace_Previous (ByVal Text As String, ByVal Antecedent As String, ByVal Find As String, ByVal Substitute As String) As String
	Declare Function Replace_If_Between (ByVal Text As String, ByVal Precedent As String, ByVal Antecedent As String, ByVal Find As String, ByVal Substitute As String) As String
	Declare Function Replace_If_Between_Once (ByVal Text As String, ByVal Precedent As String, ByVal Antecedent As String, ByVal Find As String, ByVal Substitute As String) As String
	Declare Function Between (ByVal Text As String, ByVal Precedent As String, ByVal Antecedent As String, ByVal Start As Long = 1) As String
	Declare Function Before (ByVal Text As String, ByVal Find As String, ByVal Start As Long = 1) As String
	Declare Function After (ByVal Text As String, ByVal Find As String, ByVal Start As Long = 1) As String
	Declare Function Filter (ByVal Text As String, ByVal Allowed As String) As String
'--------------------------------------------------------------------------------
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
		lngLocation = InStr(1, Text, Find)
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
					lngLocation = InStr(lngLocation, Text, Find)
		'Next instance of [Find]...
			Wend
	'OUTPUT:
		Replace = Text
End Function

Function Replace_Once (ByVal Text As String, ByVal Find As String, ByVal Substitute As String) As String
	'SUMMARY:
		'[Replace_Once] replaces all instances of the [Find] sub-string with the [Substitute] sub-string within the [Text] string.
	'INPUT:
		'Text: The input string; the text that's being manipulated.
		'Find: The specified sub-string; the string sought within the [Text] string.
		'Substitute: The sub-string that's being added to the [Text] string.
	'VARIABLES:
		Dim lngLocation As Long 'The address of the [Find] substring within the [Text] string.
		Dim strBefore As String 'The characters before the string to be replaced.
		Dim strAfter As String 'The characters after the string to be replaced.
	'INITIALIZE:
		lngLocation = InStr(1, Text, Find)
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
					lngLocation = InStr(lngLocation + Len(Substitute), Text, Find)
		'Next instance of [Find]...
			Wend
	'OUTPUT:
		Replace_Once = Text
End Function

Function Replace_From (ByVal Text As String, ByVal Precedent As String, ByVal Antecedent As String, ByVal Substitute As String) As String
	'SUMMARY:
		'[Replace_From] replaces characters in the [Text] string from the start of the [Precedent] sub-string to the end of the [Antecedent] sub-string with the [Substitute] sub-string.
	'INPUT:
		'Text: The input string; the text that's being manipulated.
		'Precedent: The sub-string that denotes the start of the change within [Text].
		'Antecedent: The sub-string that denotes the end of the change within [Text].
		'Substitute: The sub-string that's being added to the [Text] string.
	'VARIABLES:
		Dim lngStart As Long 'The location of the [Precedent] sub-string within the [Text] string.
		Dim lngStop As Long 'The location of the [Antecedent] sub-string within the [Text] string.
	'INITIALIZE:
		'Locate the [Precedent]:
			lngStart = InStr(1, Text, Precedent)
			If (lngStart > 0) Then lngStop = InStr(lngStart + Len(Precedent), Text, Antecedent)
	'PROCESSING:
		'While the [Precedent] appears in the [Text]...
			While ((lngStart > 0) And (lngStop > 0))
				'Locate the last character of the [Antecedent]:
					lngStop = lngStop + Len(Antecedent) - 1
				'Replace the text:
					Text = Left$(Text, (lngStart - 1)) + Substitute + Right$(Text, (Len(Text) - lngStop))
				'Find the next instance:
					lngStart = InStr(lngStart + Len(Substitute), Text, Precedent)
					If (lngStart > 0) Then lngStop = InStr(lngStart + Len(Precedent), Text, Antecedent)
		'Next instance of [Precedent]...
			Wend
	'OUTPUT:
		Replace_From = Text
End Function

Function Replace_Between (ByVal Text As String, ByVal Precedent As String, ByVal Antecedent As String, ByVal Substitute As String) As String
	'SUMMARY:
		'[Replace_Between] replaces characters in the [Text] string from the end of the [Precedent] sub-string to the start of the [Antecedent] sub-string with the [Substitute] sub-string.
	'INPUT:
		'Text: The input string; the text that's being manipulated.
		'Precedent: The sub-string that denotes the start of the change within [Text].
		'Antecedent: The sub-string that denotes the end of the change within [Text].
		'Substitute: The sub-string that's being added to the [Text] string.
	'VARIABLES:
		Dim lngStart As Long 'The location of the [Precedent] sub-string within the [Text] string.
		Dim lngStop As Long 'The location of the [Antecedent] sub-string within the [Text] string.
	'INITIALIZE:
		'Locate the [Precedent]:
			lngStart = InStr(1, Text, Precedent)
		'Locate the [Antecedent] in the [Text]...
			If (lngStart > 0) Then lngStop = InStr((lngStart + Len(Precedent)), Text, Antecedent)
	'PROCESSING:
		'While the [Precedent] appears in the [Text]...
			While ((lngStart > 0) And (lngStop > 0))
				'If the [Antecedent] appears in the [Text]...
					'Locate the last character of the [Antecedent]:
						lngStop = lngStop - 1
					'Replace the text:
						Text = Left$(Text, (lngStart + Len(Precedent) - 1)) + Substitute + Right$(Text, (Len(Text) - lngStop))
					'Find the next instance:
						lngStart = InStr(lngStart + Len(Precedent) + Len(Substitute) + Len(Antecedent), Text, Precedent)
					'Locate the [Antecedent] in the [Text]...
						If (lngStart > 0) Then lngStop = InStr(lngStart + Len(Precedent), Text, Antecedent)
		'Next instance of [Precedent]...
			Wend
	'OUTPUT:
		Replace_Between = Text
End Function

Function Replace_Subsequent (ByVal Text As String, ByVal Precedent As String, ByVal Find As String, ByVal Substitute As String) As String
	'SUMMARY:
		'[Replace_Subsequent] replaces the first [Find] sub-string after the [Precedent] sub-string with the [Substitute] sub-string within the [Text] string.
	'INPUT:
		'Text: The input string; the text that's being manipulated.
		'Precedent: The sub-string that denotes the start of the change within [Text].
		'Find: The specified sub-string; the string sought within the [Text] string.
		'Substitute: The sub-string that's being added to the [Text] string.
	'VARIABLES:
		Dim lngStart As Long 'The location of the [Precedent] sub-string within the [Text] string.
		Dim lngStop As Long 'The location of the last character of the [Find] sub-string within the [Text] string.
		Dim lngLocation As Long 'The address of the [Find] substring within the [Text] string.
	'INITIALIZE:
		lngStart = InStr(1, Text, Precedent)
		If (lngStart > 0) Then lngLocation = InStr(lngStart + Len(Precedent), Text, Find)
	'PROCESSING:
		'While the [Precedent] appears in the [Text]...
			While lngStart And lngLocation
				'Locate the last character of [Find]:
					lngStop = lngLocation + Len(Find) - 1
				'Replace the text:
					Text = Left$(Text, (lngLocation - 1)) + Substitute + Right$(Text, (Len(Text) - lngStop))
				'Increment the start point:
					lngStart = lngLocation + Len(Substitute)
				'Find the next instance:
					lngStart = InStr(lngStart, Text, Precedent)
					If (lngStart > 0) Then lngLocation = InStr(lngStart + Len(Precedent), Text, Find)
		'Next instance of [Precedent]...
			Wend
	'OUTPUT:
		Replace_Subsequent = Text
End Function

Function Replace_Previous (ByVal Text As String, ByVal Antecedent As String, ByVal Find As String, ByVal Substitute As String) As String
	'SUMMARY:
		'[Replace_Subsequent] replaces the first [Find] sub-string before the [Antecedent] sub-string with the [Substitute] sub-string within the [Text] string.
	'INPUT:
		'Text: The input string; the text that's being manipulated.
		'Antecedent: The sub-string that denotes the start of the change within [Text].
		'Find: The specified sub-string; the string sought within the [Text] string.
		'Substitute: The sub-string that's being added to the [Text] string.
	'VARIABLES:
		Dim lngStart As Long 'The location of the [Antecedent] sub-string within the [Text] string.
		Dim lngStop As Long 'The location of the last character of the [Find] sub-string within the [Text] string.
		Dim lngLocation As Long 'The address of the [Find] substring within the [Text] string.
	'INITIALIZE:
		lngStart = InStrRev(Text, Antecedent)
		If (lngStart > 0) Then lngLocation = InStr(lngStart, Text, Find)
	'PROCESSING:
		'While the [Antecedent] appears in the [Text]...
			While lngStart And lngLocation
				'Locate the last character of [Find]:
					lngStop = lngLocation + Len(Find) - 1
				'Replace the text:
					Text = Left$(Text, (lngLocation - 1)) + Substitute + Right$(Text, (Len(Text) - lngStop))
				'Increment the start point:
					lngStart = lngLocation
				'Find the next instance:
					lngStart = InStrRev(Text, Antecedent, lngStart)
					If (lngStart > 0) Then lngLocation = InStr(lngStart + Len(Antecedent), Text, Find)
		'Next instance of [Antecedent]...
			Wend
	'OUTPUT:
		Replace_Previous = Text
End Function

Function Replace_If_Between (ByVal Text As String, ByVal Precedent As String, ByVal Antecedent As String, ByVal Find As String, ByVal Substitute As String) As String
	'SUMMARY:
		'[Replace_If_Between] Replaces all instances of the [Find] sub-string that appear between the [Precedent] and [Antecedent] sub-strings with the [Substitute] sub-string in the [Text] string.
	'INPUT:
		'Text: The input string; the text that's being manipulated.
		'Precedent: The sub-string that denotes the start of the change within [Text].
		'Antecedent: The sub-string that denotes the end of the change within [Text].
		'Find: The specified sub-string; the string sought within the [Text] string.
		'Substitute: The sub-string that's being added to the [Text] string.
	'VARIABLES:
		Dim lngStart As Long 'The location of the [Precedent] sub-string within the [Text] string.
		Dim lngLocation As Long 'The address of the [Find] substring within the [Text] string.
		Dim strSubString As String 'The text between the [Precedent] and [Antecedent] sub-strings within the [Text] string.
	'INITIALIZE:
		'Locate the [Precedent] string within the [Text] string:
			lngStart = InStr(1, Text, Precedent)
			If (lngStart > 0) Then lngLocation = InStr((lngStart + Len(Precedent)), Text, Antecedent)
	'PROCESSING:
		'While the [Precedent] appears in the [Text]...
			While lngStart And lngLocation
				'Extract the substring:
					strSubString = Mid$(Text, (lngStart + Len(Precedent)), (lngLocation - (lngStart + Len(Precedent))))
				'Replace the text within the substring:
					strSubString = Replace(strSubString, Find, Substitute)
				'Insert the new substring into the text:
					Text = Left$(Text, ((lngStart + Len(Precedent)) - 1)) + strSubString + Right$(Text, (Len(Text) + 1 - lngLocation))
				'Increment the start point:
					lngStart = lngStart + Len(Precedent) + Len(strSubString) + Len(Antecedent)
				'Find the next instance:
					lngStart = InStr(lngStart, Text, Precedent)
					If (lngStart > 0) Then lngLocation = InStr((lngStart + Len(Precedent)), Text, Antecedent)
		'Next instance of [Precedent]...
			Wend
	'OUTPUT:
		Replace_If_Between = Text
End Function

Function Replace_If_Between_Once (ByVal Text As String, ByVal Precedent As String, ByVal Antecedent As String, ByVal Find As String, ByVal Substitute As String) As String
	'SUMMARY:
		'[Replace_If_Between] Replaces all instances of the [Find] sub-string that appear between the [Precedent] and [Antecedent] sub-strings with the [Substitute] sub-string in the [Text] string.
	'INPUT:
		'Text: The input string; the text that's being manipulated.
		'Precedent: The sub-string that denotes the start of the change within [Text].
		'Antecedent: The sub-string that denotes the end of the change within [Text].
		'Find: The specified sub-string; the string sought within the [Text] string.
		'Substitute: The sub-string that's being added to the [Text] string.
	'VARIABLES:
		Dim lngStart As Long 'The location of the [Precedent] sub-string within the [Text] string.
		Dim lngLocation As Long 'The address of the [Find] substring within the [Text] string.
		Dim strSubString As String 'The text between the [Precedent] and [Antecedent] sub-strings within the [Text] string.
	'INITIALIZE:
		'Locate the [Precedent] string within the [Text] string:
			lngStart = InStr(1, Text, Precedent)
			If (lngStart > 0) Then lngLocation = InStr((lngStart + Len(Precedent)), Text, Antecedent)
	'PROCESSING:
		'While the [Precedent] appears in the [Text]...
			While lngStart And lngLocation
				'Extract the substring:
					strSubString = Mid$(Text, (lngStart + Len(Precedent)), (lngLocation - (lngStart + Len(Precedent))))
				'Replace the text within the substring:
					strSubString = Replace_Once(strSubString, Find, Substitute)
				'Insert the new substring into the text:
					Text = Left$(Text, ((lngStart + Len(Precedent)) - 1)) + strSubString + Right$(Text, (Len(Text) + 1 - lngLocation))
				'Increment the start point:
					lngStart = lngStart + Len(Precedent) + Len(strSubString) + Len(Antecedent)
				'Find the next instance:
					lngStart = InStr(lngStart, Text, Precedent)
					If (lngStart > 0) Then lngLocation = InStr((lngStart + Len(Precedent)), Text, Antecedent)
		'Next instance of [Precedent]...
			Wend
	'OUTPUT:
		Replace_If_Between_Once = Text
End Function

Function Between (ByVal Text As String, ByVal Precedent As String, ByVal Antecedent As String, ByVal Start As Long = 1) As String
	'SUMMARY:
		'[Between] returns all the characters from the [Text] string that appear between the [Precedent] and [Antecedent] sub-strings.
	'INPUT:
		'Text: The input string; the text that's being manipulated.
		'Precedent: The sub-string that denotes the start of the change within [Text].
		'Antecedent: The sub-string that denotes the end of the change within [Text].
		'Start: The first location within the [Text] string where the [Find] string is sought.
	'VARIABLES:
		Dim lngLocation As Long 'The address of the [Find] substring within the [Text] string.
		Dim lngStart As Long 'The address of the end of the [Precedent].
		Dim lngStop As Long 'The address of the beginning of the [Antecedent].
		Dim lngLength As Long 'The length of the sub-string to be extracted.
	'PROCESSING:
		'Locate the [Precedent]:
			lngLocation = InStr(Start, Text, Precedent)
		'If the [Precedent] string was present...
			If lngLocation Then
				'Move the pointer ot the end of the [Precedent]:
					lngStart = lngLocation + Len(Precedent)
				'Locate the [Antecedent]:
					lngLocation = InStr(lngStart, Text, Antecedent)
				'If the [Antecedent] was present...
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
			lngLocation = InStr(Start, Text, Find)
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
			lngLocation = InStr(Start, Text, Find)
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
					If InStr(1, Allowed, strCharacter) Then
						'Add [Character] to the [Temporary] string:
							strTemporary = strTemporary + strCharacter
					End If
		'Next [Character]...
			Next lngCharacter
	'OUTPUT:
		Filter = strTemporary
End Function
