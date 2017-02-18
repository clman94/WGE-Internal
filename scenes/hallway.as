
array<entity> buttons;
entity door;
entity door1;

[start]
void start()
{
  set_position(get_player(), vec(4.5, 12));
  door = add_entity("dungeon", "door");
  set_position(door, vec(4.5, 13));
  door1 = add_entity("dungeon", "door");
  set_position(door1, vec(0.22, 10));
}

[start]
void door_collision() {
  if(has_flag("room1_open")) {
    set_visible(door1, false);
    group::enable("door", false);
  }
}

[start]
void make_buttons() {
  buttons.resize(3);
  for(int i = 0; i < 3; i++) {
    if(has_flag("button" + i)) {
      buttons[i] = add_entity("dungeon", "button_p");
    } else {
      buttons[i] = add_entity("dungeon", "button");
    }
    set_position(buttons[i], vec(1.5 + 3 * i, 3));
  }
}

[start]
void check_buttons() {
  while(!(has_flag("button0") && has_flag("button1") && has_flag("button2"))) {
    group::enable("freedom", true);
    yield();
  }
  set_visible(door, false);
  group::enable("freedom", false);
}

[group door]
void open_door() {
  if(!has_flag("room1_open")) {
    say("click");
    set_flag("room1_open");
    group::enable("door", false);
    set_visible(door1, false);
    narrative::end();
  }
}

[group button0]
void do_button0() {
  if(!has_flag("button0")) {
    say("click");
    set_flag("button0");
    set_atlas(buttons[0], "button_p");
    group::enable("button0", false);
    narrative::end();
  }
}

[group button1]
void do_button1() {
  if(!has_flag("button1")) {
    say("click");
    set_flag("button1");
    set_atlas(buttons[1], "button_p");
    group::enable("button1", false);
    narrative::end();
  }
}

[group button2]
void do_button2() {
  if(!has_flag("button2")) {
    say("click");
    set_flag("button2");
    set_atlas(buttons[2], "button_p");
    group::enable("button2", false);
    narrative::end();
  }
}

