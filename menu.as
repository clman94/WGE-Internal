#include "boxes.as"

/*
TODO: make the sizing of the menu more robust, allow changing/setting of rows and columns
make options a 2-d array?
*/


//may change/make chaneable
const vec border_padding = pixel(3, 3);

class menu
{
  
  menu() {}
  
  menu(array<string> pOptions, vec pPosition, uint pColumns = 1, vec pOp_size = pixel(60, 20), bool pBox = true)
  {
    mCursor = add_entity("NarrativeBox", "SelectCursor");
    set_anchor(mCursor, anchor::topright);
    make_gui(mCursor, 1);
    
    mOp_size = pOp_size;
    
    mPosition = pPosition;
    
    for(uint i = 0; i < pOptions.length(); i++)
      this.add_option(pOptions[i], i);
    
    update_size(pColumns);
    
    if(pBox) //                                     pemdas
      mBox = box("bawks", mPosition, mSize * pOp_size + border_padding * 2);
    else
      mBox = box();
    
    mCurrent_selection = 0;
    
    update_positions();
  }
  
  ~menu()
  {
    this.remove();
  }
  
  //The 'main' function of the menu class
  //returns -1 if no selection has been made, -2 is the "back" control is triggered, or the selection number
  //usage will probably look like this: `
  //menu menuthing();
  //  //add stuff
  //do
  //{
  //  switch(menuthing.tick())
  //  {
  //     //handle stuff
  //  }
  //} while(yield);
  int tick()
  {
    
    if(is_triggered("select_up")    && mCurrent_selection % mSize.y != 0)
      --mCurrent_selection;
    
    if(is_triggered("select_down")  && mCurrent_selection % mSize.y != mSize.y -1 && mCurrent_selection != mOptions.length() - 1)
      mCurrent_selection++;
    
    if(is_triggered("select_left")  && floor(mCurrent_selection / mSize.y) != 0)
      mCurrent_selection -= int(mSize.y);
    
    if(is_triggered("select_right") && floor(mCurrent_selection / mSize.y) != mSize.x - 1 && mOptions[mCurrent_selection + int(mSize.y)].is_valid())
      mCurrent_selection += int(mSize.y);
    
    update_positions();
    
    if(is_triggered("activate"))
      return mCurrent_selection;
    
    if(is_triggered("back"))
      return -2;
    
    return -1;
  }
  
  //Set visibility
  void set_visible(bool pVisible)
  {
    for(uint i = 0; i < mOptions.length(); i++)
      ::set_visible(mOptions[i], pVisible);
    
    if(mBox.is_valid())
    {
      if(pVisible)
        mBox.show();
      else
        mBox.hide();
    }
  }
  
  array<entity>@ get_options()
  {
    return @mOptions;
  }
  
  void hide_cursor()
  {
    ::set_visible(mCursor, false);
  }
  
  void show_cursor()
  {
    ::set_visible(mCursor, true);
  }
  
  bool is_valid()
  {
    return !(mOptions.length() == 0)
  }
  
  //Removes the box, text, and cursor permanently
  void remove()
  {
    for(uint i = 0; i < mOptions.length(); i++)
      if(mOptions[i].is_valid())
        remove_entity(mOptions[i]);
    if(mCursor.is_valid())
      remove_entity(mCursor);
    mBox.remove();
    while (mOptions.length() != 0)
      mOptions.removeLast();
  }
  
  //Appends and option to the option list
  void add_option(string pText, uint pIndex = mOptions.length())
  {
    entity text = add_text();
    set_text(text, pText);
    set_anchor(text, anchor::topleft);
    
    mOptions.insertAt(pIndex, text);
    make_gui(mOptions[pIndex], 1);
  }
  
  //Removes an option
  void remove_option(uint pIndex)
  {
    if(pIndex < mOptions.length())
      mOptions.removeAt(pIndex);
    else
      dprint("Menu: Attempt to remove out-of-bounds option.");
  }
  
  //Changes the text of an option
  void set_option(uint pIndex, string pText)
  {
    if(pIndex < mOptions.length())
      set_text(mOptions[pIndex], pText);
    else
      dprint("Menu: Attempt to edit out-of-bounds option.");
  }
  
  void set_size(vec pSize)
  {
    mSize = pSize;
  }
  
  void set_position(vec pPosition)
  {
    mPosition = pPosition;
    update_positions();
  }
  
  private void update_size(uint pColumns)
  {
    
    int y = int(ceil(mOptions.length() / pColumns));
    
    int x = pColumns;
    
    mSize = vec(x, y);
    
  }
  
  private void update_cursor()
  {
    ::set_position(mCursor, get_position(mOptions[mCurrent_selection]));
  }
  
  private void update_positions()
  {
    
    for(uint i = 0; i < mOptions.length(); i++)
      ::set_position(mOptions[i], mPosition + border_padding + (mOp_size * vec(floor(i / mSize.y), i % mSize.y)));
      
    update_cursor();
    
  }
  
  private uint mCurrent_selection;
  private vec mOp_size;
  private vec mSize;
  private vec mPosition;
  
  private array<entity> mOptions;
  
  private entity mCursor;
  private box mBox;
}

