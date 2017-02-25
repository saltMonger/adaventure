WITH Ada.Integer_Text_IO;     USE Ada.Integer_Text_IO;

PACKAGE BODY ENEMY IS

   -- A procedure to create a monster. This will later be updated to store monster information into an array.
   PROCEDURE Create_Monster(Monster_Stats : in File_Type; mon : in out Monster) IS
   BEGIN
      mon.Name := To_Unbounded_String(Get_Line(Monster_Stats));
      Get(File => Monster_Stats, Item => mon.Level);
      Get(File => Monster_Stats, Item => mon.HP);
      Get(File => Monster_Stats, Item => mon.Strength);
      Get(File => Monster_Stats, Item => mon.Defense);
      Get(File => Monster_Stats, Item => mon.Agility);
   END Create_Monster;

   -- Display a monster's stats. This will later be updated to display all available monster's stats
   PROCEDURE Display_Monster_Stats(Mon : IN Monster) IS
   BEGIN
      Put("Name: ");
      Put(To_String(mon.Name));
      New_Line;
      Put("Level: ");
      Put(Item => mon.Level, Width => 5);
      New_Line;
      Put("HP: ");
      Put(Item => mon.HP, Width => 8);
      New_Line;
      Put("Strength: ");
      Put(Item => mon.Strength, Width => 2);
      New_Line;
      Put("Defense: ");
      Put(Item => mon.Defense, Width => 3);
      New_Line;
      Put("Agility: ");
      Put(Item => mon.Agility, Width => 3);
      New_Line;
   END Display_Monster_Stats;

END ENEMY;
