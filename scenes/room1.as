
entity crack;
entity door;
entity food1;

[start]
void start() {
  set_position(get_player(), vec(0.5, 3));
  group::enable("food", false);
  set_z(get_player(), 0);
  door = add_entity("dungeon", "door");
  set_position(door, vec(6.76, 5));
}

[start]
void door_collision() {
  if(has_flag("room1_open")) {
    group::enable("door", false);
    set_visible(door, false);
  }
}

[start]
void food_drop() {
  if(!has_flag("food")) {
    wait(10);
    food1 = add_entity("dungeon", "food");
    set_position(food1, vec(1, 0.05));
    set_visible(food1, true);
    set_depth(food1, 0);
    move(food1, vec(1.5, 5), 5);
    set_depth(food1, 255);
    set_flag("food");
    group::enable("food", true);
  }
}

[start]
void wall() {
  if(!has_flag("wall_broken")) {
    crack = add_entity("dungeon", "wall_crack");
  } else {
    crack = add_entity("dungeon", "wall_crack_2");
  }
  set_position(crack, vec(3.5, 2));
  set_depth(crack, 255);
}

[group food]
void get_food() {
  if(has_flag("food") and not has_flag("wall_broken")) {
    //say("You got a food!");
    say("rumble rumble");
    set_flag("wall_broken");
    group::enable("wall_crack", true);
    set_atlas(crack, "wall_crack_2");
    remove_entity(food1);
    narrative::end();
  }
}

[group wall_crack]
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

[group testing]
void test_room() {
  load_scene("test");
}

[group extra]
void extra_room() 
{
	load_scene("Dark_Room");
}
