module csl.preprs._sbox;
import std.stdio, std.string, std.file, std.algorithm, std.regex;
import csl.preprs.sbox_funcprintf;
string[string] localsbox;


enum TokanTypea {
    Keyword,
    Name,
    Value,
    Oprator,
    Br1,
    Br2,
    funcname,
    undr
}

int isMain = 0;

struct Tokana
{
    TokanTypea token;
    string value;
}

void sbox(string ll, string mode)
{
    auto onm = ll.split(' ');
    if (mode == "debug")
    {
        writeln(onm);
    }
    onm = onm.remove(0);
    if (mode == "debug")
    {
        writeln(onm);
    }
    Tokana[] tkss;
    int fl = 0;
    foreach (aas; onm)
    {
        if (aas.startsWith("printf"))
        {
            __printf(onm.join(' '), mode);
            fl = 1;
            break;
        } else {
        TokanTypea ss;
        if (aas == "char")
        {
            ss = TokanTypea.Keyword;
        } else if ((aas.startsWith("--value:") && aas.endsWith("[]") ) || (aas.startsWith("-v:") && aas.endsWith("[]")))
        {
            ss = TokanTypea.Name;
        } else if (aas == "=")
        {
            ss = TokanTypea.Oprator;
        } else {
            ss = TokanTypea.Value;
        }
        tkss ~= Tokana(ss, aas);
        }
    }
    if (fl == 0)
    {
    if (tkss[0].token == TokanTypea.Keyword && tkss[1].token == TokanTypea.Name)
    {
        if (tkss[2].token == TokanTypea.Oprator)
        {
            localsbox[tkss[1].value.replace("[]", "")] = tkss[3].value.replace("\"", "");
        } else {
            writeln("f1");
        }
    } else {
        writeln("f2");
    }
    }
}