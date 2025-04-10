% BIN PACKING PROBLEM
% there are n items with different weights and n equal bins this items should be packed into
% find minimal number of required bins 

% DATA
int: num_stuff;                    % number of things to pack
array[1..num_stuff] of int: stuff; % the value/weight of the things to pack
int: bin_capacity;                 % all bins have the same capacity

% Number of bins cannot exceed num_stuff...
int: num_bins;
int: total_weight = sum(s in 1..num_stuff)(stuff[s]);


% VARIABLES
% bin number for stuff
array[1..num_stuff] of var 1..num_bins: X;

% inverse map for bins-stuff map
array[1..num_bins] of var set of 1..num_stuff: Xinv;

% channeling constraint
include "int_set_channel.mzn";
constraint int_set_channel(X, Xinv);

% bin load
array[1..num_bins] of var 0..bin_capacity: bins_load;

% minimal thing index in bin (zero if bin is empty).
array[1..num_bins] of var 0..num_bins: min_stuff;


% OBJECTIVE
% minimize the number of loaded bins
var 1..num_bins: bins_loaded = max(X);


% CONSTRAINTS


include "decreasing.mzn";

% Размер уменьшается (по весу)
%constraint decreasing(bins_weight);

% Размер уменьшается (по количеству)
% constraint decreasing([card(s) | s in Xinv]);

% Лексикографический порядок
constraint decreasing(min_stuff);

constraint forall(b in 1..num_bins)(
  if card(Xinv[b]) > 0 then min_stuff[b] = min(Xinv[b]) else min_stuff[b] = 0 endif
);


constraint forall(b in 1..num_bins)(
  sum([stuff[i] | i in 1..num_stuff where X[i] = b]) = bins_load[b]
);


% SYMMETRY BREAKING
% bins are opened in order of ID

% bins are ordered by quantity

% bins are ordered by weight


% PRE-SOLVE STRATEGIES
% constraint bin_capacity * sum(b in 1..num_bins)(bin_open[b]) >= total_weight;

%onstraint forall(b in 1..num_bins)(
%  total_weight * bin_open[b] >= total_weight - bin_capacity * (b - 1)
%);

%constraint forall(b in 1..num_bins) (
%  (total_weight - bin_capacity * (b - 1)) * bin_open[b] >= total_weight - bin_capacity * (b - 1)
%);

ann: search_weight = int_search([min_stuff[i] | i in 1..num_stuff], first_fail, indomain_random);

solve::search_weight minimize bins_loaded;

% OUTPUT
output [ "Number of loaded bins: " ++ show(max(fix(X)))] ++ ["\n"] ++
       [ "Bin " ++ show(b) ++ ": " ++ show([i | i in 1..num_stuff where X[i] = b]) ++ " " ++ show([stuff[i] | i in 1..num_stuff where X[i] = b]) ++ "\n" | b in 1..num_bins];
