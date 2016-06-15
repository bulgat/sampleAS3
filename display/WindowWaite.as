package game.display
{
	
	
	import flash.display.Graphics;
	
	import core.baseObject;
	import core.chat.Message;

	/**
	 * Окно ожидания между командами ответа на запросы с клиента к серверу 
	 * @author volk
	 * 
	 */	
	public class WindowWaite extends baseObject
	{
		public function WindowWaite( msg:Message )
		{
			Draw( );
		}
		
		
		private function Draw( ):void{
			var g:Graphics = this.graphics;
			g.clear();
			g.lineStyle( 10,0xff0000,0.1);
			g.beginFill( 0xff000,0.1);
			g.drawRect(0,0,800,800);
			g.endFill();
			
		}
		override protected function onDestroy():void{
			
		}
	}
}