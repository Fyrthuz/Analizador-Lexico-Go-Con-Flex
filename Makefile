CC= gcc -Wall
HEADER_FILES_DIR = .
INCLUDES = -I $(HEADER_FILES_DIR)
MAIN= compilador
SRCS = main.c lex.yy.c analizadorsintactico.c estructura.c tablasimbolos.c gestionerrores.c
DEPS = $(HEADER_FILES_DIR)/lex.yy.h analizadorsintactico.h estructura.h definiciones.h tablasimbolos.h gestionerrores.h
OBJS = $(SRCS:.c=.o)
$(MAIN): $(OBJS)
	$(CC) -o $(MAIN) $(OBJS) -g
	rm -f *.o *~
%.o: %.c $(DEPS)
	$(CC) -c $< $(INCLUDES)
cleanall: clean
	rm -f $(MAIN)
clean:
	rm -f *.o *~
