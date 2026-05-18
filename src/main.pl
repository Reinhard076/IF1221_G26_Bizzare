% Integrasi semua file modul
:- include('state.pl').
:- include('deck.pl').
:- include('game_setup.pl').
:- include('player_turn.pl').
:- include('game_info.pl').
:- include('helper.pl').
:- include('action_card.pl').
:- include('validasi.pl').

start :-
    write('Selamat datang di Game UNI!'), nl,
    write('Ketik "startGame." untuk memulai permainan.'), nl.

mainkanKartu(N) :-
    is_game_started(true),
    !,
    eksekusi_mainkan(N).

mainkanKartu(_) :-
    write('Error: Permainan belum dimulai! Gunakan startGame. dulu.'), nl.