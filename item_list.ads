WITH Ada.Text_IO;               USE Ada.Text_IO;
WITH Ada.Strings.Unbounded;     USE Ada.Strings.Unbounded;

PACKAGE Item_List IS

   TYPE Sub_Item_Type IS (Consumable, Weapon, Armor);

   -- A variant record for an item. The item can be a consumable, weapon, or armor
   TYPE Item_Type (Kind_Of_Item : Sub_Item_Type := Consumable) IS RECORD
      Name : Unbounded_String;
      Description : Unbounded_String;
      Weight : Float;
      CASE Kind_Of_Item IS
         WHEN Consumable    => Heal_HP       : Integer;
                               Attack_Boost  : Integer;
                               Defense_Boost : Integer;
                               Agility_Boost : Integer;
                               Restore_MP    : Integer;
         WHEN Weapon..Armor => Attack        : Integer;
                               Defense       : Integer;
                               Speed         : Integer;
                               Is_Equipped   : Boolean;
      END CASE;
   END RECORD;

   -- Fill a master array with all items from an items file
   PROCEDURE Fill_Items_Array;

   -- Print all the items out using the filled array
   PROCEDURE Print_Items_Array;

   -- Retrieve an item from the list by passing in an index associated with the item's spot in the list
   -- For the game's purposes, a random integer should be passed in and a "random" item will then be returned
   -- for the player to store in their backpack
   FUNCTION Get_Item(Index : Integer) RETURN Item_Type;

END Item_List;
