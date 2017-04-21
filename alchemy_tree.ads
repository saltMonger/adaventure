WITH Item_List;               USE Item_List;
WITH Ada.Text_IO;             USE Ada.Text_IO;
WITH Ada.Strings.Unbounded;   USE Ada.Strings.Unbounded;

PACKAGE Alchemy_Tree IS

   TYPE Node;
   TYPE Node_Ptr IS ACCESS Node;

   -- A node to store a recipe
   TYPE Node IS RECORD
      Ingredient1 : Unbounded_String;
      Ingredient2 : Unbounded_String;
      Creation    : Item_Type;
      Left        : Node_Ptr;
      Right       : Node_Ptr;
   END RECORD;

   -- This procedure inserts a recipe into the tree. The recipe consists of:
   --                  - Ingredient1
   --                  - Ingredient2
   --                  - The item created from the ingredients
   PROCEDURE Insert_Recipe(Ingredient1 : Unbounded_String; Ingredient2 : Unbounded_String; Creation : Item_Type; Root : IN OUT Node_Ptr);

   -- Accepts a file of recipes to store in a tree
   PROCEDURE Build_Tree(File_Name : Unbounded_String; Root : IN OUT Node_Ptr);

   -- Finds the appropriate recipe and returns it's creation for the calling program to store in the player's backpack
   PROCEDURE Synthesize(Ingredient1 : Unbounded_String; Ingredient2 : Unbounded_String; Creation : IN OUT Item_Type; Root : IN OUT Node_Ptr);

   -- Prints the tree in LNR traversal(alphabetical order)
   PROCEDURE Print_Tree(Root : Node_Ptr);

END Alchemy_Tree;
