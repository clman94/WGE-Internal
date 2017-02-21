
entity spoopy;
entity alpa;
array<entity> magic;

[start]
void start() {
  set_position(get_player(), vec(7.5, 22));
  set_flag("normal_text");
}

[start]
void tension() {
  spoopy = add_entity("spoopy", "back_up_talk");
  set_position(spoopy, vec(18.5, 6.8));
  alpa = add_entity("alpa");
  set_position(alpa, vec(18.5, 3.5));
}

[start]
void stupid_magic_function_thingy_because_spinning_is_hard() {
  for(int i = 0; i < 3; i ++) {
    magic.insertLast(add_entity("void_ball"));
    set_visible(magic[i], false);
    set_anchor(magic[i], anchor::center);
  }
  
  const float pFreq = 3;
  
  float w = 360 * pFreq;
  float theta = 0;
  
  do {
    theta += w * get_delta();
    for(int i = 0; i < 3; i++) {
      set_rotation(magic[i], theta);
    }
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
  vec final = midpoint(get_position(spoopy), get_position(alpa)) + vec(0, .5);
  
  set_direction(get_player(), direction::left);
  
  wait(.5);
  focus::move(mid, .5 * pl_pos.distance(mid));
  
  wait(1);
  focus::move(final, 2);
  
  wait(.5);
  
  set_position(magic[0], vec(18.5, get_position(alpa).y - 1.5));
  set_depth(magic[0], 0);
  set_visible(magic[0], true);
  
  narrative::set_speaker(alpa);
  say("Release them!");
  
  narrative::hide();
  
  set_depth(magic[0], 255);
  move(magic[0], get_position(spoopy) + vec(0, -.3), .75);
  
  narrative::set_speaker(spoopy);
  wait(1);
  
  say("Heh heh heh.");
  say("You really thought you could\ndefeat me with such an assault?");
  say("How incredibly hilarious.");
  say("Unfortuantely for you, it is,\nshall we say, insufficient.");
  narrative::hide();
  
  set_position(magic[1], get_position(spoopy) + vec(-2, .5));
  set_position(magic[2], get_position(spoopy) + vec(2, .5));
  
  set_visible(magic[1], true);
  wait(.25);
  set_visible(magic[2], true);
  
  {
   vec target = get_position(alpa) + vec(0, -.5);
   
   for(int i = i; i < 3; i++) {
     set_depth(magic[i], 0);
     move(magic[i], target, .25);
   }
   
   say("Now, you will die.");
   narrative::hide();
   
   for(int i =0; i < 5; i++) {
     set_position(magic[1], get_position(spoopy) + vec(-2, .5));
     set_position(magic[2], get_position(spoopy) + vec(2, .5));
     move(magic[1], target, .25);
     move(magic[2], target, .25);
   }
  }
  
  //death animation
  remove_entity(alpa);
  
  for(int i = 0; i < 3; i++) {
    remove_entity(magic[i]);
  }
  
  wait(.5);
  
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
  set_position(get_player(), vec(23, 9));
}

