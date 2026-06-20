import std.stdio, std.file, std.string, proc;

void main(string[] args)
{
	if (args.length < 2)
	{
		writeln("\033[1mC/C (C/ForCompile) (V0.1) https://github.com/anhumandev/csc");
		writeln("	Usage: ./csc [flag] [options]");
		writeln("\nFlags:\n	-e | --enter: Importing an CSC program");
		writeln("	-v | --version: show version of C/C.");
		writeln("	-h | --help: show current menu.");
		writeln("\nExample: ./csc -e hi.csc -n\033[0m");
	} else if (exists(args[2])){
		auto input = readText(args[2]);
		if (args[3] == "-n")
		{
			proce(input, args[2], "n");
		} else if (args[3] == "-d")
		{
			proce(input, args[2], "d");
		}
		
	}
}
