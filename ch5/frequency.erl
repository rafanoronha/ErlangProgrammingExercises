% Exercise 5-2: Changing the Frequency Server
% Using the frequency server example in this chapter,
% change the code to ensure that only the client who allocated a frequency is allowed to deallocate it.
% Make sure that deallocating a frequency that has not been allocated does not make the server crash.

% Hint: use the self() BIF in the allocate and deallocate functions called by the client.
% Extend the frequency server so that it can be stopped only if no frequencies are allocated.

% Finally, test your changes to see whether they still allow individual clients
% to allocate more than one frequency at a time.
% This was previously possible by calling allocate_frequency/0 more than once.
% Limit the number of frequencies a client can allocate to three.

-module(frequency).
-export([start/0, stop/0, allocate/0, deallocate/1]).
-export([init/0]).

%% These are the start functions used to create and
%% initialize the server.

start() ->
  register(frequency, spawn(frequency, init, [])).

init() ->
  Frequencies = {get_frequencies(), []},
  loop(Frequencies).

% Hard Coded
get_frequencies() -> [10,11,12,13,14,15].

%%  The client Functions

stop()           -> call(stop).
allocate()       -> call(allocate).
deallocate(Freq) -> call({deallocate, Freq}).

%% We hide all message passing and the message
%% protocol in a functional interface.

call(Message) ->
  frequency ! {request, self(), Message},
  receive
    {reply, Reply} -> Reply
  end.

%% The Main Loop

loop(Frequencies) ->
  receive
    {request, Pid, allocate} ->
      {NewFrequencies, Reply} = allocate(Frequencies, Pid),
      reply(Pid, Reply),
      loop(NewFrequencies);
    {request, Pid , {deallocate, Freq}} ->
      {Result, NewFrequencies} = deallocate(Frequencies, Freq, Pid),
      reply(Pid, Result),
      loop(NewFrequencies);
    {request, Pid, stop} ->
      Ok = case Frequencies of
        {_Free, []} -> true;
        _Other -> false
      end,
      case Ok of
        true ->
          reply(Pid, ok);
        _False ->
          reply(Pid, {error, has_open_frequencies}),
          loop(Frequencies)
      end
  end.

reply(Pid, Reply) ->
  Pid ! {reply, Reply}.

%% The Internal Help Functions used to allocate and
%% deallocate frequencies.

allocate({[], Allocated}, _Pid) ->
  {{[], Allocated}, {error, no_frequency}};
allocate({[Freq|Free], Allocated}, Pid) ->
  {{Free, [{Freq, Pid}|Allocated]}, {ok, Freq}}.

deallocate({Free, Allocated}, Freq, Pid) ->
  RequestedFrequency = lists:keyfind(Freq, 1, Allocated),
  Response = case RequestedFrequency of
    false -> {{error, no_frequency}, {Free, Allocated}};
    {Freq, Pid} -> {ok, {[Freq|Free],  lists:keydelete(Freq, 1, Allocated)}}; 
    {Freq, _Pid} -> {{error, forbidden}, {Free, Allocated}}
  end,
  Response.
