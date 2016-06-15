package game.Managers
{
	import game.gameplay.bank.baseBank;

	/**
	 *  
	 * менеджер покупок
	 * 
	 */	
	public class ManagersBank extends ManagerBase
	{
		
		private var m_list:Object; // массив покупок
		
		private var m_xml:XML;
		
		public function ManagersBank( data:Object  )
		{
			super( data );
			
			m_xml = data as XML;
			
			parseLocal( );
		}
		
		private function parseLocal( ):void{ 
			
			m_list = new Object( );
			
			for each ( var xx:XML in m_xml.items.item ){
				var b:baseBank  = new baseBank( xx );
				m_list[xx.@globalID] = b;
			} 
		}
		
		public function getItemByGlobalID( globalID:String ):baseBank{
			return m_list[ globalID ];
		}
		
	}
}