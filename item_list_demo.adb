WITH Ada.Text_IO;      USE Ada.Text_IO;
WITH Item_List;

PROCEDURE Item_List_Demo IS

   Items_File : File_Type;

BEGIN
   -- Open items.txt
   Open(File => Items_File,
        Mode => In_File,
        Name => "items.txt");

   Item_List.Fill_Items_Array(Items_File);

   Item_List.Print_Items_Array;

END Item_List_Demo;
