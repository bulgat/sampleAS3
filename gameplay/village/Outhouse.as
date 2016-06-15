package game.gameplay.village
{
	import fl.controls.listClasses.ImageCell;
	
	import flash.display.Bitmap;
	
	import game.Global;
	import game.Managers.Managers;
	import game.gameplay.consumed.TypeConsumed;

	/**
	 * Хоз потсройка которая непосредственно в деревне 
	 * @author volk
	 * 
	 */	
	public class Outhouse
	{	//"timeUpgrade":0,"timeProduction":1392280140,"idHouse":"1","level":1
		
		private var m_baseOuthouse:baseOuthouse;
		
		private var m_level:uint = 0;
		
		private var m_timeUpgrade:int = 0;
		
		private var m_timeProduction:int = 0;
		
		private var m_state:StateOuthouse = StateOuthouse.PRODUCTION;
		
		private var m_villageId:uint = 0;
		
		/**
		 * изменилось ли состояние
		 */
		private var m_change:Boolean;
		
		public function Outhouse( idBaseOuthouse:int , data:Object , villageID:uint )
		{
			m_baseOuthouse 		= Managers.outhouse.getOuthouseByID( String(idBaseOuthouse ) );
			m_level 			= uint( data['level'] );
			m_timeProduction 	= int( data['timeProduction'] );
			m_timeUpgrade 		= int( data['timeUpgrade'] );
			
			m_villageId = villageID;
		}
		
		
		/**
		 * попытаться проапгрейдиться
		 */
		public function Upgrade( ):void{
			m_level += 1;
		}
		
		
		/**
		 * проверяем доступность для апгрейда
		 */
		public function EnabledUpgrade(  ):Boolean{
			if( Global.MaxUpgradeOuthouse <= m_level ) return false;
			var table:Array = m_baseOuthouse.UpgradeTable;
			
			//if ( Global.player.Level < table[m_level]["level"]) return false;
			
			if( m_level >= table.length ) return false;
			
			var cond:Object = table[m_level]["condition"];
			for ( var key:* in cond ){
				if( Global.player.getConsumed( TypeConsumed.Convert( key ) )< cond[key] )
					return false;
			}
			
			return true;
		}
		
		/**
		 * результат предвычислений менялось ли состояние хоз постройки
		 */
		private function setState( state:StateOuthouse ):void{
			if( m_state!=state ){ 
				m_change = true;
				m_state  = state;
			}
			else
				m_change = false;
		}
		
		public function get BaseOuthouse( ):baseOuthouse{
			return m_baseOuthouse;
		}
		
		public function get Image( ):String{
			return m_baseOuthouse.Image;
		} 
		
		public function get RequirementToUpgrade( ):Object{
			if( m_level >= m_baseOuthouse.UpgradeTable.length ) return null;
			return m_baseOuthouse.UpgradeTable[m_level];
		}
		
		public function get TableUpgrade( ):Object{
			return m_baseOuthouse.UpgradeTable[m_level];
		}
		
		public function get Result( ):Object{
			return m_baseOuthouse.UpgradeTable[ m_level - 1 ]["result"];
		}
		
		public function get Change( ):Boolean{
			return m_change;
		}
		
		public function get State( ):StateOuthouse{
			return m_state;
		}
		
		public function get Level( ):int{
			return m_level;
		}
		
		public function get TimeProduction( ):int{
			return m_timeProduction;
		}
		
		public function get TimeUpgrade( ):int{
			return m_timeUpgrade;
		}
		
		public function get Time( ):int{
			return m_baseOuthouse.UpgradeTable[ m_level - 1 ]["time"];
		}
		
		public function get Name( ):String{
			return m_baseOuthouse.Name;
		}
		
		public function get VillageID( ):uint{
			return m_villageId;
		}
		
		public function set TimeProduction( time:int ):void{
			m_timeProduction = time;	
		}
		
	}
}