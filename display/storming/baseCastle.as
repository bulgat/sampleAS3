package game.display.storming
{
	import core.utils.ImgNameCrop;
	
	import flash.geom.Point;

	public class baseCastle
	{
		
		private var m_name:String;
		private var m_globalID:int;
		private var m_img:String;
		/**
		 * урон от одного друга/члена отряда
		 */
		private var m_damageOne:int;
		private var m_strength:int;
		/**
		 * время выделенное на штурм замка 
		 */		
		private var m_timeStorm:int;
		private var m_weaponPos:Object = new Object();
		
		public function baseCastle( data:Object )
		{
			m_name 		= data.@name;
			m_globalID 	= int( data.@globalID );
			m_img		= ImgNameCrop.SplitAlias( data.@image );
			m_damageOne = data.@damageOne;
			m_strength 	= data.@strength;
			m_timeStorm = data.@timeStorm;
			for each(var key:* in data.weapon ){
				m_weaponPos[ key.@ID ] = new Point( int( key.@x ), int( key.@y ) );
			}
			
		}
		
		public function get TimeStorm():int{
			return m_timeStorm;
		}
		
		public function get DamageOne():int{
			return m_damageOne;
		}
		
		public function get Strength():int{
			return m_strength;
		}
		
		public function get Name( ):String{
			return m_name;
		}
		
		public function get Image():String{
			return m_img;
		}
		
		public function get GlobalID( ):int{
			return m_globalID;
		}
		
		public function get WeaponPos( ):Object{
			return m_weaponPos;
		}
		
	}
	
}