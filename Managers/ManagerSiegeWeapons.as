package game.Managers
{
	import game.gameplay.siegeWeapon.baseSiegeWeapon;

	/**
	 * менеджер осадных орудий 
	 * @author volk
	 * 
	 */	
	public class ManagerSiegeWeapons extends ManagerBase
	{
		private var m_list:Object;
		
		public function ManagerSiegeWeapons( data:Object )
		{
			super( data );
			parse( data );
		}
		
		private function parse( data:Object ):void{
			m_list = new Object( );
			
			if( data as XML ){
				for each ( var xx:XML in data.item ){  	
					var bsw:baseSiegeWeapon = new baseSiegeWeapon( xx  );
					m_list[xx.@globalID] = bsw;  
				} 
			}
		}
		
		public function getSiegeWeaponbyID( id:String ):baseSiegeWeapon{
			return m_list[ id ];
		}
	}
}