package game.display.Screens
{
	import flash.display.Bitmap;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	public class ScreenLord extends baseScreen
	{
		[Embed(source="../../../../ResourcesGame/game/Screens/lord/lord.jpg")]   
		public static const lordBack:Class
		
		private var m_iBack:Bitmap;
		
		public function ScreenLord()
		{
			Mouse.cursor = MouseCursor.AUTO;
			
			this.m_internalName = "ScreenLord";
			m_iBack = new lordBack( ) as Bitmap;
			addChild( m_iBack );
		}
		
		override protected function onDestroy():void{
			m_iBack.bitmapData.dispose();
			m_iBack = null;
		}
	}
}