WITH Ada.Text_IO;               USE Ada.Text_IO;
WITH Ada.Strings.Unbounded;     USE Ada.Strings.Unbounded;

PACKAGE Item_List IS

   TYPE Sub_Item_Type IS (Consumable, Weapon, Armor);

   -- A variant record for an item. The item can be a consumable, weapon, or armor
   TYPE Item_Type (Kind_Of_Item : Sub_Item_Type := Consumable) IS RECORD
      Name : Unbounded_String;
      Description : Unbounded_String;
      Weight : Float;
      Is_Consumable : Boolean;
      Is_Weapon     : Boolean;
      Is_Armor      : Boolean;
      CASE Kind_Of_Item IS
         WHEN Consumable    => Heal_HP       : Integer;
                               Attack_Boost  : Integer;
                               Defense_Boost : Integer;
                               Agility_Boost : Integer;
                               Restore_MP    : Integer;
         WHEN Weapon..Armor => Attack        : Integer;
                               Defense       : Integer;
                               Speed         : Integer;
      END CASE;
   END RECORD;

   -- Fill a master array with all items from an items file
   PROCEDURE Fill_Items_Array(Items_File : IN OUT File_Type);

   -- Print all the items out using the filled array
   PROCEDURE Print_Items_Array;

END Item_List;
