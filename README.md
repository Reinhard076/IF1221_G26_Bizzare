# Tugas Besar IF1221 Logika Komputasional - Game UNI

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
    └── endgame.pl      
```

---

## 👥 Anggota Kelompok

Silakan isi identitas anggota kelompok beserta persentase kontribusi di bawah ini:

| NIM | Nama | Fokus Utama / Spesifikasi Tugas | Kontribusi (%) |
| :---: | :--- | :--- | :---: |
| 135xxxx1 | [Nama Anggota 1] | Core System, Game State, & Validasi Kartu | XX% |
| 135xxxx2 | [Nama Anggota 2] | Game Inisialisasi, Setup Pemain, & Efek Action Cards | XX% |
| 135xxxx3 | [Nama Anggota 3] | Turn Mechanism, Aturan Khusus (UNI, Tangkap, Tantang) | XX% |
| 135xxxx4 | [Nama Anggota 4] | Game UI, Info System, Endgame, & Scoring | XX% |
