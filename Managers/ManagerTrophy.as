package game.Managers
{
	import game.gameplay.trophy.baseTrophy;

	/**
	 * менеждер трофеев
	 */	
	public class ManagerTrophy extends ManagerBase
	{
		private var m_list:Object;
		private var m_length:int = 0;
		
		public function ManagerTrophy( data:Object )
		{
			super( data );
			m_list = new Object( );
			parse( data );
		}
		
		private function parse( data:Object ):void{ 
			var xml:XML = data as XML;
			
			for each ( var xx:XML in xml.items.item ){
				var b:baseTrophy   = new baseTrophy( xx );
				m_list[xx.@globalID] = b;
				m_length++;
			}
			
		}
		
		public function getImageTrophy( globalID:String ):String{
			return m_list[ globalID ].Image;
		}

		public function getTrophyByGlobalID( globalID:String ):baseTrophy{
			return m_list[ globalID ];
		}
		
		public function get Length():int{
			return m_length;
		}
		
	}
}