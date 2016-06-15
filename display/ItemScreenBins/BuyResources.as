package game.display.ItemScreenBins
{
	import core.baseObject;
	import core.gui.button.TypeButton;
	import core.gui.button.buttonUpDown;
	import core.gui.button.stretchButton;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.text.TextField;
	
	import game.Global;
	import game.Managers.Managers;
	import game.assets.Assets;
	import game.display.Screens.ScreenBins;
	import game.gameplay.consumed.TypeConsumed;
	import game.gameplay.consumed.baseConsumed;
	
	/**
	 * окно докупа  ресурса
	 * @author volk
	 * 
	 */	
	public class BuyResources extends baseObject
	{
		[Embed(source="../../../../ResourcesGame/game/Screens/bins/winBuy.png")] 
		public static const back:Class;
		
		private var m_back:Bitmap;
		
		private var m_ico:Bitmap;
		
		private var m_consumed:baseConsumed;
		
		private var m_slider:controlSlider;
		
		private var m_btnClose:buttonUpDown;
		
		private var m_btnBuy:stretchButton;
		
		private var m_win:WinBuyResources;
		
		private var m_title:TextField;
		
		private var m_voices:TextField;
		
		private var m_refresh:Function;
		
		private namespace CALLBACK;
		
		public function BuyResources( win:WinBuyResources , consumed:baseConsumed, refresh:Function )
		{
			m_refresh = refresh;
			
			m_win = win;
			m_back     = new back( )as Bitmap;	
			addChild( m_back );
			
			m_consumed = consumed;
			m_ico = new Bitmap();
			m_ico = m_consumed.Ico;
			m_ico.x = 35;
			m_ico.y = 30;
			addChild( m_ico );
			
			m_slider = new controlSlider( consumed.Price, onUpdate );
			m_slider.x = 120;
			m_slider.y = 32;
			addChild( m_slider );
			
			m_voices = new TextField();
			m_voices.text = String( m_slider.Value / m_slider.Delta );
			m_voices.x = 150;
			m_voices.y = 32;
			m_voices.mouseEnabled = false;
			addChild( m_voices );
			
			m_btnClose = new buttonUpDown(  Assets.getBitmap("geton_close_normal_but") , Assets.getBitmap( "geton_close_press_but") );
			m_btnClose.x = 40;
			m_btnClose.y = 5;
			m_btnClose.Click = onClose;
			addChild( m_btnClose );
			
			m_title = new TextField();
			m_title.textColor = 0xFFFFFF;
			m_title.x = 60;
			m_title.y = 5;
			m_title.text = "Покупка ресурсов";
			m_title.selectable = false;
			m_title.mouseEnabled = false;
			addChild( m_title );
			
			m_btnClose = new stretchButton( TypeButton.SIMPLE_RED, 1, "Купить" );
			m_btnClose.x = 110;
			m_btnClose.y = 52;
			m_btnClose.Click = onBuy;
			addChild( m_btnClose );
		}
		
		private function onUpdate( ):void{
			m_voices.text = String( m_slider.Value / m_slider.Delta );
		}
		
		private function onBuy( ):void{
			trace('Покупаем ',m_consumed.Type.Value,' в количестве ',m_slider.Value,' за ',int(m_voices.text),' золотых');
			Global.Server.BuyConsumed( Global.player.InternalID, m_consumed.GlobalID, m_slider.Value, CALLBACK::onBuyGood, CALLBACK::onBuyBad );
		}
		
		CALLBACK function onBuyGood( response:Object ):void{
			trace('Покупка удалась');
			Global.player.addConsumed( m_consumed.Type , m_slider.Value );
			Global.player.addConsumed( TypeConsumed.GOLD_COIN , -int(m_voices.text) );
			
			m_refresh();
			
			m_win.onClose();
		}
		
		CALLBACK function onBuyBad( response:Object ):void{
			trace('Покупка не удалась');
		}

		private function onClose( ):void{
			m_win.onClose();
		}
		
		override protected function onDestroy():void{
			m_back.bitmapData.dispose();
			m_back = null;
			
			m_ico.bitmapData.dispose();
			m_ico = null;
		}
		
	}
}
import core.gui.baseCounter;
import core.gui.button.buttonUpDown;

import game.assets.Assets;

class controlSlider extends baseCounter{
	
	public function controlSlider( delta:int, callBack:Function = null ){
		
		super( callBack );
				
		m_btnDown = new buttonUpDown( Assets.getBitmap("geton_down_normal_but") , Assets.getBitmap("geton_downpress_normal_but") );
		m_btnUp = new buttonUpDown( Assets.getBitmap("geton_up_normal_but") , Assets.getBitmap("geton_uppress_normal_but") );
		m_backText = Assets.getBitmap( "window_number" );
		m_goldIco = Assets.getBitmap( "icon_coin_gold_small" );
		
		addChild( m_goldIco );
		addChild( m_backText );
		addChild( m_btnUp   );
		addChild( m_btnDown );
		
		m_btnDown.y = m_btnUp.height;
		
		m_text.x = -22;
		addChild( m_text );
		
		m_backText.x = -m_backText.width;
		
		m_goldIco.x = 10;
		m_goldIco.y = 0;
		
		Delta = delta;
		Value = Delta;
		
		m_btnDown.Click = onDown;
		m_btnUp.Click = onUp;
	}
}