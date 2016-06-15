package game.display.Screens
{
	import flash.display.Bitmap;
	
	import core.gui.button.TypeButton;
	import core.gui.button.stretchButton;
	
	import game.assets.Assets;
	import game.display.ItemScreenBins.TabBins;
	import game.display.ItemScreenBins.TabTrophy;
	import game.display.ItemScreenBins.TabConsuned;
	import game.display.ItemScreenBins.TabResources;

	/**
	 * Закрома игрока
	 * @author volk
	 * 
	 */	
	public class ScreenBins extends baseScreen
	{
		/**
		 *трофеи 
		 */		
		private var m_btnBooty:stretchButton;
		
		private var m_btnResources:stretchButton;
		
		private var m_btnConsumed:stretchButton;
		
		private var m_tab:TabBins;
		
		protected var m_back:Bitmap;
		
		public function ScreenBins()
		{
			this.m_internalName = "ScreenBins";
			
			m_back = Assets.getBitmap( "background_storage" );
			addChild( m_back );
						
			m_btnBooty = new stretchButton( TypeButton.DIFFICULT_BLUE, 80, "Трофеи" );
			m_btnBooty.x = 53; m_btnBooty.y = 9;
			addChild( m_btnBooty );
			
			m_btnResources = new stretchButton( TypeButton.DIFFICULT_BLUE, 80, "Ресурсы" );
			m_btnResources.x = 235; m_btnResources.y = 9;
			addChild( m_btnResources );
			
			m_btnConsumed = new stretchButton( TypeButton.DIFFICULT_BLUE, 80, "Расходники" );
			m_btnConsumed.x = 418; m_btnConsumed.y = 9;
			addChild( m_btnConsumed );
			
			m_btnBooty.Click     = onBooty;
			m_btnResources.Click = onResources;
			m_btnConsumed.Click  = onConsumed;
			
			m_tab = new TabTrophy( this );
			addChild( m_tab );
		}
		
		
		private function onBooty():void{
			removeChild( m_tab );
			m_tab = new TabTrophy( this );
			addChild( m_tab );
		}
		
		private function onResources():void{
			removeChild( m_tab );
			m_tab = new TabResources( this );
			addChild( m_tab );
		}
		
		private function onConsumed():void{
			removeChild( m_tab );
			m_tab = new TabConsuned( this );
			addChild( m_tab );
		}
		
		
		override protected function onDestroy():void{
			m_back.bitmapData.dispose();
			m_back = null;
		}
		
	}
}