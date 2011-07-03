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
	import org.flexunit.asserts.fail;
	import org.hamcrest.object.equalTo;

	import flash.errors.IllegalOperationError;
	import flash.ui.Keyboard;

	public class CheatCodeTest
	{
		[Test]
		public function should_be_empty():void
		{
			var code:CheatCode = new CheatCode();

			assertThat(code.length, equalTo(0));
		}

		[Test]
		public function should_push_valid_codes():void
		{
			var code:CheatCode = new CheatCode();
			
			code.push(Keyboard.ENTER);
			code.push(54);
			
			assertThat(code.length, equalTo(2));
			assertThat(code.keyCodeAt(0), equalTo(Keyboard.ENTER));
			assertThat(code.keyCodeAt(1), equalTo(54));
		}
		
		[Test]
		public function should_throw_out_of_range_error():void
		{
			var code:CheatCode = new CheatCode();
			code.push(1);
			
			try
			{
				code.keyCodeAt(1);
			}
			catch (e:IllegalOperationError)
			{
				return;
			}
			
			fail("IllegalOperationError expected");
		}

	}
}