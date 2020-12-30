unit Lexer;
interface
uses 
	sysutils,crt,strutils,utilToken, GrammarSymbols;

procedure isReserved (var lexem: string; var token:Token ; var found:boolean);
procedure isArit (var lexem: string; var token:Token ; var found:boolean);	
procedure isRel (var lexem: string; var token:Token ; var found:boolean);
procedure isLog (var lexem: string; var token:Token ; var found:boolean);
procedure isConstant (var lexem: string; var token:Token ; var found:boolean);
procedure isIdentifier (var lexem: string; var token:Token ; var found:boolean);
procedure isString (var lexem: string; var token:Token ; var found:boolean);
procedure isSymbol (var lexem: string; var token:Token ; var found:boolean);
procedure isList (var lexem: string; var token:Token ; var found:boolean);
procedure getNextToken(var lexem: string; var token:Token ; var found:boolean);
	
implementation

procedure isReserved (var lexem: string; var token:Token ; var found:boolean);

begin
     lexem:=upcase(lexem); {todo en upcase}
     case lexem of
     'PROGRAM': begin
     		setToken(token,lexem,T_PROGRAM);
     		found := true;
     		end;
     'BEGIN': begin
     		setToken(token,lexem,T_BEGIN);
     		found := true;
     		end;
     'END.': begin
     		setToken(token,lexem,T_END);
     		found := true;
     		end;
     'IF': begin
     		setToken(token,lexem,T_IF);
     		found := true;
     		end;
     'THEN': begin
     		setToken(token,lexem,T_THEN);
     		found := true;
     		end;
     'ENDIF': begin
     		setToken(token,lexem,T_ENDIF);
     		found := true;
     		end;
     'ELSE': begin
     		setToken(token,lexem,T_ELSE);
     		found := true;
     		end;
     'DO': begin
     		setToken(token,lexem,T_DO);
     		found := true;
     		end;
     'WHILE': begin
     		setToken(token,lexem,T_WHILE);
     		found := true;
     		end;
     'ENDWHILE': begin
     		setToken(token,lexem,T_ENDWHILE);
     		found := true;
     		end;
     'READINT': begin
     		setToken(token,lexem,READINT);
     		found := true;
     		end;
     'READLIST': begin
     		setToken(token,lexem,READLIST);
     		found := true;
     		end;
     'WRITEINT': begin
     		setToken(token,lexem,WRITEINT);
     		found := true;
     		end;
     'WRITELIST' : begin
     		setToken(token,lexem,WRITELIST);
     		found := true;
     		end;	
      '$' 	: begin
     		setToken(token,lexem,T_EOF);
     		found := true;
     		end;
     end;
      
end;

procedure isArit (var lexem: string; var token: Token; var found:boolean);
begin
     lexem:=upcase(lexem); {todo en upcase}
     case lexem of
     '+' : begin
     		setToken(token,lexem,PLUS);
		found := true;
		end;
     '-' : begin
     		setToken(token,lexem,MINUS);
		found := true;
		end;
     '/' : begin
     		setToken(token,lexem,DIVI);
		found := true;
		end;
     '*' : begin
     		setToken(token,lexem,MULT);
		found := true;
		end;
	end;		
end;

procedure isRel (var lexem: string; var token: Token; var found:boolean);
begin
     lexem:=upcase(lexem); {todo en upcase}
     case lexem of
     '>' : begin
     		setToken(token,lexem,GT);
		found := true;
		end;
     '<' : begin
     		setToken(token,lexem,LT);
		found := true;
		end;
     '=' : begin
     		setToken(token,lexem,EQ);
		found := true;
		end;
     '>=' : begin
     		setToken(token,lexem,GTE);
		found := true;
		end;
     '<=' : begin
     		setToken(token,lexem,LTE);
		found := true;
		end;
	end;		
end;

procedure isLog (var lexem: string; var token: Token; var found:boolean);
begin
     lexem:=upcase(lexem); {todo en upcase}
     case lexem of
     'AND' : begin
     		setToken(token,lexem,T_AND);
		found := true;
		end;
     'OR' : begin
     		setToken(token,lexem,T_OR);
		found := true;
		end;
     'NEG' : begin
     		setToken(token,lexem,NEG);
		found := true;
		end;
	end;
end;

procedure isSymbol (var lexem: string; var token: Token; var found:boolean);
begin
     	lexem:=upcase(lexem);
	case lexem of
     	',': begin
     		setToken(token,lexem,COMMA);
     		found := true;
     		end;
     	';': begin
     		setToken(token,lexem,SEMI);
     		found := true;
     		end;
     	':=':begin
     		setToken(token,lexem,ASSIG);
     		found := true;
     		end;
     	'(': begin
     		setToken(token,lexem,OPPAR);
     		found := true;
     		end;
     	')': begin
     		setToken(token,lexem,CLPAR);
     		found := true;
     		end;
     	'[': begin
     		setToken(token,lexem,OPBRA);
     		found := true;
     		end;
     	']': begin
     		setToken(token,lexem,CLBRA);
		found := true;
		end;
	end;
end;

procedure isList (var lexem: string; var token: Token; var found:boolean);
begin
	lexem:=upcase(lexem);
	case lexem of
	'REST':begin
     	        setToken(token,lexem,REST);
		found := true;
		end;
	'CONS':begin
     	        setToken(token,lexem,CONS);
		found := true;
		end;
	'FIRST':begin
     	        setToken(token,lexem,FIRST);
		found := true;
		end;
	'NULL' :begin
     	        setToken(token,lexem,NULL);
		found := true;
		end; 
	end;
end;

procedure isIdentifier (var lexem: string; var token: Token; var found:boolean);
Const
	q0 = 0;
	F = 1;
	
Type
	Q = 0..2;
	Sigma = (letter, digit, underScore, other);
	DeltaType = Array[Q,Sigma] of Q;
Var
	control: Integer;
	actualState: Q;	
	delta:DeltaType;
Function charToSymb(aChar: Char):Sigma;
Begin
	Case aChar of
		'a'..'z','A'..'Z':charToSymb := letter;
		'0'..'9':charToSymb := digit;
		'_':charToSymb := underScore;
	else
		charToSymb := other;
	end;
end;
Begin
	delta[0,letter] := 1;
	delta[0,digit] := 2;
	delta[0,underScore] := 1;
	delta[0,other] := 2;
	delta[1,letter] := 1;
	delta[1,digit] := 1;
	delta[1,other] := 2;
	delta[1,underScore] := 1; 
	
	actualState := q0;
	for control := 1 to Length(lexem) do
		actualState := delta[actualState, charToSymb(lexem[control])];
	if actualState = F then
	begin
		setToken(token,lexem,IDENTIFIER);
          	found:= true;
	end;
end;

procedure isConstant (var lexem: string; var token: Token; var found:boolean);
Const
	q0 = 0;
	F = 1;
	
Type
	Q = 0..3;
	Sigma = (digit, minus,other);
	DeltaType = Array[Q,Sigma] of Q;
Var
	control: Integer;
	actualState: Q;	
	delta:DeltaType;
Function charToSymb(aChar: Char):Sigma;
Begin
	Case aChar of
		'-':charToSymb := minus;
		'0'..'9':charToSymb := digit;
	else
		charToSymb := other;
	end;
end;
Begin
	found := false;
	delta[0,digit] := 1;
	delta[0,minus] := 2;
	delta[0,other] := 3;
	delta[1,digit] := 1;
	delta[1,other] := 3;
	delta[1,minus] := 3;
	delta[2,digit] := 1;
	delta[2,minus] := 3;
	delta[2,other] := 3; 
	
	actualState := q0;
	for control := 1 to Length(lexem) do
		actualState := delta[actualState, charToSymb(lexem[control])];
	if actualState = F then
	begin
		setToken(token,lexem,CONSTANT);
          	found:= true;
	end;
end;

procedure isString (var lexem: string; var token:Token ; var found:boolean);
Const
	q0 = 0;
	F = 2;
	
Type
	Q = 0..3;
	Sigma = (text, other, quotes);
	DeltaType = Array[Q,Sigma] of Q;
Var
	control: Integer;
	actualState: Q;	
	delta:DeltaType;
Function charToSymb(aChar: Char):Sigma;
Begin
	Case aChar of
		'"':charToSymb := quotes;
		'0'..'9','a'..'z','A'..'Z':charToSymb := text;
	else
		charToSymb := other;
	end;
end;
Begin
	found := false;
	delta[0,quotes] := 1;
	delta[0,text] := 3;
	delta[0,other] := 3;
	delta[1,text] := 1;
	delta[1,other] := 1;
	delta[1,quotes] := 2;
	delta[2,text] := 3;
	delta[2,quotes] := 3;
	delta[2,other] := 3; 
	
	actualState := q0;
	for control := 1 to Length(lexem) do
		actualState := delta[actualState, charToSymb(lexem[control])];
	if actualState = F then
	begin
		setToken(token,lexem,T_STRING);
          	found:= true;	
	end;
	
end;

procedure getNextToken(var lexem:string; var token:Token; var found:boolean);
begin
	found := false;
	isReserved(lexem, token, found);
	if found = false then
	begin
		isList(lexem,token,found);
	end;
	if found = false then
	begin
		isLog(lexem,token,found);
	end;
	if found = false then
	begin
		isIdentifier(lexem,token,found);
	end;
	if found = false then
	begin
		isString(lexem,token,found);
	end; 
	if found = false then
	begin
		isConstant(lexem,token,found);
	end;
	if found = false then
	begin
		isSymbol(lexem,token,found);
	end;
	if found = false then
	begin
		isArit(lexem,token,found);
	end;
	if found = false then
	begin
		isRel(lexem,token,found);
	end;
	if found = false then
	begin
		Writeln('error lexico',lexem);
	end; 
end;


End.
