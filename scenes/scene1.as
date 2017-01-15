#include "backend/battle_system.as"

[trigger x=6 y=0 w=1 h=1]
void text_battle_system()
{
	once_flag("asdfasdf");
	battle_system sattle_bystem;
	sattle_bystem.set_music("doodle76");
	sattle_bystem.set_enemy(guy_enemy());
	sattle_bystem.start();
	music::fade("doodle57", 3);
}

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
