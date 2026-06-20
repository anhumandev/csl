module ultracex;

import std.stdio;

class UltraCExp : Exception
{
    this(string msg, int code = 0) pure nothrow @nogc @safe
    {
        super(msg);
    }
}
