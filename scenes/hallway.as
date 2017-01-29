
[start]
void start()
{
	set_position(get_player(), vec(0.5,5.85));
}

[start]
void door_collision() {
  if(has_flag("room1_open")) {
    group::enable("door", false);
  }
}

[group door]
void open_door() {
  if(!has_flag("room1_open")) {
    say("click");
    set_flag("room1_open");
    group::enable("door", false);
    narrative::end();
  }
}

