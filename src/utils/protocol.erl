%%%-------------------------------------------------------------------
%%% @author Kael_Wu
%%% @copyright (C) 2015, <COMPANY>
%%% @doc ssdb协议序列化，以及反序列化的工具类
%%%
%%% @end
%%% Created : 01. 四月 2015 下午4:39
%%%-------------------------------------------------------------------
-module(protocol).
-author("Kael Wu").

%% API
-export([serialize/1, deserialization/1]).

serialize(SendMsg) ->
  MsgList = groupMsgForSSDB(SendMsg, []),
  MsgList.


deserialization(RecvMsg) ->
  case RecvMsg of
    {ok, Bin} ->
      Res = splitMsgForSSDB(Bin),
      case Res of
        {ok, _} ->
          Res;
        no_found ->
          no_found;
        error ->
          error
      end;
    _ ->
      error
  end.

groupMsgForSSDB(Info, L) ->
  Head = hd(Info),
  if
    is_atom(Head) ->
      TmpList = atom_to_list(Head);
    is_integer(Head) ->
      TmpList = integer_to_list(Head);
    is_float(Head) ->
      TmpList = float_to_list(Head)
  end,
  TmpLen = lists:flatlength(TmpList),
  NewL = lists:append(L, [integer_to_list(TmpLen), "\n", TmpList, "\n"]),
  NewInfo = tl(Info),
  case NewInfo of
    [] ->
      lists:append(NewL, ["\n"]);
    _ ->
      groupMsgForSSDB(NewInfo, NewL)
  end.

splitMsgForSSDB(Info) ->
  List = binary_to_list(Info),
  case my_string:split(List) of
    no_found ->
      no_found;
    {ok, Res} ->
      {ok, Res};
    error ->
      error
  end.