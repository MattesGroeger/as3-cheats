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
package de.mattesgroeger.cheats.util
{
	import org.flexunit.assertThat;
	import org.flexunit.asserts.fail;
	import org.hamcrest.object.equalTo;

	import flash.errors.IllegalOperationError;

	public class KeyCodeUtilTest
	{
		[Test]
		public function should_not_allow_multi_character_char():void
		{
			try
			{
				KeyCodeUtil.keyCodeOf("test");
			}
			catch(e:IllegalOperationError)
			{
				return;
			}
			
			fail("Error expected");
		}

		[Test]
		public function should_return_proper_key_code():void
		{
			assertKeyCode("a", 65);
			assertKeyCode("b", 66);
			assertKeyCode("c", 67);
			assertKeyCode("d", 68);
			assertKeyCode("e", 69);
			assertKeyCode("f", 70);
			assertKeyCode("g", 71);
			assertKeyCode("h", 72);
			assertKeyCode("i", 73);
			assertKeyCode("j", 74);
			assertKeyCode("k", 75);
			assertKeyCode("l", 76);
			assertKeyCode("m", 77);
			assertKeyCode("n", 78);
			assertKeyCode("o", 79);
			assertKeyCode("p", 80);
			assertKeyCode("q", 81);
			assertKeyCode("r", 82);
			assertKeyCode("s", 83);
			assertKeyCode("t", 84);
			assertKeyCode("u", 85);
			assertKeyCode("v", 86);
			assertKeyCode("w", 87);
			assertKeyCode("x", 88);
			assertKeyCode("y", 89);
			assertKeyCode("z", 90);
			
			assertKeyCode("0", 48);
			assertKeyCode("1", 49);
			assertKeyCode("2", 50);
			assertKeyCode("3", 51);
			assertKeyCode("4", 52);
			assertKeyCode("5", 53);
			assertKeyCode("6", 54);
			assertKeyCode("7", 55);
			assertKeyCode("8", 56);
			assertKeyCode("9", 57);
		}

		private function assertKeyCode(char:String, expectedKeyCode:int):void
		{
			assertThat(KeyCodeUtil.keyCodeOf(char), equalTo(expectedKeyCode));
		}
	}
}