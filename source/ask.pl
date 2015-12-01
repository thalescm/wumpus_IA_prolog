%-------------------------------------------------------------------------------
% Ask_KB
%

ask_KB(Action) :- make_action_query(Strategy,Action).

make_action_query(Strategy,Action) :- act(strategy_reflex,Action),!.
make_action_query(Strategy,Action) :- act(strategy_find_out,Action),!.
make_action_query(Strategy,Action) :- act(strategy_go_out,Action),!.


% Strategy Reflex

act(strategy_reflex,rebound) :-		% back at the last location
	agent_location(L),
	is_wall(L),
	is_short_goal(rebound),!.
	
act(strategy_reflex,die) :- 
	agent_healthy,
	wumpus_healthy,
	agent_location(L),
	wumpus_location(L),
	is_short_goal(die_wumpus),
	!.
	
act(strategy_reflex,die) :- 
	agent_healthy,
	agent_location(L),
	pit_location(L),
	is_short_goal(die_pit),
	!.
		
act(strategy_reflex,shoot) :-		% I shoot Wumpus only if I think  
	agent_arrows(1),		% that we are in the same X
	agent_location([X,Y]),		% it means I assume Wumpus and me
	location_ahead([X,NY]),		
	is_wumpus(yes,[X,WY]),		% are in the same column
	dist(NY,WY,R1),			% And If I don't give him my back...
	dist(Y,WY,R2),			% <=> If I'm in the good orientation
	inf_equal(R1,R2),		% to shoot him... HE!HE!
	is_short_goal(shoot_forward_in_the_same_X),
	!.
	
act(strategy_reflex,shoot) :-		% I shoot Wumpus only if I think  
	agent_arrows(1),		% that we are in the same y
	agent_location([X,Y]),
	location_ahead([NX,Y]),
	is_wumpus(yes,[WX,Y]),
	dist(NX,WX,R1),			% And If I don't give him my back...
	dist(X,WX,R2),
	inf_equal(R1,R2),
	is_short_goal(shoot_forward_in_the_same_Y),
	!.	
	
act(strategy_reflex,grab) :-
	agent_location(L),		
	is_gold(L),			
	is_short_goal(grab_gold),	
	!.
	
act(strategy_reflex,climb) :-		% climb with gold
	agent_location([1,1]),	
	agent_hold,	
%	format("I'm going out~n",[]),	
	is_short_goal(nothing_more),	
	!.
			
% Strategy to find out gold	
	
% And there is a good room adjacent	

act(strategy_find_out,forward) :-			
	agent_goal(find_out),
	agent_courage,
	good(_),			% I'm interested by a good somewhere
	location_ahead(L),		% this somewhere is just
	good(L),			% the room in front of me.
	no(is_wall(L)),
	is_short_goal(find_out_forward_good_good),
	!.
	
act(strategy_find_out,turnleft) :-			
	agent_goal(find_out),
	agent_courage,
	good(_),			% I'm interested,...
	agent_orientation(O),
	Planned_O is (O+90) mod 360,
	agent_location(L),
	location_toward(L,Planned_O,Planned_L),
	good(Planned_L),		% directly by my left side.
	no(is_wall(Planned_L)),
	is_short_goal(find_out_turnleft_good_good),
	!.
	
act(strategy_find_out,turnright) :-
	agent_goal(find_out),
	agent_courage,
	good(_),			% I'm interested,
	agent_orientation(O),
	Planned_O is abs(O-90) mod 360,
	agent_location(L),
	location_toward(L,Planned_O,Planned_L),
	good(Planned_L),		% directly by my right side.
	no(is_wall(Planned_L)),
	is_short_goal(find_out_turnright_good_good),
	!.	
		
% And there is a good room but not adjacent	
	
act(strategy_find_out,forward) :- 			
	agent_goal(find_out),
	agent_courage,		
	good(_),			% I'm interested by good somewhere	
	location_ahead(L),		% I'm looking for this better...
	medium(L),			% I use medium room to go to
	no(is_wall(L)),
	is_short_goal(find_out_forward_good_medium),
	!.
	
act(strategy_find_out,turnleft) :- 	
	agent_goal(find_out),
	agent_courage,		
	good(_),			% I'm interested by good somewhere
	agent_orientation(O),
	Planned_O is (O+90) mod 360,	% my leftside can help me :
	agent_location(L),
	location_toward(L,Planned_O,Planned_L),
	medium(Planned_L),		% I use medium room to go to
	no(is_wall(Planned_L)),
	is_short_goal(find_out_turnleft_good_medium),
	!.
	
act(strategy_find_out,turnright) :- 		
	agent_goal(find_out),
	agent_courage,
	good(_),			% I'm interested by good somewhere
	agent_orientation(O),
	Planned_O is abs(O-90) mod 360, % my rightside can help me
	agent_location(L),
	location_toward(L,Planned_O,Planned_L),
	medium(Planned_L),		% I use medium room 
	no(is_wall(Planned_L)),
	is_short_goal(find_out_turnright_good_medium),
	!.
	
act(strategy_find_out,turnleft) :-	% I want to change completely  
	agent_goal(find_out),		% my direction ( + 180 )
	agent_courage,
	good(_),			% while I don't find it, I look for
	is_short_goal(find_out_180_good_),!.	
	
	
% I'm not tired but nowhere is good room and my goal is always find gold
% So I'm testing risky and deadly room...
	
% First the risky room	
	
act(strategy_find_out,forward) :-	% I don't know any more good room 
	agent_goal(find_out),	 	% Now I'm not interested anymore by
	agent_courage, 	
	location_ahead(L),		% looking for a risky room better 
	risky(L),			% than a deadly room, .
	no(is_wall(L)),			% Can't be a wall !!!
	is_short_goal(find_out_forward__risky),
	!.
	
act(strategy_find_out,turnleft) :-
	agent_courage,		
	agent_goal(find_out),		% so I test by following priority :
	agent_orientation(O),		% risky(forward), risky(turnleft),
	Planned_O is (O+90) mod 360,	% risky(turnright), deadly(forward)
	agent_location(L),
	location_toward(L,Planned_O,Planned_L),
	risky(Planned_L),
	no(is_wall(Planned_L)),		% Can't be a wall !!!
	is_short_goal(find_out_turnleft__risky),
	!.
	
act(strategy_find_out,turnright) :-
	agent_courage,
	agent_goal(find_out),
	agent_orientation(O),
	Planned_O is abs(O-90) mod 360,	
	agent_location(L),
	location_toward(L,Planned_O,Planned_L),
	risky(Planned_L),
	no(is_wall(Planned_L)),		% Can't be a wall !!!
	is_short_goal(find_out_turnright__risky).
	
% Second the deadly room		

act(strategy_find_out,forward) :-
	agent_courage,			
	agent_goal(find_out),		
	location_ahead(L),		
	deadly(L),
	no(is_wall(L)),			% Can't be a wall !!!
	is_short_goal(find_out_forward__deadly),
	!.	
	
act(strategy_find_out,turn_left) :-
	agent_courage,			
	agent_goal(find_out),
	agent_orientation(O),
	Planned_O is (O+90) mod 360,
	agent_location(L),
	location_toward(L,Planned_O,Planned_L),
	deadly(Planned_L),
	no(is_wall(Planned_L)),		% Can't be a wall !!!	
	is_short_goal(find_out_turnleft__deadly),
	!.
	
act(strategy_find_out,turn_right) :-
	agent_courage,		
	agent_goal(find_out),
	agent_orientation(O),
	Planned_O is abs(O-90) mod 360,
	agent_location(L),
	location_toward(L,Planned_O,Planned_L),
	no(is_wall(Planned_L)),		% Can't be a wall !!!	
	deadly(Planned_L),
	is_short_goal(find_out_turnright__deadly),!.	
	
% Strategy to go out : I follow the wall helping the chance...
% I perfom this strategy in order to go out because
% I found gold
% I'm tired
% agent_hold or no(agent_courage) is True.

act(strategy_go_out,climb) :-
	agent_location([1,1]),
	is_short_goal(go_out___climb),
	!.	
	
act(strategy_go_out,forward) :-
	location_ahead(L),
	medium(L),
	no(is_wall(L)),
	is_short_goal(go_out_forward__medium),
	!.

act(strategy_go_out,turnleft) :-	% I'm interested by my left side
	agent_orientation(O),
	Planned_O is (O+90) mod 360,
	agent_location(L),
	location_toward(L,Planned_O,Planned_L),
	medium(Planned_L),
	no(is_wall(Planned_L)),
	is_short_goal(go_out_turnleft__medium),
	!.
	
act(strategy_go_out,turnright) :-	% I'm interested by my right side
	agent_orientation(O),
	Planned_O is abs(O-90) mod 360,
	agent_location(L),
	location_toward(L,Planned_O,Planned_L),
	medium(Planned_L),
	no(is_wall(Planned_L)),
	is_short_goal(go_out_turnright__medium),
	!.
			
act(strategy_go_out,turnleft) :-	% I want to change completely  
	is_short_goal(go_out_180__).	% my orientation ( 180 )
