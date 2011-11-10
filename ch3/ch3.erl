-module(ch3).
-export([sum/1]).
-export([sum/2]).

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
