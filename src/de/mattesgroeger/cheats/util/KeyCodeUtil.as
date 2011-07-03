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
	import flash.errors.IllegalOperationError;
	
	/**
	 * Based on <tt>KeyCodeUtil.as</tt> of 
	 * Andy Li (andy@onthewings.net)
	 * 2009-11-02
	 */
	public class KeyCodeUtil
	{
		private static const KEY_CODES:Object = {
			27: 27,         //esc
			96: 192,        //`
			49: 49,         //1
			50: 50,         //2
			51: 51,         //3
			52: 52,         //4
			53: 53,         //5
			54: 54,         //6
			55: 55,         //7
			56: 56,         //8
			57: 57,         //9
			48: 48,         //0
			45: 189,        //-
			61: 187,        //=
			8: 8,           //backspace
			9: 9,           //tab
			113: 81,        //q
			119: 87,        //w
			101: 69,        //e
			114: 82,        //r
			116: 84,        //t
			121: 89,        //y
			117: 85,        //u
			105: 73,        //i
			111: 79,        //o
			112: 80,        //p
			91: 219,        //[
			93: 221,        //]
			92: 220,        //\
			97: 65,         //a
			115: 83,        //s
			100: 68,        //d
			102: 70,        //f
			103: 71,        //g
			104: 72,        //h
			106: 74,        //j
			107: 75,        //k
			108: 76,        //l
			59: 186,        //;
			39: 222,        //'
			13: 13,         //enter
			122: 90,        //z
			120: 88,        //x
			99: 67,         //c
			118: 86,        //v
			98: 66,         //b
			110: 78,        //n
			109: 77,        //m
			44: 188,        //,
			46: 190,        //.
			47: 191,        ///
			32: 32,         //space
			127: 46,        //delete
			126: 192,       //~
			33: 49,         //!
			64: 50,         //@
			35: 51,         //#
			36: 52,         //$
			37: 53,         //%
			94: 54,         //^
			38: 55,         //&
			42: 56,         //*
			40: 57,         //(
			41: 48,         //)
			95: 189,        //_
			43: 187,        //+
			81: 81,         //Q
			87: 87,         //W
			69: 69,         //E
			82: 82,         //R
			84: 84,         //T
			89: 89,         //Y
			85: 85,         //U
			73: 73,         //I
			79: 79,         //O
			80: 80,         //P
			123: 219,       //{
			125: 221,       //}
			124: 220,       //|
			65: 65,         //A
			83: 83,         //S
			68: 68,         //D
			70: 70,         //F
			71: 71,         //G
			72: 72,         //H
			74: 74,         //J
			75: 75,         //K
			76: 76,         //L
			58: 186,        //:
			34: 222,        //"
			90: 90,         //Z
			88: 88,         //X
			67: 67,         //C
			86: 86,         //V
			66: 66,         //B
			78: 78,         //N
			77: 77,         //M
			60: 188,        //<
			62: 190,        //>
			63: 191         //?
		};
		
		/**
		 * Returns the keyCode for a certain char.
		 * 
		 * @param char The char the you want to know the keyCode of
		 * @return keyCode, -1 in case it can't be found
		 */
		public static function keyCodeOf(char:String):int
		{
			if (char.length > 1)
				throw new IllegalOperationError("You can not assign a multiple character " +
					"string here (now: " + char.length + ")! Use one char only!");
			
			var charCode:Number = char.charCodeAt();

			return KEY_CODES[charCode] ? KEY_CODES[charCode] : -1;
		}
	}
}