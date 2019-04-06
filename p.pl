
% :- dynamic cliente/2.
:- consult(menu).
:- consult(list_utils).
:- consult(input).
:- consult(questionario).



% cliente(nome,
%         saldo,
%         renda_mensal, 
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
aplicacao(lci, 6, 36, 5000, agressivo).
aplicacao(tesouro_selic,1, 0, 30, conservador).
aplicacao(tesouro_ipca, 5, 12,1000, moderado).
aplicacao(poupanca, 0, 999,0, nao_recomendado).
nomes_aplicacoes([cdb,lci, tesouro_selic, tesouro_ipca, poupanca]).

% cliente(ronaldinho,5000,1000,5,12,[cdb,poupanca],[1000,20],conservador).
cliente(ronaldinho,5000,1000,5,12,[cdb,poupanca],[1000,20],conservador,500).


% @TODO: DEFINIR UM METODO DE EXIBIR DIVERSIFICAÇÃO DE INVESTIMENTOS caso o cliente possua a renda suficiente
% @TODO: OU dizer quanto ele pode investir em cada um.

% Retorna uma lista de onde o cliente poderá aplicar
verif_pode_aplicar(_, _, _, [], AUX, AUX).

verif_pode_aplicar(VALOR_INVEST, PRAZO_RETORNO, PERFIL, [H|T], LISTA_ONDE, AUX):-
    aplicacao(H, _, PRAZO_RETORNO, VAL, PERFIL),
    VALOR_INVEST > VAL,
    verif_pode_aplicar(VALOR_INVEST, PRAZO_RETORNO, PERFIL, T, LISTA_ONDE, [H|AUX]),!.

verif_pode_aplicar(VALOR_INVEST, PRAZO_RETORNO, PERFIL, [_|T], LISTA_ONDE, AUX):-
    verif_pode_aplicar(VALOR_INVEST, PRAZO_RETORNO, PERFIL, T, LISTA_ONDE, AUX),!.

onde_pode_aplicar(VALOR_INVEST,PRAZO_RETORNO,PERFIL):-
    nomes_aplicacoes(X),
    verif_pode_aplicar(VALOR_INVEST, PRAZO_RETORNO, PERFIL,X, LISTA_ONDE, _),
    exibe_valores_lista(LISTA_ONDE).

exibe_aplicacao_valor([],[]).
exibe_aplicacao_valor([H|T], [H1|T1]):-
    write("Aplicação: "),
    write(H),
    write(". Valor: R$"),
    write(H1),
    nl,
    exibe_aplicacao_valor(T,T1).

% nao esta aplicando
verifica_aplicacoes(C):-
    cliente(C,_,_,_,_, T,_,_,_),
    write(T),
    nl,
    exibe_valores_lista(T),
    nl,
    tamanho_lista(T,TAM),
    TAM = 0,
    write(TAM).

v_ronaldinho():-
    cliente(ronaldinho,S,R, D, _, _, _, _,_),
    valor_minimo_investimento(S,R,D).

valor_minimo_investimento(SALDO,RENDA,DEP):-
    minimo_dependentes(DEP,MIN),
    S1 is RENDA - MIN,
    S2 is SALDO + S1,
    S2 > 30,
    % S2 < 1000,
    write("Parabéns, você possui saldo o suficiente para investir.").

minimo_dependentes(DEP,MIN):-
    MIN is DEP * 1500.

% exibe_renda_adequada(C):-


verifica_fundo_emergencia(_, _, DEPENDENTES, DESPESA, SOBRA, APLIC, QT_APLIC):-
    DESPESA_SEIS_MESES is DESPESA * 6,
    minimo_dependentes(DEPENDENTES, MINDEP),
    DESPESA_SEIS_MESES_DEP is MINDEP * 6,
    DESPESA_TOTAL is DESPESA_SEIS_MESES + DESPESA_SEIS_MESES_DEP,
    soma_aplicacoes([cdb,tesouro_selic],APLIC,QT_APLIC,SOMA), % se falhar, recomendar investir 
    SOBRA is SOMA - DESPESA_TOTAL,
    SOMA > DESPESA_TOTAL,
    write("Parabéns, você possui um fundo de emergência com "),
    write(SOBRA),
    write(" de diferença do mínimo que precisaria para sobreviver por seis meses!"). % aqui avisar que pode investir em mais??


%se tiver saldo, avisar que poderia aplicar nestas aplicações (as de perfil de emergência)
verifica_fundo_emergencia(_, _, DEPENDENTES, DESPESA, SOBRA,APLIC, QT_APLIC):-
    DESPESA_SEIS_MESES is DESPESA * 6,
    minimo_dependentes(DEPENDENTES, MINDEP),
    DESPESA_SEIS_MESES_DEP is MINDEP * 6,
    DESPESA_TOTAL is DESPESA_SEIS_MESES + DESPESA_SEIS_MESES_DEP,
    soma_aplicacoes([cdb,tesouro_selic],APLIC,QT_APLIC,SOMA), % se falhar, recomendar investir 
    SOBRA is DESPESA_TOTAL - SOMA,
    SOMA < DESPESA_TOTAL,
    write("Que pena! Faltam "),
    write(SOBRA),
    write(" reais para você atingir seu fundo de emergência!"). % aqui avisar que pode investir em mais??
    
ronal():-
    cliente(ronaldinho,SALDO, R_A, DEP, _, APLIC, QT_APLIC, _, DESP),
    % pega_aplicacao_valor(cdb, APLIC, QT_APLIC, A, V),
    % write(A),
    % nl,
    % write(V),
    % soma_aplicacoes([cdb,tesouro_selic],APLIC,QT_APLIC,SOMA),
    % nl,
    verifica_fundo_emergencia(SALDO, R_A, DEP, DESP, _, APLIC, QT_APLIC).
    % write(SOMA).

soma_aplicacoes([],_,_,0).
soma_aplicacoes([H|T],A,QT,SOMA):-
    pega_aplicacao_valor(H,A,QT,_,VAL),
    soma_aplicacoes(T,A,QT,S1),
    SOMA is S1 + VAL.

pega_aplicacao_valor(_, [], [],_,0).
pega_aplicacao_valor(A, [A], [A1],A,A1).
pega_aplicacao_valor(A, [H|_], [H1|_], APLIC, VAL):-
    A = H,
    APLIC = H,
    VAL is H1.
pega_aplicacao_valor(A, [_|T], [_|T1], APLIC, VAL):-
    pega_aplicacao_valor(A, T, T1, APLIC, VAL).



exibe_aplicacoes_valores_cliente(C):-
    cliente(C,_,_,_,_, T, QT,_,_),
    write("Você está investindo em: "),
    nl,
    exibe_aplicacao_valor(T,QT).


exibe_info(X):-
    write(X),
    nl,
    cliente(X,Y,_,_,_,_,_,_,_),
    write(Y).
