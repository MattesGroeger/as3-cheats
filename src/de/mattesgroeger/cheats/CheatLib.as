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
	import de.mattesgroeger.cheats.controller.CheatObserver;
	import de.mattesgroeger.cheats.controller.ICheatsProvider;
	import de.mattesgroeger.cheats.model.Cheat;
	import de.mattesgroeger.cheats.model.CheatCodeBuilder;
	import de.mattesgroeger.cheats.model.ICheat;
	import de.mattesgroeger.cheats.model.ICheatCode;

	import flash.errors.IllegalOperationError;
	import flash.events.IEventDispatcher;
	import flash.net.SharedObject;
	
	use namespace cheat_internal;
	
	public class CheatLib implements ICheatsProvider
	{
		private var _timeoutMs:uint;
		private var _masterCheat:Cheat;
		private var _cheats:Vector.<Cheat>;
		private var _cheatObserver:CheatObserver;
		private var _sharedObject:SharedObject;

		public function CheatLib(stage:IEventDispatcher, name:String, timeoutMs:uint = 3000)
		{
			_timeoutMs = timeoutMs;
			_cheats = new Vector.<Cheat>();
			_cheatObserver = new CheatObserver(stage, this);
			_sharedObject = SharedObject.getLocal(name);
		}

		public function get cheats():Vector.<Cheat>
		{
			return _cheats;
		}

		public function createMasterCheat(code:String, persist:Boolean = false, label:String = null):ICheat
		{
			if (_masterCheat != null)
				throw new IllegalOperationError("You can only set one master cheat! Already set " + _masterCheat.id + "!");
			
			_masterCheat = registerCheat(code, persist, label);
			
			for each (var cheat:Cheat in _cheats)
			{
				if (cheat == _masterCheat)
					continue;
				
				cheat.parent = _masterCheat;
			}
			
			return _masterCheat;
		}

		public function createCheat(code:String, persist:Boolean = false, label:String = null):ICheat
		{
			return registerCheat(code, persist, label);
		}

		public function addCheat(cheat:Cheat, persist:Boolean = false):void
		{
			if (_masterCheat)
				cheat.parent = _masterCheat;
			
			if (persist)
				cheat.sharedObject = _sharedObject;
			
			_cheats.push(cheat);
		}

		private function registerCheat(code:String, persist:Boolean, label:String):Cheat
		{
			var cheatCode : ICheatCode = CheatCodeBuilder.create()
											.appendString(code)
											.build();
			
			var cheat:Cheat = new Cheat(code, cheatCode, _masterCheat);
			
			if (label != null)
				cheat.label = label;
			
			if (persist)
				cheat.sharedObject = _sharedObject;
			
			_cheats.push(cheat);
			
			return cheat;
		}

		public function destroy():void
		{
			_cheatObserver.destroy();
			_cheats = null;
			_masterCheat = null;
		}
	}
}