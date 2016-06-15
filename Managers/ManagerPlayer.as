package game.Managers
{
	/**
	 * менеждер игрока
	 */	
	public class ManagerPlayer extends ManagerBase
	{
		private var m_healthInc:int;
		private var m_honorInc:int;
		
		public function ManagerPlayer( data:Object )
		{
			super( data );
			
			m_healthInc = int( data.@healthInc );
			m_honorInc = int( data.@honorInc );
		}
		
		public function get HealthInc( ):int{
			return m_healthInc;
		}
		
		public function get HonorInc( ):int{
			return m_honorInc;
		}
		
	}
}