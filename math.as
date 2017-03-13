// Just some extra math functions

/// Random value in a range
int random(int min, int max)
{
	return (rand()%(max - min)) + min;
}

int abs(int val)
{
	return val < 0 ? -val : val;
}

namespace math
{
	const float pi = 3.14159265;
}
