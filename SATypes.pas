unit SATypes;
interface

uses GrammarSymbols;

Type
	
	TasNodePointer = ^TasNode;
	TasNode = record
		elem:GrammarSymbol;
		next:TasNodePointer;
		end;
	SymbolList = record
		size:integer;
		head:TasNodePointer;
		end;
	T_Tas = array [S..CYCLE,T_PROGRAM..T_EOF] of SymbolList;
	Stack = record
		size : integer;
		top:TasNodePointer;
		end;
	
	TNodePointer = ^TreeNode;
	
	ChildListPointer = ^Node;
	
	Node = record
		elem:TNodePointer;
		next:ChildListPointer;	
	end;
	
	ChildNodeList = record
			head:ChildListPointer;
			size:integer;
		end;
	
	TreeNode = record
		elem:GrammarSymbol;
		parent:TNodePointer;
		childList:ChildNodeList;
		end;
	SyntaxTree = record
		root:TNodePointer;
	end;
	
	{NodeListPointer = ^Node;
	
	TNodePointer = ^TreeNode;
	
	SyntaxTree = record 
		root : TNodePointer;
		end;
	
	Node = record
		nodeElem:TNodePointer;
		next:NodeListPointer
		end;
	
	NodeList = record
		size:integer;
		head:NodeListPointer;
		end;
		
	TreeNode = record
		elem:GrammarSymbol;
		childList:NodeList;
		parent:TNodePointer;
		end;}
		
		

{procedure initTas(tas:T_Tas);}
procedure initSymbolList(var l: SymbolList);
procedure showList(var l :SymbolList);
procedure initChildList(var l: ChildNodeList);
procedure showChildList(var n :ChildNodeList);
procedure addToSymbolList(var l:SymbolList;newElem:GrammarSymbol);
procedure addToChildList(var l:ChildNodeList;var newElem:TNodePointer);
procedure fillTas(var tas:T_Tas);
procedure initStack(var stack:Stack);
procedure pop(var stack:Stack;var aTop:GrammarSymbol);
procedure push(var stack:Stack;var newElem:GrammarSymbol);
procedure initTree(var tree:SyntaxTree);
procedure addRoot(var t:SyntaxTree; var newElem:GrammarSymbol);
procedure showTree(var t:SyntaxTree);
procedure addChild(var t:SyntaxTree;var newElem:GrammarSymbol);


implementation

procedure initSymbolList(var l: SymbolList);
begin
	l.head := nil;
	l.size := 0;
end;
procedure initChildList(var l: ChildNodeList);
begin
	l.head := nil;
	l.size := 0;
end;

procedure addToSymbolList(var l:SymbolList;newElem:GrammarSymbol);
var
dir, ant, act :TasNodePointer;
begin
	New(dir);
	dir^.elem := newElem;
	if(l.head = nil) then
	begin
		dir^.next := nil;
		l.head := dir;
	end
	else
	begin
		act := l.head^.next;
		ant := l.head;
		while (act<>nil) do
		begin
			act:=act^.next;
			ant := ant^.next;
		end;
		dir^.next := act;
		ant^.next := dir;
	end;
	Inc(l.size);
end;	

procedure showList(var l :SymbolList);
var act: TasNodePointer;
begin
	act := l.head;
	if(act = nil) then
	begin
		WRITELN('ERROR');
	end
	else
	begin
		while(act<>nil) do
		begin
			writeln(act^.elem);
			act := act^.next;
		end;
	end;
end;

procedure addToChildList(var l:ChildNodeList;var newElem:TNodePointer);
var
dir, ant, act :ChildListPointer;
begin
	New(dir);
	dir^.elem := newElem;
	if(l.head = nil) then
	begin
		dir^.next := l.head;
		l.head := dir;
	end
	else
	begin
		act := l.head^.next;
		ant := l.head;
		while (act<>nil) do
		begin
			act:=act^.next;
			ant := ant^.next;
		end;
		dir^.next := act;
		ant^.next := dir;
	end;
	Inc(l.size);
end;	

procedure showChildList(var n :ChildNodeList);
var act: ChildListPointer;
begin
	act := n.head;
	if(act = nil) then
	begin
		WRITELN('ERROR');
	end
	else
	begin
		while(act<>nil) do
		begin
			writeln(act^.elem^.elem);
			act := act^.next;
		end;
	end;
	
end;


procedure initStack(var stack:Stack);
begin
	stack.top := nil;
end;

procedure pop(var stack:Stack;var aTop:GrammarSymbol);

begin
	aTop:=stack.top^.elem;
	stack.top := stack.top^.next;
	stack.size := stack.size - 1;
	
end;

procedure push(var stack:Stack; var newElem:GrammarSymbol);
var aux :TasNodePointer;
begin
	New(aux);	
	aux^.elem := newElem;
	aux^.next := stack.top;
	stack.top := aux;
	stack.size := stack.size + 1;
end;
procedure initTree(var tree:SyntaxTree);
begin
	tree.root := nil;
	
end;

procedure addRoot(var t:SyntaxTree;var newElem:GrammarSymbol);
var aux:TNodePointer;
auxChildList:ChildNodeList;

begin
	new(aux);
        aux^.elem := newElem;
        aux^.parent := nil;
        initChildList(auxChildList);
        aux^.childList := auxChildList;
        t.root := aux;
        writeln(t.root^.elem);
end;

procedure showTree(var t:SyntaxTree);
var aux : ChildListPointer;

begin
	writeln('raiz',t.root^.elem);
	
	
end;

procedure addChild(var t:SyntaxTree;var newElem:GrammarSymbol);
var child : TNodePointer;
    auxChildList:ChildNodeList;
begin
	new(child);
	child^.elem := newElem;
	child^.parent := t.root;
	auxChildList := t.root^.childList;
	addToChildList(auxChildList,child);
	t.root^.childList := auxChildList;
	
end;    
    
procedure fillTas(var tas:T_Tas);
var list: SymbolList;
begin	
	{S}
	initSymbolList(list);
	addToSymbolList(list,T_PROGRAM);
	addToSymbolList(list,IDENTIFIER);
	addToSymbolList(list,SEMI);
	addToSymbolList(list,T_BEGIN);
	addToSymbolList(list,BODY);
	addToSymbolList(list,T_END);
	tas[S,T_PROGRAM] := list;
   	{BODY}
	initSymbolList(list);
	addToSymbolList(list,SENT);
	addToSymbolList(list,SEMI);
	addToSymbolList(list,RRSENT);
	tas[BODY,IDENTIFIER] := list;
	tas[BODY,READINT] := list;
	tas[BODY,READLIST] := list;
	tas[BODY,WRITEINT] := list;
	tas[BODY,WRITELIST] := list;
	tas[BODY,T_IF] := list;
	tas[BODY,T_WHILE] := list;
	{RRSENT}
	initSymbolList(list);
	addToSymbolList(list,SENT);
	addToSymbolList(list,SEMI);
	addToSymbolList(list,RRSENT);
	tas[RRSENT,IDENTIFIER] := list;
	tas[RRSENT,READINT] := list;
	tas[RRSENT,READLIST] := list;
	tas[RRSENT,WRITEINT] := list;
	tas[RRSENT,WRITELIST] := list;
	tas[RRSENT,T_IF] := list;
	tas[RRSENT,T_WHILE] := list;
	initSymbolList(list);
	addToSymbolList(list,EPSILON);
	tas[RRSENT,T_END] := list;
	{SENT}
	initSymbolList(list);
	addToSymbolList(list,ASIG);
	tas[SENT,IDENTIFIER] := list;
	initSymbolList(list);
	addToSymbolList(list,V_READ);
	tas[SENT,READINT] := list;
	tas[SENT,READLIST] := list;
	initSymbolList(list);
	addToSymbolList(list,V_WRITE);
	tas[SENT,WRITEINT] := list;
	tas[SENT,WRITELIST] := list;
	initSymbolList(list);
	addToSymbolList(list,CONDITIONAL);
	tas[SENT,T_IF] := list;
	initSymbolList(list);
	addToSymbolList(list,CYCLE);
	tas[SENT,T_WHILE] := list;
	{ASIG}
	initSymbolList(list);
	addToSymbolList(list,IDENTIFIER);
	addToSymbolList(list,ASIGOP);
	addToSymbolList(list,EXPR);
	tas[ASIG,IDENTIFIER] := list;
	{ASIGOP}
	initSymbolList(list);
	addToSymbolList(list,ASSIG);
	tas[ASIGOP,ASSIG] := list;
	{EXPR}
	initSymbolList(list);
	addToSymbolList(list,EXPARIT);
	tas[EXPR,IDENTIFIER] := list;
	tas[EXPR,OPPAR] := list;
	tas[EXPR,CONSTANT] := list;
	tas[EXPR,FIRST] := list;
	initSymbolList(list);
	addToSymbolList(list,V_LIST);
	tas[EXPR,OPBRA] := list;
	tas[EXPR,REST] := list;
	tas[EXPR,CONS] := list;
	{EXPARIT}
	initSymbolList(list);
	addToSymbolList(list,TERM);
	addToSymbolList(list,RRTERM);
	tas[EXPARIT,IDENTIFIER] := list;
	tas[EXPARIT,OPPAR] := list;
	tas[EXPARIT,CONSTANT] := list;
	tas[EXPARIT,FIRST] := list;
	tas[EXPARIT,CONSTANT] := list;
	{RRTERM}
	initSymbolList(list);	
	addToSymbolList(list,SUMOP);
	addToSymbolList(list,TERM);
	addToSymbolList(list,RRTERM);
	tas[RRTERM,PLUS] := list;
	tas[RRTERM,MINUS] := list;
	initSymbolList(list);
	addToSymbolList(list,EPSILON);
	tas[RRTERM,SEMI] := list;
	{SUMOP}
	initSymbolList(list);
	addToSymbolList(list,PLUS);
	tas[SUMOP,PLUS] := list;
	initSymbolList(list);
	addToSymbolList(list,MINUS);
	tas[SUMOP,MINUS] := list;
	{TERM}
	initSymbolList(list);
	addToSymbolList(list,FACTOR);
	addToSymbolList(list,RRFACTOR);
	tas[TERM,IDENTIFIER] := list;
	tas[TERM,OPPAR] := list;
	tas[TERM,CONSTANT] := list;
	tas[TERM,FIRST] := list;
	{RRFACTOR}
	initSymbolList(list);
	addToSymbolList(list,MULTOP);
	addToSymbolList(list,FACTOR);
	addToSymbolList(list,RRFACTOR);
	tas[RRFACTOR,MULT] := list;
	tas[RRFACTOR,DIVI] := list;
	initSymbolList(list);
	addToSymbolList(list,EPSILON);
	tas[RRFACTOR,PLUS] := list;
	tas[RRFACTOR,MINUS] := list;
	{MULTOP}
	initSymbolList(list);
	addToSymbolList(list,MULT);
	addToSymbolList(list,DIVI);
	tas[MULTOP,MULT] := list;
	tas[MULTOP,DIVI] := list;
	{FACTOR}
	initSymbolList(list);
	addToSymbolList(list,IDENTIFIER);
	tas[FACTOR,IDENTIFIER] := list;
	initSymbolList(list);
	addToSymbolList(list,OPPAR);
	addToSymbolList(list,EXPARIT);
	addToSymbolList(list,CLPAR);
	tas[FACTOR,OPBRA] := list;
	initSymbolList(list);
	addToSymbolList(list,CONSTANT);
	tas[FACTOR,CONSTANT] := list;
	initSymbolList(list);
	addToSymbolList(list,FIRST);
	addToSymbolList(list,OPPAR);
	addToSymbolList(list,V_LIST);
	addToSymbolList(list,CLPAR);
	tas[FACTOR,FIRST] := list;
	{List}
	initSymbolList(list);
	addToSymbolList(list,OPBRA);
	addToSymbolList(list,LISTCONST);
	addToSymbolList(list,CLBRA);
	tas[V_LIST,OPBRA] := list;
	initSymbolList(list);
	addToSymbolList(list,REST);
	tas[V_LIST,REST] := list;
	initSymbolList(list);
	addToSymbolList(list,CONS);
	tas[V_LIST,CONS] := list;
	{LISTCONST}
	initSymbolList(list);
	addToSymbolList(list,CONSTANT);
	addToSymbolList(list,RRINTCONST);
	tas[LISTCONST,CONSTANT] := list;
	{RRINTCONST}
	initSymbolList(list);
	addToSymbolList(list,COMMA);
	addToSymbolList(list,RRINTCONST);
	tas[RRINTCONST,COMMA] := list;
	initSymbolList(list);
	addToSymbolList(list,EPSILON);
	tas[RRINTCONST,CLBRA] := list;
	{REST}
	initSymbolList(list);
	addToSymbolList(list,REST);
	addToSymbolList(list,OPPAR);
	addToSymbolList(list,LISTARG);
	addToSymbolList(list,CLPAR);
	tas[V_REST,REST] := list;
	{LISTARG}
	initSymbolList(list);
	addToSymbolList(list,IDENTIFIER);
	tas[LISTARG,IDENTIFIER] := list;
	initSymbolList(list);
	addToSymbolList(list,V_LIST);
	tas[LISTARG,OPBRA] := list;
	tas[LISTARG,REST] := list;
	tas[LISTARG,CONS] := list;
	{Cons}
	initSymbolList(list);
	addToSymbolList(list,CONS);
	addToSymbolList(list,OPPAR);
	addToSymbolList(list,EXPARIT);
	addToSymbolList(list,COMMA);
	addToSymbolList(list,LISTARG);
	addToSymbolList(list,CLPAR);
	tas[V_CONS,CONS] := list;
	{READ}
	initSymbolList(list);
	addToSymbolList(list,READINT);
	addToSymbolList(list,OPPAR);
	addToSymbolList(list,IARG);
	addToSymbolList(list,CLPAR);
	tas[V_READ,READINT] := list;
	initSymbolList(list);
	addToSymbolList(list,READLIST);
	addToSymbolList(list,OPPAR);
	addToSymbolList(list,IARG);
	addToSymbolList(list,CLPAR);
	tas[V_READ,READLIST] := list;
	{WRITE}
	initSymbolList(list);
	addToSymbolList(list,WRITEINT);
	addToSymbolList(list,OPPAR);
	addToSymbolList(list,OARG);
	addToSymbolList(list,CLPAR);
	tas[V_WRITE,WRITEINT] := list;
	initSymbolList(list);
	addToSymbolList(list,WRITELIST);
	addToSymbolList(list,OPPAR);
	addToSymbolList(list,OARG);
	addToSymbolList(list,CLPAR);
	tas[V_WRITE,WRITELIST] := list;
	{IARG}
	initSymbolList(list);
	addToSymbolList(list,T_STRING);
	addToSymbolList(list,COMMA);
	addToSymbolList(list,IDENTIFIER);
	tas[IARG,T_STRING] := list;
	{OARG}
	initSymbolList(list);
	addToSymbolList(list,T_STRING);
	addToSymbolList(list,COMMA);
	addToSymbolList(list,EXPR);
	tas[OARG,T_STRING] := list;
	{CONDITIONAL}
	initSymbolList(list);
	addToSymbolList(list,T_IF);
	addToSymbolList(list,CONDITION);
	addToSymbolList(list,T_THEN);
	addToSymbolList(list,BODY);
	addToSymbolList(list,CLOSEIF);
	tas[CONDITIONAL,T_IF] := list;
	{CONDITION}
	initSymbolList(list);
	addToSymbolList(list,V_NEG);
	addToSymbolList(list,C);
	addToSymbolList(list,LOG);
	tas[CONDITION,IDENTIFIER] := list;
	tas[CONDITION,OPPAR] := list;
	tas[CONDITION,CONSTANT] := list;
	tas[CONDITION,FIRST] := list;
	tas[CONDITION,NEG] := list;
	tas[CONDITION,NULL] := list;
	{NEG}
	initSymbolList(list);
	addToSymbolList(list,EPSILON);
	tas[V_NEG,IDENTIFIER] := list;
	tas[V_NEG,OPPAR] := list;
	tas[V_NEG,CONSTANT] := list;
	tas[V_NEG,FIRST] := list;
	tas[V_NEG,NULL] := list;
	{C}
	initSymbolList(list);
	addToSymbolList(list,EXPARIT);
	addToSymbolList(list,RELOP);
	addToSymbolList(list,EXPARIT);
	tas[C,IDENTIFIER] := list;
	tas[C,OPPAR] := list;
	tas[C,CONSTANT] := list;
	tas[C,FIRST] := list;
	initSymbolList(list);
	addToSymbolList(list,NULL);
	addToSymbolList(list,OPPAR);
	addToSymbolList(list,V_LIST);
	addToSymbolList(list,CLPAR);
	{RELOP}
	initSymbolList(list);
	addToSymbolList(list,GT);
	tas[RELOP,GT] := list;
	initSymbolList(list);
	addToSymbolList(list,LT);
	tas[RELOP,LT] := list;
	initSymbolList(list);
	addToSymbolList(list,GTE);
	tas[RELOP,GTE] := list;
	initSymbolList(list);
	addToSymbolList(list,LTE);
	tas[RELOP,LTE] := list;
	initSymbolList(list);
	addToSymbolList(list,EQ);
	tas[RELOP,EQ] := list;
	{LOG}
	initSymbolList(list);
	addToSymbolList(list,LOGOP);
	addToSymbolList(list,CONDITION);
	tas[LOG,T_AND] := list;
	tas[LOG,T_OR] := list;
	{LOGOP}
	initSymbolList(list);
	addToSymbolList(list,T_AND);
	tas[LOGOP,T_AND] := list;
	initSymbolList(list);
	addToSymbolList(list,T_OR);
	tas[LOGOP,T_OR] := list;
	{CLOSEIF}
	initSymbolList(list);
	addToSymbolList(list,V_ELSE);
	tas[CLOSEIF,T_ELSE] := list;
	initSymbolList(list);
	addToSymbolList(list,V_ENDIF);
	tas[CLOSEIF,T_ENDIF] := list;
	{ELSE}
	initSymbolList(list);
	addToSymbolList(list,T_ELSE);
	addToSymbolList(list,BODY);
	addToSymbolList(list,V_ENDIF);
	tas[V_ELSE,T_ELSE] := list;
	{ENDIF}
	initSymbolList(list);
	addToSymbolList(list,T_ENDIF);
	tas[V_ENDIF,T_ENDIF] := list;
	{CYCLE}
	initSymbolList(list);
	addToSymbolList(list,T_WHILE);
	addToSymbolList(list,OPPAR);
	addToSymbolList(list,CONDITION);
	addToSymbolList(list,CLPAR);
	addToSymbolList(list,T_DO);
	addToSymbolList(list,BODY);
	addToSymbolList(list,T_ENDWHILE);
	tas[CYCLE,T_WHILE] := list;
end;
end.
	
