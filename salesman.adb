PACKAGE BODY Salesman IS

   ------------------
   -- SalesmanSays --
   ------------------

   PROCEDURE SalesmanSays (Player : Actor.Actor) IS
   BEGIN
      Put("Traveling Salesman: ");
      IF Current_Weight > Allowable_Weight * 0.8 THEN
         Put("I'm not sure you can fit much more in that dingy little sack of yours...");
         New_Line;
         Put("But hey... who am I to tell you how to live your life?");
      ELSIF Player.Current_HP < Integer(Player.Max_HP * 0.5) THEN
         Put("Even the mightiest of warriors needs a little help sometimes...");
      ELSIF Current_Weight < Allowable_Weight * 0.4 THEN
         Put("Would you like to have a look at my wares? I'm sure you could use something to fill that backpack of yours!");
      --ELSIF Player.Loot > 500 THEN
         --Put("You seem to be a man of exquisite taste! Care to have a look at my wares?");
      END IF;
   END SalesmanSays;

   PROCEDURE Salesman_Menu IS
      Player_Input : Character;
   BEGIN
      Put("Would you like to [B]uy, [S]ell, or [L]eave?");
      Get_Immediate(Player_Input);

      CASE Player_Input IS
         WHEN 'b' => ForSale;
         --WHEN 's' => TradeIn;
         WHEN 'l' => RETURN;
         WHEN OTHERS => NULL;
      END CASE;
   END Salesman_Menu;

   -------------
   -- ForSale --
   -------------

   PROCEDURE ForSale IS
   BEGIN
      Put("Testing");
   END ForSale;

END Salesman;
