package game.gameplay.ammunition
{
	/**
	 * типы оружия 
	 * @author volk
	 * 
	 */	
	public final class TypeAmmunition
	{
		/**
		 * шлемы 
		 */		
		public static const HELMET:TypeAmmunition = new TypeAmmunition( "helmet");
		
		/**
		 * оружие 
		 */		
		public static const WEAPON:TypeAmmunition = new TypeAmmunition( "weapon" );
		
		/**
		 * щиты
		 */		
		public static const SHIELDS:TypeAmmunition = new TypeAmmunition( "shields" );
		
		/**
		 *что то накосячили 
		 */		
		public static const UNKNOW:TypeAmmunition = new TypeAmmunition( "unknow" );
		
		/**
		 * нагрудник 
		 */		
		public static const BIB:TypeAmmunition = new TypeAmmunition( "bib" );
		
		/**
		 *  сапоги
		 */		
		public static const BOOTS:TypeAmmunition = new TypeAmmunition( "boots" );
		
		/**
		 *перчатки 
		 */		
		public static const GLOVES:TypeAmmunition = new TypeAmmunition( "gloves" );
		
		/**
		 * юбка 
		 */		
		public static const SKIRT:TypeAmmunition = new TypeAmmunition( "skirt" );
		
		/**
		 * наплечник 
		 */		
		public static const SCAPULAR:TypeAmmunition = new TypeAmmunition( "scapular" );
		
		/**
		 * поддевка 
	    */
		public static const UNDERSUITS:TypeAmmunition = new TypeAmmunition( "undersuits" );
		
		/**
		 * набедренник 
		 */
		public static const EPIGONATION:TypeAmmunition = new TypeAmmunition( "epigonation" );
		
		/** 
		*  рукав
		*/
		public static const REREBRACE:TypeAmmunition = new TypeAmmunition( "rerebrace" );
		
		
		
		public function TypeAmmunition( value:String )
		{
			m_value =  value;	
		}
		
		public function  toString( ):String{
			return m_value;
		}
		
		private var m_value:String;
	}
}