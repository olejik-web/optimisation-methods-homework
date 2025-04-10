% BIN PACKING PROBLEM
% there are n items with different weights and n equal bins this items should be packed into
% find minimal number of required bins 

% DATA
int: num_stuff;                    % number of things to pack
array[1..num_stuff] of int: stuff; % the value/weight of the things to pack
int: bin_capacity;                 % all bins have the same capacity

% Number of bins cannot exceed num_stuff...
int: num_bins; % num_stuff;
int: total_weight = sum(s in 1..num_stuff)(stuff[s]);


% VARIABLES
% either the thing is packed or not into the bin
array[1..num_bins, 1..num_stuff] of var 0..1: bins;


% if bin is open
array[1..num_bins] of var 0..1: bin_open;


% OBJECTIVE
% minimize the number of loaded bins
solve minimize sum(b in 1..num_bins) (bin_open[b]);

% OUTPUT
output [ "Number of loaded bins: " ++ show(sum(b in 1..num_bins) (bin_open[b]))] ++ ["\n"] ++
       [ "Bin " ++ show(i) ++ ": " ++ show([stuff[j] | j in 1..num_stuff where bins[i, j] > 0]) ++ "\n" | i in 1..num_bins ];