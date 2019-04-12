/**
 *  Regra para exibição de valores de uma lista
 *  @param:
 *      L = Lista para ter os valores exibidos
 * 
 **/
exibe_valores_lista([]).
exibe_valores_lista([H|T]):-
    write(H),
    nl,
    exibe_valores_lista(T),!.

/**
 *  Regra para verificar o tamanho de uma lista
 *  @param:
 *      L = Lista para verificar o tamanho
 *      TAM = Tamanho da lista a ser retornado
 * 
 **/
tamanho_lista([],0).
tamanho_lista([_|T],TAM):-
    tamanho_lista(T, T1),
    TAM is T1 + 1.

/**
 *  Regra que encapsula a regra de APPEND para listas,
 *  para o usuário passar um valor e inserí-lo ao final de uma lista
 *  @param:
 *      L = Lista de origem
 *      VAL = Valor a ser inserido ao fim da lista
 *      RESULTADO = Lista resultante
 * 
 **/
insere_lista(L,VAL,RESULTADO):-
    append(L,[VAL], RESULTADO),!.

/**
 *  Regra para exibição de aplicações e valores de duas listas distintas
 *  @param:
 *      L = Lista para ter as aplicações exibidas
 *      L1 = Lista para ter os valores das aplicações exibidos
 * 
 **/
exibe_aplicacao_valor([],[]).
exibe_aplicacao_valor([H|T], [H1|T1]):-
    write("Aplicação: "),
    write(H),
    write(". Valor: R$"),
    write(H1),
    nl,
    exibe_aplicacao_valor(T,T1).

/**
 *  Regra para somar aplicações de uma lista
 *  @param:
 *      L = Lista para ter as aplicações somadas
 *      A = Lista com as aplicações
 *      QT = Lista com os valores das aplicações
 *      SOMA = Variável para retornar a soma
 * 
 **/
soma_aplicacoes([],_,_,0).
soma_aplicacoes([H|T],A,QT,SOMA):-
    pega_aplicacao_valor(H,A,QT,_,VAL),
    soma_aplicacoes(T,A,QT,S1),
    SOMA is S1 + VAL,!.

/**
 *  Regra para pegar aplicações de uma lista
 *  @param:
 *      A = Valor a ser retornado
 *      L = Lista com as aplicações
 *      L1 = Lista com os valores das aplicações
 *      APLIC = Variável com o nome da aplicação a ser retornado
 *      VAL = Variável com o valor da aplicação a ser retornado
 * 
 **/
pega_aplicacao_valor(_, [], [],_,0).
pega_aplicacao_valor(A, [A], [A1],A,A1).
pega_aplicacao_valor(A, [H|_], [H1|_], APLIC, VAL):-
    A = H,
    APLIC = H,
    VAL is H1.
pega_aplicacao_valor(A, [_|T], [_|T1], APLIC, VAL):-
    pega_aplicacao_valor(A, T, T1, APLIC, VAL),!.
