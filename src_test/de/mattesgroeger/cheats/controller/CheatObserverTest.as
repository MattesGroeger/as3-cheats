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
package de.mattesgroeger.cheats.controller
{
	import de.mattesgroeger.cheats.model.Cheat;
	import de.mattesgroeger.cheats.model.CheatCode;

	import org.flexunit.async.Async;
	import org.flexunit.rules.IMethodRule;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.given;
	import org.mockito.integrations.never;
	import org.mockito.integrations.times;
	import org.mockito.integrations.verify;

	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class CheatObserverTest
	{
		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();
		
		[Mock]
		public var cheatCode1:CheatCode;
		
		[Mock]
		public var cheatCode2:CheatCode;
		
		[Mock]
		public var cheatsProvider:ICheatsProvider;

		[Mock(argsList="cheatDataArgs")]
		public var cheatData1:Cheat;
		
		[Mock(argsList="cheatDataArgs")]
		public var cheatData2:Cheat;
		
		public var cheatDataArgs:Array = [null, null];
		
		private var dispatcher:IEventDispatcher;
		private var observer:CheatObserver;
		
		[Before]
		public function before():void
		{
			dispatcher = new EventDispatcher();
			observer = new CheatObserver(dispatcher, cheatsProvider, 0);
			
			given(cheatsProvider.cheats).willReturn(Vector.<Cheat>([cheatData1, cheatData2]));
			
			given(cheatData1.code).willReturn(cheatCode1);
			given(cheatCode1.keyCodeAt(0)).willReturn(1);
			given(cheatCode1.keyCodeAt(1)).willReturn(2);
			given(cheatCode1.length).willReturn(2);
			
			given(cheatData2.code).willReturn(cheatCode2);
			given(cheatCode2.keyCodeAt(0)).willReturn(2);
			given(cheatCode2.keyCodeAt(1)).willReturn(3);
			given(cheatCode2.keyCodeAt(2)).willReturn(4);
			given(cheatCode2.length).willReturn(3);
		}

		[Test]
		public function should_toggle_cheat():void
		{
			dispatchKey(99);
			dispatchKey(1);
			dispatchKey(2);
			
			verify(times(1)).that(cheatData1.trigger());
			verify(never()).that(cheatData2.trigger());
		}

		[Test]
		public function should_not_trigger_cheat():void
		{
			dispatchKey(1);
			dispatchKey(99);
			dispatchKey(2);
			
			verify(never()).that(cheatData1.trigger());
			verify(never()).that(cheatData2.trigger());
		}

		[Test]
		public function should_ignore_first_typo_error():void
		{
			dispatchKey(1);
			dispatchKey(99);
			dispatchKey(1);
			dispatchKey(2);
			
			verify(times(1)).that(cheatData1.trigger());
			verify(never()).that(cheatData2.trigger());
		}

		[Test]
		public function should_ignore_first_double_letter():void
		{
			dispatchKey(99);
			dispatchKey(99);
			dispatchKey(1);
			dispatchKey(2);
			
			verify(times(1)).that(cheatData1.trigger());
			verify(never()).that(cheatData2.trigger());
		}

		[Test]
		public function should_toggle_both_cheats():void
		{
			dispatchKey(1);
			dispatchKey(2);
			dispatchKey(3);
			dispatchKey(4);
			
			verify(times(1)).that(cheatData1.trigger());
			verify(times(1)).that(cheatData2.trigger());
		}
		
		[Test(async)]
		public function should_timeout():void
		{
			dispatchKey(2);
			dispatchKey(3);

			var timer:Timer = new Timer(10, 1);
			Async.handleEvent(this, timer, TimerEvent.TIMER_COMPLETE, handleTimerTimeout);
			timer.start();
		}

		private function handleTimerTimeout(event:TimerEvent, passThroughData:Object):void
		{
			dispatchKey(4);
			
			verify(never()).that(cheatData1.trigger());
			verify(never()).that(cheatData2.trigger());
		}
		
		[Test(async)]
		public function should_not_timeout():void
		{
			observer.timeout = 1000;
			
			dispatchKey(2);
			dispatchKey(3);

			var timer:Timer = new Timer(10, 1);
			Async.handleEvent(this, timer, TimerEvent.TIMER_COMPLETE, handleTimer);
			timer.start();
		}

		private function handleTimer(event:TimerEvent, passThroughData:Object):void
		{
			dispatchKey(4);
			
			verify(never()).that(cheatData1.trigger());
			verify(times(1)).that(cheatData2.trigger());
		}

		private function dispatchKey(keyCode:uint):void
		{
			dispatcher.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, true, false, 0, keyCode));
		}
		
		[Test]
		public function should_destroy():void
		{
			observer.destroy();
		}
	}
}