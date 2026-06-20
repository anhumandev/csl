module func;
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
import csl.preprs.define, infss;

void funcl(string lio, string mode)
{
    if (lio.startsWith("printf")){
        auto aj = regex(`printf\("([^"]+)"\);`);
        auto aj2 = match(lio, aj);
        if (!aj2.empty)
        {

            if (aj2.captures[1] in int_s)
            {
                write(int_s[aj2.captures[1]]);
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
                        if (kal in str)
                        {
                            write(str[kal]);
                        } else if(kal.startsWith("\"") && kal.endsWith("\"")){
                            auto lll = kal.replace("\"", "");
                            lll = lll.replace("\\s0", " ");
                            lll = lll.replace("\\n", "\n");
                            write(lll);
                        } else if(kal in int_s) {
                            write(int_s[kal]);
                        } else if(kal in unint){
                            write(unint[kal]);
                        } else {
                            writeln("pw2");
                        }
                    }
                } else {
                if (kaj2.captures[1] in int_s)
            {
                write(int_s[kaj2.captures[1]]);
            } else if (kaj2.captures[1] in str){
                write(str[kaj2.captures[1]]);
            } else if (kaj2.captures[1] in unint){
                write(unint[kaj2.captures[1]]);
            } else {
                prinPanic("no value with this name.");
            }
                }
        } else {
            writeln("e2");
        }
        }
    } else if(lio.startsWith("return")){
            auto reg = regex(`return (\S+);`);
            auto ja = match(lio, reg);
            if (!ja.empty)
            {
                if (ja.captures[1] in int_s){
                    
                        fiappwitherror(int_s[ja.captures[1]]); 
                    
                } else {
                    fiappwitherror(to!int(ja.captures[1]));
                }
            } else {
                writeln("r1");
            }
    } else if (lio == "_exitWDT;"){
        throw new UltraCExp("Program ended with");
    } else if (lio.startsWith("malloc"))
    {
        auto ll = regex(`malloc\((.+)\);`);
        auto ll2 = match(lio, ll);
        if (!ll2.empty)
        {
            if (mode == "debug")
            {
                writeln(ll2);
            }

            _malloc(ll2.captures[1], mode);
        }
    } else if(lio.startsWith("free")){
        auto ll = regex(`free\((.+)\);`);
        auto ll2 = match(lio, ll);
        if (!ll2.empty)
        {
            if (mode == "debug")
            {
                writeln(ll2);
            }

            _free(ll2.captures[1]);
        }
    } else if (lio.startsWith("math("))
    {
        auto regexo = regex(`math\(([^)]+)\);`);
        auto kk = match(lio, regexo);
        if (!kk.empty)
        {
            if (kk.captures[1] in int_s)
            {
               int_s[kk.captures[1]] = matha(kk.captures[2]);
            }
             
        } else { writeln("fi1"); }
    }
}


int matha(string value1)
{
    // اگر رشته خالی بود، خطا بده
    if (value1.strip().length == 0) {
        writeln("Error: Empty expression in math()");
        return 0;
    }

    // ============================================
    // پردازش آرگومان‌ها با کاما
    // ============================================
    auto parts = value1.split(',');
    if (parts.length < 2) {
        writeln("Error: math() requires at least 2 arguments");
        return 0;
    }

    // ============================================
    // پردازش آرگومان اول (متغیر یا عدد)
    // ============================================
    string arg1 = parts[0].strip();
    int val1;
    
    // اگر متغیر بود، مقدارش را از int_s بگیر
    if (arg1 in int_s) {
        val1 = int_s[arg1];
    } else {
        // اگر عدد بود، تبدیل کن
        try {
            val1 = to!int(arg1);
        } catch (Exception e) {
            writeln("Error: Invalid first argument: ", arg1);
            return 0;
        }
    }

    // ============================================
    // پردازش آرگومان دوم (عبارت ریاضی)
    // ============================================
    string arg2 = parts[1].strip();
    int val2 = evaluateExpression(arg2);

    // ============================================
    // برگرداندن نتیجه (می‌توانید عملیات دیگری هم اضافه کنید)
    // ============================================
    return val1 + val2;  // یا هر عملیات دیگری مثل ضرب، تفریق و ...
}

// ============================================
// تابع محاسبه‌گر عبارات ریاضی
// ============================================
int evaluateExpression(string expr)
{
    // حذف فاصله‌ها
    expr = expr.replace(" ", "");
    
    // ============================================
    // پشتیبانی از پرانتز (داخلی‌ترین)
    // ============================================
    int start = -1;
    int end = -1;
    int parenLevel = 0;
    
    for (int i = 0; i < expr.length; i++) {
        char c = expr[i];
        if (c == '(') {
            if (parenLevel == 0) start = i;
            parenLevel++;
        } else if (c == ')') {
            parenLevel--;
            if (parenLevel == 0) end = i;
        }
    }
    
    if (start != -1 && end != -1) {
        string inside = expr[start+1 .. end];
        int result = evaluateExpression(inside);
        string newExpr = expr[0 .. start] ~ to!string(result) ~ expr[end+1 .. $];
        return evaluateExpression(newExpr);
    }
    
    // ============================================
    // جمع و تفریق (اولویت پایین‌تر)
    // ============================================
    int lastAdd = -1;
    int lastSub = -1;
    parenLevel = 0;
    
    for (int i = to!int(expr.length) - 1; i >= 0; i--) {
        char c = expr[i];
        if (c == ')') parenLevel++;
        else if (c == '(') parenLevel--;
        else if (parenLevel == 0) {
            if (c == '+') { lastAdd = i; break; }
            if (c == '-') { lastSub = i; break; }
        }
    }
    
    if (lastAdd != -1) {
        string left = expr[0 .. lastAdd];
        string right = expr[lastAdd+1 .. $];
        return evaluateExpression(left) + evaluateExpression(right);
    }
    
    if (lastSub != -1) {
        string left = expr[0 .. lastSub];
        string right = expr[lastSub+1 .. $];
        return evaluateExpression(left) - evaluateExpression(right);
    }
    
    // ============================================
    // ضرب و تقسیم (اولویت بالاتر)
    // ============================================
    int lastMul = -1;
    int lastDiv = -1;
    parenLevel = 0;
    
    for (int i = to!int(expr.length) - 1; i >= 0; i--) {
        char c = expr[i];
        if (c == ')') parenLevel++;
        else if (c == '(') parenLevel--;
        else if (parenLevel == 0) {
            if (c == '*') { lastMul = i; break; }
            if (c == '/') { lastDiv = i; break; }
        }
    }
    
    if (lastMul != -1) {
        string left = expr[0 .. lastMul];
        string right = expr[lastMul+1 .. $];
        return evaluateExpression(left) * evaluateExpression(right);
    }
    
    if (lastDiv != -1) {
        string left = expr[0 .. lastDiv];
        string right = expr[lastDiv+1 .. $];
        int divisor = evaluateExpression(right);
        if (divisor == 0) {
            writeln("Error: Division by zero!");
            return 0;
        }
        return evaluateExpression(left) / divisor;
    }
    
    // ============================================
    // تبدیل به عدد
    // ============================================
    try {
        return to!int(expr);
    } catch (Exception e) {
        writeln("Error: Invalid number '", expr, "'");
        return 0;
    }
}