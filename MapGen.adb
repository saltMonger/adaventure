with Ada.Text_IO;
-- random number package
with Ada.Numerics.discrete_Random;

-- This file is a test of a map generation system

-- The system creates a two dimensional array of a specific size
-- and fills it randomly with 1s and 0s.

-- A second array full of records is generated based on the 1s and 0s.
-- On a "1" space, the array will have directionals, and a description.
-- On a "0" space, the array will be null.

procedure MapGen is
	-- types
		
	type Room_Type is (Room, Empty);
	
	-- cool thing:  This is a Variant Record
	-- For it to exist in an array, set it to all Null.
	type Dungeon_Cell (Option: Room_Type := Empty) is record
		-- common components
		case Option is
			when Room =>
				North		:	Boolean;
				South		:	Boolean;
				East		:	Boolean;
				West		:	Boolean;
				Description	:	String(1..200);
			when Empty =>
				Null;
		end case;
	end record;
	
	type Dungeon is Array(Positive range <>, Positive range <>) of Dungeon_Cell;
	
	subtype D2 is Integer range 0 .. 1;
	subtype D4 is Integer range 1 .. 3;
	subtype D6 is Integer range 1 .. 6;
	subtype D8 is Integer range 1 .. 8;
	subtype D10 is Integer range 1 .. 10;
	subtype D12 is Integer range 1 .. 12;
	subtype D20 is Integer range 1 .. 20;
	
	package Random_D2 is new Ada.Numerics.discrete_Random(D2);
	package Random_D4 is new Ada.Numerics.discrete_Random(D4);
	
	
	-- procedures
	function RollD2(G : in Random_D2.Generator) return Integer is
	begin
		return Random_D2.Random(G);
	end RollD2;
	
	function RollD4(G : Random_D4.Generator) return Integer is
	begin
		return Random_D4.Random(G);
	end RollD4;
	
	function RandomDescription(G :	Random_D4.Generator) return String is
		Desc1	:	String(1..200) := "A large room sprawls before you.  The bricks here are blue, indicating the presence of some ghastly slimemolds.  Some shimmering coins lie in a lumpy pile near the wall. What do you do?zzzzzzzzzzzzzzz";
		Desc2	:	String(1..200) := "The walls are solid stone. Faintly, you see a figure in the corner. A staircase down flanks your left. Though the walls are solid, they're slowly closing in on you. The room goes dark. What do you do?";
		Desc3	:	String(1..200) := "You notice when you enter he room that there is a series of tracks on the floor with fast moving boulders, about the size of your fist, on the rails.  The door lies on the opposite side of the room.  ";
		Desc4	:	String(1..200) := "The goblin of luck blesses you with luck!  Or... something like that.  Your entire body feels tingly - you soon realize that your skin is slowly turning to gold.  You've received the Midas Curse.zzzzz";
	begin
		case RollD4(G) is
			when 1 =>
				return Desc1;
			when 2 =>
				return Desc2;
			when 3 =>
				return Desc3;
			when 4 =>
				return Desc4;
			when others =>
				return Desc2;
		end case;
		
	end RandomDescription;
		
	procedure GenerateMap(Dng : in out Dungeon; Die2 : in out Random_D2.Generator; Die4 : in out Random_D4.Generator) is
		N	:	Boolean;
		S	:	Boolean;
		E	:	Boolean;
		W	:	Boolean;
	begin
		-- init loop
		for R  in Integer range  1 .. Dng'Length(1) loop
			for C in Integer range 1 .. Dng'Length(2) loop
				if (RollD2(Die2) = 0) then
					Dng(R,C) := (Option => Empty);
					Ada.Text_IO.Put("   ");
				else
					Dng(R,C) := (Option => Room,
									 North => False,
									 South => False,
									 East => False,
									 West => False,
									 Description => "NULLXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
					Ada.Text_IO.Put("▓▓▓");
				end if;
			end loop;
			Ada.Text_IO.New_Line;
		end loop;
		
		-- fill and print loop
		
		-- Left-most, Top-most entry
		N := False;
		W := False;
		-- testing for non null neighboors
		if (Dng(1,2).Option /= Empty) then
			S := True;
		else
			S := False;
		end if;
			
		if (Dng(2,1).Option /= Empty) then
			E := True;
		else
			E := False;
		end if;
		
		if(Dng(1,1).Option /= Empty) then
			Dng(1,1) := (Option => Room,
							 North => N,
							 South => S,
							 East => E,
							 West => W,
							 Description => RandomDescription(Die4));
			--Ada.Text_IO.Put(" 1 ");
		--else
			--Ada.Text_IO.Put(" 0 ");
		end if;
		
		
		-- top row
		for C in Integer range 2 .. (Dng'Length(2) - 1) loop
			
			if (Dng(C,1).Option /= Empty) then
				N	:=	False;
				if (Dng(C, 2).Option /= Empty) then
					S	:=	True;
				else
					S	:=	False;
				end if;
				
				if (Dng(C - 1,1).Option /= Empty) then
					W	:=	True;
				else
					W	:=	False;
				end if;
				
				if(Dng(C + 1,1).Option /= Empty) then
					E	:=	True;
				else
					E	:=	False;
				end if;
				
				Dng(C,1) :=	(	 Option	=>	Room,
								 North	=>	N,
								 South	=>	S,
								 East	=>	E,
								 West	=>	W,
								 Description => RandomDescription(Die4));
				--Ada.Text_IO.Put(" 1 ");
			--else
				--Ada.Text_IO.Put(" 0 ");
			end if;
		end loop;
			
				-- Right-most, Top-most entry
				if(Dng(Dng'Length(1),1).Option /= Empty) then
					N := False;
					E := False;
					-- testing for non null neighboors
					if (Dng(Dng'Length(1),2).Option /= Empty) then
						S := True;
					else
						S := False;
					end if;
						
					if (Dng(Dng'Length(1) - 1,2).Option /= Empty) then
						W := True;
					else
						W := False;
					end if;
					
					Dng(Dng'Length(1),1) :=	(Option	=>	Room,
													 North	=>	N,
													 South	=>	S,
													 East	=>	E,
													 West	=>	W,
													 Description	=>	RandomDescription(Die4));
					--Ada.Text_IO.Put_Line(" 1 ");
				--else
					--Ada.Text_IO.Put_Line(" 0 ");
				end if;
		
	end GenerateMap;
	
	
	
	
	
	-- Variables
	
	Layout	:	Dungeon(1..20, 1..20);
	Die2	:	Random_D2.Generator;
	Die4	:	Random_D4.Generator;
begin
	Random_D2.Reset(Die2);
	Random_D4.Reset(Die4);
	Ada.Text_IO.Put_Line("yo testa here.");
	GenerateMap(Layout, Die2, Die4);
end MapGen;