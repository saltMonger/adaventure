PACKAGE Map_Generator IS

   -- A variant type for a cell that is a room or isn't a room
   TYPE Room_Type IS (Room, Not_Room);

   -- A cell in the 2D array. It can either be a room or not a room
   TYPE Cell (Cell_Type : Room_Type := Not_Room) IS RECORD
      CASE Cell_Type IS
         WHEN Room     => Num_Of_Enemies     : Integer;
                          Num_Of_Items       : Integer;
                          Traveling_Salesman : Boolean;
         WHEN Not_Room => NULL;
      END CASE;
   END RECORD;

   -- Initalizes a 2D array (20 x 20) of 0s
   PROCEDURE Initialize_Empty_Map;

   -- Generates a random map of 1s within the 2D array of 0s
   PROCEDURE Generate_Random_Map;

   -- Prints a representation of the map for the user to see
   PROCEDURE Print_Map(Row : Integer; Column : Integer);

   -- Prints a representation of the room the player is currently in
   PROCEDURE Print_Current_Room(Row : Integer; Column : Integer);

   -- Gets the first room of the map
   PROCEDURE Get_Starting_Room(Row : IN OUT Integer; Column : IN OUT Integer);

   FUNCTION Take_Item(Row : Integer; Column : Integer) RETURN Boolean;

   FUNCTION Fight_Enemy(Row : Integer; Column : Integer) RETURN Boolean;

   FUNCTION Check_If_Room(Row : Integer; Column : Integer) RETURN Boolean;

   FUNCTION Check_For_Salesman(Row : Integer; Column : Integer) RETURN Boolean;
END Map_Generator;
