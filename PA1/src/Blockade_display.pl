:-use_module(library(lists)).
	
	
trading(0,' ').
trading(1,'A').
trading(2,'B').
trading(3,'C').
trading(4,'D').
trading(5,'X').
trading(6,'Y').
trading(a,1).
trading(b,2).
trading(c,3).
trading(d,4).

trading_v(0,'   ').
trading_v(1,' | ').

trading_h(0,'   ').
trading_h(1,'---').

write_char(N) :- 
	char_code(A,N),
	write(A).

display_board(B,V,H) :- display_top(9), display_board_m(B,V,H,0).

display_separator(N,R,L,M) :- write_char(R), write('---'), display_separator_m(N,M), write('---'), write_char(L), nl.
display_separator_m(0,M) :- write_char(M).
display_separator_m(N,M) :- write_char(M), write('---'), N1 is N - 1, display_separator_m(N1,M).

display_top(N) :- display_separator(N,9484,9488,9516).
display_bot(N) :- display_separator(N,9492,9496,9524).
display_mid(N) :- display_separator(N,9500,9508,9532).

display_board_m([B1|B2],[V1|V2],[H1|H2],Cont) :- write('| '), display_line(B1,V1,Cont), display_hor(H1), NewCont is Cont+1, display_board_m(B2,V2,H2,NewCont).
display_board_m([B1|B2],[V1|V2],[],Cont) :- write('| '), display_line(B1,V1,Cont), NewCont is Cont+1, display_board_m(B2,V2,[],NewCont).
display_board_m([],[],[],Cont) :- display_bot(9), write('  0   1   2   3   4   5   6   7   8   9  10'), nl,nl.

display_line([E1|E2],[V1|V2],Cont) :-
	trading(E1,X),
	trading_v(V1,Y),
	write(X), 
	write(Y),
	display_line(E2,V2,Cont).
	
display_line([E1|E2],[],Cont) :-
	trading(E1,X),
	write(X),
	write(' |'), write(Cont), 
	display_line(E2,[],NewCont).

display_line([],[],Cont):- nl.

display_hor(H) :-
	write_char(9500),
	display_hor_m(H),
	write_char(9508),
	nl.

display_hor_m([H1]) :-
	trading_h(H1,X),
	write(X),
	display_hor_m([]).
	
display_hor_m([H1|H2]) :-
	trading_h(H1,X),
	write(X),
	write_char(9532),
	display_hor_m(H2).
	
display_hor_m([]).