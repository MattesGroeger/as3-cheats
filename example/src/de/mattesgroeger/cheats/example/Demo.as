/*
 * Copyright (c) 2011 Mattes Groeger
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package de.mattesgroeger.cheats.example
{
	import de.mattesgroeger.cheats.CheatLib;
	import de.mattesgroeger.cheats.model.CheatBuilder;
	import de.mattesgroeger.cheats.model.CheatCodeBuilder;
	import de.mattesgroeger.cheats.model.ICheat;

	import flash.display.Sprite;
	import flash.ui.Keyboard;

	public class Demo extends Sprite
	{
		private var cheatLib:CheatLib;
		
		public function Demo()
		{
			cheatLib = new CheatLib(stage, "demo");
			
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

			// cheat with complex code
			cheatLib.addCheat(CheatBuilder.create("fps", 
									CheatCodeBuilder.create()
										.appendKeyCode(Keyboard.ENTER)
										.appendString("fps")
										.appendKeyCode(Keyboard.ENTER)
										.build())
									.setLabel("FPS")
									.build());
		}

		private function handleLisaCheatToggle(cheat:ICheat):void
		{
			trace("Cheat 'lisa' (custom listener) " + cheat.activated);
		}

		private function handleAllCheatsToggle(cheat:ICheat):void
		{
			trace("Cheat '" + cheat.id + "' " + cheat.activated);
		}
	}
}