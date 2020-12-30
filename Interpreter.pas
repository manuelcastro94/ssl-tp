unit Interpreter;

interface
uses Lexer, LexemHandler, SyntaxAnalyzer, utilToken,GrammarSymbols,SysUtils,crt,ASDPNR,SyntaxTree,SymbolTable;
	

procedure evalS(var t:TNodePointer;var st:Table);
procedure evalBODY(var t:TNodePointer;var st:Table); 
procedure evalRRSENT(var t:TNodePointer;var st:Table);
procedure evalSENT(var t:TNodePointer;var st:Table);
procedure evalASIG(var t:TNodePointer;var st:Table);
procedure evalEXP(var t:TNodePointer;var st:Table;var result:real;var list:string);
procedure asignVar(var st:Table;var lexem:string; var result:real);
procedure asignList(var st:Table;var lexem:string; var list:string);
procedure evalEXPARIT(var t:TNodePointer;var st:Table;var result:real);
procedure evalRRTERM(var t:TNodePointer;var st:Table;var resTERM:real;var result:real);
procedure evalSUMOP(var t:TNodePointer;var resTERM:real;var resTERM2:real; var result:real);
procedure evalTERM(var t:TNodePointer;var st:Table;var resTERM:real);	
procedure evalRRFACTOR(var t:TNodePointer;var st:Table;var resF:real;var resTerm:real);
procedure evalMULTOP(var t:TNodePointer;var resF:real;var resF2:real; var result:real);
procedure evalFACTOR(var t:TNodePointer;var st:Table;var resF:real);
procedure evalLIST(var t:TNodePointer;var st:Table;var list:string);
procedure evalLISTCONST(var t:TNodePointer;var st:Table;var list:string);
procedure evalRRLISTCONST(var t:TNodePointer;var st:Table;var list:string);
procedure evalREST(var t:TNodePointer;var st:Table;var list:string);
procedure evalLISTARG(var t:TNodePointer;var st:Table;var list:string);
procedure evalCONS(var t:TNodePointer;var st:Table;var list:string);
procedure evalREAD(var t:TNodePointer;var st:Table);
procedure evalWRITE(var t:TNodePointer;var st:Table);
procedure evalIARGINT(var t:TNodePointer;var st:Table);
procedure evalIARGLIST(var t:TNodePointer;var st:Table);
procedure evalOARGINT(var t:TNodePointer;var st:Table);
procedure evalOARGLIST(var t:TNodePointer;var st:Table);
procedure evalCONDITIONAL(var t:TNodePointer;var st:Table);
procedure evalCONDITION(var t:TNodePointer;var st:Table;var condition:boolean);
{procedure evalNEG(var t:TNodePointer);}
procedure evalC(var t:TNodePointer;var st:Table;var condition:boolean);
procedure evalLOG(var t:TNodePointer;var st:Table;var condi:boolean;var condition:boolean);
procedure evalLOGOP(var t:TNodePointer;var st:Table;var condi:boolean;var resC2:boolean; var condition:boolean);
procedure evalCLOSEIF(var t:TNodePointer;var st:Table);
{procedure ENDIF(var t:TNodePointer);
procedure V_ELSE(var t:TNodePointer);}
procedure evalCYCLE(var t:TNodePointer;var st:Table );
									
implementation

procedure evalS(var t:TNodePointer;var st:Table);
var 
	lc,rb : TNodePointer;
	i:integer;
begin
	getLeftChild(t,lc);
	for i := 1 to 4 do
	begin
		getRightBro(lc,rb);
		lc := rb;
	end;
	evalBody(lc,st);
	
end;

procedure evalBODY(var t:TNodePointer;var st:Table); 
var
	lc,rb:TNodePointer;
	i:integer;
begin
	
	getLeftChild(t,lc);
	for i := 1 to 2 do
	begin
		getRightBro(lc,rb);
		lc := rb;
	end;
	evalSENT(t^.leftChild,st);
	evalRRSENT(lc,st);
end;

procedure evalSENT(var t:TNodePointer;var st:Table);
begin
	if t^.leftchild^.elem = ASIG then
	begin
		evalASIG(t^.leftChild,st);
	end;
	if t^.leftchild^.elem = V_READ then
	begin
		evalREAD(t^.leftChild,st);
	end;
	if t^.leftchild^.elem = V_WRITE then
	begin
		evalWRITE(t^.leftChild,st);
	end;
	if t^.leftchild^.elem = CONDITIONAL then
	begin
		evalCONDITIONAL(t^.leftChild,st);
	end;
	if t^.leftchild^.elem = CYCLE then
	begin
		evalCYCLE(t^.leftChild,st);
	end;
	
end;

procedure evalRRSENT(var t:TNodePointer;var st:Table);
var
	lc,rb:TNodePointer;
	i:integer;
begin
	if t^.leftChild^.elem <> EPSILON then
	begin
		getLeftChild(t,lc);
		for i := 1 to 2 do
		begin
			getRightBro(lc,rb);
			lc := rb;
		end;
		evalSENT(t^.leftChild,st);
		evalRRSENT(lc,st);
	end;
end;

procedure evalASIG(var t:TNodePointer;var st:Table);
var 
	lc,rb : TNodePointer;
	result:real;
	list:string;
begin
	lc := t^.leftChild^.rightBro;
	rb := lc^.rightBro;
	evalEXP(rb,st,result,list);
	if list = '' then
	begin
		asignVar(st,t^.leftChild^.lexem,result);
	end
	else
	begin
		asignList(st,t^.leftChild^.lexem,list);
	end;
end;

procedure asignVar(var st:Table;var lexem:string; var result:real);
var fts:string;
begin
	fts := FloatToStr(result);
	setValueOfVar(st,lexem,fts);
	
end;

procedure asignList(var st:Table;var lexem:string; var list:string);
begin
	list := list + ']';
	setValueOfVar(st,lexem,list);
end;

procedure evalEXP(var t:TNodePointer;var st:Table;var result:real;var list:string);

begin 
	if t^.leftChild^.elem = EXPARIT then
	begin
		evalEXPARIT(t^.leftChild,st,result);
		list := '';
	end;
	if t^.leftChild^.elem = V_LIST then
	begin
		list := '';
		evalLIST(t^.leftChild,st,list);
		result := -1;
	end;
end;

procedure evalEXPARIT(var t:TNodePointer;var st:Table;var result:real);
var resTERM:real;
begin
	evalTERM(t^.leftChild,st,resTERM);
	evalRRTERM(t^.leftChild^.rightBro,st,resTERM,result);
end;

procedure evalRRTERM(var t:TNodePointer;var st:Table;var resTERM:real;var result:real);
var resTERM2:real;
begin
	if t^.leftChild^.elem <> EPSILON then
	begin
		evalTERM(t^.leftChild^.rightBro,st,resTERM2);
		evalSUMOP(t^.leftChild,resTERM,resTERM2,result);
	end
	else
	begin
		result := resTERM;
	end;
end;

procedure evalTERM(var t:TNodePointer;var st:Table;var resTERM:real);	
var resF:real;
begin
	evalFACTOR(t^.leftChild,st,resF);
	evalRRFACTOR(t^.leftChild^.rightBro,st,resF,resTERM);
end;
procedure evalRRFACTOR(var t:TNodePointer;var st:Table;var resF:real;var resTerm:real);
var resF2:real;
begin
	if t^.leftChild^.elem <> EPSILON then
	begin
		evalFACTOR(t^.leftChild^.rightBro,st,resF2);
		evalMULTOP(t^.leftChild,resF,resF2,resTerm);
	end
	else
	begin
		resTerm := resF;
	end;
end;

procedure evalFACTOR(var t:TNodePointer;var st:Table;var resF:real);
var v_val:string;
	i:integer;
    lc,rb : TNodePointer;
begin
	if t^.leftChild^.elem = IDENTIFIER then
	begin
		getVar(st,t^.leftChild^.lexem,v_val);
		resF := StrToInt(v_val);
	end;
	if t^.leftChild^.elem = CONSTANT then
	begin
		resF := StrToInt(t^.leftChild^.lexem);
	end;
	if t^.leftChild^.elem = OPPAR then
	begin
		if t^.leftChild^.rightBro^.elem = EXPARIT then
		begin
			evalEXPARIT(t^.leftChild^.rightBro,st,resF);
		end;
	end;
	if t^.leftChild^.elem = FIRST then
	begin
		getLeftChild(t,lc);
		for i := 1 to 2 do
		begin
			getRightBro(lc,rb);
			lc := rb;
		end;
		v_val:=' ';
		evalLIST(lc,st,v_val);
		v_val := v_val[2];
		resF := StrToInt(v_val);
	end;
end;

procedure evalSUMOP(var t:TNodePointer;var resTERM:real;var resTERM2:real; var result:real);
begin
	if t^.leftChild^.elem = PLUS then
	begin
		result := resTERM + resTERM2;
	end; 
	if t^.leftChild^.elem = MINUS then
	begin
		result := resTERM - resTERM2;
	end; 
	
end;

procedure evalMULTOP(var t:TNodePointer;var resF:real;var resF2:real; var result:real);
begin
	if t^.leftChild^.elem = MULT then
	begin
		result := resF * resF2;
	end; 
	if t^.leftChild^.elem = DIVI then
	begin
		result := resF / resF2;
	end; 
end;
procedure evalLIST(var t:TNodePointer;var st:Table;var list:string);
begin
	if t^.leftChild^.elem = OPBRA then
	begin
		list := list + '[';
		evalLISTCONST(t^.leftChild^.rightBro,st,list);
	end;
	
	if t^.leftChild^.elem = V_REST then
	begin
		evalREST(t^.leftChild,st,list);
	end;
	
	if t^.leftChild^.elem = V_CONS then
	begin
		evalCONS(t^.leftChild,st,list);
	end;
	if t^.leftChild^.elem = IDENTIFIER then
	begin
		getVar(st,t^.leftChild^.lexem,list);
	end;
end;

procedure evalLISTCONST(var t:TNodePointer;var st:Table;var list:string);
begin

	list := list + t^.leftChild^.lexem;
	evalRRLISTCONST(t^.leftChild^.rightBro,st,list);
end;

procedure evalRRLISTCONST(var t:TNodePointer;var st:Table;var list:string);
var p:TNodePointer;
begin
	if t^.leftChild^.elem <> EPSILON then
	begin
		list := list + t^.leftChild^.lexem;
		list := list + t^.leftChild^.rightBro^.lexem;
		p := t^.leftChild^.rightBro;
		p := p^.rightBro;
		evalRRLISTCONST(p,st,list);
	end;
end;

procedure evalREST(var t:TNodePointer;var st:Table;var list:string);
var pt,rb,sb:TNodePointer;
a:integer;
v_val:string;
begin
	pt := t^.leftChild;
	rb:= pt^.rightBro;
	sb := rb^.rightBro;
	v_val := '';
	evalLISTARG(sb,st,v_val);
	list := list + '[';
	for a := 4 to Length(v_val)-1 do
	begin
		list := list + v_val[a];
	end;
end;

procedure evalLISTARG(var t:TNodePointer;var st:Table;var list:string);
begin
	if t^.leftChild^.elem = IDENTIFIER then
	begin
		getVar(st,t^.leftChild^.lexem,list);
	end;
end;

procedure evalCONS(var t:TNodePointer;var st:Table;var list:string);
var result:real;
    lc,rb:TNodePointer;
    v_val,comma,nl:string;
    i:integer;	
begin
	getLeftChild(t,lc);
	for i := 1 to 2 do
	begin
		getRightBro(lc,rb);
		lc := rb;
	end;
	evalEXPARIT(lc,st,result);
	for i := 1 to 2 do
	begin
		getRightBro(lc,rb);
		lc := rb;
	end;
	evalLISTARG(lc,st,v_val);
	nl := '';
	for i := 2 to Length(v_val)-1 do
	begin
		nl := nl + v_val[i];
	end;
	comma := ',';
	list := '['+FloatToStr(result) + comma + nl;
end;

procedure evalREAD(var t:TNodePointer;var st:Table);
var lc,rb:TNodePointer;
	i:integer;
begin
	if t^.leftChild^.elem = READINT then
	begin
		getLeftChild(t,lc);
		for i := 1 to 2 do
		begin
			getRightBro(lc,rb);
			lc := rb;
		end;
		evalIARGINT(lc,st);
	end;
	if t^.leftChild^.elem = READLIST then
	begin
		getLeftChild(t,lc);
		for i := 1 to 2 do
		begin
			getRightBro(lc,rb);
			lc := rb;
		end;
		evalIARGLIST(lc,st);
	end;
end;

procedure evalIARGINT(var t:TNodePointer;var st:Table);
var input,i:integer;
	lc,rb:TNodePointer;
	fts:string;
begin
	writeln(t^.leftChild^.lexem);
	Readln(input);
	getLeftChild(t,lc);
		for i := 1 to 2 do
		begin
			getRightBro(lc,rb);
			lc := rb;
		end;
	fts := FloatToStr(input);
	setValueOfVar(st,lc^.lexem,fts);
	
end;
procedure evalIARGLIST(var t:TNodePointer;var st:Table);
var input:string;
	i:integer;
	lc,rb:TNodePointer;
begin
	writeln(t^.leftChild^.lexem);
	Readln(input);
	getLeftChild(t,lc);
		for i := 1 to 2 do
		begin
			getRightBro(lc,rb);
			lc := rb;
		end;
		
	setValueOfVar(st,lc^.lexem,input);
end;

procedure evalWRITE(var t:TNodePointer;var st:Table);
	var lc,rb:TNodePointer;
	i:integer;
begin
	if t^.leftChild^.elem = WRITEINT then
	begin
		getLeftChild(t,lc);
		for i := 1 to 2 do
		begin
			getRightBro(lc,rb);
			lc := rb;
		end;
		evalOARGINT(lc,st);
	end;
	if t^.leftChild^.elem = WRITELIST then
	begin
		getLeftChild(t,lc);
		for i := 1 to 2 do
		begin
			getRightBro(lc,rb);
			lc := rb;
		end;
		evalOARGLIST(lc,st);
	end;
end;

procedure evalOARGINT(var t:TNodePointer;var st:Table);
var i:integer;
    result:real;
    list:string;	
	lc,rb:TNodePointer;
begin
	write(t^.leftChild^.lexem,' ');
	getLeftChild(t,lc);
		for i := 1 to 2 do
		begin
			getRightBro(lc,rb);
			lc := rb;
		end;
	evalEXPARIT(lc,st,result);
	write(result:0:0);
	writeln(' ');
	
end;
procedure evalOARGLIST(var t:TNodePointer;var st:Table);
var 	i:integer;
	list:string;	
	lc,rb:TNodePointer;
begin
	writeln(t^.leftChild^.lexem);
	getLeftChild(t,lc);
		for i := 1 to 2 do
		begin
			getRightBro(lc,rb);
			lc := rb;
		end;
	list:= '';
	evalLISTARG(lc,st,list);
	writeln(list);
end;

procedure evalCONDITIONAL(var t:TNodePointer;var st:Table);
var lc,rb,lcp,rbp:TNodePointer;
    condition:boolean;
    i:integer;	
begin
	getLeftChild(t,lc);
	for i := 1 to 2 do
	begin
		getRightBro(lc,rb);
		lc := rb;
	end;
	evalCONDITION(lc,st,condition);
	if condition = true then
	begin
		getLeftChild(t,lcp);
		for i := 1 to 5 do
		begin
			getRightBro(lcp,rbp);
			lcp := rbp;
		end;
		
		evalBODY(lcp,st);
	end
	else
	begin
		getLeftChild(t,lcp);
		for i := 1 to 6 do
		begin
			getRightBro(lcp,rbp);
			lcp := rbp;
		end;
		evalCLOSEIF(lcp,st);
	end;

end;

procedure evalCLOSEIF(var t:TNodePointer;var st:Table);
begin
	if t^.leftChild^.elem = V_ELSE then
	begin
		evalBODY(t^.leftChild^.rightBro,st);
	end;
end;

procedure evalCYCLE(var t:TNodePointer;var st:Table );
var lc,rb,lcp,rbp:TNodePointer;
    condition:boolean;
    i:integer;	
begin
	getLeftChild(t,lc);
	for i := 1 to 2 do
	begin
		getRightBro(lc,rb);
		lc := rb;
	end;
	evalCONDITION(lc,st,condition);
	getLeftChild(t,lcp);
	for i := 1 to 5 do
	begin
		getRightBro(lcp,rbp);
		lcp := rbp;
	end;
	while condition = true do
	begin
		evalBODY(lcp,st);
		evalCONDITION(lc,st,condition);
	end;
	
end;

procedure evalCONDITION(var t:TNodePointer;var st:Table;var condition:boolean);
var lc,rb:TNodePointer;
var condI:boolean;
	i:integer;
begin
	getLeftChild(t,lc);
	for i := 1 to 2 do
	begin
		getRightBro(lc,rb);
		lc := rb;
	end;
	evalC(t^.leftChild^.rightBro,st,condI);
	evalLOG(lc,st,condI,condition);
end;

procedure evalC(var t:TNodePointer;var st:Table;var condition:boolean);
var resI,resD:real;
    lc,rb:TNodePointer;
    i:integer;
begin
	evalEXPARIT(t^.leftChild,st,resI);
	getLeftChild(t,lc);
	for i := 1 to 2 do
	begin
		getRightBro(lc,rb);
		lc := rb;
	end;
	evalEXPARIT(lc,st,resD);
	if t^.leftChild^.rightBro^.lexem = '<' then
	begin
		if resI < resD then
		begin
			condition := true;
		end
		else
			condition := false;
		end;
	
	if t^.leftChild^.rightBro^.leftChild^.lexem = '>' then
	begin
		if resI > resD then
		begin
			condition := true;
		end
		else
			condition := false;
		end;
	if t^.leftChild^.rightBro^.leftChild^.lexem = '<=' then
	begin
		if resI <= resD then
		begin
			condition := true;
		end
		else

			condition := false;
		end;

	if t^.leftChild^.rightBro^.leftChild^.lexem = '>=' then
	begin
		if resI >= resD then
		begin
			condition := true;
		end
		else
			condition := false;
		end;

	if t^.leftChild^.rightBro^.leftChild^.lexem = '=' then
	begin
		if resI = resD then
		begin
			condition := true;
		end
		else
			condition := false;
		end;
	
end;

procedure evalLOG(var t:TNodePointer;var st:Table;var condi:boolean;var condition:boolean);
var resC2:boolean;
begin
	if t^.leftChild^.elem <> EPSILON then
	begin
		evalCONDITION(t^.leftChild^.rightBro,st,resC2);
		evalLOGOP(t^.leftChild,st,condi,resC2,condition);
	end
	else
	begin
		condition := condi;
	end;
end;

procedure evalLOGOP(var t:TNodePointer;var st:Table;var condi:boolean;var resC2:boolean; var condition:boolean);
begin

	if t^.leftChild^.elem = T_AND then
	begin
		if condi = true AND resC2 = true then
		begin
			condition := true;
		end
		else
		begin
			condition := false;
		end;
	end;
	if t^.leftChild^.elem = T_OR then
	begin
		if condi = false AND resC2 = false then
		begin
			condition := false;
		end
		else
		begin
			condition := true;
		end;
		
	end;
end;

end.
























														


