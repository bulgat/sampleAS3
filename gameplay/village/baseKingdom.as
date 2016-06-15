package game.gameplay.village
{
	public class baseKingdom
	{
		private var m_globalID:int = 0; //слобальный id королевства
		private var m_name:String = "";
		private var m_tableVillages:Array;
		
		
		public function baseKingdom( data:Object )
		{
			if (data) parse( data );
			else{
				m_tableVillages = new Array( );
				m_tableVillages.push(1);
				m_tableVillages.push(1);
				m_tableVillages.push(1);
			}
			
		}
		
		private function parse( data:Object ):void{
			
			m_globalID = int( data.@globalID );
			m_name = data.@name;
			m_tableVillages = String( data.@villages ).split( "#" );
		}
		
		public function get GlobalID( ):int{
			return m_globalID;
		}
		
		public function get Name( ):String{
			return m_name;
		}
		
		public function getVillageIDByIndex( index:int ):int{
			if (index >=0 && index < m_tableVillages.length)
				return m_tableVillages[index];
			
			return 0;
		}
		
		public function getLengthVillage( ):int{
			return m_tableVillages.length;
		}
		
	}
}

