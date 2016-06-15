package game.display.FittingRoom.pnl
{
	import com.junkbyte.console.Cc;
	
	import core.baseObject;
	import core.gui.button.filterButton;
	import core.utils.ScrollBar;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import game.Global;
	import game.Managers.Managers;
	import game.display.Screens.ScreenAmmunition;
	import game.gameplay.ammunition.Ammunition;
	import game.gameplay.ammunition.TypeAmmunition;
	import game.gameplay.consumed.TypeConsumed;

	/**
	 * список аммуниции доступной для данного игрока согласно его  скилов и всего прочего 
	 * @author volk
	 * 
	 */	
	public class PnlAmmunition extends baseObject
	{
		[Embed(source="../../../../../ResourcesGame/game/FittingRoom/frame_background.png")]  
		public static const frame_background:Class;
		
		[Embed(source="../../../../../ResourcesGame/game/FittingRoom/background_all.png")]   
		public static const backgroundClass:Class;
		
		[Embed(source="../../../../../ResourcesGame/game/FittingRoom/arrow_frame.png")]  
		public static const arrow_frame:Class;
		
		[Embed(source="../../../../../ResourcesGame/game/FittingRoom/pointer_arrow.png")]  
		public static const pointer_arrow:Class;
		
		private var m_back:Bitmap;
		
		private var m_frame:Bitmap;
		
		private var m_list:Vector.<ItmAmmunition>;
		
		private var m_numberSlot:int;
		
		private var m_panel:Sprite;
		
		private var m_arrowFrame:Bitmap;
		
		private var m_arrow:filterButton;
		
		private var m_offset:uint = 163;
		
		private var m_hidePanel:Boolean = false;
		
		private var m_screen:ScreenAmmunition;
		
		private var m_scrollBar:ScrollBar;
		
		private var m_itmDress:Ammunition;
		
		private var m_itmTakeOff:Ammunition;
		
		private namespace CALLBACK;
		
		public function PnlAmmunition( scrAmmunition:ScreenAmmunition )
		{
			
			m_screen = scrAmmunition;
			m_list = new Vector.<ItmAmmunition>( );
			
			m_numberSlot = Managers.current_ammunitions.NumberSlot;
						
			m_panel = new Sprite( );
						
			onFillData() ;
			x = 485;
			
			m_back = new backgroundClass() as Bitmap;
			m_back.x = 0;
			m_back.y = 0;
			addChild( m_back );
			m_scrollBar = new ScrollBar( m_panel, new Rectangle( 0 , 2 , 145 , 571 ) );
			m_scrollBar.CreateScroll();
			m_scrollBar.Offset = 110;
			addChild(m_scrollBar);	
			
			m_frame = new frame_background() as Bitmap;
			m_frame.y = 1;
			m_frame.x = -3;
			addChild( m_frame );
						
			m_arrowFrame = new arrow_frame( ) as Bitmap;
			m_arrowFrame.x = -m_arrowFrame.width - 3;
			m_arrowFrame.y = m_screen.height / 2 - m_arrowFrame.height / 2;
			addChild( m_arrowFrame );
			
			m_arrow = new filterButton( new pointer_arrow( ) as Bitmap );
			m_arrow.x = -m_arrow.width - 4;
			m_arrow.y = m_screen.height / 2 - m_arrow.height / 2;
			m_arrow.Click = ArrowClick;
			addChild( m_arrow );
		}
		
		private function ArrowClick( ):void{
			m_hidePanel = !m_hidePanel;
			
			if ( m_hidePanel ){
				m_arrow.x += m_offset + m_arrow.width;
				m_panel.x += m_offset;
				m_arrowFrame.x += m_offset;
				m_frame.visible = false;
				m_scrollBar.visible = false;
				m_back.visible = false;
				
				m_screen.setOffset( ( m_offset - 3) / 2, 0);
			}
			else{
				m_arrow.x -= m_offset + m_arrow.width;
				m_panel.x -= m_offset;
				m_arrowFrame.x -= m_offset;
				m_frame.visible = true;
				m_scrollBar.visible = true;
				m_back.visible = true;
				
				m_screen.setOffset( ( -m_offset + 3 ) / 2, 0);
			}
			
			m_arrow.rotationY += 180;
		}	

		/**
		 * заполнияем панель данными 
		 * 
		 */		
		private function onFillData( ):void{ 
			var i:int = 0;
			var len:int = 2;
			var itm:ItmAmmunition;
			for each( var ammunition:* in Managers.current_ammunitions.getAmmunitions() ){
				
				if( (ammunition!=null) && 
					(ammunition.BaseAmmunition.Type != Managers.ammunitions.getAmmunitionByTypeString(TypeAmmunition.UNDERSUITS.toString()).Type )
				){
					if ( i > m_numberSlot ) break;
					
					i++;
					
					itm = new ItmAmmunition( this , ammunition ); 
					m_panel.addChild( itm );
					m_list.push( itm );
					
					if ( ammunition.Dress ) itm.on_Click( false );
				}
			}
			
			while ( i < m_numberSlot ){
				
				itm = new ItmAmmunition( this, null, true );
				m_panel.addChild( itm );
				m_list.push( itm );
				
				i++;
				
			}
			
			itm = new ItmAmmunition( this, null);
			m_panel.addChild( itm );
			m_list.push( itm );
			
			for( i = 0;i<m_list.length;i++){ 
				//m_list[ i ].x = 60+105*(i%len); 
				//m_list[ i ].y = 70+160*Math.floor(i/len);
				m_list[ i ].x = 72*(i%len); 
				m_list[ i ].y = 114*Math.floor(i/len) + 2; 
			}
		}
		
		public function onSelectItem( itm:Ammunition , send:Boolean ):void{
			m_itmDress = itm;
			
			if( m_itmDress ){
				if ( send )
					Global.Server.player_dressAmmunition( Global.player.InternalID , itm.BaseAmmunition.globalID.toString() , CALLBACK::onDressGood, CALLBACK::onDressFail );
				else{
					m_itmDress.Dress = true;
					m_screen.addAmmunition( m_itmDress );
					
					m_itmDress = null;	
				}
			}

		}
		
		public function onBuySlot( price:int ):void{
			if ( Global.player.subConsumed( TypeConsumed.GOLD_COIN, price ) )
				Global.Server.BuySlot( Global.player.InternalID, CALLBACK::onBuySlotGood, CALLBACK::onBuySlotBad );
			else
				trace('Не хватает денег');
		}
		
		CALLBACK function onBuySlotGood( response:Object ):void{
			m_numberSlot = int( response );
			
			Managers.current_ammunitions.NumberSlot = m_numberSlot;
			
			Refresh();
		}
		
		CALLBACK function onBuySlotBad( response:Object ):void{
			trace('Не удалось купить слот');
		}
		
		CALLBACK function onDressGood( response:Object ):void{
			
			var iter:ItmAmmunition;
			for each (iter in m_list ){
				if ( iter.m_info )
					if( iter.m_info.BaseAmmunition.Type == m_itmDress.BaseAmmunition.Type  ){
						
						if ( iter.m_info.Dress ){
							iter.m_info.Dress = false;
							iter.Refresh();
						}
						
					}	
			}
			
			m_itmDress.Dress = true;
			m_screen.addAmmunition( m_itmDress );
			
			m_itmDress = null;
		}
		
		CALLBACK function onDressFail( response:Object ):void{
			trace('Не удалось одеть предмет - ', response);
			m_itmDress = null;
		}
		
		public function onTakeOff( itm:Ammunition , send:Boolean ):void{
			m_itmTakeOff = itm;
			
			if ( m_itmTakeOff ){
				if ( send )
					Global.Server.player_takeOffAmmunition( Global.player.InternalID , String( m_itmTakeOff.BaseAmmunition.globalID ) , CALLBACK::onTakeOffGood , CALLBACK::onTakeOffBad );
				else CALLBACK::onTakeOffGood( null );
					
			}
		}
		
		CALLBACK function onTakeOffGood( response:Object ):void{
			m_screen.takeOff( m_itmTakeOff );
			m_itmTakeOff.Dress = false;
			
			m_itmTakeOff = null;
		}
		
		CALLBACK function onTakeOffBad( response:Object ):void{
			trace('Не удалось снять предмет - ', response);
			m_itmTakeOff = null;
		}
		
		private function Refresh( ):void{
			
			m_list = new Vector.<ItmAmmunition>( );
			
			removeChild( m_scrollBar );
			
			m_panel = new Sprite( );
			
			m_scrollBar = new ScrollBar( m_panel, new Rectangle( 0 , 2 , 145 , 571 ) );
			m_scrollBar.CreateScroll();
			m_scrollBar.Offset = 110;
			addChild(m_scrollBar);
			
			onFillData() ;
			
		}
		
		override protected function onDestroy():void{
			m_frame.bitmapData.dispose();
			m_frame = null;
			
			m_back.bitmapData.dispose();
			m_back = null;
		}
	}
}