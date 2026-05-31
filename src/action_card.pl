efek(_, mimic) :-
    efek_aksi(mimic),
    ( turn_aksi(AksiLama, WarnaLama, PemainLama, TurnLama)
    -> T is TurnLama + 1,
       retractall(turn_aksi(_, _, _, _)),
       assertz(turn_aksi(AksiLama, WarnaLama, PemainLama, T))
    ;  true
    ),
    !.

efek(Warna, Aksi) :-
    is_kartu_aksi(kartu(_, Aksi)),
    Aksi \== mimic,
    giliran_sekarang(Pemain),
    retractall(turn_aksi(_, _, _, _)),
    assertz(turn_aksi(Aksi, Warna, Pemain, 1)),
    efek_aksi(Aksi),
    !.

efek(_, _) :-
    turn_aksi(AksiLama, WarnaLama, PemainLama, TurnLama),
    T is TurnLama + 1,
    retractall(turn_aksi(_, _, _, _)),
    assertz(turn_aksi(AksiLama, WarnaLama, PemainLama, T)),
    !.

efek(_, _) :-
    !.

efek_aksi(draw_two) :-
    assertz(draw_player_two(x)).


efek_aksi(wild_draw_four) :-
    write('Masukkan Warna : '),
    read(Warna),
    retractall(warna_aktif(_)),
    warna_wild(Warna),
    format('Warna diubah menjadi ~w.~n', [Warna]),
    assertz(draw_player_four(x)),
    !.

efek_aksi(skip) :-
    pindah_giliran_skip,
    giliran_sekarang(Next),
    format('~w diskip.~n', [Next]),
    pindah_giliran_skip,
    giliran_sekarang(Now),
    format('Sekarang giliran ~w.', [Now]),
    !.

efek_aksi(reverse) :-
    arah_permainan(kiri),
    retractall(arah_permainan(_)),
    assertz(arah_permainan(kanan)),
    write('Arah permainan dibalik.'), nl,
    !.

efek_aksi(reverse) :-
    arah_permainan(kanan),
    retractall(arah_permainan(_)),
    assertz(arah_permainan(kiri)),
    write('Arah permainan dibalik.'), nl,
    !.   

efek_aksi(mimic) :-
    \+ turn_aksi(_, _, _, _),
    write('Menelusuri riwayat permainan.'), nl,
    write('Belum ada kartu aksi yang dimainkan.'), nl,
    write('Masukkan Warna :'),
    read(Warna),
    retractall(warna_aktif(_)),
    warna_wild(Warna),
    format('Warna diubah menjadi ~w.~n', [Warna]),
    !.

efek_aksi(mimic) :-
    turn_aksi(Aksi, Warna, Pemain, Turn),
    write('Menelusuri riwayat permainan.'), nl,
    format('Kartu aksi terakhir yang dimainkan: ~w-~w (oleh ~w, ~d giliran lalu).~n', [Warna, Aksi, Pemain, Turn] ),
    format('Kartu mimic menyalin efek ~w.~n', [Aksi]),
    ( (Aksi == wild ; Aksi == wild_draw_four)
    ->  efek_aksi(Aksi)
    ;   efek_aksi(Aksi),
        write('Masukkan Warna :'),
        read(WarnaBaru),
        retractall(warna_aktif(_)),
        warna_wild(WarnaBaru),
        format('Warna diubah menjadi ~w.~n', [WarnaBaru]),
        !
    ).


efek_aksi(wild) :-
    write('Masukkan Warna : '),
    read(Warna),
    retractall(warna_aktif(_)),
    warna_wild(Warna),
    format('Warna diubah menjadi ~w.~n', [Warna]),
    !.

efek_aksi(_) :-
    !.

efek_draw_two :-
    giliran_sekarang(Current),
    format('~w mengambil 2 kartu.~n', [Current]),
    ambilKartuAksi(Current, 2),
    retractall(draw_player_two(_)),
    !.

efek_draw_four :-
    giliran_sekarang(Current),
    format('~w mengambil 4 kartu.~n', [Current]),
    ambilKartuAksi(Current, 4),
    retractall(draw_player_four(_)),
    !.


ambilKartuAksi(_, 0) :-
    !.

ambilKartuAksi(Pemain, Jumlah) :-
    deck(Deck),
    ( Deck = [Kartu|Sisa]
    ->  retractall(deck(_)), 
        assertz(deck(Sisa)),
        tangan_pemain(Pemain, Tangan),
        retractall(tangan_pemain(Pemain, _)),
        assertz(tangan_pemain(Pemain, [Kartu|Tangan])),
        J is Jumlah - 1
    ;   write('Deck kosong! Deck akan di shuffle ulang.'), nl,
        shuffle_deck,
        J is Jumlah
    ),
    ambilKartuAksi(Pemain, J),
    !.


warna_wild(W) :-
    (W == merah ->  assertz(warna_aktif(merah))
    ; W == hijau -> assertz(warna_aktif(hijau))
    ; W == kuning -> assertz(warna_aktif(kuning))
    ; W == biru -> assertz(warna_aktif(biru))
    ; write('Input warna tidak valid'), nl,
      read(Warna),
      warna_wild(Warna)   
    ),
    !.

