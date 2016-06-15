package game.display.chat
{
	import flash.events.MouseEvent;
	
	import core.baseObject;

	public class ItmListChat extends chatMessage
	{
		private var m_idUser:String;
		
		private var m_online:Boolean;
		
		private var m_enabled:Boolean = true;
		
		private var m_indiacator:Boolean = false;
		
		
		public function ItmListChat( message:Object  )
		{
			addEventListener ( MouseEvent.CLICK , onClick );
		}
		
		
		private function onClick( e:MouseEvent ):void{
	
		}
		
		
		public function set isEnabled( f:Boolean ):void{
			if( f == m_enabled ) return;
			m_enabled = f;
			if( !f ) {
				alpha = 0.3;
				removeEventListener ( MouseEvent.CLICK , onClick );
			}else{
				this.alpha = 1;
				addEventListener ( MouseEvent.CLICK , onClick );
			}
		}
		
		public function set Online( f:Boolean ):void{
			m_online = f;
			if( f ) 
				this['indicator'].gotoAndStop( 1 );
			else
				this['indicator'].gotoAndStop( 2 );
		}
		
		public function get Online( ):Boolean{
			return m_online;
		}
		
		
	}
}