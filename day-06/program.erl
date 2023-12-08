-module(program).
-import(string,[concat/2]).
-export([start/0]).

% This doesn't actually work, I was working on a way to use powers of two to deal with even ones
% but got tired of doing the math in my head and just decided to brute force it
% check out brute.erl for the brute force solution

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

createArrays(Line) ->
    lists:map(fun(X) -> makeNumbers(lists:nth(2,string:tokens(X, ":"))) end, Line).

makeNumbers(Line) ->
    lists:map(fun(Y) -> stringToNumber(Y) end, string:tokens(Line, " ")).
    % funny and confusing thing - with the input I had, when the two arrays came back
    % one was showing as a string ".MTO" or some such, which was just the ascii
    % values, as erlang doesn't really differentiate between arrays of ints and strings

stringToNumber(Value) ->
    {I1, []} = string:to_integer(Value),
    I1.

getWinners(Time, Distance) ->
    % Half equals Time / 2 truncated
    % if Time is even, Furthest = Half * Half
    % if Time is odd, Furthest = Half * (Half + 1)
    % Difference = Furthest - Distance
    % if Time is even, Winner = (sqrt(Difference) - 1) * 2 + 1
    % if Time is odd, Winner = sqrt(Difference) * 2
    Half = trunc(Time / 2),
    if
        Time rem 2 == 0 ->
            Furthest = Half * Half;
        Time rem 2 == 1 ->
            Furthest = Half * (Half + 1)
    end,
    Difference = Furthest - Distance,
    io:fwrite("Time is ~p~n", [Time]),
    io:fwrite("Distance is ~p~n", [Distance]),
    io:fwrite("Half is ~p~n", [Half]),
    io:fwrite("Furthest is ~p~n", [Furthest]),
    io:fwrite("Difference is ~p~n", [Difference]),
    case isPowerTwo(Difference) of
        true -> EvenMath = sigBit(Difference) - 1;
        false -> EvenMath = sigBit(Difference)
    end,
    if
        Time rem 2 == 0 ->
            Winner = (trunc(math:sqrt(Difference)) - 1) * 2 + 1;
        Time rem 2 == 1 ->
            Winner = EvenMath * 2
    end,
    Winner.

sigBit(Number) ->
    case Number of
        0 -> 0;
        _ -> moveBit(Number, 1)
    end.

moveBit(Number, Accum) ->
    case Number bsr 1 of
        0 -> Accum;
        _ -> moveBit(Number bsr 1, Accum + 1)
    end.

isPowerTwo(Number) ->
    case Number of
        0 -> false;
        1 -> true;
        _ -> isPowerTwo(Number bsr 1)
    end.

start() ->
    % Inputs = string:tokens(openFile(), "\n"),
    % io:fwrite("Inputs are ~p~n", [Inputs]),
    % InputArrays = createArrays(Inputs),
    % io:fwrite("InputArrays are ~p~n", [InputArrays]).
    One = getWinners(46, 347),
    Two = getWinners(82, 1522),
    Three = getWinners(84, 1406),
    Four = getWinners(79, 1471),
    Product = One * Two * Three * Four,
    io:fwrite("One is ~p~n", [One]),
    io:fwrite("Two is ~p~n", [Two]),
    io:fwrite("Three is ~p~n", [Three]),
    io:fwrite("Four is ~p~n", [Four]),
    io:fwrite("Product is ~p~n", [Product]).
