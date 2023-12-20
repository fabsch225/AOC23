#!/usr/bin/env escript
%%! -noshell

main(Args) ->
    File = case Args of
               [F | _] -> F;
               [] -> filename:join(filename:dirname(escript:script_name()), "in.txt")
           end,
    {ok, Bin} = file:read_file(File),
    [WfText, PartText] = string:split(string:trim(binary_to_list(Bin)), "\n\n"),
    Flows = maps:from_list([parse_flow(L) || L <- string:tokens(WfText, "\n")]),
    Parts = [parse_part(L) || L <- string:tokens(PartText, "\n")],
    io:format("~p~n", [lists:sum([rating(P) || P <- Parts, accepted(Flows, "in", P)])]),
    Full = maps:from_list([{C, {1, 4000}} || C <- "xmas"]),
    io:format("~p~n", [count(Flows, "in", Full)]).

parse_flow(Line) ->
    [Name | Rules] = string:tokens(Line, "{},"),
    {Name, [parse_rule(R) || R <- Rules]}.

parse_rule([C, Op | Rest]) when Op =:= $<; Op =:= $> ->
    {N, [$: | Dest]} = string:to_integer(Rest),
    {C, Op, N, Dest};
parse_rule(Dest) ->
    Dest.

parse_part(Line) ->
    maps:from_list(pairs(string:tokens(Line, "{},="))).

pairs([]) -> [];
pairs([[C], N | T]) -> [{C, list_to_integer(N)} | pairs(T)].

rating(P) -> lists:sum(maps:values(P)).

accepted(_, "A", _) -> true;
accepted(_, "R", _) -> false;
accepted(Flows, Name, P) ->
    accepted(Flows, apply_rules(maps:get(Name, Flows), P), P).

apply_rules([Dest], _) when is_list(Dest) -> Dest;
apply_rules([{C, Op, N, Dest} | Rest], P) ->
    V = maps:get(C, P),
    case (Op =:= $< andalso V < N) orelse (Op =:= $> andalso V > N) of
        true -> Dest;
        false -> apply_rules(Rest, P)
    end.

count(_, "R", _) -> 0;
count(_, "A", Ranges) ->
    lists:foldl(fun({Lo, Hi}, Acc) -> Acc * (Hi - Lo + 1) end, 1, maps:values(Ranges));
count(Flows, Name, Ranges) ->
    walk(maps:get(Name, Flows), Ranges, Flows).

walk([Dest], Ranges, Flows) when is_list(Dest) -> count(Flows, Dest, Ranges);
walk([{C, Op, N, Dest} | Rest], Ranges, Flows) ->
    {Lo, Hi} = maps:get(C, Ranges),
    {Yes, No} = case Op of
                    $< -> {{Lo, min(Hi, N - 1)}, {max(Lo, N), Hi}};
                    $> -> {{max(Lo, N + 1), Hi}, {Lo, min(Hi, N)}}
                end,
    Sub = fun({A, B}, F) when A =< B -> F(); (_, _) -> 0 end,
    Sub(Yes, fun() -> count(Flows, Dest, Ranges#{C := Yes}) end) +
        Sub(No, fun() -> walk(Rest, Ranges#{C := No}, Flows) end).
