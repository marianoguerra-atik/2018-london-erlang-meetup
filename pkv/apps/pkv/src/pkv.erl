-module(pkv).

-export([ping/1, set/3, get/2]).

ping(NodeName) ->
    partisan_peer_service:forward_message(NodeName, pkv_handler, ping).

set(Ns, Key, Value) ->
    {ok, MsgId} = pkv_broadcast_handler:set(Ns, Key, Value),
    partisan_plumtree_broadcast:broadcast({MsgId, Ns, Key, Value},
                                          pkv_broadcast_handler).

get(Ns, Key) ->
    pkv_broadcast_handler:get(Ns, Key).

