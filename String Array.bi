'---------------------------------------------------------------------------------------------------
'STRING ARRAY
'---------------------------------------------------------------------------------------------------
'SUMMARY
	'Purpose: A library of custom subroutines to create and manipulate a dnynamic array of strings.
	'Author: Dustinian Camburides (dustinian@gmail.com)
	'Platform: FreeBASIC (www.freebasic.net)
	'Revision: 1.1
	'Updated: 4/15/2013
'---------------------------------------------------------------------------------------------------
'REVISION HISTORY
	'1.1: Migrated from QB64 (www.qb64.net) to FreeBASIC (www.freebasic.net).
	'1.0: First working version.
'---------------------------------------------------------------------------------------------------
'PLANNED ENHNACEMENTS
	'Major:
		'None at this time.
	'Minor:
		'None at this time.
'---------------------------------------------------------------------------------------------------
'PROCEDURES
	Declare Sub Separate_Lines (Words() As String, ByVal Text As String, ByVal Separator As String)
	Declare Sub Remove_Word(Words() As String, ByVal Index As Integer)
	Declare Sub Remove_Blank_Words (Words() As String)
'---------------------------------------------------------------------------------------------------
Sub Remove_Word(Words() As String, ByVal Index As Integer)
	'SUMMARY:
		'[Remove_Word] removes a word from a dynamic array of strings.
	'INPUT:
		'Words(): The dynamic array, where separate elements are stored.
		'Index: The element to be removed from the dynamic array.
	'VARIABLES:
		Dim intWord As Integer 'The [Word] in the [Words] array.
	'PROCESSING:
		'For each [Word] after [Index]...
			For intWord = Index to UBound(Words) - 1
				'Replace the word with the subsequent word:
					 Words(intWord) = Words(intWord + 1)
		'Next [Word]...
			Next intWord
		'ReDimension the [Words] array:
			ReDim Preserve Words(UBound(Words) - 1) As String
End Sub

Sub Separate_Lines (Words() As String, ByVal Text As String, ByVal Separator As String)
	'SUMMARY:
		'[Separate_Lines] extracts individual sub-strings from a string.
	'INPUT:
		'Words(): The output array, where separate [sub-strings] are stored.
		'Text: The input string being filtered.
		'Separator: The character(s) that separates [sub-strings].
	'VARIABLES:
		Dim lngLocation As Long 'The location of the [Separator] within the [Text].
		Dim lngStart As Long 'The starting point For the Next search For a [Separator] within the [Text].
		Dim intLines As Integer 'The total number of lines in the dynamic array.
	'INITIALIZE:
		Text = Text + Separator
		intLines = 0
		lngStart = 1
		lngLocation = INSTR(lngStart, Text, Separator)
	'PROCESSING:
		'While the [Separator] appears in the [Text]...
			While (lngLocation > 0)
				'Increment the number of lines:
					intLines = intLines + 1
				'Re-size the dynamic array:
					ReDim Preserve Words(intLines) As String
				'Extract the [sub-string] from the [Text]:
					Words(intLines) = Mid$(Text, lngStart, (lngLocation - lngStart))
				'Move the [Start] pointer beyond the end of the [sub-string]:
					lngStart = lngLocation + 1
				'Locate the Next [Separator] within the [Text]:
					lngLocation = InStr(lngStart, Text, Separator)
		'Next instance of [Separator]...
			Wend
End Sub

Sub Remove_Blank_Words (Words() As String)
	'SUMMARY:
		'[Remove_Blank_Words] removes blank elements from a dynamic array of strings.
	'INPUT/OUTPUT:
		'Words(): The dynamic array, where separate elements are stored.
	'VARIABLES:
		Dim intElement As Integer 'The element within the array.
	'PROCESSING:
		'For each [Element] in the [Array]...
			For intElement = UBound(Words) To LBound(Words) Step -1
				'If the word is blank...
					If Words(intElement) = "" Then
						'Remove the word:
							Remove_Word(Words(), intElement)
					End If
		'Next [Element]...
			Next intElement
End Sub
