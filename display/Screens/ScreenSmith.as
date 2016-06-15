package game.display.Screens
{
	import core.gui.button.TypeButton;
	import core.gui.button.stretchButton;
	
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import game.assets.Assets;
	import game.display.ItmScreenSmith.*;
	
	public class ScreenSmith extends baseScreen
	{
		
		private var m_back:Bitmap;
		
		private var m_title:TextField;
		
		private var m_btnWeapon:stretchButton;
		private var m_btnProtect:stretchButton;
		private var m_btnRepair:stretchButton;
		private var m_btnSell:stretchButton;
		
		private var m_tab:TabSmith;
		
		public function ScreenSmith()
		{
			super();
			
			this.m_internalName = "ScreenSmith";
			
			m_back = Assets.getBitmap( "background_smith" );
			addChild( m_back );
			
			m_title = new TextField();
			m_title.defaultTextFormat = new TextFormat( "Candara", 18, 0xFFFFFF );
			m_title.mouseEnabled = false;
			m_title.text = "Кузнец";
			m_title.autoSize = TextFieldAutoSize.LEFT;
			m_title.y = 1;
			m_title.x = m_back.width / 2 - m_title.width / 2;
			addChild( m_title );
			
			m_btnWeapon = new stretchButton( TypeButton.DIFFICULT_BLUE, 60, "ОРУЖИЕ" );
			m_btnWeapon.x = 25; m_btnWeapon.y = 188;
			addChild( m_btnWeapon );
			
			m_btnProtect = new stretchButton( TypeButton.DIFFICULT_BLUE, 60, "ДОСПЕХИ" );
			m_btnProtect.x = m_btnWeapon.x + 150 ; m_btnProtect.y = 188;
			addChild( m_btnProtect );
			
			m_btnRepair = new stretchButton( TypeButton.DIFFICULT_BLUE, 60, "РЕМОНТ" );
			m_btnRepair.x = m_btnProtect.x + 150; m_btnRepair.y = 188;
			addChild( m_btnRepair );
			
			m_btnSell = new stretchButton( TypeButton.DIFFICULT_BLUE, 60, "ПРОДАЖА" );
			m_btnSell.x = m_btnRepair.x + 150; m_btnSell.y = 188;
			addChild( m_btnSell );
			
			m_btnWeapon.Click = onWeaponTab;
			m_btnProtect.Click = onBuyTab;
			m_btnRepair.Click = onRepairTab;
			m_btnSell.Click = onSellTab;
			
			m_tab = new TabSell( this );
			addChild( m_tab );
			
		}
		
		private function onWeaponTab():void{
			removeChild( m_tab );
			m_tab = new TabWeapon( this );
			addChild( m_tab );
		}
		
		private function onBuyTab():void{
			removeChild( m_tab );
			m_tab = new TabProtect( this );
			addChild( m_tab );
		}
		
		private function onRepairTab():void{
			removeChild( m_tab );
			m_tab = new TabRepair( this );
			addChild( m_tab );
		}
		
		private function onSellTab():void{
			removeChild( m_tab );
			m_tab = new TabSell( this );
			addChild( m_tab );
		}
		
		
	}
}