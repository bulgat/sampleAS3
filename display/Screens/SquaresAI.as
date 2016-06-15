package game.display.Screens
{
	import game.display.Screens.Point;
	import game.display.Screens.Square;
	import Math;
	//import flash.geom.Point;
	
	
	public class SquaresAI
	{
			
		
		var PLAINBOARDSIZE:int = 0;
		var BOARDSIZE:int = 0;
		var SpeedMap: Vector.<Vector.<int>>;
		var SQSIZE:int = 1120;
		var pboard:Vector.<int>;				
		var Min:int;
		var Max:int;
		
		function SquaresAI(boardsize:int)
		{
			BOARDSIZE = boardsize;
			PLAINBOARDSIZE = boardsize*boardsize;
			pboard = new Vector.<int>(PLAINBOARDSIZE);
		}
		
		
		var SArray:Vector.<Square>= new Vector.<Square>(1120);
		
			
			
		
	
		public function GetSpeedMap():void
		{
			for(var num:int=0;num<PLAINBOARDSIZE;num++)
			{
				var size:int = 0;
				var res:Vector.<int>;
				var i:int = 0;
				
				for (var j:int=0;j<SQSIZE;j++)      
					if ((SArray[j].x1==num)||(SArray[j].x2==num)||(SArray[j].x3==num)||(SArray[j].x4==num)) 
						size++;
				
				var res:Vector.<int> = new Vector.<int>(size);
				
				
				for (var j:int=0;j<SQSIZE;j++)      
					if ((SArray[j].x1==num)||(SArray[j].x2==num)||(SArray[j].x3==num)||(SArray[j].x4==num)) 
						res[i++] = j;
				
				SpeedMap[num] = res;				
			}
		}
		
		
		
		
		public function RandomStep():Point
		{	
			var pointlist:Vector.<Point> = new Vector.<Point>(PLAINBOARDSIZE);
		//	var pointlist1:Vector.<int> = new Vector.<int>(PLAINBOARDSIZE);
	
			var i:int,listsize:int;
						
			for(i=0;i<PLAINBOARDSIZE;i++)										
			{
				pointlist.push(TOP(i));			
			};
			
			return pointlist[ Math.floor(Math.random()*listsize)];
		}
		
		
		function TOP( xx:int):Point
		{			
			return new Point(xx/BOARDSIZE,xx%BOARDSIZE);
		}
		
		
		function PlainOchkiSpeed( p:int):int
		{
			var i:int,res:int;
			res = 0;
			
			for (i=0;i<SQSIZE;i++)
			{ 
				if(pboard[SArray[i].x1]==p)
					if(pboard[SArray[i].x2]==p)
						if(pboard[SArray[i].x3]==p)
							if(pboard[SArray[i].x4]==p)		  		  
								res+=SArray[i].Sqr;		
			}
			return res;
		}
		
		
		function PlainOchki2():int
		{
			return PlainOchkiSpeed(1)-PlainOchkiSpeed(2);
		}
		
		function PlainStep( p:int, deep:int):void
		{
			var m:int,i:int;
			for( i=0;i<PLAINBOARDSIZE;i++)
				if (pboard[i]==0)
				{
					pboard[i]=p;
					if (deep>0)
						PlainStep((p==1)?2:1,deep-1);
					else
					{
						m=PlainOchki2();
						if (m<Min) Min=m;
						if (m>Max) Max=m;
					}
					pboard[i]=0;
				}
		}
		
		
		function SubStep( i:int, p:int, deep:int):void
		{
			var m:int;
			pboard[i]=p;
			if (deep>0)
				PlainStepSpeed(p,deep);
			else
			{
				m=PlainOchki2();
				if (m<Min) Min=m;
				if (m>Max) Max=m;
			}
			pboard[i]=0;
		}
		
		function PlainStepSpeed(p:int,deep:int):void
		{
			var i:int;
			for (i=0;i<SQSIZE;i++)
			{ 
				if ((((pboard[SArray[i].x1]==1)+(pboard[SArray[i].x2]==1)+(pboard[SArray[i].x3]==1)+(pboard[SArray[i].x4]==1))>1)||
					(((pboard[SArray[i].x1]==2)+(pboard[SArray[i].x2]==2)+(pboard[SArray[i].x3]==2)+(pboard[SArray[i].x4]==2))>1))	
				{
					if(!pboard[SArray[i].x1])
						SubStep(SArray[i].x1,(p==1)?2:1,deep-1);
					if(!pboard[SArray[i].x2])
						SubStep(SArray[i].x2,(p==1)?2:1,deep-1);
					if(!pboard[SArray[i].x3])
						SubStep(SArray[i].x3,(p==1)?2:1,deep-1);
					if(!pboard[SArray[i].x4])
						SubStep(SArray[i].x4,(p==1)?2:1,deep-1);
				}
			}
		}
		
		
		function  PlainOchki3(hod:int):int
		{
			var i:int =0;
			var j:int =0;
			var res1:int =0;
			var res2:int =0;
			var map:Vector.<int> = SpeedMap[hod];
			var size:int  = map.length;
			
			pboard[hod] = 1; 
			
			for (j=0;j<size;j++)
			{               
				i = map[j];
				if (pboard[SArray[i].x1]==1)
					if (pboard[SArray[i].x2]==1)
						if (pboard[SArray[i].x3]==1)
							if (pboard[SArray[i].x4]==1)
								res1+=SArray[i].Sqr;
			}
			
			pboard[hod] = 2;
			for (j=0;j<size;j++)
			{               
				i = map[j];
				
				if (pboard[SArray[i].x1]==2)
					if (pboard[SArray[i].x2]==2)
						if (pboard[SArray[i].x3]==2)
							if (pboard[SArray[i].x4]==2)
								res2+=SArray[i].Sqr;
			}
			
			if (res2>res1)
				res1 = res2;
			return res1;
		}
		
		
		public function MacroStep2( deep:int):Point
		{
			var i,maxmin,maxmax:int;
			
			var flag:int=1;
			
			
			var ptindex:int =-1;
			var m:int = 0;
			var mix:int = 0;
			//int *pboard=&board[0][0];
			
			/*
			PLAINBOARD pboard;
			int *p1=&board[0][0],*p2=&pboard[0];
			int progress=0;
			Point pt=RandomStep(board);
			// if (deep==0) return pt;
			//   ptindex=pt.x*BOARDSIZE+pt.y;
			for(i=0;i<PLAINBOARDSIZE;i++) p2[i]=p1[i];
			*/
			
			var pt:Point=RandomStep();
			
			for(i=0;i<PLAINBOARDSIZE;i++)
				if(pboard[i]==0)
				{
					m=PlainOchki3(i);
					if (m>mix)
					{
						mix=m;
						ptindex=i;
					}
					pboard[i]=0;
				}
			
			if (ptindex == -1)
				return pt;
			pt.x=ptindex/BOARDSIZE;
			pt.y=ptindex%BOARDSIZE;
			return pt;
		}
		
		
		
		public function MacroStep12(deep:int):Point
		{
			var i,maxmin,maxmax:int;			
			var flag:int=1;
			var ptindex:int;
			var progress:int=0;
			var pt:Point=RandomStep();
			
			/*
			//int *pboard=&board[0][0];
			PLAINBOARD pboard;
			int *p1=&board[0][0],*p2=&pboard[0];
			
			
			if (deep==0) return pt;
			ptindex=pt.x*BOARDSIZE+pt.y;
			for(i=0;i<PLAINBOARDSIZE;i++) p2[i]=p1[i];   
			*/
			
			
			for(i=0;i<PLAINBOARDSIZE;i++)
				if(pboard[i]==0)
				{					
					progress++;
					pboard[i]=1;
					Min=100000;
					Max=-100000;
					PlainStep(2,deep-1);	 
					pboard[i]=0;
					if (flag)
					{
						maxmin=Min;
						maxmax=Max;
						flag=0;
					}
					if (Min>maxmin)
					{
						maxmin=Min;
						maxmax=Max;
						ptindex=i;
					}
					if (Min>=maxmin)
						if (Max>maxmax)
						{
							maxmin=Min;
							maxmax=Max;
							ptindex=i;
						}
				}
			pt.x=ptindex/BOARDSIZE;
			pt.y=ptindex%BOARDSIZE;
			return pt;
		}
		
		function GenerateSqare(p:Point,BS:int):Square
		{
			
			
			var c:int=BS/2;
			var s:int = 0;
			
			var p1:Point = new Point(p.x,p.y);
			var p2:Point = new Point(BS-1-p.y,p.x);
			var p3:Point = new Point(p.y,BS-1-p.x);
			var p4:Point = new Point(BS-1-p.x,BS-1-p.y);
			
			
			if (p.x>p.y)
			{
				s=-p.y;
				//	Sq.Sqr=p.x*p.x;
			}
			else
			{
				s=-p.x;
				//	Sq.Sqr=p.y*p.y;
			}
			//s=0;
			//Sq.Sqr=IsSqare(p1,p2,p3,p4);//SQR(ABS(p3.x-p2.x)+1);
			var Sqr:int=   ( Math.abs(p1.x-p2.x)+  Math.abs(p1.y-p2.y)+1)  *  ( Math.abs(p1.x-p2.x)+  Math.abs(p1.y-p2.y)+1) ;
			p1.x+=s;  
			p1.y+=s;  
			p2.x+=s;  
			p2.y+=s;  
			p3.x+=s;  
			p3.y+=s;  
			p4.x+=s;  
			p4.y+=s;
			
			var Sq: Square = new Square(
			   p1.x*BOARDSIZE+p1.y,
			   p2.x*BOARDSIZE+p2.y,
			   p3.x*BOARDSIZE+p3.y,
			   p4.x*BOARDSIZE+p4.y
			);
			
			Sq.Sqr = Sqr;
			return Sq;
		}
		
		function DeltaSquare( s:Square,delta:int):Square
		{			
			return new Square(
				s.x1+delta,
				s.x2+delta,
				s.x3+delta,
				s.x4+delta);
		}
		
		function SqrArraySize():int
		{
			var res:int=0;
			var k:int;
			var n:int,m:int;
			var i:int;
			var j:int;
			var p:Point;
			
			for (i=0;i<BOARDSIZE/2;i++)
				for (j=0;j<BOARDSIZE/2;j++)
				{
					if (i>j) k=j;
					else k=i;
					
					k=BOARDSIZE/2-k;
					p.x=i;
					p.y=j;
					
					for (n=0;n<BOARDSIZE-k*2+1;n++)
						for (m=0;m<BOARDSIZE-k*2+1;m++)
						{
							SArray[res]= DeltaSquare(GenerateSqare(p,BOARDSIZE),n*BOARDSIZE+m);
							res++;
						}
				}
			
			for (i=0;i<BOARDSIZE/2;i++)
				for (j=0;j<BOARDSIZE/2-1;j++)
					if (!((i==BOARDSIZE/2-1)&&(j==BOARDSIZE/2-1)))
					{
						if (i>j) k=i;
						else k=j;
						
						if (i>j) k=j;
						else k=i;
						
						k=BOARDSIZE/2-k;
						p.x=i;
						p.y=j;
						
						for (n=0;n<BOARDSIZE-k*2+2;n++)
							for (m=0;m<BOARDSIZE-k*2+2;m++)
							{
								//ShowSquare(DeltaSquare(GenerateSqare(p,5),n*BOARDSIZE+m));
								SArray[res]= DeltaSquare(GenerateSqare(p,BOARDSIZE-1),n*BOARDSIZE+m);
								res++;
							}
					}
			
			SQSIZE=res;
			
			GetSpeedMap();
			return res;
		}
		
		
	
		/*
		int AI_IsGameOver(BOARD board)
		{
			int i,j;
			
			for (j=0; j < uiDeskSize; j++)
				for (i=0; i < uiDeskSize; i++)
					if (board[i][j] == 0)
						return FALSE;
			
			return TRUE;
		}
*/
		
	
	
	}

}






