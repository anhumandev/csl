module csl.mempack.freec;

import std.stdio, std.conv, core.stdc.stdlib, csl.mempack.mallc;
import intfunc;
void _free(string line)
{
    string[] args = init_func(line);
    if (args[0] in voidp)
    {
        free(voidp[args[0]]);
    } else {
        writeln("ER1");
    }
}
