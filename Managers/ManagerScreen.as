package game.Managers
{
	import flash.display.MovieClip;
	
	import game.display.Screens.ScreenWait;

	public class ManagerScreen
	{
		private var m_root:MovieClip;
		
		private var m_waitScreen:ScreenWait;
		
		public function ManagerScreen( root:MovieClip )
		{
			m_root = root;	
		}
		
		public function ShowWaitScreen( message:String ):void{
			m_waitScreen = new ScreenWait( message );
			m_root.addChild( m_waitScreen );
		}
		
		public function HideWaitScreen( ):void{
			if( m_waitScreen != null ){
				m_waitScreen.parent.removeChild( m_waitScreen );
				m_waitScreen = null;
			}
		}
		
		public function ShowLobby( ):void{
		 
		}
	}
}