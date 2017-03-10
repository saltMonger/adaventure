WITH Ada.Integer_Text_IO;  USE Ada.Integer_Text_IO;
With Ada.Text_IO;

PACKAGE BODY ACTOR IS

   PROCEDURE Create_Actor(Actor_Stats : IN File_Type; Act : IN OUT Actor; Option : in Actor_Type) IS
   BEGIN
         Act.Name := To_Unbounded_String(Get_Line(Actor_Stats));
         Get(File => Actor_Stats, Item => Act.Level);
         Get(File => Actor_Stats, Item => Act.HP);
         Get(File => Actor_Stats, Item => Act.Strength);
         Get(File => Actor_Stats, Item => Act.Constitution);
         Get(File => Actor_Stats, Item => Act.Dexterity);
         Get(File => Actor_Stats, Item => Act.Intelligence);
         Get(File => Actor_Stats, Item => Act.AC);
         Act.ACMOD := 0;  --ACMOD is zero unless under status condition
         Get(File => Actor_Stats, Item => Act.MP);
         Get(File => Actor_Stats, Item => Act.DamageDie);
         Get(File => Actor_Stats, Item => Act.DamageDice);
      IF(Option = Monster) THEN
         Get(File => Actor_Stats, Item => Act.Experience_Value);
         --some case statement to point to a loot table
      ELSIF(Option = Player) THEN
         Ada.Text_IO.Put_Line("Creating Player Actor");
         Get(File => Actor_Stats, Item => Act.Experience);
         Ada.Text_IO.Put_Line("EXP");
         Get(File => Actor_Stats, Item => Act.Weapon);
         Ada.Text_IO.Put_Line("WEAPON");
         Get(File => Actor_Stats, Item => Act.Armor);
         Ada.Text_IO.Put_Line("ARMOR");
         --need an inventory loader for the player
      END IF;
   END Create_Actor;

   PROCEDURE Display_Actor_Stats(Act : IN Actor; Option : IN Actor_Type) IS
   BEGIN
      Put("Name: ");
      Put(To_String(Act.Name));
      New_Line;
      Put("Level: ");
      Put(Item => Act.Level, Width => 5);
      New_Line;
      Put("HP: ");
      Put(Item => Act.HP, Width => 8);
      New_Line;
      Put("STR: ");
      Put(Item => Act.Strength, Width => 2);
      New_Line;
      Put("CON: ");
      Put(Item => Act.Constitution, Width => 3);
      New_Line;
      Put("DEX: ");
      Put(Item => Act.Dexterity, Width => 3);
      New_Line;
      Put("INT: ");
      Put(Item => Act.Intelligence, Width => 3);
      New_Line;
      Put("AC: ");
      Put(Item => Act.AC, Width => 3);
      New_Line;
      Put("Damage: ");
      Put(Item => Act.DamageDice, Width => 1);
      Put("d");
      Put(Item => Act.DamageDie, Width => 1);
      New_Line;

      IF(Option = Monster) THEN
      Put("Experience Value: ");
      Put(Item => Act.Experience_Value, Width => 3);
         New_Line;
      ELSIF(Option = Player) THEN
         Put("Total Experience: ");
         Put(Item => Act.Experience, Width => 5);
         New_Line;

         Put("Max Weight: ");
         Put(Item => Act.Weight, Width => 3);
         New_Line;
      END IF;

   END Display_Actor_Stats;
END Actor;



