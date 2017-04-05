WITH Ada.Text_IO;         USE Ada.Text_IO;
WITH Ada.Float_Text_IO;   USE Ada.Float_Text_IO;
WITH Backpack;            USE Backpack;
WITH Item_List;           USE Item_List;
WITH Actor;               USE Actor;

PACKAGE Salesman IS

   -- List of things the salesman might say and what can cause him to say them
   PROCEDURE SalesmanSays(Player : Actor.Actor);

   PROCEDURE ForSale;
END Salesman;
