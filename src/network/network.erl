%%%-------------------------------------------------------------------
%%% @author Kael_Wu
%%% @copyright (C) 2015, <COMPANY>
%%% @doc ssdb 网络控制类
%%%
%%% @end
%%% Created : 01. 四月 2015 下午6:23
%%%-------------------------------------------------------------------
-module(network).
-author("Kael Wu").

%% API
-export([conn/2, synSend/2, asynSend/2, recv/1]).

conn(Host, Port)->
  case gen_tcp:connect(Host, Port, [ binary, {packet, 0}]) of
    {ok, Socket} ->
      {ok, Socket};
    E ->
      {error, E}
  end.

%% 发送后需要调用recv方法获取返回信息.
synSend(Socket, Msg)->
  inet:setopts(Socket, [{active, false}, binary, {packet, 0}]),
  case gen_tcp:send(Socket, Msg) of
    ok ->
      send_ok;
    {error, E} ->
      {error, E}
  end.

%% 发送后直接获取返回信息.
asynSend(_Socket, _Msg)->
  todo.

recv(Socket)->
  case gen_tcp:recv(Socket, 0) of
    {ok,Packet} ->
      {ok,Packet};
    {error,Reason} ->
      {error,Reason}
  end.
