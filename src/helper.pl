% Mencari elemen pada indeks tertentu (mulai dari 0).
nilaiIdx(0, [H|_], H) :- !. 
nilaiIdx(I, [_|T], X) :-
    I > 0,
    I1 is I - 1,
    nilaiIdx(I1, T, X).     

% Mengumpulkan semua jawaban dari suatu goal ke dalam satu list.
find_all(X, Goal, _) :-
    Goal,                   
    assertz(temp(X)), 
    fail.                        

find_all(_, _, Hasil) :-
    hasil_all([], Hasil).   
hasil_all(Acc, Hasil) :-
    retract(temp(X)), !,
    hasil_all([X|Acc], Hasil). %
hasil_all(Hasil, Hasil).

% append
gabung_list([], L, L).
gabung_list([H|T], L, [H|R]) :-
    gabung_list(T, L, R).

 %length   
panjang_list([], 0).
panjang_list([_|T], N) :-
    panjang_list(T, N1),
    N is N1 + 1.
