package game.gameplay.storm
{
	import flash.utils.getTimer;
	
	import game.Global;
	import game.Managers.Managers;
	import game.gameplay.siegeWeapon.baseSiegeWeapon;
	import game.gameplay.storm.StormCastle;
	
	
	public class infoSiege{
		private var m_id:int = -1;
		//остаток времени на выполнение штурма
		private var m_residue:int = 0;
		private var m_tick:int = 0;
		private var m_storm:StormCastle;
		private var m_bs:baseSiegeWeapon;
		private var m_speedDamage:Number = 0;
		public function infoSiege( storm:StormCastle , data:Object ){
			m_storm = storm;
			m_id = data.id; 
			m_bs =  Managers.siegeWeapons.getSiegeWeaponbyID( m_id.toString()  );
			m_speedDamage = m_bs.Damage/m_bs.Time;
			m_residue = m_bs.Time;
			// значит построили только что и время шагает сначала
			if( int(data.time) )
				m_tick = Math.min( m_bs.Time, Global.startTimeGame - data.time + Math.floor(getTimer() / 1000) );
			
		}
		
		public function Update( time:Number ):void{
			m_tick+=time; 
			if( m_tick >= m_residue ){ 
 				m_storm.onCompleteSiege( this );
			}
		}
		
		/**
		 * нанесенный урон за время , которое штурмует
		 */
		public function get ItogoDamage():int{
			
			if( m_tick >= m_residue ){ 
				return 0;
			}
			
			return  m_tick*m_speedDamage;
		}
		
		public function get ID( ):int{
			return m_id;
		}
		
		public function get siegeWeapon():baseSiegeWeapon{
			return m_bs;
		}
		
		public function get CurrentTime():int{
			return m_tick;
		}
	}
}