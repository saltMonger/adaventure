--ATTN:
--THIS PACKAGE IS DEPRECATED
---------------------------------
WITH Actor; USE Actor;
PACKAGE Actorlist IS

   TYPE Node;
   type node_ptr is access node;
   TYPE Node IS RECORD
      Act   :   Actor.ACTOR;
      Next   :   Node_Ptr;
   END RECORD;

   TYPE Actor_List IS RECORD
      Head   :   node_ptr   :=   NULL;
   END RECORD;



   PROCEDURE Add(Act_List : IN OUT Actor_List; Act_Rec : IN Actor.ACTOR);
   PROCEDURE Clear(Act_List : IN OUT Actor_List);
   FUNCTION  CheckPlayerDeath(Act_List : IN Actor_List) RETURN Boolean;
   FUNCTION  CheckMonsterDeath(Act_List : IN Actor_List) RETURN Integer;
   Procedure DebugPrintList(Act_List : In Actor_List);
end actorlist;




