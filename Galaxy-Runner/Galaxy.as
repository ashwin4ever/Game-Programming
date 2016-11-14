package{
	
		import flash.display.Sprite;
		import flash.filters.GlowFilter;
		import flash.events.MouseEvent;
		import flash.ui.Mouse;
		import flash.events.Event;
		import flash.geom.Vector3D;
		import com.greensock.*;
		import com.greensock.easing.*;
		
		public class Galaxy extends Sprite{
			
			private var _menuScr:MenuScreen;
			
			private var _shipFilter:GlowFilter = new GlowFilter(0x33FF00, 0.8, 4, 4, 2, 3, false, false);
			private var _smokeFilter:GlowFilter = new GlowFilter(0xCCFF00, 0.8, 4, 4, 6, 3, false, false);
			private var _fuelFilter:GlowFilter = new GlowFilter(0xCC99FF, 0.8, 4, 4, 2, 3, false, false);
			private var _rockFilter:GlowFilter = new GlowFilter(0x9933FF, 0.8, 4, 4, 2, 3, false, false);
			private var _scoreFilter:GlowFilter = new GlowFilter(0xCC66FF, 0.8, 4, 4, 2, 3, false, false);
			private var _gasoline:Number;
			
			private var _gravity:Number = 0.1;
			private var _thrust:Number = 0.29;
			private var _xSpeed:Number = 5;
			private var _ySpeed:Number = 0;
			private var _smokeInterval:Number = 10;
			private var _frameCount:Number = 0;
			private var _isEngine:Boolean = false;
			private var _shipAngle:Number;
			private var _rockFrequency:Number;
			private var _fuelFrequency:Number;
			
			private var ship:Ship;
			private var _smokeCanvas:Sprite;
			private var _rockCanvas:Sprite;
			private var _fuelCanvas:Sprite;
			private var _smokeVec:Vector.<Smoke>;
			private var _rockVec:Vector.<Rock>;
			private var _fuelVec:Vector.<Fuel>;
			private var _starVec:Vector.<Star>;
			
			private var _score:Score;
			
			private var _star:Star;
			private var _beamSpot:BeamSpot;
			private var _beamCanvas:Sprite;
			
			private var _beamX:Number;
			private var _beamY:Number;
			private var _distance:Number;
			private var _starSpeed:Number;
			
			public function Galaxy(){
				
				init();
				
			}//end of funtion
			
			private function init():void{
				
				_menuScr = new MenuScreen();
				addChild(_menuScr);
				
				_menuScr.start_btn.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
				_menuScr.start_btn.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
				_menuScr.start_btn.addEventListener(MouseEvent.CLICK, onPressed);
				
				_gasoline = 500;
				_shipAngle = 0;
				_rockFrequency = 25;
				_fuelFrequency = 10;
				_distance = 0;
				_gravity = 0.1;
				_thrust = 0.29;
				_ySpeed = 0;
				_frameCount = 0;
				_smokeInterval = 10;
				_starSpeed = 3;
				
				_star = new Star();
				_beamSpot = new BeamSpot();
				_smokeCanvas = new Sprite();
				_rockCanvas = new Sprite();
				_fuelCanvas = new Sprite();
				_beamCanvas = new Sprite();
				
				_smokeVec = new Vector.<Smoke>();
				_rockVec = new Vector.<Rock>();
				_fuelVec = new Vector.<Fuel>();
				_starVec = new Vector.<Star>();
				_score = new Score();
				
				
				addChild(_smokeCanvas);
				addChild(_rockCanvas);
				addChild(_fuelCanvas);
				addChild(_beamCanvas);
				addChild(_score);
				
				
			}//end of init
			
			private function onMouseOver(m:MouseEvent):void{
				TweenNano.to(m.target,0.5, {scaleX: 1.2, scaleY: 1.2, ease:Back.easeOut});
			}//end of mouse over
			
			private function onMouseOut(m:MouseEvent):void{
				TweenNano.to(m.target,0.5, {scaleX: 1, scaleY: 1, ease:Back.easeIn});
			}//end of on mouse out
			
			private function onPressed(m:MouseEvent):void{
				
				//trace("pressed");
				stage.focus = stage;
				
				TweenNano.to(_menuScr, 0.5, {y: -_menuScr.height, ease:Circ, onComplete: run});
				//removeChild(_menuScr);
				
			}//end of on pressed
			
			private function run():void{
				
				_menuScr.start_btn.removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
				_menuScr.start_btn.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
				_menuScr.start_btn.removeEventListener(MouseEvent.CLICK, onPressed);
				stage.focus = stage;
				removeChild(_menuScr);
				_menuScr = null;
				
				//addChild(_starField);
				ship = new Ship();
				ship.x = 120;
				ship.y = 240;
				addChild(ship);
				_ySpeed = 0;
				ship.filters = [_shipFilter];
				
				addChild(_beamSpot);
				_beamSpot.filters = [_smokeFilter];
				
				_score.filters = [_scoreFilter];
				_score.x = 100;
				_score.y = 30;
				
				for(var i: Number = 0; i < 250; i++){
					var s:Star = new Star();
					s.x = Math.random() * 550;
					s.y = Math.random() * 400;
					addChild(s);
					_starVec.push(s);
				}
				
				addEventListener(Event.ENTER_FRAME, onFrameEnter);
				stage.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
				stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
				
			}//end of run
			
			private function onDown(m:MouseEvent):void{
				//trace("running");
				_isEngine = true;
				_frameCount = _smokeInterval;
				
			}//end of on down
			
			private function onUp(m:MouseEvent):void{
				
				_isEngine = false;
				_smokeInterval = 10;
				
			}//end of on up
			
			private function onFrameEnter(e:Event):void{
				
				//trace("ship y: " +ship.y);
				//trace("y speed: " +_ySpeed);
				//trace("engine: " +_isEngine);
				//Add rocks
				if(Math.random() * 1000 < _rockFrequency){
					var rock:Rock = new Rock();
					rock.y = Math.random() * 400 + 40;
					rock.x = 670;
					//rock.rotation = Math.random() * 360;
					rock.filters = [_rockFilter];
					_rockCanvas.addChild(rock);
					_rockVec.push(rock);
				}
				//Add fuel
				if(Math.random() * 1000 < _fuelFrequency){
					var fuel:Fuel = new Fuel();
					fuel.y = Math.random() * 400 + 40;
					fuel.x = 650;
					fuel.filters = [_fuelFilter];
					_fuelCanvas.addChild(fuel);
					_fuelVec.push(fuel);
				}
				
				_distance += _xSpeed;
				_score.scoreTxt.text = "Distance: " + _distance + " - " + " Fuel: " + _gasoline;
			
				//Making ship move
				if(_gasoline > 0 && _isEngine){
					
					_ySpeed -= _thrust;
					_smokeInterval -= 0.25;
					_gasoline--;
					//trace(_frameCount++);
					//trace(_smokeInterval);
					_frameCount++;
					if(_smokeInterval < _frameCount){
						
						var smoke:Smoke = new Smoke();
						smoke.x = ship.x;
						smoke.y = ship.y;
						smoke.filters = [_smokeFilter];
					    _smokeCanvas.addChild(smoke);
						_smokeVec.push(smoke);
						_frameCount = 0;
						_smokeInterval -= 0.01;
						
					}
					
				}
				
				
				
				//make rocks move
				for(var i:Number = _rockVec.length - 1; i >= 0; i--){
					
					_rockVec[i].x -= _xSpeed;
					_rockVec[i].rotation += 2;
					
					if(_rockVec[i].hitTestObject(_beamSpot)){
						_rockVec[i].alpha -= 0.02;
						
						if(_rockVec[i].alpha < 0){
							if(_rockVec[i] != null && _rockCanvas.contains(_rockVec[i]))
								_rockCanvas.removeChild(_rockVec[i]);
						}
					}
					if(_rockVec[i].x < -10){
						if(_rockVec[i] != null && _rockCanvas.contains(_rockVec[i]))
							_rockCanvas.removeChild(_rockVec[i]);
					}
				}
				
				//Emit smoke from ship
				for(i = _smokeVec.length - 1; i >= 0; i--){
					
					_smokeVec[i].x -= _xSpeed;
					_smokeVec[i].width += 0.2;
					_smokeVec[i].height += 0.2;
					_smokeVec[i].alpha -= 0.02;
					
					if(_smokeVec[i].alpha < 0){
						_smokeCanvas.removeChild(_smokeVec[i]);
						_smokeVec.splice(i, 1);
					}
				}
				
				if(_distance % 700 == 0)
					_starSpeed++;
				
				//make stars move
				for(i = _starVec.length - 1; i >= 0; i--){
					_starVec[i].x -= _starSpeed;
					
					if(_starVec[i].x < 0){
						_starVec[i].x = 560;
					}
				}
				
				//make fuel move
				for(i = _fuelVec.length - 1; i >= 0; i--){
					_fuelVec[i].x -= _xSpeed * 1.2;
					var distX:Number = ship.x + Math.cos(_shipAngle) - _fuelVec[i].x;
					var distY:Number = ship.y + Math.sin(_shipAngle) - _fuelVec[i].y;
					var dist:Number = Math.sqrt(distX * distX + distY * distY);
					
					if(_fuelVec[i].hitTestObject(_beamSpot)){
						_fuelVec[i].alpha -= 0.02;
						if(_fuelVec[i].alpha < 0){
							if(_fuelVec[i] != null && _fuelCanvas.contains(_fuelVec[i]))
								_fuelCanvas.removeChild(_fuelVec[i]);
						}
					}
					
					
					if(dist < 10){
						_gasoline += 100;
						if(_fuelVec[i] != null && _fuelCanvas.contains(_fuelVec[i])){
							_fuelCanvas.removeChild(_fuelVec[i]);
							_fuelVec.splice(i, 1);
						}
					}
					else{
						if(_fuelVec[i].x < -10){
							if(_fuelVec[i] != null && _fuelCanvas.contains(_fuelVec[i])){
								_fuelCanvas.removeChild(_fuelVec[i]);
								_fuelVec.splice(i, 1);
							}
						}
					}
				}
				
				
				_ySpeed += _gravity;
				ship.y += _ySpeed;
				
				_shipAngle = Math.atan2(_ySpeed, _xSpeed);
				ship.rotation = _shipAngle * 180 / Math.PI;
				//trace("ship angle: " +_shipAngle * 180 / Math.PI);
				//fire laser
				_beamCanvas.graphics.clear();
				_beamCanvas.graphics.lineStyle(1, 0xCC0000, 10 + Math.random() * 40);
				_beamCanvas.graphics.moveTo(ship.x + 30 * Math.cos(_shipAngle), ship.y + 30 * Math.sin(_shipAngle));
				//_beamCanvas.graphics.lineTo(mouseX, mouseY);
				
				for(i = 0; i < 250; i++){
					_beamX = ship.x + (30 + i) * Math.cos(_shipAngle);
					_beamY = ship.y + (30 + i) * Math.sin(_shipAngle);
					
					if(_rockCanvas.hitTestPoint(_beamX, _beamY, true) || _fuelCanvas.hitTestPoint(_beamX, _beamY, true)){
						break;
					}
				}
				
				_beamCanvas.graphics.lineTo(_beamX, _beamY);
				_beamSpot.x = _beamX;
				_beamSpot.y = _beamY;
				
				
				//check ship collision
				//trace(ship.x + 28 * Math.cos(_shipAngle));
				if(ship.y < 0 || ship.y > 400 || _rockCanvas.hitTestPoint(ship.x + 28 * Math.cos(_shipAngle), ship.y + 28 * Math.sin(_shipAngle), true) || _rockCanvas.hitTestPoint(ship.x + 8 * Math.cos(_shipAngle + Math.PI / 2), ship.y + 8 * Math.sin(_shipAngle + Math.PI / 2), true) || _rockCanvas.hitTestPoint(ship.x + 8 * Math.cos(_shipAngle - Math.PI / 2), ship.y + 8 * Math.sin(_shipAngle - Math.PI / 2), true) ){
					//trace("end");
					restart();
				}
				
				
			}//end of on frame enter
			
			private function restart():void{
				
				removeEventListener(Event.ENTER_FRAME, onFrameEnter);
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
				
				_isEngine = false;
				//rockVector=new Vector.<Rock>();
				for(var i:Number = _starVec.length - 1; i >= 0; i--)
					removeChild(_starVec[i]);
				_starVec = new Vector.<Star>();
				removeChild(_rockCanvas);
				//_thrust = 0;
				//_gravity = 0;
				//rockCanvas=new Sprite();
				//addChild(rockCanvas);
				//fuelVector=new Vector.<Fuel>();
				removeChild(_fuelCanvas);
				//fuelCanvas=new Sprite();
				//addChild(fuelCanvas);
				//smokeVector=new Vector.<Smoke>();
				removeChild(_smokeCanvas);
				
				removeChild(ship);
				removeChild(_beamSpot);
				ship = null;
				
				//removeChild(_starField);
				removeChild(_score);
				//_starField = null;
				_beamCanvas.graphics.clear();
				//smokeCanvas=new Sprite();
				//addChild(smokeCanvas);
				init();
			
			}//end of restart
			
		}//end of class
	
}//end of package