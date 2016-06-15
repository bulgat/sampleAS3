package game.display.FriendBar
{
	import core.action.ImageLoader;
	import core.gui.button.scaleButton;
	
	import flash.display.Bitmap;
	import flash.text.TextField;
	
	import game.Global;

	public class ItmFriendBar extends scaleButton
	{
		[Embed(source="../../../../ResourcesGame/game/FriendBar/avatar.png")]   
		public static const friendBarBack:Class;
		
		[Embed(source="../../../../ResourcesGame/game/FriendBar/friendBarAvatar.png")]   
		public static const friendBarBackLoaded:Class;
		
		private var m_name:String;
		
		private var m_level:String = "0";
		
		private var m_levelText:TextField;
		  
		//private var m_image:ImageLoader; 
		
		private var m_uid:String;  
		
		private var m_pnl:PnlFriendBar;
		
		private var m_avatar:ImageLoader;
		  
		private var m_url:String;
		
		private var m_isShow:Boolean;
		
		private var m_callBack:Function;
		
		private static var m_WIDTH:Number = 0;
		
		public function ItmFriendBar( panel:PnlFriendBar , uid:String , callBack:Function )
		{
			super( new friendBarBack() as Bitmap , true );
			m_uid = uid;	
			m_pnl = panel;
			m_WIDTH = this.width;
			
			m_callBack = callBack;
			
			this.Click = ShowFriend;
		}
		
		private function ShowFriend( ):void{
			m_callBack( m_uid );
		}
		
		public static function get WIDTH( ):Number{
			return m_WIDTH;
		}
		
		private function onInfoFriend( response:Object ):void{
			//trace(  response[0]['photo_50'] );   
			m_url = response[0]['photo_50'] ;
			m_avatar = new ImageLoader( response[0]['photo_50'] , onResize );
		} 
	
		public function loadAvatar( ):void{
			if( m_isShow || m_uid=="-1") return;
			Global.social.GetUserInfo( [m_uid], ["photo_50"] , onInfoFriend ); 
			//m_avatar = new ImageLoader( m_url , onResize );
			m_isShow = true;
			
			ChangeImg( new friendBarBackLoaded() as Bitmap );
			
			//Уровень игрока
			m_levelText = new TextField();
			m_levelText.text = String( m_level );
			m_levelText.mouseEnabled = false;
			m_levelText.x = -5;
			m_levelText.y = -48;
			addChild( m_levelText );
			
		}
		
		private function onResize( ):void{
			m_avatar.x = - m_avatar.width/2;
			m_avatar.y = - m_avatar.height/2 ;//- 10;
			addChild( m_avatar );
		}
		
	}
}