package game.display.Lobby
{
	import core.Events.GeneralDispatcher;
	import core.baseObject;
	import core.gui.button.buttonUpDown;
	import core.gui.button.txtButton;
	import core.gui.guiRoot;
	import core.gui.progress.Progress;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.sensors.Accelerometer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import game.Global;
	import game.Managers.ManagerSound;
	import game.Managers.Managers;
	import game.assets.Assets;
	import game.display.Screens.ScreenBank;
	import game.gameplay.EventGame;
	import game.gameplay.ammunition.TypeAmmunition;
	import game.gameplay.consumed.TypeConsumed;

	/**
	 * верхняя панель - содержит прогрессы и доп табы к продажам 
	 * @author volk
	 * 
	 */	
	public class PnlTop extends baseObject
	{
		[Embed(source="../../../../ResourcesGame/game/Lobby/topPanel/top_background.png")]    
		public static const top_background:Class
		
		private var m_back:Bitmap;
		
		private var m_rb:Bitmap;
		
		private var m_btnCopper:TabSquare;
		private var m_btnGold:TabSquare;
		private var m_btnSilver:TabSquare;
		private var m_btnHorseshoe:TabSquare;
		
		/**
		 *правитель 
		 */		
		private var m_btnRuler:txtButton;
		private var m_btnShop:txtButton; 
		private var m_btnArmorer:txtButton;
		private var m_btnAlchemist:txtButton;
		private var m_btnGuard:txtButton;
		private var m_btnGarden:txtButton;
		private var m_btnGate:txtButton;
		private var m_btnHospital:txtButton;
		
		//--прогресс бары
		private var m_pb1:ProgressPnlTop;
		private var m_pb2:ProgressPnlTop;
		private var m_pb3:ProgressPnlTop;
		
		private var m_countSkull:ItmConsumed;
		private var m_countCharter:ItmConsumed;
		private var m_countStellGlove:ItmConsumed;
		//координаты маленьких иконок Черепа, Карты и Перчатки
		private var countSkullCharterGlove_0_y:int=0;
		private var countSkullCharterGlove_1_y:int=22;
		private var countSkullCharterGlove_2_y:int=44;
		
		//иконки звука, музыки, справки и рыцаря
		private var m_soundBtn:buttonUpDown;
		private var m_musicBtn:buttonUpDown;
		private var m_questionBtn:buttonUpDown;
		private var m_knightBtn:buttonUpDown;
		
		private var m_screenLobby:ScreenLobby;
		
		private var m_dispatcher:GeneralDispatcher;
		
		public function PnlTop( screenLobby:ScreenLobby )
		{
			m_screenLobby = screenLobby;
			
			m_back = new top_background as Bitmap;
			addChild( m_back  );
			
			m_soundBtn = new buttonUpDown( Assets.getBitmap( "button_sound_normal" ), Assets.getBitmap( "button_sound_press" ), "", -1, 1 );
			m_musicBtn = new buttonUpDown( Assets.getBitmap( "button_music_normal" ), Assets.getBitmap( "button_music_press" ), "", -1, 1 );
			m_questionBtn = new buttonUpDown( Assets.getBitmap( "button_information_normal" ), Assets.getBitmap( "button_information_press" ), "", -1, 1 );
			m_knightBtn = new buttonUpDown( Assets.getBitmap( "button_settings_normal" ), Assets.getBitmap( "button_settings_press" ), "", -1, 1 );
			
			if ( !ManagerSound.isSound ) m_soundBtn.setUpImg( Assets.getBitmap( "button_sound_off" ) );
			
			if ( !ManagerSound.isMusic ) m_musicBtn.setUpImg( Assets.getBitmap( "button_music_off" ) );
			
			m_soundBtn.x = 20; m_soundBtn.y = 3;
			m_musicBtn.x = 50; m_musicBtn.y = 3;
			m_questionBtn.x = 20; m_questionBtn.y = 33;
			m_knightBtn.x = 50; m_knightBtn.y = 33;
			
			m_soundBtn.Click = SoundClick;
			m_musicBtn.Click = MusicClik;
			m_questionBtn.Click = QuestionClick;
			m_knightBtn.Click = KnightClick;
			
			addChild( m_soundBtn );
			addChild( m_musicBtn );
			addChild( m_questionBtn );
			addChild( m_knightBtn );
			
			m_btnCopper  = new TabSquare( 'купить' , Global.player.getConsumed( TypeConsumed.COPPER_COIN ), Assets.getBitmap( TypeConsumed.COPPER_COIN.Value + "_ico" ), onBuyClick );
			m_btnGold = new TabSquare( 'купить' , Global.player.getConsumed( TypeConsumed.GOLD_COIN ), Assets.getBitmap( TypeConsumed.GOLD_COIN.Value + "_ico" ), onBuyClick );
			m_btnSilver = new TabSquare( 'купить' , Global.player.getConsumed( TypeConsumed.SILVER_COIN ), Assets.getBitmap( TypeConsumed.SILVER_COIN.Value + "_ico" ), onBuyClick ); 
			m_btnHorseshoe = new TabSquare( 'купить' , Global.player.getConsumed( TypeConsumed.HORSESHOE_COIN ), Assets.getBitmap( TypeConsumed.HORSESHOE_COIN.Value + "_ico" ), onBuyClick );
			
			m_countSkull = new ItmConsumed( Assets.getBitmap( "ico_skull" ), 1500 ); 
		    addChild( m_countSkull );
			m_countSkull.x = 390;
			m_countSkull.y = countSkullCharterGlove_0_y;
			
			m_countCharter = new ItmConsumed( Assets.getBitmap( "ico_charter" ), 1500 );   
			addChild( m_countCharter ); 
			m_countCharter.x = m_countSkull.x;
			m_countCharter.y = countSkullCharterGlove_1_y;
			
			m_countStellGlove = new ItmConsumed( Assets.getBitmap( "ico_stell_glove" ), 1500 );   
			addChild( m_countStellGlove ); 
			m_countStellGlove.x = m_countSkull.x;
			m_countStellGlove.y = countSkullCharterGlove_2_y;
			

			addChild( m_btnCopper );  m_btnCopper.x = 480; m_btnCopper.y = 5;
			addChild( m_btnGold );  m_btnGold.x = m_btnCopper.x+83; m_btnGold.y = 5;
			addChild( m_btnSilver );  m_btnSilver.x = m_btnGold.x+83; m_btnSilver.y = 5;
			addChild( m_btnHorseshoe );  m_btnHorseshoe.x = m_btnSilver.x+83; m_btnHorseshoe.y = 5;
			
			initProgress( );
			
			m_dispatcher = new GeneralDispatcher( );
			m_dispatcher.addEventListener( EventGame.UPDATE.Type , onUpdate  );
		}
		
		private function KnightClick():void
		{
			
		}
		
		private function QuestionClick():void
		{
			
		}
		
		private function MusicClik():void
		{
			ManagerSound.isMusic = !ManagerSound.isMusic;
			
			if ( ManagerSound.isMusic )
				m_musicBtn.setUpImg( Assets.getBitmap( "button_music_normal" ) );
			else
				m_musicBtn.setUpImg( Assets.getBitmap( "button_music_off" ) );
		}
		
		private function SoundClick():void
		{
			ManagerSound.isSound = !ManagerSound.isSound;
			
			if ( ManagerSound.isSound )
				m_soundBtn.setUpImg( Assets.getBitmap( "button_sound_normal" ) );
			else
				m_soundBtn.setUpImg( Assets.getBitmap( "button_sound_off" ) );
		}
		
		/**
		 * поднимается на любой апдейт неважно чего
		 */
		private function onUpdate( event:Event ):void{
			//ап прогрессов
			m_pb1.Value = Global.player.Honor;
			m_pb2.Value = Global.player.Health;
			m_pb1.Value = Global.player.Honor;
			//ап значений расходников
			m_btnCopper.setLabel   ( Global.player.getConsumed( TypeConsumed.COPPER_COIN    ).toString() ) ;
			m_btnGold.setLabel     ( Global.player.getConsumed( TypeConsumed.GOLD_COIN      ).toString() ) ;
			m_btnSilver.setLabel   ( Global.player.getConsumed( TypeConsumed.SILVER_COIN    ).toString() ) ;  
			m_btnHorseshoe.setLabel( Global.player.getConsumed( TypeConsumed.HORSESHOE_COIN ).toString() ) ;
			
			m_countSkull.setLabel	  ( Global.player.getConsumed( TypeConsumed.SKULL   ).toString() );
			m_countCharter.setLabel	  ( Global.player.getConsumed( TypeConsumed.CHARTER ).toString() );
			m_countStellGlove.setLabel( Global.player.getConsumed( TypeConsumed.GLOVE   ).toString() );
		}
		
		private function onBuyClick( ):void{
			if( m_screenLobby.CurrentScreen != "ScreenBank" )  
				m_screenLobby.ShowScreen( new ScreenBank( )  );
		}
		
		private function initProgress( ):void{
			
			m_pb1 = new ProgressPnlTop(  Assets.getBitmap('emptyspirit_bar'), Assets.getBitmap('spirit_bar'), Assets.getBitmap( "ico_flag" ) );
			m_pb2 = new ProgressPnlTop(  Assets.getBitmap('emptyhealth_bar'), Assets.getBitmap('health_bar'), Assets.getBitmap( "ico_heart" ) );
			m_pb3 = new ProgressPnlTop(  Assets.getBitmap('emptyexpirience_bar'), Assets.getBitmap('expirience_bar'), Assets.getBitmap( "ico_star" ) );
			
			addChild( m_pb1 ); m_pb1.x = 110; m_pb1.y = 23;
			addChild( m_pb2 ); m_pb2.x = m_pb1.x; m_pb2.y = 2;
			addChild( m_pb3 ); m_pb3.x = m_pb1.x; m_pb3.y = 45;

			m_pb1.Max = 1500;
			m_pb1.Value = Math.ceil( Global.player.Honor );
			
			m_pb2.Max = 1500;
			m_pb2.Value = Math.ceil( Global.player.Health );
			
			m_pb3.Max = 2500;
			m_pb3.Value = Math.ceil( Global.player.Exp );
		}
	}
}

import core.baseObject;
import core.gui.button.TypeButton;
import core.gui.button.stretchButton;
import core.gui.button.txtButton;

import flash.display.Bitmap;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import game.assets.guiAsset;
import game.display.font.Font;

class TabSquare extends baseObject{

	private var m_back:Bitmap;

	private var m_button:stretchButton;
	
	private var m_ico:Bitmap;
	
	private var m_label:TextField;
	
	//координаты расположения картинки монеты
	private static var indentIconMoney_x:int = 0;
	private static var indentIconMoney_y:int = 0;
	//координаты расположения картинки текста
	private static var indentIconText_x:int = 25;
	private static var indentIconText_y:int = 5;
	
	public function TabSquare( label:String , count:int, ico:Bitmap , onBuyClick:Function ){
		
		m_ico = ico; 
		m_ico.x = indentIconMoney_x;
		m_ico.y = indentIconMoney_y;
		addChild( m_ico );
		
		m_label = new TextField( );
		
		m_label.defaultTextFormat = Font.mainFont_13;
		m_label.text = count.toString();
		m_label.autoSize = TextFieldAutoSize.LEFT;
		m_label.x = indentIconText_x;
		m_label.y = indentIconText_y;
		m_label.mouseEnabled = false;
		addChild( m_label );
		
		m_button = new stretchButton( TypeButton.SIMPLE_RED, 5 , label );
		m_button.LabelColor = 0xFFE770;
		m_button.Click = onBuyClick;
		addChild( m_button );
		
		m_button.x = 0;
		m_button.y = m_button.height + 8;
	}
	
	public function setLabel( label:String ):void{
		m_label.text = label; 
	}
}

class ItmConsumed extends baseObject{
	
	private var m_img:Bitmap;
	private var m_label:TextField;

	public function ItmConsumed( img:Bitmap, count:int ){
		
		m_img = img;
		addChild( m_img );
		
		m_label = new TextField();
		m_label.defaultTextFormat = new TextFormat( "Candara", 16, 0x000000 );
		m_label.autoSize = TextFieldAutoSize.LEFT;
		m_label.text = String( count );
		m_label.mouseEnabled = false;
		m_label.x = m_img.width + 2;
		m_label.y = 0;
		addChild( m_label );
		
	}
	
	public function setLabel( text:String ):void{
		
		m_label.text = String( text );
		
	}
	
	override protected function onDestroy():void{
		if ( m_img ){
			m_img.bitmapData.dispose();
			m_img = null;
		}
	}
	
}