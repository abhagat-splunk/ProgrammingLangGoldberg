with Text_io;
use Text_io;

with Ada.Float_Text_IO;
use Ada.Float_Text_IO;
with Ada.Numerics.Generic_Elementary_Functions;
with AdaptiveQuad;

procedure AQMain is
	
	package FloatFunctions is new Ada.Numerics.Generic_Elementary_Functions(Float);
	use FloatFunctions;
	package int_io is new Integer_io(Integer);
	use int_io;

	Epsilon:Float:=0.000001;

	function MyF(x:Float) return Float is
	begin
		return Sin(x*x);
	end MyF;

	package AQPack is new AdaptiveQuad(MyF);


	task ReadPairs;
	task ComputeArea is
		entry Consume(A:Float;B:Float);
		entry Done;
	end ComputeArea;
	task PrintResult is
		entry PrintMessage(A:Float;B:Float;Ret:Float);
		entry Done;
	end PrintResult;
			
	task body ReadPairs is
		A:Float;
		B:Float;
		begin
			for I in 1..5 loop
				get(A);
				get(B);
				ComputeArea.Consume(A,B);
			end loop;
		ComputeArea.Done;	
		end ReadPairs;

	task body ComputeArea is 
		Finished: Boolean := False;
		Ret:Float;
		begin
			while not Finished loop
				select
					accept Consume(A:Float;B:Float) do
						Ret := AQPack.AQuad(A,B,Epsilon);
						PrintResult.PrintMessage(A,B,Ret);
					end Consume;
				or	
					accept Done do
					PrintResult.Done;
					Finished:=True;
					end Done;
				end select;
			end loop;		
		end ComputeArea;

	task body PrintResult is
		Finished: Boolean:= False;
		begin
			while not Finished loop
				select
					accept PrintMessage(A:Float;B:Float;Ret:Float) do
						Put("The area under sin(x^2) for x = "); Put(A); Put(" to "); Put(B); Put(" is "); Put(Ret);new_line;
					end PrintMessage;
				or
					accept Done;
					Finished:=True;
				end select;
			end loop;
		end PrintResult;					

begin
	null;
end AQMain;	
