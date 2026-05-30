lihatCommand :-
    draw_player_two(_),
    is_game_started(true), !,
    write('Aksi utama yang tersedia:'), nl,
    write('1. ambilKartu'), nl, nl,
    write('Aksi pendukung yang tersedia:'), nl,
    write('1. lihatCommand'), nl,
    write('2. lihatKartu'), nl,
    write('3. cekInfo'), nl.

lihatCommand :- 
    draw_player_four(_),
    is_game_started(true), !,
    write('Aksi utama yang tersedia:'), nl,
    write('1. ambilKartu'), nl, nl,
    write('Aksi pendukung yang tersedia:'), nl,
    write('1. tantang'), nl,
    write('2. lihatCommand'), nl,
    write('3. lihatKartu'), nl,
    write('4. cekInfo'), nl.

lihatCommand :- 
    is_game_started(true), !,
    write('Aksi utama yang tersedia:'), nl,
    write('1. mainkanKartu(NomorUrut)'), nl,
    write('2. ambilKartu'), nl, nl,
    write('Aksi pendukung yang tersedia:'), nl,
    write('1. lihatCommand'), nl,
    write('2. lihatKartu'), nl,
    write('3. cekInfo'), nl.


lihatCommand :-
    write('Error: Permainan belum dimulai! Gunakan startGame. dulu.'), nl.

cetak_list_kartu([], _) :- !.
cetak_list_kartu([kartu(Warna, Jenis)|Sisa], Index) :-
    format('~d. ~w-~w~n',[Index, Warna, Jenis]),
    NextIndex is Index + 1,
    cetak_list_kartu(Sisa, NextIndex).

lihatKartu :-
    is_game_started(true), !,
    giliran_sekarang(Pemain),
    (tangan_pemain(Pemain, Tangan) -> format('Kartu yang anda punya (~w):~n', [Pemain]), 
    cetak_list_kartu(Tangan,1) ; format('~w belum memiliki kartu.~n', [Pemain])),

    (mode_permainan(turnamen) -> cari_teman(Pemain, Teman), nl,
    format('Berikut kartu yang teman satu tim anda miliki (~w).~n' [Teman]),
    tangan_pemain(Teman, TanganTeman), cetak_list_kartu(TanganTeman,1) ; true).

lihatKartu :-
    write('Error: Permainan belum dimulai! Gunakan startGame. dulu.'), nl.

cetak_urutan([]) :- !.
cetak_urutan([Pemain]) :- 
    write(Pemain), !.
cetak_urutan([Pemain|Sisa]) :-
    format('~w - ', [Pemain]),
    cetak_urutan(Sisa).

cetak_info_pemain([], _) :- !.
cetak_info_pemain([Pemain|Sisa], Index) :-
    format('Nama pemain ~d: ~w~n', [Index, Pemain]),
    (tangan_pemain(Pemain, Tangan) -> panjang_list(Tangan, JumlahKartu) ; JumlahKartu = 0),
    format('Jumlah kartu : ~d~n', [JumlahKartu]), nl,
    NextIndex is Index + 1,
    cetak_info_pemain(Sisa, NextIndex).

cekInfo :- is_game_started(true),
    discard_top(kartu(_, X)),
    (X == wild ; X == wild_draw_four),
    warna_aktif(Aktif),
    (discard_top(kartu(Warna, Jenis)) -> format('Kartu discard top: ~w-~w(~w)~n', [Warna, Jenis, Aktif])
    ; write('Kartu discard top kosong.'), nl),
    nl,

    (mode_permainan(turnamen) -> tim(1, [P1,P3]), tim(2, [P2,P4]),
    format('Tim 1 : ~w, ~w~n', [P1,P3]),
    format('Tim 2 : ~w, ~w~n', [P2,P4]), nl ; true),

    (daftar_pemain(ListPemain) -> write('Urutan pemain: '), cetak_urutan(ListPemain), nl, nl, cetak_info_pemain(ListPemain, 1) 
    ; write('Daftar pemain belum ada.'), nl), !.


cekInfo :- is_game_started(true), !,
    (discard_top(kartu(Warna, Jenis)) -> format('Kartu discard top: ~w-~w~n', [Warna, Jenis])
    ; write('Kartu discard top kosong.'), nl),
    nl,

    (daftar_pemain(ListPemain) -> write('Urutan pemain: '), cetak_urutan(ListPemain), nl, nl, cetak_info_pemain(ListPemain, 1) 
    ; write('Daftar pemain belum ada.'), nl).

cekInfo :- 
    write('Error: Permainan belum dimulai! Gunakan startGame. dulu.'), nl.