PACKAGE BODY Backpack IS

   PROCEDURE Initialize_Backpack(Backpack : IN OUT Zipper; Bottom : IN OUT Zipper) IS
   BEGIN
      Found_Item(Get_Item(2), Backpack, Bottom);

      FOR I IN Integer RANGE 1..5 LOOP
         Found_Item(Get_Item(1), Backpack, Bottom);
      END LOOP;

      Found_Item(Get_Item(3), Backpack, Bottom);
      Found_Item(Get_Item(5), Backpack, Bottom);
   END Initialize_Backpack;
   ----------------
   -- Found_Item --
   ----------------

   PROCEDURE Found_Item (Item_Record : Item_Type; Backpack : IN OUT Zipper; Bottom : IN OUT Zipper) IS
      Current : Zipper := Backpack;         -- Set current to point to the front of the backpack list
   BEGIN
      Current_Weight := Current_Weight + Item_Record.Weight;
      -- Traverse the list making sure the item isn't already in the list
      WHILE Current /= NULL LOOP
         -- If the item is already in the list, simply add to the item's node's counter to indicate there is
         -- more than 1 of that particular item in inventory
         IF Item_Record.Name = Current.Item.Name THEN
            Current.Num_Of_Item := Current.Num_Of_Item + 1;
            RETURN;
         END IF;
         Current := Current.Next;
      END LOOP;

      -- If the backpack is empty, add the new item
      IF Backpack = NULL THEN
         Backpack := NEW Pouch'(Item => Item_Record, Num_Of_Item => 1, Prev => NULL, Next => NULL);
         Bottom := Backpack;
      -- If the item is a consumable or the only thing in the list is armor, add the item to the front
      ELSIF Item_Record.Kind_Of_Item = Consumable OR ELSE
            ((Backpack.Item.Kind_Of_Item = Armor OR Backpack.Item.Kind_Of_Item = Weapon) AND Item_Record.Kind_Of_Item = Weapon) THEN
         Backpack.Prev := NEW Pouch'(Item => Item_Record, Num_Of_Item => 1, Prev => NULL, Next => Backpack);
         Backpack := Backpack.Prev;
      -- If the item is a piece of armor or if the last item in the list is a consumable(indicating this item
      -- would have to be a weapon and the list only contains consumables, at this point in the if statement cases),
      -- add the it to the back of the list
      ELSIF Item_Record.Kind_Of_Item = Armor OR ELSE Bottom.Item.Kind_Of_Item = Consumable THEN
         Bottom.Next := NEW Pouch'(Item => Item_Record, Num_Of_Item => 1, Prev => Bottom, Next => NULL);
         Bottom := Bottom.Next;
      -- If the item is a weapon, find the start of the weapons part of the list, or if there are no weapons
      -- in the backpack yet, find the start of the armor part of the list
      ELSIF Item_Record.Kind_Of_Item = Weapon THEN
         Current := Backpack;
         WHILE Current /= NULL LOOP
            IF Current.Item.Kind_Of_Item = Weapon OR ELSE Current.Item.Kind_Of_Item = Armor THEN
               Current.Prev := NEW Pouch'(Item => Item_Record, Num_Of_Item => 1, Prev => Current.Prev, Next => Current);
               Current.Prev.Prev.Next := Current.Prev;
               RETURN;
            END IF;
            Current := Current.Next;
         END LOOP;
      END IF;
   END Found_Item;

   --------------
   -- Use_Item --
   --------------

   PROCEDURE Use_Item (Name_Of_Item : Unbounded_String; Backpack : IN OUT Zipper; Bottom : IN OUT Zipper; Stats : IN OUT Integer_Array) IS
      Current : Zipper := Backpack;
   BEGIN
      -- Traverse the list, checking if the current item is consumable and whether or not the item is in the backpack
      WHILE Current /= NULL LOOP
         -- Once found, deliver the stat boosts/restoratives to the user
         IF To_Lower(To_String(Current.Item.Name)) = To_Lower(To_String(Name_Of_Item)) AND Current.Item.Kind_Of_Item = Consumable THEN
            Stats(1) := Current.Item.Heal_HP;
            Put(Stats(1));
            Stats(2) := Current.Item.Attack_Boost;
            Stats(3) := Current.Item.Defense_Boost;
            Stats(4) := Current.Item.Agility_Boost;
            Stats(5) := Current.Item.Restore_MP;
            -- Then remove the item from the backpack
            Throw_Away_Item(Name_Of_Item => Name_Of_Item, Backpack => Backpack, Bottom => Bottom);
            RETURN;
         END IF;
         -- If an item in the list has been reached that isn't a consumable, then there must be no/or no remaining
         -- consumables in the list. In this case, break out of the procedure.
         IF Current.Item.Kind_Of_Item /= Consumable THEN
            Put("'" & To_String(Name_Of_Item) & "' is not in your backpack to use.");
            RETURN;
         END IF;
         Current := Current.Next;
      END LOOP;
   END Use_Item;

   ---------------------
   -- Throw_Away_Item --
   ---------------------

   PROCEDURE Throw_Away_Item (Name_Of_Item : Unbounded_String; Backpack : IN OUT Zipper; Bottom : IN OUT Zipper) IS
      Current : Zipper := Backpack;
   BEGIN
      -- If the list is empty
      IF Backpack = NULL THEN
         Put("Your backpack is empty, you poor dingbat.");
         -- If the item is the only item left in the list
      ELSIF To_Lower(To_String(Backpack.Item.Name)) = To_Lower(To_String(Name_Of_Item))
        AND To_Lower(To_String(Bottom.Item.Name)) = To_Lower(To_String(Name_Of_Item)) THEN
         IF Backpack.Num_Of_Item > 1 THEN
            Backpack.Num_Of_Item := Backpack.Num_Of_Item - 1;
            Current_Weight := Current_Weight - Backpack.Item.Weight;
         ELSE
            Current_Weight := Current_Weight - Backpack.Item.Weight;
            Free(Backpack);
            Bottom := NULL;
            Backpack := NULL;
         END IF;
      -- If the throw away item is at the front
      ELSIF To_Lower(To_String(Backpack.Item.Name)) = To_Lower(To_String(Name_Of_Item)) THEN
         IF Backpack.Num_Of_Item > 1 THEN
            Backpack.Num_Of_Item := Backpack.Num_Of_Item - 1;
            Current_Weight := Current_Weight - Backpack.Item.Weight;
         ELSE
            Backpack := Backpack.Next;
            Backpack.Prev.Next := NULL;
            Current_Weight := Current_Weight - Backpack.Prev.Item.Weight;
            Free(Backpack.Prev);
            Backpack.Prev := NULL;
         END IF;
      -- If the throw away item is at the back
      ELSIF To_Lower(To_String(Bottom.Item.Name)) = To_Lower(To_String(Name_Of_Item)) THEN
         IF Bottom.Num_Of_Item > 1 THEN
            Bottom.Num_Of_Item := Bottom.Num_Of_Item - 1;
            Current_Weight := Current_Weight - Bottom.Item.Weight;
         ELSE
            Bottom := Bottom.Prev;
            Bottom.Next.Prev := NULL;
            Current_Weight := Current_Weight - Bottom.Next.Item.Weight;
            Free(Bottom.Next);
            Bottom.Next := NULL;
         END IF;
      -- If the throw away item is in the middle
      ELSE
         WHILE Current /= NULL LOOP
            IF To_Lower(To_String(Current.Item.Name)) = To_Lower(To_String(Name_Of_Item)) THEN
               IF Current.Num_Of_Item > 1 THEN
                  Current.Num_Of_Item := Current.Num_Of_Item - 1;
                  Current_Weight := Current_Weight - Current.Item.Weight;
               ELSE
                  Current.Prev.Next := Current.Next;
                  Current.Next.Prev := Current.Prev;
                  Current.Next := NULL;
                  Current.Prev := NULL;
                  Current_Weight := Current_Weight - Current.Item.Weight;
                  Free(Current);
                  RETURN;
               END IF;
            END IF;
            Current := Current.Next;
         END LOOP;
      END IF;
   END Throw_Away_Item;

   --------------------
   -- Check_Backpack --
   --------------------

   PROCEDURE Check_Backpack (Backpack : Zipper) IS
      Current : Zipper := Backpack;
   BEGIN

      -- If the backpack is empty
      IF Current = NULL THEN
         Put("Your backpack is currently empty.");
      END IF;

      -- Traverse the list and print out the item name, description, and number of that particular item currently in the backpack
      WHILE Current /= NULL LOOP
         Put("****************************************");
         New_Line;
         Put(To_String(Current.Item.Name));
         Put("     x");
         Put(Item => Current.Num_Of_Item, Width => 0);
         Put("     ");
         Put(Item => (Current.Item.Weight * Float(Current.Num_Of_Item)), Fore => 3, Aft => 1, Exp => 0);
         Put(" lbs");
         New_Line;
         Put(To_String(Current.Item.Description));
         New_Line;
         IF Current.Item.Kind_Of_Item = Weapon OR ELSE Current.Item.Kind_Of_Item = Armor THEN
            IF Current.Item.Is_Equipped = True THEN
               Put("EQUIPPED");
               New_Line;
            END IF;
         END IF;
         Put("Trade Value: $");
         Put(Item => Current.Item.Loot_Value * 0.75, Fore => 2, Aft => 2, Exp => 0);
         New_Line;
         Current := Current.Next;
      END LOOP;
   END Check_Backpack;

   PROCEDURE Equip(Name_Of_Desired_Equipment : Unbounded_String; Current_Weapon : IN OUT Item_Type; Current_Armor : IN OUT Item_Type; Bottom : Zipper) IS
      Equip_Ptr : Zipper := Bottom;
      Unequip_Ptr   : Zipper := Bottom;
   BEGIN
      WHILE Equip_Ptr /= NULL AND THEN Equip_Ptr.Item.Kind_Of_Item /= Consumable LOOP
         IF To_Lower(To_String(Equip_Ptr.Item.Name)) = To_Lower(To_String(Name_Of_Desired_Equipment)) THEN
            IF Equip_Ptr.Item.Kind_Of_Item = Weapon THEN
               Equip_Ptr.Item.Is_Equipped := True;
               Current_Weapon := Equip_Ptr.Item;
            ELSIF Equip_Ptr.Item.Kind_Of_Item = Armor THEN
               Equip_Ptr.Item.Is_Equipped := True;
               Current_Armor := Equip_Ptr.Item;
            END IF;
            WHILE Unequip_Ptr /= NULL AND THEN Unequip_Ptr.Item.Kind_Of_Item /= Consumable LOOP
               IF Unequip_Ptr.Item.Is_Equipped = True AND THEN Unequip_Ptr.Item.Kind_Of_Item = Equip_Ptr.Item.Kind_Of_Item
                  AND THEN To_Lower(To_String(Equip_Ptr.Item.Name)) /= To_Lower(To_String(Unequip_Ptr.Item.Name)) THEN
                  Unequip_Ptr.Item.Is_Equipped := False;
                  RETURN;
               END IF;
               Unequip_Ptr := Unequip_Ptr.Prev;
            END LOOP;
            RETURN;
         END IF;
         Equip_Ptr := Equip_Ptr.Prev;
      END LOOP;
      Put("You don't own a piece of equipment that matches your request.");
      New_Line;
   END Equip;

   -- Returns TRUE if the current weight is LESS than the Allowable Weight.
   -- Returns FALSE if the backpack has TOO MUCH weight in it.
   FUNCTION Check_Weight RETURN Boolean IS
   BEGIN
      RETURN Allowable_Weight > Current_Weight;
   END Check_Weight;
END Backpack;
