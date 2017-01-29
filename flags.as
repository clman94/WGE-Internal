
/// \weakgroup Flags
/// \{


/// Exit thread if flag exists otherwise create the flag and continue.
/// This is useful in situations when you do not want a trigger to be activated more than one time.
/// \param pFlag Keyboard smash if you have no further use for it
void once_flag(const string&in pName)
{
	if (has_flag(pName))
		abort();
	set_flag(pName);
}

/// \}

