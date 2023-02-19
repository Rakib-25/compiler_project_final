%{
  #include<stdio.h>
	#include<math.h>
	#include<string.h>
    #include<limits.h>
    #include<float.h>
	void yyerror(const char *);
	extern int yylex();
    extern int yyparse();
    extern FILE *yyin;
	extern FILE *yyout;
    
  typedef struct {
    char *name;
    char *data_type;
    int ival;
    float fval;
  }value;
  value symbol_table[200];

  int index=0;
  int if_check = 0;
  int check = 0;
  int sw = 0;
  int find_symbol_table_index(char *var);
  void assignment(char *name, int ival, float fval, char *type);
%}


%start program
%token MAIN INT FLOAT CHAR POW FACTO PRIME READ PRINT SWITCH CASE DEFAULT
%token IF ELIF ELSE WHILE INC DEC MAX MIN COMMA PLUS MINUS MUL DIV
%token ASSIGN EQUAL FUNC HEADER NOTEQUAL GT GAE LT LAE ID REALNUM INTNUM FBS FBC SBS
%token SBC SCOLON COLON INPUT OUT nul RET AND OR FOR NOT BITWISEAND BITWISEOR
%union {
  struct abc {
    int ival;
    float fval;
    char *str;
    char *type;
  }uni_var;
}
%type<uni_var> ID INTNUM REALNUM VALUE HEADER statement block expression2
%left PLUS MINUS
%left MUL DIV MOD
%left POW

%%	  	
program: 
       |program statement 
       |
        ;			    

statement: 
          declaration
          |expression2
          |print
          |in
          |if
          |while
          |for
          |head
          |function
          |function_call
          |switch
          |case
          ;


switch  :
        SWITCH FBS VALUE FBC {
        sw = $3.ival;
        check = 0;
        printf("switch statement.\n");
    }
    ;

case    :
        cases
        {
        if(check == 0)
        {
            printf("default value\n");
        }
        }
        ;

cases   :
        CASE VALUE COLON FBS statement FBC cases{
        if(sw==$2.ival)
        {
            printf("Matched with case %d\n",$2.ival);
            check = 1;
        }

    }
    |CASE VALUE COLON FBS statement SBS default_function {
        
        if(sw==$2.ival)
        {
            printf("Matched with case %d\n",$2.ival);
            check = 1;
        }
    }
    ;

default_function:
    DEFAULT FBS statement SBS {
    }
    ;



function:
    TYPE ID FBS statement FBC SBS block {
      if(strcmp($2.str, "principle") == 0)
      {
          printf("Main function declared.\n");
      }
      else
      {
          printf("User defined function declared.\n");
      }
    }
    |TYPE MAIN FBS FBC SBS block{
        printf("\nmain function end\n");
    }
    ;


function_call:
    ID FBS expression2 FBC 
    |ID FBS FBC
    ;

head     :HEADER{printf("\n %s is included\n",$1.str);}

print   :OUT FBS VALUE FBC {
        if (strcmp($3.type, "int") == 0) printf("%d\n", $3.ival);
        else if (strcmp($3.type, "float") == 0) printf("%.2lf\n", $3.fval);
          }
        | OUT FBS VALUE FBC {
        printf("%s\n", $3.str);
      }
      ;

in    :INPUT FBS ID FBC {
      int i = find_symbol_table_index($3.str);
      if (i != index) {
        printf("Enter value for %s := ", symbol_table[i].name);
        if (strcmp(symbol_table[i].data_type, "int") == 0) {
          scanf("%d", &symbol_table[i].ival);
        }
        else if (strcmp(symbol_table[i].data_type, "float") == 0) {
          scanf("%f", &symbol_table[i].fval);
        }
      }
      else {
        printf("Variable not declared\n");
      }
    }
    ;
    

expression2:
           ID ASSIGN VALUE {assignment($1.str, $3.ival, $3.fval, $3.type);}
           |ID INC {
            int i = find_symbol_table_index($1.str);
            if (i != index) {
              symbol_table[i].ival = symbol_table[i].ival + 1;
              symbol_table[i].fval = symbol_table[i].fval + 1.0;
            }
           }


           |ID DEC {
            int i = find_symbol_table_index($1.str);
            if (i != index) {
              symbol_table[i].ival = symbol_table[i].ival - 1;
              symbol_table[i].fval = symbol_table[i].fval - 1.0;
            }
           }

           | ID {assignment($1.str, 0, 0.0, "int");}



declaration:
            TYPE expression1
            ;

TYPE :
     INT
     |FLOAT
     ;

expression1 :
            expression1 COMMA expression
            | expression
            ; 

expression:
          ID ASSIGN VALUE {assignment1($1.str, $3.ival, $3.fval, $3.type);}
          ;
VALUE:
          INTNUM  {$$.ival = $1.ival, $$.type = $1.type;}
          |REALNUM {$$.fval = $1.fval, $$.type = $1.type;}
          |ID {
            int i = 0;
            for (i = 0; i < index; i++) {
              if (strcmp($1.str, symbol_table[i].name) == 0) {
                $$.ival = symbol_table[i].ival, $$.fval = symbol_table[i].fval, $$.type = symbol_table[i].data_type;
                break;
              }
            }
            if (i == index) printf("NOT FOUND\n");
          }
          | VALUE OR VALUE {
            if (strcmp($1.type, "int")==0) {
              $$.ival = ($1.ival || $3.ival);
              $$.fval = $1.fval, $$.type = $1.type;
            }
          }
          | VALUE AND VALUE {
            if (strcmp($1.type, "int")==0) {
              $$.ival = ($1.ival && $3.ival);
              $$.fval = $1.fval, $$.type = $1.type;
            }
          }
          /* | VALUE BITWISEXOR VALUE {
            if (strcmp($1.type, "int")==0) {
              $$.ival = $1.ival ^ $3.ival;
              $$.fval = $1.fval, $$.type = $1.type;
            } */
          
          | VALUE BITWISEAND VALUE {
            if (strcmp($1.type, "int")==0) {
              $$.ival = $1.ival & $3.ival;
              $$.fval = $1.fval, $$.type = $1.type;
            }
          }
          /* | VALUE BITWISEXOR VALUE {
            if (strcmp($1.type, "int")==0) {
              $$.ival = $1.ival ^ $3.ival;
              $$.fval = $1.fval, $$.type = $1.type;
            }
          } */
          | VALUE BITWISEOR VALUE {
            if (strcmp($1.type, "int")==0) {
              $$.ival = $1.ival | $3.ival;
              $$.fval = $1.fval, $$.type = $1.type;
            }
          }
          | VALUE EQUAL VALUE {
            if (strcmp($1.type, "int")==0) {
              if ($1.ival == $3.ival) $$.ival = 1, $$.fval = 1.0;
              else $$.ival = 0, $$.fval = 0.0;
              $$.type = $1.type;
            }
            else if (strcmp($1.type, "float") == 0) {
              if ($1.fval == $3.fval) $$.fval = 1.0, $$.ival = 1;
              else $$.fval = 0.0, $$.ival = 0;
              $$.type = $1.type;
            }
          }
          | VALUE NOTEQUAL VALUE {
            if (strcmp($1.type, "int")==0) {
              if ($1.ival != $3.ival) $$.ival = 1, $$.fval = 1.0;
              else $$.ival = 0, $$.fval = 0.0;
              $$.type = $1.type;
            }
            else if (strcmp($1.type, "float") == 0) {
              if ($1.fval != $3.fval) $$.fval = 1.0, $$.ival = 1;
              else $$.fval = 0.0, $$.ival = 0;
              $$.type = $1.type;
            }
          }
          | VALUE LT VALUE {
            if (strcmp($1.type, "int")==0) {
              if ($1.ival < $3.ival) $$.ival = 1, $$.fval = 1.0;
              else $$.ival = 0, $$.fval = 0.0;
              $$.type = $1.type;
            }
            else if (strcmp($1.type, "float") == 0) {
              if ($1.fval < $3.fval) $$.fval = 1.0, $$.ival = 1;
              else $$.fval = 0.0, $$.ival = 0;
              $$.type = $1.type;
            }
          }
          | VALUE LAE VALUE {
            if (strcmp($1.type, "int")==0) {
              if ($1.ival <= $3.ival) $$.ival = 1, $$.fval = 1.0;
              else $$.ival = 0, $$.fval = 0.0;
              $$.type = $1.type;
            }
            else if (strcmp($1.type, "float") == 0) {
              if ($1.fval <= $3.fval) $$.fval = 1.0, $$.ival = 1;
              else $$.fval = 0.0, $$.ival = 0;
              $$.type = $1.type;
            }
          }
          | VALUE GT VALUE {
            if (strcmp($1.type, "int")==0) {
              if ($1.ival > $3.ival) $$.ival = 1, $$.fval = 1.0;
              else $$.ival = 0, $$.fval = 0.0;
              $$.type = $1.type;
            }
            else if (strcmp($1.type, "float") == 0) {
              if ($1.fval > $3.fval) $$.fval = 1.0, $$.ival = 1;
              else $$.fval = 0.0, $$.ival = 0;
              $$.type = $1.type;
            }
          }
          | VALUE GAE VALUE {
            if (strcmp($1.type, "int")==0) {
              if ($1.ival >= $3.ival) $$.ival = 1, $$.fval = 1.0;
              else $$.ival = 0, $$.fval = 0.0;
              $$.type = $1.type;
            }
            else if (strcmp($1.type, "float") == 0) {
              if ($1.fval >= $3.fval) $$.fval = 1.0, $$.ival = 1;
              else $$.fval = 0.0, $$.ival = 0;
              $$.type = $1.type;
            }
          }


          | VALUE PLUS VALUE     { $$.ival = $1.ival + $3.ival, $$.fval = $1.fval + $3.fval; }
          | VALUE MINUS VALUE     { $$.ival = $1.ival - $3.ival, $$.fval = $1.fval - $3.fval; }
          | VALUE MUL VALUE     { $$.ival = $1.ival * $3.ival, $$.fval = $1.fval * $3.fval; }
          | VALUE DIV VALUE     { $$.ival = $1.ival / $3.ival, $$.fval = $1.fval / $3.fval; }
          | '(' VALUE ')'            { $$.ival = $2.ival; $$.ival }
          ;



block:
     statement block
     |statement SBC {$$.ival=$1.ival;}
     ;

if:
    IF FBS VALUE FBC SBS block {
      if($3.ival)
      {
          if_check=1;
          printf("\nIf statement will be executed.\n");
      }
      if(if_check!=1)
      {
          printf("\nElse statement will be executed.\n");
      }
    }
    | IF FBS VALUE FBC SBS block else {
      if($3.ival)
      {  
          if_check=1;
          printf("\nIf statement will be executed.\n");
      }
      if(if_check!=1)
      {
          printf("\nElse statement will be executed.\n");
      }
    }
    ;

else:
    ELSE SBS block {}
    ;

while:
    WHILE FBS VALUE FBC SBS block {
      while($3.ival)
      {
          printf("Inside while loop\n");
      }
    }
    ;

for:
    FOR FBS statement SCOLON VALUE SCOLON expression2 FBC SBS block{
      printf("for loop executed");
    }
    ;







%%


void yyerror(const char *s) {
    fprintf(stderr, "%s\n", s);
}

int find_symbol_table_index(char *var)
{
  int i;
  for (i = 0; i < index; i++) {
    if (strcmp(symbol_table[i].name, var) == 0) return i;
  }
  printf("\nid was not declared\n");
}

int find_symbol_table_index1(char *var)
{
  int i;
  for (i = 0; i < index; i++) {
    if (strcmp(symbol_table[i].name, var) == 0) printf("\n**multiple declaration**\n");
  }
  return index;
}
void assignment(char *name, int ival, float fval, char *type)
{
  int i = find_symbol_table_index(name);
  symbol_table[i].data_type = type;
  symbol_table[i].name = name;
  symbol_table[i].ival = ival;
  symbol_table[i].fval = fval;

  if (i == index) index++;
}

void assignment1(char *name, int ival, float fval, char *type)
{
  int i = find_symbol_table_index1(name);
  symbol_table[i].data_type = type;
  symbol_table[i].name = name;
  symbol_table[i].ival = ival;
  symbol_table[i].fval = fval;
  if (i == index) index++;

}


int main()
{    
    yyin = fopen("input2.txt","r");
    yyout = fopen("output.txt","w");
    yyparse();

}