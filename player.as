
namespace player
{
namespace priv
{
	float speed = 3;
	bool is_locked = false;
	bool is_walking = false;
	entity player_entity;
	
	void handle_player_movement()
	{
		vec move(0, 0);
		if (is_triggered("left"))  move.x -= 1;
		if (is_triggered("right")) move.x += 1;
		if (is_triggered("up"))    move.y -= 1;
		if (is_triggered("down"))  move.y += 1;
		
		if (move != vec(0, 0))
		{
			move.normalize();
			move *= speed*get_delta();
			
			// This is influenced by collision
			vec modified_move(move);
			
			bool has_collision = false;
			
			rect collision_box = get_collision_box();
			
			// Check if the x axis is blocked
			if (collision::is_colliding(rect(collision_box.get_offset() + vec(move.x, 0), collision_box.get_size())))
			{
				has_collision = true;
				modified_move.x = 0;
			}
			
			// Check if the y axis is blocked
			if (collision::is_colliding(rect(collision_box.get_offset() + vec(0, move.y), collision_box.get_size())))
			{
				has_collision = true;
				modified_move.y = 0;
			}
			
			// Handle Direction
			
			if (has_collision)
			{
				if (modified_move == vec(0, 0))
					set_direction(player_entity, vector_direction(move)); // Can't move but can still change direction
				else
					set_direction(player_entity, vector_direction(modified_move)); // Make sure the player is in the direction it is moving
			}
			else if (!is_walking) // Set first time
			{
				set_direction(player_entity, vector_direction(move));
			}
			else
			{
				direction dir = get_direction(player_entity);
				
				// Player direction locked left and right
				if (dir == direction::left
					|| dir == direction::right
					|| (move.x != 0 && move.y == 0))
					set_direction(player_entity, vector_direction(vec(move.x, 0)));
				
				// Recalculate direction for the next part
				dir = get_direction(player_entity);
				
				// Player direction locked up and down
				if (dir == direction::up
					|| dir == direction::down
					|| (move.x == 0 && move.y != 0))
					set_direction(player_entity, vector_direction(vec(0, move.y)));
			}
			
			move = modified_move;
		}	
		if (move != vec(0, 0))
		{
			set_position(player_entity, get_position(player_entity) + move);
			is_walking = true;
			animation::start(player_entity);
		}else
		{
			is_walking = false;
			animation::stop(player_entity);
		}
	}
	
	void handle_player_interactions()
	{
		rect collision_box = get_collision_box();
		
		if (is_triggered("activate"))
		{
			collision::box button_hit = collision::first_collision(collision::type::button, player::get_activation_point(1));
			if (button_hit)
			{
				string group_name = collision::get_group(button_hit);
				if (group_name.length() != 0)
					group::call_bindings(group_name);
			}
		}
		
		collision::activate_triggers(collision_box);
		
		collision::box door_hit = collision::first_collision(collision::type::door, collision_box);
		if (door_hit)
		{
			player::lock(true);
			fx::scene_fade_out();
			load_scene(collision::get_dest_scene(door_hit), collision::get_dest_door(door_hit));
		}
	}
	
	[start]
	void player_thread()
	{
		ensure_player_entity();
		do{
			if (!is_locked)
			{
				handle_player_movement();
				handle_player_interactions();
			}
			else if (is_walking)
			{ // Make sure animations are stopped
				animation::stop(player_entity);
				is_walking = false;
			}
		} while(yield());
	}
	
	void ensure_player_entity()
	{
		if (!player_entity.is_valid())
		{
			player_entity = add_character(player::texture);
		}
	}
}
	/// \weakgroup Player
	/// \{

	/// Set whether or not the player character will receive
	/// movement events (left, right, etc). When locked, the player will
	/// simply be unable to move.
	void lock(bool pIs_locked)
	{
		player::priv::is_locked = pIs_locked;
	}
	
	/// Check if player is locked
	bool is_locked()
	{
		return player::priv::is_locked;
	}
	
	/// Get main entity
	entity get()
	{
		return player::priv::player_entity;
	}
	
	void set_speed(float pSpeed)
	{
		player::priv::speed = pSpeed;
	}
	
	/// Get collision based on the entity.
	rect get_collision_box()
	{
		vec entitysize = get_size(player::priv::player_entity);
		vec size = vec(entitysize.x, entitysize.y / 3) / 32.f; // TODO: Use a get_unit function for something
		vec offset = get_position(player::priv::player_entity)
			- vec(size.x / 2, size.y);
		return rect(offset, size);
	}
	
	vec get_activation_point(float pDistance)
	{
		vec pos = get_position(player::priv::player_entity);
		switch (get_direction(player::priv::player_entity))
		{
		case direction::left:  return pos + vec(-pDistance, 0);
		case direction::right: return pos + vec(pDistance, 0);
		case direction::up:    return pos + vec(0, -pDistance);
		case direction::down:  return pos + vec(0, pDistance);
		default:               return pos;
		}
		return vec(0, 0);
	}
  
	/// \}
}