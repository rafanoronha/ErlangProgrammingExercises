% Example 4-1
% An Echo Example
% Now that we have covered process creation and message passing, let’s use spawn, send, and receive, in a small program.
% Open your editor and copy the contents of Example 4-1 or download it from the book’s website.
% When doing so, do not forget to export the function you are spawning, in this case loop/0.
% In the example, pay particular notice to the fact that two different processes will be executing and interacting with each other using code defined in the same module.
-module(echo).
-export([go/0, loop/0]).

go() ->
   Pid = spawn(echo, loop, []),
   Pid ! {self(), hello},
   receive
     {Pid, Msg} ->
       io:format("~w~n",[Msg])
   end,
   Pid ! stop.


loop() ->
   receive
     {From, Msg} ->
        From ! {self(), Msg},
        loop();
     stop ->
       true
   end.