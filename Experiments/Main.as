package{
	
		import flash.display.Sprite;
		import flash.utils.Timer;
		import flash.events.Event;
		import flash.events.MouseEvent;
		import flash.events.TimerEvent;
		
		public class Main extends Sprite{
			
			private var clockArray:Array = [15,13,11,9,7,5,3,1];
			private var top:Array = [];
			private var container:Sprite = new Sprite();
			private var containerCopy:Sprite = new Sprite();
			private var timer:Timer = new Timer(1000);
			private var counter:int = 0;
			
			public function Main(){
			
				start_btn.addEventListener(MouseEvent.MOUSE_UP,buildClock);
				start_btn.buttonMode = true;
				//trace(clockArray[0].length);
			
			}//end of function
			
			private function buildClock(m:MouseEvent):void{
			
				start_btn.removeEventListener(MouseEvent.MOUSE_UP,buildClock);
				start_btn.enabled = true;
				
				var clockLen:int = clockArray.length;
				
				for(var i:int =0;i < clockLen; i++){
					
					for(var j:int = 0;j < clockArray[i]; j++){
						trace("j: "+j);
						trace("i: "+i);
						var s:Square = new Square();
						var s_copy:Square = new Square();
						
						s.x = 70 + (s.width * j) + (1*j) + (i * (s.width + 1)); /*+ (i * (s.width + 1))*/;
						s.y = 84.5 + (s.height + 1) * i;
						trace("sx: "+s.x);
						trace("sy: "+s.y);
						s_copy.x = s.x;
						s_copy.y = s.y;
						
						/*if(i >= 5){
							s.x = 70.5 + (s.width * j) + (1*j) + (i * (s.width + 1)) + (s.width * 2 - 4);
							s_copy.x = s.x;
						}*/
						
						container.addChild(s);
						containerCopy.addChild(s_copy);
						
						top.push(s);
						s_copy.alpha = 0.2;
						
					}//end of for j
					
					addChild(container);
					containerCopy.x = 294;
					containerCopy.y = 333;
					containerCopy.rotation = 180;
					addChild(containerCopy);
				
				}//end of for i
				
				timer.addEventListener(TimerEvent.TIMER,startClock);
				timer.start();
			
			}//end of build clock
			
			private function startClock(t:TimerEvent):void{
			
				container.getChildAt(counter).alpha = 0.2;
				containerCopy.getChildAt(counter).alpha = 1;
				counter++;
				
				if(counter >= 63){
					timer.stop();
					timer.removeEventListener(TimerEvent.TIMER,startClock);
				}
			
			}//end of start Clock
			
		}//end of class main
	
}//end of package