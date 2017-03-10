WITH Ada.Integer_Text_IO;       USE Ada.Integer_Text_IO;
WITH Ada.Float_Text_IO;         USE Ada.Float_Text_IO;

PACKAGE BODY Item_List IS

   -- Number of items available in each class. These will need updated as items are added to items.txt
   Num_Of_Consumables : CONSTANT Integer := 2;
   Num_Of_Weapons     : CONSTANT Integer := 2;
   Num_Of_Armor       : CONSTANT Integer := 2;
   -- An input string to hold information from the file that is not important to the items array
   Input              : Unbounded_String;

   -- Array to store all the items
   TYPE Items_Array_Type IS ARRAY (Integer RANGE 1..Num_Of_Consumables + Num_Of_Weapons + Num_Of_Armor) OF Item_Type;
   Items_Array : Items_Array_Type;

   -- A procedure for filling the array from a txt file
   -- Fills in this order:  1. Consumables
   --                       2. Weapons
   --                       3. Armor
   PROCEDURE Fill_Items_Array IS
      Items_File : File_Type;
   BEGIN
      -- Open items.txt
        Open(File => Items_File,
        Mode => In_File,
        Name => "items.txt");

      -- Starts a loop to grab consumable items
      FOR I IN Integer RANGE 1..Items_Array'Length LOOP
         Input := To_Unbounded_String(Get_Line(Items_File));         -- Gets the CONSUMABLES part of the file
         IF Input = "CONSUMABLE" THEN
            Items_Array(I) := (Kind_Of_Item => Consumable,
                               Name => To_Unbounded_String(Get_Line(Items_File)),
                               Description =>To_Unbounded_String(Get_Line(Items_File)),
                               Weight => Float'Value(Get_Line(Items_File)),
                               Loot_Value => Float'Value(Get_Line(Items_File)),
                               Heal_HP => Integer'Value(Get_Line(Items_File)),
                               Attack_Boost => Integer'Value(Get_Line(Items_File)),
                               Defense_Boost => Integer'Value(Get_Line(Items_File)),
                               Agility_Boost => Integer'Value(Get_Line(Items_File)),
                               Restore_MP => Integer'Value(Get_Line(Items_File)));
         ELSIF Input = "WEAPON" THEN
            Items_Array(I) := (Kind_Of_Item => Weapon,
                               Name => To_Unbounded_String(Get_Line(Items_File)),
                               Description => To_Unbounded_String(Get_Line(Items_File)),
                               Weight => Float'Value(Get_Line(Items_File)),
                               Loot_Value => Float'Value(Get_Line(Items_File)),
                               Attack => Integer'Value(Get_Line(Items_File)),
                               Defense => Integer'Value(Get_Line(Items_File)),
                               Speed => Integer'Value(Get_Line(Items_File)),
                               Is_Equipped => False);
         ELSIF Input = "ARMOR" THEN
            Items_Array(I) := (Kind_Of_Item => Armor,
                               Name => To_Unbounded_String(Get_Line(Items_File)),
                               Description => To_Unbounded_String(Get_Line(Items_File)),
                               Weight => Float'Value(Get_Line(Items_File)),
                               Loot_Value => Float'Value(Get_Line(Items_File)),
                               Attack => Integer'Value(Get_Line(Items_File)),
                               Defense => Integer'Value(Get_Line(Items_File)),
                               Speed => Integer'Value(Get_Line(Items_File)),
                               Is_Equipped => False);
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
         New_Line;
         Put("Weight: ");
         Put(Item => Items_Array(I).Weight, Aft => 1, Fore => 2, Exp => 0);
         New_Line;
         Put("Purchase Value: $");
         Put(Item => Items_Array(I).Loot_Value * 1.1, Aft => 1, Fore => 2, Exp => 0);
         New_Line;
         Put("Trade Value: $");
         Put(Item => Items_Array(I).Loot_Value * 0.75, Aft => 1, Fore => 2, Exp => 0);

         IF Items_Array(I).Kind_Of_Item = Consumable THEN
            Put("CONSUMABLE");
            New_Line;
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
         ELSIF Items_Array(I).Kind_Of_Item = Weapon OR ELSE Items_Array(I).Kind_Of_Item = Armor THEN
            IF Items_Array(I).Kind_Of_Item = Weapon THEN
               Put("WEAPON");
            ELSE
               Put("ARMOR");
            END IF;
            New_Line;
            Put("Attack Stat: ");
            Put(Items_Array(I).Attack, Width => 2);
            New_Line;
            Put("Defense Stat: ");
            Put(Items_Array(I).Defense, Width => 2);
            New_Line;
            Put("Speed Stat: ");
            Put(Items_Array(I).Speed, Width => 2);
            New_Line;
         END IF;
         New_Line;
      END LOOP;
   END Print_Items_Array;

   FUNCTION Get_Item_List_Length RETURN Integer IS
   BEGIN
      RETURN Items_Array'Length;
   END Get_Item_List_Length;

   -- Returns a record of an item from the array, associated with a passed in index
   FUNCTION Get_Item(Index : Integer) RETURN Item_Type IS
   BEGIN
      RETURN Items_Array(Index);
   END Get_Item;
END Item_List;
