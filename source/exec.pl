%-------------------------------------------------------------------------------
% carry out : result(Action)
%

apply(rebound) :-
	agent_location(L),
	agent_orientation(O),		
	Back_O is (O+180) mod 360,
	location_toward(L,Back_O,L2),
	retractall(agent_location(_)),
	assert(agent_location(L2)).	% back at the last location
	
apply(die) :-
	agent_location(L1),
	wumpus_location(L1),		% If I'm dead =( , I'm not dead =)... 
	retractall(is_wumpus(yes,_)),	% we can use a function "restore"
	assert(is_wumpus(yes,L)),	% which gives a new life
	agent_score(S),
	score_agent_dead(SAD),
	New_S is S - SAD,
	assert(agent_score(New_S)),
	retractall(agent_healthy),
%	give_new_life,
 	format("Killed by Wumpus...~n",[]),
	!.
		
apply(die) :-	
	agent_location(L1),
	pit_location(L1),		% If I'm dead =( , I'm not dead =)...
	retractall(is_pit(_,L)),	% we can use a function "restore"
	assert(is_pit(yes,L)),		% which gives a new life
	agent_score(S),
	score_agent_dead(SAD),
	New_S is S - SAD,
	assert(agent_score(New_S)),
	retractall(agent_healthy),
%	give_new_life,
	format("Fallen in a pit...~n",[]),
	!.

apply(shoot) :-				% Now we check if actually there is
	agent_location([X,Y]),
	location_ahead([X,NY]),		
	wumpus_location([X,WY]),	% Wumpus, because it could be only
	dist(NY,WY,R1),			% a supposition.
	dist(Y,WY,R2),
	inf_equal(R1,R2),
	
	retractall(wumpus_location(_)),
	retractall(wumpus_healthy),
	retractall(agent_arrows(_)),
	assert(agent_arrows(0)),
	
	is_wumpus(yes,WL),
	assert(is_wumpus(no,WL)),
	retractall(is_wumpus(yes,_)),
	assert(is_dead),
	
	agent_score(S),	
	score_wumpus_dead(SWD),
	New_S is S + SWD,
	retractall(agent_score(S)),
	assert(agent_score(New_S)),
	format("There can be only One~n",[]),
	!.
	
apply(shoot) :-				% Now we check if actually there is
	agent_location([X,Y]),
	location_ahead([NX,Y]),	
	wumpus_location([WX,Y]),	% Wumpus, because it could be only
	dist(NX,WX,R1),			% a supposition.
	dist(X,WX,R2),
	inf_equal(R1,R2),
	
	retractall(wumpus_location(_)),
	retractall(wumpus_healthy),
	retractall(agent_arrows(_)),
	assert(agent_arrows(0)),
	
	is_wumpus(yes,WL),
	assert(is_wumpus(no,WL)),
	retractall(is_wumpus(yes,_)),
	assert(is_dead),
	
	agent_score(S),	
	score_wumpus_dead(SWD),
	New_S is S + SWD,
	retractall(agent_score(S)),
	assert(agent_score(New_S)),
	format("There can be only One~n",[]),
	!.
	
apply(shoot) :-				% Wumpus is missed
	format("Ouchh, I fail Grrrr  >=}...~n",[]),	
	retractall(agent_arrows(_)),	% I can infer some informations !!! 
	assert(agent_arrows(0)),	
	agent_location([X,Y]),		% I can assume that Wumpus...
	location_ahead([X,NY]),
	is_wumpus(yes,[X,WY]),
	retractall(is_wumpus(yes,[X,WY])),	
	assert(is_wumpus(no,[X,WY])),	% ...is not in the supposed room.
	!.
	
apply(shoot) :-				% Wumpus is missed
	format("Ouchh, I fail Grrrr  >=}...~n",[]),	
	retractall(agent_arrows(_)),	% I can infer some informations !!! 
	assert(agent_arrows(0)),	
	agent_orientation(TO),		% I can assume that Wumpus...
	agent_location([X,Y]),
	location_ahead([NX,Y]),
	is_wumpus(yes,[WX,Y]),
	retractall(is_wumpus(yes,[WX,Y])),	
	assert(is_wumpus(no,[WX,Y])),	%  ...is not in the supposed room
	!.			
			
apply(climb) :-				% I win or I lose, 
	agent_hold,			% It depends on my hold...
	agent_score(S),	
	score_climb_with_gold(SC),
	New_S is S + SC,
	retractall(agent_score(S)),
	assert(agent_score(New_S)),
	retractall(agent_in_cave),
	!.
	
apply(climb) :-	
	retractall(agent_in_cave),
	!.	
	
apply(grab) :-
	agent_score(S),
	score_grab(SG),
	New_S is S + SG,
	retractall(agent_score(S)),
	assert(agent_score(New_S)),
	retractall(gold_location(_)),	% no more gold at this place
	retractall(is_gold(_)),		% The gold is with me!
	assert(agent_hold),		% money, money,  :P 
	retractall(agent_goal(_)),
	assert(agent_goal(go_out)),	% Now I want to go home
	format("Yomi! Yomi! Give me the money >=}...~n",[]),
	!.				
	
apply(forward) :-
	agent_orientation(O),
	agent_location(L),
	location_toward(L,O,New_L),
	retractall(agent_location(_)),
	assert(agent_location(New_L)),
	!.
	
apply(turnleft) :-	
	agent_orientation(O),
	New_O is (O + 90) mod 360,
	retractall(agent_orientation(_)),
	assert(agent_orientation(New_O)),
	!.
	
apply(turnright) :-	
	agent_orientation(O),
	New_O is abs(O - 90) mod 360,
	retractall(agent_orientation(_)),
	assert(agent_orientation(New_O)),
	!.

give_new_life :-
	agent_orientation(O),			% first go out the trap.
	New_O is (O+90) mod 360,		% Choosen arbitrary.
	retractall(agent_orientation(_)),
	assert(agent_orientation(New_O)),
	apply(forward),				% one step forward
	assert(agent_healthy).			% WE ARE GOD !!!
