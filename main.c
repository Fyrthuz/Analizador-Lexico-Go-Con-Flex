#include <stdio.h>
#include <stdlib.h>

#include "lex.yy.h"
#include "analizadorsintactico.h"
#include "tablasimbolos.h"
//ALT+SHIFT+T

int main(int argc,char **argv){
    if(argc<2){
      printf("No introdujo el fichero a analizar\n");
      exit(0);
    }
    abrirfichero(argv[1]);
    inicializarTabla();
    analizar_codigo();

    eliminarTabla();
    cerrar();
    return 0;

}
