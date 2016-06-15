package game.display.Screens
{
	import core.gui.button.TypeButton;
	import core.gui.button.stretchButton;
	
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import game.assets.Assets;
	import game.display.ItmScreenAlchemist.TabAlchemist;
	import game.display.ItmScreenAlchemist.TabBuy;
	import game.display.ItmScreenAlchemist.TabCreate;
		
	//окно алхимика
	
	public class ScreenAlchemist extends baseScreen
	{
		
		private var m_back:Bitmap;
		private var m_title:TextField;
		
		private var m_btnCreate:stretchButton;
		private var m_btnBuy:stretchButton;
		
		private var m_tab:TabAlchemist;
		
		public function ScreenAlchemist()
		{
			super();
			
			this.m_internalName = "ScreenAlchemist";
			
			m_back = Assets.getBitmap( "back_alchemist" );
			addChild( m_back );
			
			m_title = new TextField();
			m_title.defaultTextFormat = new TextFormat( "Candara", 18, 0xFFFFFF );
			m_title.mouseEnabled = false;
			m_title.text = "Алхимик";
			m_title.autoSize = TextFieldAutoSize.LEFT;
			m_title.y = 5;
			m_title.x = m_back.width / 2 - m_title.width / 2;
			addChild( m_title );
			
			m_btnCreate = new stretchButton( TypeButton.DIFFICULT_BLUE, 80, "СВАРИТЬ" );
			m_btnCreate.x = 130; m_btnCreate.y = 190;
			addChild( m_btnCreate );
			
			m_btnBuy = new stretchButton( TypeButton.DIFFICULT_BLUE, 80, "КУПИТЬ" );
			m_btnBuy.x = 360; m_btnBuy.y = 190;
			addChild( m_btnBuy );
			
			m_btnCreate.Click = onCreateTab;
			m_btnBuy.Click = onBuyTab;
			
			m_tab = new TabCreate( this );
			addChild( m_tab );
		}
		
		private function onCreateTab():void{
			removeChild( m_tab );
			m_tab = new TabCreate( this );
			addChild( m_tab );
		}
		
		private function onBuyTab():void{
			removeChild( m_tab );
			m_tab = new TabBuy( this );
			addChild( m_tab );
		}		
		
		override protected function onDestroy():void{
			m_back.bitmapData.dispose();
			m_back = null;
		}
	}
}