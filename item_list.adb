WITH Ada.Integer_Text_IO;       USE Ada.Integer_Text_IO;
WITH Ada.Float_Text_IO;         USE Ada.Float_Text_IO;

PACKAGE BODY Item_List IS

   -- Number of items available in each class. These will need updated as items are added to items.txt
   Num_Of_Consumables : CONSTANT Integer := 2;
   Num_Of_Weapons     : CONSTANT Integer := 2;
   Num_Of_Armor       : CONSTANT Integer := 2;

   -- Arrays to store the different item types
   TYPE Consumables_Array_Type IS ARRAY (Integer RANGE 1..Num_Of_Consumables) OF Consumable;
   TYPE Weapons_Array_Type IS ARRAY (Integer RANGE 1..Num_Of_Weapons) OF Weapon;
   TYPE Armor_Array_Type IS ARRAY (Integer RANGE 1..Num_Of_Armor) OF Armor;

   Consumables_Array : Consumables_Array_Type;
   Weapons_Array     : Weapons_Array_Type;
   Armor_Array       : Armor_Array_Type;
   Input_Buffer      : Unbounded_String;         -- An input variable to assist with an issue that file reading seems to have with unbounded strings

   -- This procedure loads the consumables information from the items.txt file into
   -- the consumables array
   PROCEDURE Create_Consumables_List(Items_File : IN OUT File_Type) IS
   BEGIN
      Input_Buffer := To_Unbounded_String(Get_Line(Items_File));         -- Skip the CONSUMABLES title in the items.txt file
      FOR I IN Integer RANGE 1..Num_Of_Consumables LOOP
         Consumables_Array(i).Name := To_Unbounded_String(Get_Line(Items_File));
         Consumables_Array(I).Description := To_Unbounded_String(Get_Line(Items_File));
         Get(Item => Consumables_Array(i).Weight,        File => Items_File);
         Get(Item => Consumables_Array(i).Stat_Value,    File => Items_File);
         Get(Item => Consumables_Array(i).Heal_HP,       File => Items_File);
         Get(Item => Consumables_Array(i).Attack_Boost,  File => Items_File);
         Get(Item => Consumables_Array(i).Defense_Boost, File => Items_File);
         Get(Item => Consumables_Array(i).Agility_Boost, File => Items_File);
         Get(Item => Consumables_Array(I).Restore_MP, File => Items_File);
         -- Push the file reader to the correct line for re-looping or for the weapons procedure to pick up at the correct line
         Input_Buffer := To_Unbounded_String(Get_Line(Items_File));
      END LOOP;
   END Create_Consumables_List;

   -- A procedure for printing the names, descriptions, and weights of all of the consumable items
   PROCEDURE Print_Consumables IS
   BEGIN
      FOR i IN Integer RANGE 1..Num_Of_Consumables LOOP
         Put(To_String(Consumables_Array(i).Name));
         New_Line;
         Put(To_String(Consumables_Array(i).Description));
         New_Line;
         Put(Item => "Weight: ");
         Put(Item => Consumables_Array(i).Weight, Fore => 2, Aft => 1, Exp => 0);
         New_Line;
         New_Line;
      END LOOP;
   END Print_Consumables;

   -- A procedure to load weapon information from items.txt into the weapon array
   PROCEDURE Create_Weapons_List(Items_File : IN OUT File_Type) IS
   BEGIN
      Input_Buffer := To_Unbounded_String(Get_Line(Items_File));                     -- Skip the WEAPONS title in items.txt
      FOR i IN Integer RANGE 1..Num_Of_Weapons LOOP
         Weapons_Array(i).Name := To_Unbounded_String(Get_Line(Items_File));
         Weapons_Array(i).Description := To_Unbounded_String(Get_Line(Items_File));
         Get(Item => Weapons_Array(i).Weight, File => Items_File);
         Get(Item => Weapons_Array(i).Attack, File => Items_File);
         Get(Item => Weapons_Array(i).Speed,  File => Items_File);
         Input_Buffer := To_Unbounded_String(Get_Line(Items_File));                  -- Another jump to the correct line
      END LOOP;
   END Create_Weapons_List;

   -- A procedure to print all weapon names, descriptions, and weights
   PROCEDURE Print_Weapons IS
   BEGIN
      FOR i IN Integer RANGE 1..Num_Of_Weapons LOOP
         Put(To_String(Weapons_Array(i).Name));
         New_Line;
         Put(To_String(Weapons_Array(i).Description));
         New_Line;
         Put("Weight: ");
         Put(Item => Weapons_Array(i).Weight, Fore => 2, Aft => 1, Exp => 0);
         New_Line;
         New_Line;
      END LOOP;
   END Print_Weapons;

   -- A procedure to load armor information from items.txt into the armor array
   PROCEDURE Create_Armor_List(Items_File : IN OUT File_Type) IS
   BEGIN
      Input_Buffer := To_Unbounded_String(Get_Line(Items_File));
      FOR i IN Integer RANGE 1..Num_Of_Armor LOOP
         Armor_Array(i).Name := To_Unbounded_String(Get_Line(Items_File));
         Armor_Array(I).Description := To_Unbounded_String(Get_Line(Items_File));
         Get(Item => Armor_Array(i).Weight,  File => Items_File);
         Get(Item => Armor_Array(i).Armor,   File => Items_File);
         Get(Item => Armor_Array(i).Speed,   File => Items_File);
         IF i /= Num_Of_Armor THEN                                             -- Avoid jumping down a line if the end of the file has been reached
            Input_Buffer := To_Unbounded_String(Get_Line(Items_File));
         END IF;
      END LOOP;
   END Create_Armor_List;

   -- A procedure to print all armor names, descriptions, and weights
   PROCEDURE Print_Armor IS
   BEGIN
      FOR i IN Integer RANGE 1..Num_Of_Armor LOOP
         Put(To_String(Armor_Array(i).Name));
         New_Line;
         Put(To_String(Armor_Array(i).Description));
         New_Line;
         Put(Item => "Weight: ");
         Put(Item => Armor_Array(I).Weight, Fore => 2, Aft => 1, Exp => 0);
         New_Line;
         New_Line;
      END LOOP;
   END Print_Armor;
END Item_List;
