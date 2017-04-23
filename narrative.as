/*! \weakgroup Narrative



 \{
 */

/// A return from a 2 choice selection.
/// \see select
enum option
{
	first,
	second
};

/// \}

namespace narrative
{
namespace priv
{	
	array<entity> speakers;
	void validate_speaker(uint i)
	{
		if (!speakers[i].is_valid())
			speakers.removeAt(i);
	}
	void start_speakers()
	{
		for (uint i = 0; i < speakers.length(); i++)
			animation::start(speakers[i]);
		if (expression.is_valid())
			animation::start(expression);
	}
	
	void stop_speakers()
	{
		for (uint i = 0; i < speakers.length(); i++)
			animation::stop(speakers[i]);
		if (expression.is_valid())
			animation::stop(expression);
	}
	
	
	string current_dialog_sound = "dialog_sound";
	bool randomized_dialog_sound = false;
	bool player_already_locked = false;
	bool skip = true;
	
	bool is_shown = true;
	bool is_session_open = false;
	
	entity box;
	entity main_text;
	
	entity expression;
	
	void position_text_entities()
	{
		set_position(box, pixel((get_display_size()*vec(0.5, 1))
			- (get_size(box)*vec(0.5, 1))
			- vec(0, 5))); // 5px margin from 
		if (expression.is_valid())
		{
			vec size = get_size(narrative::priv::expression);
			set_position(narrative::priv::main_text, get_position(box) + pixel(size.x, 10));
		}
		else
			set_position(main_text, get_position(box)
			+ pixel(10, 10)); // 10px margin
	}
	
	void create_narrative()
	{
		// Create box
		narrative::priv::box = add_entity("NarrativeBox", "NarrativeBox");
		entity box = narrative::priv::box;
		make_gui(box, 10);
		set_anchor(box, anchor::topleft);
		
		// Create text
		narrative::priv::main_text = _add_dialog_text();
		entity main_text = narrative::priv::main_text;
		make_gui(main_text, 11);
		_set_interval(main_text, 30);
		
		position_text_entities();
	}
	
	void play_sound_effect()
	{
		if (narrative::priv::randomized_dialog_sound)
			fx::sound(narrative::priv::current_dialog_sound, 100, random(80, 110)*0.01);
		else
			fx::sound(narrative::priv::current_dialog_sound);
	}
}
	
	/// \addtogroup Narrative
	/// \{
	
	void set_expression(const string&in pTexture, const string&in pAtlas)
	{
		clear_expression();
		narrative::priv::expression = add_entity(pTexture, pAtlas);
		set_anchor(narrative::priv::expression, anchor::topleft);
		set_position(narrative::priv::expression, get_position(box)
			+ pixel(3, 3));
		make_gui(narrative::priv::expression, 11);
		
		narrative::priv::position_text_entities();
	}
	
	void clear_expression()
	{
		if (narrative::priv::expression.is_valid())
		{
			remove_entity(narrative::priv::expression);
			narrative::priv::position_text_entities();
		}
	}
  
	/// Set the sound effect for reveal text.
	void set_dialog_sound(const string &in pName)
	{
		narrative::priv::current_dialog_sound = pName;
	}
	
	/// Add an entity whose animation will play when dialogue is appearing.
	void add_speaker(entity pEntity)
	{
		narrative::priv::speakers.insertLast(pEntity);
	}
	
	/// Remove all entities that are to "speak"
	void clear_speakers()
	{
		const uint size = narrative::priv::speakers.length();
		narrative::priv::speakers.removeRange(0, size);
	}
	
	/// Set a "single" entity whose animation will play when dialogue is appearing.
	/// All other speakers will be automatically cleared and replaced
	void set_speaker(entity pEntity)
	{
		clear_speakers();
		add_speaker(pEntity);
	}
	
	/// Make the narrative show/reappear.
	void show()
	{
		narrative::priv::player_already_locked = player::is_locked();
		player::lock(true);
		if (!narrative::priv::is_session_open)
		{
			narrative::priv::create_narrative();
			narrative::priv::is_session_open = true;
		}
		
		// Ensure visible
		set_visible(narrative::priv::box, true);
		set_visible(narrative::priv::main_text, true);
		narrative::priv::is_shown = true;
	}
	
	/// Hide the dialog box. The current session is not closed
	/// and all settings are kept.
	/// \see narrative::show
	void hide()
	{
		// Hide the stuff
		set_visible(narrative::priv::box, false);
		set_visible(narrative::priv::main_text, false);
		narrative::priv::is_shown = false;
	}
	
	/// End the dialog session.
	/// A dialog session consists of changes
	/// made to the narrative box and speakers added.
	void end(bool pUnlock_player = true)
	{
		// Reset everything
		clear_speakers();
		clear_expression();
		if (!narrative::priv::player_already_locked)
			player::lock(!pUnlock_player);
		narrative::priv::current_dialog_sound = "dialog_sound";
		narrative::priv::randomized_dialog_sound = false;
		narrative::priv::skip = true;
		narrative::priv::is_session_open = false;
		
		// Remove the entities
		remove_entity(narrative::priv::box);
		remove_entity(narrative::priv::main_text);
	}
	
	/// Get entity referencing the box of the narrative box.
	entity& get_box()
	{
		return narrative::priv::box;
	}
	
	/// Set the interval between each character
	void set_interval(float ms)
	{
		if (ms <= 0)
		{
			eprint("interval cannot be less than or equal to 0");
			return;
		}
		_set_interval(narrative::priv::main_text, ms);
	}
	
	/// Set interval between each character based on characters per second
	void set_speed(float pSpeed)
	{
		set_interval(1000.f/pSpeed);
	}
	
	void set_skip(bool pSkip)
	{
		narrative::priv::skip = pSkip;
	}
	
	/// \}
}

void _wait_dialog_reveal(bool pSkip = false)
{
	narrative::priv::start_speakers();
	do {
		yield();
		if (_has_displayed_new_character(narrative::priv::main_text))
			narrative::priv::play_sound_effect();
		
		if (is_triggered(control::activate) && narrative::priv::skip)
			_skip_reveal(narrative::priv::main_text);
	} while (_is_revealing(narrative::priv::main_text));
	narrative::priv::stop_speakers();
}

/// \addtogroup Narrative
/// \{

/// Wait for key before continuing.
void keywait(int pControl = control::activate)
{
	do { yield(); }
	while (!_is_triggered(pControl));
}

/// Open and reveal text without waiting for key to continue.
void fsay(const string&in msg)
{
	narrative::show();
	_reveal(narrative::priv::main_text, msg, false);
	_wait_dialog_reveal();
}

/// Open and reveal text and wait for key to continue.
void say(const string&in msg)
{
	fsay(msg);
	keywait();
}

/// Append text to the narrative without waiting for key.
/// The dialogue is required to be open for this to work properly.
void fappend(const string&in msg)
{
	_reveal(narrative::priv::main_text, msg, true);
	_wait_dialog_reveal();
}

/// Append text to the narrative and wait for key.
/// The dialogue is required to be open for this to work properly.
void append(const string&in msg)
{
	fappend(msg);
	keywait();
}

/// Append and newline of text to the narrative without waiting for key.
/// The dialogue is required to be open for this to work properly.
void fnewline(const string&in msg)
{
	fappend("\n" + msg);
}

/// Append and newline of text to the narrative and wait for key.
/// The dialogue is required to be open for this to work properly.
void newline(const string&in msg)
{
	append("\n" + msg);
}

/// Append and newline of text to the narrative without waiting for key.
/// The dialogue is required to be open for this to work properly.
/// Short-cut for fnewline.
/// \see nl
void fnl(const string&in msg)
{
	fnewline(msg);
}

/// Append and newline of text to the narrative and wait for key.
/// The dialogue is required to be open for this to work properly.
/// Short-cut for newline.
void nl(const string&in msg)
{
	newline(msg);
}

/// Wait for a specific amount of seconds.
void wait(float pSeconds)
{
	util::timer wait_timer;
	
	wait_timer.start(pSeconds);
	while (!wait_timer.is_reached() && yield());
}

/// Opens the selection menu and allows the user to choose between 2 options.
option select(const string&in pOption1, const string&in pOption2)
{
	option val = option::first;
	
	// Create text
	scoped_entity selection_text = add_text();
	make_gui(selection_text, 11);
	set_text(selection_text, "*" + pOption1 + "   " + pOption2);
	set_position(selection_text, get_position(narrative::priv::box)
		+ pixel(10, get_size(narrative::priv::box).y - 24));
	
	do {
		if (_is_triggered(control::select_previous)) // First option
		{
			val = option::first;
			set_text(selection_text, "*" + pOption1 + "   " + pOption2);
		}
		if (_is_triggered(control::select_next)) // Second option
		{
			val = option::second;
			set_text(selection_text, " " + pOption1 + "  *" + pOption2);
		}
	} while (yield() && !_is_triggered(control::activate));
	return val;
}

/// \}

