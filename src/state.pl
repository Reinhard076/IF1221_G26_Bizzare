% Deklarasi fakta dinamis agar bisa diubah (assert/retract) selama permainan
:- dynamic(is_game_started/1).       % Mengecek apakah startGame sudah dijalankan
:- dynamic(jumlah_pemain/1).         % Menyimpan angka 2-4 
:- dynamic(daftar_pemain/1).         % List nama pemain [william, razi, adinda]
:- dynamic(giliran_sekarang/1).      % Nama pemain yang sedang aktif
:- dynamic(arah_permainan/1).        % kanan (searah jarum jam) atau kiri

% Fakta terkait kartu
:- dynamic(deck/1).                  % List kartu yang bisa diambil (draw pile)
:- dynamic(discard_top/1).           % Kartu teratas di meja: kartu(Warna, Jenis)
:- dynamic(tangan_pemain/2).         % tangan_pemain(Nama, ListKartu)
:- dynamic(draw_player_two/1).              % pemain harus mengambil 2 kartu
:- dynamic(draw_player_four/1).             % pemain harus mengambil 4 kartu
:- dynamic(warna_aktif/1).           % Warna yang berlaku setelah kartu wild


% Fakta terkait aturan khusus
:- dynamic(sudah_uni/1).             % List pemain yang sudah menyerukan UNI
:- dynamic(kartu_tersembunyi/2).     % Bonus: kartu_tersembunyi(Nama, Kartu)
:- dynamic(turn_aksi/4).             % Menyimpan kartu aksi terakhir turn_aksi(Aksi, Warna, Pemain, Turn)

% Fakta untuk helper
:- dynamic(temp/1).

