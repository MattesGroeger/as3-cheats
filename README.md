AS3 Cheats
==================

This library provides an easy way to handle cheats within flash. Register a key combination or phrase to a cheat and it gets then triggered by the library.

**Use cases for this library:**

- Enable functionalities in live environments which should be normally deactivated (e.g. logging)
- Use cheats within games
- Trigger easter eggs

**What does it do?**

It observes all keyboard inputs and compares them against the keycode combinations registered for your cheats. Whenever a keyboard input matches, the appropriate cheat gets toggled and you can trigger a custom action.

Beside this basic functionality it provides an easy way to define master cheats. They prevent your users from accidentally triggering easy to type cheats. Furthermore cheat states can be  stored in the local shared object. This way you don't have to re-enter the cheats the next time you start your application.

See the examples below for more details.

**Dependencies**

This library is compiled against *as3-signals-v0.7*. The SWC is included in the download file.
More information regarding as3-signals can be [found here](https://github.com/robertpenner/as3-signals).

Usage
-----

**Download**

Download the latest version from [the downloads page](https://github.com/MattesGroeger/as3-cheats/downloads). The zip file contains all necessary SWC files and the asdocs. Put the SWC files in your projects libs folder and/or add them to the classpath of your project.

**Creation**

First of all you have to initialize the `CheatLib` with the `stage` and a custom identifier (id):

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

**Output**

To display cheat toggles this library provides several default implementations. If you want to see a visual output you can assign an instance of `NotificationOutput` to your `CheatLib`:

	CheatLib.get("demo")
		.output = new NotificationOutput(stage);

And this is how it looks like for a master cheat toggle:

![Notification output example](https://github.com/MattesGroeger/as3-cheats/blob/master/assets/example.png?raw=true "Notification output example")

Beside this visual output the library comes with a `TraceOutput` which just traces all cheat toggles. By default the `CheatLib` uses the `NoOutput` which doesn't do anything.

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

**0.0.3-SNAPSHOT**

* **[Added]** Added `CheatLib.has(id)` method to determent if a lib exists for a certain key
* **[Added]** Added `applyMaster` parameter to `addCheat()` in case you want to ignore the master cheat
* **[Added]** Added method `addMasterCheat` to CheatLib

**0.0.2** (2011/07/13)

* **[Added]** Added output functionality for `CheatLib` (shows state changes). You can use one of the default implementations (NotificationOutput, TraceOutput) or assign your own ones.
* **[Changed]** Default timeout is now 2 seconds instead of 3

**0.0.1** (2011/07/07)

* **[Added]** Cheat functionality for any combination of strings and special keys
* **[Added]** Cheats can be toggled (on/off)
* **[Added]** Per cheat and global toggled Signal
* **[Added]** Master Cheat support
* **[Added]** Cheats can be optionally persisted (Local Shared Object)
* **[Added]** Static access for easy access (`CheatLib.get(id)`)

Roadmap
-------

- Anything missing? [Please let me know](https://github.com/MattesGroeger).