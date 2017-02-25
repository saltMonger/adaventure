WITH Ada.Text_IO;             USE Ada.Text_IO;
WITH Enemy;

PROCEDURE Enemy_Demo IS

   Monster_File : File_Type;
   Slime : Enemy.Monster;

BEGIN

   -- Open the monsters.txt file
   Open(File => Monster_File,
        Mode => In_File,
        Name => "monsters.txt");

   -- Create a simple slime for testing
   Enemy.Create_Monster(Monster_Stats => Monster_File, Mon => Slime);

   -- Display the slime's stats
   Enemy.Display_Monster_Stats(Mon => Slime);

END Enemy_Demo;