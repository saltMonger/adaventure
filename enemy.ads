WITH Ada.Text_IO;             USE Ada.Text_IO;
WITH Ada.Strings.Unbounded;   USE Ada.Strings.Unbounded;

PACKAGE ENEMY IS

   -- A record to store information about a particular monster
   type Monster is record
      Name : Unbounded_String;
      Level: Positive;
      HP : Integer;
      Strength : Integer;
      Defense : Integer;
      Agility : Integer;
   end record;

   -- Set the enemy's physical attributes
   PROCEDURE Create_Monster(Monster_Stats : IN File_Type; Mon : IN OUT Monster);

   -- Display the enemy's physical attributes
   PROCEDURE Display_Monster_Stats(Mon : IN Monster);

END ENEMY;
