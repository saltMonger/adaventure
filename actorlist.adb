WITH Actor;  USE Actor;
WITH Ada.Unchecked_Deallocation;
WITH Ada.Text_IO;
WITH Ada.Strings.Unbounded; USE Ada.Strings.Unbounded;


PACKAGE BODY Actorlist IS

   Procedure Delete is new Ada.Unchecked_Deallocation(Object => Node, Name => node_ptr);

   PROCEDURE Add(Act_List : IN OUT Actor_List; Act_Rec : IN Actor.ACTOR) IS
      Temp_Node   :   node_ptr;
   BEGIN
      IF(Act_List.Head = NULL) THEN
         Act_List.Head := NEW Node'(Act => Act_Rec, Next => NULL);
      ELSE
         Temp_Node := Act_List.Head;
         WHILE(Temp_Node.Next /= NULL) LOOP
            Temp_Node := Temp_Node.Next;
         END LOOP;
         Temp_Node.Next := NEW Node'(Act => Act_Rec, Next => NULL);
      END IF;
   END Add;

   PROCEDURE Clear(Act_List : IN OUT Actor_List) IS
      Temp_Node   :   Node_Ptr;
      Player_Pointer   :   Node_Ptr;
   BEGIN
      Temp_Node   :=   Act_List.Head;
      WHILE(Temp_Node /= NULL) LOOP
         IF(Temp_Node.All.Act.Option /= Player) THEN
            Delete(Temp_Node);
            Temp_Node   :=   Temp_Node.Next;
         ELSE
            Player_Pointer   :=   Temp_Node;
            Temp_Node   :=   Temp_Node.Next;
         END IF;
      END LOOP;
   END Clear;

   FUNCTION  CheckPlayerDeath(Act_List : IN Actor_List) RETURN Boolean IS
      Temp_Node   :   node_ptr   :=   Act_List.Head;
   BEGIN
      WHILE(Temp_Node /= NULL) LOOP
         IF(Temp_Node.All.Act.Option = Player) THEN
            IF(Temp_Node.All.Act.Current_HP > 0) THEN
               RETURN False;
            ELSE
               RETURN True;
            END IF;
         END IF;
         Temp_Node := Temp_Node.Next;
      END LOOP;
      RETURN False;
   END CheckPlayerDeath;


   FUNCTION  CheckMonsterDeath(Act_List : IN Actor_List) RETURN Integer IS
      Temp_Node   :   Node_Ptr   :=   Act_List.Head;
      Counter   :   Integer   :=   0;
   BEGIN
      WHILE(Temp_Node /= NULL) LOOP
         IF(Temp_Node.All.Act.Option = Monster) THEN
            IF(Temp_Node.All.Act.Current_HP <= 0) THEN
               Counter   :=   Counter + 1;
            END IF;
         END IF;
         Temp_Node := Temp_Node.Next;
      END LOOP;
      RETURN Counter;
   END CheckMonsterDeath;

   PROCEDURE DebugPrintList(Act_List : IN Actor_List) IS
      Temp_Pointer   :   Node_Ptr   :=   Act_List.Head;
   BEGIN
      WHILE(Temp_Pointer.Next /= NULL) LOOP
         Ada.Text_IO.Put_Line(To_String(Temp_Pointer.All.Act.Name));
         Temp_Pointer   :=   Temp_Pointer.Next;
      END LOOP;
      Ada.Text_IO.Put_Line(To_String(Temp_Pointer.All.Act.Name));
   END DebugPrintList;


end actorlist;
