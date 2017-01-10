package{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.text.TextField;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	public class BalloonGame extends MovieClip{
	
		const STATE_INIT:int=10;
		const STATE_PLAY:int=20;
		const STATE_END:int=30;
		
		public var gameState:int=0;
		public var score:int=0;
		public var level:int=0;
		public var chance:int=0;
		//public var speed:Number=0;
		
		public var bg:MovieClip;
		public var player:MovieClip;
		public var balloonArray:Array;
		public var sound:Sound;
		public var channel:SoundChannel;
		
		public var scoreLabel:TextField=new TextField();
		public var levelLabel:TextField=new TextField();
		public var chanceLabel:TextField=new TextField();
		
		public var scoreText:TextField=new TextField();
		public var levelText:TextField=new TextField();
		public var chanceText:TextField=new TextField();
		
		public const SCOREBOARD_Y:int=380;
		
		
		public function BalloonGame(){
		
			addEventListener(Event.ENTER_FRAME,onGameLoop);
			bg=new BackGround();
			addChild(bg);
			
			scoreLabel.text="Score: ";
			levelLabel.text="Level: ";
			chanceLabel.text="Misses: ";
			scoreText.text="0";
			levelText.text="1";
			chanceText.text="0";
			
			scoreLabel.y=SCOREBOARD_Y;
			levelLabel.y=SCOREBOARD_Y;
			chanceLabel.y=SCOREBOARD_Y;
			
			scoreText.y=SCOREBOARD_Y;
			levelText.y=SCOREBOARD_Y;
			chanceText.y=SCOREBOARD_Y;
			
			scoreLabel.x=5;
			scoreText.x=50;
			
			levelLabel.x=105;
			levelText.x=155;
			
			chanceLabel.x=205;
			chanceText.x=255;
			
			addChild(scoreLabel);
			addChild(levelLabel);
			addChild(chanceLabel);
			addChild(scoreText);
			addChild(levelText);
			addChild(chanceText);
			
			gameState=STATE_INIT;
			
			//sound==new Pop();
			//channel=new SoundChannel();
			//channel.stop();
		
		}//end of balloon game
		
		private function onGameLoop(e:Event):void{
			
			switch(gameState){
				
				case STATE_INIT:
					initGame();
					break;
				case STATE_PLAY:
					playGame();
					break;
				case STATE_END:
					gameOver();
					break;
			}
			
		}//end of game loop
		
		private function initGame():void{
			
			score=0;
			level=1;
			chance=0;
			levelText.text=level.toString();
			
			player=new Player();
			addChild(player);
			player.startDrag(true,new Rectangle(0,0,550,400));
			Mouse.hide();
			balloonArray=new Array();
			
			gameState=STATE_PLAY;
			
			
		}//end of on init game
		
		private function playGame():void{
			
			player.rotation+=15;
			makeBalloons();
			moveBalloons();
			testCollisions();
			testEnd();
			
		}//end of play game
		
		private function makeBalloons():void{
		
			var trial:Number=Math.floor(Math.random()*100);
			if(trial<2+level){
				var tempBalloon:MovieClip;
				tempBalloon=new Enemy();
				tempBalloon.speed=3+level;
				tempBalloon.gotoAndStop(Math.floor(Math.random()*5)+1);
				tempBalloon.y=435;
				tempBalloon.x=Math.floor(Math.random()*514);
				addChild(tempBalloon);
				balloonArray.push(tempBalloon);
				
			}
		}//end of make balloons
		
		private function moveBalloons():void{
		
			var tmp:MovieClip=new MovieClip();
			for(var i:int=balloonArray.length-1;i>=0;i--){
		
				tmp=balloonArray[i];
				tmp.y-=balloonArray[i].speed;
				
				if(tmp.y<-35){
					chance++;
					chanceText.text=chance.toString();
					balloonArray.splice(i,1);
					removeChild(tmp);
				}
			}
		
		}//end of move balloons
		
		private function testCollisions():void{
			
			var sound:Sound=new Pop();
			var temp:MovieClip;
			for(var i:int=balloonArray.length-1;i>=0;i--){
				temp=balloonArray[i];
				if(temp.hitTestObject(player)){
					score++;
					scoreText.text=score.toString();
					sound.play();
					balloonArray.splice(i,1);
					removeChild(temp);
				}
		}
	}//end of test collisions
	
		private function testEnd():void{
			
			if(chance>=5){
				gameState=STATE_END;
			}
			else if(score>level*10){
				level++;
				levelText.text=level.toString();
				
			}
			
		}//end of test end
		
		private function gameOver():void{
			
			for(var i:uint=0;i<balloonArray.length;i++){
				removeChild(balloonArray[i]);
				balloonArray=[];
			}
			player.stopDrag();
			
		}//end of game over
			
	}//end of class
	
}//end of package