'---------------------------------------------------------------------------------------------------
'TEXT FILE INPUT / OUTPUT
'---------------------------------------------------------------------------------------------------
'SUMMARY
	'Purpose: A library of custom subroutines and functions to load text to/from a file.
	'Author: Dustinian Camburides (dustinian@gmail.com)
	'Platform: FreeBASIC (www.freebasic.net)
	'Revision: 1.6
	'Updated: 7/1/2015
'---------------------------------------------------------------------------------------------------
'REVISION HISTORY
	'1.6: Updates
			'Removed [List_Folder_Contents] since it's no longer used.
			'Removed "If...Then..." from [Input File] to speed it up.
	'1.5: Updates
			'Reverted changes from 1.4. It was faster, but it created too many encoding problems.
	'1.4: Updated
			'[File_Input] now tries to figure out how the input file is encoded.
			'[File_Input] uses WInput to open large files much more quickly than looped line-inputs.
	'1.3: Added:
			'[Folder_Contents] function to return all files in a folder.
	'1.2: Updated:
			'Migrated from QB64 (www.qb64.net) to FreeBASIC (www.freebasic.net).
	'1.1: Added:
			'[FreeFile] function (rather than defaulting all file streams to #1).
			'[_FILEEXISTS] function (rather than error-trapping).
	'1.0: First working version.
'---------------------------------------------------------------------------------------------------
'PLANNED ENHNACEMENTS
	'Major:
		'Add function to return all files in a folder (subfolders optional).
		'Check to see If folders exist in [Output_File].
	'Minor:
		'None at this time.
'---------------------------------------------------------------------------------------------------
'PROCEDURES
	Declare Function Input_File (ByVal Path As String) As String
	Declare Sub Output_File (ByVal Text As String, ByVal Path As String)
	Declare Sub List_Folder_Contents (Files() as String, ByVal Path as String, ByVal Filter as String = "*")
'---------------------------------------------------------------------------------------------------
'INCLUDES
	'Libraries:
		#include "file.bi"
'---------------------------------------------------------------------------------------------------
Function Input_File (ByVal Path As String) As String
	'SUMMARY:
		'[Input_File] returns the text of the file at the [Path] location.
	'INPUT:
		'Path: The location of the file.
	'VARIABLES:
		Dim strLine As String 'The current [Line] being added to the [File Text] string.
		Dim strFileText As String 'The [File Text] of the [Input File].
		Dim intFileNumber As Integer 'The number of the file.
	'INITIALIZE:
		strFileText = ""
	'PROCESSING:
		'If the file exists:
			If FileExists(Path) Then
				'Open the input file:
					intFileNumber = FreeFile
					OPEN Path For Input AS #intFileNumber
				'Initialize:
					Line Input #intFileNumber, strFileText
				'While not at the end of the file...
					While Not EOF(intFileNumber)
						'Input a line of text:
							Line Input #intFileNumber, strLine
						'Add the [line feed] and [carriage return] characters and the [line] to the [file text]:
							strFileText = strFileText & Chr$(13) & Chr$(10) & strLine
				'Next line...
					Wend
				'Close the input file:
					Close #intFileNumber
			End If
	'OUTPUT:
		Input_File = strFileText
End Function

Sub Output_File (ByVal Text As String, ByVal Path As String)
	'SUMMARY:
		'[Output_File] outputs the [Text} into a file at the [Path] location.
	'INPUT:
		'Text: The output string; the text that's being output to the [Path] location.
		'Path: The location of the file.
	'VARIABLES:
		Dim intFileNumber As Integer 'The number of the file.
	'PROCESSING:
		'Open the output file:
			intFileNumber = FreeFile
			Open Path For Output AS #intFileNumber
		'Print the text to the file:
			Print #intFileNumber, Text
		'Close the output file:
			Close #intFileNumber
End Sub