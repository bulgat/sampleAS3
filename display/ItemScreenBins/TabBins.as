package game.display.ItemScreenBins
{
	import flash.display.Bitmap;
	
	import core.baseObject;
	
	import game.assets.Assets;
	import game.display.Screens.ScreenBins;


	public class TabBins extends baseObject
	{
		
		public var m_screen:ScreenBins;
		
		public function TabBins( screen:ScreenBins )
		{
			m_screen = screen;
		}
		
		protected function onFill(  ):void{
		
		}
		
	}
}