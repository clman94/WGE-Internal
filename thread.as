/// \weakgroup Thread
/// \{

class thread
{
	thread()
	{
		mThread_count = 0;
	}
	
	~thread()
	{
		if (mThread_count > 0)
			eprint("Threads not completed");
	}
	
	void wait()
	{
		while (mThread_count > 0 && yield());
	}
	
	void thread_start()
	{
		++mThread_count;
	}
	
	void thread_end()
	{
		if (mThread_count == 0)
		{
			eprint("mThread_count == 0");
			return;
		}
		--mThread_count;
	}
	
	private uint mThread_count;
};

/// \}