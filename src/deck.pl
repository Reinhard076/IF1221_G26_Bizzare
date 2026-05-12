:- dynamic(shuffle_dek/1).  %shuffle_dek(deck)          mengacak kartu dalam dek
:- dynamic(bagi_kartu/2).   %bagi_kartu(deck/Player)    memberi 7 kartu untuk pemain 
:- dynamic(discard_pile/1). %discard_card(deck)         membuka 1 kartu angka sebagai kartu awal di meja

warna(merah). warna(kuning). warna(hijau). warna(biru). warna(hitam).
angka(0). angka(1). angka(2). angka(3). angka(4). angka(5). angka(6). angka(7). angka(8). angka(9).
aksi(skip). aksi(reverse). aksi(draw2). aksi(wilddraw). aksi(wild). %aksi(mimic).

kartu_wild(hitam,wild). kartu_wild(hitam,wilddraw)
kartu_angka(X,Y):- warna(X), angka(Y).kartu_aksi(X,Y):- warna(X), aksi(Y), X /== hitam, Y /== wild, Y /== wilddraw.
