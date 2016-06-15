package game.display.ItmScreenAlchemist
{
	import core.utils.ScrollBar;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import game.Global;
	import game.Managers.Managers;
	import game.assets.Assets;
	import game.display.ItmScreenAlchemist.TabAlchemist;
	import game.display.Screens.ScreenAlchemist;
	import game.gameplay.alchemy.basePotion;
	import game.gameplay.consumed.TypeConsumed;

	public class TabBuy extends TabAlchemist
	{
		private var m_scrollPanel:Sprite;
		private var m_scrollBar:ScrollBar;
		
		private var m_usedPotion:basePotion;
		
		private namespace CALLBACK;
		
		public function TabBuy( screen:ScreenAlchemist )
		{
			super( screen );
			
			m_scrollPanel = new Sprite();
			
			onFill( );
			
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}
		
		private function onAddedToStage( e:Event ):void{
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			
			m_scrollBar = new ScrollBar( m_scrollPanel, new Rectangle( 0 , m_scrollPanel.y , m_scrollPanel.width, 345 ) );
			m_scrollBar.Background = Assets.getBitmap( "back_scroll_alchemist" );
			m_scrollBar.CreateScroll();
			m_scrollBar.x = 8;
			m_scrollBar.y = 223;
			m_scrollBar.Offset = 50;
			addChild(m_scrollBar);
		}
		
		private function onFill( ):void{
			
			var dx:int = 0;
			var dy:int = 0;
			var count:uint = 0;
			
			for(var i:int = 1; i < 1000; i++){
				var potion:basePotion = Managers.potions.getPotionByGlobalID( i.toString() );
				
				if ( potion ){
					var itmPotion:ItmPotion = new ItmPotion( potion, onBuy );
					itmPotion.x = dx;
					itmPotion.y = dy;
					m_scrollPanel.addChild( itmPotion );
					
					dx += itmPotion.width;
					
					count++;
					
					if ( count == 3 ){
						count = 0;
						dx = 0;
						dy += itmPotion.height;
					}
				}
			}
		}
		
		private function onBuy( potion:basePotion ):void{
			m_usedPotion = potion;
			
			for(var key:* in potion.Price){
				if ( Global.player.subConsumed( TypeConsumed.Convert( key ), potion.Price[key] ) )
					Global.Server.BuyPotion( Global.player.InternalID, m_usedPotion.GlobalID, CALLBACK::onBuyGood, CALLBACK::onBuyBad );
			}
		}
		
		CALLBACK function onBuyGood( response:Object ):void{
			trace('Покупка удалась');
			
			Global.player.setPotion( m_usedPotion.GlobalID, 1 );
			
			Refresh( );
		}
		
		CALLBACK function onBuyBad( response:Object ):void{
			trace('Покупка не удалась');
		}
		
		private function Refresh( ):void{
			while ( m_scrollPanel.numChildren ){
				
				var child:* = m_scrollPanel.getChildAt( 0 )
				
				if ( child is Bitmap ){
					child.bitmapData.dispose();
				}
				
				m_scrollPanel.removeChild( child );
				
				child = null;
			}
			
			onFill();
		}
		
	}
}

import core.baseObject;
import core.gui.button.TypeButton;
import core.gui.button.iconButton;

import flash.display.Bitmap;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import game.Global;
import game.assets.Assets;
import game.gameplay.alchemy.basePotion;
import game.gameplay.consumed.TypeConsumed;

class ItmPotion extends baseObject{
	
	private var m_potion:basePotion;
	private var m_back:Bitmap;
	private var m_img:Bitmap;
	private var m_title:TextField;
	private var m_col:TextField;
	private var m_buyBtn:iconButton;
	private var m_iconVector:Vector.<Bitmap> = new Vector.<Bitmap>;
	private var m_callBack:Function;
	
	public function ItmPotion( potion:basePotion, callBack:Function ) {
		
		m_potion = potion;
		m_callBack = callBack;
		
		m_back = Assets.getBitmap( "back_alchemist_icon" );
		addChild( m_back );
		
		m_title = new TextField();
		m_title.defaultTextFormat = new TextFormat( "Candara", 14, 0xFFFFFF );
		m_title.autoSize = TextFieldAutoSize.LEFT;
		m_title.text = potion.Name;
		m_title.mouseEnabled = false;
		m_title.x = 10;
		m_title.y = 3;
		addChild( m_title );
		
		m_img = Assets.getBitmap( m_potion.Image );
		m_img.x = 4;
		m_img.y = 28;
		addChild( m_img );
		
		m_col = new TextField();
		m_col.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000 );
		m_col.autoSize = TextFieldAutoSize.LEFT;
		m_col.text = "x"+Global.player.getPotion( m_potion.GlobalID );
		m_col.mouseEnabled = false;
		m_col.x = m_img.x + m_img.width / 2  - m_col.width / 2;
		m_col.y = 88;
		addChild( m_col );
		
		for( var key:* in m_potion.Price ){
			
			switch ( TypeConsumed.Convert( key ) ){
				case TypeConsumed.GOLD_COIN:
					m_buyBtn = new iconButton( Assets.getBitmap( "icon_coin_gold_small" ), TypeButton.DIFFICULT_GREEN, 70, "купить за " + m_potion.Price[key]);
					break;
				case TypeConsumed.SILVER_COIN:
					m_buyBtn = new iconButton( Assets.getBitmap( "icon_coin_silver_small" ), TypeButton.DIFFICULT_GREEN, 70, "купить за " + m_potion.Price[key]);
					break;
				case TypeConsumed.COPPER_COIN:
					m_buyBtn = new iconButton( Assets.getBitmap( "icon_coin_copper_small" ), TypeButton.DIFFICULT_GREEN, 70, "купить за " + m_potion.Price[key]);
					break;
				default:
					m_buyBtn = new iconButton( Assets.getBitmap( "unknow" ), TypeButton.DIFFICULT_GREEN, 70, "купить за " + m_potion.Price[key]);
					break;
			}
			
		}
		
		m_buyBtn.x = 75;
		m_buyBtn.y = 85;
		m_buyBtn.Click = onClick;
		addChild( m_buyBtn );
		
		
		var dx:int = 80;
		var dy:int = 30;
		for( key in m_potion.Give ){
			
			var icon:Bitmap;
			
			switch( TypeConsumed.Convert(key) ){
				case TypeConsumed.HEALTH:
					icon = Assets.getBitmap("ico_heart");
					break;
				case TypeConsumed.HONOR:
					icon = Assets.getBitmap("ico_flag");
					break;
				case TypeConsumed.EXP:
					icon = Assets.getBitmap("ico_star");
					break;
				case TypeConsumed.ATTACK:
					icon = Assets.getBitmap("icon_damage");
					break;
				case TypeConsumed.PROTECT:
					icon = Assets.getBitmap("icon_shield");
					break;
			}
			
			icon.x = dx;
			icon.y = dy;
			addChild( icon );
			
			var text:TextField = new TextField(); 
			text.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000 );
			text.autoSize = TextFieldAutoSize.LEFT;
			text.text = "+" + m_potion.Give[key];
			text.mouseEnabled = false;
			text.x = icon.x + 20;
			text.y = dy - 5;
			addChild( text );
			
			m_iconVector.push( icon );
			dy += icon.height + 5;
		}
		
	}
	
	private function onClick( ):void{
		m_callBack( m_potion );
	}
	
	override protected function onDestroy():void{
		if ( m_back ){
			m_back.bitmapData.dispose();
			m_back = null;
		}
		if ( m_img ){
			m_img.bitmapData.dispose();
			m_img = null;
		}
		
		while(m_iconVector.length){
			m_iconVector.pop().bitmapData.dispose();
		}
		m_iconVector = null;
	}
	
}