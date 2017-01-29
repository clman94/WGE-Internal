
namespace group
{
/*! \weakgroup Groups
 \{
*/

/// Enable or disable all walls/triggers/buttons/doors in group
void enable(const string&in pName, bool pIs_enabled)
{
	_set_wall_group_enabled(pName, pIs_enabled);
}

/// Check if group is enabled
bool is_enabled(const string&in pName)
{
	return _get_wall_group_enabled(pName);
}

/// \}
}
