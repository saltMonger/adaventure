WITH EncounterPackage;
WITH Ada.Text_IO; USE Ada.Text_IO;
WITH Ada.Integer_Text_IO;
WITH Ada.Strings.Unbounded; USE Ada.Strings.Unbounded;
WITH Actor;  USE Actor;
WITH Actorlist; Use Actorlist;
WITH DamageUtils;
with Ada.characters.Handling;

PROCEDURE Encounter2Demo IS
   Player1   :   Actor.ACTOR(Option   =>   Player);
   Save   :   Ada.Text_IO.File_Type;
BEGIN
   Open(File => Save, Mode => In_File, Name =>  "player.txt");
   Actor.Create_Actor(Save, Player1, Player);
   Display_Actor_Stats(Player1, Player);
   Close(Save);

   EncounterPackage.RandomEncounter(Player1);

END Encounter2Demo;

