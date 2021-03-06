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
package de.mattesgroeger.cheats.view
{
	import de.mattesgroeger.cheats.view.ICheatOutput;
	import de.mattesgroeger.cheats.model.ICheat;

	/**
	 * This class provides a trace output for cheat state changes.
	 * 
	 * <p>Whenever a cheat state is toggled a trace will be created. If you set
	 * a label for your cheat it will be used. Otherwise the id/code
	 * will be displayed instead.</p>
	 * 
	 * @example <listing version="3.0">
	 * var cheatLib:ICheatLib = CheatLib.get("demo")
	 * cheatLib.output = new TraceOutput();</listing>
	 */
	public class TraceOutput implements ICheatOutput
	{
		public function cheatToggled(cheat:ICheat):void
		{
			var label:String = cheat.label != null ? cheat.label : cheat.id;
			
			trace("Cheat " + label.toUpperCase() + " " + (cheat.activated ? "activated" : "deactivated"));
		}

		public function destroy():void
		{
		}
	}
}