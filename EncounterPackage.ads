WITH Ada.Text_IO; USE Ada.Text_IO;
WITH Ada.Integer_Text_IO;
WITH Ada.Strings.Unbounded; USE Ada.Strings.Unbounded;
WITH Actor;  USE Actor;
WITH Actorlist; Use Actorlist;
WITH DamageUtils;
WITH Ada.Characters.Handling;

PACKAGE EncounterPackage IS

   type Enemy_Array is Array(Integer range <>) of Actor.ACTOR(Option => Monster);
   TYPE Fight_State IS (Ongoing, PlayerDeath, EnemyDeath);

   PROCEDURE PlayerDoDamage(Player1   :   Actor.ACTOR; EArray   :   IN OUT Enemy_Array; TargetNumber   :   IN   Integer);
   PROCEDURE PlayerTarget(Player1   :   IN Actor.ACTOR; EArray   :   IN OUT Enemy_Array);
   PROCEDURE PlayerInteraction(Player1   :   IN Actor.ACTOR; EArray  :   IN OUT Enemy_Array);
   FUNCTION CheckEnemyDeath(EArray   :   IN Enemy_Array) RETURN Boolean;
   PROCEDURE EncounterWrapper(Player1   :   IN OUT Actor.ACTOR; NumEnemies : IN Integer);
   PROCEDURE RandomEncounter(Player1   :   IN OUT Actor.ACTOR);
   PROCEDURE Encounter(Player1 : in out Actor.ACTOR; EArray : in out Enemy_Array);

end EncounterPackage;




