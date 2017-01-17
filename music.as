namespace music
{

	/// \weakgroup Music
	/// \{

	/// Set whether or not you want the
	/// music to loop.
	void loop(bool pLoop)
	{
		_music_set_loop(pLoop);
	}
	
	/// Stop the music.
	void stop()
	{
		_music_stop();
	}
	
	/// Pause the song
	void pause()
	{
		_music_pause();
	}
	
	/// Seamlessly swap out music files.
	/// This will maintain the current position
	/// of the music playing beforehand (Only if
	/// the new music is the same or longer in length).
	void swap(const string&in pName)
	{
		_music_swap(pName);
	}
	
	/// Smoothly fade to a new music
	void fade(const string&in pName, float pSeconds, float pVolume = 100)
	{
		if (pSeconds <= 0)
		{
			eprint("Please specify time that is greater than 0");
			return;
		}
		
		// Start second stream that will fade in
		_music_start_transition_play(pName);
		
		create_thread(
			function(pArgs)
			{
				const float pSeconds = float(pArgs["pSeconds"]);
				const float pVolume  =  float(pArgs["pVolume"]);
				
				const float first_speed  = _music_get_volume() / pSeconds;
				const float second_speed = pVolume / pSeconds;
				
				float timer = 0;
				
				float first_volume  = _music_get_volume();
				float second_volume = 0;
				
		        // Smoothly fade the main music out and fade the seconds one in
				while (timer < pSeconds)
				{
					yield();
					
					const float delta = get_delta();
					
					timer += delta;
					
					first_volume -= first_speed*delta;
					if (first_volume > 0)
						_music_set_volume(first_volume);
					
					second_volume += second_speed*delta;
					if (second_volume < 100)
						_music_set_second_volume(second_volume);
				}
				
				// Make the second music the main one
				_music_stop_transition_play();
				_music_set_volume(pVolume);
			},
			dictionary = {
			{"pSeconds", pSeconds},
			{"pVolume" , pVolume }});
	}
	
	/// Is the song playing?
	bool playing()
	{
		return _music_is_playing();
	}
	
	/// Play/resume music.
	void play()
	{
		if (!playing())
			_music_play();
	}
	
	/// Set volume of music.
	/// \param pVolume A value from 0-100.
	void volume(float pVolume)
	{
		_music_set_volume(pVolume);
	}
	
	/// Get duration of music in seconds.
	float duration()
	{
		return _music_get_duration();
	}
	
	/// Get current position of music in seconds
	float get_position()
	{
		return _music_get_position();
	}
	
	/// set the position of the music in seconds
	void set_position(float pSeconds)
	{
		_music_set_position(pSeconds);
	}
	
	/// Open sound file
	/// \param pQuick Automatically set to play and loop.
	void open(const string&in pPath, bool pQuick = true)
	{
		if (_music_open(pPath) != 0)
			dprint("Could not load music file '" + pPath + "'");
		
		if (pQuick)
		{
			loop(true);
			play();
		}
	}
	
	/// Wait until a specific time in the currently playing music
	void wait_until(float pSeconds)
	{
		if (!music::playing())
		{
			dprint("No music is playing to wait for...");
			return;
		}
		
		if (music::duration() < pSeconds)
		{
			dprint("The duration of the music is less then the time you requested to wait");
			return;
		}
		
		while (music::playing()
		&&     music::get_position() < pSeconds)
		{ yield(); }
	}
	
	/// \}
}