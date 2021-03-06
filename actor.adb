WITH Ada.Integer_Text_IO;  USE Ada.Integer_Text_IO;
With Ada.Text_IO;

PACKAGE BODY ACTOR IS

   PROCEDURE Create_Actor(Actor_Stats : IN File_Type; Act : IN OUT Actor; Option : in Actor_Type) IS
   BEGIN
         Act.Name := To_Unbounded_String(Get_Line(Actor_Stats));
         Get(File => Actor_Stats, Item => Act.Level);
         Get(File => Actor_Stats, Item => Act.Max_HP);
         Act.Current_HP := Act.Max_HP;
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
         Get(File => Actor_Stats, Item => Act.Experience);
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
      Put(Item => Act.Current_HP, Width => 2);
      Put(Item => "/");
      Put(Item => Act.Max_HP, Width => 1);
      New_Line;
      Put("STR: ");
      IF (Option = Player) THEN
         Put(Item => Act.Strength - Act.Weapon.Attack - Act.Armor.Attack, Width => 2);
         Put(Item => "[");
         Put(Item => Act.Strength, Width => 2);
         Put(Item => "]");
      ELSE
         Put(Item => Act.Strength, Width => 2);
      END IF;
      New_Line;
      Put("CON: ");
      IF (Option = Player) THEN
         Put(Item => Act.Constitution - Act.Weapon.Defense - Act.Armor.Defense, Width => 2);
         Put(Item => "[");
         Put(Item => Act.Constitution, Width => 2);
         Put(Item => "]");
      ELSE
         Put(Item => Act.Constitution, Width => 2);
      END IF;
      New_Line;
      Put("DEX: ");
      IF (Option = Player) THEN
         Put(Item => Act.Dexterity - Act.Weapon.Speed - Act.Armor.Speed, Width => 2);
         Put(Item => "[");
         Put(Item => Act.Dexterity, Width => 2);
         Put(Item => "]");
      ELSE
         Put(Item => Act.Dexterity, Width => 2);
      END IF;
      New_Line;
      Put("INT: ");
      Put(Item => Act.Intelligence, Width => 2);
      New_Line;
      Put("AC: ");
      Put(Item => Act.AC, Width => 2);
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

         Put(Item => "Weapon: ");
         Put(Item => To_String(Act.Weapon.Name));
         New_Line;
         Put(Item => "Armor: ");
         Put(Item => To_String(Act.Armor.Name));
         New_Line;
      END IF;

   END Display_Actor_Stats;
END Actor;



