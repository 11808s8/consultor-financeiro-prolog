:- use_module(library('plot/barchart')).
:- use_module(library(autowin)).
:- use_module(library(pce)).

% Referências para o gráfico de barras:
% https://github.com/SWI-Prolog/packages-xpce/blob/master/prolog/lib/plot/demo.pl
% http://www.swi-prolog.org/packages/xpce/UserGuide/libplot.html#sec:11.6


%  ------------------------------------------------
%  Gráfico Questionário


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


%  -----------------------------------------------
%  Gráficos Aplicações

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
