# Analizador-Lexico-Go
Instrucciones ejecucion

Utilizar el comando "dos2unix *" para que se pueda ejecutar en sistemas Linux de manera apropiada y no de ningún tipo de fallo (aunque no debería darlo de todos modos solo por si acaso ya que desarrollé el código en Windows)

Compilar flex

flex --header-file="lex.yy.h" lex.l

Añadimos las cabeceras de las funciones y de la struct a lex.yy.h

[AUNQUE CON ESTA VERSION SEGUN COMO ESTA PUEDES OMITIR ESTE PASO, ES POR SI QUERÉIS COMPILAR POR VUESTRA CUENTA, SI LO HACEIS TENEIS QUE METER LAS FUNCIONES DECLARADAS EN EL .l EN EL .h generado]

Comando para producir el ejecutable ----> make

Nombre del ejecutable -----> compilador
x
Documento con el output(esta no se produce durante la ejecución del código la subo como documento anexo) -----> salida.txt

Comando time(para medir el tiempo de ejecucion) ----> time ./compilador <archivo> para medir el tiempo de ejecución

Comando valgrind(para controlar que se libera toda la memoria) ----> valgrind ./compilador <archivo> para comprobar que libera toda la memoria

Comando para ejecutarlo normal --.-> ./compilador <archivo>

Especificaciones tecnicas

Tabla de Simbolos: Arbol binario de búsqueda


Documentación Go:
https://go.dev/ref/spec#Keywords
