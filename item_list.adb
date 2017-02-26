WITH Ada.Integer_Text_IO;       USE Ada.Integer_Text_IO;
WITH Ada.Float_Text_IO;         USE Ada.Float_Text_IO;

PACKAGE BODY Item_List IS

   -- Number of items available in each class. These will need updated as items are added to items.txt
   Num_Of_Consumables : CONSTANT Integer := 2;
   Num_Of_Weapons     : CONSTANT Integer := 2;
   Num_Of_Armor       : CONSTANT Integer := 2;
   -- An input string to hold information from the file that is not important to the items array
   Input              : Unbounded_String;
   Item_Flag          : Boolean;               -- A flag to assist setting the Is_Weapon and Is_Armor flags

   -- Array to store all the items
   TYPE Items_Array_Type IS ARRAY (Integer RANGE 1..Num_Of_Consumables + Num_Of_Weapons + Num_Of_Armor) OF Item_Type;
   Items_Array : Items_Array_Type;

   -- A procedure for filling the array from a txt file
   -- Fills in this order:  1. Consumables
   --                       2. Weapons
   --                       3. Armor
   PROCEDURE Fill_Items_Array(Items_File : IN OUT File_Type) IS
   BEGIN
      Input := To_Unbounded_String(Get_Line(Items_File));         -- Gets the CONSUMABLES part of the file
      -- Starts a loop to grab consumable items
      FOR I IN Integer RANGE 1..Num_Of_Consumables LOOP
            Items_Array(I) := (Kind_Of_Item => Consumable,
                               Name => To_Unbounded_String(Get_Line(Items_File)),
                               Description =>To_Unbounded_String(Get_Line(Items_File)),
                               Weight => Float'Value(Get_Line(Items_File)),
                               Is_Consumable => True,
                               Is_Weapon => False,
                               Is_Armor => False,
                               Heal_HP => Integer'Value(Get_Line(Items_File)),
                               Attack_Boost => Integer'Value(Get_Line(Items_File)),
                               Defense_Boost => Integer'Value(Get_Line(Items_File)),
                               Agility_Boost => Integer'Value(Get_Line(Items_File)),
                               Restore_MP => Integer'Value(Get_Line(Items_File)));
      END LOOP;
      -- Gets the WEAPONS part of the file
      Input := To_Unbounded_String(Get_Line(Items_File));
      -- Set a flag to assist in setting the Is_Weapon and Is_Armor flags
      Item_Flag := True;
      FOR I IN Integer RANGE Num_Of_Consumables + 1..Items_Array'Length LOOP
         Items_Array(I) := (Kind_Of_Item => Weapon,
                            Name => To_Unbounded_String(Get_Line(Items_File)),
                            Description => To_Unbounded_String(Get_Line(Items_File)),
                            Weight => Float'Value(Get_Line(Items_File)),
                            Is_Consumable => False,
                            Is_Weapon => Item_Flag,                           -- When the flag is true, the item is a weapon
                            Is_Armor => NOT Item_Flag,                        -- Once the flag is false, the item is a piece of armor
                            Attack => Integer'Value(Get_Line(Items_File)),
                            Defense => Integer'Value(Get_Line(Items_File)),
                            Speed => Integer'Value(Get_Line(Items_File)));
      IF I = Num_Of_Weapons + Num_Of_Consumables THEN               -- If the start of the ARMOR part of the file is reached
            Input := To_Unbounded_String(Get_Line(Items_File));        -- Gets the ARMOR line of the file
            Item_Flag := False;                                       -- Sets the item flag to false indicating armor
      END IF;
      END LOOP;
   END Fill_Items_Array;

   -- Prints all information about each item
   PROCEDURE Print_Items_Array IS
   BEGIN
      FOR I IN Integer RANGE 1..Items_Array'Length LOOP
         Put(To_String(Items_Array(I).Name));
         New_Line;
         Put(To_String(Items_Array(I).Description));
         New_Line;         Put("Weight: ");
         Put(Item => Items_Array(I).Weight, Aft => 1, Fore => 2, Exp => 0);
         New_Line;
         Put("Is it consumable? ");
         Put(Boolean'Image(Items_Array(I).Is_Consumable));
         New_Line;
         Put("Is it a weapon? ");
         Put(Boolean'Image(Items_Array(I).Is_Weapon));
         New_Line;
         Put("Is it armor? ");
         Put(Boolean'Image(Items_Array(I).Is_Armor));
         New_Line;
         IF Items_Array(I).Is_Consumable = True THEN
            Put("Health Affect: ");
            Put(Items_Array(I).Heal_HP, Width => 2);
            New_Line;
            Put("Attack Boost: ");
            Put(Items_Array(I).Attack_Boost, Width => 2);
            New_Line;
            Put("Defense Boost: ");
            Put(Items_Array(I).Defense_Boost, Width => 2);
            New_Line;
            Put("Agility Boost: ");
            Put(Items_Array(I).Agility_Boost, Width => 2);
            New_Line;
            Put("Restore MP: ");
            Put(Items_Array(I).Restore_MP, Width => 2);
            New_Line;
            New_Line;
         ELSIF Items_Array(I).Is_Weapon = True OR ELSE Items_Array(I).Is_Armor THEN
            Put("Attack Stat: ");
            Put(Items_Array(I).Attack, Width => 2);
            New_Line;
            Put("Defense Stat: ");
            Put(Items_Array(I).Defense, Width => 2);
            New_Line;
            Put("Speed Stat: ");
            Put(Items_Array(I).Speed, Width => 2);
            New_Line;
            New_Line;
         END IF;
      END LOOP;
   END Print_Items_Array;
END Item_List;
