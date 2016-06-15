package game.display.Lobby
{
	import core.gui.button.scaleButton;
	import core.gui.guiRoot;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	
	import game.Global;
	import game.display.Screens.ScreenAmmunition;
	import game.display.Screens.ScreenArena;
	import game.display.Screens.ScreenAttackBoss;
	import game.display.Screens.ScreenBins;
	import game.display.Screens.ScreenBoss;
	import game.display.Screens.ScreenCastle;
	import game.display.Screens.ScreenChooseStorm;
	import game.display.Screens.ScreenMap;
	import game.display.Screens.ScreenStorming;
	import game.gameplay.storm.StormCastle;

	/**
	 * Правая панель лобби 
	 * @author volk
	 * 
	 */	
	public class PnlRightLobby extends MovieClip
	{
		[Embed(source="../../../../ResourcesGame/game/Lobby/rightPanel/arena_64x64.png")]   
		public static const arena_64x64:Class
		
		[Embed(source="../../../../ResourcesGame/game/Lobby/rightPanel/bank_64x64.png")]   
		public static const bank_64x64:Class
		
		[Embed(source="../../../../ResourcesGame/game/Lobby/rightPanel/castle_64x64.png")]   
		public static const castle_64x64:Class
		
		[Embed(source="../../../../ResourcesGame/game/Lobby/rightPanel/eagle_post_64x64.png")]   
		public static const eagle_post_64x64:Class
		
		[Embed(source="../../../../ResourcesGame/game/Lobby/rightPanel/home_64x64.png")]   
		public static const home_64x64:Class
		
		[Embed(source="../../../../ResourcesGame/game/Lobby/rightPanel/inventory_64x64.png")]   
		public static const inventory_64x64:Class
		
		[Embed(source="../../../../ResourcesGame/game/Lobby/rightPanel/magicwheel_64x64.png")]   
		public static const magicwheel_64x64:Class
		
		[Embed(source="../../../../ResourcesGame/game/Lobby/rightPanel/map_64x64.png")]   
		public static const map_64x64:Class
		
		[Embed(source="../../../../ResourcesGame/game/Lobby/rightPanel/skills_64x64.png")]   
		public static const skills_64x64:Class
		
		[Embed(source="../../../../ResourcesGame/game/Lobby/rightPanel/soldiers_of_fortune_64x64.png")]   
		public static const soldiers_of_fortune_64x64:Class
		
		[Embed(source="../../../../ResourcesGame/game/Lobby/rightPanel/takeover_64x64.png")]   
		public static const takeover_64x64:Class
		
		[Embed(source="../../../../ResourcesGame/game/Lobby/rightPanel/depository.png")]   
		public static const depository:Class
		
		[Embed(source="../../../../ResourcesGame/game/Lobby/rightPanel/RightPanel.png")]     
		public static const RightPanel:Class
		
		
		private var m_iBack:Bitmap;
		
		private var m_listButton:Vector.<scaleButton>;
		
		private var m_bArena:scaleButton;
		private var m_bBank:scaleButton;
		private var m_bCastle:scaleButton;
		private var m_bEagle:scaleButton;
		private var m_bHome:scaleButton;
		private var m_bInventory:scaleButton;
		private var m_bMagicWheel:scaleButton;
		private var m_bMap:scaleButton;
		private var m_bSkills:scaleButton;
		private var m_bSoldiers_of_fortune:scaleButton;
		private var m_bTakeover:scaleButton;
		private var m_bDepository:scaleButton;
		
		private var m_lobbyScreen:ScreenLobby;
		
		//отступ и дистанция между большими иконками левого меню
		private var listButtonLeftIndent_i:int=47;
		private var listButtonLap_i:int=65;
		
		private namespace CALLBACK;
		
		public function PnlRightLobby( scrLobby:ScreenLobby )
		{ 
			m_lobbyScreen = scrLobby;
			
			m_iBack = new RightPanel() as Bitmap;
			addChild( m_iBack );
			
			m_listButton = new Vector.<scaleButton>( );
			
			m_bArena  = new scaleButton( new arena_64x64() as Bitmap );    m_bArena.Click  = onArena; m_bArena.Hint = "Переход на арену";
			m_bBank   = new scaleButton( new bank_64x64() as Bitmap );     m_bBank.Click   = onBank; m_bBank.Hint = "Переход в банк";
			m_bCastle = new scaleButton( new castle_64x64() as Bitmap );  m_bCastle.Click = onCastle;
			m_bEagle  = new scaleButton( new eagle_post_64x64() as Bitmap );    m_bEagle.Click  = onEagle;
			m_bHome   = new scaleButton( new home_64x64() as Bitmap );      m_bHome.Click   = onHome;
			
			m_bInventory  = new scaleButton( new inventory_64x64() as Bitmap );    m_bInventory.Click = onInventory;
			m_bMagicWheel = new scaleButton( new magicwheel_64x64() as Bitmap );   m_bMagicWheel.Click = onMagicWheel;
			m_bMap 		  = new scaleButton( new map_64x64() as Bitmap ); 		   m_bMap.Click = onMap; m_bMap.Hint = "Переход на карту";
			m_bSkills     = new scaleButton( new skills_64x64() as Bitmap ); 	   m_bSkills.Click = onSkills;
			m_bSoldiers_of_fortune = new scaleButton( new soldiers_of_fortune_64x64() as Bitmap ); m_bSoldiers_of_fortune.Click = onSoldFortune;
			m_bTakeover   = new scaleButton( new takeover_64x64() as Bitmap ); 	   m_bTakeover.Click = onTakeover;
			m_bDepository   = new scaleButton( new depository() as Bitmap ); 	   m_bDepository.Click = onDepository;			
			
			m_listButton.push( m_bArena );
			m_listButton.push( m_bBank );
			m_listButton.push( m_bCastle );
			m_listButton.push( m_bEagle );
			m_listButton.push( m_bHome );
			m_listButton.push( m_bInventory );
			m_listButton.push( m_bMagicWheel );
			m_listButton.push( m_bMap );
			m_listButton.push( m_bSkills );
			m_listButton.push( m_bSoldiers_of_fortune ); 
			m_listButton.push( m_bTakeover );
			m_listButton.push( m_bDepository );
			onFill( );	
			x = guiRoot.sizeWidth - width;//+7;//+20+20+10;   
		
		}
		
		private function onFill( ):void{
			var len:int = 2;
			var i:int = 0;
			for( i = 0;i<m_listButton.length;i++){ 
							
				m_listButton[ i ].x = listButtonLeftIndent_i+listButtonLap_i*(i%len); 
				m_listButton[ i ].y = 70+80*Math.floor(i/len); 
				addChild( m_listButton[i] );
			}
		}
		
		private function onArena( ):void{
			if( m_lobbyScreen.CurrentScreen != "ScreenArena" )  
				m_lobbyScreen.ShowScreen( new ScreenArena( )  );
		}
		public function onBank( ):void{
			// если в штурме, то шлепаем в штурм сразу
			if( StormCastle.isStorm() ){
				if( m_lobbyScreen.CurrentScreen != "ScreenStorming" )
					m_lobbyScreen.ShowScreen( new ScreenStorming( StormCastle.getIDCastleStorm() ) ); 
			}
			else{
				if( m_lobbyScreen.CurrentScreen != "ScreenChooseStorm" )
					m_lobbyScreen.ShowScreen( new ScreenChooseStorm( )  );
			}
		}
		
		private function onCastle( ):void{
			if( m_lobbyScreen.CurrentScreen != "castleScreen" )
				m_lobbyScreen.ShowScreen( new ScreenCastle( )  );
		}
		
		private function onEagle( ):void{
			Global.Server.getInfoBattle( Global.player.InternalID , CALLBACK::onGoodInfo , CALLBACK::onFailedInfo );
		}
		
		CALLBACK function onGoodInfo( e:Object ):void{
			if ( e == "Empty" ){
				if( m_lobbyScreen.CurrentScreen != "ScreenBoss" )
						m_lobbyScreen.ShowScreen( new ScreenBoss( )  );
			}else{
				//- переходим сразу в окно с боем босса
				if( m_lobbyScreen.CurrentScreen != "ScreenAttackBoss" ){
					m_lobbyScreen.ShowScreen( new ScreenAttackBoss( e ) ); 
				}
			}
		}
		
		CALLBACK function onFailedInfo( e:Object ):void{
			if( m_lobbyScreen.CurrentScreen != "ScreenBoss" )
				m_lobbyScreen.ShowScreen( new ScreenBoss( )  );
		}
		
		private function onHome( ):void{
									
		}
		
		private function onInventory( ):void{
			if( m_lobbyScreen.CurrentScreen != "AmmunitionArena" )
				m_lobbyScreen.ShowScreen( new ScreenAmmunition()   );
		}
		
		private function onMagicWheel( ):void{}
		
		private function onMap( ):void{
			if( m_lobbyScreen.CurrentScreen != "screenMap" )
				m_lobbyScreen.ShowScreen( new ScreenMap( ) );
		}
		
		private function onSkills( ):void{
			
		}
		
		private function onSoldFortune( ):void{
			if( m_lobbyScreen.CurrentScreen != "ScreenStorming" )
				m_lobbyScreen.ShowScreen( new ScreenStorming( 1 )  );
		}
		
		private function onTakeover( ):void{
		
		}
		
		private function onDepository( ):void{
			if( m_lobbyScreen.CurrentScreen != "ScreenBins" )
				m_lobbyScreen.ShowScreen( new ScreenBins()  );
		}
		
		
		
	}
}