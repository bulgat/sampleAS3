package game.display.Screens
{
	import core.gui.button.TypeButton;
	import core.gui.button.stretchButton;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import game.Managers.Managers;
	import game.assets.Assets;
	import game.display.Lobby.PnlRightLobby;
	import game.display.Lobby.ScreenLobby;
	import game.display.villageList.ItmVillageList;

	/**
	 * экран со списком деревень 
	 * @author volk
	 * 
	 */	
	public class ScreenListVillage extends baseScreen
	{
		private var m_title:TextField;
		
		private var m_bTitle:Bitmap;
		
		private var m_backTitle:Bitmap;
		
		private var m_imgGetAll:Bitmap;
		
		private var m_btnSendCollector:stretchButton;
		
		private var m_itmVillageLists:Vector.<ItmVillageList>;
		
		private var m_globalKingdomID:String;
		
		public function ScreenListVillage( globalKingdomID:String )
		{			
			m_globalKingdomID = globalKingdomID;
			
			m_internalName = "screenListVillage";	
			m_bTitle       = Assets.getBitmap( 'vill_list_bgr_name' );
			addChild( m_bTitle );
			
			m_backTitle = Assets.getBitmap( "vill_list_bgr_name" );
			m_backTitle.y = 2;
			
			m_title      = new TextField( );
			m_title.defaultTextFormat = new TextFormat( "Candara", 18, 0xffffff, true );
			m_title.autoSize = TextFieldAutoSize.LEFT;
			m_title.text = "<<" + Managers.kingdoms.getKingdomByGlobalID( m_globalKingdomID ).Name + ">>";
			m_title.x    = width/2 - m_title.width/2;
			m_title.y 	 = 2;
			m_title.mouseEnabled = false;
			
			m_imgGetAll = Assets.getBitmap( "vill_list_bgr_getall" );
			m_imgGetAll.x = 0;
			m_imgGetAll.y = 545;
			
			m_btnSendCollector   = new stretchButton( TypeButton.DIFFICULT_GREEN, 150, "послать сборщика дани за 2 " );
			m_btnSendCollector.x = this.width/2 - m_btnSendCollector.width/2;
			m_btnSendCollector.y = 545;
			m_btnSendCollector.Click = onSendCollector;
			
		}
		
		override protected function onAdd( event:Event ):void{
			removeEventListener( Event.ADDED_TO_STAGE  , onAdd );
			onFill( );
			
			addChild( m_backTitle );
			addChild( m_title );
			addChild( m_imgGetAll );
			addChild( m_btnSendCollector );
		}
		
		private function onFill( ):void{
			var dy:int = 30;
			var village:ItmVillageList;
			var count:int = 1;
			m_itmVillageLists = new Vector.<ItmVillageList>;
			for(var i:int = 0; i < 3; i++){
				village = new ItmVillageList( Assets.getBitmap( "village_img_" + count.toString() ), Managers.villages.getVillageByGlobalID( Managers.kingdoms.getKingdomByGlobalID( m_globalKingdomID ).getVillageIDByIndex(i).toString() ) , ScreenLobby(this.parent));
				village.y = dy;
				dy += 172;
				addChild( village );
				m_itmVillageLists.push( village );
				
				count++;
			}
			
		}
		
		/**
		 *послать сбощика  
		 */		
		private function onSendCollector( ):void{
			
		}
	}
}