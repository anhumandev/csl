module csl.preprs.sbox_funcprintf;
import std.stdio, std.string, std.regex, std.algorithm, error, csl.preprs._sbox;

void __printf(string lio, string mode)
{
    auto aj = regex(`printf\("([^"]+)"\);`);
    auto aj2 = match(lio, aj);
    if (!aj2.empty)
    {

        if (aj2.captures[1] in localsbox)
        {
            write(localsbox[aj2.captures[1]]);
        } else {
            string kaaa = aj2.captures[1].replace("\"", "");
                kaaa = kaaa.replace("\\n", "\n");
                write(kaaa);
            }
        } else {
            auto kaj = regex(`printf\((.+)\);`);
            auto kaj2 = match(lio, kaj);
            if(!kaj2.empty){
                if (kaj2.captures[1].indexOf("+") != -1){
                    string[] kp = kaj2.captures[1].split('+');
                    if (mode == "debug"){
                        writeln(kp);
                    }
                    foreach (kal; kp){
                        kal = kal.replace(" ", "");
                        if (kal in localsbox)
                        {
                            write(localsbox[kal]);
                        } else if(kal.startsWith("\"") && kal.endsWith("\"")){
                            auto lll = kal.replace("\"", "");
                            lll = lll.replace("\\s0", " ");
                            lll = lll.replace("\\n", "\n");
                            write(lll);
                        } else if(kal in localsbox) {
                            write(localsbox[kal]);
                        } else {
                            writeln("pw2");
                        }
                    }
                } else {
                if (kaj2.captures[1] in localsbox)
            {
                write(localsbox[kaj2.captures[1]]);
            } else {
                prinPanic("no value with this name.");
            }
        }
        } else {
            writeln("e2");
        }
    }
}