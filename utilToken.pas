unit utilToken;
interface
uses GrammarSymbols;
Type
	CompLex = T_PROGRAM..T_EOF;
	
	Token = record
		lexem:string;
		compLex: CompLex;
		end;
	NodePointer = ^Node;
	Node = record
		elem:Token;
		next:NodePointer;
		end;
	TokenList = record
		size:integer;
		head:NodePointer;
		end;
	
		
procedure setToken(var t:Token;var lex:string;cL:CompLex);
procedure showToken(var t:Token);
procedure newTokenList(var l:TokenList);
procedure addToTokenList(var l:TokenList; newElem:Token);

implementation

procedure setToken(var t:Token;var lex:string;cL:CompLex);
begin
	t.lexem := lex;
	t.compLex := cL;	
end;
procedure showToken(var t:Token);
begin
	WriteLn('Lexem: ',t.lexem);
	WriteLn('CompLex: ',t.compLex);	
end;
procedure newTokenList(var l:TokenList);
begin
	l.head := nil;
	l.size := 0;
end;

procedure addToTokenList(var l:TokenList; newElem:Token);
var
dir, ant, act :NodePointer;
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
End.

