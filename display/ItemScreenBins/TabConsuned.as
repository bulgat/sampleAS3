package game.display.ItemScreenBins
{
	import core.utils.ScrollBar;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import game.Global;
	import game.Managers.Managers;
	import game.assets.Assets;
	import game.display.Screens.ScreenBins;
	import game.gameplay.alchemy.basePotion;
	import game.gameplay.consumed.TypeConsumed;

	public class TabConsuned extends TabBins
	{
		private var m_scrollPanel:Sprite;
		private var m_scrollBar:ScrollBar;
		
		private var m_usedPotion:basePotion;
		
		private namespace CALLBACK;
		
		public function TabConsuned( screen:ScreenBins )
		{
			super( screen );
			
			m_scrollPanel = new Sprite();
			m_scrollPanel.x = 7;
			m_scrollPanel.y = 50;
			
			onFill( );
			
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}
		
		private function onAddedToStage( e:Event ):void{
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			
			CreateScroll();
		}
		
		private function CreateScroll():void{
			m_scrollBar = new ScrollBar( m_scrollPanel, new Rectangle( 0 , m_scrollPanel.y , m_scrollPanel.width, 468 ) );
			m_scrollBar.CreateScroll();
			m_scrollBar.Offset = 50;
			addChild(m_scrollBar);
		}
		
		override protected function onFill( ):void{
			var backName:Bitmap = Assets.getBitmap( "storage_trophy_bgr_name" );
			
			var nameTitle:TextField = new TextField();
			nameTitle.defaultTextFormat = new TextFormat( "Candara", 16, 0xFFFFFF );
			nameTitle.mouseEnabled = false;
			nameTitle.text = "Для героя";
			nameTitle.autoSize = TextFieldAutoSize.LEFT;
			nameTitle.x = backName.width / 2;
			
			m_scrollPanel.addChild( backName );
			m_scrollPanel.addChild( nameTitle );
			
			var potion:basePotion;
			var itm:ItmPotion;
			var dx:int = 0;
			var dy:int = 26;
			var count:uint = 0;
			var helper:uint = 0;
			for ( var i:int = 1; i <= 1000; i++ ){
				potion = Managers.potions.getPotionByGlobalID( i.toString() );
				if( potion!=null && Global.player.getPotion( i ) ){
					if ( potion.Mime == 'player' ){
						itm = new ItmPotion( potion, onUse );
						m_scrollPanel.addChild( itm );
						itm.x = dx;
						itm.y = dy;
						
						dx += itm.width + 4;
						
						count++;
						if ( count % 4 == 0 ){
							dx = 0;
							dy += itm.height + 2;
							count = 0;
						}
					}
					else{
						if ( helper == 0){
							helper = 1;
							
							if ( count % 4 != 0 ){
								dy += itm.height + 2;
								count = 0;
							}
							
							dx = 0;
							
							backName = Assets.getBitmap( "storage_trophy_bgr_name" );
							m_scrollPanel.addChild( backName );
							backName.y = dy;
														
							nameTitle = new TextField();
							nameTitle.defaultTextFormat = new TextFormat( "Candara", 16, 0xFFFFFF );
							nameTitle.mouseEnabled = false;
							nameTitle.text = "Против боссов";
							nameTitle.autoSize = TextFieldAutoSize.LEFT;
							nameTitle.x = backName.width / 2;
							nameTitle.y = dy;
							m_scrollPanel.addChild( nameTitle );
							
							var backType:Bitmap = Assets.getBitmap( "bgr_name_consumed" );
							backType.y = dy + 30;
							m_scrollPanel.addChild( backType );
							
							var titleType:TextField = new TextField();
							titleType.defaultTextFormat = new TextFormat( "Candara", 16, 0xFFFFFF );
							titleType.mouseEnabled = false;
							titleType.text = "Атаки";
							titleType.autoSize = TextFieldAutoSize.LEFT;
							titleType.x = backType.width / 2;
							titleType.y = dy + 30;
							m_scrollPanel.addChild( titleType );
							
							dy += 60;
						}
						else
						if ( potion.Mime == 'boss_protect' && helper == 1){
							helper = 2;
							
							if ( count % 4 != 0 ){
								dy += itm.height + 2;
								count = 0;
							}
							dx = 0;
														
							backType = Assets.getBitmap( "bgr_name_consumed" );
							backType.y = dy;
							m_scrollPanel.addChild( backType );
							
							titleType = new TextField();
							titleType.defaultTextFormat = new TextFormat( "Candara", 16, 0xFFFFFF );
							titleType.mouseEnabled = false;
							titleType.text = "Уловки";
							titleType.autoSize = TextFieldAutoSize.LEFT;
							titleType.x = backType.width / 2;
							titleType.y = dy;
							m_scrollPanel.addChild( titleType );
							
							dy += 30;
						}
						
						itm = new ItmPotion( potion, null );
						m_scrollPanel.addChild( itm );
						itm.x = dx;
						itm.y = dy;
						
						dx += itm.width + 4;
						
						count++;
						if ( count % 4 == 0 ){
							dx = 0;
							dy += itm.height + 2;
						}
					}
				}
			}
		}
		
		
		private function onUse( potion:basePotion ):void{
			m_usedPotion = potion;
			Global.Server.UsePotionForHeroes( Global.player.InternalID, m_usedPotion.GlobalID, CALLBACK::onUseGood, CALLBACK::onUseBad );
		}
		
		CALLBACK function onUseGood( response:Object ):void{
						
			if ( !m_usedPotion.Time ){
				
				for ( var key:* in m_usedPotion.Give ){
					switch ( TypeConsumed.Convert( key ) ){
						case TypeConsumed.HEALTH: Global.player.Health += int(m_usedPotion.Give[key]); break;
						case TypeConsumed.HONOR: Global.player.Honor += int(m_usedPotion.Give[key]); break;
						case TypeConsumed.EXP: Global.player.Exp += int(m_usedPotion.Give[key]); break;
					}
				}
								
				Global.player.setPotion( m_usedPotion.GlobalID, -1 );
			}
			else Global.player.ApplyPotion( m_usedPotion.Time, m_usedPotion.GlobalID );
			
			Refresh( );
		}
		
		CALLBACK function onUseBad( response:Object ):void{
			
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

import game.Global;
import game.assets.Assets;
import game.gameplay.alchemy.basePotion;

class ItmPotion extends baseObject{
	
	private var m_potion:basePotion;
	private var m_back:Bitmap;
	private var m_img:Bitmap;
	private var m_title:TextField;
	private var m_col:TextField;
	private var m_useBtn:stretchButton;
	private var m_icon:Bitmap;
	private var m_iconText:TextField = new TextField();
	private var m_callBack:Function;
	
	public function ItmPotion( potion:basePotion, callBack:Function ) {
		
		m_potion = potion;
		m_callBack = callBack;
		
		m_back = Assets.getBitmap( "background_storage_consumable" );
		addChild( m_back );
		
		m_title = new TextField();
		m_title.defaultTextFormat = new TextFormat( "Candara", 12, 0xFFFFAA );
		m_title.autoSize = TextFieldAutoSize.LEFT;
		m_title.text = potion.Name;
		m_title.mouseEnabled = false;
		m_title.x = 30;
		m_title.y = 5;
		addChild( m_title );
		
		m_col = new TextField();
		m_col.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000 );
		m_col.autoSize = TextFieldAutoSize.LEFT;
		m_col.text = "x"+Global.player.getPotion( m_potion.GlobalID );
		m_col.mouseEnabled = false;
		m_col.x = 8;
		m_col.y = 85;
		addChild( m_col );
		
		m_img = Assets.getBitmap( m_potion.Image );
		m_img.x = 4;
		m_img.y = 25;
		addChild( m_img );
		
		if ( potion.Mime == 'player' ){
			m_useBtn = new stretchButton( TypeButton.SIMPLE_GREEN, 10, "применить");
			m_useBtn.x = 68;
			m_useBtn.y = 75;
			m_useBtn.Click = onClick;
			addChild( m_useBtn );
			
			m_icon = Assets.getBitmap( "icon_clock" );
			m_iconText.text = String( potion.Time ) + ' сек.';
			m_icon.y = 50;
		}
		else{
			m_icon = Assets.getBitmap( "icon_damage" );
			m_iconText.text = '-100';
			m_icon.y = 50;
		}
		
		m_iconText.defaultTextFormat = new TextFormat( "Candara", 12, 0x000000 );
		m_iconText.autoSize = TextFieldAutoSize.LEFT;
		m_iconText.mouseEnabled = false;
		m_iconText.x = 85;
		m_iconText.y = 50;
		addChild( m_iconText );
		
		m_icon.x = 70;
		if ( potion.Time ){ 
			addChild( m_icon );
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
	}
	
}