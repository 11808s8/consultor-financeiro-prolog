
:- dynamic cliente/9.
:- consult(menu).
:- consult(list_utils).
:- consult(input).
:- consult(questionario).

% @TODO MASSIVE: COLOCAR A PORCENTAGEM DA APLICACAO QUE VAI AUMENTAR.
%  POR EXEMPLO CDB 1.2 AI QUANDO O CARA APLICA AVISA PRA ELE QUE ELE TERA UM LUCRO DE ... DEPOIS DE X
%  MESES!


% cliente(nome,
%         saldo,
%         renda_mensal, 
%         dependentes,
%         prazo_retorno_investimento,
%         [aplicacoes],
%         [quantia_aplicada_em_cada_aplicacao],
%         perfil,
%         DESPESA)

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

% Testei cor a cor até chegar nessas
cores([red,blue,green,yellow,gray,black,brown,cyan,violet]).

% cliente(ronaldinho,5000,1000,5,12,[cdb,poupanca],[1000,20],conservador).
cliente(ronaldinho,5000,1000,5,12,[cdb,poupanca],[1000,20],conservador,500).


% @TODO: DEFINIR UM METODO DE EXIBIR DIVERSIFICAÇÃO DE INVESTIMENTOS caso o cliente possua a renda suficiente
% @TODO: OU dizer quanto ele pode investir em cada um.


% @TODO: VERIFICAR SE O CLIENTE JÁ POSSUI UM INVESTIMENTO EM DETERMINADA APLICAÇÃO
%        SE POSSUIR, ADICIONAR MAIS NELA
onde_pode_aplicar(VALOR_INVEST,PRAZO_RETORNO,PERFIL, CLIENTE):-
    nomes_aplicacoes(X),
    verif_pode_aplicar(VALOR_INVEST, PRAZO_RETORNO, PERFIL,X, LISTA_ONDE, _),
    exibe_valores_lista(LISTA_ONDE),
    write("Deseja aplicar diversificado nestas aplicações?(S/N)"),
    nl,
    read(RESPOSTA),
    pergunta_aplicar_diversificado_em(RESPOSTA,LISTA_ONDE, CLIENTE).

pergunta_aplicar_diversificado_em(RESPOSTA,LISTA_ONDE, CLIENTE):-
    RESPOSTA = "S",
    write("Quanto deseja investir?"),
    nl,
    read(QUANTO),
    calcula_quanto(LISTA_ONDE, CLIENTE,QUANTO).

pergunta_aplicar_diversificado_em(RESPOSTA,LISTA_ONDE, CLIENTE):-
    RESPOSTA = "N",
    write("Tudo bem! Retornando ao menu").

calcula_quanto(LISTA_ONDE, CLIENTE,QUANTO):-
    cliente(CLIENTE,SALDO,_,_,_,_,_,_,_),
    QUANTO=<SALDO,
    aplicar_diversificado_em(QUANTO,LISTA_ONDE,CLIENTE),
    write("Aplicação realizada com sucesso!").
calcula_quanto(LISTA_ONDE, CLIENTE,QUANTO):-
    cliente(CLIENTE,SALDO,_,_,_,_,_,_,_),
    QUANTO>SALDO,
    write("Você não possui esta quantia! Seu saldo é de: "),
    write("R$"),
    write(SALDO).

aplicar_diversificado_em(VALOR_INVEST, LISTA_ONDE, CLIENTE):-
    tamanho_lista(LISTA_ONDE, TAM),
    QUANTO_EM_CADA is VALOR_INVEST/TAM,
    cliente(CLIENTE,SAL,REND,DEP,PRAZO,APLIC,QT_APLIC,P,D),
    append(APLIC,LISTA_ONDE,APLIC1),
    retract(cliente(CLIENTE,_,_,_,_,_,_,_,_)),
    insere_investimento_lista(LISTA_ONDE,LISTA_VALORES,QUANTO_EM_CADA),
    SAL1 is SAL - VALOR_INVEST,
    append(QT_APLIC,LISTA_VALORES,QT_APLIC_FINAL),
    assert(cliente(CLIENTE,SAL1,REND,DEP,PRAZO,APLIC1,QT_APLIC_FINAL,P,D)).

insere_investimento_lista([],[],_).
insere_investimento_lista([H|T], AUX,VAL):-
    insere_investimento_lista(T, AUX1,VAL),
    insere_lista(AUX1,VAL,AUX).

% Retorna uma lista de onde o cliente poderá aplicar
verif_pode_aplicar(_, _, _, [], AUX, AUX).

verif_pode_aplicar(VALOR_INVEST, PRAZO_RETORNO, PERFIL, [H|T], LISTA_ONDE, AUX):-
    aplicacao(H, _, P_R, VAL, PERFIL),
    VALOR_INVEST > VAL,
    PRAZO_RETORNO >= P_R,
    verif_pode_aplicar(VALOR_INVEST, PRAZO_RETORNO, PERFIL, T, LISTA_ONDE, [H|AUX]),!.

verif_pode_aplicar(VALOR_INVEST, PRAZO_RETORNO, PERFIL, [_|T], LISTA_ONDE, AUX):-
    verif_pode_aplicar(VALOR_INVEST, PRAZO_RETORNO, PERFIL, T, LISTA_ONDE, AUX),!.

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
    verififica_fundo_emergencia_comparacao(SOMA,DESPESA_TOTAL,SOBRA).    

verififica_fundo_emergencia_comparacao(SOMA,DESPESA_TOTAL,SOBRA):-
    SOMA > DESPESA_TOTAL,
    SOBRA is SOMA - DESPESA_TOTAL,
    write("Parabéns, você possui um fundo de emergência com "),
    write(SOBRA),
    write(" de diferença do mínimo que precisaria para sobreviver por seis meses!"). % aqui avisar que pode investir em mais??

verififica_fundo_emergencia_comparacao(SOMA,DESPESA_TOTAL,SOBRA):-
    SOMA < DESPESA_TOTAL,
    SOBRA is DESPESA_TOTAL - SOMA,
    write("Que pena! Faltam "),
    write(SOBRA),
    write(" reais para você atingir seu fundo de emergência!"). % aqui avisar que pode investir em mais??

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
    exibe_aplicacao_valor(T,QT),
    nl,
    cores(CORES),
    monta_barras(T,QT,CORES,LISTA_FINAL),
    nomes_aplicacoes(X),
    soma_aplicacoes(X,T,QT,SOMA),
    grafico_aplicacoes(LISTA_FINAL,SOMA).

exibe_info(X):-
    write(X),
    nl,
    cliente(X,Y,_,_,_,_,_,_,_),
    write(Y).


grafico_aplicacoes(LISTA_MEMBROS,TOTAL) :-
    new(W,  auto_sized_picture('Respostas do Questionário')),
    send(W, display, new(BC, bar_chart(horizontal,0,TOTAL))),
    forall(member(Name/Height/Color,
              LISTA_MEMBROS),
           (   new(B, bar(Name, Height)),
               send(B, colour(Color)),
               send(BC, append, B)
           )),
    send(W, open).

% monta_barras(LISTA_NOMES_APLICACOES, LISTA_QUANTIDADE_APLICACOES, LISTA_NOMES_CORES, LISTA_FINAL):-
monta_barras([], _, _, _).
monta_barras([H|T], [H1|T1], [H2|T2], LISTA_FINAL):-
    monta_barras(T,T1,T2,LISTA_FINAL1),
    append(LISTA_FINAL1,[H/H1/H2],LISTA_FINAL). 
