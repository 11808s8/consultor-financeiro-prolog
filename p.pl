
:- dynamic cliente/9.
:- consult(menu).
:- consult(list_utils).
% :- consult(input).
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

/**
 * Regra
 * 
 * 
 * 
 * 
 * 
**/

% @TODO: VERIFICAR SE O CLIENTE JÁ POSSUI UM INVESTIMENTO EM DETERMINADA APLICAÇÃO
%        SE POSSUIR, ADICIONAR MAIS NELA
onde_pode_aplicar(VALOR_INVEST,_,_, CLIENTE):-
    cliente(CLIENTE,SALDO,_,DEPENDENTES,_,APLIC,QT_APLIC,_,DESPESA),
    calculo_fundo_emergencia(DEPENDENTES,APLIC,QT_APLIC,DESPESA, SOMA, DESPESA_TOTAL),
    SOMA < DESPESA_TOTAL,
    FALTA is DESPESA_TOTAL - SOMA,
    write("Sinto muito, "),
    write(CLIENTE),
    write(". Faltam R$ "),
    write(FALTA),
    write(" para completar seu fundo de emergência!"),
    nl,
    write("É necessário montar/aumentar sua reserva de emergência antes de investir!"),
    nl,
    aplicacoes_para_fundo_emergencia(AFE), 
    retorna_lista_valor_p_investir_menor_saldo(AFE,SALDO,RESULTADO),
    tamanho_lista(RESULTADO,TAM), %@TODO: ADICIONAR VERIFICAÇÃO PARA TAMANHO como a abaixo.
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
    cliente(CLIENTE,_,_,DEPENDENTES,_,APLIC,QT_APLIC,_,DESPESA),
    calculo_fundo_emergencia(DEPENDENTES,APLIC,QT_APLIC,DESPESA, SOMA, DESPESA_TOTAL),
    SOMA >= DESPESA_TOTAL,
    write(VALOR_INVEST),
    nl,
    write("Parabéns! Você já possui um montante suficiente em sua reserva de emergência."),
    nl,
    write("As opções para investimento são: "),
    nl,
    nomes_aplicacoes(NOMES_APLICACOES),
    verif_pode_aplicar(VALOR_INVEST, PRAZO_RETORNO, PERFIL,NOMES_APLICACOES, LISTA_ONDE, _),
    tamanho_lista(LISTA_ONDE,TAM), 
    verificacao_tamanho_lista_pode_aplicar(TAM,LISTA_ONDE,CLIENTE,VALOR_INVEST),!.
    
/**
 * Regra que valida se há aplicações para o usuário investir
 * com base em uma comparação com o tamanho da lista de investimentos possíveis.
 * @param:
 *      TAM = (int) Tamanho da lista de possíveis investimentos
 *      LISTA_ONDE = Lista de aplicações onde o cliente fará os investimentos
 *      CLIENTE = nome do cliente
 *      VALOR_INVEST = (int/float) quantia a ser investida
 * 
**/
verificacao_tamanho_lista_pode_aplicar(TAM,LISTA_ONDE,CLIENTE,VALOR_INVEST):-
    TAM>0,
    exibe_valores_lista(LISTA_ONDE),
    write("Deseja aplicar diversificado nestas aplicações?(s/n)"),
    nl,
    read(RESPOSTA),
    write(RESPOSTA),
    nl,
    pergunta_aplicar_diversificado_em(RESPOSTA,LISTA_ONDE, CLIENTE, VALOR_INVEST),!.
verificacao_tamanho_lista_pode_aplicar(TAM,LISTA_ONDE,CLIENTE,VALOR_INVEST):-
    TAM=<0,
    write("Não é possível investir em sequer uma aplicação!"),
    nl,
    write("Retornando ao menu."),
    nl,!.

/**
 * Regra que verifica a resposta do cliente sobre aplicar 
 * ou não diversificadamente seus valores.
 * @param:
 *      RESPOSTA = RESPOSTA (s/n) do usuário
 *      LISTA_ONDE = Lista de aplicações onde o cliente fará os investimentos
 *      CLIENTE = nome do cliente
 *      SALDO = (int/float) saldo do cliente no banco
**/
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

/**
 * Regra que calcula se o cliente pode efetivamente
 * realizar algum investimento em uma aplicação com base no quanto informou e seu saldo
 * @param:
 *      LISTA_ONDE = Lista de aplicações onde o cliente fará os investimentos
 *      CLIENTE = nome do cliente
 *      QUANTO = (int/float) Valor informado pelo usuário para realizar investimentos
 * 
**/
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

/**
 * Regra que realiza a aplicação diversificada do 
 * cliente em múltiplas aplicações, com base no valor passado.
 * @param:
 *      VALOR_INVEST = (int/float) valor TOTAL a ser investido em aplicação
 *      LISTA_ONDE = Lista de aplicações onde o cliente fará os investimentos
 *      CLIENTE = nome do cliente
 * 
**/
aplicar_diversificado_em(VALOR_INVEST, LISTA_ONDE, CLIENTE):-
    tamanho_lista(LISTA_ONDE, TAM),
    QUANTO_EM_CADA is VALOR_INVEST/TAM,
    cliente(CLIENTE,SAL,REND,DEP,PRAZO,APLIC,QTD_APLIC,P,D),
    retract(cliente(CLIENTE,_,_,_,_,_,_,_,_)),
    aplicacoes_lista_cliente(APLIC,QTD_APLIC,LISTA_ONDE,QUANTO_EM_CADA,QTD_RESULTADO,APLIC_RESULTADO),
    SAL1 is SAL - VALOR_INVEST,
    assert(cliente(CLIENTE,SAL1,REND,DEP,PRAZO,APLIC_RESULTADO,QTD_RESULTADO,P,D)).

/**
 *  Regra que atualiza a lista de valores com dois tipos de regras:
 *      Se uma aplicação já faz parte da lista de aplicações do cliente, atualiza o valor dela
 *      Se uma aplicação não faz parte da lista, insere ela na lista (e seu valor na lista de valores)
 *      As listas novas são retornadas nas variáveis APLIC_RESULTADO (Lista com nomes das aplicações) e QTD (lista com valores aplicados)
 * @param:
 *      APLIC = Lista com os nomes das aplicações do Cliente
 *      QTD_APLIC = Lista com valores aplicados do cliente
 *      LISTA_ONDE = Lista onde serão aplicados os investimentos
 *      VALOR_INVEST = (int/float) valor a ser investido nas aplicações da lista
 *      QTD = Lista com as novas quantidades aplicadas
 *      APLIC_RESULTADO = Lista com as novas aplicações
 * 
**/
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

/**
 * Regra que retorna uma lista de valores 
 * atualizados com a adição do valor anterior 
 *              pelo valor de investimento.
 * @param:
 *      LISTA_NOME_APLICACOES = Lista com o nome das aplicações a serem comaprados
 *      LISTA_VALOR_APLICADO_APLICACOES = Lista com o valor das aplicações a serem alterados
 *      A = Variável que será comparada com o nome das aplicações para verificar se ALTERA ou não seu valor
 *      VAL = (int/float) Variável com o VALOR que será adicionado ao valor de uma aplicação caso ela seja a aplicação buscada.
 *      LISTA_RESULTADO = Lista com o resultado da lista de valores alterada
**/
retorna_lista_valores_atualizados([],[],_,_,[]).
retorna_lista_valores_atualizados([H|T],[H1|T1],A,VAL,[H2|Result]):- 
    H = A,          % se forem iguais, adicionará o valor dele + VAL em uma variável nova
    H2 is VAL + H1, % e então colocará H2 nesta posição da lista, no retorno
    retorna_lista_valores_atualizados(T,T1,A,VAL,Result),!.                
retorna_lista_valores_atualizados([H|Tail],[H1|T1],A,VAL,[H1|Result]):-  % Coloca o valor normal
    retorna_lista_valores_atualizados(Tail,T1,A,VAL,Result).              %prossegue para o filho


/**
 * 
 * 
 * 
 * 
 * 
 * 
 * 
**/

retorna_lista_valor_p_investir_menor_saldo([],_,[]).
retorna_lista_valor_p_investir_menor_saldo([H|T],VAL,[H|Result]):- 
    aplicacao(H, _, _,VALOR_INVESTIR, _),
    VALOR_INVESTIR =< VAL,          % se forem iguais, adicionará o valor de H na lista de retorno
    retorna_lista_valor_p_investir_menor_saldo(T,VAL,Result),!.                
retorna_lista_valor_p_investir_menor_saldo([H|Tail],VAL,[H|Result]):-  % Coloca o valor normal
    retorna_lista_valor_p_investir_menor_saldo(Tail,VAL,Result).              %prossegue para o filh


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

/**
 * Regra que verifica o valor mínimo para um investimento. Se possuir, exibe uma mensagem adequada.
 * @param:
 *      SALDO = (int/float) Quanto o cliente possui de saldo no banco
 *      RENDA = (int/float) Renda do cliente
 *      DEP = (int) Quantidade de dependentes que o cliente possui
**/
valor_minimo_investimento(SALDO,RENDA,DEP):-
    minimo_dependentes(DEP,MIN),
    S1 is RENDA - MIN,
    S2 is SALDO + S1,
    S2 > 30,
    write("Parabéns, você possui saldo o suficiente para investir.").


/**
 * Regra que verifica o valor mínimo para um investimento. Se não possuir, exibe uma mensagem adequada.
 * @param:
 *      SALDO = (int/float) Quanto o cliente possui de saldo no banco
 *      RENDA = (int/float) Renda do cliente
 *      DEP = (int) Quantidade de dependentes que o cliente possui
**/
valor_minimo_investimento(SALDO,RENDA,DEP):-
    minimo_dependentes(DEP,MIN),
    S1 is RENDA - MIN,
    S2 is SALDO + S1,
    S2 < 30,
    write("Você possui menos que a quantidade suficiente para investir. O mínimo é 30 reais para o tesouro_selic.").


/**
 * Regra que verifica a renda mínima necessária 
 * para a quantidade de dependentes que um cliente possui 
 * @param:
 *      DEP = (int) Quantidade de dependentes que um cliente possui
 *      MIN = (int/float) Variável com a renda mínima necessária para a quantidade de dependentes
**/
minimo_dependentes(DEP,MIN):-
    minimo_dependente(MIN_DEP),
    MIN is DEP * MIN_DEP.


/**
 * Regra intermediária que primeiro executa 
 * o cálculo para o fundo de emergência
 * e então passa as variáveis necessárias 
 * para a regra de verificação se o cliente
 * possui um fundo de emergência adequado.
 * @param:
 *      DEPENDENTES = (int) quantidade de dependentes que um cliente possui
 *       DESPESA = (int/float) despesa mensal do cliente
 *       SOBRA = (int/float) variável com o retorno da verificação de fundo de emergência
 *       APLIC = Lista com nomes de aplicações que um cliente está investindo
 *       QT_APLIC = Lista com valores de aplicações que um cliente está investindo
 * 
**/
verifica_fundo_emergencia( DEPENDENTES, DESPESA, SOBRA, APLIC, QT_APLIC):-
    calculo_fundo_emergencia(DEPENDENTES,APLIC,QT_APLIC,DESPESA, SOMA, DESPESA_TOTAL),
    verififica_fundo_emergencia_comparacao(SOMA,DESPESA_TOTAL,SOBRA).    

/**
 * Regra que calcula o valor das variáveis 
 * para a verificação se o cliente está adequado
 * ou não aos investimentos para caracterizar o
 * fundo de emergência.
 * @param:
 *      DEPENDENTES = (int) Quantidade de dependentes que um cliente tem
 *      APLIC = Lista com nomes de aplicações que um cliente está investindo
 *      QT_APLIC = Lista com valores de aplicações que um cliente está investindo
 *      DESPESA = (int/float) Despesa mensal de um cliente
 *      SOMA = (int/float) Soma de todas as aplicações 
 *      DESPESA_TOTAL = (int/float) Despesa total da família (cliente + dependentes) para 6 meses
**/
calculo_fundo_emergencia(DEPENDENTES,APLIC,QT_APLIC,DESPESA,SOMA,DESPESA_TOTAL):-
    DESPESA_SEIS_MESES is DESPESA * 6,
    minimo_dependentes(DEPENDENTES, MINDEP),
    DESPESA_SEIS_MESES_DEP is MINDEP * 6,
    DESPESA_TOTAL is DESPESA_SEIS_MESES + DESPESA_SEIS_MESES_DEP,
    aplicacoes_para_fundo_emergencia(X),
    soma_aplicacoes(X,APLIC,QT_APLIC,SOMA),
    nl. 

/**
 * Regra que verifica se o valor passado em receita é 
 * maior que a despesa total de uma família. Se for maior,
 * atrela à variável SOBRA a quantidade de renda que resta
 * após a subtração das despesas da família e exibe uma mensagem na tela.
 * 
 * @params:
 *      RECEITA = (int/float)  receita de uma família
 *      DESPESA_TOTAL = (int/float) despesa total de uma família (ao longo de seis meses)
 *      SOBRA = resultado de RECEITA - DESPESA_TOTAL 
**/
verififica_fundo_emergencia_comparacao(RECEITA,DESPESA_TOTAL,SOBRA):-
    RECEITA >= DESPESA_TOTAL,
    SOBRA is RECEITA - DESPESA_TOTAL,
    write("Parabéns, você possui um fundo de emergência com "),
    write(SOBRA),
    write(" de diferença do mínimo que precisaria para sobreviver por seis meses!"). % aqui avisar que pode investir em mais??


/**
 * Regra que verifica se o valor passado em receita é 
 * menor que a despesa total de uma família. Se for menor,
 * atrela à variável FALTAM o quanto falta para a receita 
 * alcançar a despesa e exibe uma mensagem na tela.
 * 
 * @params:
 *      RECEITA = (int/float)  receita de uma família
 *      DESPESA_TOTAL = (int/float)  despesa total de uma família (ao longo de seis meses)
 *      FALTAM = resultado de DESPESA_TOTAL - RECEITA 
**/
verififica_fundo_emergencia_comparacao(RECEITA,DESPESA_TOTAL,FALTAM):-
    RECEITA < DESPESA_TOTAL,
    FALTAM is DESPESA_TOTAL - RECEITA,
    write("Que pena! Faltam "),
    write(FALTAM),
    write(" reais para você atingir seu fundo de emergência!"). % aqui avisar que pode investir em mais??


/**
 * Regra que exibe as aplicações do cliente textualmente e por meio de um gráfico
 * A ordem exibida é nome aplicação -> valor aplicado
 * @param:
 *  C = nome do cliente
 **/
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

/**
 *  Regra intermediária para a verificação de lucro nas aplicações de um cliente
 *  @params:
 *      C = nome do cliente
 * 
**/
quanto_lucrarei(C):-
    cliente(C,_,_,_,_,APLIC,QTD_APLIC,_,_),
    verifica_todas_aplicacoes_lucro(APLIC,QTD_APLIC).

/**
 *  Regra que busca e escreve o nome da aplicação e 
 *  o quanto essa aplicação irá gerar de lucro ao fim 
 *                         do seu prazo de rendimento.
 * 
 *  A regra recebe duas listas e elas PRECISAM estar na mesma ordem para fazer sentido.
 *  E.g.: Se investi 2000 reais em cdb e 1000 reais em tesouro_selic, as listas serão
 *          [cdb, tesouro_selic]
 *          [2000, 1000] 
 *  @params:
 *      LISTA_APLICAÇÕES (Parametro 1) = Lista com o nome de aplicações
*      LISTA_VALOR_APLICADO (Parametro 2) = Lista com o valor de aplicações
**/
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

