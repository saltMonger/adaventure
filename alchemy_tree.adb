WITH Ada.Characters.Handling;      USE Ada.Characters.Handling;
WITH Ada.Text_IO;                  USE Ada.Text_IO;
WITH Ada.Strings;                  USE Ada.Strings;

PACKAGE BODY Alchemy_Tree IS
   Num_Of_Nodes : Integer := 3;      -- This needs updated to keep track of the number of recipes in the file

   -- Inserts a node, containing a recipe, to the tree
   PROCEDURE Insert_Recipe(Ingredient1 : Unbounded_String; Ingredient2 : Unbounded_String; Creation : Item_Type; Root : IN OUT Node_Ptr) IS
   BEGIN
      -- If the tree is empty, insert the node at the root
      IF Root = NULL THEN
         Root := NEW Node'(Ingredient1 => Ingredient1, Ingredient2 => Ingredient2, Creation => Creation, Left => NULL, Right => NULL);
      -- If the incoming recipe's first ingredient is alphabetically higher than the current node's, insert to the right
      ELSIF Root.Ingredient1 <= Ingredient1 THEN
         -- If the right pointer is empty, insert there
         IF Root.Right = NULL THEN
            Root.Right := NEW Node'(Ingredient1 => Ingredient1, Ingredient2 => Ingredient2, Creation => Creation, Left => NULL, Right => NULL);
         -- If there already exists a right node, move to that node and repeat the algorithm
         ELSE
            Insert_Recipe(Ingredient1 => Ingredient1, Ingredient2 => Ingredient2, Creation => Creation, Root => Root.Right);
         END IF;
      -- If the incoming recipe's first ingredient is alphabetically lower than the current node's, insert to the left
      ELSIF Root.Ingredient1 > Ingredient1 THEN
         -- If the left pointer is empty, insert there
         IF Root.Left = NULL THEN
            Root.Left := NEW Node'(Ingredient1 => Ingredient1, Ingredient2 => Ingredient2, Creation => Creation, Left => NULL, Right => NULL);
         -- If there already exists a left node, move to that node and repeat the algorithm
         ELSE
            Insert_Recipe(Ingredient1 => Ingredient1, Ingredient2 => Ingredient2, Creation => Creation, Root => Root.Left);
         END IF;
      END IF;
   END Insert_Recipe;

   ----------------
   -- Build_Tree --
   ----------------

   -- Read through a file and inserts all the recipes into a tree
   PROCEDURE Build_Tree (File_Name : Unbounded_String; Root : IN OUT Node_Ptr) IS
      Alchemy_File : File_Type;            -- A file variable
      Ingredient1 : Unbounded_String;      -- To store an ingredient
      Ingredient2 : Unbounded_String;      -- To store another ingredient
      Creation    : Item_Type;             -- To store the created item and all it's attributes
      Item_Kind   : Unbounded_String;      -- To store the kind of item that's being read in
   BEGIN
      -- Open the file
      Open(File => Alchemy_File, Mode => In_File,Name => To_String(File_Name));

      -- Loop through until all the nodes have been read in
      FOR I IN Integer RANGE 1..Num_Of_Nodes LOOP
         -- Read in the ingredients and the kind of item being created
         Ingredient1 := To_Unbounded_String(Get_Line(Alchemy_File));
         Ingredient2 := To_Unbounded_String(Get_Line(Alchemy_File));
         Item_Kind := To_Unbounded_String(Get_Line(Alchemy_File));
         -- If the item is a consumable
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
         -- If the item is a weapon
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
         -- If the item is an armor
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
         -- Insert the complete recipe into the tree
         Insert_Recipe(Ingredient1 => Ingredient1, Ingredient2 => Ingredient2, Creation => Creation, Root => Root);
      END LOOP;
   end Build_Tree;

   -----------------
   -- Synthesize --
   -----------------

   -- Attempts to find a requested recipe
   PROCEDURE Synthesize(Ingredient1 : Unbounded_String; Ingredient2 : Unbounded_String; Creation : IN OUT Item_Type; Root : IN OUT Node_Ptr) IS
   BEGIN
      -- If the tree is empty, leave the procedure
      IF Root = NULL THEN
         RETURN;
      -- If the ingredient being looked at is lower alphabetically than the requested ingredient, move to the right
      ELSIF To_Lower(To_String(Ingredient1)) >= To_Lower(To_String(Root.Ingredient1)) AND
            To_Lower(To_String(Ingredient2)) /= To_Lower(To_String(Root.Ingredient2)) THEN
         Synthesize(Ingredient1 => Ingredient1, Ingredient2 => Ingredient2, Creation => Creation, Root => Root.Right);
      -- If the ingredient being looked at is higher alphabetically than the requested ingredient, move to the left
      ELSIF To_Lower(To_String(Ingredient2)) < To_Lower(To_String(Root.Ingredient2)) THEN
         Synthesize(Ingredient1 => Ingredient1, Ingredient2 => Ingredient2, Creation => Creation, Root => Root.Left);
      -- If this is the recipe, store the creation and exit the procedure
      ELSIF To_Lower(To_String(Root.Ingredient1)) = To_Lower(To_String(Ingredient1)) AND
            To_Lower(To_String(Root.Ingredient2)) = To_Lower(To_String(Ingredient2)) THEN
         Creation := Root.Creation;
      END IF;
   END Synthesize;

   -- Prints the recipes in the tree in LNR traversal
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
