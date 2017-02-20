PACKAGE ENEMY IS

   -- Give the enemey a name
   PROCEDURE Set_Name(N : String);

   -- Set the enemy's physical attributes
   PROCEDURE Set_Stats(Set_HP : Integer; Set_Strength : Integer;
                       Set_Defense : Integer; Set_Agility : Integer);

   -- To damage the enemy's health
   PROCEDURE Take_Damage(Damage : Integer);

   -- A value used to damage the player
   FUNCTION Attack RETURN Integer;

   FUNCTION Is_Enemy_Alive RETURN Boolean;

END ENEMY;
