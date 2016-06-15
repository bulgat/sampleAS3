package game.display.domain
{
	import flash.text.TextField;
	
	import core.baseObject;
	import core.gui.button.baseButton;
	
	import game.display.font.Font;

	public class ItmDomain extends baseObject
	{
		/**
		 * кнопка собрать дань 
		 */		
		private var m_btnCollectTribute:baseButton;
		
		private var m_label:TextField;
		
		private var m_data:Object;
		
		public function ItmDomain( data:Object )
		{
			m_label = new TextField( );
			addChild( m_label );
		}
		
		private function parse( data:Object ):void{
			
		}
		
	}
}