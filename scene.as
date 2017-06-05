
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

[start]
void __fadein__()
{
	fx::fade_in(0.5);
}

[door]
void __door__(const string&in scene, const string&in door)
{
	player::lock(true);
	fx::fade_out(0.5);
	load_scene(scene, door);
}
