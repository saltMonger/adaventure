WITH Ada.Text_IO;            USE Ada.Text_IO;
WITH Ada.Integer_Text_IO;    USE Ada.Integer_Text_IO;
WITH Ada.Float_Text_IO;      USE Ada.Float_Text_IO;
WITH Ada.Strings.Unbounded;  USE Ada.Strings.Unbounded;
WITH Item_List;              USE Item_List;
WITH Backpack;               USE Backpack;

PROCEDURE BackPack_Demo IS
   Backpack : Zipper;           -- The "front" of the linked list
   Bottom   : Zipper;           -- The "back" of the linked list
   Choice   : Integer;          -- A number choice for the menu option and for indexing the array of items
   Input    : Unbounded_String; -- An input string for getting the name of an item to delete from the backpack list
BEGIN
   Fill_Items_Array;            -- Fill the items array

   LOOP
      -- Testing menu
      Put("1. Store item in backpack");
      New_Line;
      Put("2. Throw away item");
      New_Line;
      Put("3. Display backpack");
      New_Line;
      Put("4. Equip weapon");
      New_Line;
      Put("5. Equip armor");
      New_Line;
      -- Enter a menu choice number
      Put("Enter choice: ");
      Get(Choice);
      New_Line;

      -- Perform the appropriate menu operation
      CASE Choice IS
         -- If add, locate the item in the array list and store it in the backpack
         WHEN 1 =>
            Put("Enter the index number of the list where the item is located: ");
            Get(Choice);
            Found_Item(Get_Item(Choice), Backpack, Bottom);
            Put(To_String(Get_Item(Choice).Name));
         -- If delete, enter the name of the item to delete, and then delete it from the backpack
         WHEN 2 =>
            Put("Enter the name of the item you wish to delete: ");
            Skip_Line;
            Input := To_Unbounded_String(Get_Line);
            Throw_Away_Item(Input, Backpack, Bottom);
            Put(To_String(Input));
         -- Display the current contents of the backpack
         WHEN 3 =>
            Check_Backpack(Backpack);
         WHEN 4 =>
            Put("Enter the weapon you'd like to equip: ");
            Skip_Line;
            Input := To_Unbounded_String(Get_Line);
            Put(To_String(Equip_Weapon(Input, To_unbounded_String(""), Backpack).Name));
         WHEN 5 =>
            Put("Enter the armor you'd like to equip: ");
            Skip_Line;
            Input := To_Unbounded_String(Get_Line);
            Put(To_String(Equip_Armor(Input, To_Unbounded_String("Cloth Tunic"), Bottom).Name));
         -- When anything else is entered, exit the procedure
         WHEN OTHERS =>
            RETURN;
      END CASE;

      New_Line;
      New_Line;

   END LOOP;
END BackPack_Demo;
