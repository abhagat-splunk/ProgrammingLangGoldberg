package body AdaptiveQuad is
	function SimpsonsRule(A:Float;B:Float) return Float is
	C:Float;
	H3:Float;
	begin
		C:=(A+B)/2.0;
		H3:= abs(B-A)/6.0;
		return H3*(F(A)+4.0*F(C)+F(B));
	end SimpsonsRule;
	
	function RecAQuad(A:Float;B:Float;eps:Float;whole:Float) return Float is
	Left:Float;
	Right:Float;
	C:Float;
	begin
		C:=(A+B)/2.0;
		Left:=SimpsonsRule(A,C);
		Right:=SimpsonsRule(C,B);
		if (abs(Left+Right-Whole)<(15.0*eps)) then
			return Left+Right+((Left+Right-Whole)/15.0);
		end if;	
		return RecAQuad(A,C,eps/2.0,Left) + RecAQuad(C,B,eps/2.0,Right);	
	end RecAQuad;
	
	function AQuad(A:Float;B:Float;eps:Float) return Float is
	begin
	return RecAQuad(A,B,eps,SimpsonsRule(A,B));
	end AQuad;
end AdaptiveQuad;	
