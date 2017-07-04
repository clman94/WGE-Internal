#include "boxes.as"

/*
TODO: make the sizing of the menu more robust, allow changing/setting of rows and columns
make options a 2-d array?
refactor everything
*/

//Return values
enum menu_command
{
  back = -2,
  nothing = -1,
};

//this is currently useless
const vec border_padding = pixel(2, 2);

class menu
{
  menu() {}
  
  //pVertical determines whether columns or rows are prioritized when arranging the menu, and also some size priority
  menu(array<menu_item@> pOptions, vec pPosition, vec pOp_padding, bool pBox = true, bool pVertical = true, uint pCount = 1)
  {
    mCursor = add_entity("NarrativeBox", "SelectCursor");
    set_anchor(mCursor, anchor::topright);
    make_gui(mCursor, 1);
    
    mPosition = pPosition;
    
    mVertical = pVertical;
    
    mSize = (pVertical ? vec(pCount, 0) : vec(0, pCount));
    
    mOp_size = vec(0, 0);
    mOp_padding = pOp_padding;
    
    mBox.make_box("bawks", mPosition - mBox.get_border_size(), mOp_size * mSize + pixel(get_size(mCursor).x, 0) + mBox.get_border_size() * 2);    
    
    for(uint i = 0; i < pOptions.length(); i++)
      this.add_option(pOptions[i], i);
    
    mCurrent_selection = 0;
    
    update_positions();
  }
  
  ~menu()
  {
    this.remove();
  }
  
  //The 'main' function of the menu class
  //returns -1 if no selection has been made, -2 if the "back" control is triggered, or the selection number
  //usage will probably look like this:
  //menu menuthing(things);
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
      return menu_command::back;
    
    return menu_command::nothing;
  }
  
  void set_visible(bool pVisible)
  {
    for(uint i = 0; i < mOptions.length(); i++)
      mOptions[i].set_visible(pVisible);
    
    ::set_visible(mCursor, pVisible);
    
    if(mBox.is_valid())
    {
      if(pVisible)
        mBox.show();
      else
        mBox.hide();
    }
  }
  
  void show()
  {
    this.set_visible(true);
  }
  
  void hide()
  {
    this.set_visible(false);
  }
  
  array<menu_item@> get_options()
  {
    return mOptions;
  }
  
  menu_item@ get_option(uint pIndex)
  {
    return mOptions[pIndex];
  }
  
  void hide_cursor()
  {
    ::set_visible(mCursor, false);
  }
  
  void show_cursor()
  {
    ::set_visible(mCursor, true);
  }
  
  void remove()
  {
    for(uint i = 0; i < mOptions.length(); i++)
      if(mOptions[i].is_valid())
        mOptions[i].remove();
    
    if(mCursor.is_valid())
      remove_entity(mCursor);
    
    mBox.remove();
    
    while(mOptions.length != 0)
      mOptions.removeLast();
  }
  
  void add_option(menu_item@ pItem, uint pIndex = mOptions.length())
  {
    mOptions.insertAt(pIndex, pItem);
    
    update_size();
    
    if(pixel(mOptions[pIndex].get_size()).x > mOp_size.x)
      mOp_size.x = pixel(mOptions[pIndex].get_size()).x + mOp_padding.x * 2;
    if(pixel(mOptions[pIndex].get_size()).y > mOp_size.y)
      mOp_size.y = pixel(mOptions[pIndex].get_size()).y + mOp_padding.y * 2;
    
    update_box();
  }
  
  void remove_option(uint pIndex)
  {
    if(pIndex < mOptions.length())
      mOptions.removeAt(pIndex);
    else
      dprint("Menu: Attempt to remove out-of-bounds option.");
  }
  
  void set_option(uint pIndex, menu_item@ pItem)
  {
    if(pIndex < mOptions.length())
    {
      mOptions.removeAt(pIndex);
      mOptions.insertAt(pIndex, pItem);
    }
    else
      dprint("Menu: Attempt to edit out-of-bounds option.");
  }
  
  void clear_options()
  {
    mOptions.removeRange(0, mOptions.length());
  }
  
  void set_size(vec pSize)
  {
    mSize = pSize;
  }
  
  void set_position(vec pPosition)
  {
    mPosition = pPosition;
  }
  
  vec get_position()
  {
    return mPosition;
  }
  
  private void update_size()
  {
    if(mVertical)
    {
      int y = int(ceil(mOptions.length() / uint(mSize.x)));
      
      int x = uint(mSize.x);
      
      mSize = vec(x, y);
    }
    else
    {
      int x = int(ceil(mOptions.length() / uint(mSize.y)));
      
      int y = uint(mSize.y);
      
      mSize = vec(x, y);
    }
  }
  
  private void update_cursor()
  {
    ::set_position(mCursor, mOptions[mCurrent_selection].get_position());
  }
  
  private void update_positions()
  {
    for(uint i = 0; i < mOptions.length(); i++)
    {
      const vec pos_offset (mOp_size * (mVertical ? vec(floor(i / mSize.y), i % mSize.y) : vec(i % mSize.y, floor(i / mSize.y))));
      const vec centering = mOp_padding;
      mOptions[i].set_position(mPosition + pixel(get_size(mCursor).x, 0) + pos_offset + centering);
    }
    update_cursor();
  }
  
  private void update_box()
  {
    if(mBox.is_valid())
      mBox.set_size(mSize * mOp_size + pixel(get_size(mCursor).x, 0) + mOp_padding / 2 + mBox.get_border_size() * 2);
  }
  
  private uint mCurrent_selection;
  private vec mOp_size;
  private vec mOp_padding;
  private vec mSize;
  private vec mPosition;
  
  private bool mVertical;
  
  private array<menu_item@> mOptions;
  
  private entity mCursor;
  private box mBox;
}

//generic menu item thing, implement it to create a new 'menu type' (generally) (ish) - see text_entry and sprite_entry below
interface menu_item
{
  bool is_valid();
  
  vec get_size();
  
  void set_visible(bool);
  
  vec get_position();
  
  void set_position(vec);
  
  void remove();
  
  entity opConv();
}

class text_entry : menu_item
{
  text_entry() {}
  
  text_entry(string pText)
  {
    mText = add_text();
    set_text(mText, pText);
    set_anchor(mText, anchor::topleft);
    make_gui(mText, 1);
  }
  
  ~text_entry()
  {
    this.remove();
  }
  
  bool is_valid()
  {
    return mText.is_valid();
  }
  
  vec get_size()
  {
    return ::get_size(mText);
  }
  
  void set_visible(bool pVisible)
  {
    ::set_visible(mText, pVisible);
  }
  
  vec get_position()
  {
    return ::get_position(mText);
  }
  
  void set_position(vec pPos)
  {
    ::set_position(mText, pPos);
  }
  
  void remove()
  {
    remove_entity(mText);
  }
  
  entity opConv()
  {
    return mText;
  }
  
  private entity mText;
}

//TODO: possibly make more flexible in relative positioning
class text_sprite_entry : menu_item
{
  text_sprite_entry() {}
  
  text_sprite_entry(string pText, entity pSprite)
  {
    mText = add_text();
    set_text(mText, pText);
    set_anchor(mText, anchor::topleft);
    
    mSprite = pSprite;
    set_anchor(mSprite, anchor::topleft);
  }
  
  text_sprite_entry(string pText, string pTexture, string pAtlas = "default:default")
  {
    mText = add_text();
    set_text(mText, pText);
    set_anchor(mText, anchor::topleft);
    
    mSprite = add_entity(pTexture, pAtlas);
    set_anchor(mSprite, anchor::topleft);
    
    add_child(mText, mSprite);
    ::set_position(mSprite, vec(pixel(::get_size(mSprite)).x, (pixel(::get_size(mSprite)).y - pixel(::get_size(mText)).y) / 2));
  }
  
  ~text_sprite_entry()
  {
    this.remove();
  }
  
  bool is_valid()
  {
    return mText.is_valid() && mSprite.is_valid();
  }
  
  vec get_size()
  {
    const vec t_size = ::get_size(mText);
    const vec s_size = ::get_size(mSprite);
    return vec(t_size.y > s_size.y ? t_size.y : s_size.y, t_size.x + s_size.x);
  }
  
  void set_visible(bool pVisible)
  {
    ::set_visible(mText, pVisible);
    ::set_visible(mSprite, pVisible);
  }
  
  vec get_position()
  {
    return ::get_position(mSprite);
  }
  
  void set_position(vec pPos)
  {
    ::set_position(mSprite, pPos);
  }
  
  void remove()
  {
    remove_entity(mText);
    remove_entity(mSprite);
  }
  
  entity opConv()
  {
    //bad programming 101:
    //return (random(0,1) == 1 ? mSprite : mText);
    return mText;
  }
  
  private entity mText;
  private entity mSprite;
}

