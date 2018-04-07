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
	
	float binomial_coeff(float n, float k)
	{
		if (k > n)
			eprint("n > k");
		float mul = 1;
		for (uint i = 1; i <= k; i++)
			mul *= (n + 1 - i)/float(i);
		return mul;
	}
	
	/// Simple linear interpolation
	float lerp(float p0, float p1, float t)
	{
		if (t <= 0)
			return p0;
		if (t >= 1)
			return p1;
		return p0*(1 - t) + p1*t;
	}
	
	/// Simple linear interpolation
	vec lerp(const vec&in p0, const vec&in p1, float t)
	{
		if (t <= 0)
			return p0;
		if (t >= 1)
			return p1;
		return p0*(1 - t) + p1*t;
	}
	
	/// Quadratic Bezier curve
	vec quad_bezier_curve(const vec&in p0, const vec&in p1, const vec&in p2, float t)
	{
		if (t <= 0)
			return p0;
		if (t >= 1)
			return p2;
		float invt = 1 - t;
		return (p0*invt + p1*t)*invt + (p1*invt + p2*t)*t;
	}
	
	/// Bezier curve to the nth degree.
	vec bezier_curve(array<vec>@ p, float t)
	{
		if (p.length() == 0)
			return vec(0, 0);
		if (p.length() == 1)
			return p[0];
		if (t <= 0)
			return p[0];
		if (t >= 1)
			return p[p.length() - 1];
		vec sum(0, 0); // Summation of the parts
		for (uint i = 0; i < p.length(); i++)
			sum +=  p[i] * binomial_coeff(p.length() - 1, i) * pow(t, float(i)) * pow(1 - t, float(p.length() - i) - 1);
		return sum;
	}
	
}
