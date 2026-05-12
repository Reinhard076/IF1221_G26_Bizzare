% 1. DATABASE KARTU MENTAH (Total 55 Kartu Unik)
% Format: kartu(Warna, Jenis)
% Jenis: 0-9 (Angka), skip, reverse, draw_two, wild, wild_draw_four, mimic
kartu_mentah([
    kartu(merah, 0), kartu(merah, 1), kartu(merah, 2), kartu(merah, 3), kartu(merah, 4),
    kartu(merah, 5), kartu(merah, 6), kartu(merah, 7), kartu(merah, 8), kartu(merah, 9),
    kartu(hijau, 0), kartu(hijau, 1), kartu(hijau, 2), kartu(hijau, 3), kartu(hijau, 4),
    kartu(hijau, 5), kartu(hijau, 6), kartu(hijau, 7), kartu(hijau, 8), kartu(hijau, 9),
    kartu(biru, 0), kartu(biru, 1), kartu(biru, 2), kartu(biru, 3), kartu(biru, 4),
    kartu(biru, 5), kartu(biru, 6), kartu(biru, 7), kartu(biru, 8), kartu(biru, 9),
    kartu(kuning, 0), kartu(kuning, 1), kartu(kuning, 2), kartu(kuning, 3), kartu(kuning, 4),
    kartu(kuning, 5), kartu(kuning, 6), kartu(kuning, 7), kartu(kuning, 8), kartu(kuning, 9),

    kartu(merah, skip), kartu(merah, reverse), kartu(merah, draw_two),
    kartu(hijau, skip), kartu(hijau, reverse), kartu(hijau, draw_two),
    kartu(biru, skip), kartu(biru, reverse), kartu(biru, draw_two),
    kartu(kuning, skip), kartu(kuning, reverse), kartu(kuning, draw_two),

    kartu(hitam, wild), kartu(hitam, wild_draw_four), kartu(hitam, mimic)
]).

% -------------------------------------------------------------------------
% 2. LOGIKA MENGACAK DECK (shuffle_deck/0)
% -------------------------------------------------------------------------
shuffle_deck :-
    kartu_mentah(ListAsal),
    panjang_list(ListAsal, Panjang),
    acak_list(ListAsal, Panjang, ListAcak),
    retractall(deck(_)),
    assertz(deck(ListAcak)),
    !.

% Helper mengacak list secara rekursif
acak_list([], _, []) :- !.
acak_list(Sebelum, Count, [Pilihan|Setelah]) :-
    Count1 is Count + 1,
    random(1, Count1, Rand),
    ambil_indeks(Sebelum, Rand, Pilihan, Sisa),
    C1 is Count - 1,
    acak_list(Sisa, C1, Setelah),
    !.

% Helper mengambil elemen berdasarkan indeks (1-based)
ambil_indeks([H|T], 1, H, T) :- !.
ambil_indeks([H|T], I, X, [H|Rest]) :-
    I1 is I - 1,
    ambil_indeks(T, I1, X, Rest),
    !.

% Helper menghitung panjang list manual
panjang_list([], 0).
panjang_list([_|T], N) :-
    panjang_list(T, N1),
    N is N1 + 1.

bagi_kartu(_, 0) :- !.
bagi_kartu(Pemain, Jumlah) :-
    deck([KartuAtas|SisaDeck]),
    retract(deck(_)),
    assertz(deck(SisaDeck)),
    ( tangan_pemain(Pemain, TanganLama) 
    ->  retract(tangan_pemain(Pemain, _)),
        assertz(tangan_pemain(Pemain, [KartuAtas|TanganLama]))
    ;   assertz(tangan_pemain(Pemain, [KartuAtas]))
    ),
    SisaJumlah is Jumlah - 1,
    bagi_kartu(Pemain, SisaJumlah),
    !.

bagikan_kartu_semua_pemain([]) :- !.
bagikan_kartu_semua_pemain([Pemain|SisaPemain]) :-
    bagi_kartu(Pemain, 7),
    bagikan_kartu_semua_pemain(SisaPemain).

inisialisasi_discard_pile :-
    deck([KartuAtas|SisaDeck]),
    retract(deck(_)),
    assertz(deck(SisaDeck)),
    (  is_kartu_aksi(KartuAtas)
    -> % Jika terambil kartu aksi, kembalikan ke bawah deck, lalu ulangi
       taruh_di_bawah_deck(KartuAtas),
       inisialisasi_discard_pile
    ;  % Jika kartu angka valid, pasang sebagai discard_top pertama
       retractall(discard_top(_)),
       assertz(discard_top(KartuAtas)),
       KartuAtas = kartu(Warna, _),
       retractall(warna_aktif(_)),
       assertz(warna_aktif(Warna)),
       !
    ).

is_kartu_aksi(kartu(_, skip)).
is_kartu_aksi(kartu(_, reverse)).
is_kartu_aksi(kartu(_, draw_two)).
is_kartu_aksi(kartu(_, wild)).
is_kartu_aksi(kartu(_, wild_draw_four)).
is_kartu_aksi(kartu(_, mimic)).

taruh_di_bawah_deck(Kartu) :-
    deck(ListLama),
    retract(deck(_)),
    gabung_list(ListLama, [Kartu], ListBaru),
    assertz(deck(ListBaru)),
    !.

gabung_list([], L, L).
gabung_list([H|T], L, [H|R]) :-
    gabung_list(T, L, R).
