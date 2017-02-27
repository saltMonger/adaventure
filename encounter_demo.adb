WITH Ada.Text_IO; Use Ada.Text_IO;
WITH Actor;  Use Actor;


PROCEDURE Encounter_Demo IS
   Mon1   :   Actor.Actor(Option => Monster);
   File   :   File_Type;
BEGIN
   Open(File => File, Mode => In_File, Name => "newmonsters.txt");
   Actor.Create_Actor(File, Mon1, Monster);
   Display_Actor_Stats(Mon1, Monster);
   Close(File);
END Encounter_Demo;

