package game.display.notice
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import game.Managers.ManagerBase;

	public class ManagerNotice extends ManagerBase
	{
		private var m_list:Vector.<baseNotice>;
		
		private var m_timer:Timer;
		
		private var m_root:DisplayObjectContainer;
		
		public static const TIME_INTERVAL:int = 3;
		
		public function ManagerNotice( root:DisplayObjectContainer )
		{
			super( null );
			if( root == null ) return;
			m_root = root;
			m_list = new Vector.<baseNotice>( ); 
			
		}
		
		public function addNotice(  notice:baseNotice ):void{
			
			if( !m_list.length ){
				startTimer();
			}
			
			m_list.push( notice );
		}
		
		private function startTimer( ):void{
			m_timer = new Timer( ManagerNotice.TIME_INTERVAL * 1000 , 0 );
			m_timer.addEventListener(TimerEvent.TIMER , onTimer  );
			m_timer.start();
		}
		
		private function stopTimer( ):void{
			m_timer.stop();
			m_timer.removeEventListener(TimerEvent.TIMER , onTimer );
		}
		
		private function onTimer( e:TimerEvent ):void{
			m_list.shift().Show();
			
			if ( !m_list.length ){
				stopTimer();
			}
		}
	}
}