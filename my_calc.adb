with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Float_Text_IO;    use Ada.Float_Text_IO;

procedure My_Calc is

   Max_Length   : constant Natural := 200;
   Input_Line   : String (1 .. Max_Length);
   Len          : Natural;
   Current_Pos  : Natural := 1;

   ----------------------------------------------------------------
   -- Forward Declarations
   ----------------------------------------------------------------
   function Parse_Expression return Float;
   function Parse_Term return Float;
   function Parse_Factor return Float;
   function Parse_Primary return Float;

   ----------------------------------------------------------------
   -- Yardımcı Prosedür: Boşlukları atlar.
   ----------------------------------------------------------------
   procedure Skip_Whitespace is
   begin
      while Current_Pos <= Len and then Input_Line(Current_Pos) = ' ' loop
         Current_Pos := Current_Pos + 1;
      end loop;
   end Skip_Whitespace;

   ----------------------------------------------------------------
   -- Primary: Sayı veya parantezli ifade
   ----------------------------------------------------------------
   function Parse_Primary return Float is
      Number_Str : String (1 .. 50);
      J : Natural := 0;
      Result : Float;
   begin
      Skip_Whitespace;
      if Current_Pos <= Len and then Input_Line(Current_Pos) = '(' then
         Current_Pos := Current_Pos + 1;  -- '(' atla
         Result := Parse_Expression;
         Skip_Whitespace;
         if Current_Pos <= Len and then Input_Line(Current_Pos) = ')' then
            Current_Pos := Current_Pos + 1;  -- ')' atla
         else
            Put_Line("Error: Missing closing parenthesis");
         end if;
         return Result;
      else
         while Current_Pos <= Len and then (Input_Line(Current_Pos) in '0' .. '9' or else Input_Line(Current_Pos) = '.') loop
            J := J + 1;
            Number_Str(J) := Input_Line(Current_Pos);
            Current_Pos := Current_Pos + 1;
         end loop;
         if J = 0 then
            Put_Line("Error: Expected a number");
            return 0.0;
         else
            return Float'Value(Number_Str(1 .. J));
         end if;
      end if;
   end Parse_Primary;

   ----------------------------------------------------------------
   -- Factor: Primary [ '^' Factor ]
   -- Üs alma işlemi; exponentin tam sayı olması beklenir.
   ----------------------------------------------------------------
   function Parse_Factor return Float is
      Left : Float := Parse_Primary;
      Exponent : Float;
   begin
      Skip_Whitespace;
      if Current_Pos <= Len and then Input_Line(Current_Pos) = '^' then
         Current_Pos := Current_Pos + 1;
         Skip_Whitespace;
         Exponent := Parse_Factor;  -- Sağ birleşken
         if Exponent /= Float'Floor(Exponent) then
            Put_Line("Error: Exponent must be an integer");
            return 0.0;
         else
            return Left ** Natural(Exponent);  -- Exponenti tam sayıya çeviriyoruz.
         end if;
      else
         return Left;
      end if;
   end Parse_Factor;

   ----------------------------------------------------------------
   -- Term: Factor { ('*' | '/') Factor }
   ----------------------------------------------------------------
   function Parse_Term return Float is
      Left : Float := Parse_Factor;
      Temp : Float;
   begin
      Skip_Whitespace;
      while Current_Pos <= Len loop
         Skip_Whitespace;
         if Current_Pos <= Len and then Input_Line(Current_Pos) = '*' then
            Current_Pos := Current_Pos + 1;
            Skip_Whitespace;
            Left := Left * Parse_Factor;
         elsif Current_Pos <= Len and then Input_Line(Current_Pos) = '/' then
            Current_Pos := Current_Pos + 1;
            Skip_Whitespace;
            Temp := Parse_Factor;
            if Temp = 0.0 then
               Put_Line("Error: Division by zero");
               return 0.0;
            else
               Left := Left / Temp;
            end if;
         else
            exit;
         end if;
         Skip_Whitespace;
      end loop;
      return Left;
   end Parse_Term;

   ----------------------------------------------------------------
   -- Expression: Term { ('+' | '-') Term }
   ----------------------------------------------------------------
   function Parse_Expression return Float is
      Left : Float := Parse_Term;
   begin
      Skip_Whitespace;
      while Current_Pos <= Len loop
         Skip_Whitespace;
         if Current_Pos <= Len and then Input_Line(Current_Pos) = '+' then
            Current_Pos := Current_Pos + 1;
            Skip_Whitespace;
            Left := Left + Parse_Term;
         elsif Current_Pos <= Len and then Input_Line(Current_Pos) = '-' then
            Current_Pos := Current_Pos + 1;
            Skip_Whitespace;
            Left := Left - Parse_Term;
         else
            exit;
         end if;
      end loop;
      return Left;
   end Parse_Expression;

begin
   Put_Line("Simple Calculator in Ada");
   Put_Line("Enter an expression (e.g., (1 + 2) * 4, 10 / (5 + 2), 2 ^ 3, ((1 + 2) * 3) ^ 2).");
   Put_Line("Type 'exit' to quit.");
   
   loop
      Put("> ");
      Get_Line(Input_Line, Len);
      if Len = 0 then
         null;
      elsif Input_Line(1 .. Len) = "exit" then
         exit;
      else
         Current_Pos := 1;
         declare
            Result : Float := Parse_Expression;
         begin
            Put("Result: ");
            -- Aşağıdaki Put ile sonucu normal, düz formatta yazdırıyoruz (bilimsel gösterim olmaz).
            Ada.Float_Text_IO.Put(Item => Result, Fore => 0, Aft => 1, Exp => 0);
            New_Line;
         exception
            when others =>
               Put_Line("Error in expression");
         end;
      end if;
   end loop;
end My_Calc;
