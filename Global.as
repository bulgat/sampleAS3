package game
{

	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.system.Security;
	
	import core.Settings;
	import core.chat.Session;
	import core.loader.BatchLoader;
	import core.loader.ResourceLoader;
	import core.loader.TypeLoad;
	import core.social.ISocial;
	import core.social.TypeSocial;
	import core.task.ManagerTask;
	
	import game.Managers.ManagerAmmoSet;
	import game.Managers.ManagerAmmunition;
	import game.Managers.ManagerArtifact;
	import game.Managers.ManagerCastle;
	import game.Managers.ManagerCollection;
	import game.Managers.ManagerConsumed;
	import game.Managers.ManagerGarden;
	import game.Managers.ManagerPlayer;
	import game.Managers.ManagerPotions;
	import game.Managers.ManagerScreen;
	import game.Managers.ManagerSiegeWeapons;
	import game.Managers.ManagerSound;
	import game.Managers.ManagerTrophy;
	import game.Managers.ManagerVillageCoord;
	import game.Managers.Managers;
	import game.Managers.ManagersBank;
	import game.Managers.ManagersKingdoms;
	import game.Managers.ManagersOuthouse;
	import game.display.Lobby.ScreenLobby;
	import game.display.chat.ClientChat;
	import game.display.notice.ManagerNotice;
	import game.gameplay.Player;
	import game.server.IServer;
	import game.server.OfflineServer;
	import game.server.OnlineServer;

	public class Global
	{
		public static var social:ISocial;
		
		public static var managerScreen:ManagerScreen;
		
		public static var Tasks:ManagerTask;
		
		public static var Notice:ManagerNotice;
		
		public static var ManagerResources:ResourceLoader; 
		
		public static var player:Player;
		
		public static var screenLobby:ScreenLobby;
		
		private var m_callback:Function = null;
		
		private static var m_inOnline:Boolean;
		 
		private static var m_host:String = "http://87.249.31.60/";
		
		public static var Server:IServer;
		
		public static var FlashVars:Object;
		
		public static var TypeSoc:TypeSocial= TypeSocial.VKontakte;
		 
		public static const MaxUpgradeOuthouse:int = 8;
		
		public static var settings:Settings;
		
		public static var Root:DisplayObjectContainer;
		
		public static var Chat:ClientChat;
		
		private namespace CALLBACK;
		
		/**
		 * время  подключения игрока к серверу/использовать только для чтения / позже переделать на get с нормальной логикой
		 */
		public static var startTimeGame:int = 0;
	
		public function Global ( root:MovieClip  , callback:Function )
		{ 
			Global.Root = root;
			
			if ( flash.system.Security.sandboxType.indexOf(flash.system.Security.REMOTE) >= 0) {
				m_inOnline = true;
			}else
				m_inOnline = false; 
			if( CONFIG::VOLK ){  
				Server = new OnlineServer( "http://test1.ru/MiddleAges/index.php?" );
			}else
				Server = new OnlineServer( "http://87.249.31.60/MiddleAges/index.php?" );
			
			m_callback       = callback;
			managerScreen    = new ManagerScreen( root );	 
			Tasks            = new ManagerTask( );
			Notice			 = new ManagerNotice( root );
			ManagerResources = new ResourceLoader( );
			settings 	     = new Settings( );
			Managers.sounds  = new ManagerSound( );
						
			Global.ManagerResources.addEventListener( ResourceLoader.END_LOADED , onEnd );
			LoadData( );
			new game.Console( );
			
		}
		
		
		private function onEnd( e:* ):void{
			
			if( m_callback )
				m_callback();
		}
		
		private function LoadData( ):void{
			ManagerResources.addBacth(  new BatchLoader( "config/outhouse.xml"    , TypeLoad.XML_DATA , CALLBACK::onOunthouse   ) );	
			ManagerResources.addBacth(  new BatchLoader( "config/ammunition.xml"  , TypeLoad.XML_DATA , CALLBACK::onAmmunition  ) );
			ManagerResources.addBacth(  new BatchLoader( "config/ammoSet.xml"     , TypeLoad.XML_DATA , CALLBACK::onAmmoSet     ) );
			ManagerResources.addBacth(  new BatchLoader( "config/consumed.xml"    , TypeLoad.XML_DATA , CALLBACK::onConsumed    ) );	
			ManagerResources.addBacth(  new BatchLoader( "config/collection.xml"  , TypeLoad.XML_DATA , CALLBACK::onCollection  ) );
			ManagerResources.addBacth(	new BatchLoader( "config/kingdoms.xml"    , TypeLoad.XML_DATA , CALLBACK::onKingdoms    ) );
			ManagerResources.addBacth(  new BatchLoader( "config/villages.xml"    , TypeLoad.XML_DATA , CALLBACK::onVillages    ) );
			ManagerResources.addBacth(	new BatchLoader( "config/bank.xml"        , TypeLoad.XML_DATA , CALLBACK::onBank        ) );
			ManagerResources.addBacth(	new BatchLoader( "config/garden.xml"      , TypeLoad.XML_DATA , CALLBACK::onGarden      ) );
			ManagerResources.addBacth(	new BatchLoader( "config/potion.xml"      , TypeLoad.XML_DATA , CALLBACK::onPotion      ) );
			ManagerResources.addBacth(	new BatchLoader( "config/trophy.xml"      , TypeLoad.XML_DATA , CALLBACK::onTrophy      ) );
			ManagerResources.addBacth(	new BatchLoader( "config/artifact.xml"    , TypeLoad.XML_DATA , CALLBACK::onArtifact    ) );
			ManagerResources.addBacth(	new BatchLoader( "config/table_siege.xml", TypeLoad.XML_DATA , CALLBACK::onSiegeWeapon ) );
			ManagerResources.addBacth(	new BatchLoader( "config/castles.xml"	  , TypeLoad.XML_DATA , CALLBACK::onCastle	    ) );
			ManagerResources.addBacth(  new BatchLoader( "config/Player.xml"      , TypeLoad.XML_DATA , CALLBACK::onPlayer      ) );
		} 
		
		CALLBACK function onCastle( data:* ):void{
			Managers.castle = new ManagerCastle( data );
		}
		
		CALLBACK function onSiegeWeapon( data:* ):void{
			Managers.siegeWeapons = new ManagerSiegeWeapons( data );
		}
		
		CALLBACK function onCollection( data:* ):void{
			Managers.collection = new ManagerCollection( data );
		}
		
		CALLBACK function onVillages( data:* ):void{
			Managers.OuthouseCoord = new ManagerVillageCoord( data ); 
		}
		
		CALLBACK function onPlayer( data:* ):void{
			Managers.player = new ManagerPlayer( data );
		}
		 
		CALLBACK function onAmmunition( data:* ):void{
			Managers.ammunitions = new ManagerAmmunition( data ); 
		}
		
		CALLBACK function onAmmoSet( data:* ):void{
			Managers.ammo_set = new ManagerAmmoSet( data ); 
		}
		
		CALLBACK function onOunthouse( data:* ):void{
			Managers.outhouse = new ManagersOuthouse( data );
		}
		
		CALLBACK function onConsumed( data:*):void{
			Managers.consumed = new ManagerConsumed( data );
		}
		
		CALLBACK function onKingdoms( data:* ):void{
			Managers.kingdoms = new ManagersKingdoms( data );
		}
		
		CALLBACK function onBank( data:* ):void{
			Managers.bank = new ManagersBank( data );
		}
		
		CALLBACK function onGarden( data:* ):void{
			Managers.garden = new ManagerGarden( data );
		}
		
		CALLBACK function onPotion( data:* ):void{
			Managers.potions = new ManagerPotions( data );
		}
		
		CALLBACK function onTrophy( data:* ):void{
			Managers.trophy = new ManagerTrophy( data );
		}
		
		CALLBACK function onArtifact( data:* ):void{
			Managers.artifact = new ManagerArtifact( data );
		}
		
		//--set/get
		public static function get Online( ):Boolean{
			return m_inOnline;
		}
		
		public static function get Host( ):String{
			if( m_inOnline )
				return m_host;
			else
				return "";
		}
	}
}