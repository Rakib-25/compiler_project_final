main:
	bison -d fp.y
	flex fp.l
	gcc lex.yy.c fp.tab.c