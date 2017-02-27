WITH Ada.Text_IO;
USE Ada.Text_IO;
WITH Ada.Integer_Text_IO;
USE Ada.Integer_Text_IO;
WITH Ada.Numerics.Discrete_Random;

PROCEDURE MapGenerator IS

   -- An array to be the rows of a 2D array
   TYPE Boolean_Matrix_Row IS ARRAY (1 .. 20) OF Integer;
   -- An array to be the columns of a 2D array
   TYPE Boolean_Matrix IS ARRAY (1 .. 20) OF Boolean_Matrix_Row;
   Map : Boolean_Matrix; -- A 2D array to represent a map
   -- The range allowed for the starting x-coordinate
   SUBTYPE X_Range IS Integer RANGE 7..13;
   -- The range allowed for the starting y-coordinate
   SUBTYPE Y_Range IS Integer RANGE 7..13;
   -- A range: 1 represents north, 2 represents east, 3 represents south, 4 represents north
   SUBTYPE Direction_Range IS Integer RANGE 1..4;
   PACKAGE Random_Start_X IS NEW Ada.Numerics.Discrete_Random(X_Range);
   PACKAGE Random_Start_Y IS NEW Ada.Numerics.Discrete_Random(Y_Range);
   PACKAGE Random_Direction IS NEW Ada.Numerics.Discrete_Random(Direction_Range);

   -- The random seeds
   X         : Random_Start_X.Generator;
   Y         : Random_Start_Y.Generator;
   Direction : Random_Direction.Generator;

   -- To store the random coordinates of the current spot in the map being operated on
   Row       : Integer;
   Col       : Integer;
   Go        : Integer;         -- To store which direction to go, 1 : North, 2 : East, 3 : South, 4 : West

   -- Initalizes a 2D array map to all 0s
   PROCEDURE Initialize_Empty_Map IS
   BEGIN
      --Pick new numbers each time
      Random_Start_X.Reset(X);
      Random_Start_Y.Reset(Y);

      -- Initialize the 2D array
      FOR I IN Integer RANGE 1..20 LOOP
         FOR J IN Integer RANGE 1..20 LOOP
            Map(I)(J) := 0;
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
      Map(Row)(Col) := 1;

      -- Generate the map by randomly moving north, west, south, and east from wherever the current point may be
      -- until the new current point approaches the border of the 2D array
      WHILE Row >= 2 AND Col >= 2 AND Row <= 19 AND Col <= 19 LOOP
         Random_Direction.Reset(Direction);
         Go := Random_Direction.Random(Direction);
         CASE Go IS
            WHEN 1 =>                     -- When 1 move north
                  Row := Row - 1;
            WHEN 2 =>                     -- When 2 move east
               IF Map(Row)(Col + 1) = 0 THEN
                  Col := Col + 1;
               END IF;
            WHEN 3 =>                     -- When 3 move south
               IF Map(Row + 1)(Col) = 0 THEN
                  Row := Row + 1;
               END IF;
            WHEN 4 =>                     -- When 4 move west
               IF Map(Row)(Col - 1) = 0 THEN
                  Col := Col - 1;
               END IF;
            WHEN OTHERS =>                -- To satisfy this naggy compiler
               Put("Test");
         END CASE;
         Map(Row)(Col) := 1;               -- Set the random position to 1
      END LOOP;
   END Generate_Random_Map;

   -- Prints the boolean version of the map for debugging
   PROCEDURE Print_Boolean_Map IS
   BEGIN
      FOR I IN Integer RANGE 1..20 LOOP
         FOR J IN Integer RANGE 1..20 LOOP
            Put(Map(I)(J), Width => 3);
         END LOOP;
         New_Line;
      END LOOP;
   END Print_Boolean_Map;

   -- Prints a representation of the randomly generated map
   PROCEDURE Print_Map IS
   BEGIN
      FOR I IN Integer RANGE 1..20 LOOP
         FOR J IN Integer RANGE 1..20 LOOP
            IF Map(I)(J) = 1 THEN

               Put("[  ]");
            ELSE
               Put("    ");
            END IF;
         END LOOP;
      New_Line;
      END LOOP;
   END Print_Map;

BEGIN

   Initialize_Empty_Map;      -- Create a boolean 2D array filled with 0s indicating no rooms

   Generate_Random_Map;       -- Generate random 1s into the 2D array, indicating there is a room in those cells

   New_Line;                  -- Who doesn't love a good new line

   Print_Boolean_Map;         -- For debugging

   Print_Map;                 -- Print a representation of the map

END MapGenerator;
