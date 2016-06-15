package game.display.Screens
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import core.gui.button.TypeButton;
	import core.gui.button.iconButton;
	import core.gui.button.stretchButton;
	import core.utils.TimeToString;
	
	import game.Global;
	import game.Managers.Managers;
	import game.assets.Assets;
	import game.display.Lobby.ProgressPnlTop;
	import game.gameplay.alchemy.basePotion;
	import game.gameplay.consumed.TypeConsumed;

	public class ScreenAttackBoss extends baseScreen
	{
		
		private var m_back:Bitmap;
		private var m_backLord:Bitmap;
		private var m_backPlayer:Bitmap;
		private var m_sandWatch:Bitmap;
		
		private var m_nameLord:TextField;
		private var m_attackTxt:TextField;
		private var m_trickTxt:TextField;
		private var m_eventsTxt:TextField;
		private var m_leastTimeTxt:TextField;
		
		private var m_healthBar:ProgressPnlTop;
		
		private var m_attackBtn:iconButton;
		private var m_exitBtn:stretchButton;
		
		private var m_lord:MovieClip;
		
		private var m_infoWindow:InfoWindow;
		
		private var m_data:Object;
		
		private namespace CALLBACK;
		
		public function ScreenAttackBoss( data:Object )
		{
			super();
			this.m_internalName = "ScreenAttackBoss";
			
			if ( data['idBoss'] != null ){//значит попали сюда сразу
				
			}
			else m_data = data; //значит попали сюда из списка боссов
			
		}
		
		override protected function onAdd(event:Event):void{
			super.onAdd( event );
			
			m_backLord = Assets.getBitmap( "back_lord" );
			m_backLord.x = 25;
			m_backLord.y = 40;
			addChild( m_backLord );
			
			m_backPlayer = Assets.getBitmap( "back_lord" );
			m_backPlayer.x = 232;
			m_backPlayer.y = 40;
			addChild( m_backPlayer );
			
			m_lord = m_data['lord'];
			m_lord.x = 25;
			m_lord.y = 40;
			addChild( m_lord );
			
			m_back = Assets.getBitmap( "back_bossfight" );
			addChild( m_back );
			
			//заголовки
			m_nameLord = new TextField();
			m_nameLord.defaultTextFormat = new TextFormat( "Candara", 18, 0xffffff );
			m_nameLord.autoSize = TextFieldAutoSize.LEFT;
			m_nameLord.text = "Бой с лордом " + m_data['lord_name'];
			m_nameLord.mouseEnabled = false;
			m_nameLord.x = 30;
			m_nameLord.y = 5;
			addChild( m_nameLord );
			
			m_attackTxt = new TextField();
			m_attackTxt.defaultTextFormat = new TextFormat( "Candara", 18, 0xffffff );
			m_attackTxt.autoSize = TextFieldAutoSize.LEFT;
			m_attackTxt.text = "Атаки";
			m_attackTxt.mouseEnabled = false;
			m_attackTxt.x = 20;
			m_attackTxt.y = 260;
			addChild( m_attackTxt );
			
			m_trickTxt = new TextField();
			m_trickTxt.defaultTextFormat = new TextFormat( "Candara", 18, 0xffffff );
			m_trickTxt.autoSize = TextFieldAutoSize.LEFT;
			m_trickTxt.text = "Уловки";
			m_trickTxt.mouseEnabled = false;
			m_trickTxt.x = 338;
			m_trickTxt.y = 260;
			addChild( m_trickTxt );
			
			m_eventsTxt = new TextField();
			m_eventsTxt.defaultTextFormat = new TextFormat( "Candara", 18, 0xffffff );
			m_eventsTxt.autoSize = TextFieldAutoSize.LEFT;
			m_eventsTxt.text = "События";
			m_eventsTxt.mouseEnabled = false;
			m_eventsTxt.x = 440;
			m_eventsTxt.y = 31;
			addChild( m_eventsTxt );
			
			//--------------
			
			m_healthBar = new ProgressPnlTop(  Assets.getBitmap('emptyhealth_bar'), Assets.getBitmap('health_bar'), Assets.getBitmap( "ico_heart" ) );
			m_healthBar.Max = 3500;
			m_healthBar.Value = 2000;
			m_healthBar.x = 35;
			m_healthBar.y = 229;
			addChild( m_healthBar );
			
			m_attackBtn = new iconButton( Assets.getBitmap( "ico_flag" ), TypeButton.DIFFICULT_GREEN, 100, "удар оружием 100"  );
			m_attackBtn.x = 245;
			m_attackBtn.y = 225;
			m_attackBtn.Click = onAttack;
			addChild( m_attackBtn );
			
			m_exitBtn = new stretchButton( TypeButton.DIFFICULT_GREEN, 60, "ВЫЙТИ ИЗ БОЯ"  );
			m_exitBtn.x = 510;
			m_exitBtn.y = 5;
			m_exitBtn.Click = onExit;
			addChild( m_exitBtn );
			
			m_sandWatch = Assets.getBitmap( "clock_ico" );
			m_sandWatch.x = 424;
			m_sandWatch.y = 10;
			addChild( m_sandWatch );
			
			m_leastTimeTxt = new TextField();
			m_leastTimeTxt.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000 );
			m_leastTimeTxt.autoSize = TextFieldAutoSize.LEFT;
			m_leastTimeTxt.text = "до конца боя      " + TimeToString.ConvertTimeToString( 12345, true );
			m_leastTimeTxt.mouseEnabled = false;
			m_leastTimeTxt.x = 340;
			m_leastTimeTxt.y = 8;
			addChild( m_leastTimeTxt );
			
			m_infoWindow = new InfoWindow();
			m_infoWindow.x = 440;
			m_infoWindow.y = 63;
			addChild( m_infoWindow );
			
			onFillAttack( );
			onFillTrick( );
			
		}
		
		private function onFillAttack( ):void{
			
			var dx:int = 11;
			var dy:int = 292;
			
			for( var i:int = 100; i < 104; i++ ){
				
				var itm:ItmWindow = new ItmWindow( Managers.potions.getPotionByGlobalID( i.toString() ), onItmUse );
				itm.x = dx;
				itm.y = dy;
				addChild( itm );
				
				dx += 155;
				
				if ( i % 2 ){
					dx = 11;
					dy += 138;
				}
							
			}
			
		}
		
		private function onFillTrick( ):void{
			
			var dx:int = 327;
			var dy:int = 292;
			
			for( var i:int = 110; i < 114; i++ ){
				
				var itm:ItmWindow = new ItmWindow( Managers.potions.getPotionByGlobalID( i.toString() ), onItmUse );
				itm.x = dx;
				itm.y = dy;
				addChild( itm );
				
				dx += 155;
				
				if ( i % 2 ){
					dx = 327;
					dy += 138;
				}
				
			}
			
		}
		
		private function onItmUse( potion:basePotion ):void{
			m_infoWindow.sendMsg( "Использовали зелье " + String( potion.Name ) );
		}
		
		private function onAttack( ):void{
			m_infoWindow.sendMsg( "АТАКА" );
			Global.Server.HarmWeaponsBoss( Global.player.InternalID , CALLBACK::onGootAttack , CALLBACK::onFailedAttack );
		}
		
		private function onExit( ):void{
			m_infoWindow.sendMsg( "ВЫХОД" );
		}
		
	    CALLBACK function onGootAttack( resp:Object ):void{
			Global.player.addConsumed( TypeConsumed.HEALTH , -resp['damage_user'] );
			m_infoWindow.sendMsg( "Босс нанес вам урон " +resp['damage_user']+ "здоровья" );
		//			resp['spirit_user'] = $pl->getConsumed( Consumed::SPIRIT );
		    m_healthBar.Value = resp['health_boss']; 
			if( resp['text'] != null ){
				m_infoWindow.sendMsg( resp['text'] );
			}
		}
		
		CALLBACK function onFailedAttack( resp:Object ):void{
		
		}
	}
}


import core.baseObject;
import core.utils.ScrollBar;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import game.assets.Assets;
import game.gameplay.alchemy.basePotion;

class InfoWindow extends baseObject{
	
	private var m_text:TextField;
	private var m_scrollBar:ScrollBar;
	
	public function InfoWindow(){
			
		m_text = new TextField();
		m_text.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000, null, null, true, null, null, null, null, null, -10 );
		m_text.autoSize = TextFieldAutoSize.LEFT;
		m_text.width = 180;
		m_text.wordWrap = true;
		m_text.mouseEnabled = false;
		addChild( m_text );
		
		createScroll( );
		
	}
	
	private function createScroll( ):void{
		
		if ( m_scrollBar ) removeChild( m_scrollBar );
		
		m_text.y = 0;
		
		m_scrollBar = new ScrollBar( m_text, new Rectangle( 0, 0, 180, 180 ) );
		m_scrollBar.Offset = 10;
		m_scrollBar.Background = Assets.getBitmap( "chat_boss_attack_scroll_back" );
		m_scrollBar.CreateScroll();
		addChild( m_scrollBar );
		m_scrollBar.SetScrollPos( m_text.height );
	}
	
	public function sendMsg( msg:String ):void{
		
		m_text.appendText( msg + "\n\n");
		createScroll( );
	}
	
}

import game.Global;
import game.display.ItemScreenBins.WinBuyResources;
import core.gui.button.stretchButton;
import core.gui.button.TypeButton;

class ItmWindow extends baseObject{
	
	private var m_back:Bitmap;
	private var m_img:Bitmap;
	
	private var m_name:TextField;
	private var m_col:TextField;
	
	private var m_useBtn:stretchButton;
	private var m_buyBtn:stretchButton;
	
	private var m_potion:basePotion;
	
	private var m_onUse:Function;
	
	public function ItmWindow( potion:basePotion, onUseFun:Function ){
		
		m_potion = potion;
		
		m_onUse = onUseFun;
		
		m_back = Assets.getBitmap( "background_storage_consumable" );
		addChild( m_back );
		
		m_name = new TextField();
		m_name.defaultTextFormat = new TextFormat( "Candara", 14, 0xffffff );
		m_name.autoSize = TextFieldAutoSize.LEFT;
		m_name.mouseEnabled = false;
		m_name.text = m_potion.Name;
		m_name.x = 10;
		m_name.y = 3;
		addChild( m_name );
		
		m_img = Assets.getBitmap( m_potion.Image );
		m_img.x = 2;
		m_img.y = 25;
		addChild( m_img );
		
		m_col = new TextField();
		m_col.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000 );
		m_col.autoSize = TextFieldAutoSize.LEFT;
		m_col.mouseEnabled = false;
		m_col.text = "x" + Global.player.getPotion( m_potion.GlobalID );
		m_col.x = m_img.width / 2 + m_img.x - m_col.width / 2;
		m_col.y = 82;
		addChild( m_col );
		
		m_useBtn = new stretchButton( TypeButton.DIFFICULT_GREEN, 80, "АТАКОВАТЬ" );
		m_useBtn.x = 5;
		m_useBtn.y = 105;
		m_useBtn.Click = onUse;
		addChild( m_useBtn );
		
		m_buyBtn = new stretchButton( TypeButton.SIMPLE_RED, 1, "купить" );
		m_buyBtn.x = 85;
		m_buyBtn.y = 75;
		m_buyBtn.Click = onBuy;
		addChild( m_buyBtn );
		
	}
	
	private function onUse( ):void{
		m_onUse( m_potion );
	}
	
	private function onBuy( ):void{
		
	}
	
	override protected function onDestroy():void
	{
		
		if ( m_back ){
			m_back.bitmapData.dispose();
			m_back = null;
		}
		
	}
	
}