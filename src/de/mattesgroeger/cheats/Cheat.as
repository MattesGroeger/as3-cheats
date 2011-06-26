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
package de.mattesgroeger.cheats
{
	import flash.events.EventDispatcher;

	public class Cheat extends EventDispatcher
	{
		private var _cheat:String;
		private var _activated:Boolean;

		/**
		 * Creates a new cheat. If the cheat was already persisted 
		 * before, the initial state is retrieved from persistency.
		 * Optionally you can declare a parent cheat which will then
		 * act as a master cheat. The cheat can't be triggered unless
		 * the parent cheat is enabled.
		 * 
		 * @param cheat The string that should trigger the cheat
		 * @param persistent If the cheat state should be stored inside LSO
		 * @param parent Cheat that acts a master cheat for this one
		 */
		public static function create(cheat:String, persistent:Boolean = false, parent:Cheat = null):Cheat
		{
			return null;
		}

		public function set activated(activated:Boolean):void
		{
			_activated = activated;
		}

		public function get activated():Boolean
		{
			return _activated;
		}

		public function set cheat(cheat:String):void
		{
			_cheat = cheat;
		}

		public function get cheat():String
		{
			return _cheat;
		}
	}
}