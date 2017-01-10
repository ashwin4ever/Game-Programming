package{
	
		import flash.display.Sprite;
		import flash.events.MouseEvent;
		import flash.display.MovieClip;
		import flash.ui.Mouse;
		import com.greensock.*;
		import com.greensock.easing.*;
		
		
		public class Game extends Sprite{
			
			//1 for X and 0 for o
			private var _turn:Number;
			
			//1 for X and -1 for o
			private var _playerShape:Number;
			
			//1 for single player and 2 for ywo players
			private var _playerCount:Number;
			
			private var _gameBoardVec:Vector.<Object>;
			
			private var _skill:Number;
			private var _moveCount:Number;
			private var _board:Array;
			
			private var _move:MovieClip;
			
			private var _value:Number;
			private var _bestValue:Number;
			
			private const MAX:Number = 100;
			private const MIN:Number = -100;
			private var bestMove:MovieClip = new MovieClip()
			
		
		
			public function Game(){
				
				init();
				
			}//end of game
			
			private function init():void{
				
				btn3_mc.enabled = false;
				btn3_mc.visible = false;
				
				_bestValue = 0;
				_value = 0;
				
				btn1_mc.buttonMode = true;
				btn1_mc.mouseChildren = false;
				
				btn2_mc.buttonMode = true;
				btn2_mc.mouseChildren = false;
				
				board_mc.visible = false;
				
				btn1_mc.myText_txt.text = "1 player";
				btn2_mc.myText_txt.text = "2 players";
				
				_board = [];
				_move = new MovieClip();
				
				_gameBoardVec = new Vector.<Object>();
				feedback_txt.text = "Choose Single or Double Player";
				
				for(var i:Number = 0; i < 3; i++){
					_gameBoardVec[i] = new Vector.<Object>();
					for(var j:Number = 0; j < 3; j++){
						_gameBoardVec[i][j] = new Object();
						_gameBoardVec[i][j] = board_mc.getChildByName("b"+i+j+"_mc");
						_gameBoardVec[i][j].nRow = i;
						_gameBoardVec[i][j].nCol = j;
						//trace(_gameBoardVec[i][j]);
						//_gameBoardVec[i][j].name = "b"+i+j+"_mc";
						_gameBoardVec[i][j].x_mc.visible = false;
						_gameBoardVec[i][j].o_mc.visible = false;
						//_gameBoardVec[i][j].addEventListener(MouseEvent.MOUSE_UP, onMakeMove);
					}
				}
				
				btn1_mc.addEventListener(MouseEvent.MOUSE_UP, onSelectFirstPlayer);
				btn2_mc.addEventListener(MouseEvent.MOUSE_UP, startDoublePlayerGame);
				
			}//end of init
			
			private function onSelectFirstPlayer(m:MouseEvent):void{
				board_mc.visible = false;
				btn1_mc.myText_txt.text = "X";
				btn2_mc.myText_txt.text = "O";
				feedback_txt.text = "Choose X or 0";
				
				
				btn1_mc.removeEventListener(MouseEvent.MOUSE_UP, onSelectFirstPlayer);
				btn2_mc.removeEventListener(MouseEvent.MOUSE_UP, startDoublePlayerGame);
				
				btn1_mc.addEventListener(MouseEvent.MOUSE_UP, checkShape);
				btn2_mc.addEventListener(MouseEvent.MOUSE_UP, checkShape);
				
				trace(m.target.name);
				
			}//end of select first player
			
			private function checkShape(m:MouseEvent):void{
				
				if(m.target.name == "btn1_mc"){
					//trace(m.target.name);
					firstPlayerSelected(1);
				}
				else if(m.target.name == "btn2_mc"){
					//trace(m.target.name);
					firstPlayerSelected(-1);
				}
				
			}//end of check shape
			
			private function firstPlayerSelected(n:Number):void{
				
				_playerShape = n;
				btn1_mc.removeEventListener(MouseEvent.MOUSE_UP, checkShape);
				btn2_mc.removeEventListener(MouseEvent.MOUSE_UP, checkShape);
				
				btn3_mc.visible = true;
				btn3_mc.mouseChildren = false;
				btn3_mc.buttonMode = true;
				btn3_mc.enabled = true;
				
				btn1_mc.myText_txt.text = "Skill 1";
				btn2_mc.myText_txt.text = "Skill 2";
				btn3_mc.myText_txt.text = "Skill 3";
				
				feedback_txt.text = "Choose Skill";
				
				btn1_mc.addEventListener(MouseEvent.MOUSE_UP, selectSkill);
				btn2_mc.addEventListener(MouseEvent.MOUSE_UP, selectSkill);
				btn3_mc.addEventListener(MouseEvent.MOUSE_UP, selectSkill);
				
				
			}//end of first player selected
			
			private function selectSkill(m:MouseEvent):void{
				
				if(m.target.name == "btn1_mc"){
					//trace(m.target.name);
					skillSelected(1);
				}
				else if(m.target.name == "btn2_mc"){
					//trace(m.target.name);
					skillSelected(2);
				}
				else if(m.target.name == "btn3_mc"){
					//trace(m.target.name);
					skillSelected(3);
				}
				
			}//end of select skill
			
			private function skillSelected(n:Number):void{
				
				_skill = n
				trace(_skill);
				
				btn1_mc.removeEventListener(MouseEvent.MOUSE_UP, selectSkill);
				btn2_mc.removeEventListener(MouseEvent.MOUSE_UP, selectSkill);
				btn3_mc.removeEventListener(MouseEvent.MOUSE_UP, selectSkill);
				
				btn3_mc.enabled = false;
				btn3_mc.visible = false;
				
				//btn1_mc.addEventListener(MouseEvent.MOUSE_UP, onSelectFirstPlayer);
				//btn2_mc.addEventListener(MouseEvent.MOUSE_UP, onStart2Player);
				
				btn1_mc.myText_txt.text = "1 player";
				btn2_mc.myText_txt.text = "2 players";
				
				startSinglePlayerGame();
				
				
			}//end of skillSelected
			
			private function startSinglePlayerGame():void{
				feedback_txt.text = "";
				_playerCount = 1;
				startGame();
				
			}//end of startSinglePlayerGame
			
			private function startDoublePlayerGame(m:MouseEvent):void{
				
				feedback_txt.text = "";
				_playerCount = 2;
				_playerShape = 1;  //1 for X
				startGame();
			}//end of startDoublePlayerGame
			
			private function startGame():void{
				
				_turn = 1;
				board_mc.visible = true;
				
				_board = [[0, 0, 0], [0, 0, 0], [0, 0, 0]];
				_moveCount = 0;
				
				for(var i:Number = 0; i < 3; i++){
					for(var j:Number = 0; j < 3; j++){
						//trace(_gameBoardVec[i][j].name);
						//var b:MovieClip = _gameBoardVec[i][j];
						//trace(b.name);
						//_gameBoardVec[i][j].x_mc.visible = true;
						//board_mc.b00_mc.visible
						//_gameBoardVec[i][j].visible = true;
						//board_mc.b00_mc.addEventListener(MouseEvent.MOUSE_UP, onMakeMove);
						_gameBoardVec[i][j].addEventListener(MouseEvent.MOUSE_UP, onMakeMove);
						//_gameBoardVec[i][j].addEventListener(MouseEvent.MOUSE_UP, onMakeMove);
						_gameBoardVec[i][j].x_mc.visible = true;
						_gameBoardVec[i][j].o_mc.visible = true;
						
						_gameBoardVec[i][j].x_mc.alpha = 0;
						_gameBoardVec[i][j].o_mc.alpha = 0;
						//board_mc.b.visible = true;
						//board_mc._gameBoardVec[i][j].visible = true;
					}
				}
				
				//set win bar invisible
				for(i = 1; i < 9; i++)
					board_mc.getChildByName("bar"+i+"_mc").visible = false;
					
				//check if computer plays first
				if(_playerCount == 1 && _playerShape == -1)
					makeComputerMove();
				
			}//end of startgame
			private function onMakeMove(m:MouseEvent):void{
				//trace("make move");
				//trace(_playerCount);
				if(_playerShape == 1){
					trace(m.currentTarget.name);
					makeXMove(m.currentTarget as MovieClip);
				}
					
				if(_playerShape == -1){
					trace(m.currentTarget.name);
					makeOMove(m.currentTarget as MovieClip);
				}
					
				if(_playerCount == 1){
					makeComputerMove();
				}
				else{
					_turn = -_turn;
					_playerShape = -_playerShape;
				}
				
			}//end of on make move
			

			
			private function makeComputerMove():void{
				
				
				/*for(var i:int = 0; i < 3 ; i++)
					for(var j:int = 0; j < 3 ; j++)
						trace("pc move board: " +i + j + "  " + _board[i][j]);*/
				
				if(_skill == 1){
					
					do{
						var rr:Number = getRandom(0 , 2);
						var rc:Number = getRandom(0 , 2);
					}while(_board[rr][rc] != 0)
					_move = _gameBoardVec[rr][rc];
				}
				
				
				else if(_skill == 2){
					if(_board[1][1] == 0)
						_move = _gameBoardVec[1][1];
						
					else if(_board[0][0] == 0)
						_move = _gameBoardVec[0][0];
					
					else if(_board[2][2] == 0)
						_move = _gameBoardVec[2][2];
					
					else if(_board[0][2]==0) 
						_move = _gameBoardVec[0][2];
					
					else if(_board[2][0]==0) 
						_move = _gameBoardVec[2][0];
						
					else if(_board[1][0]==0) 
						_move = _gameBoardVec[1][0];
						
					else if(_board[0][1]==0) 
						_move = _gameBoardVec[0][1];
						
					else if(_board[2][1]==0) 
						_move = _gameBoardVec[2][1];
						
					else if(_board[1][2]==0) 
						_move = _gameBoardVec[1][2];
				}
				
				else if(_skill == 3)
					_move = findGoodMove();
				
				trace("computer move: " +_move);
				executeComputerMove(_move);
				
			}//end of make computer move
			
			private function executeComputerMove(m:MovieClip):void{
				//trace("exec pc move m: " +m.getChildByName("o_mc"));
				if(_playerShape == 1)
					makeOMove(m);
				else if(_playerShape == -1)
					makeXMove(m);
				
			}//end of execute computer move
			
			private function findGoodMove():MovieClip{
				
				//trace("inside find good move");
				//trace("find good move move count: " +_moveCount);
				if(_moveCount == 0){
					return _gameBoardVec[1][1];
				}
				else if(_moveCount == 1){
					if(!_board[1][1]){
						//trace(_gameBoardVec[1][1].name);
						//trace(_gameBoardVec[1][1].numChildren);
						return _gameBoardVec[1][1];
					}
					else
						return _gameBoardVec[0][0];
				}
				else if(_moveCount == 2){
					if(_board[0][0])
						return _gameBoardVec[2][2];
					if(_board[2][0])
						return _gameBoardVec[0][2];
					if(_board[2][2])
						return _gameBoardVec[0][0];
					if(_board[0][2])
						return _gameBoardVec[2][0];
					if(_board[0][1] || _board[1][0])
						return _gameBoardVec[2][0];
					if(_board[1][2] || _board[2][1])
						return _gameBoardVec[0][0];
				}
				
				else
					return minMax();
				return new MovieClip();
				 
			}//end of find good move
			
			private function makeXMove( mc:MovieClip):void{
				//trace(" x mc: "+mc);
				//trace("human move count: " +_moveCount);
				_moveCount++;
				//mc.x_mc.visible = true;
				mc.x_mc.alpha = 100;
				mc.removeEventListener(MouseEvent.MOUSE_UP, onMakeMove);
				
				_board[mc.nRow][mc.nCol] = 1;
				stopGame(checkWin());
				
				if(_playerShape == 0 && _turn == 0 && _playerCount == 0){
					restart();
				}
				
			}//make x move
			
			private function makeOMove(mc:MovieClip):void{
				
				//trace("pc move count: " +_moveCount);
				_moveCount++;
				
				trace("make o move mc: " +mc.name);
				//mc.o_mc.visible = true;
				mc.o_mc.alpha = 100;
				mc.removeEventListener(MouseEvent.MOUSE_UP, onMakeMove);
				trace("O row: " +mc.nRow + " O col: " + mc.nCol);
				_board[mc.nRow][mc.nCol] = -1;
				stopGame(checkWin());
				
				if(_playerShape == 0 && _turn == 0 && _playerCount == 0){
					restart();
				}
				
			}//end of makeOmove
			
			private function minMax():MovieClip{
				//trace("calling minmax");
				outputBoard();
				
				var prune:Boolean = false;
				_bestValue = 0;
				for(var i:int = 0; i < 3 && !prune; i++){
					for(var j:int = 0; j < 3 && !prune; j++){
						//trace(_board[i][j]);
						if(_board[i][j] == 0){
							
							var curMove:MovieClip = new MovieClip();
							
							if(_moveCount % 2 == 0)
								_board[i][j] = 1;
							else
								_board[i][j] = -1;
							
							_moveCount++;
							//trace("inside minmax move count: " +_moveCount);
							
							var hasWon:int = checkWin();
							//check who has won 1 for X and -1 for O and zero for tie
							//trace("inside minmax haswon: " +hasWon);
							if(hasWon == 1){
								curMove = _gameBoardVec[i][j];
								//_board[i][j] = 1;
								//curMove.nRow = i;
								//curMove.nCol = j;
								//trace("minmax curmove: " +curMove.name);
								_value = 100;
							}
							else if(hasWon == -1){
								//trace(i +" " +j);
								curMove = _gameBoardVec[i][j];
								//curMove.nRow = i;
								//curMove.nCol = j;
								//trace("minmax curmove: " +curMove.name);
								_value = -100;
							}
							else if(_moveCount == 9){
								curMove = _gameBoardVec[i][j];
								//_board[i][j] = 0;
								//curMove.nRow = i;
								//curMove.nCol = j;
								//trace("minmax curmove: " +curMove.name);
								_value = 0;
							}
							
							else{
								curMove = minMax();
							}
							//trace("value: " +_value);
							//trace("cur move: "+curMove.name);
							//trace("i: " +i +" j: " +j);
							//curMove.nRow = i;
							//curMove.nCol = j;
							_moveCount--;
							_board[i][j] = 0;
							curMove.nRow = i;
							curMove.nCol = j;
							//prune = true;
							//trace("inside min max move count: " +_moveCount);
							//trace("best value: " +_bestValue);
							//trace("min max best move: " + bestMove.name);
							if(_moveCount % 2 == 0){
								if(_value >= _bestValue){
									_bestValue = _value;
									bestMove = curMove as MovieClip;
									//trace(curMove.name)
									//curMove.nRow = i;
									//curMove.nCol = j;
									if(_bestValue == MAX)
										prune = true;
								}
							}
							else{
								if(_value <= _bestValue){
									_bestValue = _value;
									bestMove = curMove as MovieClip;
									//trace(curMove.name)
									//curMove.nRow = i;
									//curMove.nCol = j;
									if(_bestValue == MIN)
										prune = true;
								}
							}
							
						}//end of if
						
					}//end of for j
					
				}//end of for i
				//_bestValue = _value;
				//_value = 0;
				//curMove.nRow = i;
				//curMove.nCol = j;
				//trace("best move: " +bestMove.name);
				//_moveCount--;
				return bestMove;
				
			}//end of min max
			private function outputBoard():void{
				trace('depth: '+_moveCount);
				for(var i=0;i<3;++i){
					var mystring = "";
					for(var j=0;j<3;++j){
						if(_board[i][j]==1) mystring += 'X';
						else if(_board[i][j]==-1) mystring += 'O';
						else mystring += ' ';
					}
				trace(mystring);
				}
			}//end of outputboard
			
		private function checkWin():Number{
			
			/*for(var i:int = 0; i < 3 ; ++i){
					for(var j:int = 0; j < 3 ; ++j){
						trace("board: " +i + j + "  " + _board[i][j]);
					}
			}*/
			
				if(_board[0][0]){
					if(_board[0][0] == _board[0][1] && _board[0][1] == _board[0][2])
						return _board[0][0];
					
					if(_board[0][0] == _board[1][0] && _board[1][0] == _board[2][0])
						return _board[0][0];
					
					if(_board[0][0] == _board[1][1] && _board[1][1] == _board[2][2])
						return _board[0][0];
				}
				
				if(_board[1][1]){
					trace("board 11 " +_board[1][1]);
					
					if(_board[1][0] == _board[1][1] && _board[1][1] == _board[1][2])
						return _board[1][1];
					if(_board[0][1] == _board[1][1] && _board[1][1] == _board[2][1])
						return _board[1][1];
					if(_board[0][2] == _board[1][1] && _board[1][1] == _board[2][0])
						return _board[1][1];
				}
				
				if(_board[2][2]){
					if(_board[2][0] == _board[2][1] && _board[2][1] == _board[2][2])
               			return _board[2][0];
          			if(_board[0][2] == _board[1][2] && _board[1][2] == _board[2][2])
               			return _board[0][2];
				}
				
				if(_moveCount == 9)
					return 0;
				
				return -99;
			
			}//end of check win
			
			private function stopGame(winner:Number):void{
				trace("Stop game");
				trace("winner : " + winner);
				switch(winner){
					
					case -99:
						return;
					case 0:
						feedback_txt.text = "Tie Game";
						break;
					case 1:
						feedback_txt.text = "X wins";
						break;
					case -1:
						feedback_txt.text = "O wins";
						break;
				}
				_playerCount = _turn = _playerShape = 0;
				
				if(Math.abs(_board[0][0]+_board[0][1]+_board[0][2]) == 3)
          			board_mc.bar4_mc.visible=true;
     				
				if(Math.abs(_board[1][0]+_board[1][1]+_board[1][2]) == 3)
          			board_mc.bar5_mc.visible=true;
     				
				if(Math.abs(_board[2][0]+_board[2][1]+_board[2][2]) == 3)
         			board_mc.bar6_mc.visible=true;
     				
				if(Math.abs(_board[0][0]+_board[1][0]+_board[2][0]) == 3)
          			board_mc.bar1_mc.visible=true;
     				
				if(Math.abs(_board[0][1]+_board[1][1]+_board[2][1]) == 3)
          			board_mc.bar2_mc.visible=true;
     				
				if(Math.abs(_board[0][2]+_board[1][2]+_board[2][2]) == 3)
          			board_mc.bar3_mc.visible=true;
     				
				if(Math.abs(_board[0][0]+_board[1][1]+_board[2][2]) == 3)
          			board_mc.bar8_mc.visible=true;
     				
				if(Math.abs(_board[0][2]+_board[1][1]+_board[2][0]) == 3)
          			board_mc.bar7_mc.visible=true;
				
			}//end of stop game
			
			private function restart():void{
				
				btn1_mc.addEventListener(MouseEvent.MOUSE_UP, onSelectFirstPlayer);
				btn2_mc.addEventListener(MouseEvent.MOUSE_UP, startDoublePlayerGame);
				
			}//end of restatr
			
			private function getRandom(min:Number, max:Number):Number{
     			return Math.floor(Math.random()	* (max - min +1) + min);
			}		


		
		}//end of class
	
	
}//end of package