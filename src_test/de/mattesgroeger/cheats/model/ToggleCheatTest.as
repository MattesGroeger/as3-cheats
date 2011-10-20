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

	import org.flexunit.rules.IMethodRule;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.notNullValue;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.osflash.signals.utils.SignalAsyncEvent;
	import org.osflash.signals.utils.failOnSignal;
	import org.osflash.signals.utils.handleSignal;
	import org.osflash.signals.utils.proceedOnSignal;
	
	use namespace cheat_internal;
	
	public class ToggleCheatTest
	{
		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();
		
		[Mock]
		public var cheatCode:CheatCode;
		
		private var root:ToggleCheat;
		private var sub1a:ToggleCheat;
		private var sub1b:ToggleCheat;
		private var sub2c:ToggleCheat;
		private var sub2d:ToggleCheat;
		
		/**
		 *   root		 r   
		 *   		    / \
		 *   		   /   \
		 *   sub1	  a  	b
		 *   	  		   / \
		 *   	  		  /   \
		 *   sub2	     c     d
		 */
		[Before]
		public function before():void
		{
			root = new ToggleCheat("root", cheatCode);
			sub1a = new ToggleCheat("sub1a", cheatCode, root);
			sub1b = new ToggleCheat("sub1b", cheatCode, root);
			sub2c = new ToggleCheat("sub2c", cheatCode, sub1b);
			sub2d = new ToggleCheat("sub2d", cheatCode, sub1b);
		}
		
		[Test]
		public function should_be_correct_initialized():void
		{
			assertThat(root.id, equalTo("root"));
			assertThat(root.code, equalTo(cheatCode));
			assertThat(root.activated, equalTo(false));
			assertThat(root.toggleSignal, notNullValue());
		}

		[Test]
		public function should_register_parent():void
		{
			assertThat(sub1a.parent, equalTo(root));
			assertThat(sub1b.parent, equalTo(root));
			assertThat(root.children.length, equalTo(2));
			assertThat(sub1b.children.length, equalTo(2));
			assertThat(sub2c.parent, equalTo(sub1b));
			assertThat(sub2d.parent, equalTo(sub1b));
		}

		[Test(async)]
		public function should_dispatch_toggle():void
		{
			handleSignal(this, root.toggleSignal, handleToggled, 10, {data:root}); 
			
			root.activated = true;
		}

		[Test(async)]
		public function should_toggle():void
		{
			handleSignal(this, root.toggleSignal, handleToggled, 10, {data:root}); 
			
			root.trigger();
		}

		private function handleToggled(event:SignalAsyncEvent, data:Object):void
		{
			assertThat(ToggleCheat(data["data"]).activated, equalTo(true));
		}

		[Test(async)]
		public function should_not_toggle():void
		{
			failOnSignal(this, root.toggleSignal); 
			
			root.activated = false;
		}
		
		[Test(async)]
		public function should_not_toggle_because_of_deactivated_parent():void
		{
			failOnSignal(this, root.toggleSignal); 
			failOnSignal(this, sub1a.toggleSignal); 
			failOnSignal(this, sub1b.toggleSignal); 
			failOnSignal(this, sub2c.toggleSignal); 
			failOnSignal(this, sub2d.toggleSignal); 
			
			sub1a.activated = true;
			sub1b.activated = true;
			sub2c.activated = true;
			sub2d.activated = true;
		}
		
		[Test(async)]
		public function should_toggle_because_of_activated_parent():void
		{
			proceedOnSignal(this, root.toggleSignal); 
			proceedOnSignal(this, sub1a.toggleSignal); 
			failOnSignal(this, sub1b.toggleSignal); 
			failOnSignal(this, sub2c.toggleSignal); 
			failOnSignal(this, sub2d.toggleSignal); 
			
			root.activated = true;
			sub1a.activated = true;
			sub2c.activated = true;
			sub2d.activated = true;
		}
		
		[Test(async)]
		public function should_activate_all():void
		{
			proceedOnSignal(this, root.toggleSignal); 
			proceedOnSignal(this, sub1a.toggleSignal); 
			proceedOnSignal(this, sub1b.toggleSignal); 
			proceedOnSignal(this, sub2c.toggleSignal); 
			proceedOnSignal(this, sub2d.toggleSignal); 
			
			root.activated = true;
			sub1a.activated = true;
			sub1b.activated = true;
			sub2c.activated = true;
			sub2d.activated = true;
		}
	}
}