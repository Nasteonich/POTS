-module(mobius).
-export([is_prime/1, prime_factors/1, is_square_multiple/1, find_square_multiples/2]).

% проверка того, является ли число простым
is_prime(1) -> false;	
is_prime(N) when N >= 2 -> is_prime(N, 2).
is_prime(N, Div) when Div * Div > N -> true;    % реализация метода сортировки делителей
is_prime(N, Div) -> 
	if
		N rem Div == 0 -> false;
		true -> is_prime(N, Div + 1)
	end.

% Возвращает список простых множителей числа N
prime_factors(N) -> prime_factors(N, 2, []).

% Найдите делитель числа N в диапазоне от [2, N]
prime_factors(N, Div, Result) when Div > N -> Result;
prime_factors(N, Div, Result) ->
	case is_prime(Div) of
		true -> case is_prime(N) of 
					true -> [N | Result];
					false ->
						if 
							N rem Div == 0 ->
								prime_factors(N div Div, Div, [Div | Result]);
							true -> prime_factors(N, Div + 1, Result)
						end 
				end;
		false -> prime_factors(N, Div + 1, Result) 
	end.

% получает аргумент N, и возвращает true, если аргумент делится на 
% квадрат простого числа или false, если не длится
% сортировка списка простых сомножителей, затем поиск повторяющихся сомножителей
is_square_multiple(N) -> 
	SortedPrimeFactors = lists:sort(prime_factors(N)),
	length(SortedPrimeFactors) > sets:size(sets:from_list(SortedPrimeFactors)).

% Если функция находит Count чисел подряд, делящихся на квадрат простого числа 
% в диапазоне [2, MaxN], она должна вернуть первое число из этой последовательности
find_square_multiples(Count, MaxN) -> find_square_multiples(Count, MaxN, 2, 2, 0).
find_square_multiples(Count, _, _, First, SeqLen) when SeqLen == Count -> First;

% Если функция не находит серию из Count чисел делящихся на квадрат простого числа 
% в этом диапазоне, она должна вернуть атом fail
find_square_multiples(_, MaxN, Current, _, _) when Current > MaxN -> fail;
find_square_multiples(Count, MaxN, Current, First, SeqLen) ->
	case is_square_multiple(Current) of
		true -> find_square_multiples(Count, MaxN, Current+1, First, SeqLen+1);
		false -> find_square_multiples(Count, MaxN, Current+1, Current+1, 0)
	end.