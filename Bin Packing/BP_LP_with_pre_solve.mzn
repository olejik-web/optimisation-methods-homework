% Иногда полезно ввести новые ограничения, чтобы сократить область значений.
% Фактически, в любой модели надо найти оптимальный баланс.

% Также, использование тех или иных ограничений может давать сразу какое-то решение (не оптимальное)
% либо решать задачу быстрее, но долго не давать никакого решения
% На практике оптимального решения вы вряд ли дождетесь!
% Здесь тоже нужен баланс.

int: num_bins;                      % количество контейнеров
int: num_stuff;                     % количество предметов
array[1..num_stuff] of int: stuff;  % веса предметов
int: bin_capacity;                  % вместимость контейнера

% таблица с распределением по контейнерам; X[i, j] = 1 == вещь j в контейнере i.
array[1..num_bins, 1..num_stuff] of var 0..1: X;

% список используемых бинов
array[1..num_bins] of var 0..1: bins_open;

% CONSTRAINTS
% каждая вещь ровно в одном контейнере
constraint forall(s in 1..num_stuff)(
  sum(b in 1..num_bins)(X[b, s]) = 1
);

% сумма масс вещей в контейнере не должна превышать его вместимость, если он испольуется; и ноль, если 
constraint forall(b in 1..num_bins)(
  sum(s in 1..num_stuff)(X[b, s] * stuff[s]) <= bin_capacity * bins_open[b]
);

% SYMMETRRY BREAKING CONSTRAINTS

% (ограничение 1) заполняем контейнеры по порядку
constraint forall(b in 1..num_bins - 1)(bins_open[b] >= bins_open[b + 1]);  % сразу сильное ускорение

% (ограничение 2) суммарный вес контейнеров убывает
%constraint forall(b in 1..num_bins - 1)(sum(s in 1..num_stuff)(X[b, s] * stuff[s] - X[b + 1, s] * stuff[s]) >= 0);  % не сильно, но ускоряет. в случае комбинированного - замедляет

% (ограничение 3) содержимое бинов идёт в лексикографическом порядке (2 и 3 несовместны)
%constraint forall(i in 2..num_bins, j in 2..num_stuff)(
%  sum(s in i..num_bins)(X[s, j]) <= sum(p in 1..j - 1)(X[i - 1, p])
%);
%constraint X[1, 1] = 1;

% С использованием глобальных ограничений
%include "decreasing.mzn";

% (ограничение 1) то же, только при помощи глобальных ограничений
% constraint decreasing(bins_open);

% (ограничение 2) то же, только при помощи глобальных ограничений
%constraint decreasing([sum(s in 1..num_stuff)(X[b, s] * stuff[s]) | b in 1..num_bins]);


% PRE-SOLVE STRATEGIES

int: total_weight = sum(s in 1..num_stuff)(stuff[s]);

% Естественное ограничение на количество бинов
% constraint bin_capacity * sum(b in 1..num_bins)(bins_open[b]) >= total_weight;

% Более тонкая версия: 
constraint forall(b in 1..num_bins)(
  total_weight * bins_open[b] >= total_weight - bin_capacity * (b - 1)
);


% OBJECTIVE
% распределить как-нибудь
solve minimize sum(b in 1..num_bins)(bins_open[b]);

output [ "Number of loaded bins: " ++ show(sum(b in 1..num_bins) (bins_open[b]))] ++ ["\n"] ++
       [ "Bin " ++ show(i) ++ ": " ++ show([j | j in 1..num_stuff where X[i, j] > 0]) ++ " " ++ show([stuff[j] | j in 1..num_stuff where X[i, j] > 0]) ++ ", TW: " ++ show(sum(s in 1..num_stuff)(X[i, s] * stuff[s])) ++ "\n" | i in 1..num_bins];