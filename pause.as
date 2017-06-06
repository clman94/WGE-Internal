
#include "menu.as"
//i kinda don't want to do this...but stats
#include "../scenes/backend/user_data.as"

[start]
void check_pause() {
  
  do {
    
    if(is_triggered(control::activate))
      open_menu();
    
  } while(yield());
  
}


menu pause_menu;

const vec pause_menu_position = pixel(27, 27);
const vec pause_option_size   = pixel(80, 20);


void open_menu()
{
  if(!pause_menu.is_valid())
    _make_menu();
  else
    pause_menu.set_visible(true);
  
  player::lock(true);
  
  bool exit = false;
  
  do
  {
    
    switch(pause_menu.tick())
    {
      case -2:
        exit = true;
        break;
      
      case -1:
        break;
      
      // Stats
      case 0:
        open_stats();
        break;
      
      case 1:
        open_inv();
        break;
    }
    
  } while(!exit);
  
  pause_menu.set_visible(false);
  player::lock(false);
}

void _make_menu()
{
  array<string> pause_options = {"Stats", "Items"};
  pause_menu = menu(pause_options, pause_menu_position, 1, pause_option_size);
}

void open_stats()
{
  array<string> stats;
  
  stats.insertLast(formatInt(user_data.get_hp()));
  stats.insertLast(formatInt(user_data.get_atk()));
  stats.insertLast(formatInt(user_data.get_def()));
  
  menu stat_thing (stats, pause_menu_position, 1, pause_option_size);
  
  do
  {
    
    switch(pause_menu.tick())
    {
      case -2:
        exit = true;
        break;
      
      case -1:
        break;
      
      // Stats
      case 0:
        open_stats();
        break;
      
      case 1:
        open_inv();
        break;
    }
    
  } while(!exit);
}

void open_inv()
{
  array<string> inv_list = user_data.get_inventory_items();
  array<entity> inv_sprites(inv_list.length());
  
  for(int i = 0; i < inv_sprites.length(); i++)
  {
    array<string> info = get_item_sprite(inv_list[i]);
    inv_sprites[i] = add_entity(info [0], info[1]);
  }
  
  menu inv (inv_list, puase_menu_position, 1, pause_option_size + pixel(26, 0));
  
  do
  {
    
    switch(pause_menu.tick())
    {
      case -2:
        exit = true;
        break;
      
      case -1:
        break;
      
      // Stats
      case 0:
        open_stats();
        break;
      
      case 1:
        open_inv();
        break;
    }
    
  } while(!exit);
}

