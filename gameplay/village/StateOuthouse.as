package game.gameplay.village
{
	import game.gameplay.consumed.TypeConsumed;

	/**
	 * состояния сооружений в деревне 
	 * @author volk
	 * 
	 */	
	public final class StateOuthouse
	{
		
		private static var list:Object = new Object( );
		
		public static const UPGRADE:StateOuthouse    = new StateOuthouse( '0' );
		
		public static const PRODUCTION:StateOuthouse = new StateOuthouse( '1' );
		
		public static const UNKNOW:StateOuthouse     = new StateOuthouse( '10' );
		
		public function StateOuthouse( state:String )
		{
			m_value = state;
			list[state] = this;
		}
		
		public function get Value( ):String{
			return m_value;
		}
		
		public static function Convert(  state:String ):StateOuthouse{
			var t:StateOuthouse = list[state];
			if( t == null ) return StateOuthouse.UNKNOW;
			return t;
		}
		
		private var m_value:String;
	}
}