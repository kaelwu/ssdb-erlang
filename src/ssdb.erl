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
-export([start_link/0, set/2, get/1]).

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

set(Key, Value) ->
  case gen_server:call(?MODULE, {set, Key, Value}) of
    {ok, Bindata} ->
      {ok, Bindata};
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

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================


init([]) ->
  case network:conn("127.0.0.1", 8888) of
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
