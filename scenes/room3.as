
gui::selection_menu selection;
[start]
void thing() {
  selection.set_position(pixel(45, 218));
  
  gui::menu_item go("Go forth!");
  gui::menu_item stay("Stay here!");
  
  selection.add(go);
  selection.add(stay);
}

[start]
void start() {
  set_position(get_player(), vec(0, 2.85));
}

/*[start]
void void_flame() {
  entity fire = add_entity("void_flame");
  set_position(fire, vec( 2.5, 2.5));
}*/

[group portal]
void throne_room() {
  fsay("Do you wish to venture to the\nthrone room?");
  selection.open();
}

