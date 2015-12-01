%-------------------------------------------------------------------------------
% Display
%

description :-
	
	agent_location([X,Y]),
	degree(O),
	format(">I'm in ~p, turned to ~p, ",[[X,Y],O]).
	
description_total :-
	agent_healthy_state(AFG),
	format("| -> Agent health : ~p~n",[AFG]),	
	wumpus_healthy_state(WFS),
	format("| -> Wumpus Health : ~p~n",[WFS]),
	time(T),
	format("| -> Time : ~p~n",[T]),
	nb_visited(N),
	format("| -> Number of visited room : ~p~n",[N]),
	land_extent(LE),
	E is (LE - 1) * (LE - 1),
	format("| -> Number of total room : ~p~n",[E]),
	agent_score(SC),
	format("| -> Score : ~p~n",[SC]),
	agent_hold_state(AHS),
	format("| -> Gold : ~p~n",[AHS]),
	agent_goal(G),
	format("| -> Strategy Goal : ~p~n",[G]),
	agent_in_the_cave_state(ACS),
	format("| -> Body agent is : ~p~n",[ACS]).
	
degree(east) :- agent_orientation(0).
degree(north) :- agent_orientation(90).
degree(west) :- agent_orientation(180).
degree(south) :- agent_orientation(270).	
	
agent_in_the_cave_state(in_the_cave) :- agent_in_cave,!.
agent_in_the_cave_state(out_the_cave).

agent_healthy_state(perfect_health) :- 
	agent_healthy,
	agent_courage,
	!.
	
agent_healthy_state(a_little_tired_but_alive) :- 
	agent_healthy,
	!.	
agent_healthy_state(dead).

agent_hold_state(with_me) :- agent_hold,!.
agent_hold_state(not_found).

wumpus_healthy_state(alive) :- wumpus_healthy,!.
wumpus_healthy_state(wumpus_is_dead_baby).

the_end('=D I am the BEST') :-
	no(agent_in_cave),
	agent_hold,
	is_dead,
	!.
	
the_end('=) Pfftt too easy') :-
	no(agent_in_cave),
	agent_hold,
	no(is_dead),
	!.	
	
the_end(':) Too tired') :-
	no(agent_in_cave),
	no(agent_hold),
	is_dead,
	!.
	
the_end(':| I am sure Wumpus has moved !!!') :-
	no(agent_in_cave),
	no(agent_hold),
	no(is_dead),
	!.
		
the_end(':( No Comment') :-
	agent_in_cave,
	no(agent_hold),
	no(is_dead).	
