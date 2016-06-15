package game.Managers
{
	import game.display.storming.baseCastle;

	public class ManagerCastle extends ManagerBase
	{
		private var m_list:Object = new Object();
		
		public function ManagerCastle( data:Object )
		{
			super( data );
			
			for each( var key:* in data.item ){
				var b:baseCastle = new baseCastle( key );
				m_list[ key.@globalID ] = b; 
			}
			
		}
		
		public function getCastleByGlobalID( globalID:String ):baseCastle{ 
			return m_list[ globalID ];
		}
		
	}
	
}