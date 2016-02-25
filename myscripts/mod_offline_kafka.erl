% variables : time diff for canned call(60) , shopo user TUser(4) , chaT_TYPE ( 1,6 ) , VEersion number(7+)
-module(mod_offline_kafka).
-author('nikunjbhartia0@gmail.com').

-export([start/2, stop/1, init/2, process_and_send_offline_packet_to_kafka/3, 
        get_current_timestamp/0]).

-export([get_last_canned/3,store_canned_info/5,remove_user/2]).

-import(mod_last, ([get_last_info/2])).

-behaviour(gen_mod).

-define(PROCNAME, ?MODULE).

-include("ejabberd.hrl").
-include("jlib.hrl").
-include("logger.hrl").
-include("lager.hrl").

-shopoUser(4).
-timeDiffTwoCanned(60).
-timeDiffLastInfo(60).
-minVersion(7).
-allowed_chat_types([1,6]).

-record(canned_activity, {us = {<<"">>, <<"">>, <<"">>} :: {binary(), binary(), binary()},
        timestamp = 0 :: non_neg_integer(),
        message_id = <<"">> :: binary()}).


-record(canned_variables, 
              {shopo_user = 4 :: non_neg_integer(),
               time_diff_last_info = 3600 :: non_neg_integer(),
               time_diff_two_canned = 3600 :: non_neg_integer(),
               min_version = 7 :: non_neg_integer(),
               allowed_chat_types}).

start(Host, Opts) ->
    % lager:trace_file("/Applications/ejabberd-15.04/logs/custom_modules.log", [{module, mod_offline_kafka}], info),
    lager:log(info, self(), "****** STARTING OFFLINE KAFKA MODULE ********"),
    
    ModuleAttr = get_module_attributes(),
    #canned_variables{shopo_user = ShopoUser1,
                       time_diff_last_info = TimeDiffLastInfo1,
                       time_diff_two_canned = TimeDiffTwoCanned1,
                       min_version = MinVersion1,
                       allowed_chat_types = AllowedChatTypes1} = ModuleAttr,

    lager:log(info, self(), lists:concat([" ShopoUser ",ShopoUser1," time1 ",TimeDiffLastInfo1," time2 ",TimeDiffTwoCanned1," versionn ",MinVersion1])),


    register(?PROCNAME,spawn(?MODULE, init, [Host, Opts])),
    case gen_mod:db_type(Host, Opts) of
        mnesia ->
            lager:log(info, self(), "-- creating canned_activity table --"),
            mnesia:create_table(canned_activity,
                [{disc_copies, [node()]},
                    {attributes,
                        record_info(fields, canned_activity)}]);
            % update_table();
        _ -> 
           lager:log(info, self(), "-- canned_activity table not created , gen_mod:db_type isnt mnesia !! --"),
           ok
    end.
     % taken from ejabberd.yml file's module section
    % ShopoUser = gen_mod:get_opt(shopo_user, Opts, fun(A) -> A end),
    % TimeDiffLastInfo = gen_mod:get_opt(time_diff_last_info, Opts, fun(A) -> A end),
    % TimeDiffTwoCanned = gen_mod:get_opt(time_diff_two_canned, Opts, fun(A) -> A end),
    % MinVersion = gen_mod:get_opt(min_version, Opts, fun(A) -> A end),
    % {ok,
    %     #canned_variables{host = Host,
    %         shopoUser = ShopoUser,
    %         time_diff_last_info = TimeDiffLastInfo,
    %         time_diff_two_canned = TimeDiffTwoCanned,
    %         min_version = MinVersion}}.

init(Host, _Opts) ->
    lager:log(info, self(), "****** INITIALIZING OFFLINE KAFKA MODULE ********"),
    X = ejabberd_hooks:add(offline_message_hook, Host, ?MODULE, process_and_send_offline_packet_to_kafka, 10),
    Y = ejabberd_hooks:add(remove_user, Host, ?MODULE,remove_user, 50),    
    lager:log(info, self(), [X,Y]),
    ok.

stop(Host) ->
    lager:log(info, self(), "****** STOPPING OFFLINE KAFKA MODULE ********"),
    ejabberd_hooks:delete(offline_message_hook, Host, ?MODULE, send_notice, 10),
    ejabberd_hooks:delete(remove_user, Host, ?MODULE,remove_user, 50),
    ok.

process_and_send_offline_packet_to_kafka(From, To, Packet) ->
    lager:log(info, self(), "--- inside send_offline_packet_to_kafka ---"),
    lager:log(info, self(), lists:concat(["Processing packet from :",binary_to_list(From#jid.luser),"  to : ",binary_to_list(To#jid.luser)])),
    % lager:log(info,self(),lists:concat(["Packet : ",binary_to_list(Packet)])),
    
    FUser = From#jid.luser,
    TUser = To#jid.luser,
    LServer = To#jid.lserver,
    CurTimeStamp = get_current_timestamp(),
    Body = xml:get_path_s(Packet, [{elem, <<"body">>}, cdata]),
    ParsedBody = jiffy:decode(Body, [return_maps]),
    MessageId = maps:get(<<"message_id">>, ParsedBody),
    LastInfo = mod_last:get_last_info(TUser,LServer),

    case LastInfo of 
       {error, Reason} -> 
         lager:log(info, self(), lists:concat(["Error occured while reading last user info of ",binary_to_list(TUser)," ",Reason])),
         TLastTimestamp = CurTimeStamp; %To make sure 1hour condition don't satisfy
       
       not_found -> 
         lager:log(info, self(), lists:concat(["Last seen info not found for user ",binary_to_list(TUser)])),
         TLastTimestamp = 0; %To make sure 1hour condition satisfies
       
       {ok, TimeStamp, _Status} ->
          TLastTimestamp = TimeStamp
    end,

    TimeDiff = CurTimeStamp - TLastTimestamp,

    ModuleAttr = get_module_attributes,
    #canned_variables{shopo_user = ShopoUser1,
                       time_diff_last_info = TimeDiffLastInfo1,
                       time_diff_two_canned = TimeDiffTwoCanned1,
                       min_version = MinVersion1,
                       allowed_chat_types = AllowedChatTypes1} = ModuleAttr,

    lager:log(info, self(), lists:concat([" ShopoUser ",ShopoUser1," time1 ",TimeDiffLastInfo1," time2 ",TimeDiffTwoCanned1," versionn ",MinVersion1])),

    case binary_to_integer(TUser) /= ShopoUser1 andalso binary_to_integer(FUser) /= ShopoUser1 andalso TimeDiff > TimeDiffLastInfo1 of
        true ->        
            case get_last_canned(FUser, TUser, LServer) of
                {error, _Reason} -> 
                    lager:log(info, self(), lists:concat(["Error occured while reading canned_activity table : "]));
               
                not_found ->
                    lager:log(info, self(), "No entry found in canned_activity table, storing new record !"),
                    lager:log(info, self(), lists:concat(["New Record -> from : ",binary_to_list(From#jid.luser),"  to : ",binary_to_list(To#jid.luser)," Timestamp : ",check_and_convert_binary(CurTimeStamp,int), " MessageId : ",binary_to_list(MessageId)])),
                    store_canned_info(FUser, TUser, LServer, CurTimeStamp, MessageId),
                    send_offline_packet(From, To, Packet, MinVersion1 , AllowedChatTypes1);
               
                {ok, TimeStamp2, OldMsgId} ->
                    case ((CurTimeStamp - TimeStamp2) >= timeDiffTwoCanned andalso (binary_to_list(OldMsgId) /= binary_to_list(MessageId))) of
                        true ->
                          lager:log(info, self(), "Entry found in canned_activity table, updating new record !"),
                          lager:log(info, self(), lists:concat(["Old Record -> from : ",binary_to_list(From#jid.luser),"  to : ",binary_to_list(To#jid.luser)," Timestamp : ",check_and_convert_binary(TimeStamp2,int), " MessageId : ",binary_to_list(OldMsgId)])),
                          lager:log(info, self(), lists:concat(["New Record > from : ",binary_to_list(From#jid.luser),"  to : ",binary_to_list(To#jid.luser)," Timestamp : ",check_and_convert_binary(CurTimeStamp,int), " MessageId : ",binary_to_list(MessageId)])),
                
                          store_canned_info(FUser, TUser, LServer, CurTimeStamp, MessageId),
                          send_offline_packet(From, To, Packet , MinVersion1 , AllowedChatTypes1);
                        false ->
                          lager:log(info,self(), "One of canned conditions not satisfied :"),
                          lager:log(info, self(), lists:concat(["Time Difference between two canned :",CurTimeStamp - TimeStamp2," (Should be more than ",TimeDiffTwoCanned1," )"])),
                          lager:log(info, self(), lists:concat(["Old MessageId : ",binary_to_list(OldMsgId)," New MessageId : ",binary_to_list(MessageId), " (Shouldn't be same)"]))
                    end;
                _ ->
                    lager:log(info,self(), "Offline canned messagee not sent, unknown reason")
            end;
        false ->
            lager:log(info,self(),lists:concat([binary_to_list(FUser)," -> ",binary_to_list(TUser)," Time Diff : ",TimeDiff," (Should be > ",timeDiffLastInfo," ) => Offline Canned Activity not allowed : Either user is shopo user, or Last Seen of TUser is not in required range."]))
    end.
    
    


check_and_convert_binary(Data, int) ->
    try 
        binary_to_integer(Data)
    catch
        _:_ -> Data
    end.

send_offline_packet(_From, _To, Packet = {xmlel, <<"message">>, _Attrs, _Els} , MinVersion1 , AllowedChatTypes1) ->
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

            case VersionNumber >= MinVersion1 of
                true ->
                    case lists:member(ChatType,AllowedChatTypes1) of
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
    store_canned_info(FromUser, ToUser, LServer, TimeStamp, MessageId,
        DBType).

store_canned_info(FUser,TUser, Server, TimeStamp, MessageId,
    mnesia) ->
    US = {FUser, TUser, Server},
    F = fun () ->
            mnesia:write(#canned_activity{us = US,
                    timestamp = TimeStamp,
                    message_id = MessageId})
    end,
    mnesia:transaction(F);
store_canned_info(FUser,TUser, Server, TimeStamp, MessageId,
    riak) ->
    US = {FUser, TUser, Server},
    {atomic, ejabberd_riak:put(#canned_activity{us = US,
                timestamp = TimeStamp,
                message_id = MessageId},
            canned_activity_schema())}.


remove_user(User, Server) ->
    LUser = jlib:nodeprep(User),
    LServer = jlib:nameprep(Server),
    DBType = gen_mod:db_type(LServer, ?MODULE),
    remove_user(LUser, LServer, DBType).

remove_user(LUser, LServer, mnesia) ->    
    Pat1 = {canned_activity,{LUser,'_',LServer},_ = '_',_ = '_'},
    Pat2 = {canned_activity,{'_',LUser,LServer},_ = '_',_ = '_'},
    A = mnesia:dirty_match_object(canned_activity,Pat1),
    B = mnesia:dirty_match_object(canned_activity,Pat2),
    F = fun () -> 
          lists:map(fun(K) -> mnesia:delete_object(K) end, A),
          lists:map(fun(K) -> mnesia:delete_object(K) end, B)
        end,
    mnesia:transaction(F).


canned_activity_schema() ->
    {record_info(fields, canned_activity), #canned_activity{}}.


send_notice(_From, _To , _Packet) ->
    lager:log(info, self(), "Goodbye mod_offline_kafka.").


    % get_module_attributes() ->
    %      Att = mod_offline_kafka:module_info(attributes),
    %      {_,ShopoUser} = lists:keyfind(shopoUser,1,Att),
    %      {_,TimeDiffTwoCanned} = lists:keyfind(timeDiffTwoCanned,1,Att),
    %      {_,TimeDiffLastInfo} = lists:keyfind(timeDiffLastInfo,1,Att),
    %      {_,AllowedChatTypes} = lists:keyfind(allowed_chat_types,1,Att),
    %      {_,MinVersion} = lists:keyfind(min_version,1,Att),
    %      #canned_variables{shopo_user = ShopoUser,
    %                        time_diff_last_info = TimeDiffLastInfo,
    %                        time_diff_two_canned = TimeDiffTwoCanned,
    %                        min_version = MinVersion,
    %                        allowed_chat_types = AllowedChatTypes}.
