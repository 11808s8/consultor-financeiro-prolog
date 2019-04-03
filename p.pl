
% :- dynamic cliente/2.

teste():-
    write("Olá mundo").


menu():-
    nl,
    write(" Menu do programa: "),
    nl,
    write(" Digite a opção que deseja escolher."),
    nl,
    write(" 1 - Exibir as aplicações em que um cliente está investindo"),
    nl,
    write("SEGURE ctrl + D para sair."),
    read(X),
    opc(X),
    menu().

opc(X):-
    X = 1,
    write("Digite o nome do cliente. Exemplo: ronaldinho_gaucho."),
    read(C),
    valida_nome_cliente(C),
    exibe_aplicacoes_valores_cliente(C).
    
valida_nome_cliente(C):-
    cliente(C,_,_,_,_,_,_,_).

% cliente(nome,
%         saldo,
%         renda_anual, 
%         dependentes,
%         prazo_retorno_investimento,
%         [aplicacoes],
%         [quantia_aplicada_em_cada_aplicacao],
%         perfil)

% aplicacao(nome,
            % rendimento,
            % prazo_retorno,
            % quantia_minima,
            % perfil)

%  @TODO: Substituir estes valores com os valores reais (se nao forem os reais, estipular alguns)
aplicacao(cdb, 6, 36, 5000, agressivo).
aplicacao(tesouro_selic,1, 0, 30, conservador).
aplicacao(tesouro_ipca, 5, 12,1000, moderado).
aplicacao(poupanca, 0, 999,0, nao_recomendado).
nomes_aplicacoes([cdb, tesouro_selic, tesouro_ipca, poupanca]).

cliente(ronaldinho,5000,1000,5,12,[cdb,poupanca],[1000,20],conservador).

verif_pode_aplicar(VALOR_INVEST, PERFIL, [H|T]):-
    

onde_pode_aplicar(VALOR_INVEST,PERFIL):-


exibe_valores_lista([]).
exibe_valores_lista([H|T]):-
    write(H),
    nl,
    exibe_valores_lista(T).

exibe_aplicacao_valor([],[]).
exibe_aplicacao_valor([H|T], [H1|T1]):-
    write("Aplicação: "),
    write(H),
    write(". Valor: R$"),
    write(H1),
    nl,
    exibe_aplicacao_valor(T,T1).

tamanho_lista([],0).
tamanho_lista([H|T],TAM):-
    tamanho_lista(T, T1),
    TAM is T1 + 1.

% nao esta aplicando
verifica_aplicacoes(C):-
    cliente(C,S,R, D, P, T, QT, PERF),
    write(T),
    nl,
    exibe_valores_lista(T),
    nl,
    tamanho_lista(T,TAM),
    TAM = 0,
    write(TAM).

v_ronaldinho():-
    cliente(ronaldinho,S,R, D, P, T, QT, PERF),
    valor_minimo_perfil_moderado(S,R,D).

valor_minimo_investimento(SALDO,RENDA,DEP):-
    minimo_dependentes(DEP,MIN),
    S1 is RENDA - MIN,
    S2 is SALDO + S1,
    S2 > 30,
    S2 < 1000,
    write("Parabéns, você possui saldo o suficiente para investir.").

minimo_dependentes(DEP,MIN):-
    MIN is DEP * 1500.

% exibe_renda_adequada(C):-


exibe_aplicacoes_valores_cliente(C):-
    cliente(C,_,_,_,_, T, QT,_),
    write("Você está investindo em: "),
    nl,
    exibe_aplicacao_valor(T,QT).


le_cliente():-
    write("Digite o nome do cliente"),
    nl,
    read(X),
    write("Digite quanto ele possui de saldo no banco"),
    nl,
    read(Y),
    assertz(cliente(X,Y)),
    exibe_info(X).

exibe_info(X):-
    write(X),
    nl,
    cliente(X,Y),
    write(Y).
