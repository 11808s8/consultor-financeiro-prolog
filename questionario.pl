:- use_module(library('plot/barchart')).
:- use_module(library(autowin)).
:- use_module(library(pce)).

% Referências para o gráfico de barras:
% https://github.com/SWI-Prolog/packages-xpce/blob/master/prolog/lib/plot/demo.pl
% http://www.swi-prolog.org/packages/xpce/UserGuide/libplot.html#sec:11.6

% Está plotando na horizontal pois na vertical não consegui fazer a legenda do eixo X aparecer
grafico_questionario(A1,B1,C1, QTD_RESPOSTAS) :-
    new(W,  auto_sized_picture('Respostas do Questionário')),
    send(W, display, new(BC, bar_chart(horizontal,0,QTD_RESPOSTAS))),
    forall(member(Name/Height/Color,
              [a/A1/red, b/B1/green, c/C1/blue]),
           (   new(B, bar(Name, Height)),
               send(B, colour(Color)),
               send(BC, append, B)
           )),
    send(W, open).


questionario_perfil(CLIENTE):-
    cliente(CLIENTE,_,_,_,_,_,_,_,_),
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
    respostas_questionario([UM,DOIS,TRES,QUATRO,CINCO],A,B,C),
    nl,
    write("Deseja ver um gráfico com suas respostas?(s/n)"),
    nl,
    read(VER),
    pergunta_grafico_questionario([UM,DOIS,TRES,QUATRO,CINCO], VER, A,B,C).
    

pergunta_grafico_questionario(RESPOSTAS, VER,A,B,C):-
    VER = s,
    tamanho_lista(RESPOSTAS, TAMANHO_LISTA),
    grafico_questionario(A,B,C,TAMANHO_LISTA).

pergunta_grafico_questionario(RESPOSTAS, VER,A,B,C):-
    VER = "S",
    tamanho_lista(RESPOSTAS, TAMANHO_LISTA),
    grafico_questionario(A,B,C,TAMANHO_LISTA).

pergunta_grafico_questionario(RESPOSTAS, VER,A,B,C):-
    VER = "N",
    write("Sem problemas! Retornando ao menu.").
pergunta_grafico_questionario(RESPOSTAS, VER,A,B,C):-
    VER = n,
    write("Sem problemas! Retornando ao menu.").

respostas_questionario(RESPOSTAS,A,B,C):-
    quantifica_respostas_questionarios(RESPOSTAS,A,B,C),
    compara_respostas(A,B,C,AUX).

% @TODO: Adicionar TEXTO sobre perfis
compara_respostas(A,B,C,AUX):-
    A>B,
    A>C,
    AUX = a,
    write("Conservador").
compara_respostas(A,B,C,AUX):-
    B>A,
    B>C,
    AUX = b,
    write("Moderado").
compara_respostas(A,B,C,AUX):-
    C>A,
    C>B,
    AUX = c,
    write("Agressivo").
compara_respostas(A,B,C,AUX):-
    A=B,
    AUX = d,
    write("Conservador Moderado"). % ab
compara_respostas(A,B,C,AUX):-
    B=C,
    AUX = e,
    write("Moderado tendendo para agressivo"). % bc
compara_respostas(A,B,C,AUX):-
    A=C,
    AUX = f,
    write("Conservador e agressivo."). % ac
    
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

