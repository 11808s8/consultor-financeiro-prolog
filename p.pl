
:- dynamic cliente/9.
:- consult(menu).
:- consult(list_utils).
:- consult(input).
:- consult(questionario).
:- consult(graficos).

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
aplicacoes_para_fundo_emergencia([tesouro_selic,cdb]).
% Testei cor a cor até chegar nessas
cores([red,blue,green,yellow,gray,black,brown,cyan,violet]).

% cliente(ronaldinho,5000,1000,5,12,[cdb,poupanca],[1000,20],conservador).
cliente(ronaldinho,7000,1000,1,12,[cdb,poupanca],[1000,20],conservador,500).

minimo_dependente(500).

% @TODO: DEFINIR UM METODO DE EXIBIR DIVERSIFICAÇÃO DE INVESTIMENTOS caso o cliente possua a renda suficiente
% @TODO: OU dizer quanto ele pode investir em cada um.


% @TODO: VERIFICAR SE O CLIENTE JÁ POSSUI UM INVESTIMENTO EM DETERMINADA APLICAÇÃO
%        SE POSSUIR, ADICIONAR MAIS NELA
onde_pode_aplicar(VALOR_INVEST,PRAZO_RETORNO,PERFIL, CLIENTE):-
    cliente(CLIENTE,SALDO,_,DEPENDENTES,_,APLIC,QT_APLIC,_,DESPESA),
    calculo_fundo_emergencia(DEPENDENTES,APLIC,QT_APLIC,DESPESA, SOMA, DESPESA_TOTAL),
    write("SOMA DESPESA"),
    nl,
    write(SOMA),
    nl,
    write(DESPESA_TOTAL),
    nl,
    SOMA < DESPESA_TOTAL,
    FALTA is DESPESA_TOTAL - SOMA,
    write("Faltam R$"),
    write(FALTA),
    write(" para completar seu fundo de emergência!"),
    nl,
    write("É necessário montar/aumentar sua reserva de emergência antes de investir!"),
    nl,
    aplicacoes_para_fundo_emergencia(AFE), 
    retorna_lista_valor_p_investir_menor_saldo(AFE,SALDO,RESULTADO),
    tamanho_lista(RESULTADO,TAM), % ADICIONAR VERIFICAÇÃO PARA TAMANHO
    write("As opções para investimento são: "),
    nl,
    exibe_valores_lista(RESULTADO),
    write("Deseja aplicar diversificado nestas aplicações?(s/n)"),
    nl,
    read(RESPOSTA),
    write(RESPOSTA),
    nl,
    pergunta_aplicar_diversificado_em(RESPOSTA,AFE, CLIENTE, VALOR_INVEST),!.

onde_pode_aplicar(VALOR_INVEST,PRAZO_RETORNO,PERFIL, CLIENTE):-
    nomes_aplicacoes(X),
    cliente(CLIENTE,SALDO,_,DEPENDENTES,_,APLIC,QT_APLIC,_,DESPESA),
    calculo_fundo_emergencia(DEPENDENTES,APLIC,QT_APLIC,DESPESA, SOMA, DESPESA_TOTAL),
    SOMA >= DESPESA_TOTAL,
    write(VALOR_INVEST),
    nl,
    write("Parabéns! Você já possui um montante suficiente em sua reserva de emergência."),
    nl,
    write("As opções para investimento são: "),
    nl,
    verif_pode_aplicar(VALOR_INVEST, PRAZO_RETORNO, PERFIL,X, LISTA_ONDE, _),
    exibe_valores_lista(LISTA_ONDE),
    write("Deseja aplicar diversificado nestas aplicações?(s/n)"),
    nl,
    read(RESPOSTA),
    write(RESPOSTA),
    nl,
    pergunta_aplicar_diversificado_em(RESPOSTA,LISTA_ONDE, CLIENTE, VALOR_INVEST),!.


pergunta_aplicar_diversificado_em(RESPOSTA,LISTA_ONDE, CLIENTE, SALDO):-
    RESPOSTA = s,
    write("Quanto deseja investir?"),
    nl,
    write("Seu saldo é de: R$ "),
    write(SALDO),
    nl,
    read(QUANTO),
    calcula_quanto(LISTA_ONDE, CLIENTE,QUANTO).

pergunta_aplicar_diversificado_em(RESPOSTA,_, _,_):-
    RESPOSTA = n,
    write("Tudo bem! Retornando ao menu"),!.

calcula_quanto(LISTA_ONDE, CLIENTE,QUANTO):-
    cliente(CLIENTE,SALDO,_,_,_,_,_,_,_),
    QUANTO=<SALDO,
    aplicar_diversificado_em(QUANTO,LISTA_ONDE,CLIENTE),
    write("Aplicação realizada com sucesso!").

calcula_quanto(_, CLIENTE,QUANTO):-
    cliente(CLIENTE,SALDO,_,_,_,_,_,_,_),
    QUANTO>SALDO,
    write("Você não possui esta quantia! Seu saldo é de: "),
    write("R$"),
    write(SALDO).

aplicar_diversificado_em(VALOR_INVEST, LISTA_ONDE, CLIENTE):-
    tamanho_lista(LISTA_ONDE, TAM),
    QUANTO_EM_CADA is VALOR_INVEST/TAM,
    cliente(CLIENTE,SAL,REND,DEP,PRAZO,APLIC,QTD_APLIC,P,D),
    % append(APLIC,LISTA_ONDE,APLIC1),
    retract(cliente(CLIENTE,_,_,_,_,_,_,_,_)),
    aplicacoes_lista_cliente(APLIC,QTD_APLIC,LISTA_ONDE,QUANTO_EM_CADA,QTD_RESULTADO,APLIC_RESULTADO),

    SAL1 is SAL - VALOR_INVEST,
    % append(QTD_APLIC,LISTA_VALORES,QT_APLIC_FINAL),
    assert(cliente(CLIENTE,SAL1,REND,DEP,PRAZO,APLIC_RESULTADO,QTD_RESULTADO,P,D)).


%  APLIC - Aplicações do Cliente
%  QTD_APLIC - Valores aplicados do cliente
%  LISTA_ONDE - Lista onde serão aplicados os investimentos
%  VALOR_INVEST - valor a ser investido nas aplicações da lista
%  QTD - Lista com as novas quantidades aplicadas
%  APLIC_RESULTADO - Lista com as novas aplicações
aplicacoes_lista_cliente(APLIC, QTD,[],VALOR_INVEST,QTD,APLIC).
aplicacoes_lista_cliente(APLIC, QTD_APLIC,[ONDE|TONDE],VALOR_INVEST,QTD,APLIC_RESULTADO):-
    member(ONDE,APLIC),
    retorna_lista_valores_atualizados(APLIC,QTD_APLIC,ONDE,VALOR_INVEST,QTD_APLIC1),
    aplicacoes_lista_cliente(APLIC, QTD_APLIC1,TONDE,VALOR_INVEST,QTD,APLIC_RESULTADO),!.
aplicacoes_lista_cliente(APLIC, QTD_APLIC,[ONDE|TONDE],VALOR_INVEST,QTD,APLIC_RESULTADO):-
    not(member(ONDE,APLIC)),
    insere_lista(QTD_APLIC,VALOR_INVEST,QTD1),
    insere_lista(APLIC,ONDE,APLIC1),
    aplicacoes_lista_cliente(APLIC1, QTD1,TONDE,VALOR_INVEST,QTD,APLIC_RESULTADO),!.

retorna_lista_valor_p_investir_menor_saldo([],_,[]).
retorna_lista_valor_p_investir_menor_saldo([H|T],VAL,[H|Result]):- 
    aplicacao(H, _, _,VALOR_INVESTIR, _),
    VALOR_INVESTIR =< VAL,          % se forem iguais, adicionará o valor de H na lista de retorno
    retorna_lista_valor_p_investir_menor_saldo(T,A,VAL,Result),!.                
retorna_lista_valor_p_investir_menor_saldo([H|Tail],VAL,[H|Result]):-  % Coloca o valor normal
    retorna_lista_valor_p_investir_menor_saldo(Tail,VAL,Result).              %prossegue para o filho

retorna_lista_valores_atualizados([],[],_,_,[]).
retorna_lista_valores_atualizados([H|T],[H1|T1],A,VAL,[H2|Result]):- 
    H = A,          % se forem iguais, adicionará o valor dele + VAL em uma variável nova
    H2 is VAL + H1, % e então colocará H2 nesta posição da lista, no retorno
    retorna_lista_valores_atualizados(T,T1,A,VAL,Result),!.                
retorna_lista_valores_atualizados([H|Tail],[H1|T1],A,VAL,[H1|Result]):-  % Coloca o valor normal
    retorna_lista_valores_atualizados(Tail,T1,A,VAL,Result).              %prossegue para o filho


%@TODO: TROCAR ESSE PELO RETORNA_LISTA_VALOR_P_INVESTIR_MENOR_SALDO.
% Retorna uma lista de onde o cliente poderá aplicar
verif_pode_aplicar(_, _, _, [], AUX, AUX).

verif_pode_aplicar(VALOR_INVEST, PRAZO_RETORNO, PERFIL, [H|T], LISTA_ONDE, AUX):-
    aplicacao(H, _, P_R, VAL, PERFIL),
    VALOR_INVEST >= VAL,
    PRAZO_RETORNO >= P_R,
    verif_pode_aplicar(VALOR_INVEST, PRAZO_RETORNO, PERFIL, T, LISTA_ONDE, [H|AUX]),!.

verif_pode_aplicar(VALOR_INVEST, PRAZO_RETORNO, PERFIL, [_|T], LISTA_ONDE, AUX):-
    verif_pode_aplicar(VALOR_INVEST, PRAZO_RETORNO, PERFIL, T, LISTA_ONDE, AUX),!.


valor_minimo_investimento(SALDO,RENDA,DEP):-
    minimo_dependentes(DEP,MIN),
    S1 is RENDA - MIN,
    S2 is SALDO + S1,
    S2 > 30,
    % S2 < 1000,
    write("Parabéns, você possui saldo o suficiente para investir.").

valor_minimo_investimento(SALDO,RENDA,DEP):-
    minimo_dependentes(DEP,MIN),
    S1 is RENDA - MIN,
    S2 is SALDO + S1,
    S2 < 30,
    % S2 < 1000,
    write("Você possui menos que a quantidade suficiente para investir.").

minimo_dependentes(DEP,MIN):-
    minimo_dependente(MIN_DEP),
    MIN is DEP * MIN_DEP.

verifica_fundo_emergencia(_, _, DEPENDENTES, DESPESA, SOBRA, APLIC, QT_APLIC):-
    calculo_fundo_emergencia(DEPENDENTES,APLIC,QT_APLIC,DESPESA, SOMA, DESPESA_TOTAL),
    verififica_fundo_emergencia_comparacao(SOMA,DESPESA_TOTAL,SOBRA).    

calculo_fundo_emergencia(DEPENDENTES,APLIC,QT_APLIC,DESPESA,SOMA,DESPESA_TOTAL):-
    DESPESA_SEIS_MESES is DESPESA * 6,
    minimo_dependentes(DEPENDENTES, MINDEP),
    DESPESA_SEIS_MESES_DEP is MINDEP * 6,
    DESPESA_TOTAL is DESPESA_SEIS_MESES + DESPESA_SEIS_MESES_DEP,
    aplicacoes_para_fundo_emergencia(X),
    soma_aplicacoes(X,APLIC,QT_APLIC,SOMA),
    write(SOMA),
    nl. % se falhar, recomendar investir 

verififica_fundo_emergencia_comparacao(SOMA,DESPESA_TOTAL,SOBRA):-
    SOMA >= DESPESA_TOTAL,
    SOBRA is SOMA - DESPESA_TOTAL,
    write("Parabéns, você possui um fundo de emergência com "),
    write(SOBRA),
    write(" de diferença do mínimo que precisaria para sobreviver por seis meses!"). % aqui avisar que pode investir em mais??

verififica_fundo_emergencia_comparacao(SOMA,DESPESA_TOTAL,FALTAM):-
    SOMA < DESPESA_TOTAL,
    FALTAM is DESPESA_TOTAL - SOMA,
    write("Que pena! Faltam "),
    write(FALTAM),
    write(" reais para você atingir seu fundo de emergência!"). % aqui avisar que pode investir em mais??




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

quanto_lucrarei(C):-
    cliente(C,_,_,_,_,APLIC,QTD_APLIC,_,_),
    verifica_todas_aplicacoes_lucro(APLIC,QTD_APLIC).

verifica_todas_aplicacoes_lucro([],_).
verifica_todas_aplicacoes_lucro([H|T],[H1|T1]):-
    aplicacao(H,REND,MESES,_,_),
    V is H1 * REND,
    write("Lucro para "),
    write(H),
    write(": R$ "),
    write(V),
    nl,
    verifica_todas_aplicacoes_lucro(T,T1).

