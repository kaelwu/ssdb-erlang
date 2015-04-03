%%%-------------------------------------------------------------------
%%% @author keal
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 一月 2015 下午2:36
%%%-------------------------------------------------------------------
-module(test_ssdb).
-author("keal").

%% API
-export([test/2]).
test(_Host, _Port) ->
  todo.
%%   case ssdb_conn:conn(Host, Port) of
%%     {ok, Sock} ->
%%       A = 22,
%%       NA = A,
%%       B = 333,
%%       NB = B,
%%       ssdb_conn:get(Sock, "123"),
%%       ssdb_conn:recv(Sock);
%%     {error, E} ->
%%       io:format("~p", [E])
%%   end.
