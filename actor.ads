WITH Ada.Text_IO;             USE Ada.Text_IO;
WITH Ada.Strings.Unbounded;   USE Ada.Strings.Unbounded;

PACKAGE ACTOR IS

   TYPE Actor_Type IS (Player, Monster, NPC);

-- Temporary debug types -  these will be filled in when we work on items/loot tables
   TYPE Inventory IS RECORD
      Name   :   Unbounded_String;
      Value   :   Integer;
   END RECORD;

   TYPE Loot_Table IS RECORD
      Name   :   Unbounded_String;
      Value   :   Integer;
   END RECORD;

   Type Loot_PTR is access Loot_Table;
   Type Inventory_PTR is access Inventory;


   -- A record to store information about a particular monster
   TYPE Actor (Option : Actor_Type) IS record
      Name   :   Unbounded_String   := To_Unbounded_String("");
      Level  :   Positive   := 1;
      HP   :   Integer   := 0;
      AC   :   Integer   := 0;
      ACMOD   :   Integer   := 0;
      Strength :   Integer   := 0;
      Constitution : Integer   := 0;
      Dexterity   :   Integer   := 0;
      Intelligence   :   Integer   := 0;
      MP   :   Integer   := 0;

      CASE Option IS
         WHEN Monster =>
            Experience_Value   :   Positive   := 1;
            Loot_Table_Pointer   : Loot_PTR   := null;
         WHEN Player =>
            Experience   :   Positive;
            Inventory   : Inventory_PTR;
            Weapon   :   Integer;   -- dummy value
            Armor   :   Integer;   -- dummy value
         WHEN NPC =>
            Coins :   Integer;
      END CASE;
   END RECORD;



--   type Monster is record
--      Name : Unbounded_String;
--      Level: Positive;
--      HP : Integer;
--      Strength : Integer;
--      Defense : Integer;
--      Agility : Integer;
--   end record;

   -- Set the enemy's physical attributes
   --PROCEDURE Create_Monster(Monster_Stats : IN File_Type; Mon : IN OUT Monster);

   -- Display the enemy's physical attributes
   --PROCEDURE Display_Monster_Stats(Mon : IN Monster);

   PROCEDURE Create_Actor(Actor_Stats : IN File_Type; Act : IN OUT Actor; Option : in Actor_Type);

   PROCEDURE Display_Actor_Stats(Act : IN Actor; Option : IN Actor_Type);

END ACTOR;