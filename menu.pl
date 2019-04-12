
/**
 * 
 * Regra com o menu de exibição do programa
 * 
 * 
 **/
menu():-
    nl,
    write(" Menu do programa: "),
    nl,
    write(" Digite a opção que deseja escolher."),
    nl,
    write(" 1 - Exibir as aplicações em que um cliente está investindo"),
    nl,
    write(" 2 - Verifica se um cliente possui um fundo de emergência."),
    nl,
    write(" 3 - Verifica se um cliente possui um valor mínimo para investimento."),
    nl,
    write(" 4 - Não conhece seu perfil de investidor? Responda este questionário e descubra!"),
    nl,
    write(" 5 - Ver informações de um cliente."),
    nl,
    write(" 6 - Adicionar cliente."),
    nl,
    write(" 7 - Onde aplicar?"),
    nl,
    write(" 8 - Quanto lucrarei nas aplicações que tenho?"),
    nl,
    write(" 0 - Para sair."),
    nl,
    read(X),
    opc(X),
    menu().

/**
 * 
 * Regras para opções do menu de execução do programa
 * @param:
 *      X = número da opção escolhida
 * 
 **/
opc(X):-
    X = 0,
    halt.

opc(X):-
    X = 1,
    leitura_nome_cliente(C),
    exibe_aplicacoes_valores_cliente(C).
    
opc(X):-
    X = 2,
    leitura_nome_cliente(C),
    cliente(C,_,_, DEP, _, APLIC, QT_APLIC, _, DESP),
    verifica_fundo_emergencia( DEP, DESP, _, APLIC, QT_APLIC).
    
opc(X):-
    X = 3,
    leitura_nome_cliente(C),
    cliente(C,SALDO,RENDA, DEP, _, _, _, _,_),
    valor_minimo_investimento(SALDO,RENDA,DEP).

opc(X):-
    X = 4,
    leitura_nome_cliente(C),
    cliente(C,_,_,_, _, _, _, _,_), 
    questionario_perfil(C).

opc(X):-
    X = 5,
    leitura_nome_cliente(C),
    cliente(C,SALDO,RENDA_MENSAL,DEPENDENTES,PRAZO_RETORNO,APLICACOES,QUANTIA,PERFIL,DESPESA), 
    write("Nome do cliente: "),
    write(C),
    nl,
    write("Saldo do cliente:"),
    write(SALDO),
    nl,
    write("Renda mensal:"),
    write(RENDA_MENSAL),
    nl,
    write("Quantidade dependentes:"),
    write(DEPENDENTES),
    nl,
    write("Prazo de retorno:"),
    write(PRAZO_RETORNO),
    nl,
    write("Aplicações e quantia em cada aplicacao:"),
    nl,
    write(APLICACOES),
    nl,
    write(QUANTIA),
    nl,
    write("Perfil de investidor:"),
    write(PERFIL),
    nl,
    write("Despesas mensais:"),
    write(DESPESA),
    nl.

opc(X):-
    X = 6,
    write("Nome do cliente: "),
    nl,
    read(C),
    write("Saldo do cliente:"),
    nl,
    read(SALDO),
    write("Renda mensal:"),
    nl,
    read(RENDA_MENSAL),
    write("Quantidade dependentes:"),
    nl,
    read(DEPENDENTES),
    write("Prazo de retorno:"),
    nl,
    read(PRAZO_RETORNO),
    write("Aplicações:"),
    nl,
    read(APLICACOES),
    write("Quantia em cada aplicacao:"),
    nl,
    read(QUANTIA),
    write("Perfil de investidor:"),
    nl,
    read(PERFIL),
    write("Despesas mensais:"),
    nl,
    read(DESPESA),
    assert(cliente(C,SALDO,RENDA_MENSAL,DEPENDENTES,PRAZO_RETORNO,APLICACOES,QUANTIA,PERFIL,DESPESA)),
    write("Usuário adicionado com sucesso!"),
    nl. 

opc(X):-
    X = 7,
    leitura_nome_cliente(C),
    cliente(C,SALDO,_,_,PRAZO_RETORNO,_,_,PERFIL,_), 
    onde_pode_aplicar(SALDO,PRAZO_RETORNO,PERFIL, C).
    
opc(X):-
    X = 8,
    leitura_nome_cliente(C),
    quanto_lucrarei(C).
    

/**
 * Regra para encapsular a leitura do nome do cliente
 * @param:
 *  C = nome do cliente a ser validado
 * 
 **/
leitura_nome_cliente(C):-
    write("Digite o nome do cliente. Exemplo: ronaldinho_gaucho."),
    nl,
    read(C),
    valida_nome_cliente(C).

/**
 * 
 * Regra para a validação de um cliente
 * @param:
 *      C = nome do cliente a ser validado
 **/
valida_nome_cliente(C):-
    cliente(C,_,_,_,_,_,_,_,_).
