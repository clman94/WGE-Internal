/// \weakgroup FX
/// \{

namespace fx
{

/// \weakgroup FX
/// \{

/// Play sound.
void sound(const string&in pName, float pVolume = 100, float pPitch = 1)
{
	_spawn_sound(pName, pVolume, pPitch);
}

/// Stop all sound effects that might be playing.
void stop_all()
{
	_stop_all();
}

/// Shake camera. Kind-of like a rumble effect.
void shake(float pSeconds, float pAmount)
{
	const vec original_focus = _get_focus();
	
	float timer = 0;
	float shake_timer = 0;
	while (timer < pSeconds)
	{
		const float delta = get_delta();
		timer += delta;
		shake_timer += delta;
		
		if (shake_timer >= 0.07)
		{
			shake_timer = 0;
			_set_focus(original_focus + vec(pAmount, 0).rotate(random(0, 360)));
		}
		
		yield();
	}
	_set_focus(original_focus);
}
	
/// Fade in to scene
void fade_in(float pSeconds)
{
	if (pSeconds <= 0)
	{
		eprint("Seconds <= 0");
		return;
	}
	float t = 0;
	while (t < 1 && yield())
	{
		t += get_delta()/pSeconds;
		set_overlay_opacity(math::lerp(1, 0, t));
	}
}

void fade_in(float pSeconds, thread@ pThread)
{
	pThread.thread_start();
	create_thread(
	function(pArgs)
	{
		const float pSeconds = float(pArgs["pSeconds"]);
		fade_in(pSeconds);
		cast<thread@>(pArgs["pThread"]).thread_end();
	}, dictionary = {
		{"pSeconds", pSeconds},
		{"pThread", pThread}});
}

/// Fade out from scene
void fade_out(float pSeconds)
{
	if (pSeconds <= 0)
	{
		eprint("Seconds <= 0");
		return;
	}
	float t = 0;
	while (t < 1 && yield())
	{
		t += get_delta()/pSeconds;
		set_overlay_opacity(math::lerp(0, 1, t));
	}
}

void fade_out(float pSeconds, thread@ pThread)
{
	pThread.thread_start();
	
	create_thread(
	function(pArgs)
	{
		fade_out(float(pArgs["pSeconds"]));
		cast<thread@>(pArgs["pThread"]).thread_end();
	}, dictionary = {
		{"pSeconds", pSeconds},
		{"pThread", pThread}});
}

/// Slowly decrease the opacity of the entity to
/// "fade" it out.
void fade_out(entity pEntity, float pSeconds)
{
	float t = 0;
	while (t < 1 && yield())
	{
		t += get_delta()/pSeconds;
		set_color(pEntity, 1, 1, 1, math::lerp(1, 0, t));
	}
}

/// Slowly increase the opacity of the entity to
/// "fade" it in.
void fade_in(entity pEntity, float pSeconds)
{
	float t = 0;
	while (t < 1 && yield())
	{
		t += get_delta()/pSeconds;
		set_color(pEntity, 1, 1, 1, math::lerp(0, 1, t));
	}
}

void scene_fade_out()
{
	thread thread_fadeout;
	fx::fade_out(0.5, thread_fadeout);
	music::fade_volume(0, 0.5, thread_fadeout);
	thread_fadeout.wait();
}

/// \}

}



/// \}