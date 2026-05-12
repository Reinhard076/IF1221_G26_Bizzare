eksekusi_mainkan(NomorUrut) :-
    giliran_sekarang(Pemain),
    tangan_pemain(Pemain, Tangan),
    length(Tangan, Panjang),
    NomorUrut >= 1, NomorUrut =< Panjang,
    nth1(NomorUrut, Tangan, Kartu),
    ( validasiKartu(Kartu)
    ->  hapus_kartu(Pemain, Kartu),
        retract(discard_top(_)),
        assertz(discard_top(Kartu)),
        format('~w memainkan ~w~n', [Pemain, Kartu]),
        pindah_giliran
    ;   write('Kartu tidak cocok dengan discard top.'), nl
    ).

eksekusi_mainkan(_) :-
    write('Nomor kartu tidak valid.'), nl.


% validasiKartu/1
validasiKartu(kartu(_, wild))           :- !.
validasiKartu(kartu(_, wild_draw_four)) :- !.
validasiKartu(kartu(W, _)) :- warna_aktif(W), !.
validasiKartu(kartu(W, _)) :- discard_top(kartu(W, _)), W \= none, !.
validasiKartu(kartu(_, J)) :- discard_top(kartu(_, J)), !.

ambilKartu :-
    is_game_started(true), !,
    giliran_sekarang(Pemain),
    deck(Deck),
    ( Deck = [Kartu|Sisa]
    ->  retract(deck(_)), assertz(deck(Sisa)),
        tangan_pemain(Pemain, Tangan),
        retract(tangan_pemain(Pemain, _)),
        assertz(tangan_pemain(Pemain, [Kartu|Tangan])),
        format('~w mengambil 1 kartu.~n', [Pemain]),
        pindah_giliran
    ;   write('Deck kosong!'), nl
    ).

ambilKartu :-
    write('Error: Permainan belum dimulai! Gunakan startGame. dulu.'), nl.


% pindah_giliran/0

pindah_giliran :-
    giliran_sekarang(Current),
    findall(N, daftar_pemain(N), List),
    arah_permainan(Arah),
    get_next_player(Current, List, Arah, Next),
    retract(giliran_sekarang(Current)),
    assertz(giliran_sekarang(Next)),
    format('Sekarang giliran ~w.~n', [Next]).

get_next_player(Current, List, kanan, Next) :-
    nth0(I, List, Current), length(List, Total),
    I1 is (I + 1) mod Total, nth0(I1, List, Next).

get_next_player(Current, List, kiri, Next) :-
    nth0(I, List, Current), length(List, Total),
    I1 is (I - 1 + Total) mod Total, nth0(I1, List, Next).

% hapus_kartu/2 — helper internal
hapus_kartu(Pemain, Kartu) :-
    tangan_pemain(Pemain, Tangan),
    select(Kartu, Tangan, Baru),
    retract(tangan_pemain(Pemain, _)),
    assertz(tangan_pemain(Pemain, Baru)).