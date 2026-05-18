validasi_kartu(_, kartu(Warna, Angka)) :-
    integer(Angka),
    warna_aktif(WarnaAktif),
    discard_top(kartu(_, JenisTop)),
    (Warna == WarnaAktif ; Angka == JenisTop),
    !.

validasi_kartu(_, kartu(Warna, skip)) :-
    warna_aktif(WarnaAktif),
    discard_top(kartu(_, JenisTop)),
    (Warna == WarnaAktif ; JenisTop == skip),
    !.

validasi_kartu(_, kartu(Warna, reverse)) :-
    warna_aktif(WarnaAktif),
    discard_top(kartu(_, JenisTop)),
    ( Warna == WarnaAktif ; JenisTop == reverse ),
    !.

validasi_kartu(_, kartu(Warna, draw_two)) :-
    warna_aktif(WarnaAktif),
    discard_top(kartu(_, JenisTop)),
    JenisTop \== draw_two,
    Warna == WarnaAktif,
    !.

validasi_kartu(_, kartu(hitam, wild)) :-
    discard_top(kartu(_, JenisTop)),
    JenisTop \== wild,
    JenisTop \== wild_draw_four,
    JenisTop \== mimic,
    !.

validasi_kartu(Pemain, kartu(hitam, wild_draw_four)) :-
    discard_top(kartu(_, JenisTop)),
    JenisTop \== wild,
    JenisTop \== wild_draw_four,
    JenisTop \== mimic,
    warna_aktif(WarnaAktif),
    tangan_pemain(Pemain, Tangan),
    \+ punya_kartu_cocok(Tangan, WarnaAktif, JenisTop),
    !.

validasi_kartu(_, kartu(hitam, mimic)) :-
    discard_top(kartu(_, JenisTop)),
    JenisTop \== wild,
    JenisTop \== wild_draw_four,
    JenisTop \== mimic,
    !.

punya_kartu_cocok([Kartu|_], WarnaAktif, JenisTop) :-
    bisa_cocok(Kartu, WarnaAktif, JenisTop), !.
punya_kartu_cocok([_|TanganLain], WarnaAktif, JenisTop) :-
    punya_kartu_cocok(TanganLain, WarnaAktif, JenisTop).

bisa_cocok(kartu(Warna, _), WarnaAktif, _) :- Warna == WarnaAktif.
bisa_cocok(kartu(_, Angka), _, JenisTop) :- integer(Angka), Angka == JenisTop.