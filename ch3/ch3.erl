-module(ch3).
-export([sum/1]).
-export([sum/2]).
-export([create/1]).
-export([reverse_create/1]).
-export([filter/2]).
-export([reverse/1]).
-export([concatenate/1]).
-export([flatten/1]).
-export([quick_sort/1]).

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
  
% 3-5
% Write a function that, given a list of lists, will concatenate them.
% Example:
% concatenate([[1,2,3], [], [4, five]]) ⇒ [1,2,3,4,five].

% my algorithm:
% concatenate([[1,2,3], [], [4, five]])
% [1,2,3] ++ concatenate([[], [4, five]])
% [1,2,3] ++ [] ++ concatenate([[4, five]])
% [1,2,3] ++ [] ++ [4,five] ++ concatenate([])
% [1,2,3] ++ [] ++ [4,five] ++ []
% [1,2,3,4,five].
concatenate([]) ->
  [];
concatenate([H | T]) ->
  H ++ concatenate(T).
  
% 3-5
% Write a function that, given a list of nested lists, will return a flat list.
% Example:
% flatten([[1,[2,[3],[]]], [[[4]]], [5,6]]) ⇒ [1,2,3,4,5,6].
% Hint: use concatenate to solve flatten.
flatten([]) ->
  [];
flatten(L) ->
  case has_list_elements(L) of
    false ->
      L;
    true ->
      case has_non_list_elements(L) of
        true ->
          flatten(concatenate(put_elements_in_lists(L)));
        false ->
          flatten(concatenate(L))
      end
  end.

has_non_list_elements([]) ->
  false;
has_non_list_elements([H | T]) ->
  case is_list(H) of
    true ->
      has_non_list_elements(T);
    false ->
      true
  end.
  
has_list_elements([]) ->
  false;
has_list_elements([H | T]) ->
  case is_list(H) of
    true ->
      true;
    false ->
      has_list_elements(T)
  end. 

put_elements_in_lists([]) ->
  [];
put_elements_in_lists([H | T]) ->
  case is_list(H) of
    true ->
      [H | put_elements_in_lists(T)];
    false ->
      [[H] | put_elements_in_lists(T)]
  end.

% 3.6
% Implement the following sort algorithms over lists:
% Quicksort
% The head of the list is taken as the pivot;
% the list is then split according to those elements smaller than the pivot and the rest.
% These two lists are then recursively sorted by quicksort, and joined together, with the pivot between them.
quick_sort([Pivot | T]) ->
  {Smallers, Rest} = smallers_and_rest(T, Pivot, {[],[]}),
  lists:sort(Smallers) ++ [Pivot] ++ lists:sort(Rest).

smallers_and_rest([], _, Acc) ->
  Acc;
smallers_and_rest([H | T], Pivot, Acc) ->
  NewAcc = case H < Pivot of
    true ->
      Smallers = element(1, Acc),
      setelement(1, Acc, Smallers ++ [H]);
    false ->
      Rest = element(2, Acc),
      setelement(2, Acc, Rest ++ [H])      
  end,
  smallers_and_rest(T, Pivot, NewAcc).