% Exercise 5-1: A Database Server
% Write a database server that stores a database in its loop data.
% You should register the server and access its services through a functional interface.

% Exported functions in the my_db.erl module should include:
% my_db:start() ⇒ ok.
% my_db:stop() ⇒ ok.
% my_db:write(Key, Element) ⇒ ok.
% my_db:delete(Key) ⇒ ok.
% my_db:read(Key) ⇒ {ok, Element} | {error, instance}.
% my_db:match(Element) ⇒ [Key1, ..., KeyN].

% Hint: use the db.erl module as a backend and use the server skeleton from the echo server from Exercise 4-1 in Chapter 4.

% Example:
% 1> my_db:start().
% ok
% 2> my_db:write(foo, bar).
% ok
% 3> my_db:read(baz).
% {error, instance}
% 4> my_db:read(foo).
% {ok, bar}
% 5> my_db:match(bar).
% [foo]

-module(my_db).
-export([start/0, stop/0, write/2, delete/1, read/1, match/1]).
-export([init/0, loop/1]).

start() ->
  register(my_db, spawn(my_db, init, [])),
  ok.  
  
stop() ->
  call(stop).

write(K,V) ->
  call({write, K, V}).
  
delete(K) ->
  call({delete, K}).
  
read(K) ->
  call({read, K}).
  
match(V) ->
  call({match, V}).
  
init() ->
  io:format("Database server started with pid ~w\n", [self()]),
  loop(db:new()).

loop(Db) ->
  receive
    {Msg, From} ->
      {Reply, UpdatedDb} = case Msg of
        {write, K, V} ->
          {ok, db:write(K, V, Db)};
        {read, K} ->
          {db:read(K, Db), Db};
        {delete, K} ->
          NewDb = db:delete(K, Db),
          {ok, NewDb};
        {match, V} ->
          {db:match(V, Db), Db};
        stop ->
          {ok, stop}
      end,
      From ! {reply, Reply}
  end,
  case UpdatedDb of
    stop ->
      io:format("Database server loop will end now\n", []);
    _Database ->
      loop(UpdatedDb)
  end.

call(Msg) ->
  my_db ! {Msg, self()},
  receive
    {reply, Reply} ->
    Reply
  end.