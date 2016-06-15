package game.Managers
{
	import game.gameplay.consumed.TypeConsumed;
	import game.gameplay.consumed.baseConsumed;

	/**
	 * менеждер ресурсов 
	 * @author volk
	 * 
	 */	
	public class ManagerConsumed extends ManagerBase
	{
		private var m_list:Object;
		
		public function ManagerConsumed( data:Object )
		{
			super( data );
			m_list = new Object( );
			parseLocal( data );
		}
		
		private function parseLocal( data:Object ):void{ 
			var xml:XML = data as XML;
			
			for each ( var xx:XML in xml.item ){       
				var b:baseConsumed   = new baseConsumed( xx );
				m_list[xx.@globalID] = b;   
			}
			
		}


		public function getConsumedByGlobalID( globalID:String ):baseConsumed{
			return m_list[ globalID ];
		}
		
		public function getConsumedByTypeString( type:String ):baseConsumed{
			var it:baseConsumed;
			for each ( it in m_list ){
				if( it.Type.Value == type )
					return it;
			}
			return null;
		}
		
		public function getConsumedByType( type:TypeConsumed ):baseConsumed{
			var it:baseConsumed;
			for each ( it in m_list ){
				if( it.Type == type )
					return it;
			}
			return null;
		}
		
	}
}