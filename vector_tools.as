/// \weakgroup Entity
/// \{


/// Convert pixel coordinate to in-game coordinates
vec pixel(float pX = 0, float pY = 0)
{
	return vec(pX, pY)/32;
}

/// Convert pixel coordinate to in-game coordinates
vec pixel(const vec&in pVec)
{
	return pVec/32;
}

/// Convenience function for moving a vector towards another at a specific speed.
vec move_towards(const vec&in pTarget, const vec&in pFollower, float pSpeed = 1)
{
	return pFollower + ((pTarget - pFollower).normalize()*get_delta()*pSpeed);
}

/// Calculate point between 2 points
vec midpoint(const vec&in a, const vec&in b)
{
  return (a + b)/2;
}

/// Vector to string
string vtos(const vec&in v)
{
  return "(" + v.x + ", " + v.y + ")";
}

/// \}
