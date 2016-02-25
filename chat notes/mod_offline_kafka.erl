-module(mod_offline_kafka).
-author('nikunjbhartia0@gmail.com').

-export([start/2, stop/1, process_and_send_offline_packet_to_kafka/3, 
        get_current_timestamp/0]).

-export([init/2]).

-import(mod_last, ([get_last_info/2])).

-behaviour(gen_mod).

-define(PROCNAME, ?MODULE).

-include("ejabberd.hrl").
-include("jlib.hrl").
-include("logger.hrl").
-include("lager.hrl").


-record(canned_activity, {us = {<<"">>, <<"">>, <<"">>} :: {binary(), binary(), binary()},
        timestamp = 0 :: non_neg_integer(),
        message_id = <<"">> :: binary()}).

start(Host, Opts) ->
    lager:log(info, self(), "****** STARTING OFFLINE KAFKA MODULE ********"),
    register(?PROCNAME,spawn(?MODULE, init, [Host, Opts])),
    case gen_mod:db_type(Host, Opts) of
        mnesia ->
            lager:log(info, self(), "-- creating canned_activity table --")
            mnesia:create_table(canned_activity,
                [{disc_copies, [node()]},
                    {attributes,
                        record_info(fields, canned_activity)}]),
            update_table();
        _ -> ok
    end,
    ok.

init(Host, _Opts) ->
    lager:log(info, self(), "****** INITIALIZING OFFLINE KAFKA MODULE ********"),
    X = ejabberd_hooks:add(offline_message_hook, Host, ?MODULE, process_and_send_offline_packet_to_kafka, 10),
    lager:log(info, self(), [X]),
    ok.

stop(Host) ->
    lager:log(info, self(), "****** STOPPING OFFLINE KAFKA MODULE ********"),
    ejabberd_hooks:delete(offline_message_hook, Host, ?MODULE, send_notice, 10),
    ok.

process_and_send_offline_packet_to_kafka(From, To, Packet = {xmlel, <<"message">>, Attrs = [{<<"message_id">>,MessageId}], _Els}) ->
    lager:log(info, self(), "--- inside send_offline_packet_to_kafka ---"),
    lager:log(info, self(), "Processing packet {\"from\": ~p, \"to\": ~p}",
        [binary_to_list(From#jid.luser),
            binary_to_list(To#jid.luser)]),
    
    FUser = From#jid.luser,
    TUser = To#jid.luser,
    LServer = To#jid.lserver,
    TimeStamp = get_current_timestamp(),
    
    case get_last_canned(FUser, TUser, LServer) of
        {error, _Reason} -> 
            lager:log(info, self(), lists:concat(["Error occured while reading canned_activity table : ",error]));
       
        not_found ->
            lager:log(info, self(), "No entry found in canned_activity table, storing new record !"),
            store_canned_info(FUser, TUser, LServer, TimeStamp, MessageId),
            send_offline_packet(From, To, Packet);
       
        {ok, TimeStamp, OldMsgId} ->
            case ;
        _ ->
            IQ#iq{type = result,
                sub_el =
                [#xmlel{name = <<"query">>,
                        attrs =
                        [{<<"xmlns">>, ?NS_LAST},
                            {<<"seconds">>, <<"0">>}],
                        children = []}]}
    end.
    


check_and_convert_binary(Data, int) ->
    try 
        binary_to_integer(Data)
    catch
        _:_ -> Data
    end.

send_offline_packet(From, To, Packet = {xmlel, <<"message">>, _Attrs, _Els}) ->
    lager:log(info, self(), "inside send_offline_packet"),
    Topic = <<"ekaf_shopo_offline_chats">>,

    Body = xml:get_path_s(Packet, [{elem, <<"body">>}, cdata]),
    Version = binary_to_list(xml:get_path_s(Packet, [{elem, <<"version">>}, cdata])),

    ParsedBody = jiffy:decode(Body, [return_maps]),
    ChatType = check_and_convert_binary(maps:get(<<"chat_type">>, ParsedBody), int),
    lager:log(info, self(), ChatType),

    % exclude this to make sure that producer and consumer arnt stuck in an infinite loop
    % ChatType =:= 11 ->
    % ok;

    case Version =:= "" of
        true ->
            lager:log(info, self(), "***** canned message is incompatible with very old app versions ");

        false ->
            % send only if messgae is simple chat or product share
            VersionNumber =  binary_to_integer(xml:get_path_s(Packet, [{elem, <<"version">>}, cdata])),

            case VersionNumber >= 7 of
                true ->
                    case ChatType =:= 1 orelse ChatType =:= 6 of
                        true ->
                            EkafJsonBody = generate_body_string(ParsedBody, Body),
                            lager:log(info, self(), "----------------------------------------"),
                            lager:log(info, self(), EkafJsonBody),
                            lager:log(info, self(), "----------------------------------------"),
                            ekaf:produce_async(Topic, EkafJsonBody);

                        false ->
                            lager:log(info, self(), lists:concat(["***** canned message is incompatible with chat type ",ChatType]))

                    end;

                false ->
                    lager:log(info, self(), lists:concat(["***** canned message is incompatible with version ",VersionNumber]))
            end
    end.


%% generate json string for actual message body
generate_body_string(ParsedBody, Body) -> 
    lager:log(info, self(), "inside generate_body_string"),
    Type = 0,
    MessageId = maps:get(<<"message_id">>, ParsedBody),
    % {ok, Time, Status} = mod_last:get_last_info(TargetId,<<"localhost">>),
    Time = get_current_timestamp(),
    lager:log(info, self(), "***** Time ********"),
    lager:log(info, self(), Time),
    encode_string(MessageId, Body, Type , Time).

% Get current time stamp in seconds since (00:00:00 GMT, January 1, 1970)
get_current_timestamp() ->
    % {Mega, Sec, Micro} = os:timestamp(),
    {Mega, Secs, _} = now(),
    Mega*1000000 + Secs.

%% Encode string to json
encode_string(MessageId, Body, Type , MessageTime) -> 
    lager:log(info, self(), "inside encode_string"),
    EkafString = {[{message_id, MessageId}, {body, Body}, {type, Type} , {message_time,MessageTime}]},
    jiffy:encode([EkafString], [uescape]).


update_table() ->
    Fields = record_info(fields, canned_activity),
    case mnesia:table_info(canned_activity, attributes) of
        Fields ->
            ejabberd_config:convert_table_to_binary(
                canned_activity, Fields, set,
                fun(#canned_activity{us = {FU, _}}) -> FU end,
                fun(#canned_activity{us = {FU, TU, S}, message_id = MessageId} = R) ->
                        R#canned_activity{us = {iolist_to_binary(FU),
                                iolist_to_binary(TU),iolist_to_binary(S)},
                            message_id = iolist_to_binary(MessageId)}
                end);
        _ ->
            lager:log(info, self(), "Recreating canned_activity table", []),
            mnesia:transform_table(canned_activity, ignore, Fields)
    end.


get_last_canned(FUser, TUser, LServer) ->
    get_last_canned(FUser, TUser, LServer,
        gen_mod:db_type(LServer, ?MODULE)).

get_last_canned(FUser, TUser, LServer, mnesia) ->
    case catch mnesia:dirty_read(canned_activity,
            {FUser, TUser, LServer})
        of
        {'EXIT', Reason} -> {error, Reason};
        [] -> not_found;
        [#canned_activity{timestamp = TimeStamp,
                message_id = MessageId}] ->
            {ok, TimeStamp, MessageId}
    end;
get_last_canned(FUser, TUser, LServer, riak) ->
    case ejabberd_riak:get(canned_activity, canned_activity_schema(),
            {FUser, TUser, LServer}) of
        {ok, #canned_activity{timestamp = TimeStamp,
                message_id = MessageId}} ->
            {ok, TimeStamp, MessageId};
        {error, notfound} ->
            not_found;
        Err ->
            Err
    end.


store_canned_info(FUser,TUser, Server, TimeStamp, MessageId) ->
    FromUser = jlib:nodeprep(FUser),
    ToUser = jlib:nodeprep(TUser),
    LServer = jlib:nameprep(Server),
    DBType = gen_mod:db_type(LServer, ?MODULE),
    store_canned_info(FromUser, ToUser, LServer, TimeStamp, Status,
        DBType).

store_canned_info(FUser,TUser, Server, TimeStamp, MessageId,
    mnesia) ->
    US = {FUser, TUser, LServer},
    F = fun () ->
            mnesia:write(#canned_activity{us = US,
                    timestamp = TimeStamp,
                    message_id = MessageId})
    end,
    mnesia:transaction(F);
store_canned_info(FUser,TUser, Server, TimeStamp, MessageId,
    riak) ->
    US = {FUser, TUser, LServer},
    {atomic, ejabberd_riak:put(#canned_activity{us = US,
                timestamp = TimeStamp,
                message_id = MessageId},
            canned_activity_schema())}.

canned_activity_schema() ->
    {record_info(fields, canned_activity), #canned_activity{}}.
