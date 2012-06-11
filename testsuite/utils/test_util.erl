% Licensed under the Apache License, Version 2.0 (the "License"); you may not
% use this file except in compliance with the License. You may obtain a copy of
% the License at
%
%   http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
% WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
% License for the specific language governing permissions and limitations under
% the License.

-module(test_util).

-include("test_util.hrl").

-export([srcdir/0, builddir/0, etcdir/0, sharedir/0, varlibdir/0, localdir/0]).
-export([init_code_path/0]).
-export([source_file/1, build_file/1, etc_file/1, share_file/1, local_file/1, varlib_file/1, config_files/0]).
-export([request/3, request/4]).

srcdir() -> ?COUCHDB_TEST_PATH.

builddir() -> filename:join([?COUCHDB_TEST_PATH,?COUCHDB_TEST_LIB_PATH]).

etcdir() -> filename:join([?COUCHDB_TEST_PATH,?COUCHDB_TEST_ETC_PATH]).

sharedir() -> filename:join([?COUCHDB_TEST_PATH,?COUCHDB_TEST_SHARE_PATH]).

varlibdir() -> filename:join([?COUCHDB_TEST_PATH,?COUCHDB_TEST_VARLIB_PATH]).

localdir() -> ?COUCHDB_TEST_ETAP_PATH.

init_code_path() ->
    Paths = ["etap"++?COUCHDB_TEST_ETAP_VERSION,
             "couch"++?COUCHDB_TEST_VERSION,
             "ejson"++?COUCHDB_TEST_EJSON_VERSION,
             "erlang-oauth"++?COUCHDB_TEST_ERLANG_OAUTH_VERSION,
             "ibrowse"++?COUCHDB_TEST_IBROWSE_VERSION,
             "mochiweb"++?COUCHDB_TEST_MOCHIWEB_VERSION,
             "snappy"++?COUCHDB_TEST_SNAPPY_VERSION],
    lists:foreach(fun(Name) ->
        code:add_patha(filename:join([builddir(), ?COUCHDB_TEST_EXTRA, Name, ?COUCHDB_TEST_EBIN]))
    end, Paths).

source_file(Name) ->
    filename:join([srcdir(), Name]).

build_file(Name) ->
    filename:join([builddir(), Name]).

etc_file(Name) ->
    filename:join([etcdir(), Name]).

share_file(Name) ->
    filename:join([sharedir(), Name]).

varlib_file(Name) ->
    filename:join([varlibdir(), Name]).

local_file(Name) ->
    filename:join([localdir(), Name]).

config_files() ->
    [
        etc_file("default.ini"),
        local_file("random_port.ini"),
        etc_file("local.ini")
    ].


request(Url, Headers, Method) ->
    request(Url, Headers, Method, []).

request(Url, Headers, Method, Body) ->
    request(Url, Headers, Method, Body, 3).

request(_Url, _Headers, _Method, _Body, 0) ->
    {error, request_failed};
request(Url, Headers, Method, Body, N) ->
    case code:is_loaded(ibrowse) of
    false ->
        {ok, _} = ibrowse:start();
    _ ->
        ok
    end,
    case ibrowse:send_req(Url, Headers, Method, Body) of
    {ok, Code0, RespHeaders, RespBody0} ->
        Code = list_to_integer(Code0),
        RespBody = iolist_to_binary(RespBody0),
        {ok, Code, RespHeaders, RespBody};
    {error, {'EXIT', {normal, _}}} ->
        % Connection closed right after a successful request that
        % used the same connection.
        request(Url, Headers, Method, Body, N - 1);
    Error ->
        Error
    end.
