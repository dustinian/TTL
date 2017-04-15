# Text Transformation Language

Copyright 2012-2015 Dustinian Camburides

## Summary

* **Purpose**: Text Transformation Language is a scripting language that uses interpreted commands to transform text files.
* **Author**: Dustinian Camburides
* **Platform**: [FreeBASIC](http://www.freebasic.net)
* **Revision**: 2.7
* **Updated**: 7/24/2015

## Downloads

* **Compiled Interpreter**: [.EXE](http://www.dustinian.com/_downloads/ttl.exe)
* **Source Code**: [.ZIP](http://www.dustinian.com/_downloads/text_transformation_language.zip)
	* Compile with the following command line: `fbc -lang fb -s console "ttl.bas"`

## Interact

* Collaborate: [GitHub](https://github.com/dustinian/ttl)
* Report a bug: [Issues](https://github.com/dustinian/ttl/issues)
* Comment: [Freebasic.net](http://www.freebasic.net/forum/viewtopic.php?f=8&t=21197)

## Commands

Use the below commands to transform your input text into your output text.

### Exact Text:

* `REPLACE "find" WITH "add"`
	* Replaces every instance of "find" with "add." This function is **recursive** (it will keep finding "find" over and over again until "find" is gone). Therefore, this function will throw an error if "add" contains "find," because this command would never finish.
* `REPLACE "find" WITH "add" ONCE`
	* Replaces every instance of "find" with "add," but only once **per instance** of "find." This function is **not recursive**. This is useful if you want to do a replace, but your "add" contains your "find." Something like:
		* `REPLACE "</p>" WITH "</p>" + NEWLINE ONCE`
* `PREPEND "add" TO "find"`
* `APPEND "add" TO "find"`
* `SURROUND "find" with "add" and "add"`
* `DELETE "find"`

### Exact Text between Preceding and Anteceding Text

* `REPLACE "find" WITH "add" BETWEEN "precedent" AND "antecedent"`
	* This replaces "find" with "add," but only when "find" appears between "precedent" and "antecedent." In other words, if you wanted to replace all the NEWLINEs with spaces but only inside of a table cell, you might say:
		*`REPLACE NEWLINE WITH " " BETWEEN "<td>" AND "</td>"`
* `REPLACE "find" WITH "add" BETWEEN "precedent" AND "antecedent" ONCE`
* `DELETE "find" BETWEEN "precedent" AND "antecedent"`

### Text based on Preceding and Anteceding Text

* `REPLACE ALL WITH "add" BETWEEN "precedent" AND "antecedent"`
	* This replaces everything between the "precedent" and the "antecedent," but **excludes** the "precedent" and "antecedent" from the replacement. In other words, after the operation is complete, you would see the "precedent," the "add," and the "antecedent."
* `REPLACE ALL WITH "add" FROM "precedent" TO "antecedent"`
	* This replaces everything between the "precedent" and the "antecedent," but **includes** the "precedent" and "antecedent." In other words, after the operation is complete, you would see only the "add." The "precedent" and "antecedent" would gone.
* `DELETE ALL FROM "precedent" TO "antecedent"`
* `DELETE ALL BETWEEN "precedent" AND "antecedent"`

### Advanced

* `REPLACE FIRST "find" AFTER "precedent" WITH "add"`
	* This replaces only the first instance of "find" after the "precedent" with "add." Example: You run an operation to replace some of your p tags with h2 tags in an HTML document. You'd naturally want to replace some of the /p tags with /h2 tags... but how can you target only those /p tags that follow an h2 tag? This operation does that.
* `PREPEND "add"`
	* Adds text to the beginning of the input file.
* `APPEND "add"`
	* Adds text to the end of the input file.

### Modules

Use the below command to include a separate file of TTL commands into your current script.

* `INCLUDE "c:\example_folder\example_file.ttl"`

## ASCII

### Chr

Use the "CHR()" operator to look for characters that you can't easily type into an ASCII TTL file.

* `REPLACE CHR(8) WITH CHR(9)`

### Tokens

Use tokens to stand in for commonly-used CHRs, and to make your TTL more readable. Tokens must appear OUTSIDE quotation marks to be interpreted correctly.

Token | Chr
------|----
TAB | 9
NEWLINE | 10
CARRIAGERETURN | 13
LINEBREAK | 13 + 10
QUOTE | 34

* `REPLACE TAB WITH ", "`

### Concatenation

Use the "+" or the "&" characters (no difference in functionality) to concatenate multiple sub-strings into a single string in a TTL command.

* `REPLACE "</p>" & NEWLINE & NEWLINE WITH "</p>" + NEWLINE`

### Quotation Marks

Quotation marks tell TTL that everything inside the quotation is a sub-string. TTL does NOT parse text inside quotation marks for TTL Commands or Tokens.

## Instructions

1. Using the syntax above, enter your commands into a plain-text file.
2. Run ttl.exe; use the command-line parameters to tell the interpreter where to find:
	* The command file
	* The input file(s)

## Sample Command-Lines

* Transform Single File: `ttl.exe script_path.ttl input_path.txt`
* Transform Multiple Files: `ttl.exe script_path.ttl *.xml`

## Revision History

* **2.7**: Added new commands.
* **2.6**: Updated the screen output.
* **2.5**: Added the "Prepend" and "Append" commands!
* **2.4**: TTL can now target multiple files!
* **2.3**: Added [Replace_Once] command.
* **2.2**: Added on-screen "log"; TTL outputs the original command before it executes. This helps when debugging TTL scripts.
* **2.1**: Added token support (TAB, LINEBREAK, QUOTE, etc.), and began compiling in -lang FB (vs. QB).
* **2.0**: Fixed an infinite loop that occurs when the [add] sub-string contains the [find] sub-string, updated command-line parameter parsing.
* **1.9**: Fixed parsing errors for Replace_Subsequent$ and Replace_Between$ commands, updated Replace_Subsequent$ syntax.
* **1.8**: Migrated from QB64 (www.qb64.net) to FreeBASIC (www.freebasic.net).
* **1.7**: Broke the source code up into modules: String Manipulation, String Array, and Text File Input / Output.
* **1.6**: Fixed numerous errors in the [string manipulation] section.
* **1.5**: Re-named parameters/arguments For logical consistency.
* **1.4**: Altered the structure of the "parse" subroutines For better re-usability.
* **1.3**: Re-ordered and re-organized procedures For logical consistency.
* **1.2**: Added the ability to target any script to any file through a command-line parameter.
* **1.1**: Re-ordered and re-organized procedures For logical consistency.
* **1.0**: First working version.

## Planned Enhancements

### Major
* **Wild Cards**: Symbols For "wild card" searches (*, # , etc.).
* **Text User-Interface (TUI)**: A user interface assembled from ASCII characters (similar to the QB IDE).
* **Graphical User-Interface (GUI)**: A windows-style user interface (buttons, menus, scroll bars, etc.).
* **Syntax Definitions**: A more elegant way to validate/recognize command syntax (DTD file, XML definitions, etc.).

### Minor

* **Debug Logs**: The ability to log transformations in progress at different levels of detail.
* **Backwards Precedent/Antecedent Recognition**: The ability for TTL to move through text backwards (InstrRev) so that it could, for example, find matched tag pairs in a markup language.
* **Expand Delete Functionality**: Expand a "Delete" option to more existing commands.
* **REPLACE FROM Precedent TO Antecedent IF BETWEEN Precedent AND Antecedent**: A new commend.

## Sample Files

* **Script**: [eyrie_script.ttl](http://www.dustinian.com/_downloads/eyrie_script.ttl), written to convert Gryphon's stories at Eyrie Productions, Unlimited.
* **Input**: [eyrie_input.txt](http://www.dustinian.com/_downloads/eyrie_input.txt), part I of "The Fulcrum of Fate" by Gryphon.
* **Command Line**: ttl.exe eyrie_script.ttl eyrie_input.txt

## License (GNU GPL3)

This file is part of Text Transformation Language.

Text Transformation Language is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Text Transformation Language is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Text Transformation Language.  If not, see [http://www.gnu.org/licenses/](http://www.gnu.org/licenses/).