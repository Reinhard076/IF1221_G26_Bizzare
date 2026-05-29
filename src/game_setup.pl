startGame :-
    is_game_started(true), !,
    write('Permainan sudah dimulai').

startGame :-
    is_game_started(true), !,
    write('Permainan sudah dimulai.').

startGame :-
    assertz(is_game_started(true)),
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