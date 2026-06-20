import std.stdio;
import init_prog;
import error;
import std.file;
import infss;

void main(string[] args)
{
	if (args.length < 2){
		writeln("\033[1mC/ (V0.1) https://github.com/anhumandev/ultrac");
		writeln("	Usage: ./csl [flag] [options]");
		writeln("\nFlags:\n	-e | --enter: Importing an UltraC program");
		writeln("	-n | --normal: Run the interpreter in normal mode (without interpretation messages)");
		writeln("	-d | --debug: Run the interpreter in debug mode and display messages during the interpretation process.");
		writeln("	-x | --xdoc: Offline Documents in localhost.");
		writeln("	-v | --version: show version of C/Interperter.");
		writeln("	-h | --help: show current menu.");
		writeln("	-spe | --sboxprinterror: Show errors of SboX.");
		writeln("\nExample: ./csl -e hi.csl -n\033[0m");
        //prinPanic("WUT");
    } else if(args[1] == "-e" || args[1] == "--enter"){
        if (exists(args[2])){
			try {
			if (args[3] == "-d" || args[3] == "--debug"){
				infs(args[2], "debug");
			} else if(args[3] == "-n" || args[3] == "--normal"){
            	infs(args[2], "normal");
			}
			} catch(Exception e){

			}
        } else {
            prinPanic("The imported file does not exist on this disk or in this directory.");
        }
    } else if (args[1] == "-v" || args[1] == "--version")
	{
		writeln("\033[1mC/ (v0.1) " ~ __DATE__ ~ " " ~ __TIME__);
	} else if (args[1] == "-h" || args[1] == "--help")
	{
		writeln("\033[1mC/ (V0.1) https://github.com/anhumandev/ultrac");
		writeln("	Usage: ./csl [flag] [options]");
		writeln("\nFlags:\n	-e | --enter: Importing an UltraC program");
		writeln("	-n | --normal: Run the interpreter in normal mode (without interpretation messages)");
		writeln("	-d | --debug: Run the interpreter in debug mode and display messages during the interpretation process.");
		writeln("	-x | --xdoc: Offline Documents in localhost.");
		writeln("	-v | --version: show version of C/Interperter.");
		writeln("	-h | --help: show current menu.");
		writeln("\nExample: ./csl -e hi.csl -n\033[0m");
	}
}