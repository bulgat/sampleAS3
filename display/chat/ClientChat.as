package game.display.chat
{
	import com.greensock.plugins.CacheAsBitmapPlugin;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import core.baseObject;
	import core.chat.Message;
	import core.chat.Session;
	import core.chat.TypeMessage;
	import core.gui.button.baseButton;
	
	import game.Global;

	public class ClientChat extends baseObject
	{
		private var m_mode:TypeMessage = TypeMessage.CLAN_CHAT;
		
		//private var m_input:InputMessage;
		
		private var m_bPublic:bButton;
		
		private var m_bClan:bButton;
		
		private var m_text:TextField;
		
		private var m_session:Session;
		
		public function ClientChat( )
		{
			y = 760;
			m_text = new TextField( );
			m_text.border = true;
			m_text.width = 700;
			m_text.height = 100;
			addChild( m_text );
			m_text.text+="Chat\n"; 
			m_text.y = 30;
		/*	var c:ItmListChat = new ItmListChat( null );
			c.y = 30;
			c.Online = false;
			addChild( c );
			*/
			//m_input = new InputMessage( );
		//	addChild( m_input );
		//	m_input.y = 130;
			
			m_bPublic = new bButton( );
			m_bClan = new bButton( );
			addChild( m_bPublic );
			addChild( m_bClan );
			
			m_bClan.x = 200;   
			
			m_bPublic.addEventListener(MouseEvent.CLICK , onPublic );
			m_bClan.addEventListener(MouseEvent.CLICK , onClan );
			
			Global.Chat = this;
		}
		
		
		/**
		 * подключиться к серверу
		 */
		public function Connect( internalID:String="111" , socID:String="2" , clanID:String="22" , _name:String= "Unkno1w" ):void{

				var ms:Message = new Message( Global.player.Name , Global.player.InternalID , Global.player.Clan.toString() , "Про " , TypeMessage.LOGIN ); 
				var h:String = "82.119.157.2";
				h = "localhost";
			    m_session = new Session( h , 1139 , ms.toSend , null );
			
		}
	
		private function onPublic( e:MouseEvent ):void{
			Mode = TypeMessage.PUBLIC;
			trace('**************PUBLIC');
		}
		
		private function onClan( e:MouseEvent ):void{
			Mode = TypeMessage.CLAN_CHAT;
			trace('***********CLAN_CHAT');
		}
		
		public function set Mode( mode:TypeMessage ):void{
			if( m_mode == mode ) return;
			m_mode = mode;
		}
		
		public function get Mode( ):TypeMessage{
			return m_mode;
		}
		
		public function Init( ):void{
		
		}
	}
}