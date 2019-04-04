

le_cliente():-
    write("Digite o nome do cliente"),
    nl,
    read(X),
    write("Digite quanto ele possui de saldo no banco"),
    nl,
    read(Y),
    assertz(cliente(X,Y)),
    exibe_info(X).