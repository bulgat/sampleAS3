package game.Managers
{
	import game.gameplay.Items.ItmCollection;

	/**
	 * менеджер вкусняшек из которых юзер будет собрирать регалии 
	 * @author volk
	 * 
	 */	
	public class ManagerCollection extends ManagerBase
	{
		private var m_list:Object;
		
		public function ManagerCollection( data:Object )
		{
			super( data );
			m_list = new Object( );
			parseLocal( data );
		}
		
		private function parseLocal( data:Object ):void{
			if( data as XML ){
				m_list = new Object( );
				for each ( var xx:XML in data.item ){  	
					//var b:baseOuthouse   = new baseOuthouse( xx , tb );  
					//m_list[xx.@globalID] = b;  
				} 
			}
		}
		
		public function CollectionItem( id:String ):ItmCollection{
			return  null;
		}
	}
}