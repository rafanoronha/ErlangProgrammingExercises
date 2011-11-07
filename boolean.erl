-module(boolean).
-export([b_and/2]).
-export([b_nand/2]).
-export([b_not/1]).
-export([b_or/2]).

b_and(true, true) ->
  true;
b_and(true, false) ->
  false;
b_and(false, false) ->
  false;
b_and(false, true) ->
  false.
  
b_nand(X, Y) when ((X == true) or (X == false)) and ((Y == true) or (Y == false)) ->
  b_not(b_and(X, Y)).
  
b_not(true) ->
  false;
b_not(false) ->
  true.

b_or(true, true) ->
  true;
b_or(true, false) ->
  true;
b_or(false, false) ->
  false;
b_or(false, true) ->
  true.