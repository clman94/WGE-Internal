entity floaty_thing;

void create_floaty_thingy(vec pPosition)
{
	floaty_thing = add_entity("light", "light_thingy");
	set_anchor(floaty_thing, anchor::center);
	set_position(floaty_thing, pPosition);
	start_animation(floaty_thing);
}

void floaty_thingy_illuminate()
{
	while (true)
	{
		vec player_position = get_position(get_player());
		float distance = player_position.manhattan(get_position(floaty_thing));
		if (distance < 3)
		{
			// Make the player a bit blue when at a distance from the light
			// and then a bit yellow when near
			set_color(get_player()
				, int(255 - (155/3)*distance)
				, int(255 - (155/3)*distance)
				, int((255/3)*distance)
				, 255);
		}
		yield();
	}
}

void floaty_thingy_follow(bool pPlayer_illuminate = false)
{
	vec hover(0, 0);
	
	while(true)
	{
		vec player_position = get_position(get_player()) + vec(0, -0.5);
		vec light_position = get_position(floaty_thing);
		float distance = light_position.distance(player_position);
		
		if (pPlayer_illuminate && distance < 3)
		{
			set_color(get_player()
				, int(255 - (155/3)*distance)
				, int(255 - (155/3)*distance)
				, int((255/3)*distance)
				, 255);
		}
		
		if (distance > 1)
		{
			// Move towards player
			set_position(floaty_thing, move_towards(player_position, light_position, 3));
		}
		else{
			// Hover around when close
			if (rand()%100 == 0)
				hover = vec(random(-100, 100), random(-100, 100))*0.01*get_delta();
			set_position(floaty_thing, light_position + hover);
		}
		yield();
	}
}