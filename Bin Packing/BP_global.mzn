% BIN PACKING PROBLEM
% there are n items with different weights and n equal bins this items should be packed into
% find minimal number of required bins 

% DATA
int: num_stuff;                    % number of things to pack
array[1..num_stuff] of int: stuff; % the value/weight of the things to pack
int: bin_capacity;                 % all bins have the same capacity

% Number of bins cannot exceed num_stuff...
int: num_bins;


% VARIABLES
% bin number for stuff
array[1..num_stuff] of var 1..num_bins: X;


% OBJECTIVE
% minimize the number of loaded bins
solve minimize max(X);

% CONSTRAINTS
include "bin_packing.mzn";
constraint bin_packing(bin_capacity, X, stuff);

% OUTPUT
output [ "Number of loaded bins: " ++ show(max(fix(X)))] ++ ["\n"] ++
       [ "Bin " ++ show(b) ++ ": " ++ show([i | i in 1..num_stuff where X[i] = b]) ++ " " ++ show([stuff[i] | i in 1..num_stuff where X[i] = b]) ++ "\n" | b in 1..num_bins];
