
% This program solve math puzzle by using prolog language,
% it takes math puzzle as list of lists,
% each list is represented as a row of the puzzle.

% A maths puzzle is defined as the following:
% Square grid of squares, each to be filled with a single digit 1-9
% Performs the following constraints:
	% 1- There are no repeated numbers in each row and column
	% 2- All squares from upper left to the lower right 
	%     on the diagonal line have identical value
	% 3- The heading for each column and row contains  
	%     the total or product of all the numbers in that column or row
	
%%% Note %%
% the headings of the row and column are not considered 
% to be part of the row or column, and can filled with number larger than 1-9

%%% Goal of the puzzle is  %%%
%  to fill in all the squares according to the rules.

%%% An example %%% 
% posted           
%  ____ ____ ____    
% |    | 6 | 6   |        
% | 6  |   |     |      
% | 6  |   |     |      
%  ---- ---- ---- 

% solved 
%  ___ ____ ____    
% |    | 6 | 6   |        
% | 6  | 3 | 2   |      
% | 6  | 2 | 3   |      
%  ---- ---- ---- 
%  (A valid 2x2 maths puzzle)

%-------------------My approach ---------------------------------------------%
% my approach to solve math puzzle problem,
%  simply it was used the funcationality 
% provided by the constraint programming library 
%  to achieve a very high efficiency.

%% it was used both the apply and clpfd libraries (Constraint logic programming) 
%  libraries, for short, efficient codes, the SWIPL libray it was also used.
% use nth0/3 from the SWIPL lists library.
% use maplist/2 from the apply library.
%% ----Functions used in clpfd library:-----%%
%   -  puzzle_solution predicate used transpose/2 and label/1.
%   - all_digit predicate used all_distinct/1 and ins/2 .
% it was used also Frequently for arithmetic constraints #=/2, #=</2 and #>=/2


:- use_module(library(clpfd)).
:- use_module(library(apply)).

%-------------------------------Program--------------------------------------%

% puzzle_solution (Puzzle) holds if Puzzle is 
%  a mathematical puzzle representation. 
% Uses the following predicates for this process:
  % - First,  Make sure the entry is square of size 2x2, 3x3 or 4x4. 
  % - to ensure puzzle has the same length, it was used "same_length"
  % - then I transpose the Puzzle to produce Colum Puzzle, for later checking, 
	% - We then check for valid digits in the puzzle, and then assure
	% - Constraint 1, as above
	% - Constraint 2, as above
	% - Constraint 3, as above
	%  Finally, assure all terms are ground.

puzzle_solution(Puzzle):-
	length(Puzzle, Length), Length in 3..5, 
    maplist(same_length(Puzzle), Puzzle),
    transpose(Puzzle, Colums),
    all_digit(Puzzle), all_digit(Colums),
    same_diagonal(Puzzle),
    reach_headings(Puzzle), reach_headings(Colums),
    maplist(label, Puzzle).
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Constriant 1: Checking For Valid and no repeated Digits 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% All elements in lists should be digit between 1-9, 
% howevere, Headings is not nessary to be digit between 1-9
% and not two elements have same value by using all_distinct/1 from clpfd.
% The upper left corner of the puzzle is not meaningful.

% all_digit(+List)
% all_digits/1 takes list of lists (Puzzle) and holds when Constraint 1 holds.

all_digit([[_|_Row]|TailRows]) :-
   maplist(digit, TailRows),
   maplist(all_distinct, TailRows).
   
% digit(+List)   
% digit/1 takes single row and holds when  
% row element domain is specified between 1-9 digits (inclusive).

digit([_H_row|T_row]) :-
    T_row ins 1..9.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constriant 2: Checking the Diagonal Constraint
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% same_diagona1(+List)
% same_diagonal/1 takes a Puzzle, discards its header row,
% hold when we start from non_heading row with dignal index is 2 
%  and then check all dignal is equal

same_diagonal(Puzzle):-
	Puzzle = [_|[_|Rows]],
	diagonal(Rows,2,_).
	
%% diagonal(+List,+Int, ?Int)
%% diagonal take a puzzle row, integer index, representing a column index 
%   that must be equal to following  Dignal, an integer.
%% Holds when the index element of Row and 
%   the index+1 element of the following row is equal to Dignal.
diagonal([], _, _).
diagonal([Row|Rows],Idx,Dignal):-
	nth0(Idx,Row,Dignal),
	Idx1 is Idx + 1,
	diagonal(Rows,Idx1,Dignal).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constriant 3: Checking For Product and Sum Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	

%reach_headings(+list)
%reach_headings/1 takes a Puzzle and  assures each row's headings 
%  are either the sum or the product of its items, used to verify 
%   the column headings are still correct with a transposed Puzzle.
 
reach_headings([_|T_Rows]) :- 
    maplist(sum_or_product,T_Rows).
    
% sum_or_product(+list)
% sum or product/1 has a puzzle row which is valid 
% if the items are the sum of the heading or the product heading.

sum_or_product([Row|Rows]):-
     
	 (   sumlist(Rows, Row);           
         multiply_list(Rows, Row)  
     ).
     
% sumlist(+list, - Result)
% This predicate checks if the provided row sufficiently performs the sum
%   an accumulator value initially 0 for the first call

sumlist(XS,L):-
	sumlist(XS,0,L).

% sumlist/3 takes a list , an accumulator value ,
% and a value L, And holds where the list item result
% sumed by the accumulator value is equal to L.

sumlist([],A,A).
sumlist([X|XS],A,L):-
	A1 #= X + A,
	sumlist(XS,A1,L).

% multiply_list(+list, - Result)
% This predicate checks if the provided row sufficiently performs the product
%   an accumulator value initially 1 for the first call

multiply_list(XS,L):-
	multiply_list(XS,1,L).

% multiply_list/3 takes a list , an accumulator value ,
% and a value L, And holds where the list item result
% multiplied by the accumulator value is equal to L.

multiply_list([],A,A).	
multiply_list([X|XS],A,L):-
	A1 #= A * X,
	multiply_list(XS,A1,L).

