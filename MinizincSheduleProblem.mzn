% Составление оптимального расписания для одного рабочего
% Данные 
% Горизонт планирования
int: horizon;
% Количество задач
int: tasksCount;
% Время выполнения задачи под номером i
array[1..tasksCount] of int: processingTime;
% Время начала выполнения задачи под номером i
array[1..tasksCount] of int: releaseTime;
% Время окончания выполнения задачи под номером i
array[1..tasksCount] of int: deadline;
% Переменные 
array[1..tasksCount, 1..horizon] of var 0..1: matrix;
var 1..horizon: executeTime;

% Целевая функция
solve :: seq_search([
    int_search([executeTime], input_order, indomain_random),
    int_search(matrix, input_order, indomain_random)
    ])
  minimize executeTime;

% Ограничения
% Каждая задача начинает выполняться только 1 раз
constraint forall(taskNumber in 1..tasksCount)(
  sum(timeNumber in 1..horizon)(matrix[taskNumber, timeNumber]) == 1);

% Никакие 2 задачи не выполняются в одно и то же время
constraint forall(upTimeNumber in 1..horizon)(
  sum(taskNumber in 1..tasksCount)(sum(timeNumber in max(1, 
  upTimeNumber - processingTime[taskNumber] + 1)..upTimeNumber)(
  matrix[taskNumber, timeNumber])) <= 1);

% Каждая задача начинает выполняься только 1 раз
constraint forall(upTimeNumber in 1..horizon)(
  sum(taskNumber in 1..tasksCount)(sum(timeNumber in max(1, 
  upTimeNumber - processingTime[taskNumber] + 1)..upTimeNumber)(
  matrix[taskNumber, timeNumber])) <= 1);

% Каждая задача начинает выполняться после времени старта
constraint forall(taskNumber in 1..tasksCount)(
  sum(timeNumber in 1..horizon)(matrix[taskNumber, timeNumber] * timeNumber) 
  >= releaseTime[taskNumber]);

% Каждая задача выполняется до дедлайна
constraint forall(taskNumber in 1..tasksCount)(
  sum(timeNumber in 1..horizon)(matrix[taskNumber, timeNumber] * timeNumber)
  + processingTime[taskNumber] - 1 <= deadline[taskNumber]);

% Каждая задача выполняется до определенного времени
constraint forall(taskNumber in 1..tasksCount)(
  sum(timeNumber in 1..horizon)(matrix[taskNumber, timeNumber] * timeNumber)
  + processingTime[taskNumber] - 1 <= executeTime);

output ["Задача " ++ show(i) ++ " выполняется в промежутке [" ++ 
  show(sum(j in 1..horizon)(matrix[i, j] * j)) ++ ", " ++ 
  show(sum(j in 1..horizon)(matrix[i, j] * j) + processingTime[i] - 1) ++ "]\n"
  | i in 1..tasksCount] ++ 
  ["Время выполнения всех задач: " ++ show(executeTime) ++ "\n"]