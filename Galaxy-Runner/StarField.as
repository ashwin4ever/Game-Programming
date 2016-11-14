package{
	
		import flash.display.Sprite;
		import flash.display.MovieClip;
		import flash.display.Bitmap;
		import flash.display.BitmapData;
		import flash.geom.Point;
		import flash.display.BlendMode;
		import flash.events.Event;
		import flash.filters.*;
		
		
		public class StarField extends MovieClip{
		
			private var _canvas:Sprite;
			private var _bd:BitmapData;
			private var _bmp:Bitmap;
			
			private var _offSet:Array;
			
			private var _glowFilter:GlowFilter = new GlowFilter(0xCC6600, 0.8 , 1, 1, 2 , 3);
			//dark blue 0x3300CC
			//yellow 0x66FF33
			
			public function StarField(){
				
				_canvas = new Sprite();
				
				_offSet = new Array(new Point(0, 0), new Point(0 , 0));
				
				_bd = new BitmapData(10, 10, false);
				
				_bmp = new Bitmap(_bd);
				addChild(_bmp);
				_bmp.scaleX = _bmp.scaleY = 60;
				
				_bmp.mask = _canvas;
				_bmp.blendMode = BlendMode.SCREEN;
				_bmp.filters = [_glowFilter];		
				addChild(_canvas);
				
				/*_canvas.graphics.beginFill(0xFFFFFF);
				_canvas.graphics.drawCircle( 550 * Math.random() ,  400 * Math.random() , Math.random() * 1.5);
				_canvas.graphics.endFill();*/
				
				for(var i:int = 0; i < 400; i++){
					_canvas.graphics.beginFill(0xFFFFFF);
					_canvas.graphics.drawCircle( 550 * Math.random() ,  400 * Math.random() , Math.random() * 1.5);
					_canvas.graphics.endFill();
				}
				//update();
				addEventListener(Event.ENTER_FRAME, onFrameEnter);
				
				//trace(_canvas.numChildren);
				
			}//end of star field
			
			public function onFrameEnter(e: Event):void{
				
				_offSet[1].x += 0.05;
				_offSet[1].y += 0.14;
				_bd.perlinNoise(2, 2, 2, 0, false, true, 7, true, _offSet);
				//_canvas.x -= Math.random() * 3 + 3;
				
				
			}//end of on frame enter
		
		}//end of class starfield
	
	
}//end of package