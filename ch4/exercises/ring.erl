% Exercise 4-2
% The Process Ring
% Write a program that will create N processes connected in a ring, as shown in Figure 4-17.
% Once started, these processes will send M number of messages around the ring and then terminate gracefully when they receive a quit message.
% You can start the ring with the call ring:start(M, N, Message).
% There are two basic strategies to tackling this exercise.
% The first one is to have a central process that sets up the ring and initiates sending the message.
% The second strategy consists of the new process spawning the next process in the ring.
% With this strategy, you have to find a method to connect the first process to the second process.

-module(ring).
-export([start/3]).
-export([init_process/1]).

start(M, N, Message) ->
  io:format("Central Process pid: ~w\n", [self()]),
  { ok, NextPid } = spawn_processes(N),
  ok = send_to_ring(Message, M, NextPid),
  ok = send_to_ring(stop, 1, NextPid),
  ok.

spawn_processes(N) ->
  spawn_processes(N, self()).
      
spawn_processes(1, NextOnTheRing) ->
  { ok, NextOnTheRing };
            
spawn_processes(N, NextOnTheRing) ->
  Pid = spawn(ring, init_process, [NextOnTheRing]),
  spawn_processes(N - 1, Pid).
  
init_process(NextOnTheRing) ->
  loop(NextOnTheRing).

loop(NextOnTheRing) ->
  receive
    { stop, From } ->
      io:format("~w received stop from ~w\n", [self(), From]),
      NextOnTheRing ! { stop, self() },
      ok;
    { Msg, From } ->
      io:format("~w received ~w from ~w\n", [self(), Msg, From]),
      NextOnTheRing ! { Msg, self() },
      loop(NextOnTheRing)
  end.
  
send_to_ring(Msg, Times, NextPid) ->
  NextPid ! { Msg, self() },
  ok = receive_from_last_node(Msg),
  case Times > 1 of
    true ->
      send_to_ring(Msg, Times - 1, NextPid);
    false ->
      ok
  end.
  
receive_from_last_node(Msg) ->
  receive
      { Msg, From } ->
      io:format("~w received ~w from ~w\n", [self(), Msg, From]),
      ok
  end.