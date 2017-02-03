
namespace player
{
	/// \weakgroup Player
	/// \{

	/// Set whether or not the player character will receive
	/// movement events (left, right, etc). When locked, the player will
	/// simply be unable to move.
	void lock(bool pIs_locked)
	{
		_set_player_locked(pIs_locked);
	}
	
	/// Check if player is locked
	bool is_locked()
	{
		return _get_player_locked();
	}
	/// \}
}