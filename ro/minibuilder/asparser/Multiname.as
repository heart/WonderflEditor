/* license section

Flash MiniBuilder is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Flash MiniBuilder is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Flash MiniBuilder.  If not, see <http://www.gnu.org/licenses/>.


Author: Victor Dramba
2009
*/

/*
 * @Author Dramba Victor
 * 2009
 * 
 * You may use this code any way you like, but please keep this notice in
 * The code is provided "as is" without warranty of any kind.
 */

package ro.minibuilder.asparser
{
	import ro.victordramba.util.HashMap;

	public class Multiname
	{
		public function Multiname(type:String=null, imports:HashMap=null)
		{
			this.imports = imports;
			this.type = type;
		}
		
		public var resolved:Field;
		public var imports:HashMap;
		public var type:String;
		
		//public var resolved:Field;
		
		public function toString():String
		{
			return '[Multiname '+type+']';
		}
	}
}