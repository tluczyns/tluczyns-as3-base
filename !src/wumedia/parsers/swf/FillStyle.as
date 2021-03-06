 /*
  * Copyright 2009 (c) Guojian Miguel Wu
  * 
  * Licensed under the Apache License, Version 2.0 (the "License");
  * you may not use this file except in compliance with the License.
  * You may obtain a copy of the License at
  * 
  * 	http://www.apache.org/licenses/LICENSE-2.0
  * 	
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * 
  * limitations under the License.
  * 
  */
package wumedia.parsers.swf {
	import flash.display.GradientType;
	import flash.geom.Matrix;		

	/**
	 * @author guojian@wu-media.com | guojian.wu@ogilvy.com
	 */
	public class FillStyle {
		public function FillStyle(data:Data, hasAlpha:Boolean) {
			var i:int;
			var fillType:int = data.readUnsignedByte();
			if ( fillType == 0x00 ) {
				_solidColor = new Color(data, hasAlpha);
				_method = "beginFill";
				_arguments = [_solidColor.color, _solidColor.alpha];
				type = "FS";
			} else if ( fillType == 0x10 || fillType == 0x12 || fillType == 0x13 ) {
				// gradient - linear || radial || focal radial
				var numRatios:int;
				var ratios:Array;
				var colors:Array;
				_fillMatrix = data.readMatrix();
       			
       			numRatios = data.readUnsignedByte();
				ratios = new Array(numRatios);
				colors = new Array(numRatios);
				for ( i = 0; i < numRatios; ++i ) {
					ratios[i] = data.readUnsignedByte();
					colors[i] = new Color(data, hasAlpha);
				}
				if ( fillType == 0x10 ) {
					_arguments = [GradientType.LINEAR];
				} else if ( fillType == 0x12 ) {
					_arguments = [GradientType.RADIAL];
				} else /*if ( fillType == 0x13 )*/ {
					_arguments = [GradientType.RADIAL];
				}
				_arguments = _arguments.concat([colors.map(mapColors), colors.map(mapAlphas), ratios]);
				_method = "beginGradientFill";
				type = "FG";
			} else if ( fillType == 0x40 || fillType == 0x41 || fillType == 0x42 || fillType == 0x43 ) {
				// repeat bitmap || regular bitmap || non-smooth repeat || no-smooth regular
				// TODO - not yet implemented
				var bitmapId:uint;
				bitmapId = data.readUnsignedShort();
				_fillMatrix = data.readMatrix();
				_method = "beginBitmapFill";
				type = "FB";
			} else {
				type = "FS";
				_method = "beginFill";
				_arguments = [0xffffff];
			}
		}
		
		public var type			:String;
		private var _solidColor	:Color;
		private var _fillMatrix :Matrix;
		private var _method		:String;
		private var _arguments	:Array;
		
		public function apply(graphics:*, scale:Number = 1.0, offsetX:Number = 0.0, offsetY:Number = 0.0):void {
			if ( graphics["hasOwnProperty"](_method) ) {
				if ( type == "FS" ) {
					graphics[_method].apply(null, _arguments);
				} else {
					var mat:Matrix = _fillMatrix.clone();
					mat.scale(scale, scale);
					mat.translate(offsetX, offsetY);
					graphics[_method].apply(null, _arguments.concat(mat));
				}
			} else if (graphics["hasOwnProperty"]("beginFill")) {
				if ( type == "FG" ) {
					try {
						graphics["beginFill"](_arguments[1][0]);
					} catch (err:Error) {
						graphics["beginFill"](0);
					}
				} else {
					graphics["beginFill"](0);
				}
			}
		}

		private function mapColors(c:Color, ...args):uint { return c.color;}
		private function mapAlphas(c:Color, ...args):uint { return c.alpha;}
		public function get method():* { return _method;}
		
	}
}
