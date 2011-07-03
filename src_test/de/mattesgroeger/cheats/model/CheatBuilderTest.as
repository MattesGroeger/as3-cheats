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
	import org.flexunit.rules.IMethodRule;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.mockito.integrations.flexunit4.MockitoRule;

	public class CheatBuilderTest
	{
		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();

		[Mock]
		public var cheatCode:ICheatCode;

		[Mock(argsList="masterCheatArgs")]
		public var masterCheat:Cheat;
		public var masterCheatArgs:Array = [null, null];
		
		[Test]
		public function should_build_default_cheat():void
		{
			var cheat:ICheat = CheatBuilder.create("test", cheatCode)
								.setLabel("Label")
								.setMasterCheat(masterCheat)
								.build();

			assertThat(cheat.id, equalTo("test"));
			assertThat(cheat.code, equalTo(cheatCode));
			assertThat(cheat.label, equalTo("Label"));
		}
	}
}