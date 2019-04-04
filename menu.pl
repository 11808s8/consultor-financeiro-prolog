
menu():-
    nl,
    write(" Menu do programa: "),
    nl,
    write(" Digite a opção que deseja escolher."),
    nl,
    write(" 1 - Exibir as aplicações em que um cliente está investindo"),
    nl,
    write("SEGURE ctrl + D para sair."),
    nl,
    read(X),
    opc(X),
    menu().

opc(X):-
    X = 1,
    
    write("Digite o nome do cliente. Exemplo: ronaldinho_gaucho."),
    nl,
    read(C),
    valida_nome_cliente(C),
    exibe_aplicacoes_valores_cliente(C).
    


valida_nome_cliente(C):-
    cliente(C,_,_,_,_,_,_,_,_).


teste():-
    write("Olá mundo").
