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
	import de.mattesgroeger.cheats.view.ICheatOutput;
	import de.mattesgroeger.cheats.view.NoOutput;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import flash.errors.IllegalOperationError;
	import flash.events.IEventDispatcher;
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	
	use namespace cheat_internal;
	
	/**
	 * Main class of the as3-cheats library. Use the static methods
	 * to create instances of the <tt>CheatLib</tt>.
	 * 
	 * @see de.mattesgroeger.cheats.CheatLib#create()
	 * @see de.mattesgroeger.cheats.CheatLib#get()
	 */
	public class CheatLib implements ICheatsProvider, ICheatLib
	{
		private static var cheatLibs:Dictionary = new Dictionary();
		
		private var _timeoutMs:uint;
		private var _masterCheat:Cheat;
		private var _cheats:Vector.<Cheat>;
		private var _cheatObserver:CheatObserver;
		private var _sharedObject:SharedObject;
		private var _cheatOutput:ICheatOutput;
		private var _toggledSignal:Signal = new Signal(ICheat);
		
		/**
		 * Creates a new <tt>CheatLib</tt> instance where you can add the cheats.
		 * 
		 * @example <listing version="3.0">
		 * var lib:ICheatLib = CheatLib.create(stage, "demo", 2000);</listing>
		 * @param stage The stage of your application in order to receive the KeybordEvents
		 * @param id Id for the <tt>CheatLib</tt> instance
		 * @param timeoutMs Milliseconds after which the keyboard input gets resetted
		 * @return ICheatLib
		 */
		public static function create(stage:IEventDispatcher, id:String, timeoutMs:uint = 2000):ICheatLib
		{
			if (cheatLibs[id] != null)
				throw new IllegalOperationError("A CheatLib was already registered for id " + id + ". Make sure to not call create() twice with the same id!");
			
			var cheatLib:CheatLib = new CheatLib(stage, id, timeoutMs);
			
			cheatLibs[id] = cheatLib;
			
			return cheatLib;
		}
		
		/**
		 * Returns a previously created <tt>CheatLib</tt> by id.
		 * 
		 * @example <listing version="3.0">
		 * var lib:ICheatLib = CheatLib.get("demo");</listing>
		 * @param id Id of the <tt>CheatLib</tt> instance
		 * @return ICheatLib
		 */
		public static function get(id:String):ICheatLib
		{
			if (!has(id))
				throw new IllegalOperationError("No CheatLib registered for id " + id + ". Make sure to create() one before!");
			
			return cheatLibs[id];
		}
		
		/**
		 * Returns whether a <tt>CheatLib</tt> exists for the specified id.
		 * 
		 * @example <listing version="3.0">
		 * var exists:Boolean = CheatLib.has("demo");</listing>
		 * @param id Id of the <tt>CheatLib</tt> instance
		 * @return Boolean
		 */
		public static function has(id:String):Boolean
		{
			return (cheatLibs[id] != null);
		}

		/**
		 * @private
		 */
		public function CheatLib(stage:IEventDispatcher, id:String, timeoutMs:uint = 2000)
		{
			_timeoutMs = timeoutMs;
			_cheats = new Vector.<Cheat>();
			_cheatObserver = new CheatObserver(stage, this);
			_sharedObject = SharedObject.getLocal(id);
			_cheatOutput = new NoOutput();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get output():ICheatOutput
		{
			return _cheatOutput;
		}

		public function set output(cheatView:ICheatOutput):void
		{
			_cheatOutput.destroy();
			
			_cheatOutput = cheatView;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get toggledSignal():ISignal
		{
			return _toggledSignal;
		}
		
		/**
		 * @private
		 */
		public function get cheats():Vector.<Cheat>
		{
			return _cheats;
		}

		/**
		 * @inheritDoc
		 */
		public function getCheat(id:String):ICheat
		{
			for each (var cheat:Cheat in _cheats)
			{
				if (cheat.id == id)
					return cheat;
			}
			
			throw new IllegalOperationError("No cheat found for id " + id + "!");
		}

		/**
		 * @inheritDoc
		 */
		public function createMasterCheat(code:String, persist:Boolean = false, label:String = null):ICheat
		{
			if (_masterCheat != null)
				throw new IllegalOperationError("You can only set one master cheat! Already set " + _masterCheat.id + "!");
			
			_masterCheat = buildCheat(code, label);
			
			registerCheat(_masterCheat, persist);
			updateMasterCheatInExistingOnes();
			
			return _masterCheat;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addMasterCheat(cheat:Cheat, persist:Boolean = false):void
		{
			if (_masterCheat != null)
				throw new IllegalOperationError("You can only set one master cheat! Already set " + _masterCheat.id + "!");
			
			_masterCheat = cheat;
			
			registerCheat(_masterCheat, persist);
			updateMasterCheatInExistingOnes();
		}

		/**
		 * @inheritDoc
		 */
		public function createCheat(code:String, persist:Boolean = false, label:String = null):ICheat
		{
			var cheat:Cheat = buildCheat(code, label);
			registerCheat(cheat, persist);
			
			return cheat;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addCheat(cheat:Cheat, persist:Boolean = false, applyMaster:Boolean = true):void
		{
			if (_masterCheat && applyMaster)
				cheat.parent = _masterCheat;
			
			if (persist)
				cheat.sharedObject = _sharedObject;
			
			cheat.toggledSignal.add(handleToggledSignal);
			
			_cheats.push(cheat);
		}

		private function buildCheat(code:String, label:String):Cheat
		{
			var cheatCode:ICheatCode = CheatCodeBuilder.create()
											.appendString(code)
											.build();
			
			var cheat:Cheat = new Cheat(code, cheatCode, _masterCheat);
			
			if (label != null)
				cheat.label = label;
			
			return cheat;
		}

		private function registerCheat(cheat:Cheat, persist:Boolean):void
		{
			if (persist)
				cheat.sharedObject = _sharedObject;
			
			cheat.toggledSignal.add(handleToggledSignal);
			
			_cheats.push(cheat);
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

		private function handleToggledSignal(cheat:ICheat):void
		{
			_cheatOutput.cheatToggled(cheat);
			_toggledSignal.dispatch(cheat);
		}

		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			for each (var cheat:Cheat in _cheats)
				cheat.toggledSignal.remove(handleToggledSignal);
			
			_cheatOutput.destroy();
			_cheatObserver.destroy();
			_cheats = null;
			_masterCheat = null;
			_cheatOutput = null;
		}
	}
}