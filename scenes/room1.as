#include "backend/user_data.as"

player_data@ player;

[start]
void start() {
  set_position(get_player(), vec(0.5, 3));
  group::enable("food", false);
}

[start]
void door_collision() {
  if(has_flag("room1_open")) {
    group::enable("door", false);
  }
}

[start]
void food_drop() {
  if(!has_flag("food")) {
    wait(10);
    entity food = add_entity("dungeon", "food");
    set_position(food, vec(1, 0.05));
    set_visible(food, true);
    set_depth(food, 0);
    move(food, vec(1.5, 5), 5);
    set_depth(food, 255);
    set_flag("food");
    group::enable("food", true);
  }
}

[group food]
void get_food() {
  if(has_flag("food") and not has_flag("wall_broken")) {
    //say("You got a food!");
    
    say("rumble rumble");
    narrative::hide();
    player::lock(false);
    set_flag("wall_broken");
    group::enable("wall_crack", true);
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

[trigger x=3 y=1 w=1 h=0.95]
void next_room() {
  load_scene("room2");
}