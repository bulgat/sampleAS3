package game.display.ItmScreenSmith
{
	import core.utils.ScrollBar;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import game.Global;
	import game.Managers.Managers;
	import game.assets.Assets;
	import game.display.Screens.ScreenSmith;
	import game.gameplay.ammunition.Ammunition;
	import game.gameplay.ammunition.TypeAmmunition;
	import game.gameplay.consumed.TypeConsumed;
	
	public class TabSell extends TabSmith
	{
		
		private var m_panel:Sprite;
		private var m_scrollBar:ScrollBar;
		
		private var m_curAmmo:Ammunition;
		private var m_curType:TypeConsumed;
		private var m_curCost:int;
		
		private namespace CALLBACK;
		
		public function TabSell( screen:ScreenSmith )
		{
			super(screen);
			
			onFill();
			
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			
		}
		
		protected function onAddedToStage( e:Event ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			
			CreateScroll( );
			
		}
		
		private function CreateScroll( ):void{
			
			m_scrollBar = new ScrollBar( m_panel, new Rectangle( 0 , m_panel.y , 618, 345 ) );
			m_scrollBar.Background = Assets.getBitmap( "back_scroll_alchemist" );
			m_scrollBar.CreateScroll();
			m_scrollBar.x = 10;
			m_scrollBar.y = 220;
			m_scrollBar.Offset = 40;
			addChild( m_scrollBar );
		}
		
		private function onFill( ):void{
			
			m_panel = new Sprite( );
			
			var dx:int = 0;
			var dy:int = 0;
			var i:uint = 0;
			
			var ammunitions:Object = Managers.current_ammunitions.getAmmunitions();
			
			for each( var ammo:Ammunition in ammunitions ){
				
				if ( ammo.BaseAmmunition.Type == Managers.ammunitions.getAmmunitionByTypeString(TypeAmmunition.UNDERSUITS.toString()).Type ) continue;
				if ( ammo.BaseAmmunition.globalID == 900 ) continue;
				if ( ammo.Dress ) continue;
								
				var itm:ItmAmmo = new ItmAmmo( ammo, onSellAmmo );
				itm.x = dx;
				itm.y = dy;
				
				m_panel.addChild( itm );
				
				dx += 77;
				
				i++;
				
				if ( !(i % 8) ){
					
					dx = 0;
					dy += 174;
				}
				
			}
			
		}
		
		private function onSellAmmo( ammunition:Ammunition, type:TypeConsumed, cost:int ):void{
			
			m_curAmmo = ammunition;
			m_curType = type;
			m_curCost = cost;
			
			Global.Server.sellAmmunition( Global.player.InternalID, ammunition.BaseAmmunition.globalID.toString(), CALLBACK::onSellGood, CALLBACK::onSellBad );
			
		}
		
		CALLBACK function onSellGood( response:Object ):void{
			
			Managers.current_ammunitions.sellAmmunitionByID( m_curAmmo.BaseAmmunition.globalID.toString() );
			Global.player.addConsumed( m_curType, m_curCost );
			
			Refresh( );
		}
		
		CALLBACK function onSellBad( response:Object ):void{
			trace("не удалось продать предмет");
		}
		
		
		private function Refresh( ):void{
			
			removeChild( m_scrollBar );
			m_scrollBar = null;
			
			onFill();
			
			CreateScroll();
			
		}
		
		
	}
}

import core.baseObject;
import core.gui.button.TypeButton;
import core.gui.button.stretchButton;

import flash.display.Bitmap;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import game.assets.Assets;
import game.gameplay.ammunition.Ammunition;
import game.gameplay.consumed.TypeConsumed;

class ItmAmmo extends baseObject{
	
	private var m_back:Bitmap;
	private var m_strengthImg:Bitmap;
	private var m_costImg:Bitmap;
	private var m_ico:Bitmap;
	
	private var m_typeCost:TypeConsumed;
	private var m_cost:int;
	
	private var m_strength:TextField;
	private var m_costText:TextField;
	
	private var m_btnSell:stretchButton;
	private var m_ammunition:Ammunition;
	
	private var m_callBack:Function;
	
	public function ItmAmmo( ammunition:Ammunition, callBack:Function ){
		
		m_ammunition = ammunition;
		
		m_callBack = callBack;
		
		m_back = Assets.getBitmap( "back_smith_itm_03" );
		addChild( m_back );
		
		m_strengthImg = Assets.getBitmap( "icon_damage" );
		addChild( m_strengthImg );
		
		m_strength = new TextField( );
		m_strength.defaultTextFormat = new TextFormat( "Candara", 12, 0x000000 );
		m_strength.mouseEnabled = false;
		m_strength.text = ammunition.Health + "/" + ammunition.BaseAmmunition.Strength;
		m_strength.autoSize = TextFieldAutoSize.LEFT;
		m_strength.y = 0;
		m_strength.x = 20;
		addChild( m_strength );
		
		m_ico = ammunition.BaseAmmunition.Ico;
		addChild( m_ico );
		
		for( var key:* in ammunition.BaseAmmunition.PriceBuyCoin ){
			
			m_typeCost = TypeConsumed.Convert( key );
			m_cost = int( ammunition.BaseAmmunition.PriceBuyCoin[key] );
			
		}
		
		m_costText = new TextField( );
		m_costText.defaultTextFormat = new TextFormat( "Candara", 12, 0x000000, null, null, null, null, null, "center" );
		m_costText.mouseEnabled = false;
		m_costText.text = "стоимость\n" + Math.ceil( m_cost / 2 * ( ammunition.Health / ammunition.BaseAmmunition.Strength ) );
		m_costText.autoSize = TextFieldAutoSize.LEFT;
		m_costText.y = 112;
		m_costText.x = 5;
		addChild( m_costText );
		
		switch ( m_typeCost ){
			
			case TypeConsumed.GOLD_COIN:
				m_costImg = Assets.getBitmap( "icon_coin_gold_small" );
				break;
			case TypeConsumed.SILVER_COIN:
				m_costImg = Assets.getBitmap( "icon_coin_silver_small" );
				break;
			case TypeConsumed.COPPER_COIN:
				m_costImg = Assets.getBitmap( "icon_coin_copper_small" );
				break;
			
			default:
				m_costImg = Assets.getBitmap( "" );
				break;
	
		}
		
		m_costImg.x = 2;
		m_costImg.y = 125;
		addChild( m_costImg );
		
		m_btnSell = new stretchButton( TypeButton.SIMPLE_GREEN, 10, "продать" );
		m_btnSell.x = 1;
		m_btnSell.y = m_back.height - m_btnSell.height - 1;
		m_btnSell.Click = onSellClick;
		addChild( m_btnSell );
		
	}
	
	private function onSellClick( ):void{
		
		m_callBack( m_ammunition, m_typeCost, m_cost );
		
	}
	
	override protected function onDestroy():void{
		
		if ( m_back ){
			m_back.bitmapData.dispose();
			m_back = null;
		}
		
		if ( m_ico ){
			m_ico.bitmapData.dispose();
			m_ico = null;
		}
		
	}
	
}