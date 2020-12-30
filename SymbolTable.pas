unit SymbolTable;

interface
uses
	strutils,sysutils;
const
	maxSize = 47;	
type
	VarPointer = ^VarNode;
	VarNode = record
		key_var:string;
		var_value:string;
		next:VarPointer;
		end;
	VarList = record
		size:integer;
		head:VarPointer;
		current:VarPointer;
		end;
	Table = array[1..maxSize] of VarList;

	
procedure initTable(var t:Table);
procedure initVarList(var v:VarList);
procedure addToSTable(var t:Table;var aVar:string);
procedure addToSymbolList(var l:VarList; var aVar:string);
procedure addToTable(var t:Table;var aVar:string;var aValue:string);
procedure setValueOfVar(var t:Table; var aVar:string; var aValue:string);
procedure getVar(var t:Table;var aVar:string;var aValue:string);
procedure getCurrentSymbol(var l:VarList; var kv:string; var val:string);
procedure moveNext(var l:VarList);
procedure goToFirst(var l:VarList);
procedure showSymbolTable(var t:Table);
procedure showSymbolList(var l :VarList);
function isNotDefined (var l:VarList):boolean;
function hash(var s:string;m:integer):integer;
procedure contains(var t:Table;var lexem:string;var found:boolean);


implementation

procedure initTable(var t:Table);
var a:integer;
    v:VarList;
begin
	a := 1;
	for  a := 1 to maxSize do
		initVarList(v);
		t[a] := v;		
end;

procedure initVarList(var v:VarList);
begin
	v.head := nil;
	v.current := v.head;
	v.size := 0;
end;
procedure addToSTable(var t:Table;var aVar:string);
var idx:integer;
begin
	idx := hash(aVar,maxSize);
	addToSymbolList(t[idx],aVar);
	
end;
procedure addToSymbolList(var l:VarList; var aVar:string);
var
dir, ant, act :VarPointer;
begin
	New(dir);
	dir^.key_var := aVar;
	dir^.var_value := ' ';
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

procedure addToTable(var t:Table;var aVar:string;var aValue:string);
var 	idx:integer;
    	aux:VarList;
    	dir, ant, act :VarPointer;	
begin
	idx := hash(aVar,maxSize);
	aux := t[idx];
	New(dir);
	dir^.key_var := aVar;
	dir^.var_value := aValue;
	if(aux.head = nil) then
	begin
		dir^.next := nil;
		aux.head := dir;
		aux.current := aux.head;
	end
	else
	begin
		act := aux.head^.next;
		ant := aux.head;
		while (act<>nil) do
		begin
			act:=act^.next;
			ant := ant^.next;
		end;
		dir^.next := act;
		ant^.next := dir;
	end;
	Inc(aux.size);
end;
procedure setValueOfVar(var t:Table; var aVar:string; var aValue:string);
var idx:integer;
    ap:VarPointer;
begin
	idx := hash(aVar,maxSize);
	ap := t[idx].current;
	while ap^.key_var <> aVar do
	begin
		ap := ap^.next;
	end;
	ap^.var_value := aValue;
	goToFirst(t[idx]);
	
end;
procedure getVar(var t:Table;var aVar:string;var aValue:string);
var idx:integer;
    ap:VarPointer;	
begin
	idx := hash(aVar,maxSize);
	ap := t[idx].current;
	while ap^.key_var <> aVar do
	begin
		ap := ap^.next;
	end;
 	aValue := ap^.var_value;
	goToFirst(t[idx]);
	
end;

procedure getCurrentSymbol(var l:VarList; var kv:string; var val:string);
begin
	kv := l.current^.key_var;
	val := l.current^.var_value;
end;

procedure moveNext(var l:VarList);
begin
	l.current := l.current^.next;
end;

procedure goToFirst(var l:VarList);
begin
	l.current := l.head;
end;

procedure contains(var t:Table;var lexem:string;var found:boolean);
var
idx:integer;
    aux:VarList;
    ap:VarPointer;
begin
	found := false;
	idx := hash(lexem,maxSize);
	aux := t[idx];
	if aux.head = nil then
	begin
		found := false;
	end
	else
	begin
		ap := t[idx].current;
		while ap <> nil do
		begin
			if ap^.key_var = lexem then
			begin
				found := true;
				break;
			end;
			ap := ap^.next;
		end;
	end;
end;

function isNotDefined (var l:VarList):boolean;
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

procedure showSymbolTable(var t:Table);
var a:integer;
begin
	a := 1;
	for  a := 1 to maxSize do
	begin
		showSymbolList(t[a]);	
	end;
end;

procedure showSymbolList(var l :VarList);
var act: VarPointer;
begin
	act := l.head;
	if(act = nil) then
	begin
		WRITELN('-');
	end
	else
	begin
		while(act<>nil) do
		begin
			write(' ',act^.key_var);
			write('-> ');
			write('',act^.var_value);
			act := act^.next;
		end;
	end;
end;

function hash(var s:string;m:integer):integer;
var sdex:string;
    ch:char;
    subs:string;
    code:integer;
	
begin
	sdex := Soundex(s);
	ch := sdex[1];
	subs := copy(sdex,2,Length(sdex));
	if subs <> '000' then
	begin
		code := StrToInt(subs);
		hash := (ord(ch)*code) mod m;  
	end
	else
	begin
		hash := (ord(ch)) mod m;
	end;
	
end;

end.







