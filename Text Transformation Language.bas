'---------------------------------------------------------------------------------------------------
'TEXT TRANSFORMATION LANGUAGE (TTL)
'---------------------------------------------------------------------------------------------------
'SUMMARY
	'Purpose: Text Transformation Language is a scripting language that uses interpreted commands to transform text files.
	'Author: Dustinian Camburides
	'Platform: FreeBASIC (www.freebasic.net)
	'Revision: 2.0
	'Updated: 7/28/2013
'---------------------------------------------------------------------------------------------------
'INSTRUCTIONS
	'1. Create a plain-text file of commands per the "syntax" section below.
	'2. Run the TTL intepreter, identifying the script path, input path, and output path as command-line parameters.
'---------------------------------------------------------------------------------------------------
'SYNTAX
	'Commands: Use the below commands to transform your input text into your output text.
		'REPLACE "find" WITH "add"
		'REPLACE ALL WITH "add" BETWEEN "precedant" AND "antecedant"
		'REPLACE "find" WITH "add" BETWEEN "precedant" AND "antecedant"
		'REPLACE ALL WITH "add" FROM "precedant" TO "antecedant"
		'REPLACE FIRST "find" AFTER "precedant" WITH "add"
	'Modules: Use the below command to include a seperate file of TTL commands into your current script.
		'INCLUDE "c:\example_folder\example_file.ttl"
'---------------------------------------------------------------------------------------------------
'COMMAND-LINE PARAMETERS
	'ttl.exe script_path.ttl input_path.txt output_path.txt
'---------------------------------------------------------------------------------------------------
'REVISION HISTORY
	'2.0: Fixed an infinite loop that occurs when the [add] sub-string contains the [find] sub-string, updated command-line parameter parsing.
	'1.9: Fixed parsing errors for Replace_Subsequent$ and Replace_Between$ commands, updated Replace_Subsequent$ syntax.
	'1.8: Migrated from QB64 (www.qb64.net) to FreeBASIC (www.freebasic.net).
	'1.7: Broke the source code up into modules: [string.manipulation], [string.array], and [text.file.input.output].
	'1.6: Fixed numerous errors in the [string manipulation] section.
	'1.5: Re-named parameters/arguments For logical consistency.
	'1.4: Altered the structure of the "parse" subroutines For better re-usability.
	'1.3: Re-ordered and re-organized procedures For logical consistency.
	'1.2: Added the ability to target any script to any file through a command-line parameter.
	'1.1: Re-ordered and re-organized procedures For logical consistency.
	'1.0: First working version.
'---------------------------------------------------------------------------------------------------
'PLANNED ENHNACEMENTS
	'Major:
		'Target Folder: The ability to target all the files in a folder and its subfolders (filtered by extension).
		'Append: The ability to append text from another file to the beginning or end of the current file.
		'Replace All Once / Recursive: The ability to determine whether all instances of a query string are replaced once per initial location in a file... or over and over again until they no longer occur.
		'Debug Logs: The ability to log transformations in progress at different levels of detail.
		'Text User-Interface (TUI): A user interface assembled from ASCII characters (similar to the QB IDE).
		'Graphical User-Interface (GUI): A windows-style user interface (buttons, menus, scroll bars, etc.).
		'Syntax Definitons: A more elegant way to validate/recognize command syntax (DTD file, XML definitions, etc.).
	'Minor:
		'Tokens: Constants For common "white space" characters (TAB, RETURN, etc.).
		'Wildcards: Symbols For "wildcard" searches (*, #, etc.).
'---------------------------------------------------------------------------------------------------
'LIBRARIES
	#Include "string array.bi"
	#Include "string manipulation.bi"
	#Include "text file input output.bi"
'---------------------------------------------------------------------------------------------------
'USER-DEFINED TYPES:
	Type TTLCommand
		Operation As String * 25 'The keyword For the operation to be performed.
		Path As String * 255 'The path where an input file (include, append, etc.) may be found.
		Find As String * 255 'The sub-string to be replaced by the "Add" sub-string.
		Add As String * 255 'The sub-string to added to the main string.
		Precedant As String * 255 'The sub-string that marks the beginning of an affected area in the main string.
		Antecedant As String * 255 'The sub-string that marks the end of an affected area in the main string.
	End Type
'---------------------------------------------------------------------------------------------------
'PROCEDURES:
	Declare Sub Parse_Script (Commands() As TTLCommand, Script_Path As String)
	Declare Sub Load_Script (Words() As String, Commands() As TTLCommand)
	Declare Sub Parse_Command (Commands() As TTLCommand, Text_Command As String)
	Declare Sub Seperate_Words (Words() As String, Text_Command As String)
	Declare Sub Initialize_Command (Temporary_Command As TTLCommand)
	Declare Sub Intepret_Command (Temporary_Command As TTLCommand, Command_Words() As String)
	Declare Sub Normalize_Commands (Words() As String)
	Declare Sub Remove_Comments (Words() As String)
	Declare Sub Transform_CHR (Command_Words() As String)
	Declare Sub Combine_Sub_Strings (Command_Words() As String)
	Declare Sub Validate_Command (Words() As String)
	Declare Sub Populate_Command (Command_Words() As String, Temporary_Command As TTLCommand)
	Declare Function Substring (Text As String) As Integer
	Declare Sub Add_Commands (Main_Commands() As TTLCommand, New_Commands() As TTLCommand, Line_Number As Integer)
	Declare Function Execute_Script (Commands() As TTLCommand, Text As String) As String
	Declare Sub Execute_Command (TTLCommand As TTLCommand, Text As String)
	Declare Function Interior_Characters(ByVal Text As String) As String
'---------------------------------------------------------------------------------------------------
'GLOBAL CONSTANTS:
	Const TRUE = -1 'Allows integers to be "TRUE" (compability with other BASIC dialects).
	Const FALSE = 0 'Allows integers to be "FALSE" (compability with other BASIC dialects).
'---------------------------------------------------------------------------------------------------
'GLOBAL VARIABLES:
	Dim strCommandLineParameter As String 'The command-line parameters that TTL was run with.
	Dim strScriptPath As String 'The path of the script (TTL algorithm) to be run.
	Dim strInputPath As String 'The path of the input file the script will run against.
	Dim strOutputPath As String 'The path where TTL should put the finished text.
	Dim udtCommands() As TTLCommand 'The dynamic array of [Commands] that will be assembled and executed.
	Dim strInputText As String 'The input text the script will run against.
'---------------------------------------------------------------------------------------------------
'MAIN PROCEDURE:
	'INITIALIZE:
		ReDim udtCommands(0) As TTLCommand
	'PROCESSING:
		'If there are command-line arguments to process:
			If Command$ <> "" Then
				'Parse the script path out of the command-line parameters:
					strScriptPath = Command$(1)
				'Parse the input path out of the command-line parameters:
					strInputPath = Command$(2)
				'Parse the output path out of the command-line parameters:
					strOutputPath=Command$(3)
				'If the command-line arguments are not blank:
					If strScriptPath <> "" And strInputPath <> "" And strOutputPath <> "" Then
						'Load the input text:
							Print "LOADING FILE>>>"
							strInputText = Input_File(strInputPath)
						'Parse the script:
							Print "PARSING FILE>>>"
							Parse_Script(udtCommands(), strScriptPath)
						'Execute the script:
							Print "EXECUTING SCRIPT>>>"
							strInputText = Execute_Script(udtCommands(), strInputText)
						'Output the output text:
							Print "OUTPUTTING FILE>>>"
							Output_File(strInputText, strOutputPath)
					Else
						Print "ERROR: CANNOT PARSE COMMAND-LINE ARGUMENTS..."
					End If
			Else
				Print "ERROR: NO COMMAND-LINE PARAMETERS..."
			End If
		End

'---------------------------------------------------------------------------------------------------
'Parse
'---------------------------------------------------------------------------------------------------
Sub Parse_Script (Commands() As TTLCommand, Script_Path As String)
	'SUMMARY:
		'[Parse_Script] .
	'INPUT:
		'Commands():
		'Script_Path:
	'VARIABLES:
		Dim intCommand As Integer 'The address of the current [Command] within the [Commands] array.
		Dim Temporary_Commands() As TTLCommand
		Dim strFileText As String
		Dim strScriptText() As String
	'INITIALIZE:
		ReDim Temporary_Commands(0) As TTLCommand
		ReDim strScriptText(0) As String
		intCommand = LBound(Commands)
	'PROCESSING:
		'Load the script file:
			strFileText = Input_File(Script_Path)
			Seperate_Lines(strScriptText(), strFileText, Chr$(13) + Chr$(10))
		'Load the script:
			Load_Script(strScriptText(), Commands())
		'While there are more commands to add...
			While intCommand <= UBound(Commands)
				'Initialize the temporary command:
					ReDim Temporary_Commands(0) As TTLCommand
				'If the current command is "Include..."
					If LTrim$(RTrim$(Commands(intCommand).Operation)) = "INCLUDE" Then
						'Load the script file:
							strFileText = Input_File(Between(Commands(intCommand).Path, Chr$(34), Chr$(34), 1))
							Seperate_Lines(strScriptText(), strFileText, Chr$(13) + Chr$(10))
						'Load the script:
							Load_Script(strScriptText(), Temporary_Commands())
						'Add the commands to the script:
							Add_Commands(Commands(), Temporary_Commands(), intCommand)
					Else
						'Increment the current command:
							intCommand = intCommand + 1
					End If
		'Next [command]...
			Wend
End Sub

Sub Load_Script (Words() As String, Commands() As TTLCommand)
	'SUMMARY:
		'[Load_Script] .
	'INPUT:
		'Words():
		'Commands():
	'VARIABLES:
		Dim intLine As Integer 'The address of the current [Line] within the [Script] array.
	'PROCESSING:
		'If the file contains text...
			If (UBound(Words) > 0) OR (Len(Words(0)) > 0) Then
				'For each [line]...
					For intLine = LBound(Words) TO UBound(Words)
						'If the line is not blank...
							If Words(intLine) <> "" Then
								'Parse the command:
									Parse_Command(Commands(), Words(intLine))
							End If
				'Next [line]...
					Next intLine
			Else
				Print "File Error 0001: The file is blank."
				End
			End If
End Sub

Sub Parse_Command (Commands() As TTLCommand, Text_Command As String)
	'SUMMARY:
		'[Parse_Command] .
	'INPUT:
		'Commands():
		'Text_Command:
	'VARIABLES:
		Dim strWords() As String
		Dim udtTemporaryCommand As TTLCommand
	'INITIALIZE:
		Initialize_Command(udtTemporaryCommand)
		ReDim strWords(0) As String
	'PROCESSING:
		'Separate the words in the command:
			Seperate_Words(strWords(), Text_Command)
		'If there are words in the command...
			If strWords(0) <> "" Then
				'Intepret the command
					Intepret_Command(udtTemporaryCommand, strWords())
			End If
		'If the command contains instructions...
			If Left$(udtTemporaryCommand.Operation, 1) <> " " Then
				'If the first command is blank...
					If Filter(Commands(0).Operation, "ABCDEFGHIJKLMNOPQRSTUVWXYZ") = "" Then
						'Add the command to the first position in the array:
							Commands(0) = udtTemporaryCommand
					Else
						'Expand the array:
							ReDim Preserve Commands(UBound(Commands) + 1) As TTLCommand
						'Add the command to the last position in the array:
							Commands(UBound(Commands)) = udtTemporaryCommand
					End If
			End If
End Sub

Sub Seperate_Words (Words() As String, Text_Command As String)
	'SUMMARY:
		'[Seperate_Words] .
	'INPUT:
		'Words():
		'Text_Command:
	'CONSTANTS:
		CONST ALLOWED = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789()'/+&"
	'VARIABLES:
		Dim intCharacter As Integer 'The address of the current character in the [Text].
		Dim strCharacter As String * 1 'The character being examined.
		Dim bolQuote As Integer 'Whether there is an open quotation mark.
		Dim intWord As Integer 'The [Word] within the [Command Words] array.
	'INITIALIZE:
		intCharacter = 1
		bolQuote = FALSE
		intWord = 0
		ReDim Words(0) As String
	'PROCESSING:
		'While there are more characters to process...
			While (intCharacter <= Len(Text_Command))
				'Pull the character:
					strCharacter = Mid$(Text_Command, intCharacter, 1)
				'If the character is allowed...
					If InStr(1, ALLOWED, strCharacter) Then
						'Add [Character] to the current [word]:
							Words(intWord) = Words(intWord) + strCharacter
					Else
						'If the character is a quote...
							If strCharacter = Chr$(34) Then
								'If we are in an active quote...
									If bolQuote = TRUE Then
										'End quote:
											Words(intWord) = Words(intWord) + Chr$(34)
										'Start a new word:
											intWord = intWord + 1
										'Start a new word:
											ReDim Preserve Words(intWord) As String
										'Start a new word:
											bolQuote = FALSE
									Else
										'If the current word is not blank...
											If Words(intWord) <> "" Then
												'Start a new word:
													intWord = intWord + 1
												'Start a new word:
													ReDim Preserve Words(intWord) As String
											End If
										Words(intWord) = Chr$(34)
										bolQuote = TRUE
									End If
							ElseIf bolQuote = TRUE Then
								'Add [Character] to the current [word]:
									Words(intWord) = Words(intWord) + strCharacter
							Else
								'If the current word is not blank...
									If Words(intWord) <> "" Then
										'Start a new word:
											intWord = intWord + 1
										'Start a new word:
											ReDim Preserve Words(intWord) As String
									End If
							End If
					End If
			'Increment character:
				intCharacter = intCharacter + 1
		'Next [Character]...
			Wend
		'If the last word is blank...
			If Words(intWord) = "" Then
				'Remove the last word:
					intWord = intWord - 1
				'Remove the last word:
					ReDim Preserve Words(intWord) As String
			End If
End Sub

Sub Initialize_Command (Temporary_Command As TTLCommand)
	'SUMMARY:
		'[Initialize_Command] .
	'INPUT:
		'Temporary_Command:
	'INITIALIZE:
		Temporary_Command.Operation = ""
		Temporary_Command.Path = ""
		Temporary_Command.Add = ""
		Temporary_Command.Find = ""
		Temporary_Command.Precedant = ""
		Temporary_Command.Antecedant = ""
End Sub

Sub Intepret_Command (Temporary_Command As TTLCommand, Command_Words() As String)
	'SUMMARY:
		'[Intepret_Command] .
	'INPUT:
		'Temporary_Command:
		'Command_Words():
	'VARIABLES:
		Dim intWord As Integer 'The [Word] within the [Command Words] array.
		Dim intNextWord As Integer 'The Next [Word] within the [Command Words] array.
		Dim intCharacter As Integer 'The address of the current character in the [Text].
		Dim strTemporary As String 'The temporary string that holds the output string as it is assembled.
	'PROCESSING:
		'Normalize commands:
			Normalize_Commands(Command_Words())
		'Remove comments:
			Remove_Comments(Command_Words())
		'If the command words are not blank...
			If UBound(Command_Words) > 0 OR Command_Words(0) <> "" Then
				'Remove blank words:
					Remove_Blank_Words(Command_Words())
				'Transform CHR commands to their character:
					Transform_CHR(Command_Words())
				'Combine all sub-strings with a "+" or a "&" in between:
					Combine_Sub_Strings(Command_Words())
				'Remove blank words:
					Remove_Blank_Words(Command_Words())
				'Validate all words:
					Validate_Command(Command_Words())
				'Add [command words] to [temporary command]:
					Populate_Command(Command_Words(), Temporary_Command)
			End If
End Sub

Sub Normalize_Commands (Words() As String)
	'SUMMARY:
		'[Normalize_Commands] .
	'INPUT:
		'Words(): 
	'VARIABLES:
		Dim intWord As Integer  'The [Word] within the [Command Words] array.
	'PROCESSING:
		'For each [word]...
			For intWord = LBound(Words) TO UBound(Words)
				'If the word begins and ends in something other than quotes...
					If Left$(Words(intWord), 1) <> Chr$(34) And Right$(Words(intWord), 1) <> Chr$(34) Then
						'Upper-case the word:
							Words(intWord) = UCase$(Words(intWord))
					End If
		'Next [word]...
			Next intWord
End Sub

Sub Remove_Comments (Words() As String)
	'SUMMARY:
		'[Remove_Comments] .
	'INPUT:
		'Words():
	'VARIABLES:
		Dim intWord As Integer 'The [Word] within the [Command Words] array.
	'PROCESSING:
		'For each [word]...
			For intWord = UBound(Words) TO LBound(Words) STEP -1
				'If the word begins and ends in something other than quotes...
					If Left$(Words(intWord), 1) <> Chr$(34) And Right$(Words(intWord), 1) <> Chr$(34) Then
						'If the word is not blank...
							If Words(intWord) <> "" Then
								'If the [word] contains "'"...
									If InStr(1, Words(intWord), "'") Then
										'Remove characters after "'":
											Words(intWord) = Before(Words(intWord), "'", 1)
										'Remove subsequent words:
											ReDim Preserve Words(intWord) As String
									End If
							End If
						'If the word is not blank...
							If Words(intWord) <> "" Then
								'If the [word] contains "//"...
									If InStr(1, Words(intWord), "//") Then
										'Remove characters after "//":
											Words(intWord) = Before(Words(intWord), "//", 1)
										'Remove subsequent words:
											ReDim Preserve Words(intWord) As String
									End If
							End If
						'If the word is not blank...
							If Words(intWord) <> "" Then
								'If the [word] contains "REM"...
									If InStr(1, Words(intWord), "REM") Then
										'Remove characters after "REM":
											Words(intWord) = Before(Words(intWord), "REM", 1)
										'Remove subsequent words:
											ReDim Preserve Words(intWord) As String
									End If
							End If
					End If
		'Next [word]...
			Next intWord
End Sub

Sub Transform_CHR (Command_Words() As String)
	'SUMMARY:
		'[Transform_CHR] .
	'INPUT:
		'Command_Words():
	'VARIABLES:
		Dim intWord As Integer 'The [Word] within the [Command Words] array.
		Dim intCharacter As Integer 'The address of the current character in the [Text].
		Dim strTemporary As String 'The temporary string that holds the output string as it is assembled.
	'PROCESSING:
		'For each [word]...
			For intWord = LBound(Command_Words) TO UBound(Command_Words)
				'If the word begins and ends in something other than quotes...
					If Left$(Command_Words(intWord), 1) <> Chr$(34) And Right$(Command_Words(intWord), 1) <> Chr$(34) Then
						'If the "CHR" command appears...
							If InStr(1, Command_Words(intWord), "CHR") Then
								'If the "CHR" command is formatted as "CHR(#)"...
									If Left$(Command_Words(intWord), 4) = "CHR(" And Right$(Command_Words(intWord), 1) = ")" Then
										'Extract the number from the command:
											strTemporary = Mid$(Command_Words(intWord), 5, Len(Command_Words(intWord)) - 5)
										'Filter all non-numeric characters:
											strTemporary = Filter(strTemporary, "0123456789")
										'If the temporary string is between 1 and 3 characters...
											If Len(strTemporary) > 0 And Len(strTemporary) < 4 Then
												'Determine the numeric value of the string:
													intCharacter = CINT(VAL(strTemporary))
												'Replace the word with the appropriate ASCII character:
													Command_Words(intWord) = Chr$(34) + Chr$(intCharacter) + Chr$(34)
											Else
												Print "Syntax Error 0001: The CHR() number is out of range."
												End
											End If
									Else
										Print "Syntax Error 0000: The CHR() command is not correctly formatted."
										Print Command_Words(intWord)
										End
									End If
							End If
					End If
		'Next [word]...
			Next intWord
End Sub

Sub Combine_Sub_Strings (Command_Words() As String)
	'SUMMARY:
		'[Combine_Sub_Strings] .
	'INPUT:
		'Command_Words():
	'VARIABLES:
		Dim intWord As Integer  'The [Word] within the [Command Words] array.
	'INITIALIZE:
		intWord = LBound(Command_Words) + 1
	'PROCESSING:
		'While there are more words to process...
			While intWord < UBound(Command_Words)
				'If the word is a "+" or "&"...
					If (Command_Words(intWord) = "+") Or (Command_Words(intWord) = "&") Then
						'If the preceeding word begins and ends with quotes...
							If (Left$(Command_Words(intWord - 1), 1) = Chr$(34)) And (Right$(Command_Words(intWord - 1), 1) = Chr$(34)) Then
								'If the following word begins and ends with quotes...
									If Left$(Command_Words(intWord + 1), 1) = Chr$(34) And Right$(Command_Words(intWord + 1), 1) = Chr$(34) Then
										'Join the following word into the preceeding word:
											Command_Words(intWord - 1) = Left$(Command_Words(intWord - 1), Len(Command_Words(intWord - 1)) - 1) + Right$(Command_Words(intWord + 1), Len(Command_Words(intWord + 1)) - 1)
										'Blank the following word:
											Command_Words(intWord + 1) = ""
										'Blank the "+" or "&" operator:
											Command_Words(intWord) = ""
										'Remove blank words:
											Remove_Blank_Words(Command_Words())
									Else
										Print "Syntax Error: " + Command_Words(intWord) + " should be used to join strings."
										End
									End If
							Else
								Print "Syntax Error: " + Command_Words(intWord) + " should be used to join strings."
								End
							End If
					Else
						intWord = intWord + 1
					End If
		'Next [word]...
			Wend
End Sub

Sub Validate_Command (Words() As String)
	'SUMMARY:
		'[Validate_Command] .
	'INPUT:
		'Words():
	'VARIABLES:
		Dim intWord As Integer 'The [Word] within the [Command Words] array.
	'PROCESSING:
		'For each [word]...
			For intWord = LBound(Words) TO UBound(Words)
				'If the word is not a substring...
				If Right$(Words(intWord), 1) <> Chr$(34) Or Left$(Words(intWord), 1) <> Chr$(34) Then
					Select Case Words(intWord)
						Case "REPLACE"
						Case "WITH"
						Case "FROM"
						Case "AND"
						Case "ALL"
						Case "BETWEEN"
						Case "INCLUDE"
						Case "EVERYTHING"
						Case "AFTER"
						Case "BEFORE"
						Case "NEXT"
						Case "TO"
						Case "FIRST"
						Case Else
							Print "Error 0000: Unrecognized word " + Words(intWord)
							End
					End Select
				End If
		'Next [word]...
			Next intWord
End Sub

Sub Populate_Command (Command_Words() As String, Temporary_Command As TTLCommand)
	'SUMMARY:
		'[Populate_Command] .
	'INPUT:
		'Command_Words():
		'Temporary_Command:
	'PROCESSING:
		Select Case UBound(Command_Words)
			Case 0
				Print "Error 0000: Incomplete command " + Command_Words(0)
				End
			Case 1
				If Command_Words(0) = "INCLUDE" And Substring(Command_Words(1)) = TRUE Then
					Temporary_Command.Operation = "INCLUDE"
					Temporary_Command.Path = Command_Words(1)
				Else
					Print "Error 0000: Unrecognized Command " + Command_Words(0) + " " + Command_Words(1)
					End
				End If
			Case 2
				Print "Error 0000: Unrecognized Command " + Command_Words(0) + " " + Command_Words(1) + " " + Command_Words(2)
				End
			Case 3
				If Command_Words(0) = "REPLACE" And Substring(Command_Words(1)) = TRUE And Command_Words(2) = "WITH" And Substring(Command_Words(3)) = TRUE Then
					If InStr(1, Interior_Characters(Command_Words(3)), Interior_Characters(Command_Words(1))) < 1 Then
						Temporary_Command.Operation = "REPLACE"
						Temporary_Command.Find = Command_Words(1)
						Temporary_Command.Add = Command_Words(3)
					Else
						Print "Error 0000: [Add] sub-string contains [Find] substring: " + Command_Words(0) + " " + Command_Words(1) + " " + Command_Words(2) + " " + Command_Words(3)
						End
					End If
				Else
					Print "Error 0000: Unrecognized Command " + Command_Words(0) + " " + Command_Words(1) + " " + Command_Words(2) + " " + Command_Words(3)
					End
				End If
			Case 4
				Print "Error 0000: Unrecognized Command " + Command_Words(0) + " " + Command_Words(1) + " " + Command_Words(2) + " " + Command_Words(3) + " " + Command_Words(4)
				End
			Case 5
				Print "Error 0000: Unrecognized Command " + Command_Words(0) + " " + Command_Words(1) + " " + Command_Words(2) + " " + Command_Words(3) + " " + Command_Words(4) + " " + Command_Words(5)
				End
			Case 6
				If Command_Words(0) = "REPLACE" And Command_Words(1) = "FIRST" And Substring(Command_Words(2)) = TRUE And Command_Words(3) = "AFTER" And Substring(Command_Words(4)) = TRUE And Command_Words(5) = "WITH" And Substring(Command_Words(6)) = TRUE Then
					If InStr(1, Interior_Characters(Command_Words(6)), Interior_Characters(Command_Words(2))) < 1 Then
						Temporary_Command.Operation = "REPLACESUBSEQUENT"
						Temporary_Command.Find = Command_Words(2)
						Temporary_Command.Add = Command_Words(6)
						Temporary_Command.Precedant = Command_Words(4)
					Else
						Print "Error 0000: [Add] sub-string contains [Find] substring: " + Command_Words(0) + " " + Command_Words(1) + " " + Command_Words(2) + " " + Command_Words(3) + " " + Command_Words(4) + " " + Command_Words(5) + " " + Command_Words(6)
						End
					End If
				Else
					Print "Error 0000: Unrecognized Command " + Command_Words(0) + " " + Command_Words(1) + " " + Command_Words(2) + " " + Command_Words(3) + " " + Command_Words(4) + " " + Command_Words(5) + " " + Command_Words(6)
					End
				End If
			Case 7
				If Command_Words(0) = "REPLACE" And Command_Words(1) = "ALL" And Command_Words(2) = "WITH" And Substring(Command_Words(3)) = TRUE And Command_Words(4) = "BETWEEN" And Substring(Command_Words(5)) = TRUE And Command_Words(6) = "AND" And Substring(Command_Words(7)) = TRUE Then
					Temporary_Command.Operation = "REPLACEBETWEEN"
					Temporary_Command.Add = Command_Words(3)
					Temporary_Command.Precedant = Command_Words(5)
					Temporary_Command.Antecedant = Command_Words(7)
				ElseIf Command_Words(0) = "REPLACE" And Substring(Command_Words(1)) = TRUE And Command_Words(2) = "WITH" And Substring(Command_Words(3)) = TRUE And Command_Words(4) = "BETWEEN" And Substring(Command_Words(5)) = TRUE And Command_Words(6) = "AND" And Substring(Command_Words(7)) = TRUE Then
					If InStr(1, Interior_Characters(Command_Words(3)), Interior_Characters(Command_Words(1))) < 1 Then
						Temporary_Command.Operation = "REPLACEIFBETWEEN"
						Temporary_Command.Find = Command_Words(1)
						Temporary_Command.Add = Command_Words(3)
						Temporary_Command.Precedant = Command_Words(5)
						Temporary_Command.Antecedant = Command_Words(7)
					Else
						Print "Error 0000: [Add] sub-string contains [Find] substring: " + Command_Words(0) + " " + Command_Words(1) + " " + Command_Words(2) + " " + Command_Words(3) + " " + Command_Words(4) + " " + Command_Words(5) + " " + Command_Words(6) + " " + Command_Words(7)
						End
					End If
				ElseIf Command_Words(0) = "REPLACE" And Command_Words(1) = "ALL" And Command_Words(2) = "WITH" And Substring(Command_Words(3)) = TRUE And Command_Words(4) = "FROM" And Substring(Command_Words(5)) = TRUE And Command_Words(6) = "TO" And Substring(Command_Words(7)) = TRUE Then
					Temporary_Command.Operation = "REPLACEFROM"
					Temporary_Command.Add = Command_Words(3)
					Temporary_Command.Precedant = Command_Words(5)
					Temporary_Command.Antecedant = Command_Words(7)
				Else
					Print "Error 0000: Unrecognized Command " + Command_Words(0) + " " + Command_Words(1) + " " + Command_Words(2) + " " + Command_Words(3) + " " + Command_Words(4) + " " + Command_Words(5) + " " + Command_Words(6) + " " + Command_Words(7)
					End
				End If
			Case Else
				Print "Error 0000: Unrecognized Command"
				End
		End Select
End Sub

Function Substring (Text As String) As Integer
	'SUMMARY:
		'[Substring] .
	'INPUT:
		'Text:
	'PROCESSING:
		'If the first and last characters are quotes...
			If Left$(Text, 1) = Chr$(34) And Right$(Text, 1) = Chr$(34) Then
				Substring = TRUE
			Else
				Substring = FALSE
			End If
End Function

Sub Add_Commands (Main_Commands() As TTLCommand, New_Commands() As TTLCommand, Line_Number As Integer)
	'SUMMARY:
		'[Add_Commands] .
	'INPUT:
		'Main_Commands():
		'New_Commands():
		'Line_Number:
	'VARIABLES:
		Dim intCommand As Integer 'The address of the [Command] within the [Commands] array.
	'PROCESSING:
		'If there is a command populated...
			If UBound(New_Commands) > 0 Or Left$(New_Commands(0).Operation, 1) <> " " Then
				'Resize the main array:
					ReDim Preserve Main_Commands(UBound(Main_Commands) + UBound(New_Commands)) As TTLCommand
				'Move the items in the main array down:
					For intCommand = UBound(Main_Commands) TO (Line_Number + UBound(New_Commands) + 1) STEP -1
						Main_Commands(intCommand) = Main_Commands(intCommand - UBound(New_Commands))
					Next intCommand
				'Add the new commands to the command structure:
					For intCommand = LBound(New_Commands) TO UBound(New_Commands)
						Main_Commands(Line_Number + intCommand) = New_Commands(intCommand)
					Next intCommand
		End If
End Sub

'---------------------------------------------------------------------------------------------------
'Execute
'---------------------------------------------------------------------------------------------------
Function Execute_Script (Commands() As TTLCommand, Text As String) As String
	'SUMMARY:
		'[Execute_Script] .
	'INPUT:
		'Commands(): 
		'Text: The input string; the text that's being manipulated.
	'VARIABLES:
		Dim intCommand As Integer 'The address of the current [Command] within the [Commands] array.
	'PROCESSING:
		'For each [command]...
			For intCommand = LBound(Commands) TO UBound(Commands)
				'Execute the command:
					Execute_Command(Commands(intCommand), Text)
		'Next [command]...
			Next intCommand
	'OUTPUT:
		Execute_Script = Text
End Function

Sub Execute_Command (TTLCommand As TTLCommand, Text As String)
	'SUMMARY:
		'[Execute_Command] .
	'INPUT:
		'Command: 
		'Text: The input string; the text that's being manipulated.
	'PROCESSING:
		Select Case LTrim$(RTrim$(TTLCommand.Operation))
			Case "REPLACE"
				Text = Replace(Text, Interior_Characters(TTLCommand.Find), Interior_Characters(TTLCommand.Add))
			Case "REPLACEBETWEEN"
				Text = Replace_Between(Text, Interior_Characters(TTLCommand.Precedant), Interior_Characters(TTLCommand.Antecedant), Interior_Characters(TTLCommand.Add))
			Case "REPLACEIFBETWEEN"
				Text = Replace_If_Between(Text, Interior_Characters(TTLCommand.Precedant), Interior_Characters(TTLCommand.Antecedant), Interior_Characters(TTLCommand.Find), Interior_Characters(TTLCommand.Add))
			Case "REPLACEFROM"
				Text = Replace_From(Text, Interior_Characters(TTLCommand.Precedant), Interior_Characters(TTLCommand.Antecedant), Interior_Characters(TTLCommand.Add))
			Case "REPLACESUBSEQUENT"
				Text = Replace_Subsequent (Text, Interior_Characters(TTLCommand.Precedant), Interior_Characters(TTLCommand.Find), Interior_Characters(TTLCommand.Add))
		End Select
End Sub

Function Interior_Characters(ByVal Text As String) As String
	Dim strText As String
	strText = LTrim$(RTrim$(Text))
	If Left$(strText, 1) = Chr$(34) And Right$(strText, 1) = Chr$(34) Then
		strText = Mid$(strText, 2, Len(strText) - 2)
	Else
		strText = Text
	End If
	Interior_Characters = strText
End Function