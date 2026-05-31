godsHand :-
    is_game_started(true),
    daftar_pemain(ListPemain),
    ( cek_semua_satu_kartu(ListPemain) ->
        write('Mekanisme tidak berjalan: Seluruh pemain hanya memiliki satu kartu.'), nl
    ;
        % Mengacak angka 1 sampai 100
        random(1, 101, Peluang),
        
        % Cek apakah angka yang keluar masuk dalam probabilitas 20%
        ( Peluang =< 20 ->
            eksekusi_gods_hand(ListPemain)
        ;
            write('Tuhan tidak berkehendak saat ini.'), nl
        )
    ),
    nl, giliran_sekarang(Giliran),
    format('Giliran ~w.~n', [Giliran]), !.

godsHand :-
    write('Error: Permainan belum dimulai!'), nl, !.

cek_semua_satu_kartu([]).
cek_semua_satu_kartu([P|T]) :-
    tangan_pemain(P, Tangan),
    panjang_list(Tangan, 1),
    cek_semua_satu_kartu(T).

eksekusi_gods_hand(ListPemain) :-
    pemain_ada_kartu(ListPemain, ValidPemain),
    panjang_list(ValidPemain, JmlValid),
    Batas1 is JmlValid + 1,
    random(1, Batas1, Rand1),
    ambil_indeks(ValidPemain, Rand1, P1, _),

    tangan_pemain(P1, TanganP1),
    panjang_list(TanganP1, JmlKartu),
    BatasKartu is JmlKartu + 1,
    random(1, BatasKartu, RandKartu),
    ambil_indeks(TanganP1, RandKartu, KartuPindah, SisaTanganP1),

    hapus_pemain(P1, ListPemain, SisaPemain),
    panjang_list(SisaPemain, JmlSisa),
    Batas2 is JmlSisa + 1,
    random(1, Batas2, Rand2),
    ambil_indeks(SisaPemain, Rand2, P2, _),

    retractall(tangan_pemain(P1, _)),
    assertz(tangan_pemain(P1, SisaTanganP1)),
    
    tangan_pemain(P2, TanganP2),
    retractall(tangan_pemain(P2, _)),
    assertz(tangan_pemain(P2, [KartuPindah|TanganP2])),

    KartuPindah = kartu(Warna, Jenis),
    write('Tuhan telah berkehendak.'), nl,
    format('Kartu ~w-~w milik ~w berpindah ke tangan ~w!~n', [Warna, Jenis, P1, P2]).

pemain_ada_kartu([], []).
pemain_ada_kartu([P|T], [P|Res]) :-
    tangan_pemain(P, Tangan),
    panjang_list(Tangan, Len),
    Len > 0, !,
    pemain_ada_kartu(T, Res).
pemain_ada_kartu([_|T], Res) :-
    pemain_ada_kartu(T, Res).

hapus_pemain(_, [], []).
hapus_pemain(X, [X|T], T) :- !.
hapus_pemain(X, [H|T], [H|Res]) :-
    hapus_pemain(X, T, Res).