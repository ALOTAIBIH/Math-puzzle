# Math-puzzle
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


