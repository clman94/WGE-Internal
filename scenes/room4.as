
[start]
void start() {
  set_position(get_player(), vec(0, 2.85));
}

[group fl_sign]
void fl_sign() {
  say("You see those flowers?");
  say("They will repeat whatever was\nlast said.");
  player::lock(false);
  narrative::end();
}

[group echo]
void echo() {
  say("");
  player::lock(false);
  narrative::end();
}

