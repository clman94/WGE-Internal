
[start]
void start()
{
	set_position(get_player(), vec(0.5,5.85));
}

[start]
void door_collision() {
  if(has_flag("room1_open")) {
    set_wall_group_enabled("door", false);
  }
}

[group door]
void open_door() {
  if(!has_flag("room1_open")) {
    say("click");
    set_flag("room1_open");
    set_wall_group_enabled("door", false);
    narrative::end();
  }
}

