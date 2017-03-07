WITH Ada.Text_IO;              USE Ada.Text_IO;
WITH Ada.Strings.Unbounded;    USE Ada.Strings.Unbounded;
WITH Ada.Characters.Handling;  USE Ada.Characters.Handling;
WITH Map_Generator;            USE Map_Generator;
WITH Backpack;                 USE Backpack;
WITH Item_List;                USE Item_List;
WITH Actor;                    USE Actor;

PROCEDURE Adventure IS
   Player_Input : Character;
   Player_Command : Unbounded_String;
   Backpack : Zipper;
   Bottom   : Zipper;
   Room_Coordinate_X : Integer;
   Room_Coordinate_Y : Integer;

   PROCEDURE Open_Backpack IS
   BEGIN
      Check_Backpack(Backpack => Backpack);

      WHILE Backpack /= NULL LOOP
         Put("Enter a command: ");
         Player_Command := To_Unbounded_String(Get_Line);

         IF Length(Player_Command) > 4 AND THEN To_Lower(Slice(Player_Command, 1, 3)) = To_Unbounded_String("use") THEN
            -- Needs to changed to use item once player has been added to the code
            Throw_Away_Item(Backpack => Backpack,
                            Name_Of_Item => To_Unbounded_String(Slice(Player_Command, 5, Length(Player_Command))),
                            Bottom => Bottom);
         ELSIF Length(Player_Command) > 8 AND THEN To_Lower(Slice(Player_Command, 1, 7)) = To_Unbounded_String("discard") THEN
            Throw_Away_Item(Backpack => Backpack,
                            Name_Of_Item => To_Unbounded_String(Slice(Player_Command, 9, Length(Player_Command))),
                            Bottom => Bottom);
         ELSIF Length(Player_Command) > 6 AND THEN To_Lower(Slice(Player_Command, 1, 5)) = To_Unbounded_String("equip") THEN
            -- Either Equip_Armor or Equip_Weapon
            Put("Testing");
         ELSIF To_Lower(To_String(Player_Command)) = "exit" THEN
            RETURN;
         ELSE
            Put("That is not a valid command.");
         END IF;

         New_Line;
         Check_Backpack(Backpack);
      END LOOP;
   END Open_Backpack;

BEGIN

   -- Compiles an array of items from information from a file
   Fill_Items_Array;

   -- Initializes the map to all 0s
   Initialize_Empty_Map;

   -- Generates the random rooms
   Generate_Random_Map;

   New_Line;

   -- Grab the coordinates of the starting room
   Get_Starting_Room(Row => Room_Coordinate_X, Column => Room_Coordinate_Y);

   -- Begin the game loop
   LOOP
      -- Print the map
      Print_Map;

      -- Print the room the player is currently in
      Print_Current_Room(Row => Room_Coordinate_X, Column => Room_Coordinate_Y);

      -- Get any character input the player enters in
      Get_Immediate(Item => Player_Input);
      New_Line;

      -- Respond to user character input
      CASE Player_Input IS
         WHEN 'b' => Open_Backpack;
         WHEN 'm' => Put("You have accessed the menu");
         WHEN 'e' => Put("You have interacted with an item");
                     New_Line;
                     Put("You found a ");
                     Put(To_String(Get_Item(1).Name));
                     Put("!");
                     Found_Item(Item_Record => Get_Item(1), Backpack => Backpack, Bottom => Bottom);
         WHEN 'w' => IF Check_If_Room(Room_Coordinate_X - 1, Room_Coordinate_Y) = True THEN
                        Room_Coordinate_X := Room_Coordinate_X - 1;
                     ELSE
                        Put("There is no room to the north.");
                     END IF;
         WHEN 'a' => IF Check_If_Room(Room_Coordinate_X, Room_Coordinate_Y - 1) = True THEN
                        Room_Coordinate_Y := Room_Coordinate_Y - 1;
                     ELSE
                        Put("There is no room to the west.");
                     END IF;
         WHEN 's' => IF Check_If_Room(Room_Coordinate_X + 1, Room_Coordinate_Y) = True THEN
                        Room_Coordinate_X := Room_Coordinate_X + 1;
                     ELSE
                        Put("There is no room to the south.");
                     END IF;
         WHEN 'd' => IF Check_If_Room(Room_Coordinate_X, Room_Coordinate_Y + 1) = True THEN
                        Room_Coordinate_Y := Room_Coordinate_Y + 1;
                     ELSE
                        Put("There is no room to the east.");
                     END IF;
         WHEN 'q' => Put("Now exiting the application.");
                     RETURN;
         WHEN OTHERS => NULL;
      END CASE;

      EXIT WHEN Player_Input = 'q';
      New_Line;
   END LOOP;
END Adventure;
