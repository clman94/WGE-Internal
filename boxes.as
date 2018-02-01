
/*****************************************************************************************
How to use this

Create the texture which will be used to create the box (it doesn't need to be a standalone texture)

  - It needs 9 parts, aranged thusly (not necessarily in the texture itself, but that is recommended):
    
    [top_left_corner]    [top_edge]    [top_right_corner]
    
    [left_edge]          [center]      [right_edge]
    
    [bottom_left_corner] [bottom_edge] [bottom_right_corner]
    
  - Each corresponding part of the box must have an atlas entry with the name outlined above
    - E.g. in a texture "tex" the center of the box would have the atlas entry "center"
  
  - The dimensions of adjacent corners and edges must match for things to work correctly
    - E.g. a top_left_corner corner texture which is 2*3 should be with a top_edge of height 3
      and a left_edge of width 2
  
  - Additionally, opposite edges should be the same width/height 

If you're feeling a bit lazy, call it with pSymmetric = true (doesn't work yet)
  
  - You can make only one corner, one edge (top-left and top, respectively), and the center
  - label them 'corner' 'edge' and 'center'
  - you probably want to have square corners in this case

Actually making the box

  - Position is from the top-right corner and the size should be in game/tile units (use the pixel funtion)
 *****************************************************************************************/

/********
[0][1][2]
[3][4][5]
[6][7][8]
********/

class box
{
  
  box() {}
  
  //pSymmetric doesn't do anything yet
  box(const string&in pTexture, vec pPos, vec pSize, bool pSymmetric = false)
  {
    make_box(pTexture, pPos, pSize, pSymmetric);
  }
  
  ~box()
  {
    this.remove();
  }
  
  void make_box(const string&in pTexture, vec pPos, vec pSize, bool pSymmetric = false)
  {
    mSize = pSize;
    
    prepare_parts(pTexture, pSymmetric);
    
    //this is used for resizing if/when necessary
    //edge_size is the size of the sides of the edge pieces which don't change
    mEdge_size = get_size(mParts[0]);
    
    size_parts();
    
    mPos = pPos;
    
    for(int i = 0; i < 9; i++)
    {
      set_anchor(mParts[i], anchor::topleft);
      
      //because no safeguards
      if(i != 0)
        add_child(mParts[0], mParts[i]);
    }
    
    position_parts();
  }
  
  bool is_valid() const
  {
    for(uint i = 0; i < mParts.length(); i++)
      if(!mParts[i].is_valid())
        return false;
    return true;
  }
  
  vec get_position() const
  {
    return mPos;
  }
  
  void set_position(vec pPosition)
  {
    ::set_position(mParts[0], pPosition);
  }
  
  vec get_size(bool pIn_pixels = false) const
  {
    return (pIn_pixels ? mSize * 32 : mSize);
  }
  
  void set_size(vec pSize, bool pIn_pixels = false)
  {
    mSize = (pIn_pixels ? pixel(pSize) : pSize);
    update_parts();
  }
  
  vec get_border_size()
  {
    return mEdge_size;
  }
  
  void show()
  {
    set_visible(true);
  }
  
  void hide()
  {
    set_visible(false);
  }
  
  void set_visible(bool pVisible)
  {
    for(uint i = 0; i < mParts.length(); i++)
      ::set_visible(mParts[i], pVisible);
  }
  
  // This will leave the box in an invalid state.
  // hide() should be called instead.
  // Let the destructor do the clean-up, the engine
  // is very good about handling invisible entities.
  private void remove()
  {
    for(uint i = 0; i < mParts.length(); i++)
      if(mParts[i].is_valid())
        remove_entity(mParts[i]);
  }
  
  /********
  [0][1][2]
  [3][4][5]
  [6][7][8]
  ********/
  private void prepare_parts(string pTexture, bool pSymmetric)
  {
    
    //this didn't quite work and i don't feel like fixing it right now
    /*if(pSymmetric) {
      
      for(int i = 0; i < 9; i++) {
        
        switch(i % 2) {
          
          case 0:
            if(i == 4)
              mParts[i] = add_entity(pTexture, "center");
            else {
            
              mParts[i] = add_entity(pTexture, "corner");
              set_rotation(mParts[i], i/2 * 90);
              
            }
            break;
          
          case 1:
            mParts[i] = add_entity(pTexture, "edge");
            set_rotation(mParts[i], (i - 1)/2 * 90);
            break;
        }
        
      }
      
    } else {*/
      
      mParts[0] = add_entity(pTexture, "top_left_corner"     );
      mParts[1] = add_entity(pTexture, "top_edge"            );
      mParts[2] = add_entity(pTexture, "top_right_corner"    );
      mParts[3] = add_entity(pTexture, "left_edge"           );
      mParts[4] = add_entity(pTexture, "center"              ); //mmmmmmmmm
      mParts[5] = add_entity(pTexture, "right_edge"          );
      mParts[6] = add_entity(pTexture, "bottom_left_corner"  );
      mParts[7] = add_entity(pTexture, "bottom_edge"         );
      mParts[8] = add_entity(pTexture, "bottom_right_corner" );
      
    //}
    
    for(int i = 0; i < 9; i++)
      make_gui(mParts[i], 0);
  }
  
  private void position_parts()
  {
    const vec mid_size(mSize - (mEdge_size * 2));
    ::set_position(mParts[0], mPos);
    ::set_position(mParts[1], vec(mEdge_size.x, 0));
    ::set_position(mParts[2], vec(mEdge_size.x + mid_size.x, 0));
    ::set_position(mParts[3], vec(0, mEdge_size.y));
    ::set_position(mParts[4], mEdge_size);                               //not so mmmmmmm
    ::set_position(mParts[5], vec(mEdge_size.x + mid_size.x, mEdge_size.y));
    ::set_position(mParts[6], vec(0, mEdge_size.y + mid_size.y));
    ::set_position(mParts[7], vec(mEdge_size.x, mEdge_size.y + mid_size.y));
    ::set_position(mParts[8], mEdge_size + mid_size);
  }
  
  private void size_parts()
  {
    const vec mid_size(mSize - (mEdge_size * 2));
    
    //reset scales
    for(uint i = 0; i < 9; i++)
      set_scale(mParts[i], vec(1, 1));
      
    set_scale(mParts[1], vec(mid_size.x / get_size(mParts[1]).x, 1));
    set_scale(mParts[3], vec(1, mid_size.y / get_size(mParts[3]).y));
    set_scale(mParts[4], vec(mid_size.x / get_size(mParts[4]).x, mid_size.y / get_size(mParts[4]).y));
    set_scale(mParts[5], vec(1, mid_size.y / get_size(mParts[5]).y));
    set_scale(mParts[7], vec(mid_size.x / get_size(mParts[7]).x, 1));
  }
  
  private void update_parts()
  {
    position_parts();
    size_parts();
  }
  
  private vec get_size(entity e)
  {
    return pixel(::get_size(e));
  }
  
  private array<entity> mParts(9);
  
  private vec mSize;
  private vec mEdge_size;
  private vec mPos;
  
}

