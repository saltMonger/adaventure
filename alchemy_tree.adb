WITH Ada.Characters.Handling;      USE Ada.Characters.Handling;
WITH Ada.Text_IO;                  USE Ada.Text_IO;
WITH Ada.Strings;                  USE Ada.Strings;

PACKAGE BODY Alchemy_Tree IS
   Num_Of_Nodes : Integer := 3;

   PROCEDURE Insert_Recipe(Ingredient1 : Unbounded_String; Ingredient2 : Unbounded_String; Creation : Item_Type; Root : IN OUT Node_Ptr) IS
   BEGIN
      IF Root = NULL THEN
         Root := NEW Node'(Ingredient1 => Ingredient1, Ingredient2 => Ingredient2, Creation => Creation, Left => NULL, Right => NULL);
      ELSIF Root.Ingredient1 <= Ingredient1 THEN
         IF Root.Right = NULL THEN
            Root.Right := NEW Node'(Ingredient1 => Ingredient1, Ingredient2 => Ingredient2, Creation => Creation, Left => NULL, Right => NULL);
         ELSE
            Insert_Recipe(Ingredient1 => Ingredient1, Ingredient2 => Ingredient2, Creation => Creation, Root => Root.Right);
         END IF;
      ELSIF Root.Ingredient1 > Ingredient1 THEN
         IF Root.Left = NULL THEN
            Root.Left := NEW Node'(Ingredient1 => Ingredient1, Ingredient2 => Ingredient2, Creation => Creation, Left => NULL, Right => NULL);
         ELSE
            Insert_Recipe(Ingredient1 => Ingredient1, Ingredient2 => Ingredient2, Creation => Creation, Root => Root.Left);
         END IF;
      END IF;
   END Insert_Recipe;

   ----------------
   -- Build_Tree --
   ----------------

   PROCEDURE Build_Tree (File_Name : Unbounded_String; Root : IN OUT Node_Ptr) IS
      Alchemy_File : File_Type;
      Ingredient1 : Unbounded_String;
      Ingredient2 : Unbounded_String;
      Creation    : Item_Type;
      Item_Kind   : Unbounded_String;
   BEGIN
      Open(File => Alchemy_File, Mode => In_File,Name => To_String(File_Name));

      FOR I IN Integer RANGE 1..Num_Of_Nodes LOOP
         Ingredient1 := To_Unbounded_String(Get_Line(Alchemy_File));
         Ingredient2 := To_Unbounded_String(Get_Line(Alchemy_File));
         Item_Kind := To_Unbounded_String(Get_Line(Alchemy_File));
         IF Item_Kind = "CONSUMABLE" THEN
            Creation := (Kind_Of_Item => Consumable,
                         Name => To_Unbounded_String(Get_Line(Alchemy_File)),
                         Description => To_Unbounded_String(Get_Line(Alchemy_File)),
                         Weight => Float'Value(Get_Line(Alchemy_File)),
                         Loot_Value => Float'Value(Get_Line(Alchemy_File)),
                         Heal_HP => Integer'Value(Get_Line(Alchemy_File)),
                         Attack_Boost => Integer'Value(Get_Line(Alchemy_File)),
                         Defense_Boost => Integer'Value(Get_Line(Alchemy_File)),
                         Agility_Boost => Integer'Value(Get_Line(Alchemy_File)),
                         Restore_MP => Integer'Value(Get_Line(Alchemy_File)));
         ELSIF Item_Kind = "WEAPON" THEN
            Creation := (Kind_Of_Item => Weapon,
                         Name => To_Unbounded_String(Get_Line(Alchemy_File)),
                         Description =>To_Unbounded_String(Get_Line(Alchemy_File)),
                         Weight => Float'Value(Get_Line(Alchemy_File)),
                         Loot_Value => Float'Value(Get_Line(Alchemy_File)),
                         Attack => Integer'Value(Get_Line(Alchemy_File)),
                         Defense => Integer'Value(Get_Line(Alchemy_File)),
                         Speed => Integer'Value(Get_Line(Alchemy_File)),
                         Is_Equipped => False);
         ELSIF Item_Kind = "ARMOR" THEN
            Creation := (Kind_Of_Item => Armor,
                         Name => To_Unbounded_String(Get_Line(Alchemy_File)),
                         Description =>To_Unbounded_String(Get_Line(Alchemy_File)),
                         Weight => Float'Value(Get_Line(Alchemy_File)),
                         Loot_Value => Float'Value(Get_Line(Alchemy_File)),
                         Attack => Integer'Value(Get_Line(Alchemy_File)),
                         Defense => Integer'Value(Get_Line(Alchemy_File)),
                         Speed => Integer'Value(Get_Line(Alchemy_File)),
                         Is_Equipped => False);
         END IF;
         Insert_Recipe(Ingredient1 => Ingredient1, Ingredient2 => Ingredient2, Creation => Creation, Root => Root);
      END LOOP;
   end Build_Tree;

   -----------------
   -- Synthesize --
   -----------------

   PROCEDURE Synthesize(Ingredient1 : Unbounded_String; Ingredient2 : Unbounded_String; Creation : IN OUT Item_Type; Root : IN OUT Node_Ptr) IS
   BEGIN
      IF Root = NULL THEN
         RETURN;
      ELSIF To_Lower(To_String(Ingredient1)) >= To_Lower(To_String(Root.Ingredient1)) AND
            To_Lower(To_String(Ingredient2)) /= To_Lower(To_String(Root.Ingredient2)) THEN
         Synthesize(Ingredient1 => Ingredient1, Ingredient2 => Ingredient2, Creation => Creation, Root => Root.Right);
      ELSIF To_Lower(To_String(Ingredient2)) < To_Lower(To_String(Root.Ingredient2)) THEN
         Synthesize(Ingredient1 => Ingredient1, Ingredient2 => Ingredient2, Creation => Creation, Root => Root.Left);
      ELSIF To_Lower(To_String(Root.Ingredient1)) = To_Lower(To_String(Ingredient1)) AND
            To_Lower(To_String(Root.Ingredient2)) = To_Lower(To_String(Ingredient2)) THEN
         Creation := Root.Creation;
      END IF;
   END Synthesize;

   PROCEDURE Print_Tree(Root : Node_Ptr) IS
   BEGIN
      IF Root /= NULL THEN
         Print_Tree(Root.Left);
         Put("Ingredient 1: ");
         Put(To_String(Root.Ingredient1));
         New_Line;
         Put("Ingredient 2: ");
         Put(To_String(Root.Ingredient2));
         New_Line;
         Put("Result: ");
         Put(To_String(Root.Creation.Name));
         New_Line;
         New_Line;
         Print_Tree(Root.Right);
      END IF;
   END Print_Tree;

end Alchemy_Tree;
