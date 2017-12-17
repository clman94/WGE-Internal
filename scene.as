
#include"boxes.as"
#include "math.as"
#include "speed.as"
#include "vector_tools.as"
#include "scoped_entity.as"
#include "narrative.as"
#include "follow_character.as"
#include "music.as"
#include "fx.as"
#include "entity.as"
#include "groups.as"
#include "player.as"
#include "flags.as"
#include "game.as"
#include "focus.as"
#include "collision.as"
#include "menu.as"
#include "thread.as"
#include "../scenes/_global.as"

namespace priv_scene
{
	float previous_volume = 1;
}

[start]
void __fadein__()
{
	music::fade_volume(priv_scene::previous_volume, 0.5, thread());
	fx::fade_in(0.5, thread());
}

[door]
void __door__(const string&in scene, const string&in door)
{
	player::lock(true);
	
	priv_scene::previous_volume = music::get_volume();
	
	thread thread_fadeout;
	fx::fade_out(0.5, thread_fadeout);
	music::fade_volume(0, 0.5, thread_fadeout);
	thread_fadeout.wait();
	
	load_scene(scene, door);
}
