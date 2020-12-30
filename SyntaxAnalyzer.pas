unit SyntaxAnalyzer;
interface

uses GrammarSymbols,SyntaxTree;

Type
	
	TasNodePointer = ^TasNode;
	TasNode = record
		elem:GrammarSymbol;
		next:TasNodePointer;
		end;
	SymbolList = record
		size:integer;
		head:TasNodePointer;
		current:TasNodePointer;
		end;
	T_Tas = array [S..CYCLE,T_PROGRAM..T_EOF] of SymbolList;
	Stack = record
		size : integer;
		top:TasNodePointer;
		end;
	PNodePointer = ^PNode;
	PNode = record
		p_elem:TNodePointer;
		next: PNodePointer;
		end;
		
	P_Stack = record
		p_size : integer;
		p_top:PNodePointer;
	end;
		
{procedure initTas(tas:T_Tas);}

{list}
procedure initSymbolList(var l: SymbolList);
procedure getCurrent(var l:SymbolList; var elem:GrammarSymbol);
procedure moveNext(var l:SymbolList);
procedure goToFirst(var l:SymbolList);
procedure showList(var l :SymbolList);
function isNotDefined(var l:SymbolList):boolean;
{tas}
procedure fillTas(var tas:T_Tas);
procedure addToSymbolList(var l:SymbolList;newElem:GrammarSymbol);
{stack}
procedure initStack(var s:Stack);
procedure initPStack(var s:P_Stack);
procedure pop(var s:Stack;var aTop:GrammarSymbol);
procedure p_pop(var s:P_Stack;var aTop:TNodePointer);
procedure p_pop_v(var s:P_Stack);
procedure push(var s:Stack;var newElem:GrammarSymbol);
procedure p_push(var s:P_Stack; var newElem:TNodePointer);
function isEmpty(var s:Stack):boolean;
{tree}

implementation

procedure initSymbolList(var l: SymbolList);
begin
	l.head := nil;
	l.current := l.head;
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
		l.current := l.head;
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

procedure getCurrent(var l:SymbolList; var elem:GrammarSymbol);
begin
	elem := l.current^.elem;
end;

procedure moveNext(var l:SymbolList);
begin
	l.current := l.current^.next;
end;

procedure goToFirst(var l:SymbolList);
begin
	l.current := l.head;
end;

function isNotDefined (var l:SymbolList):boolean;
begin
	if l.head = nil then
	begin
		isNotDefined := true;
	end
	else
	begin
		isNotDefined := false;
	end;
end;

function isEmpty(var s:Stack):boolean;
begin
	if s.top = nil then
	begin
		isEmpty := true;
	end
	else
	begin
		isEmpty := false;
	end;
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



procedure initStack(var s:Stack);
begin
	s.top := nil;
end;

procedure initPStack(var s:P_Stack);
begin
	s.p_top := nil;
end;


procedure pop(var s:Stack;var aTop:GrammarSymbol);
var aux:TasNodePointer;
begin
	aTop := s.top^.elem;
	s.top := s.top^.next;
	s.size := s.size - 1;
end;

procedure p_pop(var s:P_Stack;var aTop:TNodePointer);

begin
	aTop := s.p_top^.p_elem;
	s.p_top := s.p_top^.next;
	s.p_size := s.p_size - 1;
end;

procedure p_pop_v(var s:P_Stack);
begin
	if s.p_top^.next <> nil then 
	begin
		s.p_top := s.p_top^.next;
		s.p_size := s.p_size - 1;
	end;
end;

procedure push(var s:Stack; var newElem:GrammarSymbol);
var aux :TasNodePointer;
begin
	New(aux);	
	aux^.elem := newElem;
	aux^.next := s.top;
	s.top := aux;
end;
procedure p_push(var s:P_Stack; var newElem:TNodePointer);
var aux :PNodePointer;
begin
	New(Aux);
	aux^.p_elem := newElem;
	aux^.next := s.p_top;
	s.p_top := aux;
end;

{procedure initTas(var tas: T_TAS);
var
    i: S..CYCLE;
    j: T_PROGRAM..T_EOF;
begin
    for j := T_PROGRAM to T_EOF do
    begin
        for i := S to CYCLE do
        begin
            tas[i,j] :=  ;
        end;
    end;
end;
    }
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
	tas[RRSENT,T_EOF] := list;
	tas[RRSENT,T_ENDWHILE] := list;
	tas[RRSENT,T_ENDIF] := list;
	tas[RRSENT,T_ELSE] := list;
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
	addToSymbolList(list,ASSIG);
	addToSymbolList(list,EXPR);
	tas[ASIG,IDENTIFIER] := list;
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
	tas[RRTERM,COMMA] := list;
	tas[RRTERM,CLPAR] := list;
	tas[RRTERM,GT] := list;
	tas[RRTERM,LT] := list;
	tas[RRTERM,EQ] := list;
	tas[RRTERM,GTE] := list;
	tas[RRTERM,LTE] := list;
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
	tas[RRFACTOR,SEMI] := list;
	tas[RRFACTOR,COMMA] := list;
	tas[RRFACTOR,CLPAR] := list;
	tas[RRFACTOR,PLUS] := list;
	tas[RRFACTOR,MINUS] := list;
	tas[RRFACTOR,GT] := list;
	tas[RRFACTOR,LT] := list;
	tas[RRFACTOR,EQ] := list;
	tas[RRFACTOR,LTE] := list;
	tas[RRFACTOR,GTE] := list;
	{MULTOP}
	initSymbolList(list);
	addToSymbolList(list,MULT);
	tas[MULTOP,MULT] := list;
	initSymbolList(list);
	addToSymbolList(list,DIVI);
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
	addToSymbolList(list,V_REST);
	tas[V_LIST,REST] := list;
	initSymbolList(list);
	addToSymbolList(list,V_CONS);
	tas[V_LIST,CONS] := list;
	initSymbolList(list);
	addToSymbolList(list,IDENTIFIER);
	tas[V_LIST,IDENTIFIER] := list;
	
	{LISTCONST}
	initSymbolList(list);
	addToSymbolList(list,CONSTANT);
	addToSymbolList(list,RRINTCONST);
	tas[LISTCONST,CONSTANT] := list;
	{RRINTCONST}
	initSymbolList(list);
	addToSymbolList(list,COMMA);
	addToSymbolList(list,CONSTANT);
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
	addToSymbolList(list,OARGL);
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
	addToSymbolList(list,EXPARIT);
	tas[OARG,T_STRING] := list;
	{OARGL}
	initSymbolList(list);
	addToSymbolList(list,T_STRING);
	addToSymbolList(list,COMMA);
	addToSymbolList(list,LISTARG);
	tas[OARGL,T_STRING] := list;
	{CONDITIONAL}
	initSymbolList(list);
	addToSymbolList(list,T_IF);
	addToSymbolList(list,OPPAR);
	addToSymbolList(list,CONDITION);
	addToSymbolList(list,CLPAR);
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
	initSymbolList(list);
	addToSymbolList(list,EPSILON);
	tas[LOG,CLPAR] := list;
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
	
