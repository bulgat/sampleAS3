package game.Managers
{
	import game.gameplay.consumed.TypeConsumed;
	import game.gameplay.alchemy.basePotion;

	/**
	 * менеждер зельев
	 */	
	public class ManagerPotions extends ManagerBase
	{
		private var m_list:Object;
		private var m_length:int = 0;
		
		public function ManagerPotions( data:Object )
		{
			super( data );
			m_list = new Object( );
			parse( data );
		}
		
		private function parse( data:Object ):void{ 
			var xml:XML = data as XML;
			
			for each ( var xx:XML in xml.item ){       
				var b:basePotion   = new basePotion( xx );
				m_list[xx.@globalID] = b;
				
				m_length++;
			}
			
		}

		public function getPotionByGlobalID( globalID:String ):basePotion{
			return m_list[ globalID ];
		}
		
		public function get Length():int{
			return m_length;
		}
		
	}
}