
/// \weakgroup Game
/// \{

/// Basic controls that are supported in the engine.
/// There are 2 different types of controls: pressed and held.
/// Pressed controls are only activated once in only one frame and
/// in any other frame (even if it's still being held) it will not be considered
/// activated. Held controls are simply always activated when the key is down.
/// \see is_triggered
enum control
{
	activate = 0,     ///< Typically the enter and Z key (Pressed)
	left,             ///< (Held)
	right,            ///< (Held)
	up,               ///< (Held)
	down,             ///< (Held)
	select_next,      ///< Typically the right key (Pressed)
	select_previous,  ///< Typically the left key (Pressed)
	select_up,        ///< Typically the up key (Pressed)
	select_down,      ///< Typically the down key (Pressed)
	back,             ///< X key, go back or exit (Pressed)
	menu,             ///< Typically the M key (Pressed)
};

/// Check if a control as been activated
bool is_triggered(control pControls)
{
	return _is_triggered(pControls);
}
/// \}
