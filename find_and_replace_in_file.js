var arguments = WScript.Arguments;

var filename = "";
var find_text = "";
var replacement_text = "";

// Get arguments.
if (WScript.Arguments.length != 3) {
	usage = "Usage: 'find_and_replace.js filename find_text replacement_text' \n";
	usage += "\t"
	usage += "filename - a filename relative to this script's path \n";
	usage += "\t"
	usage += "find_text - a string or string-quoted regex containing the text to find \n";
	usage += "\t"
	usage += "replacement_text - a string containing the replacement text";
	
	WScript.Echo(usage);
	WScript.Quit();
}
else
{
	// If arguments are good, set variables.
	filename = WScript.Arguments(0);
	
	// RegExp object; see http://msdn.microsoft.com/en-us/library/h6e2eb7w(v=vs.84).aspx
	find_text = new RegExp(WScript.Arguments(1), "g");
	
	replacement_text = WScript.Arguments(2);
}

// Variables for filesystem / activex objects.
var ForReading = 1, ForWriting = 2, ForAppending = 8;

// Connect to the OS via ActiveX
var activex_object = new ActiveXObject("Scripting.FileSystemObject");

// Read the file into a string, then close the file.
var read_text_stream = activex_object.OpenTextFile(filename, ForReading);
var file_as_string = read_text_stream.ReadAll();
read_text_stream.Close();

// Replace the content of the string.
var replaced_string = file_as_string.replace(find_text, replacement_text);

// Write out to the same file again.
var write_text_stream = activex_object.OpenTextFile(filename, ForWriting);
write_text_stream.Write(replaced_string);
write_text_stream.Close();

WScript.Quit();