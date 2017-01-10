package{
	
		import flash.display.Sprite;
		import flash.geom.Point;
		import flash.utils.Timer;
		import flash.events.TimerEvent;
		import flash.events.MouseEvent;
		
		public class PathFinding extends Sprite{
			
			private var _canvas:Sprite;
			private var _startPoint:Point;
			private var _endPoint:Point;
			private var _currPoint:Point;
			private var _tileVector:Vector.<Object>;
			private var _path:Vector.<Point>;
			private var _timer:Timer;
			
			public function PathFinding(){
				
				_canvas = new Sprite();
				addChild(_canvas);
				fieldSetup();
				drawGrid();
				//findPath();
				stage.addEventListener(MouseEvent.CLICK, addWall);
				
			}//end of pathfinding
			
			private function fieldSetup():void{
				
				_timer = new Timer(1000);
				_canvas.graphics.clear();
				_tileVector = new Vector.<Object>();
				
				for(var i:Number = 0; i < 16; i++){
					
					_tileVector[i] = new Vector.<Object>();
					
					for(var j :Number = 0; j < 12; j++){
						
						_tileVector[i][j] = new Object();
						_tileVector[i][j].walkAble = true;
						_tileVector[i][j].startPoint = false;
						_tileVector[i][j].endPoint = false;
						_tileVector[i][j].visited = false;
						
					}//end of for j
				}//end of for i
				
				//add a random start point
				//_startPoint = new Point(Math.floor(Math.random() * 16), Math.floor(Math.random() * 12));
				_startPoint = new Point(10 , 0);
				_tileVector[_startPoint.x][_startPoint.y].startPoint = true;
				_tileVector[_startPoint.x][_startPoint.y].visited = true;
				
				//add a random endpoint 10 tiles away from start tile
				/*do{
					_endPoint = new Point(Math.floor(Math.random() * 16), Math.floor(Math.random() * 12));
					
				}while(manhattanDist(_startPoint, _endPoint) < 10 );*/
				_endPoint = new Point(12, 0);
				_tileVector[_endPoint.x][_endPoint.y].endPoint = true;
				
				trace(_endPoint);
			}//end of function fieldsetup
			
			private function findPath():void{
				
				_path = new Vector.<Point>();
				_path.push(_startPoint);
				
				for(var i:Number = 0; i < 16; i++){
					for(var j:Number = 0; j < 12; j++){
						_tileVector[i][j].visited = false;
					}//end of for j
				}//end of for i
				
				_currPoint = new Point(_startPoint.x, _startPoint.y);
				_timer.addEventListener(TimerEvent.TIMER, step);
				_timer.start();
				
			}//end of function findpath
			
			private function step(t:TimerEvent):void{
			
				var minF:Number = 10000;
				
				var savedPoint:Point;
				
				//check for directions : No diagonals
				for(var i:Number = -1; i <= 1; i++){
				
					for(var j:Number = -1; j <= 1; j++){
						//check movment of tiles... No diagonals at this time
						
						if((i != 0 && j == 0) || (i == 0 && j != 0)){
							//trace(" i: "+i + " j: "+j);
							//trace("before loop : " +_currPoint);
							//trace("before visited: " +_tileVector[_currPoint.x + i][_currPoint.y + j].visted);
							if(insideField(_currPoint, i, j) && !_tileVector[_currPoint.x + i][_currPoint.y + j].visited && _tileVector[_currPoint.x + i][_currPoint.y + j].walkAble){
								//trace("inside");
								//trace("cpx + i: " + (_currPoint.x + i) + " cpy + j: "+ (_currPoint.y + j));
								//trace("\ninside i : " +i + " j: " +j);
								var g:Number = getG(i, j);
								
								//find dist between current point and end point
								var h:Number = manhattanDist(new Point(_currPoint.x + i, _currPoint.y + j), _endPoint);
								
								var f:Number = g + h;
								//trace("h: " + h + " f: "+f);
								//trace("dist: " +f + " minf: " +minF);
								if(f <= minF){
									minF = f;
									savedPoint = new Point(_currPoint.x + i, _currPoint.y + j);
								}//end of if
								
							}//end of if
							
						}//end of if
						
					}//end of for j
				
				}//end of for i
				
				if(savedPoint){
					
					//trace("saved point: " + savedPoint + " current point: "  + _currPoint + " end point: " + _endPoint);
					if(savedPoint.x != _endPoint.x || savedPoint.y != _endPoint.y){
						//trace("not found yet");
						drawTile(savedPoint.x, savedPoint.y, 0x0000ff)
						//0x0000ff blue color current position
					}
					_tileVector[savedPoint.x][savedPoint.y].visited = true;
					_currPoint = savedPoint;
					_path.push(_currPoint);
					
					if(_path.length > 2){
						drawTile(_path[_path.length - 2].x, _path[_path.length - 2].y, 0xcccccc);
					}
					//trace("\n cp: "+ _currPoint);
					//solved
					if(_currPoint.x == _endPoint.x && _currPoint.y == _endPoint.y){
						//trace("solved");
						_timer.removeEventListener(TimerEvent.TIMER, step);
					}
					
				}
				else{
					//trace("cp: "+_currPoint);
					if(_path.length > 1){
						_currPoint = _path[_path.length - 2];
						
						drawTile(_path[_path.length - 1].x, _path[_path.length - 1].y, 0xffffff);
						_path.pop();
					}
					else{
						//un solvable
						drawTile(_currPoint.x, _currPoint.y , 0xff00ff);
						_timer.removeEventListener(TimerEvent.TIMER, step);
					}
				}
			
			}//end of step
			
		
		
		private function getG(n1:Number, n2:Number):Number{
			return 1;
		}//end of getG
		
		private function manhattanDist(p1:Point, p2:Point):Number{
			return Math.abs(p1.x - p2.x) + Math.abs(p1.y - p2.y);
		}//end of manhattan dist
		
		private function insideField(p:Point, n1:Number, n2:Number):Boolean{
			if(p.x + n1 > 15 || p.x + n1 < 0 || p.y + n2 > 11 || p.y + n2 < 0){
				return false;
			}
			return true;
		}//end of insideField
		
		private function addWall(m:MouseEvent):void{
		
			var row:Number = Math.floor(mouseY / 40);
			var col:Number = Math.floor(mouseX / 40);
			
			trace("rowWall: " +row + " colWall: " + col); 
			
			if(!_tileVector[col][row].startPoint && !_tileVector[col][row].endPoint){
				_tileVector[col][row].walkAble =! _tileVector[col][row].walkAble;
			}
			else{
				//if wall is on either end tile or start tile restart
				_timer.removeEventListener(TimerEvent.TIMER, step);
				fieldSetup();
			}
			drawGrid();
			findPath();
		
		}//end of addwall
		
		private function drawTile(px:Number, py:Number, color:Number):void{
			
			//_canvas.graphics.clear();
			_canvas.graphics.beginFill(color, 1);
			_canvas.graphics.drawRect(px * 40, py * 40, 40, 40);
			_canvas.graphics.endFill();
			
		}//end of drawTile
		
		private function drawGrid():void{
			
			_canvas.graphics.clear();
			_canvas.graphics.lineStyle(1,0x999999);
			
			for(var i:Number = 0; i < 16; i++){
				for(var j:Number = 0; j < 12; j++){
					drawTile(i, j, 0xffffff);
					
					if(_tileVector[i][j].walkAble == false){
						drawTile(i, j, 0x000000);
					}
					if(_tileVector[i][j].startPoint == true){
						drawTile(i, j, 0x00ff00);
					}
					if(_tileVector[i][j].endPoint == true){
						drawTile(i, j, 0xff0000);
					}
				}
			}
			
		}//end of drawGrid
	}//end of class pathfinding
	
}//end of package
/*package {
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.events.MouseEvent;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    public class PathFinding extends Sprite {
        private var canvas:Sprite;
        private var startPoint:Point;
        private var endPoint:Point;
        private var currPoint:Point;
        private var tileVector:Vector.<Object>;
        private var path:Vector.<Point>;
        private var timer:Timer;
        public function Main() {
            canvas=new Sprite();
            addChild(canvas);
            fieldSetup();
            drawGrid();
            findPath();
            stage.addEventListener(MouseEvent.CLICK,addWall);
        }
        // fieldSetup prepares the field. Each tile in the field is set to its default value:
        // * it's walkable
        // * it's not the start point
        // * it's not the end point
        // * it has not been visited
        private function fieldSetup():void {
            timer=new Timer(100);
            canvas.graphics.clear();
            tileVector=new Vector.<Object>();
            for (var i:Number=0; i<16; i++) {
                tileVector[i]=new Vector.<Object>();
                for (var j:Number=0; j<12; j++) {
                    tileVector[i][j]=new Object();
                    tileVector[i][j].walkable=true;
                    tileVector[i][j].startPoint=false;
                    tileVector[i][j].endPoint=false;
                    tileVector[i][j].visited=false;
                }
            }
            // while the starting point is choosen absolutely random...
            startPoint=new Point(Math.floor(Math.random()*16),Math.floor(Math.random()*12));
            tileVector[startPoint.x][startPoint.y].startPoint=true;
            tileVector[startPoint.x][startPoint.y].visited=true;
            // ... we want the end point to be at least 10 tiles away from start point.
            // jsut to make things interesting
            do {
                endPoint=new Point(Math.floor(Math.random()*16),Math.floor(Math.random()*12));
            } while (manhattan(startPoint,endPoint)<10);
            tileVector[endPoint.x][endPoint.y].endPoint=true;
        }
        // findPath function initializes the field and sets the time listener to draw the path
        private function findPath():void {
            path=new Vector.<Point>();
            path.push(startPoint);
            for (var i:Number=0; i<16; i++) {
                for (var j:Number=0; j<12; j++) {
                    tileVector[i][j].visited=false;
                }
            }
            currPoint=new Point(startPoint.x,startPoint.y);
            timer.addEventListener(TimerEvent.TIMER,step);
            timer.start();
        }
        // step is the core function. Let's explain it deeply
        private function step(e:TimerEvent):void {
            // f will be the variable which minimum value will decide which direction to take.
            // I created a minF variable with an high value to store the minimum f value found
            var minF:Number=10000;
            // initializing a temporary Point variable
            var savedPoint:Point;
            for (var i:Number=-1; i<=1; i++) {
                for (var j:Number=-1; j<=1; j++) {
                    // these two for loops together with this if statement will scan for all four directions. No diagonals at the moment.
                    if ((i!=0 && j==0)||(i==0 && j!=0)) {
                        // we consider a tile only if:
                        // * is inside the tile field
                        // * is walkable (not a wall)
                        // * has not been already visited
                        if (insideField(currPoint,i,j) && tileVector[currPoint.x+i][currPoint.y+j].walkable && !tileVector[currPoint.x+i][currPoint.y+j].visited) {
                            // now, core of the loop: let's determine g, h and f
                            // g represents the cost to move from the starting tile to the current tile. At the moment we aren't using this variable
                            // so getG function will always return 1
                            var g:Number=getG(i,j);
                            // h is the presumable distance from the current tile and the ending tile. One of the quickest way to determine it is
                            // using manhattan distance
                            var h:Number=manhattan(new Point(currPoint.x+i,currPoint.y+j),endPoint);
                            // f is just the sum of g and h
                            var f:Number=g+h;
                            // if the current f value is lower than the minimum f value found so far...
                            if (f<minF) {
                                // ... we update minF value and we save the current tile
                                minF=f;
                                savedPoint=new Point(currPoint.x+i,currPoint.y+j);
                            }
                        }
 
                    }
                }
            }
            // once all neighbor tiles have been scanned, we can have two situations:
            // * we found a candidate (savedPoint) for the next tile, and we continue the process
            // * we did not found a candidate, so we are on a dead end and we must backtrack
            if (savedPoint) {
                // continue...
                if (savedPoint.x!=endPoint.x||savedPoint.y!=endPoint.y) {
                    drawTile(savedPoint.x,savedPoint.y,0x0000ff);
                }
                tileVector[savedPoint.x][savedPoint.y].visited=true;
                currPoint=savedPoint;
                path.push(currPoint);
                if (path.length>2) {
                    drawTile(path[path.length-2].x,path[path.length-2].y,0xcccccc);
                }
                if (currPoint.x==endPoint.x&&currPoint.y==endPoint.y) {
                    // solved
                    timer.removeEventListener(TimerEvent.TIMER,step);
                }
            }
            else {
                // backtrack
                if (path.length>1) {
                    currPoint=path[path.length-2];
                    drawTile(path[path.length-1].x,path[path.length-1].y,0xffffff);
                    path.pop();
                }
                else {
                    // can't be solved
                    drawTile(currPoint.x,currPoint.y,0xff00ff);
                    timer.removeEventListener(TimerEvent.TIMER,step);
                }
            }
        }
        // getG function will become really important during next steps, but at the moment just returns 1
        private function getG(n1:Number,n2:Number) {
            return 1;
        }
        // function to find manhattan distance between two points
        private function manhattan(p1:Point,p2:Point):Number {
            return Math.abs(p1.x-p2.x)+Math.abs(p1.y-p2.y);
        }
        // insideField checks if a given point inside the field will remain inside the field after adding a x and y offset
        private function insideField(p:Point,n1:Number,n2:Number):Boolean {
            if (p.x+n1>15||p.x+n1<0||p.y+n2>11||p.y+n2<0) {
                return false;
            }
            return true;
        }
        // function to add/remove a wall or generate another random grid
        private function addWall(e:MouseEvent):void {
            var row:Number=Math.floor(mouseY/40);
            var col:Number=Math.floor(mouseX/40);
            if (! tileVector[col][row].startPoint&&! tileVector[col][row].endPoint) {
                tileVector[col][row].walkable=! tileVector[col][row].walkable;
            }
            else {
                timer.removeEventListener(TimerEvent.TIMER,step);
                fieldSetup();
            }
            drawGrid();
            findPath();
        }
        // drawTile function just draws a tile in a given position with a given color
        private function drawTile(pX:Number,pY:Number,color:Number):void {
            canvas.graphics.beginFill(color,1);
            canvas.graphics.drawRect(pX*40,pY*40,40,40);
            canvas.graphics.endFill();
        }
        // function to draw the entire grid;
        private function drawGrid() {
            //canvas.graphics.clear();
            canvas.graphics.lineStyle(1,0x999999);
            for (var i:Number=0; i<16; i++) {
                for (var j:Number=0; j<12; j++) {
                    drawTile(i,j,0xffffff);
                    if (tileVector[i][j].walkable==false) {
                        drawTile(i,j,0x000000);
                    }
                    if (tileVector[i][j].startPoint==true) {
                        drawTile(i,j,0x00ff00);
                    }
                    if (tileVector[i][j].endPoint==true) {
                        drawTile(i,j,0xff0000);
                    }
                }
            }
        }
    }
}*/