WITH Ada.Text_IO;             USE Ada.Text_IO;
WITH Ada.Strings.Unbounded;   USE Ada.Strings.Unbounded;
WITH Backpack;                USE Backpack;
WITH Item_List;               USE Item_List;

PACKAGE ACTOR IS

   TYPE Actor_Type IS (Player, Monster, NPC);
-- Temporary debug types -  these will be filled in when we work on items/loot tables

   TYPE Loot_Table IS RECORD
      Name   :   Unbounded_String;
      Value   :   Integer;
   END RECORD;

   Type Loot_PTR is access Loot_Table;

   -- A record to store information about a particular monster
   TYPE Actor (Option : Actor_Type   :=   Monster) IS record
      Name   :   Unbounded_String   := To_Unbounded_String("");
      Level  :   Positive   := 1;
      Max_HP   :   Integer   := 0;
      Current_HP : Integer := 0;
      AC   :   Integer   := 0;
      ACMOD   :   Integer   := 0;
      Strength :   Integer   := 0;
      Constitution : Integer   := 0;
      Dexterity   :   Integer   := 0;
      Intelligence   :   Integer   := 0;
      MP   :   Integer   := 0;
      DamageDie   :   Integer   :=0;   --Only ever 2,4,6,8,10,12,20
      DamageDice  :   Integer   :=1;   --Will be 1 or greater (Consider going to Natural)
      CASE Option IS
         WHEN Monster =>
            Experience_Value   :   Positive   := 1;
            Loot_Table_Pointer   : Loot_PTR   := null;
         WHEN Player =>
            Experience   :   Natural   :=   0;
            Backpack :   Zipper  :=   NULL;
            Bottom   :   Zipper  := NULL;
            Weapon   :   Item_Type;
            Armor    :   Item_Type;
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