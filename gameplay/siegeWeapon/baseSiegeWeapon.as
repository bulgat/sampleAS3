package game.gameplay.siegeWeapon
{
	import core.utils.ImgNameCrop;
	
	import flash.display.Bitmap;
	
	import game.assets.Assets;

	public class baseSiegeWeapon
	{
		private var m_globalID	:int 	= -1;
		private var m_name		:String = "unknow";
		private var m_image		:String = "unknow";
		private var m_hint		:String = "bla";
		private var m_damage	:int    =  0;
		private var m_price     :Object;
		private var m_condition	:Object;
		private var m_level		:int 	= 1;
		private var m_time:int = 0;
		//	<items name="Мост"  , globalID ='0' , damage='{"gate":"-500"}'  time='60' , condition='{"stone":"5", "gold":"2"}' , level ='1', hint="bla bla",    image='Bridge'/>
		public function baseSiegeWeapon( data:Object )
		{
			m_globalID 	= data.@globalID;
			m_name 		= data.@name;
			m_damage 	= int( data.@damage );
			m_price     = JSON.parse( data.@price );
			m_condition = JSON.parse( data.@condition );
			m_level 	= data.@level;
			m_hint 		= data.@hint;
			m_image 	= ImgNameCrop.SplitAlias( data.@image );
			m_time 		= data.@time; 
		}
		
		
		public function get Level( ):int{
			return m_level;
		}
		
		public function get Condition( ):Object{
			return m_condition;
		}
		
		public function get Price( ):Object{
			return m_price;
		}
		
		public function get Damage( ):int{
			return m_damage;	
		}
		
		public function get Hint( ):String{
			return m_hint;
		}
		
		public function get Ico( ):Bitmap{
			return Assets.getBitmap( m_image );
		}
		
		public function get Name( ):String{
			return m_name;
		}
		public function get ID( ):int{
			return m_globalID;
		}
		
		public function get Time():int{
			return m_time;
		}
	}
}