
[button x=7 y=2 w=1 h=1]
void sign()
{
	say("Hello World");
	narrative::end();
}

[start]
void start()
{
	music::open("doodle57");
	set_position(get_player(), vec(2, 3.5));
}
