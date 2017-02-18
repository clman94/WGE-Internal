
entity spoopy;
entity alpa;
entity magic;

[start]
void start() {
  set_position(get_player(), vec(7.5, 22));
  set_flag("normal_text");
}

[start]
void tension() {
  spoopy = add_entity("spoopyer", "blank_right");
  set_position(spoopy, vec(18.5, 3));
  alpa = add_entity("alpa");
  set_position(alpa, vec(18.5, 7));
}

[start]
void stupid_magic_function_thingy_because_spinning_is_hard() {
  magic = add_entity("void_ball");
  set_visible(magic, false);
  set_anchor(magic, anchor::center);
  set_position(magic, vec(5, 22));
  
  const float pFreq = 3;
  
  float w = 360 * pFreq;
  float theta = 0;
  
  do {
    theta += w * get_delta();
    set_rotation(magic, theta);
  } while(yield());
}

[group funtimes]
void go_back() {
  load_scene("hallway");
}

[group magical]
void magic_sign() {
  say("This is a magic sign!");
  if(has_flag("normal_text")) {
    say("Text is now slower!");
    unset_flag("normal_text");
  } else {
    say("Text is now boring again!");
    set_flag("normal_text");
  }
  narrative::end();
  player::lock(false);
}

[group spoop]
void spoop() {
  
  player::lock(true);
  
  narrative::set_skip(false);
  
  vec pl_pos = get_position(get_player());
  vec mid = vec(get_position(spoopy).x, pl_pos.y);
  
  set_direction(get_player(), direction::up);
  
  wait(1.5);
  focus::move(mid, 1.1 * pl_pos.distance(mid));
  
  wait(1);
  focus::move(get_position(spoopy), 3);
  
  narrative::set_speaker(spoopy);
  set_atlas(spoopy, "talk_blank");
  say("...Hmm?");
  wait(.7);
  
  say("Oh.\n");
  wait(1);
  append("One of them managed to get out.");
  narrative::hide();
  
  wait(.7644);
  
  say("Well.");
  wait(.75);
  
  narrative::clear_speakers();
  say("\n");
  narrative::set_speed(1);
  append("... ");
  
  if(has_flag("normal_text"))
    narrative::set_interval(30);
  
  narrative::set_speaker(spoopy);
  say("I guess I should take care of\nthis.");
  wait(1.5);
  narrative::end();
  
  wait(1);
  entity battle = add_entity("battle!!");
  set_anchor(battle, anchor::center);
  set_depth(battle, fixed_depth::overlay);
  set_position(battle, focus::get() + vec(0, 1));
  wait(5);
  remove_entity(battle);
  
  focus::move(mid, .15 * mid.distance(focus::get()));
  focus::move(get_position(get_player()), .15 * pl_pos.distance(mid));
  focus::player();
  group::enable("spoop", false);
  //remove_entity(spoopy);
  narrative::set_skip(true);
  player::lock(false);
}

[group alpa]
void alpa_v_spoop() {
  
  player::lock(true);
  
  narrative::set_skip(false);
  
  vec pl_pos = get_position(get_player());
  vec mid = vec(get_position(spoopy).x, pl_pos.y);
  
  set_direction(get_player(), direction::up);
  
  wait(1.5);
  focus::move(mid, 1.1 * pl_pos.distance(mid));
  
  wait(1);
  focus::move(get_position(spoopy), 3);
  
  {
   set_position(magic, vec(20, 7));
   set_visible(magic, true);
   
   
   say("");
   
   narrative::set_speaker(spoopy);
   say("");
   
  }
  
  focus::move(mid, .15 * mid.distance(focus::get()));
  focus::move(get_position(get_player()), .15 * pl_pos.distance(mid));
  focus::player();
  group::enable("alpa", false);
  //remove_entity(spoopy);
  narrative::set_skip(true);
  narrative::end();
  player::lock(false);
}

[group to_spoop]
void to_spoop() {
  set_position(get_player(), vec(18.5, 9));
}

