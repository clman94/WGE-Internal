
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

[start]
void make_numbers() {
  for(int i = 1; i <= 4; i++) {
    entity number = add_entity("numbers", formatInt(i, '', 0));
    switch(i) {
      case 1:
        set_position(number, vec(1, 5));
        break;
      case 2:
        set_position(number, vec(1, 9));
        break;
      case 3:
        set_position(number, vec(8, 5));
        break;
      case 4:
        set_position(number, vec(8, 9));
        break;
    }
  set_depth(number, 255);
  }
}

[button x=-0.5 y=9 w=1 h=1]
void open_door() {
  if(!has_flag("room1_open")) {
    say("click");
    set_flag("room1_open");
    set_wall_group_enabled("door", false);
    narrative::end();
  }
}

