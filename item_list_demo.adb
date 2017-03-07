WITH Ada.Text_IO;               USE Ada.Text_IO;
WITH Ada.Integer_Text_IO;       USE Ada.Integer_Text_IO;
WITH Item_List;                 USE Item_List;
WITH Ada.Strings.Unbounded;     USE Ada.Strings.Unbounded;

PROCEDURE Item_List_Demo IS
   Choice : Integer;
BEGIN

   Fill_Items_Array;

   Print_Items_Array;

   LOOP

   Put("Enter a number to access an item from the list: (Enter 0 to exit) ");
   Get(Choice);

   IF Choice = 0 THEN
      RETURN;
   END IF;

   Put(To_String(Get_Item(Choice).Name));
   New_Line;

   END LOOP;

END Item_List_Demo;
