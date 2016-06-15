package game.Managers
{
	
	import game.gameplay.ammunition.baseAmmoSet;
	
	public class ManagerAmmoSet extends ManagerBase
	{
		
		private var m_list:Object = new Object();
		
		public function ManagerAmmoSet(data:Object)
		{
			super(data);
			
			parse( data );
		}
		
		private function parse( data:Object ):void{
			
			var xml:XML = data as XML;
			
			for each ( var xx:XML in xml.item ){
				var b:baseAmmoSet = new baseAmmoSet( xx );
				m_list[xx.@globalID] = b; 
			}
			
		}
		
		public function getAmmoSetByID( globalID:String ):baseAmmoSet{
			return m_list[globalID];
		}
		
		public function getAmmoSets( ):Object{
			return m_list;
		}
		
	}
}