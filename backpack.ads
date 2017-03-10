WITH Item_List;                     USE Item_List;
WITH Ada.Text_IO;                   USE Ada.Text_IO;
WITH Ada.Integer_Text_IO;           USE Ada.Integer_Text_IO;
WITH Ada.Float_Text_IO;             USE Ada.Float_Text_IO;
WITH Ada.Strings.Unbounded;         USE Ada.Strings.Unbounded;
WITH Ada.Characters.Handling;       USE Ada.Characters.Handling;
WITH Ada.Unchecked_Deallocation;
WITH Actor;                         USE Actor;

PACKAGE Backpack IS

   -- A record and access type for storing and accessing items in the backpack
   TYPE Pouch;
   TYPE Zipper IS ACCESS Pouch;
   TYPE Pouch IS RECORD
      Item : Item_Type;
      Num_Of_Item : Integer;
      Next : Zipper;
      Prev : Zipper;
   END RECORD;

   PROCEDURE Free IS NEW Ada.Unchecked_Deallocation(Object => Pouch, Name => Zipper);

   -- Counters to keep track of the backpack's current weight vs the allowable weight
   Allowable_Weight : CONSTANT Float := 100.0;
   Current_Weight   : Float := 0.0;

   PROCEDURE Initialize_Backpack(Backpack : IN OUT Zipper; Bottom : IN OUT Zipper);

   -- Places an item found by the player in the backpack
   PROCEDURE Found_Item(Item_Record : Item_Type; Backpack : IN OUT Zipper; Bottom : IN OUT Zipper);

   -- Uses an item in the backpack. If the item specified is not in the backpack or is non-existent, the procedure will display a message
   -- letting the user know there is no such item in inventory.
   PROCEDURE Use_Item(Name_Of_Item : Unbounded_String; Backpack : IN OUT Zipper; Bottom : IN OUT Zipper; Player_Stats : IN OUT Actor.Actor);

   -- Throws away an item in the backpack
   PROCEDURE Throw_Away_Item(Name_Of_Item : Unbounded_String; Backpack : IN OUT Zipper; Bottom : IN OUT Zipper);

   -- Prints the contents of the backpack
   PROCEDURE Check_Backpack(Backpack : Zipper);

   -- Assists in equipping a weapon. Returns a weapon to the player to equip
   -- and sets an equip boolean associated with the item's record
   FUNCTION Equip_Weapon(Name_Of_Desired_Weapon : Unbounded_String; Name_Of_Current_Weapon : Unbounded_String; Backpack : Zipper) RETURN Item_Type;

   -- Assists in equipping a piece of armor. Returns an armor set to the player to equip
   -- and sets an equip boolean associated with the item's record
   FUNCTION Equip_Armor(Name_Of_Desired_Armor : Unbounded_String; Name_Of_Current_Armor : Unbounded_String; Bottom : Zipper) RETURN Item_Type;

   -- Checks the total weight to make sure the player hasn't gone over the allowable backpack weight
   -- Returns TRUE if the weight is FINE, returns FALSE if the weight is TOO MUCH
   FUNCTION Check_Weight RETURN Boolean;
END BackPack;