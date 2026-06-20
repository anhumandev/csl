module infss;

import std.stdio;
import error;
import std.file;
import std.conv;
import std.algorithm;
import std.string;
import std.regex;
import token_string, ultracex, ssm;
import core.stdc.stdlib: exit, malloc;
import cslg.ultracgraphic.sgfu;
import csl.mempack.freec;
import csl.mempack.mallc;
import csl.preprs.define, func;
import math_manager;


enum TokanType {
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

struct Tokan
{
    TokanType token;
    string value;
}


// dic-value
int[string] int_s;
string[string] str;
uint[string] unint;

//fi
void infs(string filepath, string mode)
{
    string hah = "";
    Tokan[] tks;
    //auto fha = File(filepath, "r");
    auto fha = readText(filepath);
    auto kp = define_(fha, mode);
    foreach(ga; kp.splitLines()){
        string haa = ga.idup;
        string[] words = tkstring(haa, mode);
        int a = 0;
        if (ga.startsWith("//")) continue;
        foreach(hh; words){
            a++;
            TokanType type;
            if (hh == "int" || hh == "char" || hh == "long" || hh == "short" || hh == "float" || hh == "double" || hh == "void*") //keywords in here
            {
                type = TokanType.Keyword;
            } else if(hh == "unsigned" || hh == "signed" || hh == "auto") {
                type = TokanType.undr;
            } else if (hh == "="){
                type = TokanType.Oprator;
            } else if (hh.startsWith("--value:") || hh.startsWith("-v:")){
                type = TokanType.Name;
            } else if (hh.startsWith("//")){
                continue;
            } else if (hh.startsWith("{")){ 
                type = TokanType.Br1;
            } else if (hh.startsWith("}")){
                type = TokanType.Br2;
            } else {
                if (hh.startsWith("\"") && hh.endsWith("\"")){
                    type = TokanType.Value;
                }
                try {
                    if (hh.startsWith("//"))
                    {
                        tks = null;
                        continue;
                    }
                    if (tks[0].value != "int" && tks[0].value == "char" && tks[0].value == "#_SBOX")
                    {

                    } else {
                    int s = to!int(hh);
                    type = TokanType.Value;
                    }
                    
                } catch(Exception e){
                    continue;
                    //prinPanic("The entered value does not match the received type of the variable.");
                }
                
            }
            tks ~= Tokan(type, hh);


            if (mode == "debug"){
                writeln(tks);
            }
            
        }
        
        try {
            if (mode == "debug"){
                foreach(t, v; tks){
                    writeln(to!string(t) ~ ": " ~ to!string(v));
                }
                writeln("isMain: " ~ to!string(isMain));
            }
            if (mode == "debug"){
                        writeln("MainInsideCode: " ~ hah);
                    }
            if (isMain == 1){
                int aja = to!int(tks.length);
                int hhp = aja - 1;
                if (tks[hhp].token == TokanType.Br2){
                    es(hah, mode);
                    isMain = 0;
                    continue;
                } else {
                    hah = to!string(hah) ~ "\n" ~ to!string(ga);
                    continue;
                }
            } else {
                int unsi = 0;
            if (tks.length > 0 && (tks[0].token == TokanType.Keyword || tks[0].token == TokanType.undr)){
                if (tks[0].value == "int" || tks[0].value == "char" || tks[0].value == "double" || tks[0].value == "float" || tks[0].value == "double" || tks[0].value == "long" || tks[0].value == "short" || tks[0].value == "signed" || tks[0].value == "unsigned" || tks[0].value == "void*"){
                    if (mode == "debug")
                    {
                        writeln(tks[0].value);
                    }
                    if (tks[0].token == TokanType.undr && tks[0].value != "auto" && tks[0].value != "signed")
                    {
                        if (mode == "debug")
                        {
                            writeln("(Global Unsigned curser (GUC) - setting to enable...)");
                        }
                        unsi = 1;
                        if (tks[2].token == TokanType.Name)
                        {
                            
                            if (tks[0].value == "char"){
                                if (tks[2].value.endsWith("[]")){
                                    if (tks[3].value == "=")
                                    {
                                        if (tks[4].value.startsWith("\"") && tks[4].value.endsWith("\"")){
                                            auto kao = tks[4].value.replace("\"", "");
                                            if (mode == "debug"){
                                                writeln(kao);
                                            }
                                         
                                            auto ak = tks[2].value.replace("[]", "");
                                            str[ak] = kao;
                                            tks = null;
                                            unsi--;
                                            continue;
                                        } else {
                                            writeln("str1");
                                            tks = null;
                                            unsi--;
                                            continue;
                                        }
                                    } else {
                                        writeln("str2");
                                        tks = null;
                                        unsi--;
                                        continue;
                                    }
                                } else {
                                    writeln("strfuckup.");
                                    tks = null;
                                    unsi--;
                                    continue;
                                }
                            }
                        unint[tks[2].value] = 0;
                        unsi--;
                        if (tks[3].token == TokanType.Oprator){
                            if (tks[3].value == "="){
                                
                                    unint[tks[2].value] = to!int(tks[4].value);
                                    unsi--;
                                    if (mode == "debug"){
                                        writeln(unint[tks[2].value]);
                                        writeln("Setting (tks) to null for new lines...");
                                    }
                                    
                            } else {
                                writeln("p5");
                            }
                        } else {
                            writeln("p4");
                        }
                        }
                    } else {
                        if (tks[0].value == "auto" || tks[0].value == "signed")
                        {
                            tks = tks.remove(0);
                        }
                        if (mode == "debug")
                        {
                            writeln("P!: " ~ tks[0].value);
                            writeln(tks);
                            writeln(tks[1]);
                        }
                    if (tks[1].token == TokanType.Name){
                        if (tks[1].value == "--value:main()" || tks[1].value == "-v:main()"){
                            if (mode == "debug"){
                                writeln("Main defined for (this main program)...");
                            }
                            isMain = 1;
                            if (tks[2].token == TokanType.Br1){
                                continue;
                                tks = null;
                            }
                        } else {
                            if (tks[0].value == "char"){
                                if (tks[1].value.endsWith("[]")){
                                    if (tks[2].value == "=")
                                    {
                                        if (tks[3].value.startsWith("\"") && tks[3].value.endsWith("\"")){
                                            auto kao = tks[3].value.replace("\"", "");
                                            if (mode == "debug"){
                                                writeln(kao);
                                            }
                                         
                                            auto ak = tks[1].value.replace("[]", "");
                                            str[ak] = kao;
                                            tks = null;
                                            continue;
                                        } else {
                                            writeln("str1");
                                            tks = null;
                                            continue;
                                        }
                                    } else {
                                        writeln("str2");
                                        tks = null;
                                        continue;
                                    }
                                } else {
                                    writeln("strfuckup.");
                                    tks = null;
                                    continue;
                                }
                            } else if(tks[0].value == "void*"){
                                voidp[tks[1].value] = malloc(1);
                                if (mode == "debug")
                                {
                                    writeln("size of: 1B in D");
                                }
                                tks = null;
                                continue;
                            } else {
                        int_s[tks[1].value] = 0;
                            }
                        }
                        if (tks[2].token == TokanType.Oprator){
                            if (tks[2].value == "="){
                                
                                    int_s[tks[1].value] = math_man(tks[3].value);
                                    if (mode == "debug"){
                                        writeln(int_s[tks[1].value]);
                                        writeln("Setting (tks) to null for new lines...");
                                    }
                                    
                            } else {
                                writeln("p5");
                            }
                        } else {
                            writeln("p4");
                        }
                    } else {
                        writeln("p3");
                    }
                    }
                } else {
                    writeln("p2");
                }
                
            } else {
                tks = null;
                //writeln("p1");
            }
        }
        } catch(Exception e){
            prinPanic(to!string(e.msg));
        }
        tks = null;
    }

}


void es(string line, string mode){
    string[] lia = line.splitLines();
    foreach(lio; lia){
        lio = lio.idup;
        lio = lio.strip();
      if(lio == "" || lio.startsWith("//")){ continue; }
      if (lio.indexOf("&") != -1) 
      {
        string[] ak = lio.split("&");
        foreach(oo; ak)
        {
            oo = oo.strip();
            funcl(oo, mode);
        }
      } else {
        funcl(lio, mode);
      }
    
    }
}