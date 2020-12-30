unit SyntaxTreeList;
interface
uses
Lexer, GrammarSymbols;
type
	
	
	LNodePointer = ^LNode;
	
	TNodePointer = ^TreeNode;
	
	LNode = record
		l_elem: TNodePointer;
		next : LNodePointer;
		end;
	
	NodeList = record
		size:integer;
		head:LNodePointer;
		current:LNodePointer;
		end;
	
	TreeNode = record
		troot:GrammarSymbol;
		children:NodeList;
		end;
procedure initTreeNode(var t:TNodePointer; var newRoot:GrammarSymbol);
procedure initChildList(var l:NodeList);
procedure addChild(var t:TNodePointer; var newElem:TNodePointer);
procedure addToChildList(var l:NodeList;var newElem:TNodePointer);
procedure getCurrentNode(var l:NodeList; var elem:TNodePointer);
procedure moveNextNode(var l:NodeList);
procedure goToFirstNode(var l:NodeList);
function preorder(var t:TNodePointer):GrammarSymbol;
implementation

procedure initTreeNode(var t:TNodePointer; var newRoot:GrammarSymbol);
var list:NodeList;
begin
	writeln('entro');
	t^.troot := newRoot;
	writeln('asigno raiz');
	initChildList(list);

	t^.children := list;
end;

procedure initChildList(var l:NodeList);
begin
	l.head := nil;
	l.current := l.head;
	l.size := 0;
end;

procedure addChild(var t:TNodePointer; var newElem:TNodePointer);
begin
	addToChildList(t^.children,newElem);
end;

procedure addToChildList(var l:NodeList;var newElem:TNodePointer);
var
dir, ant, act :LNodePointer;
begin
	New(dir);
	dir^.l_elem := newElem;
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

procedure getCurrentNode(var l:NodeList; var elem:TNodePointer);
begin
	elem := l.current^.l_elem;
end;

procedure moveNextNode(var l:NodeList);
begin
	l.current := l.current^.next;
end;

procedure goToFirstNode(var l:NodeList);
begin
	l.current := l.head;
end;


function preorder(var t:TNodePointer):GrammarSymbol;
var result:GrammarSymbol;
    l:NodeList;	
begin
	if t^.children.head = nil then
	begin
		preorder := t^.troot;
		writeln(t^.troot);
	end
	else
	begin
		l := t^.children;
		goToFirstNode(l);
		getCurrentNode(l,t);
		preorder := preorder(t);
		moveNextNode(l);
	end;	 
	
end;
end.

