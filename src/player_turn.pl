eksekusi_mainkan(NomorUrut) :-
    giliran_sekarang(Pemain),
    tangan_pemain(Pemain, Tangan),
    panjang_list(Tangan, Panjang),
    NomorUrut >= 1, NomorUrut =< Panjang,
    ambil_indeks(Tangan, NomorUrut, Kartu, _),
    ( validasiKartu(Kartu)
    ->  hapus_kartu(Pemain, Kartu),
        retract(discard_top(_)),
        assertz(discard_top(Kartu)),
        format('~w memainkan kartu: ~w-~w~n', [Pemain, Warna, Jenis]),
        pindah_giliran,
        !
    ;   write('Kartu tidak cocok dengan discard top.'), nl
    ).

eksekusi_mainkan(_) :-
    write('Nomor kartu tidak valid.'), nl.

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