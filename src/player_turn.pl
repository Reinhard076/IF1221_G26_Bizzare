eksekusi_mainkan(NomorUrut) :-
    giliran_sekarang(Pemain),
    tangan_pemain(Pemain, Tangan),
    panjang_list(Tangan, Panjang),
    NomorUrut >= 1, NomorUrut =< Panjang,
    Idx is NomorUrut - 1,
    nilaiIdx(Idx, Tangan, Kartu),
    Kartu = kartu(Warna, Jenis), 
    (validasi_kartu(Pemain, Kartu)
    ->  hapus_kartu(Pemain, Kartu),
        retractall(discard_top(_)),
        assertz(discard_top(Kartu)),
        (Warna \== hitam 
        -> retractall(warna_aktif(_)), 
           assertz(warna_aktif(Warna)) 
        ;  true),
        format('~w memainkan kartu: ~w-~w~n', [Pemain, Warna, Jenis]),
        efek(Warna, Jenis),
        ( (Jenis == skip ; Jenis == draw_two ; Jenis == wild_draw_four)
        ->  !
        ;   pindah_giliran,
            !
        )
    ;   write('Kartu tidak cocok dengan discard top.'), nl
    ).

eksekusi_mainkan(_) :-
    write('Nomor kartu tidak valid.'), nl.

% validasiKartu/1
% validasiKartu(kartu(_, wild))           :- !.
% validasiKartu(kartu(_, wild_draw_four)) :- !.
% validasiKartu(kartu(W, _)) :- warna_aktif(W), !.
% validasiKartu(kartu(W, _)) :- discard_top(kartu(W, _)), W \= none, !.
% validasiKartu(kartu(_, J)) :- discard_top(kartu(_, J)), !.

% orang 2 panggil fungsi action cardsnya
% orang 3 panggil status UNI
% orang 4 panggil pengecekan endgame

ambilKartu :-
    is_game_started(true), !,
    giliran_sekarang(Pemain),
    deck(Deck),
    ( Deck = [Kartu|Sisa]
    ->  retractall(deck(_)), 
        assertz(deck(Sisa)),
        tangan_pemain(Pemain, Tangan),
        retractall(tangan_pemain(Pemain, _)),
        assertz(tangan_pemain(Pemain, [Kartu|Tangan])),
        format('~w mengambil 1 kartu.~n', [Pemain]),
        pindah_giliran
    ;   write('Deck kosong!'), nl
    ).

ambilKartu :-
    write('Error: Permainan belum dimulai! Gunakan startGame. dulu.'), nl.

pindah_giliran_skip :-
    giliran_sekarang(Current),
    daftar_pemain(List), 
    arah_permainan(Arah),
    get_next_player(Current, List, Arah, Next),
    retractall(giliran_sekarang(_)),
    assertz(giliran_sekarang(Next)).

pindah_giliran :-
    giliran_sekarang(Current),
    daftar_pemain(List), 
    arah_permainan(Arah),
    get_next_player(Current, List, Arah, Next),
    retractall(giliran_sekarang(_)),
    assertz(giliran_sekarang(Next)),
    format('Sekarang giliran ~w.~n', [Next]).

get_next_player(Current, List, kanan, Next) :-
    gabung_list(List, List, DoubleList), 
    cari_sebelah_kanan(Current, DoubleList, Next).

get_next_player(Current, List, kiri, Next) :-
    gabung_list(List, List, DoubleList),
    cari_sebelah_kiri(Current, DoubleList, Next).

cari_sebelah_kanan(X, [X, Next|_], Next) :- !.
cari_sebelah_kanan(X, [_|T], Next) :- cari_sebelah_kanan(X, T, Next).

cari_sebelah_kiri(X, [Next, X|_], Next) :- !.
cari_sebelah_kiri(X, [_|T], Next) :- cari_sebelah_kiri(X, T, Next).

hapus_kartu(Pemain, Kartu) :-
    tangan_pemain(Pemain, Tangan),
    hapus_elemen_pertama(Kartu, Tangan, TanganBaru),
    retractall(tangan_pemain(Pemain, _)),
    assertz(tangan_pemain(Pemain, TanganBaru)).

hapus_elemen_pertama(X, [X|T], T) :- !.
hapus_elemen_pertama(X, [H|T], [H|R]) :- hapus_elemen_pertama(X, T, R).