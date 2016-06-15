package game.display.ItmScreenSmith
{
	import core.baseObject;
	
	import game.display.Screens.ScreenSmith;
	
	public class TabSmith extends baseObject
	{
		
		protected var m_screen:ScreenSmith;
		
		public function TabSmith( screen:ScreenSmith )
		{
			super();
			
			m_screen = screen;
		}
	}
}