module intfunc;

import std.stdio, std.string, std.algorithm;


string[] init_func(string line)
{
    if (line.indexOf(",") != -1)
    {
        auto p = line.split(",");
        string[] res;
        foreach (l; p)
        {
            l = l.strip();
            l = l.replace("\"", "");
            res ~= l;
        }
        return res;
    } else {
        return [line.strip()];
    }
}