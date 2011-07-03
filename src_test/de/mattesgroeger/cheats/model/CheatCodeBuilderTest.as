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
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;

	import flash.ui.Keyboard;

	public class CheatCodeBuilderTest
	{
		[Test]
		public function should_build_cheat_code():void
		{
			var cheatCode:CheatCode = CheatCodeBuilder.create()
										.appendKeyCode(Keyboard.ENTER)
										.appendString("test")
										.appendKeyCode(Keyboard.ESCAPE)
										.build();

			assertThat(cheatCode.length, equalTo(6));
			assertThat(cheatCode.keyCodeAt(0), equalTo(13));
			assertThat(cheatCode.keyCodeAt(1), equalTo(84));
			assertThat(cheatCode.keyCodeAt(2), equalTo(69));
			assertThat(cheatCode.keyCodeAt(3), equalTo(83));
			assertThat(cheatCode.keyCodeAt(4), equalTo(84));
			assertThat(cheatCode.keyCodeAt(5), equalTo(27));
		}
	}
}