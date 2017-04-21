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

   --PlayerDoDamage
   --Purpose: Uses the DamageUtils package, and Player stats to calculate if the player hits the enemy, and the damage that will be done
   PROCEDURE PlayerDoDamage(Player1   :   Actor.ACTOR; EArray   :   IN OUT Enemy_Array; TargetNumber   :   IN   Integer);

   --PlayerTarget
   --Purpose: Subprogram that waits for a player to target an enemy using 0-9 keys
   PROCEDURE PlayerTarget(Player1   :   IN Actor.ACTOR; EArray   :   IN OUT Enemy_Array);

   --PlayerInteraction
   --Purpose: Subprogram that provides the Fight, Check, Item, Run menu and input handling
   PROCEDURE PlayerInteraction(Player1   :   IN Actor.ACTOR; EArray  :   IN OUT Enemy_Array);

   --CheckEnemyDeath
   --Purpose: Checks the enemy array to determine if the enemy party has wiped (been defeated)
   FUNCTION CheckEnemyDeath(EArray   :   IN Enemy_Array) RETURN Boolean;

   --EncounterWrapper
   --Purpose: Generates an enemy array of length NumEnemies using an enemies file
   PROCEDURE EncounterWrapper(Player1   :   IN OUT Actor.ACTOR; NumEnemies : IN Integer);

   --RandomEncounter
   --Purpose: Randomly determines the amount of enemies to fight in the encounter
   PROCEDURE RandomEncounter(Player1   :   IN OUT Actor.ACTOR);

   --Encounter
   --Purpose: Handles all enemy turns and damage calculations, as well as player turn and battle states (Ongoing, PlayerDeath, EnemyDeath)
   --Plans: Eventually generate loot drops/experience rewards and award them to the player in case of EnemyDeath (or destroy save file on PlayerDeath)
   PROCEDURE Encounter(Player1 : in out Actor.ACTOR; EArray : in out Enemy_Array);

end EncounterPackage;




