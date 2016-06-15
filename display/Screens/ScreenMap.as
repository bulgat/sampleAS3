package game.display.Screens
{
	import core.gui.button.filterButton;
	import core.gui.guiRoot;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.Global;
	import game.display.FittingRoom.pnl.PnlAmmunition;
	import game.display.Lobby.PnlRightLobby;
	import game.display.Lobby.ScreenLobby;

	/**
	 * игровая карта территорий 
	 * @author volk
	 * 
	 */	
	public class ScreenMap extends baseScreen
	{
		
		//королевства карта
		[Embed (source = "../../../../ResourcesGame/game/Screens/map/kingdom_map.png")]
		private static var KingdomMapClass:Class;
		
    	[Embed (source = "../../../../ResourcesGame/game/Screens/map/kingdom-1.png")]
		private static var Kingdom1Class:Class;
	
		[Embed (source = "../../../../ResourcesGame/game/Screens/map/kingdom-2.png")]
		private static var Kingdom2Class:Class;

		[Embed (source = "../../../../ResourcesGame/game/Screens/map/kingdom-3.png")]
		private static var Kingdom3Class:Class;
			
		[Embed (source = "../../../../ResourcesGame/game/Screens/map/kingdom-4.png")]
		private static var Kingdom4Class:Class;

		[Embed (source = "../../../../ResourcesGame/game/Screens/map/kingdom-5.png")]
		private static var Kingdom5Class:Class;
	
		[Embed (source = "../../../../ResourcesGame/game/Screens/map/kingdom-6.png")]
		private static var Kingdom6Class:Class;
		
		[Embed (source = "../../../../ResourcesGame/game/Screens/map/kingdom-7.png")]
		private static var Kingdom7Class:Class;
		
		//замки на картах
		[Embed (source = "../../../../ResourcesGame/game/Screens/map/castle-1.png")]
		private static var Castle1Class:Class;
		
		[Embed (source = "../../../../ResourcesGame/game/Screens/map/castle-2.png")]
		private static var Castle2Class:Class;
		
		[Embed (source = "../../../../ResourcesGame/game/Screens/map/castle-3.png")]
		private static var Castle3Class:Class;
		
		//граница
		[Embed (source = "../../../../ResourcesGame/game/Screens/map/borderline.png")]
		private static var BorderlineClass:Class;
			
		
		private var m_iBack:Bitmap;
		private var m_bK1:mapButton;
		private var m_bK2:mapButton;
		private var m_bK3:mapButton;
		private var m_bK4:mapButton;
		private var m_bK5:mapButton;
		private var m_bK6:mapButton;
		private var m_bK7:mapButton;
		private var m_borderline:Bitmap;
		
		private var m_castle1:filterButton;
		private var m_castle2:filterButton;
		private var m_castle3:filterButton;
		private var m_castle4:filterButton;
		private var m_castle5:filterButton;
		private var m_castle6:filterButton;
		private var m_castle7:filterButton;
		
		private var m_list:Vector.<mapButton>;
		
		private var m_currentMap:mapButton;
		
		public function ScreenMap( )
		{
			super( );
			
			m_internalName = "screenMap";
			m_bK1 = new mapButton( new Kingdom1Class () as Bitmap ); m_bK1.Click = MapClick; m_bK1.ReturnParams = new Array([0]);
			m_bK2 = new mapButton( new Kingdom2Class () as Bitmap ); m_bK2.Click = MapClick; m_bK2.ReturnParams = new Array([1]);
			m_bK3 = new mapButton( new Kingdom3Class () as Bitmap ); m_bK3.Click = MapClick; m_bK3.ReturnParams = new Array([2]);
			m_bK4 = new mapButton( new Kingdom4Class () as Bitmap ); m_bK4.Click = MapClick; m_bK4.ReturnParams = new Array([3]);
			m_bK5 = new mapButton( new Kingdom5Class () as Bitmap ); m_bK5.Click = MapClick; m_bK5.ReturnParams = new Array([4]);
			m_bK6 = new mapButton( new Kingdom6Class () as Bitmap ); m_bK6.Click = MapClick; m_bK6.ReturnParams = new Array([5]);
			m_bK7 = new mapButton( new Kingdom7Class () as Bitmap ); m_bK7.Click = MapClick; m_bK7.ReturnParams = new Array([6]);
			
			m_castle1 = new filterButton( new Castle1Class () as Bitmap ); m_castle1.Click = MapClick; m_castle1.ReturnParams = new Array([0]);
			m_castle2 = new filterButton( new Castle2Class () as Bitmap ); m_castle2.Click = MapClick; m_castle2.ReturnParams = new Array([1]);
			m_castle3 = new filterButton( new Castle2Class () as Bitmap ); m_castle3.Click = MapClick; m_castle3.ReturnParams = new Array([2]);
			m_castle4 = new filterButton( new Castle2Class () as Bitmap ); m_castle4.Click = MapClick; m_castle4.ReturnParams = new Array([3]);
			m_castle5 = new filterButton( new Castle2Class () as Bitmap ); m_castle5.Click = MapClick; m_castle5.ReturnParams = new Array([4]);
			m_castle6 = new filterButton( new Castle3Class () as Bitmap ); m_castle6.Click = MapClick; m_castle6.ReturnParams = new Array([5]);
			m_castle7 = new filterButton( new Castle3Class () as Bitmap ); m_castle7.Click = MapClick; m_castle7.ReturnParams = new Array([6]);
			
			m_iBack = new KingdomMapClass( ) as Bitmap;
			m_borderline = new BorderlineClass() as Bitmap;
						
			addChild( m_iBack );
			addChild( m_borderline );
			
			addChild( m_bK1 );
			addChild( m_bK2 );
			addChild( m_bK3 );
			addChild( m_bK4 );
			addChild( m_bK5 );
			addChild( m_bK6 );
			addChild( m_bK7 );
			
			addChild( m_castle1 );
			addChild( m_castle2 );
			addChild( m_castle3 );
			addChild( m_castle4 );
			addChild( m_castle5 );
			addChild( m_castle6 );
			addChild( m_castle7 );
			
			m_bK1.x = 244; m_bK1.y = 159;
			m_bK2.x = 162; m_bK2.y = 318;
			m_bK3.x =  57; m_bK3.y = 397;
			m_bK4.x =   9; m_bK4.y = 155;
			m_bK5.x =   4; m_bK5.y =   0;
			m_bK6.x = 155; m_bK6.y =   0;
			m_bK7.x = 438; m_bK7.y =   0;
			
			m_castle1.x = 310; m_castle1.y = 185;
			m_castle2.x = 255; m_castle2.y = 340;
			m_castle3.x = 270; m_castle3.y = 455;
			m_castle4.x = 20; m_castle4.y = 250;
			m_castle5.x = 160; m_castle5.y = 90;
			m_castle6.x = 410; m_castle6.y = 30; 
			m_castle7.x = 560; m_castle7.y = 130;
			
			m_list = new <mapButton>[ m_bK1 , m_bK2 ,m_bK3 ,m_bK4 ,m_bK5 ,m_bK6 , m_bK7];
	
			//addEventListener( Event.ENTER_FRAME , onFrame , false , 0 , true );
			addEventListener( MouseEvent.MOUSE_MOVE, CheckMouseOver , false , 0 , true );
		}
		
		private function MapClick( params:Array ):void{
			Global.screenLobby.ShowScreen( new ScreenListVillage( String( params[0] ) ) );
		}
		
		
		private function CheckMouseOver( e:MouseEvent ):void{
			//m_currentMap = null;
			
			for(var i:int = 0 ; i < m_list.length ; i++ ){
								
				if( m_list[i].isOver( guiRoot.MousePosition ) ){
					//m_currentMap = m_list[i];
				}
			}
		}
		/*
		private var m_i:int = 0;
		private var m_miss:int = 0;
		private function onFrame( event:Event ):void{
			m_miss++;
			if( m_miss > 3 ){
				m_miss = 0;
				for( m_i = 0 ; m_i< m_list.length ; m_i++ ){
					if( m_list[m_i].isOver( guiRoot.MousePosition  ) ){
						trace(m_list[]);
					}
				}
			}
		}
		*/
		override protected function onDestroy():void{
			//removeEventListener( Event.ENTER_FRAME , onFrame );
			removeEventListener( MouseEvent.MOUSE_MOVE, CheckMouseOver );
		}
	} 
}



import core.gui.button.filterButton;

import flash.display.Bitmap;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;
import flash.geom.Point;
import flash.ui.Mouse;
import flash.ui.MouseCursor;



class mapButton extends filterButton{

	private var m_over:Boolean = false;
	
	public function mapButton( bitmap:Bitmap ){
		super( bitmap );
		m_filter = [new GlowFilter( 0xFF1111, 1, 3, 3, 10, 3  ), m_colorMatrix];
	}
	
	private var m_pos:Point = new Point( );
	public function isOver( pos:Point ):Boolean{
		m_pos.setTo( pos.x , pos.y );
		m_pos = globalToLocal( m_pos );
		
		if( m_image.bitmapData.getPixel( m_pos.x , m_pos.y )!=0){ 
			OVER( );
			return true;
		}
		OUT( );
		return false;
	}
		
	public function OUT( ):void{
		if( !m_over ) return;
		m_over = false;	
		Mouse.cursor = MouseCursor.AUTO;    
		filters = null;
		if( m_Out!=null ) m_Out( );
	}
	
	public function OVER( ):void{
		if( m_over ) return;
		m_over = true;
		Mouse.cursor = MouseCursor.BUTTON;  
		filters  = m_filter;
		if( m_Over!=null ) m_Over( ); 
	}
	
	override protected function onOut  ( event:MouseEvent  ):void { 

	}
	
	override protected function onOver ( event:MouseEvent  ):void {

	}
	
	
}