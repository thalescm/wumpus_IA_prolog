%-------------------------------------------------------------------------------
% Perception 
%			Problem with adjacent...return only one value.
%

make_percept_sentence([Stench,Bleeze,Glitter,Bump,Scream]) :-
	stenchy(Stench),
	bleezy(Bleeze),
	glittering(Glitter),
	bumped(Bump),
	heardscream(Scream).

stenchy(yes) :-
	wumpus_location(L1),
	agent_location(L2),
	adjacent(L1,L2),
	!.
stenchy(no).

bleezy(yes) :- 
	pit_location(L1),
	agent_location(L2), 
	adjacent(L1,L2),
	!.
bleezy(no).

glittering(yes) :-
	agent_location(L),
	gold_location(L),
	!.
glittering(no).

bumped(yes) :-			% I feel a wall when I'm closed of a wall
	agent_location(L),
	wall(L),
	!.
bumped(no).

heardscream(yes) :-
	no(wumpus_healthy), 
	!.
heardscream(no).
