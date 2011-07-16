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
	import de.mattesgroeger.cheats.model.ICheatCode;
	import de.mattesgroeger.cheats.model.ICheat;
	import org.mockito.integrations.times;
	import org.mockito.integrations.verify;
	import de.mattesgroeger.cheats.model.Cheat;
	import de.mattesgroeger.cheats.model.CheatBuilder;
	import de.mattesgroeger.cheats.model.CheatCodeBuilder;
	import de.mattesgroeger.cheats.view.ICheatOutput;
	import de.mattesgroeger.cheats.view.NoOutput;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.fail;
	import org.flexunit.rules.IMethodRule;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.nullValue;
	import org.mockito.integrations.flexunit4.MockitoRule;

	import flash.errors.IllegalOperationError;
	import flash.events.IEventDispatcher;

	public class CheatLibTest
	{
		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();

		[Mock]
		public var stage:IEventDispatcher;
		
		[Mock]
		public var output1:ICheatOutput;
		
		[Mock]
		public var output2:ICheatOutput;
		
		[Mock]
		public var cheatCode:ICheatCode;
		
		[Test]
		public function should_create_and_return():void
		{
			var cheatLib:ICheatLib = CheatLib.create(stage, "test");
			
			assertThat(cheatLib.output, instanceOf(NoOutput));
			assertThat(cheatLib, equalTo(CheatLib.get("test")));
		}

		[Test]
		public function should_fail_because_no_cheatlib_created():void
		{
			try
			{
				CheatLib.get("abc");
			}
			catch (e:IllegalOperationError)
			{
				return;
			}
			
			fail("Error expected");
		}

		[Test]
		public function should_fail_because_cheatlib_with_same_id_already_exists():void
		{
			CheatLib.create(stage, "c");
			
			try
			{
				CheatLib.create(stage, "c");
			}
			catch (e:IllegalOperationError)
			{
				return;
			}
			
			fail("Error expected");
		}

		[Test]
		public function should_create_cheat():void
		{
			var cheatLib:CheatLib = new CheatLib(stage, "test");

			var cheat:Cheat = Cheat(cheatLib.createCheat("abc"));
			
			assertThat(cheat.id, equalTo("abc"));
			assertThat(cheat.code.keyCodeAt(0), equalTo(65));
			assertThat(cheat.code.keyCodeAt(1), equalTo(66));
			assertThat(cheat.code.keyCodeAt(2), equalTo(67));
			assertThat(cheat.activated, equalTo(false));
			assertThat(cheat.label, nullValue());
		}

		[Test]
		public function should_add_cheat():void
		{
			var cheatLib:CheatLib = new CheatLib(stage, "test");
			var cheat:Cheat = new Cheat("test", cheatCode);
			
			cheatLib.addCheat(cheat);
			
			assertThat(cheatLib.getCheat("test"), equalTo(cheat));
		}
		
		[Test]
		public function should_add_master_cheat():void
		{
			var cheatLib:CheatLib = new CheatLib(stage, "test");
			
			var cheatA:Cheat = Cheat(cheatLib.createCheat("a"));
			var cheatB:Cheat = CheatBuilder.create("b", CheatCodeBuilder.create().appendString("b").build()).build();
			cheatLib.addCheat(cheatB);
			var cheatC:Cheat = new Cheat("test", cheatCode);
			cheatLib.addMasterCheat(cheatC);
			var cheatD:Cheat = Cheat(cheatLib.createCheat("d"));
			var cheatE:Cheat = CheatBuilder.create("e", CheatCodeBuilder.create().appendString("e").build()).build();
			cheatLib.addCheat(cheatE);

			assertThat(cheatA.cheat_internal::parent, equalTo(cheatC));
			assertThat(cheatB.cheat_internal::parent, equalTo(cheatC));
			assertThat(cheatD.cheat_internal::parent, equalTo(cheatC));
			assertThat(cheatE.cheat_internal::parent, equalTo(cheatC));
			assertThat(cheatC.cheat_internal::children.length, equalTo(4));
			assertThat(cheatC.cheat_internal::children[0], equalTo(cheatA));
			assertThat(cheatC.cheat_internal::children[1], equalTo(cheatB));
			assertThat(cheatC.cheat_internal::children[2], equalTo(cheatD));
			assertThat(cheatC.cheat_internal::children[3], equalTo(cheatE));
		}

		[Test]
		public function should_create_master_cheat():void
		{
			var cheatLib:CheatLib = new CheatLib(stage, "test");

			var cheatA:Cheat = Cheat(cheatLib.createCheat("a"));
			var cheatB:Cheat = CheatBuilder.create("b", CheatCodeBuilder.create().appendString("b").build()).build();
			cheatLib.addCheat(cheatB);
			var cheatC:Cheat = Cheat(cheatLib.createMasterCheat("c"));
			var cheatD:Cheat = Cheat(cheatLib.createCheat("d"));
			var cheatE:Cheat = CheatBuilder.create("e", CheatCodeBuilder.create().appendString("e").build()).build();
			cheatLib.addCheat(cheatE);

			assertThat(cheatA.cheat_internal::parent, equalTo(cheatC));
			assertThat(cheatB.cheat_internal::parent, equalTo(cheatC));
			assertThat(cheatD.cheat_internal::parent, equalTo(cheatC));
			assertThat(cheatE.cheat_internal::parent, equalTo(cheatC));
			assertThat(cheatC.cheat_internal::children.length, equalTo(4));
			assertThat(cheatC.cheat_internal::children[0], equalTo(cheatA));
			assertThat(cheatC.cheat_internal::children[1], equalTo(cheatB));
			assertThat(cheatC.cheat_internal::children[2], equalTo(cheatD));
			assertThat(cheatC.cheat_internal::children[3], equalTo(cheatE));
		}

		[Test]
		public function should_fail_because_of_multiple_master_cheats():void
		{
			var cheatLib:CheatLib = new CheatLib(stage, "test");
			cheatLib.createMasterCheat("a");
			
			try
			{
				cheatLib.createMasterCheat("b");
			}
			catch (e:IllegalOperationError)
			{
				return;
			}
			
			fail("Error expected!");
		}

		[Test]
		public function sould_return_cheat_by_id():void
		{
			var cheatLib:CheatLib = new CheatLib(stage, "test");

			var cheatA:Cheat = Cheat(cheatLib.createCheat("a"));
			var cheatB:Cheat = CheatBuilder.create("b", CheatCodeBuilder.create().appendString("b").build()).build();
			cheatLib.addCheat(cheatB);
			var cheatC:Cheat = Cheat(cheatLib.createMasterCheat("c"));
			var cheatD:Cheat = Cheat(cheatLib.createCheat("d"));
			var cheatE:Cheat = CheatBuilder.create("e", CheatCodeBuilder.create().appendString("e").build()).build();
			cheatLib.addCheat(cheatE);
			
			assertThat(cheatLib.getCheat("a"), equalTo(cheatA));
			assertThat(cheatLib.getCheat("b"), equalTo(cheatB));
			assertThat(cheatLib.getCheat("c"), equalTo(cheatC));
			assertThat(cheatLib.getCheat("d"), equalTo(cheatD));
			assertThat(cheatLib.getCheat("e"), equalTo(cheatE));
		}

		[Test]
		public function should_throw_error_for_not_existent_cheat():void
		{
			var cheatLib:CheatLib = new CheatLib(stage, "test");
			
			try
			{
				cheatLib.getCheat("a");
			}
			catch (e:IllegalOperationError)
			{
				return;
			}
			
			fail("Error expected!");
		}
		
		[Test]
		public function should_set_output():void
		{
			var cheatLib:CheatLib = new CheatLib(stage, "test");
			
			cheatLib.output = output1;
			
			assertThat(cheatLib.output, equalTo(output1));
		}
		
		[Test]
		public function should_destroy_old_output():void
		{
			var cheatLib:CheatLib = new CheatLib(stage, "test");
			cheatLib.output = output1;
			cheatLib.output = output2;
			
			verify(times(1)).that(output1.destroy());
		}
	}
}