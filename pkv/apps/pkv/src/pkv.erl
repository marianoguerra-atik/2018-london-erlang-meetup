-module(pkv).

-export([ping/1]).

ping(NodeName) ->
    partisan_peer_service:forward_message(NodeName, pkv_handler, ping).
