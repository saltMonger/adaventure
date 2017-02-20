WITH Ada.Text_IO;   USE Ada.Text_IO;

PROCEDURE Test IS

   User_Input : Character;

   TYPE Item IS RECORD
      Name : String(1..10);
      Description : String(1..30);
      Weight : Float;
   END RECORD;

   TYPE Room IS RECORD
      Name : String(1..10);
      Num_Of_Enemies : Integer;
      Num_Of_Items : Integer;
      Num_Of_Doors : Integer;
   END RECORD;

BEGIN

WHILE User_Input /= 'q' LOOP
   Put("Press a key: ");
   Get_Immediate(Item => User_Input);
   New_Line;

   CASE User_Input IS
      WHEN 'i' => Put("You have accessed your backpack/inventory");
      WHEN 'b' => Put("You have accessed your backpack/inventory");
      WHEN 'm' => Put("You have accessed the menu");
      WHEN 'e' => Put("You have interacted with an item");
      WHEN 'w' => Put("You have moved up");
      WHEN 'a' => Put("You have moved left");
      WHEN 's' => Put("You have moved down");
      WHEN 'd' => Put("You have moved right");
      WHEN 'q' => Put("Now exiting the application");
      WHEN OTHERS => Put("That key doesn't do anything");
      END CASE;
      New_Line;
END LOOP;
END Test;
