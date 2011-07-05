AS3 Cheats
==================

This library provides an easy way to handle cheats within flash. Register a key combination or phrase to a cheat and it gets then triggered by the library.

**Use cases for this library:**

- Enable certain functionalities in live environments which should be normally deactivated (e.g. logging)
- Use cheats within games or as easter egg triggers
- Persist cheats so you don't have to re-enter them again and again

**Dependencies**

This library is compiled against *as3-signals-v0.7*. You can download the latest version here:  [GitHub](https://github.com/robertpenner/as3-signals)

Change log
----------

**0.0.1**

* **[Added]** Cheat functionality for any combination of strings and special keys
* **[Added]** Cheats can be toggled (on/off)
* **[Added]** Per cheat and global toggled Signal
* **[Added]** Master Cheat support
* **[Added]** Cheats can be optionally persisted (Local Shared Object)
* **[Added]** Static access for easy access (`CheatLib.get(id)`)

Usage
-----

The basic use case is to enter any string and then trigger a hidden functionality. 

	function setup():void
	{
		var cheatLib:CheatLib = CheatLib.create(stage, "demo");

		// register central listener for all cheats
		cheatLib.toggledSignal.add(handleAllCheatsToggle);

		// persistent master cheat
		cheatLib.createMasterCheat("master", true);

		// not persistent cheat
		cheatLib.createCheat("bart");

		// persistent cheat with custom toggle listener
		cheatLib.createCheat("lisa", true)
			.toggledSignal
			.add(handleLisaCheatToggle);
	}
	
	function handleAllCheatsToggle(cheat:ICheat):void
	{
		trace("Cheat " + cheat.id + " " + cheat.activated);
	}

	function handleLisaCheatToggle(cheat:ICheat):void
	{
		trace("Cheat 'lisa' (custom listener) " + cheat.activated);
	}

For more advanced cheat codes you can use the following syntax:

	var cheat3:Cheat = CheatBuilder.create("fps", 
							CheatCodeBuilder.create()
								.appendKeyCode(Keyboard.ENTER)
								.appendString("fps")
								.appendKeyCode(Keyboard.ENTER)
								.build())
							.setLabel("FPS")
							.build();
	cheatLib.addCheat(cheat3);
	cheat3.toggledSignal.add(handleAllCheatsToggle);

Access your cheats anywhere by static access:

	trace("master cheat active: " + 
				CheatLib.get("demo")
					.getCheat("master")
					.activated);

Roadmap
-------

- Write documentation for `CheatLib` and `ICheat`
- Default debug output for cheat toggle