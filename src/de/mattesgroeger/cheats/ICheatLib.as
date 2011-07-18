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
	import de.mattesgroeger.cheats.model.Cheat;
	import de.mattesgroeger.cheats.model.ICheat;
	import de.mattesgroeger.cheats.view.ICheatOutput;

	import org.osflash.signals.ISignal;
	
	/**
	 * Main interface for using the as3-cheats library. It is returned by
	 * using the <tt>CheatLib.create()</tt> method.
	 * 
	 * @see de.mattesgroeger.cheats.CheatLib#create()
	 */
	public interface ICheatLib
	{
		/**
		 * Allows to assign an output for visualizing cheat state changes.
		 * 
		 * <p>If you don't assign an output, the <tt>CheatLib</tt> internally
		 * creates an instance of <tt>NoOutput</tt> which doesn't do anything.</p>
		 * 
		 * @see de.mattesgroeger.cheats.view.NotificationOutput
		 * @see de.mattesgroeger.cheats.view.TraceOutput
		 */
		function get output():ICheatOutput;

		function set output(cheatOutput:ICheatOutput):void;
		
		/**
		 * The Signal gets dispatched whenever a cheat has been 
		 * activated/deactivated (toggled). The registered listener 
		 * function needs to have one parameter of type 
		 * <tt>ICheat</tt>.
		 * 
		 * <p>Use this signal for logic that should be executed for
		 * all cheats of this <tt>ICheatLib</tt> instance.</p>
		 * 
		 * <p>If you are interested in toggle signals of specific cheats, 
		 * than register for appropriate the signal in the <tt>ICheat</tt> 
		 * interface.</p>
		 * 
		 * @example <listing version="3.0">
		 * CheatLib.get("demo")
		 *     .toggledSignal
		 *     .add(handleToggle);
		 * 
		 * function handleToggle(cheat:ICheat):void
		 * {
		 *     trace("Cheat '" + cheat.id + "' " + cheat.activated);
		 * }</listing>
		 * @see de.mattesgroeger.cheats.model.ICheat
		 */
		function get toggledSignal():ISignal;
		
		/**
		 * With a master cheat you block other cheats in the same 
		 * <tt>ICheatLib</tt> instance until the master cheat has been activated.
		 * 
		 * <p>The <tt>code</tt> needs to be a <tt>String</tt>. Internally it uses 
		 * this <tt>code</tt> also as <tt>id</tt> for the cheat. For more complex 
		 * cheat <tt>codes</tt> read the documentation of <tt>addCheat()</tt></p>
		 * 
		 * <p>Optionally you can set the <tt>persist</tt> flag in order to store the 
		 * state of the master cheat in the local shared object. The state will be
		 * stored under the <tt>id</tt> of the <tt>ICheatLib</tt> and <tt>ICheat</tt> 
		 * instance to prevent overlapping with other instances.</p>
		 * 
		 * @example <listing version="3.0">
		 * CheatLib.get("demo")
		 *     .createMasterCheat("master", true, "Master");</listing>
		 * @see de.mattesgroeger.cheats.ICheatLib#createCheat()
		 * @see de.mattesgroeger.cheats.ICheatLib#addCheat()
		 * @param code The string that has to be entered for triggering the cheat
		 * @param persist If the state should be stored in the local shared object
		 * @param label Can be used for debug output
		 * @return ICheat
		 */
		function createMasterCheat(code:String, persist:Boolean = false, label:String = null):ICheat;
		
		/**
		 * Allows to set a master cheat that has complex key <tt>codes</tt>. 
		 * 
		 * <p>This method provides the same functionalities as 
		 * <tt>createMasterCheat()</tt> but allows to pass in an existing cheat 
		 * instance. This way you have more flexibility in configuring the cheat
		 * itself.</p>
		 * 
		 * @example <listing version="3.0">
		 * CheatLib.get("demo")
		 *     .addMasterCheat(CheatBuilder.create("master", 
		 *                 CheatCodeBuilder.create()
		 *                     .appendString("master")
		 *                     .appendKeyCode(Keyboard.ENTER)
		 *                     .build())
		 *                 .build());</listing>
		 * @see de.mattesgroeger.cheats.ICheatLib#createMasterCheat()
		 * @see de.mattesgroeger.cheats.model.CheatBuilder
		 * @see de.mattesgroeger.cheats.model.CheatCodeBuilder
		 * @param cheat The cheat that should be used
		 * @param persist If the state should be stored in the local shared object
		 * @return void
		 */
		function addMasterCheat(cheat:Cheat, persist:Boolean = false):void;
		
		/**
		 * A cheat can be activated/deactivated (toggled) by key <tt>codes</tt>.
		 * 
		 * <p>The <tt>code</tt> needs to be a <tt>String</tt>. Internally it uses 
		 * this <tt>code</tt> also as <tt>id</tt> for the cheat. For more complex 
		 * cheat <tt>codes</tt> read the documentation of <tt>addCheat()</tt></p>
		 * 
		 * <p>Optionally you can set the <tt>persist</tt> flag in order to store the 
		 * state of the master cheat in the local shared object. The state will be
		 * stored under the <tt>id</tt> of the <tt>ICheatLib</tt> and <tt>ICheat</tt> 
		 * instance to prevent overlapping with other instances.</p>
		 * 
		 * @example <listing version="3.0">
		 * CheatLib.get("demo")
		 *     .createCheat("test", false, "Test");</listing>
		 * @see de.mattesgroeger.cheats.ICheatLib#createMasterCheat()
		 * @see de.mattesgroeger.cheats.ICheatLib#addCheat()
		 * @param code The string that has to be entered for triggering the cheat
		 * @param persist If the state should be stored in the local shared object
		 * @param label Can be used for debug output
		 * @return ICheat
		 */
		function createCheat(code:String, persist:Boolean = false, label:String = null):ICheat;

		/**
		 * Allows to add externally created <tt>Cheat</tt> instances.
		 * 
		 * <p>Using this method gives more possibilies to configure the actual
		 * <tt>Cheat</tt> instance. It allows for example to define a more complex
		 * key code that also includes special keys (see the example).</p>
		 * 
		 * <p>If you don't need this freedom, you can use the <tt>createCheat()</tt> 
		 * method. It creates the <tt>Cheat</tt> instance internally for you.</p>
		 * 
		 * <p>Optionally you can set the <tt>persist</tt> flag in order to store the 
		 * state of the master cheat in the local shared object. The state will be
		 * stored under the <tt>id</tt> of the <tt>ICheatLib</tt> and <tt>ICheat</tt> 
		 * instance to prevent overlapping with other instances.</p>
		 * 
		 * @example <listing version="3.0">
		 * CheatLib.get("demo")
		 *     .addCheat(CheatBuilder.create("fps", 
		 *                 CheatCodeBuilder.create()
		 *                     .appendKeyCode(Keyboard.ENTER)
		 *                     .appendString("fps")
		 *                     .appendKeyCode(Keyboard.ENTER)
		 *                     .build())
		 *                 .build());</listing>
		 * @see de.mattesgroeger.cheats.ICheatLib#addCheat()
		 * @see de.mattesgroeger.cheats.model.CheatBuilder
		 * @see de.mattesgroeger.cheats.model.CheatCodeBuilder
		 * @param cheat The cheat that should be used
		 * @param persist If the state should be stored in the local shared object
		 * @param applyMaster In case there is already a master cheat defined, if it should be used for this cheat (Note: If you apply the master cheat afterwards, this property has no effect)
		 * @return void
		 */
		function addCheat(cheat:Cheat, persist:Boolean = false, applyMaster:Boolean = true):void;
		
		/**
		 * Returns a previously added or created cheat by <tt>id</tt>.
		 * 
		 * <p>In case of an cheat that has been created via the <tt>createCheat()</tt>
		 * or <tt>createMasterCheat()</tt> methods the <tt>code</tt> is used as 
		 * <tt>id</tt>.</p>
		 * 
		 * @example <listing version="3.0">
		 * CheatLib.get("demo")
		 *     .getCheat("test");</listing>
		 * @param id Id that was set before for the cheat
		 * @return ICheat
		 */
		function getCheat(id:String):ICheat;
		
		/**
		 * Destroys the <tt>ICheatLib</tt> instance. Removes all internal references.
		 */
		function destroy():void;
	}
}
