module csl.mempack.mallc;

import std.stdio, std.conv, error, infss;
import core.stdc.stdlib: malloc;
import intfunc;

void*[string] voidp;
void _malloc(string line, string mode)
{
    if (mode == "debug"){
    writeln("YOU CALL MALLOC SOMEWHERE IN YOUR PROG");
    }
    string[] args = init_func(line);
    if (args[0] == "int")
    {
        voidp[args[1]] = malloc(int.sizeof);
    } else if (args[0] == "char")
    {
        voidp[args[1]] = malloc(char.sizeof);
    } else
    {
        try {
            if (args[0] in int_s)
            {
                voidp[args[1]] = malloc(to!size_t(int_s[args[0]]));
            } else {
                voidp[args[1]] = malloc(to!size_t(args[0]));
            }
        
        } catch(Exception e)
        {
            writeln("fi0");
            prinPanic("ERROR:Fi0");
        }
    }
}