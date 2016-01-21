%%%-------------------------------------------------------------------
%%% @author Kael_Wu
%%% @copyright (C) 2015, <COMPANY>
%%% @doc ssdb 客户端gen_server
%%%
%%% @end
%%% Created : 02. 四月 2015 上午10:33
%%%-------------------------------------------------------------------
-module(ssdb).
-author("Kael Wu").

-behaviour(gen_server).

%% API
-export([start_link/0, set/2, get/1, del/1, ping/0,
  dbsize/0, strlen/1, info/0, setx/3, exsits/1, setnx/2, getset/2, incr/1, incr/2, expire/2,
  ttl/1]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {}).

%%%===================================================================
%%% API
%%%===================================================================

ping() ->
  case gen_server:call(?MODULE, {ping}) of
    {ok, Res} ->
      Res;
    no_found ->
      no_found;
    error ->
      error
  end.

set(Key, Value) ->
  case gen_server:call(?MODULE, {set, Key, Value}) of
    {ok, _Bindata} ->
      ok;
    no_found ->
      no_found;
    error ->
      error
  end.

get(Key) ->
  case gen_server:call(?MODULE, {get, Key}) of
    {ok, Res} ->
      Res;
    no_found ->
      no_found;
    error ->
      error
  end.

del(Key) ->
  case gen_server:call(?MODULE, {del, Key}) of
    {ok, _Res} ->
      ok;
    no_found ->
      no_found;
    error ->
      error
  end.

dbsize() ->
  case gen_server:call(?MODULE, {dbsize}) of
    {ok, Res} ->
      Res;
    no_found ->
      no_found;
    error ->
      error
  end.

strlen(Key) ->
  case gen_server:call(?MODULE, {strlen, Key}) of
    {ok, Res} ->
      Res;
    no_found ->
      no_found;
    error ->
      error
  end.

info() ->
  case gen_server:call(?MODULE, {info}) of
    {ok, Res} ->
      Res;
    no_found ->
      no_found;
    error ->
      error
  end.

setx(Key, Value, TTL) ->
  case gen_server:call(?MODULE, {setx, Key, Value, TTL}) of
    {ok, Res} ->
      Res;
    no_found ->
      no_found;
    error ->
      error
  end.

setnx(Key, Value) ->
  case gen_server:call(?MODULE, {setnx, Key, Value}) of
    {ok, Res} ->
      Res;
    no_found ->
      no_found;
    error ->
      error
  end.

expire(Key, TTl) ->
  case gen_server:call(?MODULE, {expire, Key, TTl}) of
    {ok, Res} ->
      Res;
    no_found ->
      no_found;
    error ->
      error
  end.

ttl(Key) ->
  case gen_server:call(?MODULE, {ttl, Key}) of
    {ok, Res} ->
      Res;
    no_found ->
      no_found;
    error ->
      error
  end.

getset(Key, Value) ->
  case gen_server:call(?MODULE, {getset, Key, Value}) of
    {ok, Res} ->
      Res;
    no_found ->
      no_found;
    error ->
      error
  end.

incr(Key) ->
  case gen_server:call(?MODULE, {incr, Key}) of
    {ok, Res} ->
      Res;
    no_found ->
      no_found;
    error ->
      error
  end.

incr(Key, Num) ->
  case gen_server:call(?MODULE, {incr, Key, Num}) of
    {ok, Res} ->
      Res;
    no_found ->
      no_found;
    error ->
      error
  end.

exsits(Key) ->
  case gen_server:call(?MODULE, {exists, Key}) of
    {ok, Res} ->
      Res;
    no_found ->
      no_found;
    error ->
      error
  end.

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================


init([]) ->
  {ok, Host} = application:get_env(host),
  {ok, Port} = application:get_env(port),
  case network:conn(Host, Port) of
    {ok, Socket} ->
      put(socket, Socket),
      {ok, #state{}};
    {error, _E} ->
      {error, #state{}}
  end.


handle_call(Info, _From, State) ->
  List = tuple_to_list(Info),
  Msg = protocol:serialize(List),
  Socket = erlang:get(socket),
  network:synSend(Socket, Msg),
  RecvBin = network:recv(Socket),
  Res = protocol:deserialization(RecvBin),
  {reply, Res, State}.

handle_cast(_Request, State) ->
  {noreply, State}.


handle_info(_Info, State) ->
  {noreply, State}.


terminate(_Reason, _State) ->
  ok.


code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
