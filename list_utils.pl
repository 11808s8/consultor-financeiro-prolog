
exibe_valores_lista([]).
exibe_valores_lista([H|T]):-
    write(H),
    nl,
    exibe_valores_lista(T),!.

tamanho_lista([],0).
tamanho_lista([_|T],TAM):-
    tamanho_lista(T, T1),
    TAM is T1 + 1.

% insere_lista([],X,[X]).
insere_lista(L,VAL,RESULTADO):-
    append(L,[VAL], RESULTADO),!.
