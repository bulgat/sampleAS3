package game.display.notice
{
	/**
	 * костыльный конечно вариант, но пойдет / лажа
	 * никому не показывать ;)
	 * Костыль рожден не определенностью изначально с уведомлениями
	 * @author volk
	 * 
	 */	
	public final class TypeNotice
	{		
		public static const VILLAGE_UPGRADE:TypeNotice = new TypeNotice( "village_upgrade" );
		
		public static const VILLAGE_COMPLETE_PRODUCTION:TypeNotice = new TypeNotice( "village_complete_production" );
		
		public static const POTION_COMPLETE:TypeNotice = new TypeNotice( "potion_complete");
		
		public static const REPAIR_COMPLETE:TypeNotice = new TypeNotice( "repair_complete");
		
		public static const AMMO_COMPLETE:TypeNotice = new TypeNotice( "ammo_complete");
		
		public static const COMPLETE_STORM:TypeNotice = new TypeNotice( "complete_storm");
		
		public static const UNKNOW:TypeNotice = new TypeNotice( "unknow" );
		
		public function TypeNotice( type:String )
		{
			m_value = type;
		}
		
		public function get Value( ):String{
			return m_value;
		}
		
		private var m_value:String;
	}
}