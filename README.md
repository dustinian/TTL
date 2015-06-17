#Text Transformation Language

##Summary

* **Purpose**: Text Transformation Language is a scripting language that uses interpreted commands to transform text files.
* **Author**: Dustinian Camburides
* **Platform**: FreeBASIC (www.freebasic.net)
* **Revision**: 2.2
* **Updated**: 3/13/2015

##Downloads

* **Compiled Intepreter**: ttl.exe
* **Source Code**: text_transformation_language.zip

##Interact

* Collaborate on this project: [GitHub](https://github.com/dustinian/ttl)
* Report a bug: [Issues](https://github.com/dustinian/ttl/issues)
* Comment on this project: [Freebasic.net Forums](http://www.freebasic.net/forum/viewtopic.php?f=8&t=21197)
* Download a compiled version: [dustinian.com](http://www.dustinian.com/software/text_transformation_language.html)

##Command Syntax

###Commands

Use the below commands to transform your input text into your output text.

* 'REPLACE "find" WITH "add"'
* 'REPLACE ALL WITH "add" BETWEEN "precedent" AND "antecedent"'
* 'REPLACE "find" WITH "add" BETWEEN "precedent" AND "antecedent"'
* 'REPLACE ALL WITH "add" FROM "precedent" TO "antecedent"'
* 'REPLACE FIRST "find" AFTER "precedent" WITH "add"'

###Modules

Use the below command to include a separate file of TTL commands into your current script.

* 'INCLUDE "c:\example_folder\example_file.ttl"'

##String Syntax

###Chr

Use the "CHR()" operator to look for characters that you can't easily type into an ASCII TTL file.

* 'REPLACE CHR(8) WITH CHR(9)'

###Tokens

Use tokens to stand in for commonly-used CHRs, and to make your TTL more readable. Tokens must appear OUTSIDE quotation marks to be intepreted correctly.

Token | Chr
------|----
TAB | 9
\T | 9
NEWLINE | 10
\N | 10
CARRIAGERETURN | 13
\R | 13
LINEBREAK | 13 + 10
\R\N | 13 + 10
QUOTE | 34

* 'REPLACE TAB WITH ", "'

###Concatenation

Use the "+" or the "&" characters (no difference in functionality) to concatenate multiple sub-strings into a single string in a TTL command.

* 'REPLACE "</p>" & NEWLINE & NEWLINE WITH "</p>" + NEWLINE'

###Quotation Marks

Quotation marks tell TTL that everything inside the quotation is a sub-string. TTL does NOT parse text inside quotation marks for TTL Commands or Tokens.

##Instructions

1. Using the syntax above, enter your commands into a plain-text file.
2. Run ttl.exe; use the command-line parameters to tell the interpreter where to find:
	* The command file
	* The input file
	* The output file

##Command-Line Parameters

* 'ttl.exe script_path.ttl input_path.txt output_path.txt'

##Revision History

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

##Planned Enhancements

###Major
* **Target Folder**: The ability to target all the files in a folder and its sub-folders (filtered by extension).
* **Replace All Once / Recursive**: The ability to determine whether all instances of a query string are replaced once per initial location in a file... or over and over again until they no longer occur.
* **Debug Logs**: The ability to log transformations in progress at different levels of detail.
* **Text User-Interface (TUI)**: A user interface assembled from ASCII characters (similar to the QB IDE).
* **Graphical User-Interface (GUI)**: A windows-style user interface (buttons, menus, scroll bars, etc.).
* **Syntax Definitions**: A more elegant way to validate/recognize command syntax (DTD file, XML definitions, etc.).
* **Wild Cards**: Symbols For "wild card" searches (*, #, etc.).

###Minor

* **Prepend/Append**: The ability to append text from another file to the beginning or end of the current file.
* **Faster File Load**: Speed up loading input files into memory.

##Sample Files

* **Script**: [eyrie_script.ttl](http://www.dustinian.com/_downloads/eyrie_script.ttl), written to convert Gryphon's stories at Eyrie Productions, Unlimited.
* **Input**: [eyrie_input.txt](http://www.dustinian.com/_downloads/eyrie_input.txt), part I of "The Fulcrum of Fate" by Gryphon.
* **Command Line**: ttl.exe eyrie_script.ttl eyrie_input.txt eyrie_output.html