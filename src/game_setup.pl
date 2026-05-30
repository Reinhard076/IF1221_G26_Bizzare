startGame :-
    is_game_started(true), !,
    write('Permainan sudah dimulai').

startGame :-
    is_game_started(true), !,
    write('Permainan sudah dimulai.').

startGame :-
    write('Tersedia 2 mode permainan.'), nl,
    write('1. Mode klasik'), nl,
    write('2. Mode turnamen'), nl, nl,
    write('Pilih mode permainan: '),
    read(Mode), nl, nl,
    proses_mode(Mode), !.

proses_mode(1) :-
    assertz(is_game_started(true)),
    assertz(mode_permainan(klasik)),
    assertz(arah_permainan(kanan)),
    assertz(sudah_uni([])),
    write('Masukkan jumlah pemain: '),
    read(Player),
    valid_Player(Player),
    jumlah_pemain(JumlahValid),
    read_PlayerNames(JumlahValid, 1),
    randomizer, nl,

    daftar_pemain(ListPemain),
    write('Urutan pemain: '), cetak_urutan_dot(ListPemain), nl, nl,
    
    ListPemain = [PemainPertama | _],
    assertz(giliran_sekarang(PemainPertama)),
    
    shuffle_deck,
    bagikan_kartu_semua_pemain(ListPemain),
    write('Setiap pemain mendapatkan 7 kartu acak.'), nl, nl,
    inisialisasi_discard_pile,
    discard_top(kartu(Warna, Jenis)),
    format('Kartu discard top: ~w-~w.~n', [Warna, Jenis]), nl,
    format('Giliran ~w.~n', [PemainPertama]),
    !.

proses_mode(2) :-
    assertz(is_game_started(true)),
    assertz(mode_permainan(turnamen)),
    write('Permainan dimulai dalam mode turnamen.'), nl, nl,

    assertz(jumlah_pemain(4)),
    read_PlayerNames(4, 1),
    randomizer,

    daftar_pemain([P1,P2,P3,P4]),
    assertz(tim(1, [P1,P3])),
    assertz(tim(2, [P2,P4])), nl,
    write('Membentuk tim secara acak...'), nl,
    format('Tim 1 : ~w, ~w~n', [P1,P3]),
    format('Tim 2 : ~w, ~w~n', [P2,P4]), nl,
    write('Urutan pemain: '), cetak_urutan_dot([P1,P3,P2,P4]), nl, nl,
    assertz(giliran_sekarang(P1)),

    shuffle_deck,
    bagikan_kartu_semua_pemain([P1,P2,P3,P4]),
    write('Setiap pemain mendapatkan 7 kartu acak.'), nl, nl,
    inisialisasi_discard_pile,
    discard_top(kartu(Warna, Jenis)),
    format('Kartu discard top: ~w-~w.~n', [Warna, Jenis]), nl,
    format('Giliran ~w.~n', [P1]),
    !.

proses_mode(_):-
    write('Pilihan tidak valid, ulangi perintah startGame.'), nl, fail.

valid_Player(Player) :-
    Player >= 2,
    Player =< 4,
    assertz(jumlah_pemain(Player)),
    !.

valid_Player(_) :-
    write('Mohon masukkan angka antara 2-4.'),
    nl,
    write('Masukkan jumlah pemain: '),
    read(NewPlayer),
    valid_Player(NewPlayer),
    !.

read_PlayerNames(All, Count) :-
    X is Count,
    All < X,
    !.

read_PlayerNames(All, Count) :-
    format('Masukkan nama pemain ~d: ', [Count]),
    read(Name),
    X is Count + 1,
    addNewName(Name),
    read_PlayerNames(All, X),
    !.

addNewName(Name) :-
    daftar_pemain(Name),
    write('Nama sudah digunakan. Masukkan nama lain: '),
    read(NewName),
    !,
    addNewName(NewName).

addNewName(Name) :-
    assertz(daftar_pemain(Name)),
    !.

randomizer :-
    find_AllName(X),
    jumlah_pemain(Count),
    random_List(X, Count, Y),
    retractall(daftar_pemain(_)),
    assertz(daftar_pemain(Y)),
    !.

random_List([], _, []) :- !.

random_List(Before, Count, [New|After]) :-
    Count1 is Count + 1,
    random(1, Count1, Rand),
    pick_atI(Before, Rand, New, Rest),
    C1 is Count - 1,
    random_List(Rest, C1, After),
    !.

pick_atI([H|T], 1, H, T) :- !.
pick_atI([H|T], I, X, [H|Rest]) :-
    I1 is I - 1,
    pick_atI(T, I1, X, Rest),
    !.

find_AllName([]) :-
    \+ daftar_pemain(_),
    !.
find_AllName([Name|T]) :-
    daftar_pemain(Name),
    retract(daftar_pemain(Name)),
    find_AllName(T),
    !.

cetak_urutan_dot([]) :- !.
cetak_urutan_dot([Pemain]) :-
    write(Pemain), write('.'), !.
cetak_urutan_dot([Pemain|Sisa]) :-
    write(Pemain), write(' - '),
    cetak_urutan_dot(Sisa).