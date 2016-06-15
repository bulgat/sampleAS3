package game.Managers
{
	
	import game.Global;
	import game.gameplay.ammunition.Ammunition;
	import game.gameplay.ammunition.TypeAmmunition;
	import game.gameplay.ammunition.baseAmmunition;


	public class ManagerCurrentAmmunition  extends ManagerBase
	{
		private var m_list:Object = new Object( );
		
		private var m_numberSlot:int = 0;
		
			
		public function ManagerCurrentAmmunition( data:Object )
		{
			super( data );
			
			m_numberSlot = int( data.numberSlot );
			
			parse( data );
		}
		
		private function parse( data:Object ):void{ 
			var xx:*;
			var yy:Ammunition;
			
			for each ( xx in data.listAmmunition ){
				var a:Ammunition = new Ammunition( xx["id"], xx );
				if (a.BaseAmmunition)
				m_list[xx["id"]] = a;
			}
			
			for ( xx in data.listDress ){       
				for each ( yy in m_list ){
					if ( yy.BaseAmmunition.globalID == data.listDress[xx]){
						yy.Dress = true;
					}					
				}  
			}
		
		}
		
		public function get NumberSlot( ):int{
			return m_numberSlot;
		}
		
		public function set NumberSlot( value:int ):void{
			m_numberSlot = value;
		}
		
		public function getAmmunitions( ):Object{
			return m_list;
		}
		
		public function addAmmunitionByGlobalID( globalID:String ):void{
			var a:Ammunition = new Ammunition( globalID, null );
			if (a.BaseAmmunition)
			m_list[globalID] = a;
		}
		
		public function getAmmunitionByGlobalID( globalID:String ):Ammunition{
						
			for each ( var a:Ammunition in m_list ){
				if( a.BaseAmmunition.globalID == int( globalID ) )
					return a;
			}
			
			return null;
		}
		
		public function getAmmunitionByTypeString( type:String ):Ammunition{
			
			for each (var a:Ammunition in m_list ){
				if( a.BaseAmmunition.Type.toString() == type )
					return a;
			}
			
			return null;
		}
		
		public function sellAmmunitionByID( globalID:String ):Boolean{
			
			for each ( var a:Ammunition in m_list ){
				if( a.BaseAmmunition.globalID == int( globalID ) ){
					
					delete m_list[a.BaseAmmunition.globalID.toString()];
					
					return true;
				}
			}
			
			return false;
			
		}
		
		public function getDressed():Object{
			var obj:Object = new Object();
			
			for each ( var a:Ammunition in m_list ){
				if( a.Dress ) obj[ a.BaseAmmunition.Type.toString() ] = a;
			}
			
			return obj;
		}
	}
}