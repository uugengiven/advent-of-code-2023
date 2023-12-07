-module(program).
-import(string,[concat/2]).
-export([start/0]).

doLines(File, Accum) -> 
    case file:read_line(File) of
        eof ->
            io:fwrite("End of file~n"),
            Accum;
        {ok, Line} ->
            % io:fwrite("Line is ~p~n", [Line]),
            StrAccum = string:concat(Accum, Line),
            % io:fwrite("Accum is ~p~n", [StrAccum]),
            doLines(File, StrAccum)
    end.

openFile() ->
    {ok, File} = file:open("input.txt", [read]),
    Accum = doLines(File, ""),
    file:close(File),
    Accum.

cleanLine(Line) ->
    lists:sublist(string:tokens(Line, "\n"), 2, 1000000).

createArrays(Line) ->
    lists:map(fun(X) -> {makeNumbers(X)} end, Line).

makeNumbers(Line) ->
    lists:map(stringToNumber, string:tokens(Line, " ")).

stringToNumber(Line) ->
    {I1, []} = string:to_integer(Line),
    I1.

start() ->
    FullFile = openFile(),
    FixedFile = re:replace(FullFile, "\n\n", "^", [global, {return, list}]),
    Sections = string:tokens(FixedFile, "^"),
    io:fwrite("Sections are ~p~n", [Sections]),
    SeedLine = string:tokens(lists:nth(1,Sections), ":"),
    Seeds = string:tokens(lists:nth(2,SeedLine), " "),
    S2S = createArrays(cleanLine(lists:nth(2,Sections))),
    S2F = cleanLine(lists:nth(3,Sections)),
    F2W = cleanLine(lists:nth(4,Sections)),
    W2L = cleanLine(lists:nth(5,Sections)),
    L2T = cleanLine(lists:nth(6,Sections)),
    T2H = cleanLine(lists:nth(7,Sections)),
    H2L = cleanLine(lists:nth(8,Sections)),
    io:fwrite("Seeds are ~p~n", [Seeds]),
    io:fwrite("S2S is ~p~n", [S2S]),
    io:fwrite("S2F is ~p~n", [S2F]),
    io:fwrite("F2W is ~p~n", [F2W]),
    io:fwrite("W2L is ~p~n", [W2L]),
    io:fwrite("L2T is ~p~n", [L2T]),
    io:fwrite("T2H is ~p~n", [T2H]),
    io:fwrite("H2L is ~p~n", [H2L]).

% time to make the state machine again
% first split on double new line
% states: seeds, s2s, s2f, f2w, w2l, l2t, t2h, h2l
% seeds - single line, build base list of seeds
% each state builds a map of that state
% split on single new line, dump first row, split on space, do map building