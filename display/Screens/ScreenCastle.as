package game.display.Screens
{
	import core.gui.button.filterButton;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	
	import game.Global;
	import game.display.FriendBar.PnlFriendBar;
	import game.display.Lobby.PnlRightLobby;
	import game.display.Lobby.ScreenLobby;

	public class ScreenCastle extends baseScreen
	{
		[Embed(source="../../../../ResourcesGame/game/Screens/castle/castle_bgr.png")] 
		public static const castle_bgr:Class; 
		
		[Embed(source="../../../../ResourcesGame/game/Screens/castle/castle_forge.png")] 
		public static const castle_forge:Class; 
		
		[Embed(source="../../../../ResourcesGame/game/Screens/castle/castle_garden.png")] 
		public static const castle_garden:Class; 
		
		[Embed(source="../../../../ResourcesGame/game/Screens/castle/castle_gate.png")] 
		public static const castle_gate:Class; 
		
		[Embed(source="../../../../ResourcesGame/game/Screens/castle/castle_guard.png")] 
		public static const castle_guard:Class; 
		
		[Embed(source="../../../../ResourcesGame/game/Screens/castle/castle_hospital.png")] 
		public static const castle_hospital:Class; 
		
		[Embed(source="../../../../ResourcesGame/game/Screens/castle/castle_lord.png")] 
		public static const castle_lord:Class; 
		
		[Embed(source="../../../../ResourcesGame/game/Screens/castle/castle_shop.png")] 
		public static const castle_shop:Class; 
		
		[Embed(source="../../../../ResourcesGame/game/Screens/castle/castle_trees_1.png")] 
		public static const castle_trees_1:Class; 
		
		[Embed(source="../../../../ResourcesGame/game/Screens/castle/castle_trees_2.png")] 
		public static const castle_tree_2:Class; 
		
		[Embed(source="../../../../ResourcesGame/game/Screens/castle/castle_alchemist.png")]   
		public static const castle_alchemist:Class;
		
		[Embed(source="../../../../ResourcesGame/game/Screens/castle/animation.swf", symbol="sun")]
		private var animationClass:Class;
		private var m_animation:MovieClip;
		
		private var m_bGate:filterButton;   
		
		private var m_bHospital:filterButton;
		
		private var m_bShop:filterButton;
		
		private var m_bLord:filterButton;
		
		private var m_bGuard:filterButton;
		
		private var m_bSmith:filterButton;
		
		private var m_bAlchemist:filterButton;
		
		private var m_bGarden:filterButton;
		
		private var m_iBack:Bitmap;
		
		private var m_iTree1:Bitmap;
		
		private var m_iTree2:Bitmap;
		
		public function ScreenCastle( ) 
		{ 
			this.m_internalName = "castleScreen";
			
			m_iBack =  new castle_bgr () as Bitmap ; 
			addChild( m_iBack );
			
			m_bLord = new filterButton( new castle_lord() as Bitmap );
			m_bLord.x = 212;
			m_bLord.y = 46;
			addChild( m_bLord );
			
			m_iTree1 = new castle_trees_1() as Bitmap;
			m_iTree1.x = 150;
			m_iTree1.y = 190;
			addChild( m_iTree1  );
			
			m_bGarden = new filterButton( new castle_garden( ) as Bitmap );
			m_bGarden.x = 322;
			m_bGarden.y = 151;
			addChild( m_bGarden );
			
			m_bGate = new filterButton( new castle_gate( ) as Bitmap );
			m_bGate.x = 242;
			m_bGate.y = 423;
			addChild( m_bGate );
			
			m_bHospital = new filterButton( new castle_hospital( ) as Bitmap );
			m_bHospital.x = 69;
			m_bHospital.y = 190;
			addChild( m_bHospital );
			
			m_bShop = new filterButton( new castle_shop( ) as Bitmap );
			m_bShop.x = 344;
			m_bShop.y = 277;
			addChild( m_bShop );  
		
			m_bAlchemist = new filterButton( new castle_alchemist() as Bitmap );
			m_bAlchemist.x = 459;
			m_bAlchemist.y = 81;
			addChild( m_bAlchemist );
			
			m_bSmith = new filterButton( new castle_forge() as Bitmap );
			m_bSmith.x = 178;
			m_bSmith.y = 230;
			addChild( m_bSmith );
			
			m_bGuard = new filterButton( new castle_guard() as Bitmap );
			m_bGuard.x = 470;
			m_bGuard.y = 323;	
			addChild( m_bGuard ); 
			
			m_iTree2 = new castle_tree_2() as Bitmap;
			m_iTree2.x = 453;
			m_iTree2.y = 437;
			addChild( m_iTree2  );
			
			m_animation = new animationClass();
			m_animation.x = 420;
			m_animation.y = 60;
			m_animation.mouseEnabled = false;
			m_animation.mouseChildren = false;
			addChild( m_animation );
			
			this.m_bGarden.Click 		= onGarden;
			this.m_bAlchemist.Click 	= onAlchemist;
			this.m_bSmith.Click 		= onSmith;
			this.m_bGate.Click 		    = onGate;
			this.m_bGuard.Click 		= onGuard;
			this.m_bHospital.Click 		= onHospital;
			this.m_bLord.Click 			= onLord;
			this.m_bShop.Click 			= onShop;
			
		//	addChild( new PnlRightLobby( ) );
		//	addChild( new PnlFriendBar( null ) );
		}
		
		private function onGarden( ):void{
			Global.screenLobby.ShowScreen( new ScreenGarden( ) );
		}
		
		private function onAlchemist( ):void{
			Global.screenLobby.ShowScreen( new ScreenAlchemist() );
		}
		
		private function onSmith( ):void{ 
			Global.screenLobby.ShowScreen( new ScreenSmith( ) ); 
		}
		
		private function onGate( ):void{
			Global.screenLobby.ShowScreen( new ScreenMarket( ) );
		}
		private function onGuard( ):void{}
		private function onHospital( ):void{}
		
		private function onLord( ):void{
			Global.screenLobby.ShowScreen( new ScreenLord( ) );
		}
		
		private function onShop( ):void{}
		
	}
}