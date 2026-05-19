:- dynamic(sudah_uni/1).

tantang :-
    giliran_sekarang(Penantang),
    discard_top(kartu(hitam, wild_draw_four)), !,
    daftar_pemain(List),
    arah_permainan(Arah),
    get_prev_player(Penantang, List, Arah, Tertuduh),
    write('Tantangan dilakukan!'), nl,
    write('Memeriksa kartu '), write(Tertuduh), write('...'), nl,
    tangan_pemain(Tertuduh, KartuTertuduh),
    warna_aktif(WarnaAktif),
    (   punya_kartu_cocok(KartuTertuduh, WarnaAktif, _) ->
        write('Tantangan berhasil! '), write(Tertuduh), write(' berbohong.'), nl,
        write(Tertuduh), write(' mendapatkan hukuman 4 kartu secara acak.'), nl,
        ambilKartuAksi(Tertuduh, 4),
        pindah_giliran_tantang
    ;   write('Tantangan gagal. Pemain sebelumnya jujur!'), nl,
        write(Penantang), write(' mendapatkan 6 kartu acak.'), nl,
        ambilKartuAksi(Penantang, 6),
        pindah_giliran
    ).

tantang :-
    write('Tidak bisa melakukan tantang saat ini.'), nl.

pindah_giliran_tantang :-
    giliran_sekarang(Current),
    daftar_pemain(List),
    arah_permainan(Arah),
    get_next_player(Current, List, Arah, Next),
    write('Giliran '), write(Next), write('.'), nl.

get_prev_player(Current, List, kanan, Prev) :- get_next_player(Current, List, kiri, Prev).
get_prev_player(Current, List, kiri, Prev) :- get_next_player(Current, List, kanan, Prev).

uni(NomorUrut) :-
    giliran_sekarang(Pemain),
    tangan_pemain(Pemain, Tangan),
    panjang_list(Tangan, Panjang),
    Panjang =:= 2,
    NomorUrut >= 1, NomorUrut =< Panjang, !,
    Idx is NomorUrut - 1,
    nilaiIdx(Idx, Tangan, Kartu),
    (   validasi_kartu(Pemain, Kartu) ->
        hapus_kartu(Pemain, Kartu),
        retractall(discard_top(_)),
        assertz(discard_top(Kartu)),
        Kartu = kartu(Warna, Jenis),
        (Warna \== hitam -> retractall(warna_aktif(_)), assertz(warna_aktif(Warna)) ; true),
        assertz(sudah_uni(Pemain)),
        write(Pemain), write(' memainkan kartu: '), write(Warna), write('-'), write(Jenis), write('.'), nl,
        write(Pemain), write(' menyerukan UNI'), nl, nl,
        write('Pemain berikutnya kehilangan giliran.'), nl,
        efek(Warna, Jenis),
        ( (Jenis == skip ; Jenis == draw_two ; Jenis == wild_draw_four) -> ! ; pindah_giliran, ! )
    ;   penalti_uni(Pemain)
    ).

uni(_) :-
    giliran_sekarang(Pemain),
    penalti_uni(Pemain).

penalti_uni(Pemain) :-
    write('Perintah tidak valid. Kartu yang dimainkan tidak membuat kartu tersisa satu.'), nl,
    write('Kartu tidak dimainkan. '), write(Pemain), write(' mendapatkan 1 kartu acak sebagai penalti.'), nl,
    ambilKartuAksi(Pemain, 1),
    pindah_giliran.

tangkap(NamaPemain) :-
    tangan_pemain(NamaPemain, ListKartu),
    panjang_list(ListKartu, 1),
    \+ sudah_uni(NamaPemain), !,
    write(NamaPemain), write(' tertangkap tidak menyerukan UNI.'), nl,
    write(NamaPemain), write(' mendapatkan 2 kartu penalti.'), nl,
    ambilKartuAksi(NamaPemain, 2),
    nl,
    giliran_sekarang(Current),
    daftar_pemain(List),
    arah_permainan(Arah),
    get_next_player(Current, List, Arah, Next),
    write('Giliran '), write(Next), write('.'), nl.

tangkap(_) :-
    giliran_sekarang(Penangkap),
    write('Perintah dianggap tidak valid.'), nl,
    write(Penangkap), write(' mendapatkan 1 kartu penalti secara acak.'), nl,
    ambilKartuAksi(Penangkap, 1).
