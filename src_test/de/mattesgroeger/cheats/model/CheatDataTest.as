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
	import org.osflash.signals.utils.failOnSignal;
	import org.flexunit.rules.IMethodRule;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.notNullValue;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.osflash.signals.utils.SignalAsyncEvent;
	import org.osflash.signals.utils.handleSignal;

	public class CheatDataTest
	{
		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();
		
		[Mock]
		public var cheatCode:CheatCode;
		
		[Test]
		public function should_be_correct_initialized():void
		{
			var data:CheatData = new CheatData("test", cheatCode);

			assertThat(data.id, equalTo("test"));
			assertThat(data.code, equalTo(cheatCode));
			assertThat(data.activated, equalTo(false));
			assertThat(data.toggledSignal, notNullValue());
		}

		[Test(async)]
		public function should_dispatch_toggle():void
		{
			var data:CheatData = new CheatData("test", cheatCode);
			handleSignal(this, data.toggledSignal, handleToggled, 10, {data:data}); 
			
			data.activated = true;
		}

		[Test(async)]
		public function should_toggle():void
		{
			var data:CheatData = new CheatData("test", cheatCode);
			handleSignal(this, data.toggledSignal, handleToggled, 10, {data:data}); 
			
			data.toggle();
		}

		private function handleToggled(event:SignalAsyncEvent, data:Object):void
		{
			assertThat(CheatData(data.data).activated, equalTo(true));
		}

		[Test(async)]
		public function should_not_toggle():void
		{
			var data:CheatData = new CheatData("test", cheatCode);
			failOnSignal(this, data.toggledSignal); 
			
			data.activated = false;
		}
	}
}