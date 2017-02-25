WITH Ada.Text_IO;               USE Ada.Text_IO;
WITH Ada.Strings.Unbounded;     USE Ada.Strings.Unbounded;

PACKAGE Item_List IS

   -- A tagged record for a basic item
   TYPE Item_Type IS TAGGED RECORD
      Name : Unbounded_String;
      Description : Unbounded_String;
      Weight : Float;
   END RECORD;

   -- To store information for consumables items
   TYPE Consumable IS NEW Item_Type WITH RECORD
      Stat_Value    : Integer;                  -- The amount the item will alter some stat
      -- To store whether or not a particular consumable alters a particular stat (0 for no, 1 for yes)
      Heal_HP       : Integer;
      Attack_Boost  : Integer;
      Defense_Boost : Integer;
      Agility_Boost : Integer;
      Restore_MP    : Integer;
   END RECORD;

   -- To store information for weapon items
   TYPE Weapon IS NEW Item_Type WITH RECORD
      -- These variables store the amount of attack and speed a weapon provides the player
      Attack : Integer;
      Speed  : Integer;
   END RECORD;

   -- To store information for armor items
   TYPE Armor IS NEW Item_Type WITH RECORD
      -- These variables store the amount of protection and speed a weapon provides the player
      Armor : Integer;
      Speed : Integer;
   END RECORD;

   -- A procedure to load an array with consumable information taken from a file
   PROCEDURE Create_Consumables_List(Items_File : IN OUT File_Type);

   -- A procedure to print all of the game's available consumable's names, descriptions, and weights
   PROCEDURE Print_Consumables;

   -- A procedure to load an array with weapon information taken from a file
   PROCEDURE Create_Weapons_List(Items_File : IN OUT File_Type);

   -- A procedure to print all of the game's available weapon's names, descriptions, and weights
   PROCEDURE Print_Weapons;

   -- A procedure to load an array with armor information taken from a file
   PROCEDURE Create_Armor_List(Items_File : IN OUT File_Type);

   -- A procedure to print all of the game's available armor's names, descriptions, and weights
   PROCEDURE Print_Armor;

END Item_List;
