-module(ch3).
-export([sum/1]).
-export([sum/2]).
-export([create/1]).
-export([reverse_create/1]).
-export([filter/2]).
-export([reverse/1]).

% 3-1
% Write a function sum/1 which, given a positive integer N, will return the sum of all the integers between 1 and N.
% Example: sum(5) => 15
sum(1) -> 1;
sum(N) when is_integer(N) and (N > 0) ->
  N + sum(N-1).
  
% 3-1
% Write a function sum/2 which, given two integers N and M, where N =< M, will return the sum of the interval between N and M.
% If N > M, you want your process to terminate abnormally.
% Example:
% sum(1,3) => 6
% sum(6,6) => 6

% my algorithm:
% sum(1,3)
% 1 + sum(2,3)
% 1 + 2 + sum(3,3)
% 1 + 2 + 3
sum(N,N) when is_integer(N) ->
  N;
sum(N,M) when is_integer(N) and is_integer(M) and (N < M) ->
  N + sum(N+1,M).

% 3-2
% Write a function that returns a list of the format [1,2,..,N-1,N].
% Example:
% create(3) ⇒ [1,2,3].

% my algorithm:
% create(3)
% create(1) ++ [2,3]
% [1] ++ [2,3]
create(1) ->
  [1];
create(2) -> % this clause avoids a create(0) call
  [1,2];
create(N) when is_integer(N) and (N > 2) ->
  create(N-2) ++ [N-1,N].
  
% 3-2
% Write a function that returns a list of the format [N, N-1,..,2,1].
% Example:
% reverse_create(3) ⇒ [3,2,1].

% my algorithm:
% reverse_create(3)
% [3,2] ++ reverse_create(1)
% [3,2] ++ [1]
reverse_create(1) ->
  [1];
reverse_create(2) -> % this clause avoids a create(0) call
  [2,1];
reverse_create(N) when is_integer(N) and (N > 2) ->
  [N,N-1] ++ reverse_create(N-2).
  
% 3-5
% Write a function that, given a list of integers and an integer, will return all integers smaller than or equal to that integer.
% Example:
% filter([1,2,3,4,5], 3) ⇒ [1,2,3].

% my algorithm:
% filter([1,2,3,4,5], 3)
% [1] ++ filter([2,3,4,5], 3)
% [1,2] ++ filter([3,4,5], 3)
% [1,2,3] ++ filter([4,5], 3)
% [1,2,3] ++ filter([5], 3)
% [1,2,3] ++ []
filter([], _) ->
  [];
filter([H | T], N) when (H > N) ->
  filter(T,N);
filter([H | T], N) when (H =< N) ->
  [H] ++ filter(T,N).
  
% 3-5
% Write a function that, given a list, will reverse the order of the elements.
% Example:
% reverse([1,2,3]) ⇒ [3,2,1].

% my algorithm:  
% reverse([1,2,3])
% [3] ++ reverse([1,2])
% [3] ++ [2,1]
% [3,2,1].
reverse([N,M]) ->
  [M,N];
reverse(L) ->
  Size = length(L),
  [lists:last(L)] ++ reverse(lists:sublist(L,Size-1)).