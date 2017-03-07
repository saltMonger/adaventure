WITH Ada.Text_IO;                     USE Ada.Text_IO;
WITH Ada.Integer_Text_IO;             USE Ada.Integer_Text_IO;
WITH Ada.Numerics.Discrete_Random;

PACKAGE BODY Map_Generator IS

   TYPE Matrix_Row IS ARRAY(1..20) OF Cell;
   TYPE Matrix_Column IS ARRAY(1..20) OF Matrix_Row;
   New_Map : Matrix_Column;

   -- The range allowed for the starting x-coordinate and y-coordinate
   SUBTYPE Start_Range IS Integer RANGE 7..13;
   -- A range: 1 represents north, 2 represents east, 3 represents south, 4 represents north
   SUBTYPE Direction_Range IS Integer RANGE 1..4;
   -- A range for deciding if a room has items, enemies, traveling salesman, or nothing
   -- A 1 represents a traveling salesman, 2-3 represents an item, 4-5 represents an enemy, 6-10 represents nothing
   SUBTYPE Room_Dweller_Range IS Integer RANGE 1..10;

   -- Random package instantiations
   PACKAGE Random_Start_X IS NEW Ada.Numerics.Discrete_Random(Start_Range);
   PACKAGE Random_Start_Y IS NEW Ada.Numerics.Discrete_Random(Start_Range);
   PACKAGE Random_Direction IS NEW Ada.Numerics.Discrete_Random(Direction_Range);
   PACKAGE Random_Room_Dwellers IS NEW Ada.Numerics.Discrete_Random(Room_Dweller_Range);

   Temp_Num_Of_Enemies : Integer := 0;         -- To temporarily store the randomly generated number of enemies
   Temp_Num_Of_Items   : Integer := 0;         -- To temorarily store the randomly generated number of items
   Salesman_Flag       : Boolean := False;     -- A flag to set when a salesman is placed in a room
   Starting_Row        : Integer;              -- To store the row-coordinate of the player's starting room on the map
   Starting_Column     : Integer;              -- To store the column-coordinate of the player's starting room on the map

   -- The random seeds
   X             : Random_Start_X.Generator;
   Y             : Random_Start_Y.Generator;
   Direction     : Random_Direction.Generator;
   Room_Dwellers : Random_Room_Dwellers.Generator;

   -- To store the random coordinates of the current spot in the map being operated on
   Row       : Integer;
   Col       : Integer;
   Go        : Integer;         -- To store which direction to go, 1 : North, 2 : East, 3 : South, 4 : West
   Dweller   : Integer;         -- To store the number associated with the dweller decided on for the room

   -- Initalizes a 2D array map to all 0s
   PROCEDURE Initialize_Empty_Map IS
   BEGIN
      --Pick new numbers each time
      Random_Start_X.Reset(X);
      Random_Start_Y.Reset(Y);

      -- Initialize the 2D array
      FOR I IN Integer RANGE 1..20 LOOP
         FOR J IN Integer RANGE 1..20 LOOP
            New_Map(I)(J) := (Cell_Type => Not_Room);
         END LOOP;
      END LOOP;
   END Initialize_Empty_Map;

   -- Generates a random map by picking a random start point relatively close to the center of the
   -- map and then randomly heading north, east, south, west, until the current position approaches the border of the map
   PROCEDURE Generate_Random_Map IS
   BEGIN
      -- Plot a random start point
      Row := Random_Start_X.Random(X);
      Col := Random_Start_Y.Random(Y);
      Starting_Row := Row;
      Starting_Column := Col;

      FOR I IN Integer RANGE 1..4 LOOP
         -- NEED TO GET RANDOM NUM OF ENEMIES AND ITEMS OR PLACE A TRAVELING SALESMAN
         Random_Room_Dwellers.Reset(Room_Dwellers);
         Dweller := Random_Room_Dwellers.Random(Room_Dwellers);

         IF Dweller = 1 THEN
            Temp_Num_Of_Enemies := 0;
            Temp_Num_Of_Items := 0;
            Salesman_Flag := True;
            EXIT;
         ELSIF Dweller = 2 OR ELSE Dweller = 3 THEN
            Temp_Num_Of_Items := Temp_Num_Of_Items + 1;
         ELSIF Dweller = 4 OR ELSE Dweller = 5 THEN
            Temp_Num_Of_Enemies := Temp_Num_Of_Enemies + 1;
         END IF;
      END LOOP;

      New_Map(Row)(Col) := (Cell_Type => Room,
                            Num_Of_Enemies => Temp_Num_Of_Enemies,
                            Num_Of_Items => Temp_Num_Of_Items,
                            Traveling_Salesman => Salesman_Flag);

      -- Generate the map by randomly moving north, west, south, and east from wherever the current point may be
      -- until the new current point approaches the border of the 2D array
      WHILE Row >= 2 AND Col >= 2 AND Row <= 19 AND Col <= 19 LOOP

         Temp_Num_Of_Items := 0;
         Temp_Num_Of_Enemies := 0;
         Salesman_Flag := False;

         Random_Direction.Reset(Direction);
         Go := Random_Direction.Random(Direction);
         CASE Go IS
            WHEN 1 => Row := Row - 1;     -- When 1 move north
            WHEN 2 => Col := Col + 1;     -- When 2 move east
            WHEN 3 => Row := Row + 1;     -- When 3 move south
            WHEN 4 => Col := Col - 1;     -- When 4 move west
            WHEN OTHERS => Put("Error");  -- To satisfy this naggy compiler
         END CASE;

         FOR I IN Integer RANGE 1..4 LOOP
            -- NEED TO GET RANDOM NUM OF ENEMIES AND ITEMS OR PLACE A TRAVELING SALESMAN
            Random_Room_Dwellers.Reset(Room_Dwellers);
            Dweller := Random_Room_Dwellers.Random(Room_Dwellers);

            IF Dweller = 1 THEN
               Temp_Num_Of_Enemies := 0;
               Temp_Num_Of_Items := 0;
               Salesman_Flag := True;
               EXIT;
            ELSIF Dweller = 2 OR ELSE Dweller = 3 THEN
               Temp_Num_Of_Items := Temp_Num_Of_Items + 1;
            ELSIF Dweller = 4 OR ELSE Dweller = 5 THEN
               Temp_Num_Of_Enemies := Temp_Num_Of_Enemies + 1;
            END IF;
         END LOOP;

         New_Map(Row)(Col) := (Cell_Type => Room,
                               Num_Of_Enemies => Temp_Num_Of_Enemies,
                               Num_Of_Items => Temp_Num_Of_Items,
                               Traveling_Salesman => Salesman_Flag);
      END LOOP;
   END Generate_Random_Map;

   -- Prints a representation of the randomly generated map
   PROCEDURE Print_Map IS
   BEGIN
      FOR I IN Integer RANGE 1..20 LOOP
         FOR J IN Integer RANGE 1..20 LOOP
            IF New_Map(I)(J).Cell_Type = Room THEN
               -- Print the coordinates inside of the braces to match them up when printing room stats
               Put("[");
               Put(Item => I, Width => 1);
               Put(",");
               Put(Item => J, Width => 1);
               Put("]");
            ELSE
               Put("      ");
            END IF;
         END LOOP;
      New_Line;
      END LOOP;
   END Print_Map;

   PROCEDURE Print_Current_Room(Row : Integer; Column : Integer) IS
   BEGIN
      Put("Current room is: ");
      Put(Item => Row, Width => 1);
      Put(", ");
      Put(Item => Column, Width => 1);
      New_Line;
      Put("__________________________________");
      New_Line;
      Put("|                                |");
      New_Line;
      Put("| Number of Enemies: ");
      Put(Item => New_Map(Row)(Column).Num_Of_Enemies, Width => 1);
      Put("           |");
      New_Line;
      Put("| Number of Items: ");
      Put(Item => New_Map(Row)(Column).Num_Of_Items, Width => 1);
      Put("             |");
      New_Line;
      Put("|                                |");
      New_Line;
      Put("_________________________________");
      New_Line;
      New_Line;
   END Print_Current_Room;

   PROCEDURE Get_Starting_Room(Row : IN OUT Integer; Column : IN OUT Integer) IS
   BEGIN
      Row := Starting_Row;
      Column := Starting_Column;
   END Get_Starting_Room;

   FUNCTION Check_If_Room(Row : IN Integer; Column : IN Integer) RETURN Boolean IS
   BEGIN
      RETURN New_Map(Row)(Column).Cell_Type = Room;
   END Check_If_Room;

END Map_Generator;
