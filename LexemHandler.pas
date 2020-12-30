unit LexemHandler;

interface

uses utilToken, Lexer,SymbolTable,GrammarSymbols;

var
	idx : integer;
	line:string;
	aToken:Token;
	currentChar : char;
	lexem : string;
	lineTokens : TokenList;
	error, found: boolean;
	
procedure advance(var idx:integer;var line:string; var currentChar:char);
procedure peek(idx: integer; var line:string; var lexem:String);
procedure lexer_token(var line:string;var idx:integer;var aToken:Token;var sTable:Table);


implementation

procedure advance(var idx: integer; var line:string; var currentChar:char);
begin
	idx := idx+1;
	currentChar := line[idx];
end;

procedure peek(idx: integer; var line:string; var lexem:String);
var aux:integer;
    	
begin
	aux := idx+1;

	if line[aux] = '=' then
	begin
		lexem := lexem + line[aux];
		
		idx := idx + 2;
		
	end; 
	
end;

procedure lexer_token(var line:string;var idx:integer;var aToken:Token;var sTable:Table);
var
found:boolean;	
	
function isCharASymbol(aChar:char):boolean;
begin
	case aChar of
	'+','-','*','/','[',']','(',')',':','=',',',';','>','<','"': isCharASymbol := true;
	else
		isCharASymbol := false;
	end;
end;

function isReserved(word:string):boolean;
begin
	case word of
	'do','then','else','program','end.','begin','while','if','endwhile','endif','$': isReserved := true;
	else
		isReserved := false;
	end;
end;
Begin
	found := false;
	lexem := '';
	while line[idx] = ' ' do 
	begin
		idx := idx + 1;
	end;
	currentChar := line[idx];
	if isCharASymbol(currentChar) = false then
	begin
		while (isCharASymbol(line[idx]) = false) do
		begin
			if currentChar = ' ' then
			begin
				if isReserved(lexem) = true then
				begin
					idx := idx + 1;
					break;
				end;
				idx := idx + 1;
				currentChar := line[idx];
			end
			else 
			begin
				lexem := lexem + currentChar;
				if isReserved(lexem) = true then
				begin
					idx := idx + 1;
					break;
				end;
				idx := idx + 1;
				currentChar := line[idx];
				
			end;
		end;
		if lexem <> ' ' then
		begin
			getNextToken(lexem,aToken,found);
			{showToken(aToken);}
			if aToken.compLex = IDENTIFIER then
			begin
				contains(sTable,aToken.lexem,found);
				if found = false then 
				begin
					addToSTable(sTable,aToken.lexem);
				end;
			end;
			currentChar := ' ';	
		end;
	end;
	if isCharASymbol(currentChar) = true then
	begin
		if  (currentChar = '<') OR (currentChar = '>') OR (currentChar = ':')   then
		begin
			lexem := line[idx];
			if line[idx+1] = '=' then 
			begin
				lexem := lexem+line[idx+1];
				getNextToken(lexem,aToken,found);
				{showToken(aToken);}
				idx := idx + 1;
			end
			else
			begin	
				getNextToken(lexem,aToken,found);
				{showToken(aToken);}
			end;
		end
		else 
		begin
			if currentChar = '"' then
			begin
				lexem := lexem + currentChar;
				idx := idx + 1;
				currentChar := line[idx];
				while currentChar <> '"' do
				begin
					lexem := lexem + line[idx];
					idx := idx + 1;
					currentChar := line[idx];
				end;
				lexem := lexem + currentChar;
				getNextToken(lexem,aToken,found);
				{showToken(aToken);}
			end
			else	
			begin
				lexem := lexem + line[idx];
				getNextToken(lexem,aToken,found);
				{showToken(aToken);}
			end;
		end;
		idx := idx + 1;
	end;
end;
end.





