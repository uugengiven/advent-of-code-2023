-module(brute).
-export([start/0]).

getWinners(Time, Distance) ->
    % Iterate from 0 to Time until Iterator * (Time - Iterator) > Distance
    % Then return (Time - (Iterator * 2)) + 1
    getWinnersHelper(Time, Distance, 0).

getWinnersHelper(Time, Distance, Iterator) ->
    if
        Iterator * (Time - Iterator) > Distance ->
            io:fwrite("Time is ~p~n", [Time]),
            io:fwrite("Distance is ~p~n", [Distance]),
            io:fwrite("Iterator is ~p~n", [Iterator]),
            (Time - (Iterator * 2)) + 1;
        true ->
            getWinnersHelper(Time, Distance, Iterator + 1)
    end.

start() ->
    % One = getWinners(46, 347),
    % Two = getWinners(82, 1522),
    % Three = getWinners(84, 1406),
    % Four = getWinners(79, 1471),
    % Product = One * Two * Three * Four,
    % io:fwrite("One is ~p~n", [One]),
    % io:fwrite("Two is ~p~n", [Two]),
    % io:fwrite("Three is ~p~n", [Three]),
    % io:fwrite("Four is ~p~n", [Four]),
    % io:fwrite("Product is ~p~n", [Product]).
    One = getWinners(46828479, 347152214061471),
    io:fwrite("One is ~p~n", [One]).