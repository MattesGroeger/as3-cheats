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

	import flash.errors.IllegalOperationError;
	
	use namespace cheat_internal;

	public class Cheat implements ICheat
	{
		private var _id:String;
		private var _code:ICheatCode;
		private var _parent:ToggleCheat;
		private var _label:String;
		
		private var _children:Vector.<Cheat>;
		private var _triggerSignal:Signal = new Signal(ICheat);

		public function Cheat(id:String, code:ICheatCode, parent:ToggleCheat = null, label:String = null)
		{
			_id = id;
			_code = code;
			_parent = parent;
			_label = label;
			
			if (_parent != null)
				_parent.addChild(this);
		}

		/**
		 * @inheritDoc
		 */
		public function get id():String
		{
			return _id;
		}

		/**
		 * @private
		 */
		public function get code():ICheatCode
		{
			return _code;
		}

		/**
		 * @private
		 */
		public function set label(label:String):void
		{
			_label = label;
		}

		/**
		 * @inheritDoc
		 */
		public function get label():String
		{
			return _label;
		}

		/**
		 * @inheritDoc
		 */
		public function get triggerSignal():ISignal
		{
			return _triggerSignal;
		}

		/**
		 * @private
		 */
		public function trigger():void
		{
			if (!parentActivated())
				return;
			
			_triggerSignal.dispatch(this);
		}

		cheat_internal function set parent(parent:ToggleCheat):void
		{
			_parent = parent;
			_parent.addChild(this);
		}

		cheat_internal function get parent():ToggleCheat
		{
			return _parent;
		}

		cheat_internal function get children():Vector.<Cheat>
		{
			return _children;
		}
		
		cheat_internal function addChild(data:Cheat):void
		{
			if (data.parent != this)
				throw new IllegalOperationError("Can not register child for cheat that is not the parent!");
			
			_children ||= new Vector.<Cheat>();
			_children.push(data);
		}

		protected function parentActivated():Boolean
		{
			return (_parent) ? _parent.activated : true;
		}
	}
}