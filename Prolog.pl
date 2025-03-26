:- dynamic var/2.

calculator :-
    write('Enter expression (type exit. to quit):'), nl,
    repeat,
    write('> '),
    read(Input),
    ( Input == exit ->
         !, nl, write('Goodbye.'), nl
    ; process(Input),
      fail
    ).

process(Input) :-
    ( Input = (Var = Expr) ->
          evaluate(Expr, Val),
          retractall(var(Var, _)),
          assert(var(Var, Val)),
          write(Var), write(' = '), write(Val), nl
    ; evaluate(Input, Result),
          write('Result: '), write(Result), nl
    ).

evaluate(Expr, Value) :-
    number(Expr), !, 
    Value = Expr.
evaluate(Expr, Value) :-
    var(Expr), !,
    write('Undefined variable encountered.'), nl, 
    Value = 0.
evaluate(Expr, Value) :-
    atomic(Expr), !,
    ( clause(var(Expr, V), true) ->
          Value = V
    ;   write('Undefined variable: '), write(Expr), nl,
          Value = 0
    ).
evaluate(Expr, Value) :-
    compound(Expr), !,
    Expr =.. [Op, A, B],
    evaluate(A, VA),
    evaluate(B, VB),
    calculate(Op, VA, VB, Value).

calculate(+, A, B, Value) :- Value is A + B.
calculate(-, A, B, Value) :- Value is A - B.
calculate(*, A, B, Value) :- Value is A * B.
calculate(/, A, B, Value) :-
    ( B =:= 0 ->
         write('Division by zero error.'), nl,
         Value = 0
    ;   Value is A / B
    ).
calculate(^, A, B, Value) :- Value is A ** B.
