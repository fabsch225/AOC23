:- initialization(main, main).

main(Args) :-
    ( Args = [F|_] -> true ; F = 'in.txt' ),
    read_file_to_string(F, S, []),
    split_string(S, "\n", "", Ls0),
    exclude(==(""), Ls0, Ls),
    maplist(parse, Ls, Hands),
    winnings(Hands, false, P1),
    winnings(Hands, true, P2),
    format("~w~n~w~n", [P1, P2]).

parse(L, H-B) :-
    split_string(L, " ", "", [HS, BS]),
    string_chars(HS, H),
    number_string(B, BS).

winnings(Hands, Joker, Total) :-
    findall(Key-B, (member(H-B, Hands), key(Joker, H, Key)), Ks),
    keysort(Ks, Sorted),
    foldl(step, Sorted, 0-0, _-Total).

step(_-B, N0-A0, N-A) :-
    N is N0+1,
    A is A0+N*B.

key(Joker, H, Type-Vals) :-
    maplist(val(Joker), H, Vals),
    type(Joker, H, Type).

val(Joker, C, V) :-
    ( Joker == true -> Order = "J23456789TQKA" ; Order = "23456789TJQKA" ),
    string_chars(Order, Cs),
    nth0(V, Cs, C), !.

type(Joker, H, Counts) :-
    ( Joker == true -> exclude(==('J'), H, Rest) ; Rest = H ),
    length(Rest, R),
    NJ is 5-R,
    msort(Rest, Sorted),
    clumped(Sorted, Pairs),
    pairs_values(Pairs, Cl0),
    sort(0, @>=, Cl0, Cl),
    ( Cl = [Top|Others] -> Top1 is Top+NJ, Counts = [Top1|Others] ; Counts = [5] ).
