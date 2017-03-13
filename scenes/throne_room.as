entity vanta;

[start]
void start()
{
	//temporary
	//set_position(get_player(), vec(4.5, 10));
	set_direction(get_player(), direction::up);
	set_position(get_player(), vec(4.5, 19));
}

[start]
void create_vanta()
{
	//gonna change the sprite later; spoopy is temporary
	vanta = add_entity("spoopyer", "default:down");
	set_position(vanta, vec(4.5, 3.5));
}

void create_column(vec pPosition)
{
	entity column1 = add_entity("dungeon","pillar");
	set_position(column1, pPosition);
}

[start]
void create_columns()
{
	create_column(vec(2.5, 5.75));
    create_column(vec(6.5, 5.75));
	create_column(vec(2.5, 7.75));
	create_column(vec(6.5, 7.75));

}

entity create_torch(vec pPosition)
{
	entity torch = add_entity("torch", "torch");
	set_position(torch, pPosition);
	set_depth(torch, fixed_depth::below);
	return torch;
}

class torch_pair
{
	entity left;
	entity right;
};

array<torch_pair> torches(3);

[start]
void create_torches()
{
	for(uint k = 0; k < 3; k++)
	{
		torches[k].left = create_torch(vec(3.5, (k*2) + 11));
		torches[k].right = create_torch(vec(5.5, (k*2) + 11));
	}
	
	entity left_torch   = create_torch(vec(3.5, 3.5));
	entity right_torch = create_torch(vec(5.5, 3.5));
	
	set_atlas(left_torch, "light");
	set_atlas(right_torch, "light");
	
	start_animation(left_torch);
	start_animation(right_torch);
}

void light_torch(int k)
{
	player::lock(true);
	set_atlas(torches[k].left, "ignite");
	set_atlas(torches[k].right, "ignite");
	
	
	start_animation(torches[k].left);
	start_animation(torches[k].right);
	
	wait(0.80);
	
	player::lock(false);
}

void animate_torch(int k)
{
	set_atlas(torches[k].left, "light");
	set_atlas(torches[k].right, "light");
				
	start_animation(torches[k].left);
	start_animation(torches[k].right);
}

[group step2]
void light_torch2()
{
	light_torch(2);
	animate_torch(2);
	
	once_flag("torch2");
	
}

[group step1]
void light_torch1()
{
	light_torch(1);
	animate_torch(1);
	
	once_flag("torch1");
}

[group step0]
void light_torch0()
{
	light_torch(0);
	animate_torch(0);
	
	once_flag("torch0");
}

[group vanta]
void vanta_black()
{
	player::lock(true);
	
	wait(1);
	start_animation(get_player());
	pathfind_move(get_player(), vec(4.5, 5), 1.5, 0);
	stop_animation(get_player());
	set_direction(get_player(), direction::up);
	
	wait(1);
	
	//initial sprite of vanta is of them sitting on the throne
	focus::move(get_position(vanta), 2);
	
	narrative::set_speaker(vanta);
	set_atlas(vanta, "talk");
	say("Hello.");
	say("I've waited very long for \nyou to arrive.");
	
	narrative::clear_speakers();
	narrative::set_speed(1);
	fsay("\n...");
	
	wait(1);
	
	narrative::set_interval(30);
	narrative::set_speaker(vanta);
	set_atlas(vanta, "talk_squint");
	fsay("Why the incredulous look, \nchild?");
	
	wait(2);
	
	say("Do you not remember me?");
	int opt = select("I remember you!", "Who are you?");
	if(opt == 0)
	{
		set_flag("remembered"); 
		//set expression to calm 
		set_atlas(vanta, "talk_happy");
		fsay("Yes, yes. Of course you do.");
		wait(0.5);
	}
	else if(opt == 1)
	{
		set_flag("forgotten");
		//set expression to annoyed
		set_atlas(vanta, "talk_sinister");
		fsay("Don't play the fool, \nignorant child!");
		wait(0.25);
	}
	set_atlas(vanta, "talk_squint");
	say("Everyone in the Void knows \nof me.");
	say("For it is I...");
	//Vanta approaches player, change sprite animation
	move(vanta, vec(4.5, 3.75), 1);
	set_atlas(vanta, "talk_sinister");
	fsay("THE GREAT");
	wait(1);
	move(vanta, vec(4.5, 4), 0.75);
	//thunder and lightning; make sure to show lightning first then thunder
	fsay("VANTA");
	wait(0.5);
	move(vanta, vec(4.5, 4.5), 0.50);
	wait(0.5);
	say("BLACK!");
	//more thunder+lightning and battle commence
	wait(2);
	say("By the way, I'm cosplaying \nas Spoopy-senpai");
	
	narrative::hide();
	
	player::lock(false);
	/*
	also add expressions in narrative box
	
	*/
	
}