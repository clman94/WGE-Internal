
namespace focus
{
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
		_set_focus(focus);
		yield();
	}
	_set_focus(pPosition); // Ensure position
}

/// Set position of focus
/// Set location for camera to focus on.
/// The camera will automatically stay within the boundaries of the scene.
/// Player will lose focus when called.
void set(vec pPosition)
{
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
	_focus_player(pFocus_player);
}
/// \}
}

