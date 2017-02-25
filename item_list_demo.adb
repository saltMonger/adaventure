WITH Ada.Text_IO;      USE Ada.Text_IO;
WITH Item_List;

PROCEDURE Item_List_Demo IS

   Items_File : File_Type;

BEGIN
   -- Open items.txt
   Open(File => Items_File,
        Mode => In_File,
        Name => "items.txt");

   -- Print all consumable information
   Put("CONSUMABLES");
   New_Line;
   Item_List.Create_Consumables_List(Items_File);
   Item_List.Print_Consumables;

   -- Print all weapon information
   Put("WEAPONS");
   New_Line;
   Item_List.Create_Weapons_List(Items_File);
   Item_List.Print_Weapons;

   -- Print all armor information
   Put("ARMOR");
   New_Line;
   Item_List.Create_Armor_List(Items_File);
   Item_List.Print_Armor;

END Item_List_Demo;
