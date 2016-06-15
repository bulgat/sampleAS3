package game.gameplay.ammunition
{
	import game.Global;
	import game.Managers.Managers;
	import game.gameplay.ammunition.baseAmmunition;
	
	/**
	 * аммуниция конкретная
	 */	
	public class Ammunition
	{
		
		private var m_baseAmmunition:baseAmmunition;
		
		private var m_health:int = 0;
		
		private var m_dress:Boolean = false;
		
		private var m_repair:Boolean = false;
		
		public function Ammunition( idBaseAmmunition:String , data:Object  ) 
		{
			m_baseAmmunition = Managers.ammunitions.getAmmunitionByGlobalID( idBaseAmmunition ); 
			
			//m_repairTime 	 = data['repairTime'];
			if (data) m_health = data['health'];
			else m_health = m_baseAmmunition.Strength;
		}
		
		public function get BaseAmmunition( ):baseAmmunition{
			return m_baseAmmunition;
		}
		
		public function get Health( ):int{
			return m_health;
		}
		
		public function get Dress( ):Boolean{
			return m_dress;
		}
		
		public function get Repair( ):Boolean{
			return m_repair;
		}
		
		public function set Dress( flag:Boolean ):void{
			m_dress = flag;
		}
		
		public function set Health( value:int ):void{
			m_health = value;
		}
		
		public function set Repair( flag:Boolean ):void{
			m_repair = flag;
		}
		
	}
}