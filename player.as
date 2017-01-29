
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
	
	/// Set the focus of the camera to either focus on the player
	/// or freely move around. When function like set_focus are used,
	/// the focus on the player is automatically removed.
	///
	/// This function can be called without any parameters to focus on player.
	void focus(bool pIs_focus = true)
	{
		focus_player(pIs_focus);
	}
	
	/// Unfocus player.
	void unfocus()
	{
		focus_player(false);
	}
	
	/// \}
}