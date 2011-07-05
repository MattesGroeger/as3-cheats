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
	import flash.utils.Dictionary;
	import de.mattesgroeger.cheats.controller.CheatObserver;
	import de.mattesgroeger.cheats.controller.ICheatsProvider;
	import de.mattesgroeger.cheats.model.Cheat;
	import de.mattesgroeger.cheats.model.CheatCodeBuilder;
	import de.mattesgroeger.cheats.model.ICheat;
	import de.mattesgroeger.cheats.model.ICheatCode;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import flash.errors.IllegalOperationError;
	import flash.events.IEventDispatcher;
	import flash.net.SharedObject;
	
	use namespace cheat_internal;
	
	public class CheatLib implements ICheatsProvider, ICheatLib
	{
		private static var cheatLibs:Dictionary = new Dictionary();
		
		private var _timeoutMs:uint;
		private var _masterCheat:Cheat;
		private var _cheats:Vector.<Cheat>;
		private var _cheatObserver:CheatObserver;
		private var _sharedObject:SharedObject;
		private var _toggledSignal:Signal = new Signal(ICheat);

		public static function create(stage:IEventDispatcher, id:String, timeoutMs:uint = 3000):ICheatLib
		{
			if (cheatLibs[id] != null)
				throw new IllegalOperationError("A CheatLib was already registered for id " + id + ". Make sure to not call create() twice with the same id!");
			
			var cheatLib:CheatLib = new CheatLib(stage, id, timeoutMs);
			
			cheatLibs[id] = cheatLib;
			
			return cheatLib;
		}
		
		public static function get(id:String):ICheatLib
		{
			if (cheatLibs[id] == null)
				throw new IllegalOperationError("No CheatLib registered for id " + id + ". Make sure to create() one before!");
			
			return cheatLibs[id];
		}

		public function CheatLib(stage:IEventDispatcher, id:String, timeoutMs:uint = 3000)
		{
			_timeoutMs = timeoutMs;
			_cheats = new Vector.<Cheat>();
			_cheatObserver = new CheatObserver(stage, this);
			_sharedObject = SharedObject.getLocal(id);
		}

		public function get toggledSignal():ISignal
		{
			return _toggledSignal;
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
			
			updateMasterCheatInExistingOnes();
			
			return _masterCheat;
		}

		private function updateMasterCheatInExistingOnes():void
		{
			for each (var cheat:Cheat in _cheats)
			{
				if (cheat == _masterCheat)
					continue;
				
				cheat.parent = _masterCheat;
			}
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
			
			cheat.toggledSignal.add(delegateToggledSignal);
			
			_cheats.push(cheat);
		}

		private function registerCheat(code:String, persist:Boolean, label:String):Cheat
		{
			var cheatCode:ICheatCode = CheatCodeBuilder.create()
											.appendString(code)
											.build();
			
			var cheat:Cheat = new Cheat(code, cheatCode, _masterCheat);
			
			if (label != null)
				cheat.label = label;
			
			if (persist)
				cheat.sharedObject = _sharedObject;
			
			cheat.toggledSignal.add(delegateToggledSignal);
			
			_cheats.push(cheat);
			
			return cheat;
		}

		private function delegateToggledSignal(cheat:ICheat):void
		{
			_toggledSignal.dispatch(cheat);
		}

		public function destroy():void
		{
			_cheatObserver.destroy();
			_cheats = null;
			_masterCheat = null;
		}
	}
}