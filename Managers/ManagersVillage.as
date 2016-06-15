package game.Managers
{
	import game.gameplay.village.baseVillage;

	/**
	 * менежер деревни / занимается управлением хоз постройками в деревне 
	 * @author volk
	 * 
	 */	
	public class ManagersVillage extends ManagerBase 
	{
		
		private var m_list:Object; // массив деревень
		
		public function ManagersVillage( data:Object  )
		{
			super( data );
						
			parseLocal( data );
		}
		
		/*{"type":"player","action":"init","response":{"internalID":"10","villages":[{"idVillage":0,"list":[{"idHouse":"1","level":1,"timeUpgrade":0,"timeProduction":1392267813},{"idHouse":"2","level":1,"timeUpgrade":0,"timeProduction":1392204519},{"idHouse":"3","level":1,"timeUpgrade":0,"timeProduction":1392204519}]},{"idVillage":1,"list":[{"idHouse":"5","level":1,"timeUpgrade":0,"timeProduction":1392204519},{"idHouse":"2","level":1,"timeUpgrade":0,"timeProduction":1392204519},{"idHouse":"3","level":1,"timeUpgrade":0,"timeProduction":1392204519}]}],"data":{"consumed":{"wood":100,"stone":150,"grain":440},"veksel":0,"level":1},"time":1392279739}}*/
		private function parseLocal( data:Object ):void{ 
						
			m_list = new Object( );
			
			for each ( var xx:* in data.villages ){
				var b:baseVillage   = new baseVillage( xx['list'] , int( xx['idVillage'] ));
				m_list[xx['idVillage']] = b;
			} 
		}
		
		public function getVillageByGlobalID( globalID:String ):baseVillage{
			if (m_list[globalID] == null) 
				return m_list['0']
	
			return m_list[ globalID ];
		}
	
		
	}
}