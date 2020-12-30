unit SyntaxTree;
interface
uses
Lexer, GrammarSymbols;
type
	
	TNodePointer = ^TreeNode;
	
	TreeNode = record
		elem:GrammarSymbol;
		lexem:string;
		parent:TNodePointer;
		leftChild:TNodePointer;
		rightBro:TNodePointer;
		end;
	
procedure initTree(var t:TNodePointer; var root:GrammarSymbol);
procedure setNodeAsLeaf(var t:TNodePointer; var lexem:string);
procedure showTreeNode(var t:TNodePointer);
procedure getParent(var t:TNodePointer; var parent:TNodePointer);
procedure getLeftChild(var t:TNodePointer; var lc:TNodePointer);
procedure getRightBro(var t:TNodePointer; var rb:TNodePointer);
procedure addChild(var t:TNodePointer; var newNode:TNodePointer);
procedure preorder(var t:TNodePointer;s:string);
procedure addLeftChild(var t:TNodePointer; var newNode:TNodePointer);
procedure addRightBro(var t:TNodePointer; var newNode:TNodePointer);

implementation

procedure initTree(var t:TNodePointer; var root:GrammarSymbol);
var aux:TNodePointer;
begin
	new(aux);
	aux^.elem := root;
	aux^.lexem := '';
	aux^.parent := nil;
	aux^.leftChild := nil;
	aux^.rightBro := nil;
	t := aux;
end;

procedure setNodeAsLeaf(var t:TNodePointer; var lexem:string);
begin
	t^.lexem := lexem;
end;


procedure getParent(var t:TNodePointer; var parent:TNodePointer);
begin
	parent := t^.parent;
end;
procedure getLeftChild(var t:TNodePointer; var lc:TNodePointer);
begin
	lc := t^.leftChild;
end;
procedure getRightBro(var t:TNodePointer; var rb:TNodePointer);
begin
	rb := t^.rightBro;
end;

procedure addChild(var t:TNodePointer; var newNode:TNodePointer);
var current:TNodePointer;
begin
	if t^.leftChild = nil then
	begin
		addLeftChild(t,newNode);
	end
	else
	begin
		current := t^.leftChild;
		while current^.rightBro <> nil do
		begin
			current := current^.rightBro;
		end; 
		addRightBro(current,newNode);
	end;
end;


procedure addLeftChild(var t:TNodePointer; var newNode:TNodePointer);

begin
	newNode^.parent := t;
	newNode^.rightBro := t^.leftChild;
	newNode^.leftChild := nil;
	t^.leftChild := newNode;
	
end;
procedure addRightBro(var t:TNodePointer; var newNode:TNodePointer);

begin
	newNode^.parent := t^.parent;
	newNode^.rightBro := t^.rightBro;
	newNode^.leftChild := nil;
	t^.rightBro := newNode;
end;

procedure showTreeNode(var t:TNodePointer);
begin
	write(t^.lexem,' ');
	write(t^.elem);
	
end;


Procedure preorder(var t:TNodePointer; s:string);
begin
	if t <> nil then
	begin
		if t^.lexem <> '' then
		begin
			writeln(s,t^.lexem);
		end
		else
		begin
			writeln(s,t^.elem);
		end;

		preorder(t^.leftChild,s+' |  ');
		preorder(t^.rightBro,s);
	end
end;

end.




