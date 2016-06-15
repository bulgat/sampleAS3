package game.Managers
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import game.gameplay.consumed.TypeConsumed;
	import game.gameplay.garden.baseFlower;
	
	/**
	 * Менеджер растений в саду, тут берём их координаты
	 */	
	public class ManagerGarden extends ManagerBase
	{
		private var m_xml:XML;
		private var m_list:Object;
		private var m_length:uint = 0;
		
		public function ManagerGarden( data:Object )
		{
			super( data );
			m_xml = data as XML;
			m_list = new Object( );
			parse();
		}
		
		private function parse( ):void{
			
			for each ( var xx:XML in m_xml.item ){
				var b:baseFlower   = new baseFlower( xx );
				m_list[xx.@globalID] = b;
				m_length++;
			}
			
		}
		
		public function getRandomCoordFlower( idFlower:String ):Point{
			if (m_list[idFlower])
			return m_list[idFlower].getRandomPosition( );
			
			return new Point( 0 ,0 );
		}
		
		public function getFlowerByID( idFlower:String ):baseFlower{
			return m_list[idFlower];
		}
		
		public function getFlowerByType( type:TypeConsumed ):baseFlower{
			var bf:baseFlower;
			for each ( bf in m_list ){
				if( bf.Type == type )
					return bf;
			}
			return null;
		}
	}
}