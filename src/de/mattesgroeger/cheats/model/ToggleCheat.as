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
package de.mattesgroeger.cheats.model
{
	import de.mattesgroeger.cheats.cheat_internal;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import flash.net.SharedObject;
	
	use namespace cheat_internal;
	
	public class ToggleCheat extends Cheat implements IToggleCheat
	{
		private var _activated:Boolean = false;
		private var _sharedObject:SharedObject;
		private var _toggleSignal:Signal = new Signal(IToggleCheat);

		public function ToggleCheat(id:String, code:ICheatCode, parent:ToggleCheat = null, label:String = null)
		{
			super(id, code, parent, label);
		}

		/**
		 * @private
		 */
		public function set activated(activated:Boolean):void
		{
			if (!parentActivated())
				return;
			
			if (_activated == activated)
				return;
			
			_activated = activated;
			_toggleSignal.dispatch(this);
			
			storeState();
		}

		/**
		 * @inheritDoc
		 */
		public function get activated():Boolean
		{
			return (parentActivated()) ? _activated : false;
		}
		
		/**
		 * @private
		 */
		public override function trigger():void
		{
			if (!parentActivated())
				return;
			
			activated = !_activated;
			
			super.trigger();
		}

		/**
		 * @inheritDoc
		 */
		public function get toggleSignal():ISignal
		{
			return _toggleSignal;
		}

		cheat_internal function set sharedObject(sharedObject:SharedObject):void
		{
			_sharedObject = sharedObject;
			
			loadState();
		}

		private function storeState():void
		{
			if (_sharedObject != null)
				_sharedObject.data[id] = activated;
		}

		private function loadState():void
		{
			if (_sharedObject.data[id] is Boolean)
				activated = _sharedObject.data[id];
		}
	}
}