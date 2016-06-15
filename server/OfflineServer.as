package game.server
{
	import core.social.TypeSocial;

	public class OfflineServer implements IServer
	{
		private var m_host:String;
		
		public function OfflineServer( host:String = "serverConfig" )
		{
			m_host = host;
		}
		
		
		public function player_init ( uid:String , typeSoc:TypeSocial , friends:Array , callback:Function ):void{
			if( callback!=null ) callback( );
		}
		
		public function player_Ammunition( uid:String , callback:Function ):void{
		
		}
		 

		public function player_dressAmmunition( uid:String , ammunitGlobalID:String , callback:Function):void{
			if( callback!=null ) callback( );
		}
		
		public function player_takeOfAmmunition( uid:String , ammunitGlobalID:String , callback:Function ):void{
			if( callback !=null ) callback( );
		}
		
		public function user_getInfo( uid:String , field:Array , callback:Function ):void{
			if( callback!=null ) callback();  
		}
		
		
	}
}