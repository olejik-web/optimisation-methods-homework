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

% CONSTRAINTS
constraint forall(b in 1..num_bins)(
  sum(s in 1..num_stuff)(stuff[s] * bins[b, s]) <= bin_capacity * bin_open[b]
);

constraint forall(s in 1..num_stuff)(
  sum(b in 1..num_bins)(bins[b, s]) = 1
);


% SYMMETRY BREAKING
% bins are opened in order of ID
constraint forall(b in 2..num_bins)(bin_open[b - 1] >= bin_open[b]);

% bins are ordered by quantity
%constraint forall(b in 1..num_bins - 1)(
%  sum(s in 1..num_stuff)(bins[b, s]) >= sum(s in 1..num_stuff)(bins[b+1, s])
%); 

% bins are ordered by weight
%constraint forall(b in 1..num_bins - 1)(
%   sum(s in 1..num_stuff)(bins[b, s] * stuff[s]) >= sum(s in 1..num_stuff)(bins[b+1, s] * stuff[s])
%);

% bins are in lexicographical order
%constraint forall(i in 2..num_bins, j in 2..num_stuff)(
%  bins[i, j] <= sum(p in 1..j - 1)(bins[i - 1, p])
%);

%constraint bins[1, 1] = 1;

% bins are in lexicographical order
constraint forall(i in 2..num_bins, j in 2..num_stuff)(
  sum(s in i..num_bins)(bins[s, j]) <= sum(p in 1..j - 1)(bins[i - 1, p])
);

constraint bins[1, 1] = 1;

% два соседних бина нельзя объединить
%constraint forall(i in 2..num_bins)(
%  sum(s in 1..num_stuff)(bins[i - 1, s] * stuff[s] + bins[i, s] * stuff[s]) >= (bin_capacity + 1) * bin_open[i]
%);

% PRE-SOLVE STRATEGIES
% constraint bin_capacity * sum(b in 1..num_bins)(bin_open[b]) >= total_weight;

%onstraint forall(b in 1..num_bins)(
%  total_weight * bin_open[b] >= total_weight - bin_capacity * (b - 1)
%);

constraint forall(b in 1..num_bins) (
  (total_weight - bin_capacity * (b - 1)) * bin_open[b] >= total_weight - bin_capacity * (b - 1)
);  


% OUTPUT
output [ "Number of loaded bins: " ++ show(sum(b in 1..num_bins) (bin_open[b]))] ++ ["\n"] ++
       [ "Bin " ++ show(i) ++ ": " ++ show([j | j in 1..num_stuff where bins[i, j] > 0]) ++ " " ++ show([stuff[j] | j in 1..num_stuff where bins[i, j] > 0]) ++ "\n" | i in 1..num_bins];
