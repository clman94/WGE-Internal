
[start]
void start() {
  set_position(get_player(), vec(0.5, 3));
  set_focus(vec(2.5, 4));
}

[start]
void food_drop() {
  
  entity food = add_entity("dungeon", "food");
  set_visible(food, false);
  
  if(!has_flag("food")) {
    wait(10);
    set_position(food, vec(1, 0.05));
    set_visible(food, true);
    set_depth(food, 0);
    move(food, vec(1.5, 5), 5);
    set_depth(food, 255);
    set_flag("food");
  } else {
    set_visible(food, true);
    set_position(food, vec(1.5, 5));
  }
}

[trigger x=1 y=4 w=1 h=1]
void break_wall() {
  if(has_flag("food") and not has_flag("wall_broken")) {
    say("rumble rumble");
    narrative::hide();
    player::lock(false);
    set_flag("wall_broken");
  }
}

[button x=3 y=1 w=1 h=1]
void wall_crack() {
  if(not has_flag("wall_broken")) {
    say("A totally unsuspicious crack\nin the wall.");
    say("Nothing to see here.");
    narrative::hide();
    player::lock(false);
  } else {
    say("It appears you can fit\nthrough now.");
    load_scene("room2");
  }
}

[trigger x=3 y=1 w=1 h=0.95]
void next_room() {
  load_scene("room2");
}