module error;

import std.stdio;
import core.stdc.stdlib;
void prinPanic(string messg)
{
    writeln("\033[31m\033[1mUltraC (" ~ __TIME__ ~ "): " ~ messg ~ "\033[0m");
    exit(1);
}