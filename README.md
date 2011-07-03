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

**0.1.0**

* **[Added]** Basic cheat functionality for strings and special keys
* **[Added]** Cheats can be toggled (on/off)
* **[Added]** Master Cheat support
* **[Added]** Cheats can be optionally persisted within local ShardObject

Usage
-----

The basic use case is to enter any string and then trigger a hidden functionality. 

	function setup():void
	{
		var cheatLib:CheatLib = new CheatLib(stage, "demo");

		cheatLib.createMasterCheat("master", true)
			.toggledSignal
			.add(handleCheatToggle);

		cheatLib.createCheat("bart")
			.toggledSignal
			.add(handleCheatToggle);

		cheatLib.createCheat("lisa")
			.toggledSignal
			.add(handleCheatToggle);
	}
	
	function handleCheatToggle(cheat:ICheat):void
	{
		trace("Cheat " + cheat.id + " " + cheat.activated);
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
	cheat3.toggledSignal.add(handleCheatToggle);

Roadmap
-------

- Display cheat success (optional)
- Allow central signal listener registration in CheatLib