module token_string;

import std.stdio;
import std.string;
import std.regex;
import std.conv;
import std.array;

string[] tkstring(string line, string mode)
{
    if (mode == "debug")
    {
        writeln(line);
    }
    string[] result;
    string currentToken;
    bool inQuotes = false;
    
    for (int i = 0; i < line.length; i++) {
        char c = line[i];
        
        
        if (c == '"') {
            inQuotes = !inQuotes;
            currentToken ~= c;
            
            if (!inQuotes) {
                result ~= currentToken;
                currentToken = "";
            }
            continue;
        }
        
        if (inQuotes) {
            currentToken ~= c;
            continue;
        }
        
        if (c == ' ' || c == '\t') {
            if (currentToken.length > 0) {
                result ~= currentToken;
                currentToken = "";
            }
        } else {
            currentToken ~= c;
        }
    }
    
    if (currentToken.length > 0) {
        result ~= currentToken;
    }
    if (mode == "debug")
    {
        writeln(result);
    }
    return result;
}
