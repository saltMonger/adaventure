WITH Ada.Text_IO;                     USE Ada.Text_IO;                           -- For string IO and file IO
WITH Ada.Strings.Unbounded;           USE Ada.Strings.Unbounded;                 -- For unbounded strings
WITH Ada.Characters.Handling;         USE Ada.Characters.Handling;               -- For To_Lower
WITH Ada.Numerics.Discrete_Random;                                               -- For random number generation
WITH Map_Generator;                   USE Map_Generator;                         -- Random map generator package
WITH Backpack;                        USE Backpack;                              -- A package to provide and handle a backpack of items
WITH Item_List;                       USE Item_List;                             -- A package to store info about the game's available items
WITH Actor;                           USE Actor;                                 -- A package to provide and handle info about the player and enemies
WITH EncounterPackage;                USE EncounterPackage;                      -- A package to handle battle encounters
WITH Interfaces.C;                    USE Interfaces.C;                          -- A package to handle passing commands to the operating system
WITH Alchemy_Tree;                    USE Alchemy_Tree;                          -- A package to handle an alchemy tree for synthesizing items

------------------------------------------
----- THE GAME'S MAIN PROCEDURE ----------
------------------------------------------

-- SOME THINGS THAT WILL NEED MODIFIED
   -- WE MAY WANT TO LIMIT THE KINDS OF ITEMS THE PLAYER CAN GET SO THEY CANT GET A TON OF RUSTY SWORDS AND SO THERE ARENT TOO MANY EMPTY ROOMS

PROCEDURE Adventure IS

   -- Setting up variables for the player
   Player1 : Actor.Actor (Option => Player);
   Save    : File_Type;

   -- Needed to pass commands to the operating system for screen clearing
   FUNCTION Sys(Arg : Char_Array) RETURN Integer;
   PRAGMA Import(C, Sys, "system");
   Ret_Val : Integer;

   -- Setting up a package for a random index associated with an item from the Item_List package
   SUBTYPE Item_List_Range IS Integer RANGE 1..Get_Item_List_Length;
   PACKAGE Random_Item IS NEW Ada.Numerics.Discrete_Random(Item_List_Range);
   Item_Index : Random_Item.Generator;

   Stats_Holder : Backpack.Integer_Array;   -- An array to store the stat changes coming from an item

   Player_Input      : Character;                                      -- To get the player's key input
   Player_Command    : Unbounded_String;                               -- To store player command input
   Room_Coordinate_X : Integer := 0;                                   -- A coordinate corresponding the row-value of the current room in the map
   Room_Coordinate_Y : Integer := 0;                                   -- A coordinate corresponding to the column-value of the current room in the map
   Temp_Item_Number  : Integer;                                        -- Temporary storage for the index value of an item from the Item_List package
   User_Message      : Unbounded_String := To_Unbounded_String("Press 'h' for help");    -- A string to store messages to the user after the screen repaints
   Ingredient1       : Unbounded_String;                               -- An ingredient for synthesis
   Ingredient2       : Unbounded_String;                               -- An ingredient for synthesis
   Creation          : Item_Type;                                      -- An item created from synthesis
   Synth_Tree        : Alchemy_Tree.Node_Ptr;                          -- A pointer to a tree that holds recipes

   -- Prints a list of commands available to the player
   -- Some are key commands on the map screen
   -- Some are string commands on the backpack screen
   PROCEDURE Print_Help_Screen IS
   BEGIN
      Ret_Val := Sys(To_C("cls"));
      Put("MAP KEY COMMANDS: ");
      New_Line;
      Put("'w', 'a', 's', and 'd': North, West, South, and East, respectively");
      New_Line;
      New_Line;
      Put("'b': Opens the player's backpack");
      New_Line;
      New_Line;
      Put("'i': Pick up an item, if the room contains an item. If there are no items, the game will let you know");
      New_Line;
      New_Line;
      Put("'e': Fight an enemy, if the room contains an enemy. If there are no enemies, the game will let you know");
      New_Line;
      New_Line;
      Put("'m': Open the player menu to view the player's stats");
      New_Line;
      New_Line;
      Put("'q': Quits the game instantly");
      New_Line;
      New_Line;
      Put("BACKPACK COMMANDS");
      New_Line;
      Put("'use <item name>': Uses a consumable item to affect player stats. This command does not do anything for weapons/armor");
      New_Line;
      New_Line;
      Put("'discard <item name>': Discards an unwanted item, provided it is not a weapon/armor currently equipped to the player");
      New_Line;
      New_Line;
      Put("'equip <item name>': Equips a weapon/armor to the player and unequips the currently equipped weapon/armor");
      New_Line;
      New_Line;
      Put("'synth': Prompts you to enter 2 ingredients, one at a time, and then creates a new item.");
      New_Line;
      Put("   The ingredients you enter must match a valid recipe and you must have enough ingredients in your backpack ");
      New_Line;
      Put("   to create the new item.");
      New_Line;
      Put("   If you attempt to use an equipped weapon/armor as an ingredient, ");
      New_Line;
      Put("   the game will NOT create the item for you.");
      New_Line;
      New_Line;
      Put("'recipes': Prints a list of available recipes to synthesize");
      New_Line;
      New_Line;
      Put("'exit': Exits the backpack and returns to the previous screen.");
      New_Line;
      New_Line;
      Put("Enter any key to continue: ");
      Get_Immediate(Item => Player_Input);
   END Print_Help_Screen;

   -- A procedure to remove equipment stats from the player when a piece of equipment is removed
   PROCEDURE Remove_Equip_Stats(Player1 : IN OUT Actor.Actor) IS
   BEGIN
      Player1.Strength := Player1.Strength - Player1.Weapon.Attack - Player1.Armor.Attack;
      Player1.Constitution := Player1.Constitution - Player1.Weapon.Defense - Player1.Armor.Defense;
      Player1.Dexterity := Player1.Dexterity - Player1.Weapon.Speed - Player1.Armor.Speed;
   END Remove_Equip_Stats;

   -- A procedure to apply equipment stats to the player when a piece of equipment is newly equipped
   PROCEDURE Apply_Equip_Stats(Player1 : IN OUT Actor.Actor) IS
   BEGIN
      Player1.Strength := Player1.Strength + Player1.Weapon.Attack + Player1.Armor.Attack;
      Player1.Constitution := Player1.Constitution + Player1.Weapon.Defense + Player1.Armor.Defense;
      Player1.Dexterity := Player1.Dexterity + Player1.Weapon.Speed + Player1.Armor.Speed;
   END Apply_Equip_Stats;

   -- A procedure to open the backpack and perform operations on player inventory
   PROCEDURE Open_Backpack IS
   BEGIN
      User_Message := To_Unbounded_String("");   -- Reset the user message after it's displayed
      Check_Backpack(Backpack => Player1.Backpack, Player_HP => Player1.Current_HP, Battle_Flag => False);         -- Display the backpack

      -- Recieve and respond to player commands
      WHILE Player1.Backpack /= NULL LOOP
         New_Line;
         New_Line;
         Put("Enter a command: ");                           -- The prompt
         Player_Command := To_Unbounded_String(Get_Line);    -- Retrieve the input

         -- If the command is "recipes", open the recipes list for the user to see
         -- LNR traversal of the synthesis tree
         IF To_Lower(To_String(Player_Command)) = To_Unbounded_String("recipes") THEN
            Ret_Val := Sys(To_C("cls"));
            Put("RECIPES LIST: ");
            New_Line;
            Print_Tree(Root => Synth_Tree);
            New_Line;
            Put("Press any key to continue: ");
            Get_Immediate(Item => Player_Input);
         -- If the command was to "USE" then check the remainder of the command for what is believed to be the item name
         -- and pass it into the Use_Item procedure
         ELSIF Length(Player_Command) > 4 AND THEN To_Lower(Slice(Player_Command, 1, 3)) = To_Unbounded_String("use") THEN
            Use_Item(Backpack => Player1.Backpack,
                     Name_Of_Item => To_Unbounded_String(Slice(Player_Command, 5, Length(Player_Command))),
                     Bottom => Player1.Bottom,
                     Stats => Stats_Holder,
                     User_Message => User_Message);
               Player1.Current_HP    := Stats_Holder(1) + Player1.Current_HP;
               IF Player1.Current_HP > Player1.Max_HP THEN
                  Player1.Current_HP := Player1.Max_HP;
               END IF;
               -- Add the stat effects to the player's stats
               Player1.Strength      := Stats_Holder(2) + Player1.Strength;
               Player1.Constitution  := Stats_Holder(3) + Player1.Constitution;
               Player1.Dexterity     := Stats_Holder(4) + Player1.Dexterity;
               Player1.MP            := Stats_Holder(5) + PLayer1.MP;
            -- If the command was to "DISCARD" then check the remainder of the command for what may be the item name
            -- and pass it into the Throw_Away_Item procedure
         ELSIF Length(Player_Command) > 8 AND THEN To_Lower(Slice(Player_Command, 1, 7)) = To_Unbounded_String("discard") THEN
               Throw_Away_Item(Backpack => Player1.Backpack,
                               Name_Of_Item => To_Unbounded_String(Slice(Player_Command, 9, Length(Player_Command))),
                               Bottom => Player1.Bottom,
                               User_Message => User_Message);
         --If the command was to "EQUIP" then check the remainder of the command by passing it into the Equip_Armor or Equip_Weapon procedures
         ELSIF Length(Player_Command) > 6 AND THEN To_Lower(Slice(Player_Command, 1, 5)) = To_Unbounded_String("equip") THEN
            -- Remove the current weapon's stat effects
            Remove_Equip_Stats(Player1);
            -- Equip the new weapon
            Equip(Name_Of_Desired_Equipment => To_Unbounded_String(Slice(Player_Command, 7, Length(Player_Command))),
                  Current_Weapon => Player1.Weapon,
                  Current_Armor => Player1.Armor,
                  Bottom => Player1.Bottom,
                  User_Message => User_Message);
            -- Add the new weapon's stat effects
            Apply_Equip_Stats(Player1);
         -- If the command was to synthesize, find the recipe, and create the item if the recipe is valid
         ELSIF To_Lower(To_String(Player_Command)) = To_Unbounded_String("synth") THEN
            Put("Ingredient 1: ");
            Ingredient1 := To_Unbounded_String(Get_Line);
            Put("Ingredient 2: ");
            Ingredient2 := To_Unbounded_String(Get_Line);
            IF Ingredient1 = Ingredient2 AND THEN Check_For_Item(Backpack => Player1.Backpack, Item_Name => Ingredient1, How_Many => 2) = False THEN
               User_Message := To_Unbounded_String("You don't have those/enough ingredients");
            ELSIF Check_For_Item(Backpack => Player1.Backpack, Item_Name => Ingredient1, How_Many => 1) = False OR
                  Check_For_Item(Backpack => Player1.Backpack, Item_Name => Ingredient2, How_Many => 1) = False THEN
               User_Message := To_Unbounded_String("You don't have those/enough ingredients");
            ELSE
               -- Find the recipe and create the item
               IF Ingredient1 > Ingredient2 THEN      -- Make sure ingredient1 comes before ingredient2 alphabetically
                  Synthesize(Ingredient1 => Ingredient2, Ingredient2 => Ingredient1, Creation => Creation, Root => Synth_Tree);
               ELSE
                  Synthesize(Ingredient1 => Ingredient1, Ingredient2 => Ingredient2, Creation => Creation, Root => Synth_Tree);
               END IF;

               IF Creation.Name = To_Unbounded_String("") THEN
                  User_Message := To_Unbounded_String("That is not a valid recipe");
               ELSE
                  Found_Item(Item_Record => Creation, Backpack => Player1.Backpack, Bottom => Player1.Bottom);
                  Throw_Away_Item(Backpack => Player1.Backpack,      -- Discard the first item in the recipe
                            Name_Of_Item => Ingredient1,
                            Bottom => Player1.Bottom,
                            User_Message => User_Message);
                  Throw_Away_Item(Backpack => Player1.Backpack,      -- Discard the second item in the recipe
                            Name_Of_Item => Ingredient2,
                            Bottom => Player1.Bottom,
                            User_Message => User_Message);
               END IF;
            END IF;
            -- If the command was to exit, return to the map
         ELSIF To_Lower(To_String(Player_Command)) = "exit" THEN
            IF Check_Weight = False THEN
               User_Message := To_Unbounded_String("You must decrease your backpack's weight before you can move on. What a hoarder...");
            ELSE
               RETURN;
            END IF;
         ELSE         -- If none of the above apply, let the player know their command was not recognized
            User_Message := To_Unbounded_String("That is not a valid command.");
         END IF;

         -- Redisplay the possibly updated backpack to the user
         New_Line;
         Ret_Val := Sys(To_C("cls"));
         Check_Backpack(Backpack => Player1.Backpack, Player_HP => Player1.Current_HP, Battle_Flag => False);      -- Redisplay the backpack, in case any user operations may have altered the contents
         Put(To_String(User_Message));
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

   -- Fill in the tree with the synth_items file
   Build_Tree(File_Name => To_Unbounded_String("synth_items.txt"), Root => Synth_Tree);

   -- Reset the random seed for choosing items found in the field
   Random_Item.Reset(Item_Index);

   -- Fill the player's backpack with a rusty sword, cloth tunic, 5 potions and 1 spinach to get them started
   Initialize_Backpack(Backpack => Player1.Backpack, Bottom   => Player1.Bottom);

   -- Equip the player with a starting weapon and armor
   Equip(Name_Of_Desired_Equipment => To_Unbounded_String ("Rusty Sword"),
         Current_Weapon            => Player1.Weapon,
         Current_Armor             => Player1.Armor,
         Bottom                    => Player1.Bottom,
         User_Message => User_Message);
   Equip(Name_Of_Desired_Equipment => To_Unbounded_String ("Cloth Tunic"),
         Current_Weapon            => Player1.Weapon,
         Current_Armor             => Player1.Armor,
         Bottom                    => Player1.Bottom,
         User_Message              => User_Message);
   Apply_Equip_Stats(Player1);

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

      Put(To_String(User_Message));
      User_Message := To_Unbounded_String("Press 'h' for help");

      -- Get any character input the player enters in
      IF Check_Weight = True THEN
         Get_Immediate(Item => Player_Input);
         New_Line;
      ELSE
         Player_Input := 'b';
      END IF;

      Ret_Val := Sys(To_C("cls"));

      -- Respond to the player's character input
      CASE Player_Input IS
         -- TRAVELING SALESMAN IS NOT FINISHED
        -- WHEN 't' =>
           -- IF Check_For_Salesman(Row => Room_Coordinate_X, Column => Room_Coordinate_Y) THEN
            --   SalesmanSays(Player => Player1);
               --Salesman_Menu;
           -- ELSE
           --    User_Message := To_Unbounded_String("There's nothing to buy here. Or anyone to buy from for that matter...");
           -- END IF;
         WHEN 'm' =>
            Display_Actor_Stats(Player1, Player);
            Put("Press any key to continue: ");
            Get_Immediate(Item => Player_Input);
         -- 'b' opens the player backpack
         WHEN 'b' =>
            IF Check_Weight = False THEN
               User_Message := To_Unbounded_String("You have too much stuff in your backpack. Lighten your load before moving on.");
               New_Line;
            END IF;
            Open_Backpack;
            User_Message := To_Unbounded_String("Press 'h' for help");
         -- 'e' attempts to pick up any available items the room may have
         WHEN 'i' =>
            IF Take_Item(Row    => Room_Coordinate_X,
                         Column => Room_Coordinate_Y) = True THEN
               Temp_Item_Number := Random_Item.Random(Item_Index);
               User_Message := "You found a " & Get_Item(Temp_Item_Number).Name & "!";
               Found_Item(Item_Record => Get_Item (Temp_Item_Number), Backpack => Player1.Backpack, Bottom => Player1.Bottom);
            ELSE            -- In case the player tries to pick up an item when the room contains no items
               User_Message := To_Unbounded_String("This room holds nothing of value.");
            END IF;
         WHEN 'e' => -- START ENCOUNTER
            IF Fight_Enemy(Row => Room_Coordinate_X, Column => Room_Coordinate_Y) = True THEN
               EncounterPackage.RandomEncounter(Player1);
            ELSE
               User_Message := To_Unbounded_String("You're trying to fight... no one?");
            END IF;
         -- 'w' checks if there is a room to the north and if there is, it moves the player to that room
         WHEN 'w' =>
            IF Check_If_Room(Room_Coordinate_X - 1, Room_Coordinate_Y) = True THEN
               Room_Coordinate_X := Room_Coordinate_X - 1;
            ELSE
               User_Message := To_Unbounded_String("There is no room to the north.");
            END IF;
         -- 'a' checks if there is a room to the west and if there is, it moves the player to that room
         WHEN 'a' =>
            IF Check_If_Room(Room_Coordinate_X, Room_Coordinate_Y - 1) = True THEN
               Room_Coordinate_Y := Room_Coordinate_Y - 1;
            ELSE
               User_Message := To_Unbounded_String("There is no room to the west.");
            END IF;
         -- 's' checks if there is a room to the south and if there is, it moves the player to that room
         WHEN 's' =>
            IF Check_If_Room(Room_Coordinate_X + 1, Room_Coordinate_Y) = True THEN
               Room_Coordinate_X := Room_Coordinate_X + 1;
            ELSE
               User_Message := To_Unbounded_String("There is no room to the south.");
            END IF;
         -- 'd' checks if there is a room to the east and if there is, it moves the player to that room
         WHEN 'd' =>
            IF Check_If_Room(Room_Coordinate_X, Room_Coordinate_Y + 1) = True THEN
               Room_Coordinate_Y := Room_Coordinate_Y + 1;
            ELSE
               User_Message := To_Unbounded_String("There is no room to the east.");
            END IF;
         -- 'q' allows the player to exit the game
         WHEN 'h' =>
            Print_Help_Screen;
         WHEN 'q' =>
            RETURN;
         WHEN OTHERS =>
            User_Message := To_Unbounded_String("Not really sure what you're trying to do, pal...");
      END CASE;
      New_Line;
      Ret_Val := Sys(To_C("cls"));
   END LOOP;
END Adventure;
