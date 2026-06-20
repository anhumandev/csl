module math_manager;

import std.stdio, std.conv;

int math_man(string expr)
{
    try {
        return to!int(expr);
    } catch(Exception e)
    {
        return 0;
    }
}