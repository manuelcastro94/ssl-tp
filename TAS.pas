unit TAS;
interface
uses
	utilToken;
Type

	TasNodePointer = ^TasNode;
	TasNode = record
		elem:integer;
		next:NodePointer;
		end;
	GrammarSymbolsList = record
		size:integer;
		head:TasNodePointer;
		end;
	T_Tas = array [S..CYCLE,T_PROGRAM..T_EOF] of GrammarSymbolsList;
	
	Stack = record
		top:TasNodePointer;
		end;
	
procedure initTas(tas:T_Tas);


	
implementation


begin
end.	
