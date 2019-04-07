
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
    write("SEGURE ctrl + D para sair."),
    nl,
    read(X),
    opc(X),
    menu().

opc(X):-
    X = 1,
    leitura_nome_cliente(C),
    exibe_aplicacoes_valores_cliente(C).
    
opc(X):-
    X = 2,
    leitura_nome_cliente(C),
    cliente(C,SALDO, R_A, DEP, _, APLIC, QT_APLIC, _, DESP),
    verifica_fundo_emergencia(SALDO, R_A, DEP, DESP, _, APLIC, QT_APLIC).
    
opc(X):-
    X = 3,
    leitura_nome_cliente(C),
    cliente(C,SALDO,RENDA, DEP, _, _, _, _,_),
    valor_minimo_investimento(SALDO,RENDA,DEP).

opc(X):-
    X = 4,
    leitura_nome_cliente(C),
    cliente(C,_,_,_, _, _, _, _,_), % @TODO: COLOCAR AQUI UMA OPÇÃO PARA SUBSTITUIR O PERFIL SE QUISER
    questionario_perfil(C).


leitura_nome_cliente(C):-
    write("Digite o nome do cliente. Exemplo: ronaldinho_gaucho."),
    nl,
    read(C),
    valida_nome_cliente(C).
    
% cliente(nome,
%         saldo,
%         renda_mensal, 
%         dependentes,
%         prazo_retorno_investimento,
%         [aplicacoes],
%         [quantia_aplicada_em_cada_aplicacao],
%         perfil)

valida_nome_cliente(C):-
    cliente(C,_,_,_,_,_,_,_,_).


teste():-
    write("Olá mundo").
