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
    (tangan_pemain(Pemain, Tangan) -> format('Kartu yang anda punya (~w):~n', [Pemain]), cetak_list_kartu(Tangan,1) ; format('~w belum memiliki kartu.~n', [Pemain])).

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

cekInfo :- is_game_started(true), !,
    % Discard top
    (discard_top(kartu(Warna, Jenis)) -> format('Kartu discard top: ~w-~w~n', [Warna, Jenis])
    ; write('Kartu discard top kosong.'), nl),
    nl,

    % Urutan pemain
    (daftar_pemain(ListPemain) -> write('Urutan pemain: '), cetak_urutan(ListPemain), nl, nl, cetak_info_pemain(ListPemain, 1) 
    ; write('Daftar pemain belum ada.'), nl).

cekInfo :- 
    write('Error: Permainan belum dimulai! Gunakan startGame. dulu.'), nl.