unit ASDPNR;
interface
uses Lexer, SyntaxAnalyzer,utilToken,GrammarSymbols,SyntaxTree;

procedure initAsdpnr(var tas:T_TAS;var stc:Stack;var t:Token; var pStack:P_Stack;var root:TNodePointer);

implementation

procedure initAsdpnr(var tas:T_TAS;var stc:Stack;var t:Token; var pStack:P_Stack;var root:TNodePointer);
var 	X,i,j,teof : GrammarSymbol;
	a : CompLex;
	next:boolean;	
	auxS:Stack;
	auxP:P_Stack;
	l:SymbolList;
	current,np,nn:TNodePointer;
begin
	pop(stc,X);
	p_pop(pStack,current);
	while X<>T_EOF do
	begin
		a := t.compLex;
		if (X in [T_PROGRAM..T_EOF]) then
		begin
			if X = a then
			begin
				next := true;
				setNodeAsLeaf(current,t.lexem);
				break;
			end
			else
			begin
				writeln('---error a---');
				break;
			end;	
		end;
		if (X in [S..CYCLE]) then
		begin
			if (isNotDefined(tas[X,a])) then
			begin
			 	writeln('---error b---');
			 	break;
			end
			else
			begin
				
				initStack(auxS);
				initPStack(auxP);
			 	l := tas[X,a];
			 	while(l.current<>nil) do
			 	begin
			 
			 		getCurrent(l,i);
			 		initTree(nn,i);
			 		addChild(current,nn);
			 		if i <> EPSILON then
			 		begin
			 			push(auxS,i);
			 			p_push(auxP,nn);
			 			
			 		end;
			 		moveNext(l);
			 	end;
			 	goToFirst(l);
			 	while (isEmpty(auxS) = false) do
			 	begin
			 		pop(auxS,j);
			 		p_pop(auxP,np);
			 		push(stc,j);
			 		p_push(pStack,np);
			 	end;
			 end;
			 pop(stc,X);
			 p_pop(pStack,current);
		end;
	end;
end;
end.
	
