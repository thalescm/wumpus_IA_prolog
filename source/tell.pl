%-------------------------------------------------------------------------------
% Tell_KB : 
% inform the Knowledge Base of our agent about the features of the world
%

tell_KB([Stench,Bleeze,Glitter,yes,Scream]) :- 
	add_wall_KB(yes),!.

tell_KB([Stench,Bleeze,Glitter,Bump,Scream]) :-
%	agent_location(L),	% update only if unknown could be great
%	no(is_visited(L)),	% but the wumpus dead changes : percept
	add_wumpus_KB(Stench),
	add_pit_KB(Bleeze),
	add_gold_KB(Glitter),
%	add_wall_KB(Bump),
	add_scream_KB(Scream).


% update our knowledge about wumpus presence

add_wumpus_KB(no) :-
	agent_location(L1),
	assume_wumpus(no,L1), 		% I'm not in a wumpus place
	location_toward(L1,0,L2),	% I'm sure there are no Wumpus in
	assume_wumpus(no,L2),		% each adjacent room. >=P
	location_toward(L1,90,L3),	
	assume_wumpus(no,L3),
	location_toward(L1,180,L4),	
	assume_wumpus(no,L4),
	location_toward(L1,270,L5),	
	assume_wumpus(no,L5),
	!.
add_wumpus_KB(yes) :-	
	agent_location(L1),	% I don't know if I'm in a wumpus place
	location_toward(L1,0,L2),% And It's possible there are Wumpus in 
	assume_wumpus(yes,L2),		% each adjacent room. <=|
	location_toward(L1,90,L3),	
	assume_wumpus(yes,L3),
	location_toward(L1,180,L4),	
	assume_wumpus(yes,L4),
	location_toward(L1,270,L5),	
	assume_wumpus(yes,L5).
	
assume_wumpus(no,L) :-
	retractall(is_wumpus(_,L)),
	assert(is_wumpus(no,L)),
	!.
	
assume_wumpus(yes,L) :- 		% before I knew there is no Wumpus,
	is_wumpus(no,L),		% so Wumpus can't be now ... =)
	!.				% ... Except if it's able to move 
	
assume_wumpus(yes,L) :- 		
	wall(L),			% Wumpus can't be in a wall
%	wumpus_healthy,			
	retractall(is_wumpus(_,L)),
	assert(is_wumpus(no,L)),
	!.
	
assume_wumpus(yes,L) :- 
	wumpus_healthy,			% so...
	retractall(is_wumpus(_,L)),
	assert(is_wumpus(yes,L)),
	!.
	
assume_wumpus(yes,L) :-
	retractall(is_wumpus(_,L)),
	assert(is_wumpus(no,L)).	% because Wumpus is dead >=]	
	
	
% update our knowledge about pit presence
	
add_pit_KB(no) :-
	agent_location(L1),
	assume_pit(no,L1), 		% I'm not in a pit {:o 
	location_toward(L1,0,L2),	% And I'm sure there are no pit in
	assume_pit(no,L2), 		% each adjacent room. >=P
	location_toward(L1,90,L3),	
	assume_pit(no,L3),
	location_toward(L1,180,L4),	
	assume_pit(no,L4),
	location_toward(L1,270,L5),	
	assume_pit(no,L5),
	!.
add_pit_KB(yes) :-	
	agent_location(L1),	% I don't know if I'm in a pit place.
	location_toward(L1,0,L2),	% It's possible there are Pit in
	assume_pit(yes,L2),		% each adjacent room. <=|
	location_toward(L1,90,L3),	
	assume_pit(yes,L3),
	location_toward(L1,180,L4),	
	assume_pit(yes,L4),
	location_toward(L1,270,L5),	
	assume_pit(yes,L5).
	
assume_pit(no,L) :-
	retractall(is_pit(_,L)),
	assert(is_pit(no,L)),
	!.
	
assume_pit(yes,L) :- 			% before I knew there is no pit,
	is_pit(no,L),			% so pit can't be now ... =)
	!.
	
assume_pit(yes,L) :- 
	wall(L),			% No Pit in a wall...
	retractall(is_pit(_,L)),
	assert(is_pit(no,L)),
	!.
	
assume_pit(yes,L) :- 
	retractall(is_pit(_,L)),
	assert(is_pit(yes,L)).	
	
% update our knowledge about gold presence

add_gold_KB(yes) :-
	agent_location(L),
	retractall(is_gold(L)), 	% no purpose here, I know ;)
	assert(is_gold(L)),
	!.
add_gold_KB(no).		

% update our knowledge about wall presence

add_wall_KB(yes) :-			% here I know where there is wall
	agent_location(L),		% because I'm in ...	
	retractall(is_wall(L)),	
	assert(is_wall(L)),
	!.					
add_wall_KB(no).
		
% update our knowledge about wumpus health 

add_scream_KB(yes) :-
	retractall(is_dead),
	assert(is_dead),
	!.
add_scream_KB(no).
