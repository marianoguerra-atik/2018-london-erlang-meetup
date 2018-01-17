-module(rckv).

-export([ping/0, get/1, put/2, delete/1]).
-ignore_xref([ping/0, get/1, put/2, delete/1]).

%% Public API

%% @doc Pings a random vnode to make sure communication is functional
ping() ->
    DocIdx = riak_core_util:chash_key({<<"ping">>, term_to_binary(os:timestamp())}),
    PrefList = riak_core_apl:get_primary_apl(DocIdx, 1, rckv),
    [{IndexNode, _Type}] = PrefList,
    riak_core_vnode_master:sync_spawn_command(IndexNode, ping, rckv_vnode_master).

get(Key) ->
    send_to_one(Key, {get, Key}).

delete(Key) ->
    send_to_one(Key, {delete, Key}).

put(Key, Value) ->
    send_to_one(Key, {put, Key, Value}).

% private functions

send_to_one(Key, Cmd) ->
    DocIdx = riak_core_util:chash_key(Key),
    PrefList = riak_core_apl:get_primary_apl(DocIdx, 1, rckv),
    [{IndexNode, _Type}] = PrefList,
    riak_core_vnode_master:sync_spawn_command(IndexNode, Cmd,
         rckv_vnode_master).
