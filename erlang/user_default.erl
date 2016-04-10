-module(user_default).
-export([at/2]).
-export([rlinks/1, plinks/1]).
-export([chelp/0]).


%% === HELP FOR CUSTOM FUNCTIONS =======================================
%% =====================================================================

%% TODO
%% find so that chelp/0 returns info on available custom function without
%% editing it directly (how to parse the source file?...)

%% erlang shell's help/0 is just a heap of io:format lines. It is most
%%+ definitely faster than this but at least I learned some new BIFs.
chelp() ->
    CustomList = [{"at({_M, F, _A}, N)", "average of timer:tc/{1,2,3} called N times"},
                  {"rlinks(ProcList)", "wrapper for process_info(Pid,links), ProcList = [pid or alias|T]"},
                  {"plinks(ProcList)", "pretty printed rlink(L)"}],
    Max = lists:max([length(FirstCol) || {FirstCol,_} <- CustomList]),
    lists:foreach(fun({Def,Short}) -> io:format("~s - ~s~n",[string:left(Def,Max),Short]) end, CustomList).


%% === AVERAGE TIMER ===================================================
%% =====================================================================
%% Original average timer found here:
%% https://erlangcentral.org/wiki/index.php/Measuring_Function_Execution_Time
at(Tuple, N) when N > 0 ->
    L = loop(Tuple, N, []),
    Length = length(L),
    Min = lists:min(L),
    Max = lists:max(L),
    % simplified median calculation as N is usually above 1000 therefore the
    %+ the differences will be relatively small
    %+ Median = even_list(mean of middle 2 values) || odd_list(value in the middle)
    Med = lists:nth(round(Length / 2), lists:sort(L)),
    Avg = round(lists:foldl(fun(X, Sum) -> X + Sum end, 0, L) / Length),
    io:format("Range: ~b - ~b mics~n"
        "Median: ~b mics~n"
        "Average: ~b mics~n",
        [Min, Max, Med, Avg]),
    Med.

loop(_, 0, List) -> List;
loop(Tuple, N, List) ->
    {Time, _Result} = case Tuple of
                          {F}     -> timer:tc(F);
                          {F,A}   -> timer:tc(F,A);
                          {M,F,A} -> timer:tc(M,F,A)
                      end,
    loop(Tuple, N - 1, [Time|List]).

%% === MASS LINK CHECKER ===============================================
%% =====================================================================
%% raw links
rlinks(L) -> lists:reverse(check_links(L,[])).
%% pretty printed links
plinks(L) ->
    RawLinks = rlinks(L),
    Max = lists:max([length(atom_to_list(RegName)) || {_,RegName,_} <- RawLinks]),
    print_links(RawLinks,Max).

check_links([],Acc) -> Acc;
check_links([H|T],Acc) ->
    % Pid = (1) PID of live process           = PID
    %       (2) PID of dead process           = PID
    %       (3) whereis(atom of live process) = PID
    %       (4) whereis(atom of dead process) = undefined
    Pid = if is_pid(H) -> H;
             is_atom(H)-> whereis(H)
          end,
    % process_info( (1), links) = {links, ProcList}
    % process_info( (2), links) = undefined
    % process_info( (3), links) = {links, ProcList}
    % process_info( (4), links) = {ERROR, badarg}
    try process_info(Pid, links) of
        {links,L} ->
            NamedProcList = lists:map(fun regName/1,L),
            check_links(T,[{Pid,regName(Pid,''),NamedProcList}|Acc]);
        undefined ->
            check_links(T,[{Pid, defunct, []}|Acc])
    catch
        error:badarg -> check_links(T,[{H, defunct, []}|Acc])
    end.

%% Generic function to map processes to aliases
regName(Pid,Default) ->
    case process_info(Pid, registered_name) of
        {registered_name, R} -> R;
        []                   -> Default
    end.
%% regName/1 for mapping process names
%%+ if registered -> alias
%%+    no alias   -> pid
regName(Pid) when is_pid(Pid) ->
    regName(Pid,Pid);
%% If a socket is opened on the shell then the a given
%% pid links to other pids and PORTs. Not to mention
%% other possibilities I have no clue yet.
regName(Other) ->
    Other.

% print raw result collected with check_links/2
print_links([],_) -> ok;
print_links([{Pid,defunct,_}|T], Max) ->
    io:format("~w ~w~n",[Pid,defunct]),
    print_links(T, Max);
print_links([{Pid,RegName,ProcList}|T], Max) ->
    io:format("~12w   ~s   links to ~w~n",[Pid, string:left(atom_to_list(RegName),Max), ProcList]),
    print_links(T,Max).
