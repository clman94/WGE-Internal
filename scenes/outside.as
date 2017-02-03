
entity spoopy;

[start]
void start() {
  set_position(get_player(), vec(7.5, 22));
}

[start]
void make_spoopy() {
  spoopy = add_entity("spoopyer", "blank_right");
  set_position(spoopy, vec(18.5, 3));
}

[group funtimes]
void go_back() {
  load_scene("hallway");
}

[group spoop]
void spoop() {
  
  player::lock(true);
  
  vec pl_pos = get_position(get_player());
  vec mid = vec(get_position(spoopy).x, pl_pos.y);
  
  set_direction(get_player(), direction::up);
  
  wait(1);
  move_focus(mid, 1.1 * pl_pos.distance(mid));
  
  wait(1);
  move_focus(get_position(spoopy), 3);
  
  narrative::set_speaker(spoopy);
  set_atlas(spoopy, "talk_blank");
  say("...Hmm?");
  
  move_focus(pl_pos, .15 * pl_pos.distance(get_focus()));
  player::focus();
  group::enable("spoop", false);
  narrative::end();
  player::lock(false);
}

[group to_spoop]
void to_spoop() {
  set_position(get_player(), vec(18.5, 9));
}

