package game.display.Screens
{
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.text.TextField;
	
	import core.baseObject;

	/**
	 * Окно ожидания / поднимаем пока ждем данных для отображения другого окна / 
	 * @author volk
	 * 
	 */	
	public class ScreenWait extends baseObject
	{
		private var m_message:String;
		
		private var m_txt:TextField;
		
		public function ScreenWait(  message:String )
		{
			DrawShape( );
			m_message  = message; 
			m_txt      = new TextField( );
			m_txt.text = m_message;
			addChild( m_txt );
			addEventListener( Event.ENTER_FRAME , onFrame , false , 0 , true );
			
		}
		
		private function DrawShape( ):void{
			var gr:Graphics = this.graphics;
			gr.lineStyle( 1 , 0xf0f0f0 , 0.5 );
			gr.beginFill( 0xf00f0f,0.5);
			gr.drawRect( 0,0,300,300);
			gr.endFill();
		}
		
		private function onFrame( event:Event ):void{
			//крутим аниммацию загрузки
		}
		
		override protected function onDestroy():void{
			m_txt = null;
			removeEventListener( Event.ENTER_FRAME , onFrame );
		}
		
	} 
}