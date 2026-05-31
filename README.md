# Praktikum IF1221 Logika Komputasional - Game UNI

> **Kelompok G26 - Bizzare**

---

## Gambaran Singkat Proyek

Proyek ini merupakan simulasi permainan kartu **UNI** yang menggunakan bahasa **GNU Prolog**. Permainan ini mengelola state dinamis untuk permainan berbasis command line yang dapat dimainkan dari 2 hingga 4 pemain. Proyek ini mencakup penanganan dek kartu, sistem giliran pemain, sistem tantangan (challenge), deklarasi kartu terakhir (UNI), penalti, serta pencatatan skor akhir (end game).

---

## Cara Menjalankan Program

1. Instal **GNU Prolog** di perangkat.

2. Buka **GNU Prolog**.

3. Arahkan direktori aktif ke dalam folder utama repositori ini (Change Dir):

   ```bash
   cd /path/to/IF1221_G26_Bizzare
   ```

4. Lakukan compile terhadap file `main.pl`:

   ```prolog
   | ?- ['src/main.pl'].
   ```

5. Setelah muncul pesan sukses (`yes`), jalankan perintah selamat datang untuk melihat instruksi awal:

   ```prolog
   | ?- start.
   ```

6. Untuk memulai permainan baru, ketikkan perintah:

   ```prolog
   | ?- startGame.
   ```

---

## Struktur Repositori

```text
IF1221_G26_Bizzare/
├── docs/
│   ├── Milestone1_G26.pdf       
│   ├── Milestone2_G26.pdf       
│   └── Laporan_G26.pdf          
└── src/
    ├── main.pl                  
    ├── state.pl                 
    ├── helper.pl                
    ├── deck.pl
    ├── game_info.pl                
    ├── game_setup.pl            
    ├── player_turn.pl           
    ├── validasi.pl              
    ├── action_card.pl           
    ├── special_rules.pl         
    ├── file.pl
    ├── gods_hand.pl
    └── endgame.pl      
```

---

## Fitur Utama

* **Mode Permainan:** Tersedia Mode Klasik untuk permainan individu (2-4 pemain) dan Mode Turnamen untuk permainan berbasis tim (2v2).
* **Mekanik Kartu Aksi:** Mendukung penggunaan kartu aksi standar seperti *Skip*, *Reverse*, *Draw Two*, *Wild*, dan *Wild Draw Four*, serta penambahan kartu khusus *Mimic*.
* **Sistem Deklarasi UNI dan Penalti:** Pemain wajib mendeklarasikan UNI ketika kartu tersisa satu. Terdapat perintah `tangkap` untuk memberikan penalti kepada pemain yang tidak melakukan deklarasi.
* **Sistem Tantangan (Challenge):** Pemain dapat melakukan `tantang` terhadap penggunaan kartu *Wild Draw Four* untuk membalikkan efek penalti.
* **Sistem Tim (Khusus Turnamen):** Menyediakan perintah `swapKartu` yang memungkinkan pemain untuk bertukar kartu dengan rekan satu tim.
* **Sistem Penyimpanan (Save & Load):** Permainan dapat dihentikan sementara dengan menyimpan status (state) permainan ke dalam file `.txt` dan dapat dimuat kembali pada sesi berikutnya.
* **Fitur Bonus:**
  * **God's Hand:** Mekanisme acak dengan probabilitas 20% yang menukarkan kartu antar pemain secara otomatis.
  * **Hidden Card:** Kemampuan untuk menyembunyikan satu kartu di tangan dari pengecekan lawan untuk strategi permainan.

---

## Anggota Kelompok

| NIM | Nama |
| :---: | :--- |
| 13525094 | Arga Cyrano Simanjuntak |
| 13525076 | Reinhard Mikhael Tandra |
| 13525024 | Excell Timothy Josua Tarigan |
| 13525072 | Fahrezy Fitriansyah |
