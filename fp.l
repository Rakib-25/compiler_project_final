%{
 #include<stdio.h>
 #include "fp.tab.h"
 #include<stdlib.h>
 #include<string.h>
 #define yywrap() 1
%}
delim	[ \t]
whitesp	{delim}+
var_name	[_a-zA-Z][_a-zA-Z0-9]*
HEADER	"#involve<"[ ]*.*".h>"[ ]*
realnumber	[-]?[0-9][0-9]*[.]?[0-9]*
integer_number [0-9]+
character .
binary_op "+"|"-"|"*"|"/"|"%"
unary_op "++"|"--"
logical_op "<"|">"|"<="|">="|"=="|"!="
ret_type "num"|"NULL"|"horof"|"Dotnum"
bitwise_op "&"|"|"|"!"


%%

"principle" return(MAIN);
"num"	return(INT);
"horof"	return(CHAR);
"dotnum"	return(FLOAT);
"pow"	return(POW);
"facto"	return(FACTO);
"checkprime"	return(PRIME);
"read"	return(READ);
"output" return(OUT);
"scan:" return(INPUT);
"switch"	return(SWITCH);
"state"	return(CASE);
"Null"  return(nul);
"ret"   return(RET);
"AND"   return(AND);
"OR"    return(OR);
"NOT"   return(NOT);
"fi:"	return(IF);
"elfi:"	return(ELIF);
"else:"	return(ELSE);
"for:"  return(FOR);
"while:"  return(WHILE);
"++"	return(INC);
"--"	return(DEC);
"max"	return(MAX);
"default" return(DEFAULT);
"min"	return(MIN);
","     return(COMMA);
{HEADER}  {
  yylval.uni_var.str = strdup(yytext);
  return HEADER;}





{var_name}	{yylval.uni_var.str = strdup(yytext); return(ID);}

{integer_number} { yylval.uni_var.ival = atoi(yytext);
  yylval.uni_var.fval = 0.0;
  yylval.uni_var.type = "int";
  return INTNUM;
}

{realnumber}	{yylval.uni_var.fval = atof(yytext);
yylval.uni_var.ival = 0;
yylval.uni_var.type = "float";
return REALNUM;
}

"("     return(FBS);
")"     return(FBC);
"{"     return(SBS);
"}"     return(SBC);
";"     return(SCOLON);
":"     return(COLON);
"+"		return(PLUS);
"-"		return(MINUS);
"*"		return(MUL);
"/"		return(DIV);
"="     return(ASSIGN);
"=="	return(EQUAL);
"!="	return(NOTEQUAL);
">"		return(GT);
">="	return(GAE);
"<"		return(LT);
"<="	return(LAE);
[--].*	printf("\nSingle line comment detected. \n");
[\n]	{}
{whitesp}	{}


%% 
