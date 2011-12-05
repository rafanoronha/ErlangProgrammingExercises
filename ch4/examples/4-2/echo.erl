% Example 4-2
% Look at Example 4-2, which is a variant of Example 4-1.
% We have removed the Pid!stop expression at the end of the go/0 function,
% and instead of binding the return value of spawn/3, we pass it as the second argument to the register BIF.
% The first argument to register is echo, the atom we use to name the process.
% This alias is used to send the message to the newly spawned child.
-module(echo).
-export([go/0, loop/0]).

go() ->
  register(echo, spawn(echo, loop, [])),
  echo ! {self(), hello},
  receive
    {_Pid, Msg} ->
      io:format("~w~n",[Msg])
  end.


loop() ->
  receive
    {From, Msg} ->
      From ! {self(), Msg},
      loop();
    stop ->
      true
  end.