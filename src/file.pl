save :-
    \+ is_game_started(true),
    write('Permainan belum dimulai!'),
    nl, !.

save :-
    draw_player_four(_),
    write('Hanya bisa tantang atau mengambil kartu!'),
    !.

save :-
    draw_player_two(_),
    write('Hanya bisa mengambil kartu!'),
    !.


save :-
    write('Masukkan nama file penyimpanan: '),
    read(FileFirst), 
    name(FileFirst, FileASCII),
    gabung_list(FileASCII, [46, 116, 120, 116], FileTXT),
    name(FileName, FileTXT),
    writeFile(FileName),
    retractDynamic,
    format('Permainan berhasil disimpan ~w', [FileName]),
    !.

writeFile(FileName) :-
    open(FileName, write, Stream),
    mode_permainan(Mode),
    write(Stream, mode_permainan:Mode), write(Stream, '.'),
    nl(Stream),
    (   Mode == turnamen
    ->  writeTim(Stream)  
    ;   true
    ),
    daftar_pemain(DaftarPemain),
    write(Stream, daftar_pemain:DaftarPemain), write(Stream, '.'),
    nl(Stream),
    jumlah_pemain(Jum),
    write(Stream, jumlah_pemain:Jum), write(Stream, '.'),
    nl(Stream),
    giliran_sekarang(Giliran),
    write(Stream, giliran_sekarang:Giliran), write(Stream, '.'),
    nl(Stream),
    discard_top(DiscardTop),
    write(Stream, discard_top:DiscardTop), write(Stream, '.'),
    nl(Stream),
    warna_aktif(WarnaAktif),
    write(Stream, warna_aktif:WarnaAktif), write(Stream, '.'),
    nl(Stream),
    arah_permainan(Arah),
    write(Stream, arah_permainan:Arah), write(Stream, '.'),
    nl(Stream),
    sudah_uni(SudahUni),
    write(Stream, sudah_uni:SudahUni), write(Stream, '.'),
    nl(Stream),
    writeKartuTersembunyi(Stream),
    writeTangan(Stream),
    deck(Deck),
    write(Stream, deck:Deck), write(Stream, '.'),
    nl(Stream),
    close(Stream),
    !.

writeTangan(Stream) :-
    tangan_pemain(Nama, ListKartu),
    write(Stream, kartu(Nama):ListKartu),
    write(Stream, '.'),
    nl(Stream),
    fail.

writeTangan(_) :-
    !.

writeTim(Stream) :-
    tim(NomorTim, ListTim),
    write(Stream, tim(NomorTim):ListTim),
    write(Stream, '.'),
    nl(Stream),
    fail.

writeTim(_) :-
    !.

writeKartuTersembunyi(Stream) :-
    kartu_tersembunyi(Nama, Kartu),
    write(Stream, tersembunyi(Nama):Kartu), write(Stream, '.'),
    nl(Stream),
    fail.

writeKartuTersembunyi(_) :-
    !.

retractDynamic :-
    retractall(is_game_started(_)),
    retractall(jumlah_pemain(_)),
    retractall(giliran_sekarang(_)),
    retractall(warna_aktif(_)),
    retractall(sudah_uni(_)),
    retractall(deck(_)),
    retractall(arah_permainan(_)),
    retractall(daftar_pemain(_)),
    retractall(tangan_pemain(_, _)),
    retractall(discard_top(_)),
    retractall(mode_permainan(_)),
    retractall(tim(_, _)),
    retractall(kartu_tersembunyi(_, _)).

load :-
    is_game_started(true),
    write('Game sudah dimulai! Tidak bisa melakukan load'),
    !.

load :-
    write('Masukkan nama file yang akan dimuat: '),
    read(FileFirst), 
    name(FileFirst, FileASCII),
    gabung_list(FileASCII, [46, 116, 120, 116], FileTXT),
    name(FileName, FileTXT),
    ( file_exists(FileName)
    ->  open(FileName, read, Stream),
        readFile(Stream),
        assertz(is_game_started(true)),
        close(Stream),
        giliran_sekarang(Sekarang),
        format('Status permainan berhasil dimuat dari ~w. Melanjutkan giliran ~w', [FileName, Sekarang]),
        !
    ;   write('Error: File tidak ditemukan!'), nl,
        !
    ).
    

readFile(Stream) :-
    read(Stream, Data),
    ( Data == end_of_file 
    ->  true
    ;
        assertFile(Data),
        readFile(Stream)
    ),    
    !.

assertFile(Data) :-
    Data = deck:Deck,
    assertz(deck(Deck)),
    !.

assertFile(Data) :-
    Data = daftar_pemain:Daftar,
    assertz(daftar_pemain(Daftar)),
    !.

assertFile(Data) :-
    Data = jumlah_pemain:Jumlah,
    assertz(jumlah_pemain(Jumlah)),
    !.

assertFile(Data) :-
    Data = giliran_sekarang:Pemain,
    assertz(giliran_sekarang(Pemain)),
    !.

assertFile(Data) :-
    Data = discard_top:Kartu,
    assertz(discard_top(Kartu)),
    !.

assertFile(Data) :-
    Data = warna_aktif:Warna,
    assertz(warna_aktif(Warna)),
    !.

assertFile(Data) :-
    Data = arah_permainan:Arah,
    assertz(arah_permainan(Arah)),
    !.

assertFile(Data) :-
    Data = sudah_uni:ListPemain,
    assertz(sudah_uni(ListPemain)),
    !.

assertFile(Data) :-
    Data = kartu(Nama):ListTangan,
    assertz(tangan_pemain(Nama, ListTangan)),
    !.

assertFile(Data) :-
    Data = tim(NomorTim):ListTim,
    assertz(tim(NomorTim, ListTim)),
    !.

assertFile(Data) :-
    Data = mode_permainan:Mode,
    assertz(mode_permainan(Mode)),
    !.

assertFile(Data) :-
    Data = tersembunyi(Nama):Kartu,
    assertz(kartu_tersembunyi(Nama, Kartu)),
    !.