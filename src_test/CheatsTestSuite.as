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
package
{
	import de.mattesgroeger.cheats.CheatLibTest;
	import de.mattesgroeger.cheats.controller.CheatObserverTest;
	import de.mattesgroeger.cheats.model.CheatBuilderTest;
	import de.mattesgroeger.cheats.model.CheatCodeBuilderTest;
	import de.mattesgroeger.cheats.model.CheatCodeTest;
	import de.mattesgroeger.cheats.model.CheatTest;
	import de.mattesgroeger.cheats.util.KeyCodeUtilTest;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class CheatsTestSuite
	{
		public var cheatLibTest:CheatLibTest;
		public var keyCodeUtilTest:KeyCodeUtilTest;
		public var cheatTest:CheatTest;
		public var cheatBuilderTest:CheatBuilderTest;
		public var cheatCodeTest:CheatCodeTest;
		public var cheatCodeBuilderTest:CheatCodeBuilderTest;
		public var cheatObserverTest:CheatObserverTest;
	}
}