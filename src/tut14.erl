-module(tut14).
-author("Irada").

-export([fileSort/0]).

main(_, [], _)->
  [];

main(0,Text, Alg)->
  binary_to_list(crypto:crypto_update(Alg, Text));

main(P, [Head | Text], Alg)->
  Parent = self(),
  Ref = make_ref(),
  spawn_link(fun() -> Parent ! {Ref,main(P-1, Text, Alg)} end),
  binary_to_list(crypto:crypto_update(Alg, Head)) ++ receive {Ref, Greater} -> Greater end.



fileSort() ->
  case file:read_file("test1.txt") of
    {ok, Binary} ->
%%      file:write_file("solution.txt", []),
      P = 1,
      BinaryList = binary_to_list(Binary),
      SplitBinaryList = split_bin(BinaryList, []),
      StartTime = erlang:system_time(millisecond),
      Alg = crypto:crypto_init(aes_128_ecb, <<"1111111111111111">>, true),
      Res = main(P, SplitBinaryList, Alg),
      EndTime = erlang:system_time(millisecond),
      io:format("Time: ~p~n", [(EndTime - StartTime)/1000]),
      io:write(Res),
      file:close(Binary);
    {error, Reason} ->  io:format("~p", [Reason])
  end.

split_bin([], Acc) -> lists:reverse(Acc);

split_bin(Binary, Acc)->
  Result = tuple_to_list(lists:split(16, Binary)),
  split_bin(hd(tl(Result)), [hd(Result) | Acc]).

%%writeFile4( Name, List ) ->
%%  file:write_file(Name, lists:map(fun(Term) -> integer_to_list(Term)++" " end, List),[append]).