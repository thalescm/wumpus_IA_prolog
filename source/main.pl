%-------------------------------------------------------------------------------
% The Main Program, Schedule :
%
% "schedule." :
% 	launch a hole evolution until get a agent'result : 5 ends are possible
%	you must to refer at the_end(Smile) to get the success degree
%


	
schedule :-
	initialize_general,
	format("the game is begun.~n",[]),
	description_total,
	retractall(is_situation(_,_,_,_,_)),
	time(T),agent_location(L),agent_orientation(O),
	assert(is_situation(T,L,O,[],i_know_nothing)),
	format("I'm conquering the World Ah!Ah!...~n",[]),
	step.

step :-
	agent_healthy,		% If I'm computing... so I am...
	agent_in_cave,
	
	is_nb_visited,		% count the number of room visited
	
	agent_location(L),
	retractall(is_visited(L)),
	assert(is_visited(L)),
	
	description,		% display a short summary of my state
	
	%----------------------------------
	make_percept_sentence(Percept),	% I percept...
	format("I feel ~p, ",[Percept]),
	%----------------------------------
	tell_KB(Percept),		% I learn...(infer)
	%----------------------------------
	%ask_KB(Percept,Action),		% I think...(compute)
	ask_KB(Action),
	format("I'm doing : ~p~n",[Action]),
	%----------------------------------
	apply(Action),			% I do...
	%----------------------------------
	
	short_goal(SG),		% the goal of my current action 
% format("Short goal~p ~n",[SG]),
	
	time(T),		% Time update 
	New_T is T+1,
	retractall(time(_)),
	assert(time(New_T)),
	
	agent_orientation(O),
	assert(is_situation(New_T,L,O,Percept,SG)),
	% we keep in memory to check :
	% time, agent_location, agent_Orientation,perception, short_goal.
	
	step,
	!.
	
step :-	
	format("the game is finished.~n",[]),	% either dead or out the cave
	
	agent_score(S),
	time(T),
	New_S is S - T,
	retractall(agent_score(_)),
	assert(agent_score(New_S)),
		
	description_total,
	the_end(MARK),
	display(MARK).
	
