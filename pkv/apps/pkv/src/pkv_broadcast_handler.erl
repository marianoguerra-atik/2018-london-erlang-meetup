-module(pkv_broadcast_handler).

-behaviour(partisan_plumtree_broadcast_handler).

%% API
-export([start_link/0,
         start_link/1]).

%% partisan_plumtree_broadcast_handler callbacks
-export([broadcast_data/1,
         merge/2,
         is_stale/1,
         graft/1,
         exchange/1]).

-export([get/2, set/3]).

%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

%% State record.
-record(state, {}).

%%%===================================================================
%%% API
%%%===================================================================

%% @doc Same as start_link([]).
-spec start_link() -> {ok, pid()} | ignore | {error, term()}.
start_link() ->
    start_link([]).

%% @doc Start and link to calling process.
-spec start_link(list())-> {ok, pid()} | ignore | {error, term()}.
start_link(Opts) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, Opts, []).

%% @doc Returns from the broadcast message the identifier and the payload.
broadcast_data({MsgId, Ns, Key, Value}) ->
    {{MsgId, Ns, Key}, {Ns, Key, Value}}.

merge(MsgIdExt={MsgId, _Ns, _Key}, Payload) ->
    case is_stale(MsgIdExt) of
        true ->
            false;
        false ->
            gen_server:call(?MODULE, {merge, MsgId, Payload}, infinity),
            true
    end.

is_stale(MsgIdExt) ->
    gen_server:call(?MODULE, {is_stale, MsgIdExt}, infinity).

graft(MsgId) ->
    gen_server:call(?MODULE, {graft, MsgId}, infinity).

get(Ns, Key) ->
    gen_server:call(?MODULE, {get, Ns, Key}, infinity).

set(Ns, Key, Value) ->
    gen_server:call(?MODULE, {set, Ns, Key, Value}, infinity).

msg_id() -> {node(), erlang:unique_integer([monotonic])}.

%% @doc Anti-entropy mechanism.
-spec exchange(node()) -> {ok, pid()}.
exchange(_Peer) ->
    %% Ignore the standard anti-entropy mechanism from plumtree.
    %%
    %% Spawn a process that terminates immediately, because the
    %% broadcast exchange timer tracks the number of in progress
    %% exchanges and bounds it by that limit.
    Pid = spawn_link(fun() -> ok end),
    {ok, Pid}.

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%% @private
-spec init([]) -> {ok, #state{}}.
init([]) ->
    %% Seed the process at initialization.
    rand_compat:seed(erlang:phash2([node()]),
                     erlang:monotonic_time(),
                     erlang:unique_integer()),

    %% Open an ETS table
    ets:new(?MODULE, [named_table]),

    {ok, #state{}}.

%% @private
-spec handle_call(term(), {pid(), term()}, #state{}) ->
    {reply, term(), #state{}}.

%% @private
%% second item of is_stale tuple is the message identifier returned by
%% broadcast_data
handle_call({is_stale, {{Node, CurId}, Ns, Key}}, _From, State) ->
    Result = case ets:lookup(?MODULE, {last_msg, {Node, Ns, Key}}) of
        [] ->
            false;
        [{_, LastId}] ->
                     CurId =< LastId
    end,
    {reply, Result, State};

% graft receives msg identifier and must return message payload
handle_call({graft, {{Node, _Id}, Ns, Key}}, _From, State) ->
    MsgKey = {kv, Node, Ns, Key},
    Result = case ets:lookup(?MODULE, MsgKey) of
        [] ->
            lager:info("MsgId: ~p not found for graft.", [MsgKey]),
            {error, {not_found, MsgKey}};
        [{_MsgKey, Value}] ->
            % value returned here is sent as second tuple item to merge call
            {ok, {Ns, Key, Value}}
    end,
    {reply, Result, State};

handle_call({merge, {Node, NewId}, {Ns, Key, Value}}, _From, State) ->
    true = ets:insert(?MODULE, [{{last_msg, {Node, Ns, Key}}, NewId}]),
    true = ets:insert(?MODULE, [{{kv, Node, Ns, Key}, Value}]),
    {reply, ok, State};

% returns a list of lists where each item is [node(), value()]
handle_call({get, Ns, Key}, _From, State) ->
    Result = ets:match(?MODULE, {{kv, '$1', Ns, Key}, '$2'}),
    {reply, {ok, Result}, State};

handle_call({set, Ns, Key, Value}, _From, State) ->
    MsgId = msg_id(),
    {Node, _} = MsgId,
    true = ets:insert(?MODULE, [{{kv, Node, Ns, Key}, Value}]),
    {reply, {ok, MsgId}, State};

handle_call(Msg, _From, State) ->
    _ = lager:warning("Unhandled messages: ~p", [Msg]),
    {reply, ok, State}.

-spec handle_cast(term(), #state{}) -> {noreply, #state{}}.
%% @private
handle_cast(Msg, State) ->
    _ = lager:warning("Unhandled messages: ~p", [Msg]),
    {noreply, State}.

%% @private
handle_info(Msg, State) ->
    _ = lager:warning("Unhandled messages: ~p", [Msg]),
    {noreply, State}.

%% @private
-spec terminate(term(), #state{}) -> term().
terminate(_Reason, _State) ->
    ok.

%% @private
-spec code_change(term() | {down, term()}, #state{}, term()) ->
    {ok, #state{}}.
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

