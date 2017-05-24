
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

Actually making the box

  - If you want some sort of fancy pattern to your box, you probably want to use make_box_tiled,
    as make_box will stretch the textures used. This will be more performance-costly, however.

  - Position is from the top-right corner and the size should be in game units (use the pixel funtion)
 *****************************************************************************************/

/********
[0][1][2]
[3][4][5]
[6][7][8]
********/
 
class box
{
  
  //pSymmetric doesn't do anything yet
  box(string pTexture, vec pSize, vec pPos, bool pSymmetric = false) {
    
    mSize = pSize;
    
    prepare_parts(pTexture, pSymmetric);
    
    //this is used for resizing if/when necessary
    //edge_size is the size of the sides of the edge pieces which don't change
    edge_size = gs(mParts[0]);
    //mid_size is the sides which do change
    mid_size = mSize - (edge_size * 2);
    
    size_parts();
    
    position_parts(pPos);
    
  }
  
  /*
  void make_box_tiled(string pTexture, vec pSize, vec pPos) {
    
    
    
  }
  */
  
  vec get_pos() {
    
    return get_position(mParts[1]);
    
  }
  
  void set_pos(vec pPos) {
    
    set_position(mParts[0], pPos);
    
  }
  
  vec size(bool in_pixels = false) {
    
    return (in_pixels ? mSize * 32 : mSize);
    
  }
  
  void set_size(vec pSize, bool in_pixels = false) {
    
    mSize = (in_pixels ? pixel(pSize) : pSize);
    
    update_parts();
    
  }
  
  /********
  [0][1][2]
  [3][4][5]
  [6][7][8]
  ********/
  private void prepare_parts(string pTexture, bool pSymmetric) {
    
    mParts[0] = add_entity(pTexture, "top_left_corner"     );
    mParts[1] = add_entity(pTexture, "top_edge"            );
    mParts[2] = add_entity(pTexture, "top_right_corner"    );
    mParts[3] = add_entity(pTexture, "left_edge"           );
    mParts[4] = add_entity(pTexture, "center"              ); //mmmmmmmmm
    mParts[5] = add_entity(pTexture, "right_edge"          );
    mParts[6] = add_entity(pTexture, "bottom_left_corner"  );
    mParts[7] = add_entity(pTexture, "bottom_edge"         );
    mParts[8] = add_entity(pTexture, "bottom_right_corner" );
    
    for(int i = 0; i < 9; i++) {
      
      make_gui(mParts[i], 0);
      
    }
    
  }
  
  private void position_parts(vec pOrigin) {
    
    for(int i = 0; i < 9; i++) {
      
      set_anchor(mParts[i], anchor::topleft);
      
      //because no safeguards
      if(i != 0)
        add_child(mParts[0], mParts[i]);
      
    }
    
    vec edge_size = gs(mParts[0]);
    
    set_position(mParts[0], pOrigin);
    set_position(mParts[1], vec(edge_size.x, 0));
    set_position(mParts[2], vec(edge_size.x + mid_size.x, 0));
    set_position(mParts[3], vec(0, edge_size.y));
    set_position(mParts[4], edge_size);                               //not so mmmmmmm
    set_position(mParts[5], vec(mSize.x - edge_size.x, edge_size.y));
    set_position(mParts[6], vec(0, mSize.y - edge_size.y));
    set_position(mParts[7], vec(edge_size.x, mSize.y - edge_size.y));
    set_position(mParts[8], mSize - edge_size);
    
  }
  
  private void size_parts() {
    
    set_scale(mParts[1], vec(mid_size.x / gs(mParts[1]).x, 1));
    set_scale(mParts[3], vec(1, mid_size.y / gs(mParts[3]).y));
    set_scale(mParts[4], vec(mid_size.x / gs(mParts[4]).y, mid_size.y / gs(mParts[4]).y));
    set_scale(mParts[5], vec(1, mid_size.y / gs(mParts[5]).y));
    set_scale(mParts[7], vec(mid_size.x / gs(mParts[7]).x, 1));
    
  }
  
  private void update_parts() {
    
    mid_size = mSize - (edge_size * 2);
    
    position_parts(get_pos());
    
    size_parts();
    
  }
  
  private vec gs(entity e) {
    
    return pixel(get_size(e));
    
  }
  
  private array<entity> mParts(9);
  
  private vec mSize;
  private vec edge_size;
  private vec mid_size;
  
}

