
#include "boxes.as"
#include "math.as"
#include "speed.as"
#include "vector_tools.as"
#include "scoped_entity.as"
#include "narrative.as"
#include "follow_character.as"
#include "music.as"
#include "fx.as"
#include "entity.as"
#include "player.as"
#include "flags.as"
#include "game.as"
#include "focus.as"
#include "collision.as"
#include "menu.as"
#include "thread.as"
#include "../scenes/_global.as"

namespace priv{
bool came_through_door = false;

}

bool has_came_through_door()
{
	return priv::came_through_door;
}

[start]
void __fadein__()
{
	//music::fade_volume(1, 0.5, thread());
	fx::fade_in(0.5, thread());
}

void load_scene(const string&in pName)
{
	dprint("Requesting scene load '" + pName + "'");
	values::set("_nosave/load_scene/request", true);
	values::set("_nosave/load_scene/scene", pName);
	values::remove("_nosave/load_scene/door"); // Make sure there is no door value
}

void load_scene(const string&in pName, const string&in pDoor)
{
	dprint("Requesting scene load '" + pName + "' to door '" + pDoor + "'");
	values::set("_nosave/load_scene/request", true);
	values::set("_nosave/load_scene/scene", pName);
	values::set("_nosave/load_scene/door", pDoor);
}

[start]
void handle_load_scene_request()
{
	if (values::exists("_nosave/load_scene/door"))
	{
		string door_name = values::get_string("_nosave/load_scene/door");
		values::remove("_nosave/load_scene/door");
		
		collision::box door = collision::find_door_by_name(door_name);
		if (!door)
		{
			eprint("Door with name '" + door_name + "' does not exist");
			return;
		}
		priv::came_through_door = true;
		
		player::priv::ensure_player_entity();
		set_direction(player::get(), vector_direction(collision::get_door_offset(door)));
		set_position(player::get(), collision::get_door_absolute_offset(door));
		focus::priv::update_player_focus();
	}
}
