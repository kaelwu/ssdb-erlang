%%%-------------------------------------------------------------------
%%% @author Kael_Wu
%%% @copyright (C) 2015, <COMPANY>
%%% @doc 自实现erlang list分割基于ssdb
%%%
%%% @end
%%% Created : 01. 四月 2015 下午5:27
%%%-------------------------------------------------------------------
-module(my_string).
-author("Kael Wu").

%% API
-export([split/1]).

split(List) ->
  ResSignLen = lists:sublist(List, 1),
%% 从第三位开始计算，除去结果标记的长度和一个换行符
  ResSign = lists:sublist(List, 3, list_to_integer(ResSignLen)),
%% 获取结果信息长度
  case ResSign of
    "ok" ->
      Start = 6,
%%       Len标示结果集的长度的长度，Res标示结果集的长度 详情参考ssdb协议
      {Len, ResLen} = getMsgLen(List, Start, []),
      case ResLen of
        0 ->
          {ok, ok};
        _ ->
          %% 除去最后两个\n以及去除包头信息.这里多个信息时候有问题 需要改进.
          AllLen = lists:flatlength(List),
          Res = lists:sublist(List, 5 + Len + 2, AllLen - 8 - Len),
          {ok, Res}
      end;
    "no_found" ->
      not_found;
    _ ->
      error
end.

getMsgLen(List, Start, L) ->
  Tmp = lists:sublist(List, Start, 1),
  NewL = L ++ Tmp,
  case Tmp of
    "\n" ->
      Len = lists:flatlength(L),
      case L of
        [] ->
          {0, 0};
        _ ->
          {Len, list_to_integer(L)}
      end;
    _ ->
      getMsgLen(List, Start + 1, NewL)
  end.




