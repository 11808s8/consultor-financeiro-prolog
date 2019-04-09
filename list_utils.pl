
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

exibe_aplicacao_valor([],[]).
exibe_aplicacao_valor([H|T], [H1|T1]):-
    write("Aplicação: "),
    write(H),
    write(". Valor: R$"),
    write(H1),
    nl,
    exibe_aplicacao_valor(T,T1).

soma_aplicacoes([],_,_,0).
soma_aplicacoes([H|T],A,QT,SOMA):-
    pega_aplicacao_valor(H,A,QT,_,VAL),
    soma_aplicacoes(T,A,QT,S1),
    SOMA is S1 + VAL,!.

pega_aplicacao_valor(_, [], [],_,0).
pega_aplicacao_valor(A, [A], [A1],A,A1).
pega_aplicacao_valor(A, [H|_], [H1|_], APLIC, VAL):-
    A = H,
    APLIC = H,
    VAL is H1.
pega_aplicacao_valor(A, [_|T], [_|T1], APLIC, VAL):-
    pega_aplicacao_valor(A, T, T1, APLIC, VAL),!.
