program Test2;

uses
Lexer, LexemHandler, SyntaxAnalyzer, utilToken,GrammarSymbols,SysUtils,crt,ASDPNR,SyntaxTree,strutils,SymbolTable,Interpreter;

var 	text:string;
	count: integer;
	aToken:Token;
	stc:Stack;
	pstc:P_Stack;
	root,teof_n,fs_n:TNodePointer;
	teof,fs,x : GrammarSymbol;
	tas : T_TAS;
	sTable:Table;
Begin	
	count := 1;
	fillTas(tas);
	text := 'program test; begin I := 1; A := [1,2,3]; While (I<=10) do A := CONS(I,A); I := I + FIRST(A); endwhile; end.$';
	initStack(stc);
	initPStack(pstc);
	teof := T_EOF;
	push(stc,teof);
	initTree(teof_n,teof);
	p_push(pstc,teof_n);
	fs := S;
	push(stc,fs);
	initTree(fs_n,fs);
	p_push(pstc,fs_n);
	root := fs_n;
	initTable(sTable);
	while (count < Length(text)) do
	begin
		lexer_token(text,count,aToken,sTable);
		initAsdpnr(tas,stc,aToken,pstc,root);
	end;
	pop(stc,x);
	writeln(x);
	writeln('----arbol----');
	preorder(root,' ');
	writeln('---ejecucion---');
	evalS(root,sTable);
	writeln('----simbolos----');
	showSymbolTable(sTable);
	
end.
