package{
	
		import flash.display.Sprite;
		import flash.ui.Mouse;
		import flash.events.KeyboardEvent;
		import flash.events.MouseEvent;
		import flash.events.Event;
		import com.greensock.TweenNano;
		import com.greensock.easing.Circ;
		
		
		public class BreakOut extends Sprite{
			
			private const BRICK_W:int = 39;
			private const BRICK_H:int = 19;
			private const OFFSET:int = 6;
			private const W_LEN:int = 8;
			private const SCORE_CONST:int = 100;
			
			private var _brickVec:Vector.<Sprite> = new Vector.<Sprite>();
			private var _xSpeed:Number = 5;
			private var _ySpeed:Number = -5;
			private var _xDir:int = 1;
			private var _yDir:int = 1;
			
			private var _gameEventStr:String;
			private var _currentLevel:int = 0;
			private var _alertScr:AlertScreen;
			private var _menuScr:MenuScreen;
			private var _creditScr:CreditScreen;
			
			private var _lives:int = 3;
			private var _levels:Array = [];
			
			private const LEVEL_1:Array = [[0,0,0,0,0,0,0,0],
									   [0,0,0,0,0,0,0,0],
									   [0,0,0,1,1,0,0,0],
									   [0,0,0,1,1,0,0,0],
									   [0,1,1,1,1,1,1,0],
									   [0,1,1,1,1,1,1,0],
									   [0,0,0,1,1,0,0,0],
									   [0,0,0,1,1,0,0,0],
									   [0,0,0,0,0,0,0,0]];
		
			private const LEVEL_2:Array = [[0,0,0,0,0,0,0,0],
									   [0,0,0,1,1,0,0,0],
									   [0,0,1,0,0,1,0,0],
									   [0,0,0,0,0,1,0,0],
									   [0,0,0,0,1,0,0,0],
									   [0,0,0,1,0,0,0,0],
									   [0,0,1,0,0,0,0,0],
									   [0,0,1,1,1,1,0,0]];
			
			private const LEVEL_3:Array = [[0,1,1,1,1,1,0,0],
									   	   [0,0,0,0,0,1,0,0],
									       [0,0,0,0,0,1,0,0],
									       [0,0,0,0,0,1,0,0],
									       [0,0,1,1,1,1,0,0],
									       [0,0,0,0,0,1,0,0],
									       [0,0,0,0,0,1,0,0],
									       [0,1,1,1,1,1,0,0]];
			
		
			public final function BreakOut(){
				
				//add levels
				_levels.push(LEVEL_1, LEVEL_2, LEVEL_3);
				
				_menuScr = new MenuScreen();
				addChild(_menuScr);
				
				_menuScr.start_mc.addEventListener(MouseEvent.MOUSE_UP, tweenMC);
				_menuScr.about_mc.addEventListener(MouseEvent.MOUSE_UP, tweenMC);
				
			}//end of function
			
			private function tweenMC(m:MouseEvent):void{
				//m.target.scaleX = 0.3;
				//m.target.scaleY = 0.3;
				//trace(m.target.name);
				if(m.target.name == "start_mc"){
					
					TweenNano.to(_menuScr, 0.5, {y: -_menuScr.height, ease:Circ, onComplete:init}); 
				}
				else{
					_creditScr = new CreditScreen();
					addChild(_creditScr);
					
					TweenNano.from(_creditScr, 0.3, {x: stage.stageWidth, ease: Circ});
					_creditScr.addEventListener(MouseEvent.MOUSE_UP, hideCredits);
				}
				
			}//end of tweenmc
			
			private function hideCredits(m:MouseEvent):void{
				
				TweenNano.to(_creditScr, 0.3, {x: stage.stageWidth, ease: Circ, 
							 onComplete: function remove():void{
								 _creditScr.removeEventListener(MouseEvent.MOUSE_UP, hideCredits);
								 removeChild(_creditScr);}});
																											 
																											
				
			}//end of hidecredits
			
			private function init():void{
				
				_menuScr.start_mc.removeEventListener(MouseEvent.MOUSE_UP, tweenMC);
				_menuScr.about_mc.removeEventListener(MouseEvent.MOUSE_UP, tweenMC);
				
				_menuScr = null;
				//trace("init");
				buildLevel(LEVEL_1);
				
				background_mc.addEventListener(MouseEvent.MOUSE_UP, startGame);
								
			}//end of init
			
			private function buildLevel(level : Array):void{
				
				var len:int = level.length;
				//trace("building");
				//trace(level);
				for(var i:int = 0; i < len; i++){
					for(var j:int = 0; j < W_LEN; j++){
						//trace(level[i][j]);
						if(level[i][j] == 1){
							
							var brick:Brick = new Brick();
							brick.x = OFFSET + (BRICK_W * j);
							brick.y = BRICK_H * i + 60;
							
							addChild(brick);
							_brickVec.push(brick);
							
						}
					
					}//end of for j
					
				}//end of for i
				
			}//end of build level
			
			private function gameListeners(action:String = "add"):void{
				
				if(action == "add"){
					stage.addEventListener(MouseEvent.MOUSE_MOVE, movePaddle);
					stage.addEventListener(Event.ENTER_FRAME, onFrameEnter);
				}
				else{
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, movePaddle);
					stage.removeEventListener(Event.ENTER_FRAME, onFrameEnter);
				}
				
			}//end of game listeners
			
			private function startGame(m:MouseEvent):void{
			
				background_mc.removeEventListener(MouseEvent.MOUSE_UP, startGame);
				gameListeners();
			
			}//end of startGame
			
			private function movePaddle(m:MouseEvent):void{
				
				paddle_mc.x = mouseX;
				
				Mouse.hide();
				if(paddle_mc.x < 0){
					paddle_mc.x = 0 + paddle_mc.width / 2;
				}
				else if((paddle_mc.x + paddle_mc.width) > stage.stageWidth){
					
					paddle_mc.x = stage.stageWidth - paddle_mc.width ;
				}
				
				
			}//end of move paddle
			
			private function onFrameEnter(e:Event):void{
				
				ball_mc.x += _xSpeed;
				ball_mc.y += _ySpeed;
				
				if(ball_mc.x < 0){
					ball_mc.x = 0 + ball_mc.width / 2;
					_xSpeed = -_xSpeed;
				}
				else if(ball_mc.x + ball_mc.width > stage.stageWidth){
					ball_mc.x = stage.stageWidth - ball_mc.width;
					_xSpeed = -_xSpeed;
				}
				
				if(ball_mc.y < 0){
					ball_mc.y = 0 + ball_mc.height / 2;
					_ySpeed = -_ySpeed;
				}
				else if(ball_mc.y + ball_mc.height > stage.stageHeight){
					ball_mc.y = stage.stageHeight - ball_mc.height;
					_ySpeed = -_ySpeed;
				}
				
				if(ball_mc.y + ball_mc.height > paddle_mc.y + paddle_mc.height){
					alert("You Lose", "Play Again");
					_gameEventStr = "lose";
					_lives--;
					livesTxt.text = String(_lives);
				}
				
				//Paddle and ball colision
				
				if(paddle_mc.hitTestObject(ball_mc) && (ball_mc.x + ball_mc.width / 2) < paddle_mc.x + paddle_mc.width / 2){
					//trace("true");
					_xSpeed = -7;
					_ySpeed = -7;
				}
				else if(paddle_mc.hitTestObject(ball_mc) && (ball_mc.x + ball_mc.width / 2) >= paddle_mc.x + paddle_mc.width / 2){
					_xSpeed = 7;
					_ySpeed = -7;
				}
				
				//Ball and Brick Collision
				
				for(var i:int = 0; i < _brickVec.length; i++){
					if(ball_mc.hitTestObject(_brickVec[i])){
						_ySpeed = -_ySpeed;
						
						if(ball_mc.x + ball_mc.width / 2 < (_brickVec[i].x + _brickVec[i].width / 2)){
							_xSpeed = -5;
						}
						else if(ball_mc.x + ball_mc.width / 2 >= (_brickVec[i].x + _brickVec[i].width / 2)){
							_xSpeed = 5;
						}
						
						removeChild(_brickVec[i]);
						_brickVec.splice(i, 1);
						
						scoreTxt.text = String(int(scoreTxt.text) + SCORE_CONST);
					}
														  
				}//end of for i
				
				//check if all bricks are removed
				
				if(_brickVec.length < 1){
					alert("You Win", "Next level");
					_gameEventStr = "win";
				}
				
			}//end of on frame enter
			
			private function alert(t:String, m:String):void{
				
				gameListeners("remove");
				Mouse.show();
				
				_alertScr = new AlertScreen();
				addChild(_alertScr);
				
				TweenNano.from(_alertScr, 0.3, {scaleX : 0.5, scaleY: 0.5, ease: Circ});
				_alertScr.resultTxt.text = t;
				_alertScr.msgTxt.text = m;
				
				_alertScr.addEventListener(MouseEvent.MOUSE_UP, restart);
				
			}//end of alert
			
			private function restart(m:MouseEvent):void{
				
				if(_gameEventStr == "win" && _levels.length > _currentLevel + 1){
					_currentLevel++;
					changeLevel(_levels[_currentLevel]);
					levelTxt.text = String(_currentLevel + 1);
				}
				else if(_gameEventStr == "win" && _levels.length <= _currentLevel + 1){
					_alertScr.removeEventListener(MouseEvent.MOUSE_UP, restart);
					_alertScr = null;
					
					alert("Game Over!!" , "Congratulations !!");
					_gameEventStr = "finished";
				}
				
				else if(_gameEventStr == "lose" && _lives > 0){
					changeLevel(_levels[_currentLevel]);
				}
				else if(_gameEventStr == "lose" && _lives <= 0){
					_alertScr.removeEventListener(MouseEvent.MOUSE_UP, restart);
					removeChild(_alertScr);
					_alertScr = null;
					
					alert("Game Over", "Try Again?");
					_gameEventStr = "finished";
				}
				
				else if(_gameEventStr == "finished"){
					
					_menuScr = new MenuScreen();
					addChild(_menuScr);
					
					_menuScr.start_mc.addEventListener(MouseEvent.MOUSE_UP, tweenMC);
					_menuScr.about_mc.addEventListener(MouseEvent.MOUSE_UP, tweenMC);
					
					TweenNano.from(_menuScr, 0.3, {y: -_menuScr.height, ease: Circ});
					
					//reset vars
					
					_currentLevel = 0;
					_lives = 3;
					livesTxt.text = String(_lives);
					scoreTxt.text = "0";
					levelTxt.text = String(_currentLevel + 1);
					_xSpeed = 7;
					_ySpeed = -7;
					
					clearLevel();
					
				}
				
			}//end of restart
			private function changeLevel(level:Array):void{
				
				clearLevel();
				Mouse.hide();
				
				buildLevel(level);
				background_mc.addEventListener(MouseEvent.MOUSE_UP, startGame);
			
			
			}//end of changelevel
			
			private function clearLevel():void{
				
				_alertScr.removeEventListener(MouseEvent.MOUSE_UP, restart);
				removeChild(_alertScr);
				_alertScr = null;
				
				var bricksLen:int = _brickVec.length;
				
				for(var i:int = 0; i < bricksLen; i++){
					removeChild(_brickVec[i]);
				}
				
				_brickVec.length = 0;
				
				//reset ball and paddle position
				ball_mc.x = (stage.stageWidth / 2) - (ball_mc.width / 2);
				ball_mc.y = paddle_mc.y - 20;
			
				paddle_mc.x = 123.6;
				
			}//end of clear level
			
			
		
		}//end of class
	
}//end of package