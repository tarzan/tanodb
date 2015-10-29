-module(tanodb).
-include_lib("riak_core/include/riak_core_vnode.hrl").

-export([
         ping/0
        ]).

-ignore_xref([
              ping/0
             ]).

%% Public API

%% @doc Pings a random vnode to make sure communication is functional
ping() ->
    tanodb_metrics:core_ping(),
    DocIdx = riak_core_util:chash_key({<<"ping">>, term_to_binary(os:timestamp())}),
    PrefList = riak_core_apl:get_primary_apl(DocIdx, 1, tanodb),
    [{IndexNode, _Type}] = PrefList,
    riak_core_vnode_master:sync_spawn_command(IndexNode, ping, tanodb_vnode_master).
