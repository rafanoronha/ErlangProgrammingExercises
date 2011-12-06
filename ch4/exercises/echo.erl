% Exercise 4-1
% An Echo Server
% Write the server in Figure 4-16 that will wait in a receive loop until a message is sent to it.
% Depending on the message, it should either print its contents and loop again, or terminate.
% You want to hide the fact that you are dealing with a process, and access its services through a functional interface, which you can call from the shell.
% This functional interface, exported in the echo.erl module, will spawn the process and send messages to it. The function interfaces are shown here:
% echo:start() => ok
% echo:print(Term) => ok
% echo:stop => ok

-module(echo).
-export([start/0, print/1, stop/0]).
-export([loop/0]).

start() ->
  register(echo, spawn(echo, loop, [])),
  ok.

print(Msg) ->
  echo ! { echo, Msg },
  ok.
  
stop() ->
  echo ! stop,
  ok.

loop() ->
  receive
    {echo, Msg} ->
      io:format("~w~n",[Msg]),
      loop();
    stop ->
      true
  end.