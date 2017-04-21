With Ada.Numerics.Discrete_Random;

PACKAGE DamageUtils IS

      --Dice declarations
   	subtype D2 is Integer range 0 .. 1;
	subtype D4 is Integer range 1 .. 3;
	subtype D6 is Integer range 1 .. 6;
	subtype D8 is Integer range 1 .. 8;
	subtype D10 is Integer range 1 .. 10;
	subtype D12 is Integer range 1 .. 12;
   SUBTYPE D20 IS Integer RANGE 1 .. 20;

      package Random_D2 is new Ada.Numerics.discrete_Random(D2);
	package Random_D4 is new Ada.Numerics.discrete_Random(D4);
	package Random_D6 is new Ada.Numerics.discrete_Random(D6);
	package Random_D8 is new Ada.Numerics.discrete_Random(D8);
      package Random_D10 is new Ada.Numerics.discrete_Random(D10);
   PACKAGE Random_D12 IS NEW Ada.Numerics.Discrete_Random(D12);
   PACKAGE Random_D20  IS NEW Ada.Numerics.Discrete_Random(D20);

   Die2   :   Random_D2.Generator;
   Die4   :   Random_D4.Generator;
   Die6   :   Random_D6.Generator;
   Die8   :   Random_D8.Generator;
   Die10   :   Random_D10.Generator;
   Die12   :   Random_D12.Generator;
   Die20   :   Random_D20.Generator;

   --Sets the seed for all dice rollers
   PROCEDURE InitDamageUtils;

   --Determines damage, to be used with Enemy/Player damage routines
   FUNCTION RollDamage(DmgT : Integer; DmgNum : Integer; STR : Integer) RETURN Integer;

   --Determines attack value, used with Enemy/Player damage routines
   PROCEDURE RollAttack(DEX : IN Integer; IsCrit : OUT Boolean; RollValue : OUT Integer);


END DamageUtils;

