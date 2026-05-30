% Fakta poin setiap jenis kartu
poin(kartu(_,0),1):-!. % khusus 0
poin(kartu(_,Angka), Angka):- integer(Angka), Angka > 0, Angka =< 9, !.

poin(kartu(_,skip), 10):- !.
poin(kartu(_,reverse), 10):- !.
poin(kartu(_,draw_two), 10):- !.

poin(kartu(_,wild), 20):- !.
poin(kartu(_,wild_draw_four), 20):- !.
poin(kartu(_,mimic), 20):- !.

% hitung total
total_poin([],0).
total_poin([H|T], Sum):-
    poin(H, Poin),
    total_poin(T,Sum1),
    Sum is Poin + Sum1.

% Proses bungkus data pemain jadi skor(Poin, JumlahKartu, UrutanMain, Nama)
proses_skor([], _, []).
proses_skor([Nama|Tail], Urutan, [skor(Poin, JumlahKartu, Urutan, Nama)|HasilTail]) :-
    tangan_pemain(Nama, ListKartu),
    total_poin(ListKartu, Poin),
    panjang_list(ListKartu, JumlahKartu), % Pakai helper lu
    UrutanNext is Urutan + 1,
    proses_skor(Tail, UrutanNext, HasilTail).


% Cetak nama-nama kartu
cetak_nama_kartu([]).
cetak_nama_kartu([kartu(Warna, Nilai)]) :- 
    format('~w-~w', [Warna, Nilai]), !.
cetak_nama_kartu([kartu(Warna, Nilai)|Tail]) :-
    format('~w-~w + ', [Warna, Nilai]),
    cetak_nama_kartu(Tail).

% Cetak angka poin kartu 
cetak_angka_poin([]).
cetak_angka_poin([Kartu]) :-
    poin(Kartu, Poin),
    format('~d', [Poin]), !.
cetak_angka_poin([Kartu|Tail]) :-
    poin(Kartu, Poin),
    format('~d + ', [Poin]),
    cetak_angka_poin(Tail).

% Cetak keseluruhan rincian satu pemain
cetak_rincian_sisa_kartu([]).
cetak_rincian_sisa_kartu([Nama|Tail]) :-
    tangan_pemain(Nama, ListKartu),
    ( ListKartu == [] ->
        format('~w: kartu habis = 0 poin~n', [Nama])
    ;
        format('~w: ', [Nama]),
        cetak_nama_kartu(ListKartu),
        write(' = '),
        cetak_angka_poin(ListKartu),
        total_poin(ListKartu, TotalPoin),
        format(' = ~d poin~n', [TotalPoin])
    ),
    cetak_rincian_sisa_kartu(Tail).

% Cetak hasil klasemen akhir
cetak_klasemen([], _).
cetak_klasemen([skor(Poin, _, _, Nama)|Tail], Rank) :-
    format('~d. ~w (~d poin)~n', [Rank, Nama, Poin]),
    RankNext is Rank + 1,
    cetak_klasemen(Tail, RankNext).


endGame :-
    tangan_pemain(Pemicu, []), !,
    format('Permainan selesai! ~w menghabiskan semua kartunya!~n~n', [Pemicu]),
    write('Berikut perhitungan poin sisa kartu.'), nl,
    find_all(NamaPemain, tangan_pemain(NamaPemain, _), _ListValidasi),  
    daftar_pemain(ListPemain),
    cetak_rincian_sisa_kartu(ListPemain), nl,
    
    (mode_permainan(turnamen) -> write('Berikut perhitungan poin untuk masing-masing tim.'), nl,
        tim(1, [A1, A2]), 
        tim(2, [B1, B2]),
        % poin anggota tim 1
        tangan_pemain(A1, TanganA1), total_poin(TanganA1, PoinA1),
        tangan_pemain(A2, TanganA2), total_poin(TanganA2, PoinA2),
        TotalTim1 is PoinA1 + PoinA2,
        format('Tim 1 (~w, ~w) : ~d + ~d = ~d poin~n', [A1, A2, PoinA1, PoinA2, TotalTim1]),
        
        % poin anggota tim 2
        tangan_pemain(B1, TanganB1), total_poin(TanganB1, PoinB1),
        tangan_pemain(B2, TanganB2), total_poin(TanganB2, PoinB2),
        TotalTim2 is PoinB1 + PoinB2,
        format('Tim 2 (~w, ~w) : ~d + ~d = ~d poin~n~n', [B1, B2, PoinB1, PoinB2, TotalTim2]),
        
        % nentuin pemenang
        (TotalTim1 < TotalTim2 -> Pemenang = 'Tim 1' ; TotalTim2 < TotalTim1 -> Pemenang = 'Tim 2' ; 
        Pemenang = 'Tim 1 dan Tim 2 (Seri)' % seri), format('Selamat, ~w menjadi pemenang!~n', [Pemenang]) ; 

        % mode klasik
        proses_skor(ListPemain, 1, DataSkor),
        bubble_sort(DataSkor, DataSkorUrut),
        write('Urutan pemenang:'), nl,
        cetak_klasemen(DataSkorUrut, 1), nl,
        DataSkorUrut = [skor(_, _, _, Pemenang)|_],
        format('Selamat, ~w menjadi pemenang!~n', [Pemenang])),

    retractall(is_game_started(_)),
    assertz(is_game_started(false)),
    !.