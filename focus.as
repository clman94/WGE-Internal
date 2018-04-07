
namespace focus
{

namespace priv
{
	bool focus_player = true;
	
	
	// Use this if changing the player position doesn't update the focus
	void update_player_focus()
	{
		if (focus_player)
			_set_focus(get_position(player::get()));
	}
	
	[start]
	void player_focus_thread()
	{
		do{
			update_player_focus();
		} while (yield());
	}
}


/// \weakgroup Scene
/// \{

/// Gradually move focus point to position in x seconds
void move(vec pPosition, float pSeconds)
{
	vec focus = _get_focus();
	const vec velocity = (pPosition - focus)/pSeconds;
	
	float timer = 0;
	while (timer < pSeconds)
	{
		const float delta = get_delta();
		timer += delta;
		focus += velocity*delta;
		focus::set(focus);
		yield();
	}
	focus::set(pPosition); // Ensure position
}

void move(entity pEntity, vec pTo, speed pSpeed)
{
	focus::move(pTo, pSpeed.get_time(get().distance(pTo)));
}

/// Move in a direction at x distance in y seconds
void move(direction pDirection, float pDistance, float pSeconds)
{
	vec velocity;
	
	switch(pDirection)
	{
	case direction::left:  velocity = vec(-1, 0); break;
	case direction::right: velocity = vec(1, 0);  break;
	case direction::up:    velocity = vec(0, -1); break;
	case direction::down:  velocity = vec(0, 1);  break;
	}
	
	velocity *= pDistance/pSeconds;
	
	const vec initual_position = get();
	vec position = initual_position;
	
	float timer = 0;
	
	while (timer < pSeconds)
	{
		float delta = get_delta();
		timer += delta;
		position += velocity*delta;
		focus::set(position);
		yield();
	}
	focus::set(initual_position + (velocity*pSeconds));  // Ensure position
}

/// Move in a direction at x distance at y speed
void move(direction pDirection, float pDistance, speed pSpeed)
{
	focus::move(pDirection, pDistance, pSpeed.get_time(pDistance));
}

/// Set position of focus
/// Set location for camera to focus on.
/// The camera will automatically stay within the boundaries of the scene.
/// Player will lose focus when called.
void set(vec pPosition)
{
	focus::priv::focus_player = false;
	_set_focus(pPosition);
}

/// Get position of focus
vec get()
{
	return _get_focus();
}

/// Focus on player
void player(bool pFocus_player = true)
{
	focus::priv::focus_player = pFocus_player;
}
/// \}
}

