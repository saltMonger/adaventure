WITH Ada.Text_IO;                     USE Ada.Text_IO;
WITH Ada.Strings.Unbounded;           USE Ada.Strings.Unbounded;
WITH Ada.Characters.Handling;         USE Ada.Characters.Handling;
WITH Ada.Numerics.Discrete_Random;
WITH Map_Generator;                   USE Map_Generator;
WITH Backpack;                        USE Backpack;
WITH Item_List;                       USE Item_List;
WITH Actor;                           USE Actor;
WITH EncounterPackage;                USE EncounterPackage;

------------------------------------------
----- THE GAME'S MAIN PROCEDURE ----------
------------------------------------------

-- SOME THINGS THAT WILL NEED MODIFIED
-- TERMINAL REPAINTING WILL NEED IMPLEMENTED
-- AN EASIER WAY OF GETTING THE STARTING ITEMS FOR THE BACKPACK WILL NEED IMPLEMENTED
-- WE MAY WANT TO LIMIT THE KINDS OF ITEMS THE PLAYER CAN GET SO THEY CANT GET A TON OF RUSTY SWORDS AND SO THERE ARENT TOO MANY EMPTY ROOMS

PROCEDURE Adventure IS

   Player1 : Actor.Actor (Option => Player);
   Save    : File_Type;

   -- Setting up a package for a random index associated with an item from the Item_List package
   SUBTYPE Item_List_Range IS Integer RANGE 1..Get_Item_List_Length;
   PACKAGE Random_Item IS NEW Ada.Numerics.Discrete_Random(Item_List_Range);
   Item_Index : Random_Item.Generator;

   Stats_Holder : Backpack.Integer_Array;

   Player_Input      : Character;        -- To get the player's key input
   Player_Command    : Unbounded_String; -- To store player command input
   Room_Coordinate_X : Integer;          -- A coordinate corresponding the row-value of the current room in the map
   Room_Coordinate_Y : Integer;          -- A coordinate corresponding to the column-value of the current room in the map
   Temp_Item_Number  : Integer;          -- Temporary storage for the index value of an item from the Item_List package

   -- A procedure to open the backpack and perform operations on player inventory
   PROCEDURE Open_Backpack IS
   BEGIN
      Check_Backpack(Backpack => Player1.Backpack);         -- Display the backpack

      -- Recieve and respond to player commands
      WHILE Player1.Backpack /= NULL LOOP
         Put("****************************************");
         New_Line;
         Put("Enter a command: ");                           -- The prompt
         Player_Command := To_Unbounded_String(Get_Line);    -- Retrieve the input

         -- If the command was to "USE" then check the remainder of the command for what is believed to be the item name
         -- and pass it into the Use_Item procedure
         IF Length(Player_Command) > 4 AND THEN To_Lower(Slice(Player_Command, 1, 3)) = To_Unbounded_String("use") THEN
            Use_Item(Backpack => Player1.Backpack,
                     Name_Of_Item => To_Unbounded_String(Slice(Player_Command, 5, Length(Player_Command))),
                     Bottom => Player1.Bottom,
                     Stats => Stats_Holder);
            Player1.Current_HP    := Stats_Holder(1) + Player1.Current_HP;
            IF Player1.Current_HP > Player1.Max_HP THEN
               Player1.Current_HP := Player1.Max_HP;
            END IF;
            Player1.Strength      := Stats_Holder(2) + Player1.Strength;
            Player1.Constitution  := Stats_Holder(3) + Player1.Constitution;
            Player1.Dexterity     := Stats_Holder(4) + Player1.Dexterity;
            Player1.MP            := Stats_Holder(5) + PLayer1.MP;
            -- If the command was to "DISCARD" then check the remainder of the command for what may be the item name
            -- and pass it into the Throw_Away_Item procedure
         ELSIF Length(Player_Command) > 8 AND THEN To_Lower(Slice(Player_Command, 1, 7)) = To_Unbounded_String("discard") THEN
               Throw_Away_Item(Backpack => Player1.Backpack,
               Name_Of_Item => To_Unbounded_String(Slice(Player_Command, 9, Length(Player_Command))),
               Bottom => Player1.Bottom);
            --If the command was to "EQUIP" then check the remainder of the command by passing it into the Equip_Armor or Equip_Weapon procedures
         ELSIF Length(Player_Command) > 6 AND THEN To_Lower(Slice(Player_Command, 1, 5)) = To_Unbounded_String("equip") THEN
            Equip(Name_Of_Desired_Equipment => To_Unbounded_String(Slice(Player_Command, 7, Length(Player_Command))),
                  Current_Weapon => Player1.Weapon,
                  Current_Armor => Player1.Armor,
                  Bottom => Player1.Bottom);
            -- If the command was to exit, return to the map
         ELSIF To_Lower(To_String(Player_Command)) = "exit" THEN
            RETURN;
         ELSE         -- If none of the above apply, let the player know their command was not recognized
            Put("That is not a valid command.");
         END IF;

         New_Line;
         Check_Backpack(Backpack => Player1.Backpack);      -- Redisplay the backpack, in case any user operations may have altered the contents
      END LOOP;
   END Open_Backpack;

BEGIN
   -- Create the player character
   Open(File => Save,
        Mode => In_File,
        Name => "player.txt");
   Actor.Create_Actor(Save, Player1, Player);
   Close(Save);

   -- Compiles an array of items from information from a file
   Fill_Items_Array;

   -- Reset the random seed for choosing items found in the field
   Random_Item.Reset(Item_Index);

   -- Fill the player's backpack with a rusty sword, cloth tunic, 5 potions and 1 spinach to get them started
   Initialize_Backpack(Backpack => Player1.Backpack, Bottom   => Player1.Bottom);

   -- Equip the player with a starting weapon and armor
   Equip(Name_Of_Desired_Equipment => To_Unbounded_String ("Rusty Sword"),
         Current_Weapon            => Player1.Weapon,
         Current_Armor             => Player1.Armor,
         Bottom                    => Player1.Bottom);
   Equip(Name_Of_Desired_Equipment => To_Unbounded_String ("Cloth Tunic"),
         Current_Weapon            => Player1.Weapon,
         Current_Armor             => Player1.Armor,
         Bottom                    => Player1.Bottom);

   -- Initializes the map to all 0s
   Initialize_Empty_Map;

   -- Generates the random rooms
   Generate_Random_Map;

   New_Line;

   -- Grab the coordinates of the starting room
   Get_Starting_Room(Row => Room_Coordinate_X, Column => Room_Coordinate_Y);

   -- Begin the game loop
   LOOP
      -- Reset the values in the stats holder in case the player attempts to use an item that doesn't exist later
      FOR I IN Integer RANGE 1..Stats_Holder'Last LOOP
         Stats_Holder(I) := 0;
      END LOOP;

      -- Print the map
      Print_Map(Row => Room_Coordinate_X, Column => Room_Coordinate_Y);

      -- Print the room the player is currently in
      Print_Current_Room(Row => Room_Coordinate_X, Column => Room_Coordinate_Y);

      -- Get any character input the player enters in
      Get_Immediate(Item => Player_Input);
      New_Line;

      -- Respond to the player's character input
      CASE Player_Input IS
         WHEN 'm' =>
            Display_Actor_Stats(Player1, Player);
            Put("Press any key to continue: ");
            Get_Immediate(Item => Player_Input);
         -- 'b' opens the player backpack
         WHEN 'b' =>
            Open_Backpack;
         -- 'e' attempts to pick up any available items the room may have
         WHEN 'i' =>
            IF Take_Item(
                  Row    => Room_Coordinate_X,
                  Column => Room_Coordinate_Y) = True THEN
               Temp_Item_Number := Random_Item.Random(Item_Index);
               Put("You found a ");
               Put(To_String(Get_Item(Temp_Item_Number).Name));
               Put("!");
               Found_Item(
                  Item_Record => Get_Item (Temp_Item_Number),
                  Backpack    => Player1.Backpack,
                  Bottom      => Player1.Bottom);
            ELSE            -- In case the player tries to pick up an item when the room contains no items
               Put("This room holds nothing of value.");
            END IF;
         WHEN 'e' => -- START ENCOUNTER
            IF Fight_Enemy(Row => Room_Coordinate_X, Column => Room_Coordinate_Y) = True THEN
               EncounterPackage.RandomEncounter(Player1);
            ELSE
               Put("You're trying to fight... no one?");
            END IF;
         -- 'w' checks if there is a room to the north and if there is, it moves the player to that room
         WHEN 'w' =>
            IF Check_If_Room(Room_Coordinate_X - 1, Room_Coordinate_Y) = True THEN
               Room_Coordinate_X := Room_Coordinate_X - 1;
            ELSE
               Put("There is no room to the north.");
            END IF;
         -- 'a' checks if there is a room to the west and if there is, it moves the player to that room
         WHEN 'a' =>
            IF Check_If_Room(Room_Coordinate_X, Room_Coordinate_Y - 1) = True THEN
               Room_Coordinate_Y := Room_Coordinate_Y - 1;
            ELSE
               Put("There is no room to the west.");
            END IF;
         -- 's' checks if there is a room to the south and if there is, it moves the player to that room
         WHEN 's' =>
            IF Check_If_Room(Room_Coordinate_X + 1, Room_Coordinate_Y) = True THEN
               Room_Coordinate_X := Room_Coordinate_X + 1;
            ELSE
               Put("There is no room to the south.");
            END IF;
         -- 'd' checks if there is a room to the east and if there is, it moves the player to that room
         WHEN 'd' =>
            IF Check_If_Room(Room_Coordinate_X, Room_Coordinate_Y + 1) = True THEN
               Room_Coordinate_Y := Room_Coordinate_Y + 1;
            ELSE
               Put("There is no room to the east.");
            END IF;
         -- 'q' allows the player to exit the game
         WHEN 'q' =>
            Put("Now exiting the application.");
            RETURN;
         WHEN OTHERS =>
            NULL;
      END CASE;
      New_Line;
   END LOOP;
END Adventure;
