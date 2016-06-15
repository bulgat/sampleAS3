package game.Managers
{
	import core.baseObject;
	
	import game.gameplay.consumed.TypeConsumed;
	import game.gameplay.village.baseOuthouse;

	public class ManagersOuthouse extends ManagerBase
	{
		
		private var m_list:Object; 
		
		private var m_xml:XML;
		
		public function ManagersOuthouse( data:Object )
		{
			super( data );
			m_xml = data as XML;
			parseLocal( data );	
		} 
		
		private function parseLocal( data:Object ):void{ 
		
			m_list = new Object( );
			for each ( var xx:XML in m_xml.house.item ){  	
				var tb:Array = findTable( String( xx.@globalID) );
				var b:baseOuthouse   = new baseOuthouse( xx , tb );  
				m_list[xx.@globalID] = b;  
			} 
		
		}
		

		/**
		 * достаем таблицу истинности апгрейдов для постройки по ее globalID 
		 * @param id
		 * @return 
		 * 
		 */		
		private function findTable( id:String ):Array{
			for each ( var tx:XML in m_xml.tables.item ){
				if( tx.@globalID == id ){
					var ar:Array = new Array( );
					for each ( var sx:XML in tx.list ){
						ar.push( JSON.parse( String(sx) )); 
					}
					return ar;
				}
			}
			return null;	
		}
		
		
		public function getOuthouseByID( id:String ):baseOuthouse{
			return m_list[ id ];	
		}
		
	}
}