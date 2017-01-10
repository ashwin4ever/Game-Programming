package{
	
		import flash.display.MovieClip;
		import flash.events.Event;
		import flash.events.KeyboardEvent;
		import flash.events.MouseEvent;
		import flash.geom.Rectangle;
		import flash.media.Sound;
		import flash.text.TextField;
		
		public class PixelShooter extends MovieClip{
		
			public static const STATE_INIT:int=10;
			public static const STATE_PLAYER:int=20;
			public static const STATE_PLAY:int=30;
			public static const STATE_REMOVE_PLAYER:int=40;
			public static const STATE_END:int=50;
			
			public var gameState:int=0;
			public var chances:int=0;
			public var score:int=0;
			
			public var bg:MovieClip;
			public var enemies:Array;
			public var explosions:Array;
			public var missiles:Array;
			public var player:MovieClip;
			public var level:Number;
			
			public var scoreLabel:TextField=new TextField();
			public var chanceLabel:TextField=new TextField();
			public var levelLabel:TextField=new TextField();
			
			public var scoreTxt:TextField=new TextField();
			public var chanceTxt:TextField=new TextField();
			public var levelTxt:TextField=new TextField();
			
			public const SCOREBOARD_Y:Number=5;
			
			public function PixelShooter(){
			
				addEventListener(Event.ENTER_FRAME,onGameLoop);
				bg=new Background();
				addChild(bg);
				
				scoreLabel.text="Score: ";
				chanceLabel.text="Ships: ";
				levelLabel.text="Level: ";
				
				scoreTxt.text="0";
				chanceTxt.text="3";
				levelTxt.text="1";
				
				scoreLabel.y=SCOREBOARD_Y;
				chanceLabel.y=SCOREBOARD_Y;
				levelLabel.y=SCOREBOARD_Y;
				
				scoreTxt.y=SCOREBOARD_Y;
				chanceTxt.y=SCOREBOARD_Y;
				levelTxt.y=SCOREBOARD_Y;
				
				scoreLabel.x=5;
				scoreTxt.x=50;
				chanceLabel.x=105;
				chanceTxt.x=155;
				levelLabel.x=205;
				levelTxt.x=255;
				
				scoreLabel.textColor=0xFF0000;
				scoreTxt.textColor=0xffffff;
				chanceLabel.textColor=0xff0000;
				chanceTxt.textColor=0xffffff;
				levelLabel.textColor=0xff0000;
				levelTxt.textColor=0xffffff;
				
				addChild(scoreLabel);
				addChild(scoreTxt);
				addChild(chanceLabel);
				addChild(chanceTxt);
				addChild(levelLabel);
				addChild(levelTxt);
				
				gameState=STATE_INIT;
				
				
			}//end of pixel shooter
			
			private function onGameLoop(e:Event):void{
				
				switch(gameState){
				
					case STATE_INIT:
						initGame();
						break;
					case STATE_PLAYER:
						startPlayer();
						break;
					case STATE_PLAY:
						playGame();
						break;
					case STATE_REMOVE_PLAYER:
						removePlayer();
						break;					
					case STATE_END:
						//gameOver();
						break;
				}
			}//end of game loop
			
			private function initGame():void{
			
				stage.addEventListener(MouseEvent.MOUSE_DOWN,onmouseDown);
				score=0;
				chances=3;
				level=1;
				levelTxt.text=level.toString();
				enemies=new Array();
				missiles=new Array();
				explosions=new Array();
				player=new Ship();
				gameState=STATE_PLAYER;
			
			}//end of init game
			
			private function startPlayer():void{
			
				addChild(player);
				player.startDrag(true,new Rectangle(0,365,550,365));
				gameState=STATE_PLAY;
			
			}//end of start player
			
			private function playGame():void{
	
				makeEnemies();
				moveEnemies();
				testCollisions();
				testEnd();
			
			}//end of play Game
			
			public function makeEnemies():void{
			
				var chance=Math.floor(Math.random()*100);
				var tmpEnemy:MovieClip;
				if(chance<2+level){
					tmpEnemy=new Alien();
					tmpEnemy.speed=1+level;
					tmpEnemy.y=-25;
					tmpEnemy.x=Math.floor(Math.random()*515);
					addChild(tmpEnemy);
					enemies.push(tmpEnemy);
				}
			
			}//end of make enemies
			
			private function moveEnemies():void{
			
				var tmpEnemy:MovieClip;
				
				for(var i:int=enemies.length-1;i>=0;i--){
					tmpEnemy=enemies[i];
					tmpEnemy.y+=tmpEnemy.speed;
					if(tmpEnemy.y>435)
						removeEnemies(i);
				}
				
				var tmpMissiles:MovieClip;
				
				for(i=missiles.length-1;i>=0;i--){
					
					tmpMissiles=missiles[i];
					tmpMissiles.y-=tmpMissiles.speed;
					if(tmpMissiles.y<-35)
						removeMissiles(i);
				}
				
				var tmpExplosion:MovieClip;
				
				for(i=explosions.length-1;i>=0;i--){
				
					tmpExplosion=explosions[i];
					if(tmpExplosion.currentFrame>=tmpExplosion.totalFrames)
						removeExplosions(i);
				}
			
			}//end of ove enemies
			
			private function removePlayer():void{
			
				for(var i:int=enemies.length-1;i>=0;i--)
					removeEnemies(i);
				
				for(i=missiles.length-1;i>=0;i--)
					removeMissiles(i);
				
				removeChild(player);
				gameState=STATE_PLAYER;
			
			
			}//end of remove player
			
			private function removeEnemies(idx:int):void{
			
				removeChild(enemies[idx]);
				enemies.splice(idx,1);
			
			}//end of remove enemies
			
			private function removeMissiles(idx:int){
			
				removeChild(missiles[idx]);
				missiles.splice(idx,1);
			
			}//end of remove missiles
			
			private function removeExplosions(idx:int){
			
				removeChild(explosions[idx]);
				explosions.splice(idx,1);
			
			}//end of remove explosions
			
			private function onmouseDown(m:MouseEvent):void{
				
				if(gameState==STATE_PLAY){
				
					var tmpMissile:MovieClip=new Bullet();
					tmpMissile.x=player.x+player.width/2;
					tmpMissile.y=player.y;
					tmpMissile.speed=5;
					missiles.push(tmpMissile);
					addChild(tmpMissile);
					var sound:Sound=new ShootSound();
					sound.play();
			
				}
			}//end of mouse down
			
			private function testCollisions():void{
			
				var tempEnemy:MovieClip;
				var tempMissile:MovieClip;
				
				enemy:for(var i=enemies.length-1;i>=0;i--){
						tempEnemy=enemies[i];
					for(var j=missiles.length-1;j>=0;j--){
						tempMissile=missiles[j];
						if(tempEnemy.hitTestObject(tempMissile)){
							score++;
							scoreTxt.text=score.toString();
							makeExplosion(tempEnemy.x,tempEnemy.y);
							removeEnemies(i);
							removeMissiles(j);
							break enemy;
						}
															  
					}
				}
				
				for(i=enemies.length-1;i>=0;i--){
					tempEnemy=enemies[i];
					if(tempEnemy.hitTestObject(player)){
						chances--;
						chanceTxt.text=chances.toString();
						makeExplosion(tempEnemy.x,tempEnemy.y);
						gameState=STATE_REMOVE_PLAYER;
					} 
				}
			
			}//end of test colllisions
			
			private function makeExplosion(ex:int,ey:int):void{
				
				var tempExplosion:MovieClip;
				tempExplosion=new Blast();
				tempExplosion.x=ex;
				tempExplosion.y=ey;
				addChild(tempExplosion);
				explosions.push(tempExplosion);
				var boom:Sound=new BoomSound();
				boom.play();
				
			}//end of make explosions
			
			private function testEnd():void{
			
				if(chances<=0){
					removePlayer();
					gameState=STATE_END;
				}
				else if(score>level*2){
					level++;
					levelTxt.text=level.toString();
				}
			
			}//end of test end
			
				
		}//end of class
	
	
}//end of package