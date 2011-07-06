AS3 Cheats
==================

This library provides an easy way to handle cheats within flash. Register a key combination or phrase to a cheat and it gets then triggered by the library.

**Use cases for this library:**

- Enable functionalities in live environments which should be normally deactivated (e.g. logging)
- Use cheats within games
- Trigger easter eggs

**Dependencies**

This library is compiled against *as3-signals-v0.7*. The swc is included in the download file.
More information regarding as3-signals can be [found here](https://github.com/robertpenner/as3-signals).

Usage
-----

**Creation**

First of all you have to initialize the CheatLib with the stage and a custom identifier:

	var lib:ICheatLib = CheatLib.create(stage, "demo");

You can then either use the returned instance or always retrieve it via the `CheatLib.get(id)`. 

**Basic usage**

The basic use-case is to enter a string and then trigger a functionality. 

	CheatLib.get("demo")
		.createCheat("test")
			.toggledSignal
			.add(handleTestCheatToggle);

	function handleTestCheatToggle(cheat:ICheat):void
	{
		trace("Test cheat toggled, now " + cheat.activated);
	}

You can always get the created cheat again via the `getCheat()` method:

	CheatLib.get("demo")
		.getCheat("test");

**Master cheats**

With master cheats you block certain cheats until the master is activated. This would be the easiest way to just use one master cheat:

	CheatLib.get("demo")
		.createMasterCheat("master");
	
A more complex example, on how to use multiple master cheats will follow later.

**Persistency**

If you don't want to re-enter you cheats after each restart you can use the optional `persistent` flag. It stores the cheat state in the LocalSharedObject and re-initializes it on the next start. This flag needs to be set for each cheat individually.

	CheatLib.get("demo")
		.createMasterCheat("master", true);

**Complex cheat codes**

For more advanced cheat codes – including special keys – you can use the following syntax:

	CheatLib.get("demo")
		.addCheat(CheatBuilder.create("fps", 
					CheatCodeBuilder.create()
						.appendKeyCode(Keyboard.ENTER)
						.appendString("fps")
						.appendKeyCode(Keyboard.ENTER)
						.build())
					.build());

In this case the cheat code consists of "Enter" + "fps" + "Enter".

For more insight please check out the [example implementation](https://github.com/MattesGroeger/as3-cheats/blob/master/example/src/de/mattesgroeger/cheats/example/Demo.as).

Change log
----------

**0.0.1** (2011/07/07)

* **[Added]** Cheat functionality for any combination of strings and special keys
* **[Added]** Cheats can be toggled (on/off)
* **[Added]** Per cheat and global toggled Signal
* **[Added]** Master Cheat support
* **[Added]** Cheats can be optionally persisted (Local Shared Object)
* **[Added]** Static access for easy access (`CheatLib.get(id)`)

Roadmap
-------

- Default debug output for cheat toggle