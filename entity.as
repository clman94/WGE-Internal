/// \weakgroup Entity
/// \{

/// Basic anchoring of a graphical entity.
/// Anchoring is the offsetting of a graphical object
/// from the actual position based on its size. For example,
/// if we choose "center", the object that is rendered is centered
/// at the position.
/// \see set_anchor
enum anchor
{
	top = 0,
	topleft,
	topright,
	bottom,
	bottomleft,
	bottomright,
	left,
	right,
	center
};

enum direction
{
	other,
	left,
	right,
	up,
	down,
};

enum fixed_depth
{
	overlay,   ///< Above all world entities
	below,     ///< Below ALL world entities
	background ///< Below The tilemap
};

/// Set the anchor of an object.
///
/// Example: `set_anchor(my_entity, anchor::left);`
/// \see anchor
void set_anchor(entity pEntity, anchor pAnchor)
{
	_set_anchor(pEntity, pAnchor);
}

/// Set the depth of the entity at a specific fixed depth.
void set_depth(entity pEntity, fixed_depth pDepth)
{
	set_depth_fixed(pEntity, true);
	switch (pDepth)
	{
	case fixed_depth::overlay:
		set_depth(pEntity, -100000);
		break;
	case fixed_depth::below:
		set_depth(pEntity, 102);
		break;
	case fixed_depth::background:
		set_depth(pEntity, 100000);
		break;
	}
}

/// Calculate direction based on a vector.
direction vector_direction(vec pVec)
{
	if (abs(pVec.x) > abs(pVec.y))
	{
		if (pVec.x > 0)
			return direction::right;
		else
			return direction::left;
	}else{
		if (pVec.y > 0)
			return direction::down;
		else
			return direction::up;
	}
}

/// Set direction of an entity based on a vector
void set_direction(entity pEntity, vec pTowards)
{
	vec position = get_position(pEntity);
	set_direction(pEntity, vector_direction(pTowards - position));
}

/// Move entity to (pTo) position in (pSeconds) seconds
void move(entity pEntity, vec pTo, float pSeconds)
{
	if (is_character(pEntity))
		set_direction(pEntity, pTo);
		
	const vec initual_position = get_position(pEntity);
	const vec velocity = ((pTo - initual_position))/pSeconds;
	
	vec position = initual_position;
	
	float timer = 0;
	
	if (is_character(pEntity))
		start_animation(pEntity);
	while (timer < pSeconds)
	{
		const float delta = get_delta();
		timer += delta;
		position += velocity*delta;
		set_position(pEntity, position);
		yield();
	}
	set_position(pEntity, initual_position + (velocity*pSeconds)); // Ensure position
	if (is_character(pEntity))
		stop_animation(pEntity);
}

/// Move an entity to a position at a constant speed.
///
/// Example: `move(e, speed(13));`
/// \see speed
void move(entity pEntity, vec pTo, speed pSpeed)
{
	move(pEntity, pTo, pSpeed.get_time(get_position(pEntity).distance(pTo)));
}

/// Move in a direction at x distance in y seconds
void move(entity pEntity, direction pDirection, float pDistance, float pSeconds)
{
	if (is_character(pEntity))
		set_direction(pEntity, pDirection);
	
	vec velocity;
	
	switch(pDirection)
	{
	case direction::left:  velocity = vec(-1, 0); break;
	case direction::right: velocity = vec(1, 0);  break;
	case direction::up:    velocity = vec(0, -1); break;
	case direction::down:  velocity = vec(0, 1);  break;
	}
	
	velocity *= pDistance/pSeconds;
	
	const vec initual_position = get_position(pEntity);
	vec position = initual_position;
	
	float timer = 0;
	
	if (is_character(pEntity))
		start_animation(pEntity);
	while (timer < pSeconds)
	{
		float delta = get_delta();
		timer += delta;
		position += velocity*delta;
		set_position(pEntity, position);
		yield();
	}
	set_position(pEntity, initual_position + (velocity*pSeconds));  // Ensure position
	if (is_character(pEntity))
		stop_animation(pEntity);
}

/// Move in a direction at x distance at y speed
void move(entity pEntity, direction pDirection, float pDistance, speed pSpeed)
{
	move(pEntity, pDirection, pDistance, pSpeed.get_time(pDistance));
}

/// Set color of entity with A at 100%
/// Just a convenience function.
/// All values are 0-255.
void set_color(entity pEntity, int r, int g, int b)
{
	set_color(pEntity, r, g, b, 255);
}

/// Use path-finding to move a character to a position.
void pathfind_move(entity pEntity, vec pDestination, float pSpeed, float pWait_for_player = 0)
{
	if (pWait_for_player < 0)
	{
		eprint("pWait_for_player should not be less than 0");
		return;
	}

	array<vec> path;
	if (!find_path(path, get_position(pEntity).floor(), pDestination.floor()))
	{
		eprint("Could not find path");
		return;
	}
	for (uint i = 1; i < path.length(); i++)
	{
		if (pWait_for_player != 0)
		{
			const vec player_position = get_position(get_player());
			const vec position = get_position(pEntity);
			
			while (get_position(get_player()).distance(position) >= pWait_for_player)
			{
				set_direction(pEntity, player_position);
				yield();
			}
		}
		dprint(formatFloat(path[i].x) + ", " +  formatFloat(path[i].y));
		move(pEntity, path[i] + vec(0.5f, 0.5f), speed(pSpeed));
	}
}


/// Move entity up or down at a specific speed
void move_z(entity pEntity, float pToZ, float pSpeed)
{
	const float distance = abs(pToZ - get_z(pEntity));
	const float duration = distance / pSpeed;
	
	const float velocity = (pToZ < get_z(pEntity) ? -pSpeed : pSpeed);
	
	float timer = 0;
	while (timer <= duration)
	{
		yield();
		const float delta = get_delta();
		timer += delta;
		set_z(pEntity, get_z(pEntity) + (velocity*delta));
	}
	set_z(pEntity, pToZ);
}

/// \}