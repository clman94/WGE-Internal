#include "backend/bounce.as"

[start]
void start() {
  set_position(get_player(), vec(4,4));
  set_z(get_player(), 0);
}

[start]
void shadow() {
  entity food = add_entity("dungeon", "food");
  set_depth(food, 255);
  while(true) {
    set_position(food, get_position(get_player()) - vec(0, -.5));
    yield();
  }
}

[start]
void lets_bounce() {
  while(true) {
    bounce(3);
    yield();
  }
}

