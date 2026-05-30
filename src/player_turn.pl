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
        
        tangan_pemain(Pemain, SisaKartu),
        ( SisaKartu == [] 
        ->  endGame, ! 
        ;   
            ( (Jenis == skip ;( Jenis == mimic, turn_aksi(skip, _, _, _)))
            ->  !
            ;   pindah_giliran,
                !
            )
        )
    ;   write('Kartu tidak cocok dengan discard top.'), nl
    ).

eksekusi_mainkan(_) :-
    write('Nomor kartu tidak valid.'), nl.

ambilKartu :-
    is_game_started(true),
    draw_player_two(_),
    efek_draw_two,
    (   turn_aksi(Aksi, Warna, PemainL, Turn) 
    ->  T is Turn + 1,
        retractall(turn_aksi(_, _, _, _)),
        assertz(turn_aksi(Aksi, Warna, PemainL, T))
    ;   true 
    ),
    pindah_giliran,
    !.

ambilKartu :-
    is_game_started(true),
    draw_player_four(_),
    efek_draw_four,
    (   turn_aksi(Aksi, Warna, PemainL, Turn) 
    ->  T is Turn + 1,
        retractall(turn_aksi(_, _, _, _)),
        assertz(turn_aksi(Aksi, Warna, PemainL, T))
    ;   true 
    ),
    pindah_giliran,
    !.

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
        (   turn_aksi(Aksi, Warna, PemainL, Turn) 
        ->  T is Turn + 1,
            retractall(turn_aksi(_, _, _, _)),
            assertz(turn_aksi(Aksi, Warna, PemainL, T))
        ;   true 
        ),
        pindah_giliran
    ;   write('Deck kosong! Deck akan di shuffle ulang.'), nl,
        shuffle_deck,
        ambilKartu
    ),
    !.

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

swapKartu(NomorUrut, NomorTeman) :-
    is_game_started(true),
    mode_permainan(turnamen), !,
    giliran_sekarang(Pemain),
    cari_teman(Pemain, Teman),
    
    tangan_pemain(Pemain, Tangan),
    tangan_pemain(Teman, TanganTeman),
    panjang_list(Tangan, Len),
    panjang_list(TanganTeman, LenTeman),
    (Len =< 1 -> write('Gagal: Kamu hanya memiliki 1 kartu.'), nl, fail ; true),
    (LenTeman =< 1 -> format('Gagal: Temanmu (~w) hanya memiliki 1 kartu.~n', [Teman]), nl, fail ; true),
    NomorUrut >= 1, NomorUrut =< Len,
    NomorTeman >= 1, NomorTeman =< LenTeman,
    Idx is NomorUrut - 1, IdxTeman is NomorTeman - 1,
    nilaiIdx(Idx, Tangan, Kartu),
    nilaiIdx(IdxTeman, TanganTeman, KartuTeman),
    
    Kartu = kartu(Warna, Jenis),
    KartuTeman = kartu(WarnaTeman, JenisTeman),
    hapus_kartu(Pemain, Kartu),
    hapus_kartu(Teman, KartuTeman),
    
    tangan_pemain(Pemain, TanganBaru),
    tangan_pemain(Teman, TanganTemanBaru),
    retractall(tangan_pemain(Pemain, _)),
    retractall(tangan_pemain(Teman, _)),
    
    assertz(tangan_pemain(Pemain, [KartuTeman|TanganBaru])),
    assertz(tangan_pemain(Teman, [Kartu|TanganTemanBaru])),
    
    format('~w menukar kartu ~w-~w dengan kartu ~w-~w milik ~w.~n', [Pemain, Warna, Jenis, WarnaTeman, JenisTeman, Teman]), nl,
    write('Pertukaran kartu berhasil.'), nl, nl,
    pindah_giliran,
    !.

swapKartu(_, _) :-
    \+ mode_permainan(turnamen), !,
    write('Error: Perintah swapKartu hanya tersedia pada Mode Turnamen!'), nl.

swapKartu(_, _) :-
    write('Error: Nomor urut kartu tidak valid (out of range).'), nl.

cari_teman(P1, P2) :- tim(_, [P1, P2]), !.
cari_teman(P2, P1) :- tim(_, [P1, P2]), !.