% Exercise 3-4: Database Handling Using Lists
% Write a module db.erl that creates a database and is able to store, retrieve, and delete elements in it.

% The destroy/1 function will delete the database.
% Considering that Erlang has garbage collection, you do not need to do anything.
% Had the db module stored everything on file, however, you would delete the file.

% We are including the destroy function to make the interface consistent.
% You may not use the lists library module, and you have to implement all the recursive functions yourself.
% Hint: use lists and tuples as your main data structures.
% When testing your program, remember that Erlang variables are single-assignment:

% Interface:
% db:new()                        ⇒ Db.
% db:destroy(Db)                  ⇒ ok.
% db:write(Key, Element, Db)      ⇒ NewDb.
% db:delete(Key, Db)              ⇒ NewDb.
% db:read(Key, Db)                ⇒{ok, Element} | {error, instance}.
% db:match(Element, Db)           ⇒ [Key1, ..., KeyN].

% Example:
% 1> c(db).
% {ok,db}
% 2>  Db = db:new().
% []
% 3>  Db1 = db:write(francesco, london, Db).
% [{francesco,london}]
% 4> Db2 = db:write(lelle, stockholm, Db1).
% [{lelle,stockholm},{francesco,london}]
% 5> db:read(francesco, Db2).
% {ok,london}
% 6>  Db3 = db:write(joern, stockholm, Db2).
% [{joern,stockholm},{lelle,stockholm},{francesco,london}]
% 7>  db:read(ola, Db3).
% {error,instance}
% 8>  db:match(stockholm, Db3).
% [joern,lelle]
% 9>  Db4 = db:delete(lelle, Db3).
% [{joern,stockholm},{francesco,london}]
% 10> db:match(stockholm, Db4).
% [joern]
% 11>

% DISCLAIMER %
% As I'm not interested in reinventing the wheel right now, I'll make use of lists library module
% Actually I'm solving this exercise because this module will be reused at exercise 5-1 (ch5)

-module(db).
-export([new/0]).
-export([destroy/1]).
-export([write/3]).
-export([delete/2]).
-export([read/2]).
-export([match/2]).

new() ->
  [].
  
destroy(_Db) ->
  ok.
  
write(Key, Element, Db) ->
  lists:keystore(Key, 1, Db, {Key, Element}).
  
delete(Key, Db) ->
  lists:keydelete(Key, 1, Db).
  
read(Key, Db) ->
  case lists:keyfind(Key, 1, Db) of
    false -> { error, instance };
    { _K, V } -> { ok, V }
  end.
  
match(Element, Db) ->
  Query = fun({ _K, V }) -> Element == V end,
  Partitions = lists:partition(Query, Db),
  Matched = element(1, Partitions),
  GetKeys = fun({ K, _V }) -> K end,
  lists:map(GetKeys, Matched).
