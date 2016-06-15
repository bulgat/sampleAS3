package game.display.Lobby
{

	
	import core.baseObject;
	import core.gui.guiRoot;
	import core.gui.progress.Progress;
	
	import game.assets.guiAsset;
	import game.display.FriendBar.PnlFriendBar;
	import game.display.Screens.ScreenCastle;
	import game.display.Screens.baseScreen;
	
	public class ScreenLobby extends baseObject
	{
		
		private var m_currentScreen:baseScreen;
		
		private var m_PnlRight:PnlRightLobby;
		
		private var m_PnlFriendBar:PnlFriendBar; 
	
		private var m_PnlTop:PnlTop;
		
		public function ScreenLobby( )
		{
			m_currentScreen = new ScreenCastle( );
			addChild( m_currentScreen );
			
			m_PnlRight = new PnlRightLobby( this );
			addChild( m_PnlRight );
			
			m_PnlFriendBar = new PnlFriendBar( null );
			addChild( m_PnlFriendBar );
			
			m_PnlTop = new PnlTop( this );
			addChild( m_PnlTop ); 
			
			m_PnlRight.y = m_PnlTop.height-2;//-65;
			//m_PnlRight.x = guiRoot.sizeWidth-m_PnlRight.width+5;
			
			

			m_currentScreen.y = m_PnlTop.height-2;//-40;
		}
		
		public function ShowScreen( screen:baseScreen ):void{ 
			if( m_currentScreen != null && m_currentScreen.parent != null ){
				m_currentScreen.parent.removeChild( m_currentScreen );
			}
			addChild( screen );
			m_currentScreen = screen;
			m_currentScreen.y = m_PnlTop.height-2;
		}
		
		public function get CurrentScreen( ):String{
			return m_currentScreen.Name;
		}
	}
}  