%{
/*Definiciones necesarias*/
#include "tablasimbolos.h"
#include "gestionerrores.h"
#include "definiciones.h"

typedef struct{
 char *lexema;
 short tipo;
}comp_lexico;

void cerrar();
void abrirfichero(char* fichero);
short siguiente_comp_lexico(comp_lexico *lex);

%}

%option yylineno
%option noyywrap

NUEVALINEA \n
ESPACIO [ ]
SEPARADOR (\t|\r|{ESPACIO})+
LETRA [a-zA-Z]
CARACTER_ID {LETRA}|_
CARACTER_UNICODE .
PUNTO_Y_COMA ;

NUMERO_DECIMAL [0-9]
NUMERO_OCTAL [0-7]
NUMERO_BINARIO [0-1]
NUMERO_HEXADECIMAL[0-9a-fA-F]



DECIMAL_DIGITS {NUMERO_DECIMAL}(([_])?{NUMERO_DECIMAL})*
DECIMAL_LIT (0|([1-9](([_])?{DECIMAL_DIGITS})?))

BINARY_DIGITS {NUMERO_BINARIO}(([_])?{NUMERO_BINARIO})*
BINARY_LIT (0[bB][_]?{BINARY_DIGITS})

OCTAL_DIGITS {NUMERO_OCTAL}(([_])?{NUMERO_OCTAL})*
OCTAL_LIT (0[Oo]?[_]?{OCTAL_DIGITS})

HEX_DIGITS {NUMERO_HEXADECIMAL}(([_])?{NUMERO_HEXADECIMAL})*
HEX_LIT (0[xX][_]?{HEX_DIGITS})

INT_LIT {DECIMAL_LIT}|{HEX_LIT}|{BINARY_LIT}|{OCTAL_LIT}



DECIMAL_FLOAT_LIT {DECIMAL_DIGITS}\.{DECIMAL_DIGITS}?{DECIMAL_EXPONENT}?|{DECIMAL_DIGITS}{DECIMAL_EXPONENT}|\.{DECIMAL_DIGITS}{DECIMAL_EXPONENT}?
DECIMAL_EXPONENT [eE][+-]?{DECIMAL_DIGITS}

HEX_FLOAT_LIT 0[Xx]{HEX_MANTISA}{HEX_EXPONENT}
HEX_EXPONENT [pP][+-]?{DECIMAL_DIGITS}
HEX_MANTISA [_]?{HEX_DIGITS}\.{HEX_DIGITS}?|[_]?{HEX_DIGITS}|\.{HEX_DIGITS}

FLOAT_LIT {DECIMAL_FLOAT_LIT}|{HEX_FLOAT_LIT}

IMAGINARY_LIT {DECIMAL_DIGITS}i|{INT_LIT}i|{FLOAT_LIT}i

IDENTIFICADOR [a-zA-Z_][a-zA-Z0-9_]*


OPERADORSIMPLE [+*/%&|^,.:!><=(){}[\]-]|{PUNTO_Y_COMA}
OPERADORASIGNACION :=
OPERADORSUMAASIGNACION \+=
OPERADORFLECHA <-
AUTOADD \+\+
AUTOSUBSTRACT --
RESTAYASIGNACION -=
MULTYASIGNACION \*=
DIVYASIGNACION \/=
MODYASIGNACION %=
ESIGUAL ==
AMPERSANDIGUAL &=
AMPERSANDAMPERSAND &&
AMPERSANDELEVADO &^
AMPERSANDELEVADOIGUAL &^=
OR \|\|
ORIGUAL \|=
ELEVADOIGUAL ^=
EXCLAMACIONIGUAL !=
MENORMENOR <<
MENORIGUAL <=
MENORMENORIGUAL <<=
MAYORIGUAL >=
MAYORMAYOR >>
MAYORMAYORIGUAL >>=


/*Rune literals*/
ESCAPED_CHAR \\[a|b|f|n|r|t|v|\\|'|"]
BIG_U_VALUE \\U([0-9]|[a-f]|[A-F]){8}
LITTLE_U_VALUE \\u([0-9]|[a-f]|[A-F]){4}
HEX_BYTE_VALUE \\x([0-9]|[a-f]|[A-F]){2}
OCTAL_BYTE_VALUE \\([0-7]){3}
BYTE_VALUE {OCTAL_BYTE_VALUE}|{HEX_BYTE_VALUE}
UNICODE_VALUE {LITTLE_U_VALUE}|{BIG_U_VALUE}|{ESCAPED_CHAR}|{CARACTER_UNICODE}

/*String literals*/
INTERPRETED_STRING_LIT ["]({UNICODE_VALUE}|{BYTE_VALUE})+["]
RAW_STRING_LIT [`]({CARACTER_UNICODE}|{NUEVALINEA})+[`]
STRING_LIT ({RAW_STRING_LIT}|{INTERPRETED_STRING_LIT})

/*COMENTARIOS*/
COMENTARIO_LINEA_ \/\/.*
COMENTARIO_CELDA_ \/\*(.|{NUEVALINEA})*\*\/

%%
{SEPARADOR}
{IDENTIFICADOR} {return(ID);}
{INT_LIT} {return(ENTERO);}
{FLOAT_LIT} {return(FLOTANTE);}
{IMAGINARY_LIT} {return(IMAGINARIO);}
{STRING_LIT} {return(STRING);}
{NUEVALINEA} {return('\n');}
{COMENTARIO_LINEA_}
{COMENTARIO_CELDA_}
{OPERADORSIMPLE} {return((int)*yytext);}
{OPERADORASIGNACION} {return(ASIGNACION);}
{OPERADORSUMAASIGNACION} {return(SUMA_Y_ASIGNACION);}
{OPERADORFLECHA} {return(OPERADOR_FLECHA);}
{AUTOADD} {return(AUTOSUMA);}
{AUTOSUBSTRACT} {return(AUTORESTA);}
{RESTAYASIGNACION} {return(RESTA_Y_ASIGNACION);}
{MULTYASIGNACION} {return(MULT_Y_ASIGNACION);}
{DIVYASIGNACION} {return(DIV_Y_ASIGNACION);}
{MODYASIGNACION} {return(MOD_Y_ASIGNACION);}
{ESIGUAL} {return(ES_IGUAL);}
{AMPERSANDIGUAL} {return(AMPERSAND_IGUAL);}
{AMPERSANDAMPERSAND} {return(AMPERSAND_AMPERSAND);}
{AMPERSANDELEVADO} {return(AMPERSAND_ELEVADO);}
{OR} {return(OR);}
{ORIGUAL} {return(OR_IGUAL);}
{EXCLAMACIONIGUAL} {return(EXCLAMACION_IGUAL);}
{MENORMENOR} {return(MENOR_MENOR);}
{MENORIGUAL} {return(MENOR_IGUAL);}
{MAYORIGUAL} {return(MAYOR_IGUAL);}
{MAYORMAYOR} {return(MAYOR_MAYOR);}
. {return(-3);}
<<EOF>> {return(-1);}
%%

void abrirfichero(char* fichero){
 if((yyin = fopen(fichero, "r")) == NULL) perror("No se pudo abrir el fichero.\n");
}

void cerrar(){
 fclose(yyin);
 yylex_destroy();
}

short siguiente_comp_lexico(comp_lexico *lex){
 lex->tipo = yylex();
 if(lex->lexema!=NULL){
  free(lex->lexema);
  lex->lexema = NULL;
 }
 lex->lexema = (char*)malloc((strlen(yytext)+1)*sizeof(char));
 lex->lexema[strlen(yytext)]='\0';
 strncpy(lex->lexema,yytext,strlen(yytext));
 if(lex->tipo==-3){
  errorLexico(yylineno);
 }else if(lex->tipo==ID){
  lex->tipo=insertar_buscaEnTabla(lex->lexema,ID);
 }else if(lex->tipo==-1){//Si hay -1 hemos llegado al EOF
  return EOF;
 }
 return lex->tipo;
}
