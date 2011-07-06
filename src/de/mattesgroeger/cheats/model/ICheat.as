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
	import org.osflash.signals.ISignal;
	
	/**
	 * Basic interface for all cheats.
	 */
	public interface ICheat
	{
		/**
		 * Returns the id of this cheat. It should be unique within one <tt>CheatLib</tt>.
		 */
		function get id():String;
		
		/**
		 * Returns the label of this cheat. It can be used for debug output.
		 */
		function get label():String;
		
		/**
		 * The Signal gets dispatched whenever the cheat has been 
		 * activated/deactivated (toggled). The registered listener 
		 * function needs to have one parameter of type 
		 * <tt>ICheat</tt>.
		 * 
		 * @example <listing version="3.0">
		 * CheatLib.get("demo")
		 *     .getCheat("test")
		 *         .toggledSignal
		 *         .add(handleCheatToggle);
		 * 
		 * function handleCheatToggle(cheat:ICheat):void
		 * {
		 *     trace("Cheat " + cheat.activated);
		 * }</listing>
		 * @see de.mattesgroeger.cheats.model.ICheat
		 */
		function get toggledSignal():ISignal;
		
		/**
		 * Returns whether the cheat is currently activated or not.
		 * 
		 * <p>Be aware that the state won't change in case of a master
		 * cheat that is not activated.</p>
		 */
		function get activated():Boolean;
	}
}