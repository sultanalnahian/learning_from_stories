Use MAX_STATIC_DATA of 500000.
When play begins, seed the random-number generator with 1234.

assignment-like is a kind of thing.
bbq-like is a kind of thing.
container is a kind of thing.
home-like is a kind of thing.
door is a kind of thing.
guard-like is a kind of thing.
line-like is a kind of thing.
object-like is a kind of thing.
police-like is a kind of thing.
people-like is a kind of thing.
people1-like is a kind of thing.
robber-like is a kind of thing.
supporter is a kind of thing.
friend-like is a kind of thing.
oven-like is a kind of container.
apparatus-like is a kind of object-like.
food is a kind of object-like.
key is a kind of object-like.
stove-like is a kind of supporter.
a thing can be drinkable. a thing is usually not drinkable. a thing can be cookable. a thing is usually not cookable. a thing can be damaged. a thing is usually not damaged. a thing can be sharp. a thing is usually not sharp. a thing can be cuttable. a thing is usually not cuttable. a thing can be a source of heat. Type of cooking is a kind of value. The type of cooking are raw, grilled, roasted and fried. a thing can be needs cooking. Type of cutting is a kind of value. The type of cutting are uncut, sliced, diced and chopped.
assignment-like can be finished. assignment-like can be studied. assignment-like are usually not studied. assignment-like is fixed in place.
bbq-like is a source of heat. bbq-like are fixed in place.
containers are openable, lockable and fixed in place. containers are usually closed.
home-like can be cleaned. home-like can be sorted. home-like is fixed in place.
door is openable and lockable.
guard-like can be killed. guard-like is usually not killed. guard-like can be broken. guard-like is usually not broken. guard-like can be stolen. guard-like is usually not stolen. guard-like is fixed in place.
line-like can be checked. line-like is usually not checked. line-like can be joined. line-like is usually not joined. line-like is fixed in place.
object-like is portable.
police-like can be called or not_called. police-like are usually not_called. police-like is fixed in place.
people-like can be asked. people-like can be snatched. people-like is fixed in place.
people1-like is fixed in place.
robber-like can be open or closed. robber-like are usually open. robber-like can be allowed. robber-like can be called or not_called. robber-like is fixed in place.
supporters are fixed in place.
friend-like is fixed in place.
oven-like is a source of heat.
apparatus-like is portable. apparatus-like can be equiped or not_equiped.
food is usually edible. food is cookable. food has a type of cooking. food has a type of cutting. food can be cooked. food can be burned. food can be consumed. food is usually not consumed. food is usually cuttable.
stove-like is a source of heat.
A room has a text called internal name.


Understand the command "wear" as something new. 
Understand "wear the [something]" as _wearing. 
_wearing is an action applying to a thing. 

Carry out _wearing the apparatus-like (called apx): 
	Now the apx is equiped.
After _wearing: 
	say "You have buckled your game gears";

Understand the command "get" as something new. 
Understand "get rid of the [something]" as _gettingrid. 
_gettingrid is an action applying to a thing. 

Carry out _gettingrid the apparatus-like (called apx): 
	Now the apx is not_equiped.


Understand the command "copy" as something new. 
Understand "copy the [something] from your friend" as _copying. 
_copying is an action applying to a thing. 

Carry out _copying: 
	if a assignment-like (called asn) is not finished: 
		Say "You copied assignment from your friend.";
		Now the asn is finished; 

Understand the command "study" as something new. 
Understand "go to the library to study" as going to the library to study. 
going to the library to study is an action applying to nothing. 

Carry out going to the library to study:
	if a assignment-like (called asn) is not studied: 
		Say "You are now in the library.";
		Now the asn is studied; 

Understand the command "homework" as something new. 
Understand "complete the [something] by your own" as _completing. 
_completing is an action applying to a thing. 

Carry out _completing the assignment-like(called asn): 
	Say "Good job! you have completed your assignment";
	Now the asn is finished;



Understand the command "sort" as something new. 
  Understand "place your clothes in the dresser" as _sorting. 
  _sorting is an action applying to nothing. 

  Carry out _sorting:
  	if a home-like (called cle) is not sorted: 
  		Say "Good job! your room is partly cleaned";
  		Now the cle is sorted; 

  Understand the command "leave" as something new. 
  Understand "leave your room to clean up by your parents" as _leaving. 
  _leaving is an action applying to nothing. 

  Carry out _leaving:
  	if a home-like (called cle) is not cleaned: 
  		Say "you leave from the room";
  		Now the cle is cleaned; 

  Understand the command "keep" as something new. 
  Understand "sort scatter things in their places" as _keeping. 
  _keeping is an action applying to nothing. 

  Carry out _keeping:
  	if a home-like (called cle) is not cleaned: 
  		Say "Great! your room is clean now";
  		Now the cle is cleaned; 



After examining an open container which contains nothing:
	say "It's empty.".


Understand the command "request" as something new.
_requesting is an action applying to a thing. 


[Drinking liquid]
The block drinking rule is not listed in any rulebook.

After drinking:
	Now the noun is consumed;
	Continue the action.

Check an actor drinking (this is the can't drink unless drinkable rule):
	if the noun is not a thing or the noun is not drinkable:
		say "You cannot drink [the noun].";
		rule fails;
	if the noun is not carried by the player:
		say "You should take [the noun] first.";
		rule fails

Carry out an actor drinking (this is the drinking rule):
	remove the noun from play.

Report an actor drinking (this is the report drinking rule):
	if the actor is the player:
		say "You drink [the noun]. Not bad.";
	otherwise:
		say "[The person asked] just drunk [the noun].".

[Eating food]
After eating a food (called target):
	Now the target is consumed;
	Continue the action.

Check eating inedible food (called target):
	if target is needs cooking:
		say "You should cook [the target] first.";
		rule fails.

[Understanding things by their properties - http://inform7.com/learn/man/WI_17_15.html]
Understand the type of cutting property as describing food.
Understand the type of cooking property as describing food.

[Processing food]
Understand the commands  "slice", "prune" as something new.
The block cutting rule is not listed in any rulebook.
Dicing is an action applying to one carried thing.
Slicing is an action applying to one carried thing.
Chopping is an action applying to one carried thing.

Slicing something is a cutting activity.
Dicing something is a cutting activity.
Chopping something is a cutting activity.

Check an actor cutting (this is the generic cut is now allowed rule):
	say "You need to specify how you want to cut [the noun]. Either slice, dice, or chop it.";
	rule fails.

Before a cutting activity when the noun is not cuttable:
	say "Can only cut cuttable food.";
	rule fails.

Before a cutting activity when the noun is cuttable and the noun is not uncut:
	say "[The noun] has already been [type of cutting of the noun].";
	rule fails.

Before a cutting activity when the list of sharp things carried by the player is empty:
	say "Cutting something requires something sharp like a knife.";
	rule fails.

Before printing the name of a food (called the food item) which is not uncut while looking, examining, listing contents or taking inventory:
	say "[type of cutting of food item] ".


[Slicing food]
Carry out slicing a carried food (called the food item):
	Now the food item is sliced;
	Let sharp object be the entry 1 in the list of sharp things carried by the player;
	say "You slice the [food item] using the [sharp object].".

Understand "slice [something]" as slicing.

[Dicing food]
Carry out dicing a carried food (called the food item):
	Now the food item is diced;
	Let sharp object be the entry 1 in the list of sharp things carried by the player;
	say "You dice the [food item] using the [sharp object].";

Understand "dice [something]" as dicing.

[Chopping food]
Carry out chopping a carried food (called the food item):
	Now the food item is chopped;
	Let sharp object be the entry 1 in the list of sharp things carried by the player;
	say "You chop the [food item] using the [sharp object].";

Understand the command "chop" as something new. [Remove its association with slicing]
Understand "chop [something]" as chopping.

[Cooking food]
Cooking is an action applying to one thing.

Before cooking when the noun is not cookable:
	say "Can only cook cookable food.";
	rule fails.

Check cooking something not cookable (this is the cook only cookable things rule):
	say "[The noun] is not cookable." instead.

Check cooking something cookable when the list of touchable source of heat things is empty (this is the cooking requires a source of heat rule):
	say "Cooking requires a source of heat." instead.

Check cooking something cookable not carried by the player (this is the cookable thing location rule):
	if the noun is not carried by the player and the noun is not on a source of heat thing and the noun is not in a source of heat thing:
		say "[The noun] has to be in your inventory or placed on/in a source of heat." instead.

A rule for reaching inside a source of heat while cooking:
	allow access.

After deciding the scope of the player:
	repeat with source of heat running through the list of source of heat containers:
		place the contents of the source of heat in scope.

Carry out cooking a food (called the food item):
	Let source of heat be the entry 1 in the list of touchable source of heat things;
	if the food item is on a source of heat thing (called clocation):
		Now the source of heat is the clocation;
	if the food item is in a source of heat thing (called clocation):
		Now the source of heat is the clocation;
	if the food item is cooked:
		Now the food item is burned;
		Now the food item is not edible;
		Now the food item is not cookable;
		say "You cook the already [type of cooking of food item] [food item] using [the source of heat]. It is burned now!";
		stop;
	otherwise:
		Now the food item is cooked;
	if the food item is needs cooking:
		Now the food item is edible;
		Now the food item is not needs cooking;
	if the source of heat is a stove-like:
		Now the food item is fried;
		say "You fry the [food item] using [the source of heat].";
	else if the source of heat is a oven-like:
		Now the food item is roasted;
		Now the food item is edible;
		say "You roast the [food item] using [the source of heat].";
	else if the source of heat is a bbq-like:
		Now the food item is grilled;
		say "You grill the [food item] using [the source of heat].";

Understand "cook [something]" as cooking.

Before printing the name of a food (called the food item) while looking, examining, listing contents or taking inventory:
	if the food item is needs cooking:
		say "raw ";
	else if the food item is burned:
		say "burned ";
	else if the food item is not raw:
		say "[type of cooking of food item] ".




Understand the command "kill" as something new. 
  Understand "kill the guard" as _killing. 
  _killing is an action applying to nothing. 

  Carry out _killing:
  	if a guard-like (called grd) is not killed: 
  		Say "the guard has been killed";
  		Now the grd is killed; 

  Understand the command "attack" as something new. 
  Understand "attack the guard and make him unconscious" as _attacking. 
  _attacking is an action applying to nothing. 

  Carry out _attacking:
  	if a guard-like (called grd) is not killed: 
  		Say "the guard has became unconscious";
  		Now the grd is killed; 

  Understand the command "break" as something new. 
  Understand "break the store" as _breaking. 
  _breaking is an action applying to nothing. 

  Carry out _breaking:
  	if a guard-like (called grd) is not broken: 
  		Say "the store has been broken";
  		Now the grd is broken;

  Understand the command "steal" as something new. 
  Understand "steal food from the store" as _stealing. 
  _stealing is an action applying to nothing. 

  Carry out _stealing:
  	if a guard-like (called grd) is not stolen: 
  		Say "the man stole food from the store";
  		Now the grd is stolen; 


Understand the command "put" as something new.
Understand "put [other things] on/onto [something]" as putting it on.

Does the player mean putting something on something (called destination):
	Let L be the list of touchable supporters;
	if L is not empty and destination is entry 1 of L:
		it is very likely;
	otherwise:
		it is very unlikely;

Does the player mean inserting something into something (called destination):
	Let L be the list of touchable containers;
	if L is not empty and destination is entry 1 of L:
		it is very likely;
	otherwise:
		it is very unlikely;



Understand the command "cut" as something new. 
  Understand "cut in the line" as _cutting. 
  _cutting is an action applying to nothing. 

  Carry out _cutting:
  	if a line-like (called lne) is not joined: 
  		Say "Cut in line is not good behavior";
  		Now the lne is joined; 

  Understand the command "stand" as something new. 
  Understand "go to the end of the line" as _standing. 
  _standing is an action applying to nothing. 

  Carry out _standing:
  	if a line-like (called lne) is not checked: 
  		Say "You are in the end of the line";
  		Now the lne is checked; 

  Understand the command "stay" as something new. 
  Understand "Wait patiently in the line to enter the carnival" as _waiting. 
  _waiting is an action applying to nothing. 

  Carry out _waiting:
  	if a line-like (called lne) is not joined: 
  		Say "You are about to enter the carnival";
  		Now the lne is joined; 



Before printing the name of a thing (called the target) while looking, examining or listing contents:
	say "[bold type][italic type]";

After printing the name of a thing (called the target) while looking, examining or listing contents:
	say "[roman type]";


Understand the command "ask" as something new. 
Understand "ask money from [something]" as _asking. 
_asking is an action applying to a thing. 

Understand the command "snatch" as something new. 
Understand "snatch money from [something]" as _snatching. 
_snatching is an action applying to a thing. 


Understand the command "seek" as something new. 
Understand "seek job from [something] to earn money" as _seeking. 
_seeking is an action applying to a thing. 



Understand the command "call" as something new. 
Understand "call [something]" as calling. 
calling is an action applying to a thing. 

Carry out calling the police-like (called rx): 
	Say "The [the noun] is being called.";
	Now the rx is called.



Understand the command "shoot" as something new. 
Understand "shoot [something]" as _shooting. 
_shooting is an action applying to a thing. 

Carry out _shooting the robber-like (called rx): 
	Say "The [noun] is being shot. You are successful to stop the robbery.";
	Now the rx is closed.
After _shooting: 
	say "You killed [the noun]";

Understand the command "capture" as something new. 
Understand "capture [something]" as _capturing. 
_capturing is an action applying to a thing. 

Carry out _capturing the robber-like (called rx): 
	Say "The [noun] is being captured. You are successful to stop the robbery.";
	Now the rx is closed.

Understand the command "convince" as something new. 
Understand "convince [something]" as _convincing. 
_convincing is an action applying to a thing. 

Carry out _convincing the robber-like (called rx): 
	Say "The [noun] is ready to surrender. You are successful to stop the robbery.";
	Now the rx is closed.

Understand the command "allow" as something new. 
Understand "allow [something] to escape" as _allowing. 
_allowing is an action applying to a thing. 

Carry out _allowing the robber-like (called rx): 
	Say "The [noun] has escaped. You are failed to stop the robbery.";
	Now the rx is allowed. 

Understand the command "call" as something new. 
Understand "call the police" as calling the police. 
calling the police is an action applying to nothing. 

Carry out calling the police: 
	if a robber-like (called rx) is not_called: 
		Say "Police is being called.";
		Now the rx is called.



After examining a supporter which contains nothing:
	say "The [noun] has nothing on it.".


The r_1 and the r_0 and the r_3 and the r_2 are rooms.

The internal name of r_1 is "Alley".
The printed name of r_1 is "-= Alley =-".
The Alley part 0 is some text that varies. The Alley part 0 is "You've entered a Alley.



You need an exit without a door? You should try going east. You need an exit without a door? You should try going north. There is an exit to the west. Don't worry, there is no door.".
The description of r_1 is "[Alley part 0]".

The r_0 is mapped west of r_1.
The r_2 is mapped north of r_1.
The r_3 is mapped east of r_1.
The internal name of r_0 is "Home".
The printed name of r_0 is "-= Home =-".
The Home part 0 is some text that varies. The Home part 0 is "Of every Home you could have shown up in, you had to come round an usual one.



There is an exit to the east.".
The description of r_0 is "[Home part 0]".

The r_1 is mapped east of r_0.
The internal name of r_3 is "Store".
The printed name of r_3 is "-= Store =-".
The Store part 0 is some text that varies. The Store part 0 is "You have moved into the most standard of all possible Stores.



There is an exit to the west.".
The description of r_3 is "[Store part 0]".

The r_1 is mapped west of r_3.
The internal name of r_2 is "Downtown".
The printed name of r_2 is "-= Downtown =-".
The Downtown part 0 is some text that varies. The Downtown part 0 is "Ah, the Downtown. This is some kind of Downtown, really great ordinary vibes in this place, a wonderful ordinary atmosphere.



There is an exit to the south. Don't worry, there is no door.".
The description of r_2 is "[Downtown part 0]".

The r_1 is mapped south of r_2.

The gr_0 are guard-likes.
The gr_0 are privately-named.
The pp_0 are people-likes.
The pp_0 are privately-named.
The ppl_0 are people1-likes.
The ppl_0 are privately-named.
The r_1 and the r_0 and the r_3 and the r_2 are rooms.
The r_1 and the r_0 and the r_3 and the r_2 are privately-named.

The description of gr_0 is "".
The printed name of gr_0 is "guard".
Understand "guard" as gr_0.
The gr_0 is in r_3.
The gr_0 is not broken.
The gr_0 is not killed.
The gr_0 is not stolen.
The description of pp_0 is "".
The printed name of pp_0 is "passerby".
Understand "passerby" as pp_0.
The pp_0 is in r_1.
The description of ppl_0 is "".
The printed name of ppl_0 is "people".
Understand "people" as ppl_0.
The ppl_0 is in r_2.


The player is in r_0.

The quest0 completed is a truth state that varies.
The quest0 completed is usually false.

Test quest0_0 with ""

Every turn:
	if quest0 completed is true:
		do nothing;
	else if The player is in r_3 and The gr_0 is stolen and The gr_0 is broken and The gr_0 is killed:
		increase the score by 5; [Quest completed]
		Now the quest0 completed is true;

Use scoring. The maximum score is 5.
This is the simpler notify score changes rule:
	If the score is not the last notified score:
		let V be the score - the last notified score;
		say "Your score has just gone up by [V in words] ";
		if V > 1:
			say "points.";
		else:
			say "point.";
		Now the last notified score is the score;
	if score is maximum score:
		end the story finally; [Win]

The simpler notify score changes rule substitutes for the notify score changes rule.

Rule for listing nondescript items:
	stop.

Rule for printing the banner text:
	say "[fixed letter spacing]";
	say "                    ________  ________  __    __  ________        [line break]";
	say "                   |        \|        \|  \  |  \|        \       [line break]";
	say "                    \$$$$$$$$| $$$$$$$$| $$  | $$ \$$$$$$$$       [line break]";
	say "                      | $$   | $$__     \$$\/  $$   | $$          [line break]";
	say "                      | $$   | $$  \     >$$  $$    | $$          [line break]";
	say "                      | $$   | $$$$$    /  $$$$\    | $$          [line break]";
	say "                      | $$   | $$_____ |  $$ \$$\   | $$          [line break]";
	say "                      | $$   | $$     \| $$  | $$   | $$          [line break]";
	say "                       \$$    \$$$$$$$$ \$$   \$$    \$$          [line break]";
	say "              __       __   ______   _______   __        _______  [line break]";
	say "             |  \  _  |  \ /      \ |       \ |  \      |       \ [line break]";
	say "             | $$ / \ | $$|  $$$$$$\| $$$$$$$\| $$      | $$$$$$$\[line break]";
	say "             | $$/  $\| $$| $$  | $$| $$__| $$| $$      | $$  | $$[line break]";
	say "             | $$  $$$\ $$| $$  | $$| $$    $$| $$      | $$  | $$[line break]";
	say "             | $$ $$\$$\$$| $$  | $$| $$$$$$$\| $$      | $$  | $$[line break]";
	say "             | $$$$  \$$$$| $$__/ $$| $$  | $$| $$_____ | $$__/ $$[line break]";
	say "             | $$$    \$$$ \$$    $$| $$  | $$| $$     \| $$    $$[line break]";
	say "              \$$      \$$  \$$$$$$  \$$   \$$ \$$$$$$$$ \$$$$$$$ [line break]";
	say "[variable letter spacing][line break]";
	say "[objective][line break]".

Include Basic Screen Effects by Emily Short.

Rule for printing the player's obituary:
	if story has ended finally:
		center "*** The End ***";
	else:
		center "*** You lost! ***";
	say paragraph break;
	say "You scored [score] out of a possible [maximum score], in [turn count] turn(s).";
	[wait for any key;
	stop game abruptly;]
	rule succeeds.

Rule for implicitly taking something (called target):
	if target is fixed in place:
		say "The [target] is fixed in place.";
	otherwise:
		say "You need to take the [target] first.";
		set pronouns from target;
	stop.

Does the player mean doing something:
	if the noun is not nothing and the second noun is nothing and the player's command matches the text printed name of the noun:
		it is likely;
	if the noun is nothing and the second noun is not nothing and the player's command matches the text printed name of the second noun:
		it is likely;
	if the noun is not nothing and the second noun is not nothing and the player's command matches the text printed name of the noun and the player's command matches the text printed name of the second noun:
		it is very likely.  [Handle action with two arguments.]

Printing the content of the room is an activity.
Rule for printing the content of the room:
	let R be the location of the player;
	say "Room contents:[line break]";
	list the contents of R, with newlines, indented, including all contents, with extra indentation.

Printing the content of the world is an activity.
Rule for printing the content of the world:
	let L be the list of the rooms;
	say "World: [line break]";
	repeat with R running through L:
		say "  [the internal name of R][line break]";
	repeat with R running through L:
		say "[the internal name of R]:[line break]";
		if the list of things in R is empty:
			say "  nothing[line break]";
		otherwise:
			list the contents of R, with newlines, indented, including all contents, with extra indentation.

Printing the content of the inventory is an activity.
Rule for printing the content of the inventory:
	say "Inventory:[line break]";
	list the contents of the player, with newlines, indented, giving inventory information, including all contents, with extra indentation.

Printing the content of nowhere is an activity.
Rule for printing the content of nowhere:
	say "Nowhere:[line break]";
	let L be the list of the off-stage things;
	repeat with thing running through L:
		say "  [thing][line break]";

Printing the things on the floor is an activity.
Rule for printing the things on the floor:
	let R be the location of the player;
	let L be the list of things in R;
	remove yourself from L;
	remove the list of containers from L;
	remove the list of supporters from L;
	remove the list of doors from L;
	if the number of entries in L is greater than 0:
		say "There is [L with indefinite articles] on the floor.";

After printing the name of something (called target) while
printing the content of the room
or printing the content of the world
or printing the content of the inventory
or printing the content of nowhere:
	follow the property-aggregation rules for the target.

The property-aggregation rules are an object-based rulebook.
The property-aggregation rulebook has a list of text called the tagline.

[At the moment, we only support "open/unlocked", "closed/unlocked" and "closed/locked" for doors and containers.]
[A first property-aggregation rule for an openable open thing (this is the mention open openables rule):
	add "open" to the tagline.

A property-aggregation rule for an openable closed thing (this is the mention closed openables rule):
	add "closed" to the tagline.

A property-aggregation rule for an lockable unlocked thing (this is the mention unlocked lockable rule):
	add "unlocked" to the tagline.

A property-aggregation rule for an lockable locked thing (this is the mention locked lockable rule):
	add "locked" to the tagline.]

A first property-aggregation rule for an openable lockable open unlocked thing (this is the mention open openables rule):
	add "open" to the tagline.

A property-aggregation rule for an openable lockable closed unlocked thing (this is the mention closed openables rule):
	add "closed" to the tagline.

A property-aggregation rule for an openable lockable closed locked thing (this is the mention locked openables rule):
	add "locked" to the tagline.

A property-aggregation rule for a lockable thing (called the lockable thing) (this is the mention matching key of lockable rule):
	let X be the matching key of the lockable thing;
	if X is not nothing:
		add "match [X]" to the tagline.

A property-aggregation rule for an edible off-stage thing (this is the mention eaten edible rule):
	add "eaten" to the tagline.

The last property-aggregation rule (this is the print aggregated properties rule):
	if the number of entries in the tagline is greater than 0:
		say " ([tagline])";
		rule succeeds;
	rule fails;


An objective is some text that varies. The objective is "".
Printing the objective is an action applying to nothing.
Carry out printing the objective:
	say "[objective]".

Understand "goal" as printing the objective.

The taking action has an object called previous locale (matched as "from").

Setting action variables for taking:
	now previous locale is the holder of the noun.

Report taking something from the location:
	say "You pick up [the noun] from the ground." instead.

Report taking something:
	say "You take [the noun] from [the previous locale]." instead.

Report dropping something:
	say "You drop [the noun] on the ground." instead.

The print state option is a truth state that varies.
The print state option is usually false.

Turning on the print state option is an action applying to nothing.
Carry out turning on the print state option:
	Now the print state option is true.

Turning off the print state option is an action applying to nothing.
Carry out turning off the print state option:
	Now the print state option is false.

Printing the state is an activity.
Rule for printing the state:
	let R be the location of the player;
	say "Room: [line break] [the internal name of R][line break]";
	[say "[line break]";
	carry out the printing the content of the room activity;]
	say "[line break]";
	carry out the printing the content of the world activity;
	say "[line break]";
	carry out the printing the content of the inventory activity;
	say "[line break]";
	carry out the printing the content of nowhere activity;
	say "[line break]".

Printing the entire state is an action applying to nothing.
Carry out printing the entire state:
	say "-=STATE START=-[line break]";
	carry out the printing the state activity;
	say "[line break]Score:[line break] [score]/[maximum score][line break]";
	say "[line break]Objective:[line break] [objective][line break]";
	say "[line break]Inventory description:[line break]";
	say "  You are carrying: [a list of things carried by the player].[line break]";
	say "[line break]Room description:[line break]";
	try looking;
	say "[line break]-=STATE STOP=-";

Every turn:
	if extra description command option is true:
		say "<description>";
		try looking;
		say "</description>";
	if extra inventory command option is true:
		say "<inventory>";
		try taking inventory;
		say "</inventory>";
	if extra score command option is true:
		say "<score>[line break][score][line break]</score>";
	if extra score command option is true:
		say "<moves>[line break][turn count][line break]</moves>";
	if print state option is true:
		try printing the entire state;

When play ends:
	if print state option is true:
		try printing the entire state;

After looking:
	carry out the printing the things on the floor activity.

Understand "print_state" as printing the entire state.
Understand "enable print state option" as turning on the print state option.
Understand "disable print state option" as turning off the print state option.

Before going through a closed door (called the blocking door):
	say "You have to open the [blocking door] first.";
	stop.

Before opening a locked door (called the locked door):
	let X be the matching key of the locked door;
	if X is nothing:
		say "The [locked door] is welded shut.";
	otherwise:
		say "You have to unlock the [locked door] with the [X] first.";
	stop.

Before opening a locked container (called the locked container):
	let X be the matching key of the locked container;
	if X is nothing:
		say "The [locked container] is welded shut.";
	otherwise:
		say "You have to unlock the [locked container] with the [X] first.";
	stop.

Displaying help message is an action applying to nothing.
Carry out displaying help message:
	say "[fixed letter spacing]Available commands:[line break]";
	say "  look:                describe the current room[line break]";
	say "  goal:                print the goal of this game[line break]";
	say "  inventory:           print player's inventory[line break]";
	say "  go <dir>:            move the player north, east, south or west[line break]";
	say "  examine ...:         examine something more closely[line break]";
	say "  eat ...:             eat edible food[line break]";
	say "  open ...:            open a door or a container[line break]";
	say "  close ...:           close a door or a container[line break]";
	say "  drop ...:            drop an object on the floor[line break]";
	say "  take ...:            take an object that is on the floor[line break]";
	say "  put ... on ...:      place an object on a supporter[line break]";
	say "  take ... from ...:   take an object from a container or a supporter[line break]";
	say "  insert ... into ...: place an object into a container[line break]";
	say "  lock ... with ...:   lock a door or a container with a key[line break]";
	say "  unlock ... with ...: unlock a door or a container with a key[line break]";

Understand "help" as displaying help message.

Taking all is an action applying to nothing.
Check taking all:
	say "You have to be more specific!";
	rule fails.

Understand "take all" as taking all.
Understand "get all" as taking all.
Understand "pick up all" as taking all.

Understand "take each" as taking all.
Understand "get each" as taking all.
Understand "pick up each" as taking all.

Understand "take everything" as taking all.
Understand "get everything" as taking all.
Understand "pick up everything" as taking all.

The extra description command option is a truth state that varies.
The extra description command option is usually false.

Turning on the extra description command option is an action applying to nothing.
Carry out turning on the extra description command option:
	Decrease turn count by 1;  [Internal framework commands shouldn't count as a turn.]
	Now the extra description command option is true.

Understand "tw-extra-infos description" as turning on the extra description command option.

The extra inventory command option is a truth state that varies.
The extra inventory command option is usually false.

Turning on the extra inventory command option is an action applying to nothing.
Carry out turning on the extra inventory command option:
	Decrease turn count by 1;  [Internal framework commands shouldn't count as a turn.]
	Now the extra inventory command option is true.

Understand "tw-extra-infos inventory" as turning on the extra inventory command option.

The extra score command option is a truth state that varies.
The extra score command option is usually false.

Turning on the extra score command option is an action applying to nothing.
Carry out turning on the extra score command option:
	Decrease turn count by 1;  [Internal framework commands shouldn't count as a turn.]
	Now the extra score command option is true.

Understand "tw-extra-infos score" as turning on the extra score command option.

The extra moves command option is a truth state that varies.
The extra moves command option is usually false.

Turning on the extra moves command option is an action applying to nothing.
Carry out turning on the extra moves command option:
	Decrease turn count by 1;  [Internal framework commands shouldn't count as a turn.]
	Now the extra moves command option is true.

Understand "tw-extra-infos moves" as turning on the extra moves command option.

To trace the actions:
	(- trace_actions = 1; -).

Tracing the actions is an action applying to nothing.
Carry out tracing the actions:
	Decrease turn count by 1;  [Internal framework commands shouldn't count as a turn.]
	trace the actions;

Understand "tw-trace-actions" as tracing the actions.

The restrict commands option is a truth state that varies.
The restrict commands option is usually false.

Turning on the restrict commands option is an action applying to nothing.
Carry out turning on the restrict commands option:
	Decrease turn count by 1;  [Internal framework commands shouldn't count as a turn.]
	Now the restrict commands option is true.

Understand "restrict commands" as turning on the restrict commands option.

The taking allowed flag is a truth state that varies.
The taking allowed flag is usually false.

Before removing something from something:
	now the taking allowed flag is true.

After removing something from something:
	now the taking allowed flag is false.

Before taking a thing (called the object) when the object is on a supporter (called the supporter):
	if the restrict commands option is true and taking allowed flag is false:
		say "Can't see any [object] on the floor! Try taking the [object] from the [supporter] instead.";
		rule fails.

Before of taking a thing (called the object) when the object is in a container (called the container):
	if the restrict commands option is true and taking allowed flag is false:
		say "Can't see any [object] on the floor! Try taking the [object] from the [container] instead.";
		rule fails.

Understand "take [something]" as removing it from.

Rule for supplying a missing second noun while removing:
	if restrict commands option is false and noun is on a supporter (called the supporter):
		now the second noun is the supporter;
	else if restrict commands option is false and noun is in a container (called the container):
		now the second noun is the container;
	else:
		try taking the noun;
		say ""; [Needed to avoid printing a default message.]

The version number is always 1.

Reporting the version number is an action applying to nothing.
Carry out reporting the version number:
	Decrease turn count by 1;  [Internal framework commands shouldn't count as a turn.]
	say "[version number]".

Understand "tw-print version" as reporting the version number.

Reporting max score is an action applying to nothing.
Carry out reporting max score:
	Decrease turn count by 1;  [Internal framework commands shouldn't count as a turn.]
	say "[maximum score]".

Understand "tw-print max_score" as reporting max score.

To print id of (something - thing):
	(- print {something}, "^"; -).

Printing the id of player is an action applying to nothing.
Carry out printing the id of player:
	Decrease turn count by 1;  [Internal framework commands shouldn't count as a turn.]
	print id of player.

Printing the id of EndOfObject is an action applying to nothing.
Carry out printing the id of EndOfObject:
	Decrease turn count by 1;  [Internal framework commands shouldn't count as a turn.]
	print id of EndOfObject.

Understand "tw-print player id" as printing the id of player.
Understand "tw-print EndOfObject id" as printing the id of EndOfObject.

There is a EndOfObject.

