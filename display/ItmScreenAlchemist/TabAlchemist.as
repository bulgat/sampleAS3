package game.display.ItmScreenAlchemist
{
	import core.baseObject;
	
	import game.display.Screens.ScreenAlchemist;
	
	public class TabAlchemist extends baseObject
	{
		
		protected var m_screen:ScreenAlchemist;
		
		public function TabAlchemist( screen:ScreenAlchemist )
		{
			super();
			
			m_screen = screen;
		}
	}
}