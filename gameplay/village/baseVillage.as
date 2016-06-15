package game.gameplay.village
{
	import flash.events.Event;
	
	import game.Managers.Managers;
	import game.gameplay.village.baseOuthouse;

	public class baseVillage
	{
		/**
		 * ид деревни
		 */
		private var m_globalID:int; 
		
		private var m_name:String = "";
				
		private var m_tableOuthouse:Vector.<Outhouse> = new Vector.<Outhouse>;
		
		//{"type":"player","action":"init","response":{"internalID":"10","villages":[{"idVillage":0,"list":[{"idHouse":"1","level":1,"timeUpgrade":0,"timeProduction":1392267813},{"idHouse":"2","level":1,"timeUpgrade":0,"timeProduction":1392204519},{"idHouse":"3","level":1,"timeUpgrade":0,"timeProduction":1392204519}]},{"idVillage":1,"list":[{"idHouse":"5","level":1,"timeUpgrade":0,"timeProduction":1392204519},{"idHouse":"2","level":1,"timeUpgrade":0,"timeProduction":1392204519},{"idHouse":"3","level":1,"timeUpgrade":0,"timeProduction":1392204519}]}],"data":{"consumed":{"wood":100,"stone":150,"grain":440},"veksel":0,"level":1},"time":1392279739}}
		public function baseVillage( data:Object , globalID:int )
		{
			m_globalID = globalID;
			
			m_name = Managers.OuthouseCoord.getName( m_globalID );
			
			if (data) parse( data );
			else m_tableOuthouse.push( new baseOuthouse( null, null) );
			//{"timeUp":0,"idOuthouse":"0","level":1 ,"timeProduction":100 }
		}
				
		private function parse( obj:Object ):void{
			
			for each(var oh:* in obj){
				var outhouse:Outhouse =  new Outhouse( oh['idHouse'] , oh, m_globalID  );
				m_tableOuthouse.push( outhouse );
			}
		}
		
		public function getTableOuthouseByIndex( index:int ):Outhouse{
			if (index >=0 && index < m_tableOuthouse.length)
				return m_tableOuthouse[index];
			return null;
		}
		
		/**
		 * достаем постройку из деревни
		 */
		public function getOuthouse( idOuthouse:int ):Outhouse{
			for( var i:int = 0; i< this.m_tableOuthouse.length; i++ ){
				if( i == idOuthouse )
					return m_tableOuthouse[i];
			}
			return null;
		}
		
		public function get LengthOuthouse( ):int{
			return m_tableOuthouse.length;
		}
		
		public function get GlobalID( ):int{
			return m_globalID;
		}
		
		public function get Name( ):String{
			return m_name;
		}
		
	}
}

