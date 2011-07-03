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
	import org.osflash.signals.Signal;

	import flash.errors.IllegalOperationError;

	public class CheatData
	{
		private var _id:String;
		private var _code:CheatCode;
		private var _parent:CheatData;
		private var _children:Vector.<CheatData>;
		
		private var _activated:Boolean = false;
		private var _toggledSignal:Signal = new Signal();

		public function CheatData(id:String, code:CheatCode, parent:CheatData = null)
		{
			_id = id;
			_code = code;
			_parent = parent;
			
			if (_parent != null)
				_parent.addChild(this);
		}

		internal function get parent():CheatData
		{
			return _parent;
		}

		internal function get children():Vector.<CheatData>
		{
			return _children;
		}
		
		internal function addChild(data:CheatData):void
		{
			if (data.parent != this)
				throw new IllegalOperationError("Can not register child for cheat that is not the parent!");
			
			_children ||= new Vector.<CheatData>();
			_children.push(data);
		}

		public function get id():String
		{
			return _id;
		}

		public function get code():CheatCode
		{
			return _code;
		}

		public function toggle():void
		{
			if (!parentActivated())
				return;
			
			activated = !_activated;
		}

		public function set activated(activated:Boolean):void
		{
			if (!parentActivated())
				return;
			
			if (_activated == activated)
				return;
			
			_activated = activated;
			_toggledSignal.dispatch();
		}

		public function get activated():Boolean
		{
			return (parentActivated()) ? _activated : false;
		}

		private function parentActivated():Boolean
		{
			return (_parent) ? _parent.activated : true;
		}

		public function get toggledSignal():Signal
		{
			return _toggledSignal;
		}
	}
}