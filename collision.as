
namespace collision
{

enum type
{
  wall,
  trigger,
  button,
  door
};

box create(vec pPosition, vec pSize)
{
  return create(type::wall, pPosition, pSize);
}

box create(type pType, vec pPosition, vec pSize)
{
  box new_box = _create_box(int(pType));
  set_size(new_box, pSize);
  set_position(new_box, pPosition);
  return new_box;
}

box create(type pType)
{
  return _create_box(int(pType));
}

}