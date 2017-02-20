PACKAGE BODY ENEMY IS

   Name : String(1..10);
   HP : Integer;
   Strength : Integer;
   Defense : Integer;
   Agility : Integer;

   PROCEDURE Set_Name(N : String) IS
   BEGIN
      Name := N;
   END Set_Name;

   PROCEDURE Set_Stats(Set_HP : Integer; Set_Strength : Integer;
                       Set_Defense : Integer; Set_Agility : Integer) IS
   BEGIN
      HP := Set_HP;
      Strength := Set_Strength;
      Defense := Set_Defense;
      Agility := Set_Agility;
   END Set_Stats;

   PROCEDURE Take_Damage(Damage : Integer) IS
   BEGIN
      IF(Damage < HP) THEN
         HP := HP - Damage;
      ELSE
         HP := 0;
      END IF;
   END Take_Damage;

   FUNCTION Attack RETURN Integer IS
   BEGIN
      RETURN Strength;      -- Placeholder
   END Attack;

   FUNCTION Is_Enemy_Alive RETURN Boolean IS
   BEGIN
      IF HP = 0 THEN
         RETURN False;
      ELSE
         RETURN True;
      END IF;
   END Is_Enemy_Alive;

END ENEMY;
