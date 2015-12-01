%-------------------------------------------------------------------------------
% A few declarations
%

:- dynamic([
	short_goal/1,
	is_situation/5,			% tool to cheek a "situation"
	time/1,
	nb_visited/1,			% number of room visited
	score_climb_with_gold/1,
	score_grab/1,
	score_wumpus_dead/1,
	score_agent_dead/1,
	land_extent/1,			% size of the land
	wumpus_location/1,
	wumpus_healthy/0,
	gold_location/1,
	pit_location/1,
	agent_location/1,		% state of agent
	agent_orientation/1,
	agent_healthy/0,
	agent_hold/0,
	agent_arrows/1,
	agent_goal/1,
	agent_score/1,
	agent_in_cave/0,		
	is_wumpus/2,		% agent's knowledge about Wumpus_location
	is_pit/2,		% agent's knowledge about pit_location
	is_gold/1,		% agent's knowledge about gold_location
	is_wall/1,		% agent's knowledge about wall_location
	is_dead/0,		% agent's knowledge about Wumpus_health
	is_visited/1]).		% agent's knowledge about room visited
	
% create a map with the initial features described in the section 6.2
initialize_land(fig62):-
	retractall(land_extent(_)),	
	retractall(wumpus_location(_)),
	retractall(wumpus_healthy),
	retractall(gold_location(_)),
	retractall(pit_location(_)),
	assert(land_extent(5)),
	assert(wumpus_location([1,3])),
	assert(wumpus_healthy),
	assert(gold_location([2,3])),
	assert(pit_location([3,1])),
	assert(pit_location([3,3])),
	assert(pit_location([4,4])).
	
% create a map test
initialize_land(test):-
	retractall(land_extent(_)),	
	retractall(wumpus_location(_)),
	retractall(wumpus_healthy),
	retractall(gold_location(_)),
	retractall(pit_location(_)),
	assert(land_extent(5)),
	assert(wumpus_location([3,2])),
	assert(wumpus_healthy),
	assert(gold_location([4,3])),
	assert(pit_location([3,3])),
	assert(pit_location([4,4])),
	assert(pit_location([3,1])).

% create an agent with the initial features described in the section 6.2
initialize_agent(fig62):-	
	retractall(agent_location(_)),
	retractall(agent_orientation(_)),
	retractall(agent_healthy),
	retractall(agent_hold),
	retractall(agent_arrows(_)),
	retractall(agent_goal(_)),
	retractall(agent_score(_)),
	retractall(is_wumpus(_,_)),
	retractall(is_pit(_,_)),
	retractall(is_gold(_)),
	retractall(is_wall(_)),
	retractall(is_dead),
	retractall(is_visited(_)),
	assert(agent_location([1,1])),
	assert(agent_orientation(0)),
	assert(agent_healthy),
	assert(agent_arrows(1)),
	assert(agent_goal(find_out)),
	assert(agent_score(0)),	
	assert(agent_in_cave).
		
% initialization general
initialize_general :-
	initialize_land(test),		% Which map you wish
	initialize_agent(fig62),
	retractall(time(_)),
	assert(time(0)),
	retractall(nb_visited(_)),
	assert(nb_visited(0)),
	retractall(score_agent_dead(_)),
	assert(score_agent_dead(10000)),
	retractall(score_climb_with_gold(_)),
	assert(score_climb_with_gold(1000)),
	retractall(score_grab(_)),
	assert(score_grab(0)),
	retractall(score_wumpus_dead(_)),
	assert(score_wumpus_dead(0)),
	retractall(is_situation(_,_,_,_,_)),
	retractall(short_goal(_)).
