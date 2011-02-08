/* Redcode Grammar
 * Author: Stephen Halter
 * Created: 2-8-10
 * The grammar was derived from http://corewar.co.uk/icws94.htm the
 * Annotated Draft of the Proposed 1994 Core War Standard
 */

/* tokens */
%lex

%%
[ \t]+                          /* skip whitespace */
";"[^\n\r]                      /* skip comment */

("DAT"|"MOV"|"ADD"|"SUB"|"MUL"|
"DIV"|"MOD"|"JMP"|"JMZ"|"JMN"|
"DJN"|"CMP"|"SLT"|"SPL"|"ORG"|
"EQU"|"END")                    return 'OPCODE';

("AB"|"BA"|"A"|"B"|"F"|"X"|"I") return 'MODIFIER';
("#"|"$"|"@"|"<"|">")           return 'MODE';
[a-zA-Z_]\w*                    return 'LABEL';
[+-]?\d+                        return 'NUMBER';
"."                             return '.';
","                             return ',';
"("                             return '(';
")"                             return ')';
"+"                             return '+';
"-"                             return '-';
"*"                             return '*';
"/"                             return '/';
"%"                             return '%';
(\n|\r|\n\r|\r\n)               return 'NEWLINE';
<<EOF>>                         return 'EOF';

/lex
%start redcode
%%

redcode
    : instruction
    | eol
    | instruction redcode
    | eol redcode
    ;

instruction
    : label_list operation mode expr
    | label_list operation mode expr ',' mode expr
    | operation mode expr
    | operation mode expr ',' mode expr
    ;

label_list
    : label
    | label label_list
    | label NEWLINE label_list
    ;

label
    : LABEL
    | MODIFIER
    ;

operation
    : OPCODE
    | OPCODE '.' MODIFIER
    ;

mode
    : MODE
    | 
    ;

expr
    : term
    | term '+' expr
    | term '-' expr
    | term '*' expr
    | term '/' expr
    | term '%' expr
    ;

term
    : label
    | NUMBER
    | '(' expr ')'
    ;

eol
    : NEWLINE
    | EOF
    ;
