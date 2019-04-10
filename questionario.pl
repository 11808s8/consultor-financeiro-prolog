questionario_perfil(CLIENTE):-
    cliente(CLIENTE,_,_,_,_,_,_,PERFIL,_),
    nl,
    nl,
    write("Olá "),
    write(CLIENTE),
    write(". Faremos agora um questionário para descobrir seu perfil de investimento."),
    nl,
    write(" Após isto, será feita uma comparação com o perfil de investimento cadastrado para você."),
    nl,
    write(" Para cada pergunta, digite a letra que está entre parêntese, seguida de um ponto e dê enter."),
    nl,
    write(" Exemplo: a."),
    nl,
    nl,
    write(" ----- Questionário ----- "),
    nl,
    nl,
    write(" 1 - Qual sua motivação para investir?"),
    nl,
    write("   a - Para não ficar com dinheiro parado em conta e ter risco de gastar."),
    nl,
    write("   b - Para possivelmente realizar alguns sonhos."),
    nl,
    write("   c - Para a obtenção de rendimentos e multiplicação da minha renda."),
    nl,
    write(" ----- Digite sua Resposta -----"),
    nl,
    read(UM),
    nl,
    nl,
    write(" 2 - Você aceita perder uma porcentagem do recurso investido?"),
    nl,
    write("   a - Não, de forma alguma."),
    nl,
    write("   b - Se for pouco, ok."),
    nl,
    write("   c - Posso correr o risco caso os ganhos possam ser maiores."),
    nl,
    write(" ----- Digite sua Resposta -----"),
    nl,
    read(DOIS),
    nl,
    nl,
    write(" 3 - Como você poupa rendas extras (13º salário, restituição do Imposto de Renda...)?"),
    nl,
    write("   a - Faço investimento em aplicações que sejam seguras."),
    nl,
    write("   b - Coloco a maior parte em investimentos isentos de risco e uma parcela em modalidades um pouco mais arrojadas."),
    nl,
    write("   c - Aplico majoritariamente em investimentos de risco (mais chances de alto rendimento) e uma pequena parcela em aplicações conservadoras."),
    nl,
    write(" ----- Digite sua Resposta -----"),
    nl,
    read(TRES),
    nl,
    nl,
    write(" 4 - E o planejamento para a aposentadoria?"),
    nl,
    write("   a - Estou poupando e investindo em aplicações de baixo risco."),
    nl,
    write("   b - Uma parte do que guardo coloco em fundos conservadores e uma parte menor em investimentos mais agressivos."),
    nl,
    write("   c - Invisto sempre meus recursos em aplicações que gerem alto retorno financeiro."),
    nl,
    write(" ----- Digite sua Resposta -----"),
    nl,
    read(QUATRO),
    nl,
    nl,
    write(" 5 - Um futuro sustentável financeiramente significa:"),
    nl,
    write("   a - Ter segurança financeira, mesmo em pouca quantia."),
    nl,
    write("   b - Guardar a maior parte do dinheiro de modo cauteloso e separando uma parte para aplicações de rendimento maior."),
    nl,
    write("   c - Investir cada vez mais (agressivamente), mesmo que tenha riscos."),
    nl,
    write(" ----- Digite sua Resposta -----"),
    nl,
    read(CINCO),
    nl,
    nl,
    respostas_questionario([UM,DOIS,TRES,QUATRO,CINCO],A,B,C, NOVO_PERFIL),
    nl,
    prepara_grafico_questionario([UM,DOIS,TRES,QUATRO,CINCO], A,B,C),
    nl,
    pergunta_adicionar_perfil_a_base(CLIENTE,PERFIL, NOVO_PERFIL).
    

pergunta_adicionar_perfil_a_base(CLIENTE, PERFIL, NOVO_PERFIL):-
    nl,
    write("Deseja adicionar o perfil de investimento ao seu perfil?(s/n)"),
    nl,
    read(RESP),
    prepara_adicionar_perfil_a_base(RESP, CLIENTE, PERFIL, NOVO_PERFIL),!.

prepara_adicionar_perfil_a_base(RESP, CLIENTE, PERFIL,NOVO_PERFIL):-
    RESP = s,
    PERFIL \= "",
    nl,
    write("Seu perfil já possui o perfil de investimento "),
    write(PERFIL),
    write(" atrelado a ele, "),
    write(CLIENTE),
    write(". Deseja sobrescrevê-lo? (s/n)"),
    nl,
    read(SOBRESCREVER),
    prepara_sobrescrever_adicionar_perfil_a_base(SOBRESCREVER, CLIENTE, NOVO_PERFIL),!.

prepara_adicionar_perfil_a_base(RESP, CLIENTE, PERFIL,NOVO_PERFIL):-
    RESP = s,
    PERFIL = "", % teste redundante...
    nl,
    prepara_sobrescrever_adicionar_perfil_a_base(s, CLIENTE, NOVO_PERFIL).

prepara_adicionar_perfil_a_base(RESP, CLIENTE, PERFIL,NOVO_PERFIL):-
    RESP = n,
    nl,
    write("Sem problemas! Retornando ao menu.").

prepara_sobrescrever_adicionar_perfil_a_base(SOBRESCREVER, CLIENTE, NOVO_PERFIL):-
    SOBRESCREVER = s,
    cliente(CLIENTE,A,B,C,D,E,F,_,G),
    retract(cliente(CLIENTE,_,_,_,_,_,_,_,_)),
    assert(cliente(CLIENTE,A,B,C,D,E,F,NOVO_PERFIL,G)),
    nl,
    write("Perfil de investimento alterado com sucesso!").
prepara_sobrescrever_adicionar_perfil_a_base(SOBRESCREVER, CLIENTE, NOVO_PERFIL):-
    SOBRESCREVER = n,
    nl,
    write("Sem problemas! Retornando ao menu.").

prepara_grafico_questionario(RESPOSTAS,A,B,C):-
    tamanho_lista(RESPOSTAS, TAMANHO_LISTA),
    grafico_questionario(A,B,C,TAMANHO_LISTA).

respostas_questionario(RESPOSTAS,A,B,C, NOVO_PERFIL):-
    quantifica_respostas_questionarios(RESPOSTAS,A,B,C),
    compara_respostas(A,B,C,NOVO_PERFIL).

% @TODO: Adicionar TEXTO sobre perfis
compara_respostas(A,B,C,AUX):-
    A>B,
    A>C,
    AUX = conservador,
    write("Você tirou perfil Conservador. Parece que você não gosta de correr riscos ou busca por rendas estáveis a um curto/médio prazo").
compara_respostas(A,B,C,AUX):-
    B>A,
    B>C,
    AUX = moderado,
    write("Você tirou perfil Moderado. Parece que você busca um lucro acima do normal, sem correr tantos riscos em uma aplicação agressiva.").
compara_respostas(A,B,C,AUX):-
    C>A,
    C>B,
    AUX = agressivo,
    write("Você tirou perfil Agressivo. Você busca um lucro elevado, acima dos perfis Moderado e Conservador, mesmo que eventualmente ocorram perdas do capital investido.").
% compara_respostas(A,B,C,AUX):-
%     A=B,
%     AUX = d,
%     write("Conservador Moderado"). % ab
% compara_respostas(A,B,C,AUX):-
%     B=C,
%     AUX = e,
%     write("Moderado tendendo para agressivo"). % bc
% compara_respostas(A,B,C,AUX):-
%     A=C,
%     AUX = f,
%     write("Conservador e agressivo."). % ac
    


/**
 * Regra que contabiliza a quantidade de resposta 'a', 'b' e 'c'
 * escolhidas pelo usuário.
 * @param:
 *      LISTA_RESPOSTAS = Lista de respostas do cliente para o questionário
 *      A = Variável auxiliar a qual possuirá o retorno com a SOMA das respostas 'a'
 *      B = Variável auxiliar a qual possuirá o retorno com a SOMA das respostas 'b'
 *      C = Variável auxiliar a qual possuirá o retorno com a SOMA das respostas 'c'
**/
quantifica_respostas_questionarios([],0,0,0).
quantifica_respostas_questionarios([H|T],A,B,C):-
    H=a,
    quantifica_respostas_questionarios(T,A1,B,C),
    A is A1 + 1.
quantifica_respostas_questionarios([H|T],A,B,C):-
    H=b,
    quantifica_respostas_questionarios(T,A,B1,C),
    B is B1 + 1.
quantifica_respostas_questionarios([H|T],A,B,C):-
    H=c,
    quantifica_respostas_questionarios(T,A,B,C1),
    C is C1 + 1.

