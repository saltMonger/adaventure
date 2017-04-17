WITH Ada.Text_IO; USE Ada.Text_IO;
WITH Ada.Integer_Text_IO;
WITH Ada.Strings.Unbounded; USE Ada.Strings.Unbounded;
WITH Actor;  USE Actor;
WITH Actorlist; Use Actorlist;
WITH DamageUtils;
WITH Ada.Characters.Handling;
WITH Interfaces.C;                    USE Interfaces.C;
WITH Unbounded_Queue;



PACKAGE BODY EncounterPackage IS

  FUNCTION Sys(Arg : Char_Array) RETURN Integer;
   PRAGMA Import(C, Sys, "system");
   Ret_Val : Integer;

   Package ActorL is new Unbounded_Queue(Integer);

PROCEDURE PlayerDoDamage(Player1   :   Actor.ACTOR; EArray   :   IN OUT Enemy_Array; TargetNumber   :   IN   Integer) IS
      CriticalHit   :   Boolean   :=   False;
      AttackRollValue   :   Integer;
      DamageRollValue : Integer;
   BEGIN
         DamageUtils.RollAttack(Player1.Dexterity, CriticalHit, AttackRollValue);
         IF(AttackRollValue > EArray(TargetNumber).AC) THEN
            DamageRollValue   :=   DamageUtils.RollDamage(Player1.DamageDie, Player1.DamageDice, Player1.Strength);
            EArray(TargetNumber).Current_HP := EArray(TargetNumber).Current_HP - DamageRollValue;
            Ada.Text_IO.Put("Player hit for ");
            Ada.Integer_Text_IO.Put(Item => DamageRollValue, Width => 1);
            Ada.Text_IO.Put(".");
         ELSIF(CriticalHit = True) THEN
            DamageRollValue   :=   2 * DamageUtils.RollDamage(Player1.DamageDie, Player1.DamageDice, Player1.Strength);
            EArray(TargetNumber).Current_HP := EArray(TargetNumber).Current_HP - DamageRollValue;
            Ada.Text_IO.Put("CRITICAL HIT! dealt ");
            Ada.Integer_Text_IO.Put(Item => DamageRollValue, Width => 1);
            Ada.Text_IO.Put(".");
         ELSE
         Ada.Text_IO.Put_Line("Player missed!");
      END IF;
      Ada.Text_IO.New_Line;
   END PlayerDoDamage;


   PROCEDURE PlayerTarget(Player1   :   In Actor.ACTOR; EArray   :   IN OUT Enemy_Array) IS
      C   :   Character   :=   'A';
      KeepChecking   :   Boolean   :=   True;
      TargetNumber   :   Integer   :=   0;
   BEGIN
      Ada.Text_IO.Put_Line("Who shall you attack?");

      FOR I IN Integer RANGE 1..EArray'Length LOOP
         IF (EArray(I).Current_HP < 1) THEN
            Ada.Text_IO.Put("[");
            Ada.Integer_Text_IO.Put(Item => I, Width => 1);
            Ada.Text_IO.Put("]  ");

            Ada.Text_IO.Put(To_String(EArray(I).Name));
            Ada.Text_IO.Put(" is UNCONSCIOUS!");
            Ada.Text_IO.New_Line;
         ELSE
            Ada.Text_IO.Put("[");
            Ada.Integer_Text_IO.Put(Item => I, Width => 1);
            Ada.Text_IO.Put("]  ");

            Ada.Text_IO.Put(To_String(EArray(I).Name));
            Ada.Text_IO.Put(" is at ");
            Ada.Integer_Text_IO.Put(Item => Earray(I).Current_HP, Width => 1);
            Ada.Text_IO.Put(" health.");
            Ada.Text_IO.New_Line;
         END IF;
      END LOOP;


      WHILE(KeepChecking) LOOP
         Ada.Text_IO.Get_Immediate(C);
         CASE(c) IS

         when '1' => TargetNumber   :=   1;
         when '2' => TargetNumber   :=   2;
         when '3' => TargetNumber   :=   3;
         when '4' => TargetNumber   :=   4;
         when '5' => TargetNumber   :=   5;
         when '6' => TargetNumber   :=   6;
         when '7' => TargetNumber   :=   7;
         when '8' => TargetNumber   :=   8;
         when '9' => TargetNumber   :=   9;
         when '0' => TargetNumber   :=   10;
            WHEN OTHERS => KeepChecking   :=   False;
            TargetNumber   :=   0;
         END CASE;
         IF(TargetNumber /= 0 AND TargetNumber <= EArray'Length) THEN
            IF(EArray(TargetNumber).Current_HP < 0) THEN
               Ada.Text_IO.Put_Line("That enemy is unconscious!");
               KeepChecking   :=   True;
            ELSE
               PlayerDoDamage(Player1, EArray, TargetNumber);
               KeepChecking   :=   False;
            END IF;

         ELSE
            KeepChecking   :=   True;
            Ada.Text_IO.Put_Line("That enemy doesn't exist! Try again.");
         END IF;
      END LOOP;
   END PlayerTarget;

   PROCEDURE PlayerInteraction(Player1   :   in Actor.ACTOR; EArray  :   in out Enemy_Array) IS
      C   :   Character   :=   'A';
      KeepChecking   :   Boolean   :=   True;
   BEGIN
      Ada.Integer_Text_IO.Put(Item => EArray'Length, Width => 1);
      Ada.Text_IO.Put_Line(" Enemies stand before you.  What do you do?");
      Ada.Text_IO.Put_Line("[F]ight, [I]tem, [C]heck, [R]un");

      WHILE(KeepChecking) LOOP
         Ada.Text_IO.Get_Immediate(C);
         c   :=   Ada.characters.Handling.To_Upper(c);
         CASE(C) IS
            WHEN 'F' =>
                  PlayerTarget(Player1, EArray);
                  KeepChecking := False;
            WHEN 'I' =>
                  Ada.Text_IO.Put_Line("Not implemented yet!");
               KeepChecking := True;
            WHEN 'C' =>
                  Ada.Text_IO.Put_Line("Not implemented yet!");
               KeepChecking := True;
            WHEN 'R' =>
                  Ada.Text_IO.Put_Line("Not implemented yet!");
               KeepChecking := True;
            WHEN OTHERS =>
                  Ada.Text_IO.Put_Line("I didn't understand that. Try again.");
               KeepChecking := True;
         END CASE;
      END LOOP;
   END PlayerInteraction;

   FUNCTION CheckEnemyDeath(EArray   :   IN Enemy_Array) RETURN Boolean IS
      Count   :   Integer   :=   0;
   BEGIN
      FOR I IN Integer RANGE 1..EArray'Length LOOP
         IF(EArray(I).Current_HP <= 0) THEN
            Count   :=   Count + 1;
         END IF;
      END LOOP;

      IF (Count = EArray'Length) THEN
         RETURN True;
      ELSE
         RETURN False;
      END IF;
   END CheckEnemyDeath;

   PROCEDURE Encounter(Player1 : in out Actor.ACTOR; EArray : in out Enemy_Array) IS
      State   :   Fight_State   :=   Ongoing;
      TextGC   :   Character;
      CriticalHit   :   Boolean;
      AttackRollValue   :   Integer;   --Determines if enemy hits
      DamageRollValue   :   Integer;
      Act_List   :   Actorlist.Actor_List;
      Current   :   Node_Ptr   :=   NULL;
      CurrentI   :   Integer;
      C   :   Character;   --Takes the throw-away character for slowing the encounter down
      Queue_List   :   ActorL.Queue_Type;
   BEGIN
      -------
      --TODO: Support add in order from initiative roll.
      -------

      --populate
      FOR I IN Integer RANGE 1..EArray'Length LOOP
         Actorlist.Add(Act_List, EArray(I));
         ActorL.Enqueue(Queue_List, I);
      END LOOP;

      --add actor
      Actorlist.Add(Act_List, Player1);
      ActorL.Enqueue(Queue_List, -1);

      Ada.Integer_Text_IO.Put(Item => EArray'Length, Width => 1);
      Ada.Text_IO.Put(" enemies stand before you!");
      Ada.Text_IO.Put("Press any key to continue.");
      Ada.Text_IO.Get_Immediate(C);


      WHILE(State = Ongoing) LOOP
         --Check Liveliness of the Battle
         --TODO: REWRITE SO THAT IT JUST CHECKS THE ARRAY
         IF(CheckEnemyDeath(EArray)) THEN
            State   :=   EnemyDeath;
         ELSIF(Player1.Current_HP <= 0) THEN
            State   :=   PlayerDeath;
         ELSE
            State   :=   Ongoing;      --unnecessary
         END IF;
         --End Battle Check
         ActorL.Dequeue(Queue_List, CurrentI);
         Ret_Val := Sys(To_C("cls"));

         --EnemyRound
         IF(CurrentI /= -1) THEN
            DamageUtils.RollAttack(EArray(CurrentI).Dexterity, CriticalHit, AttackRollValue);
            IF(EArray(CurrentI).Current_HP > 0) THEN
               IF(AttackRollValue > Player1.AC) THEN
                  DamageRollValue   := DamageUtils.RollDamage(EArray(CurrentI).DamageDie, EArray(CurrentI).DamageDice, EArray(CurrentI).Strength);
                  Ada.Text_IO.Put("Enemy hit for ");
                  Ada.Integer_Text_IO.Put(Item => DamageRollValue, Width => 1);
                  Player1.Current_HP := Player1.Current_HP - DamageRollValue;
               ELSIF(CriticalHit) THEN
                  DamageRollValue   :=   2 * DamageUtils.RollDamage(EArray(CurrentI).DamageDie, EArray(CurrentI).DamageDice, EArray(CurrentI).Strength);
                  Ada.Text_IO.Put("CRITICAL HIT! dealt ");
                  Ada.Integer_Text_IO.Put(Item => DamageRollValue, Width => 1);
                  Player1.Current_HP := Player1.Current_HP - DamageRollValue;
               ELSE
                  Ada.Text_IO.Put_Line("Enemy missed!");
               END IF;
            ELSE
               Ada.Text_IO.Put("[");
               Ada.Integer_Text_IO.Put(Item => CurrentI, Width => 1);
               Ada.Text_IO.Put("]  ");
               Ada.Text_IO.Put(To_String(EArray(CurrentI).Name));
               Ada.Text_IO.Put(" is unconscious.");
            END IF;

         ELSIF(CurrentI = -1) THEN
               PlayerInteraction(Player1, EArray);
            END IF;

         ActorL.Enqueue(Queue_List, CurrentI);


            Ada.Text_IO.New_Line;
            Ada.Text_IO.Put(Item => To_String(Player1.Name));
            Ada.Text_IO.Put(" is at ");
            Ada.Integer_Text_IO.Put(Item => Player1.Current_HP, Width => 1);
            Ada.Text_IO.Put_Line("HP");

         Ada.Text_IO.New_Line;
         Ada.Text_IO.Put("Press any key to continue.");
         Ada.Text_IO.Get_Immediate(C);


      END LOOP;

      IF(State = PlayerDeath) THEN
         --display gameover here.  if we're doing a really hardcore rougelike, delete the player save
         Ada.Text_IO.Put_Line("You're a corpse!");
         Player1.Current_HP := 1;
         NULL;
      ELSIF(State = EnemyDeath) THEN
         --award XP to player character
         --determine item rewards as well
         Ada.Text_IO.Put_Line("You're winner!");
         NULL;
      END IF;


   END Encounter;




   PROCEDURE EncounterWrapper(Player1   :   IN OUT Actor.ACTOR; NumEnemies : in Integer) IS
      EArray   :   Enemy_Array(1..NumEnemies);
      Mon1   :   Actor.ACTOR;
      MFile   :   Ada.Text_IO.File_Type;
   BEGIN
      FOR I IN Integer RANGE 1..EArray'Length LOOP
            Open(File => MFile, Mode => In_File, Name => "newmonsters.txt");
            Actor.Create_Actor(MFile, Mon1, Monster);
            Display_Actor_Stats(Mon1, Monster);
         Close(MFile);
         EArray(I) :=   Mon1;
      END LOOP;
      Encounter(Player1, EArray);
   END EncounterWrapper;

   PROCEDURE RandomEncounter(Player1   :   IN OUT Actor.ACTOR) IS
      NumEnemies : Integer;
   BEGIN
      --Initialize all of the  rollers for the DamageUtility (do this first)
      DamageUtils.InitDamageUtils;
      NumEnemies   :=   DamageUtils.Random_D10.Random(DamageUtils.Die10);
      EncounterWrapper(Player1, NumEnemies);
   END RandomEncounter;

end EncounterPackage;

