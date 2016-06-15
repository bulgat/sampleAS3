package game.Managers
{
	
	import game.gameplay.village.baseKingdom;
	/**
	 *  
	 * менеджер королевств
	 * 
	 */	
	public class ManagersKingdoms extends ManagerBase
	{
		
		private var m_list:Object; // массив королевств
		
		private var m_length:int = 0;
		
		private var m_xml:XML;
		
		public function ManagersKingdoms( data:Object  )
		{
			super( data );
			
			m_xml = data as XML;
						
			parseLocal( );
		}
		
		private function parseLocal( ):void{ 
						
			m_list = new Object( );
			for each ( var xx:XML in m_xml.kingdoms.item ){
				var b:baseKingdom   = new baseKingdom( xx );
				m_list[xx.@globalID] = b;
				m_length++;
			} 
		}
		
		public function getKingdomByGlobalID( globalID:String ):baseKingdom{
			return m_list[ globalID ];
		}
		
		public function get Length( ):int{
			return m_length;
		}
		
	}
}