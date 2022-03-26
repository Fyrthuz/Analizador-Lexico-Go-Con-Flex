#include <stdio.h>
#include <stdlib.h>

#include "analizadorsintactico.h"
#include "tablasimbolos.h"
#include "gestionerrores.h"
#include "lex.yy.h"

int main(int argc,char **argv){
    //Pasamos como parametros el nombre del fichero, de otro modo ocurre un error
    if(argc!=2){
      errorParametros();
    }
    //Abrimos el fichero en el lex.yy.
    abrirfichero(argv[1]);
    //Inicializamos la tabla de simbolos
    inicializarTabla();
    //Empezamos a analizar el codigo
    analizar_codigo();
    //Cerramos y liberamos los recursos utilizados por flex
    cerrar();

    //Liberamos la tabla de símbolos y liberamos el sistema de sistema de entrada
    //liberando también los recursos utilizados
    eliminarTabla();
    return 0;

}
