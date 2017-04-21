--WITH Ada.Numerics.Discrete_Random;

PACKAGE BODY DamageUtils IS

   --Sets random function seeds
   PROCEDURE InitDamageUtils IS
   BEGIN
      Random_D2.Reset(Die2);
      Random_D4.Reset(Die4);
      Random_D6.Reset(Die6);
      Random_D8.Reset(Die8);
      Random_D10.Reset(Die10);
      Random_D12.Reset(Die12);
      Random_D20.Reset(Die20);
   END InitDamageUtils;



   --Returns a damage value calculated as DiceType Roll + Strength
   FUNCTION RollDamage(DmgT : Integer; DmgNum : Integer; STR : Integer) RETURN Integer IS
      Damage   :   Integer   :=   0;
   BEGIN
      CASE(DmgT) IS
         WHEN 2 =>
            FOR I in Integer range 1 .. DmgNum loop
               Damage := Damage + Random_D2.Random(Die2);
            END LOOP;
            Damage := Damage + STR;
            RETURN Damage;
         WHEN 4 =>
            FOR I IN Integer RANGE 1 .. DmgNum LOOP
               Damage := Damage + Random_D4.Random(Die4);
            END LOOP;
            Damage := Damage + STR;
            RETURN Damage;
         WHEN 6 =>
            FOR I IN Integer RANGE 1 .. DmgNum LOOP
               Damage := Damage + Random_D6.Random(Die6);
            END LOOP;
            Damage := Damage + STR;
            RETURN Damage;
         WHEN 8 =>
            FOR I IN Integer RANGE 1 .. DmgNum LOOP
               Damage := Damage + Random_D8.Random(Die8);
            END LOOP;
            Damage := Damage + STR;
            RETURN Damage;
         WHEN  10 =>
            FOR I IN Integer RANGE 1 .. DmgNum LOOP
               Damage := Damage + Random_D10.Random(Die10);
            END LOOP;
            Damage := Damage + STR;
            RETURN Damage;
         WHEN 12 =>
            FOR I IN Integer RANGE 1 .. DmgNum LOOP
               Damage := Damage + Random_D12.Random(Die12);
            END LOOP;
            Damage := Damage + STR;
            RETURN Damage;
         WHEN 20 =>
            FOR I IN Integer RANGE 1 .. DmgNum LOOP
               Damage := Damage + Random_D20.Random(Die20);
            END LOOP;
            Damage := Damage + STR;
            RETURN Damage;
         WHEN OTHERS =>
            RETURN 0;
      END CASE;
   END RollDamage;

   --Uses actor dexterity to determine an attack value, and if it is critical or not
   PROCEDURE RollAttack(DEX : IN Integer; IsCrit : OUT Boolean; RollValue : OUT Integer) IS
      Roll   :   Integer   :=   0;
   BEGIN
      Roll := Random_D20.Random(Die20);
      IF(Roll = 20) THEN
         IsCrit   :=   True;
      END IF;
      RollValue := Roll + DEX;   --TODO: Change the scaling of Dexterity
   END RollAttack;

END DamageUtils;

