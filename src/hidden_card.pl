:- dynamic(kartu_tersembunyi/2).
:- dynamic(temp/1).

potong_list_at(0, [_|T], T) :- !.
potong_list_at(I, [H|T], Hasil) :-
    I > 0,
    I1 is I - 1,
    potong_list_at(I1, T, Sisa),
    gabung_list([H], Sisa, Hasil).

sembunyikanKartu(_, _, HandAwal, HandAwal) :-
    panjang_list(HandAwal, JumlahKartu),
    JumlahKartu =< 1,
    write('Gagal: Anda tidak bisa menyembunyikan kartu jika hanya memiliki 1 kartu!'), nl.

sembunyikanKartu(NamaPemain, _, HandAwal, HandAwal) :-
    kartu_tersembunyi(NamaPemain, _),
    write('Gagal: Anda sudah menyembunyikan kartu lain!'), nl.

sembunyikanKartu(NamaPemain, NomorUrut, HandAwal, HandBaru) :-
    panjang_list(HandAwal, JumlahKartu), JumlahKartu > 1,
    \+ kartu_tersembunyi(NamaPemain, _),
    Indeks is NomorUrut - 1,
    nilaiIdx(Indeks, HandAwal, kartu(Warna, Jenis)),
    assertz(kartu_tersembunyi(NamaPemain, kartu(Warna, Jenis))),
    potong_list_at(Indeks, HandAwal, HandBaru),
    write('Kartu '), write(Warna), write('-'), write(Jenis), write(' berhasil disembunyikan.'), nl.

sembunyikanKartu(_, NomorUrut, HandAwal, HandAwal) :-
    Indeks is NomorUrut - 1,
    \+ nilaiIdx(Indeks, HandAwal, _),
    write('Gagal: Nomor urut kartu tidak valid!'), nl.

tangkap(NamaTarget) :-
    kartu_tersembunyi(NamaTarget, kartu(Warna, Jenis)),
    write('Terdapat kartu yang disembunyikan oleh '), write(NamaTarget), write('.'), nl,
    write('Kartunya adalah: '), write(Warna), write('-'), write(Jenis), nl.

tangkap(NamaTarget) :-
    \+ kartu_tersembunyi(NamaTarget, _),
    write(NamaTarget), write(' tidak menyembunyikan kartu apapun.'), nl.
