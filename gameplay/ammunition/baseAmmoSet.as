package game.gameplay.ammunition
{
	import core.utils.ImgNameCrop;

	public class baseAmmoSet
	{
		
		private var m_name:String;
		private var m_image:String;
		private var m_hint:String;
		private var m_effect:Object;
		private var m_globalID:int;
		private var m_level:int;
		private var m_ammoList:Array;
		
		public function baseAmmoSet( obj:Object )
		{
			
			m_name     = obj.@name;
			m_image    = ImgNameCrop.SplitAlias( obj.@image );
			m_hint     = obj.@hint;
			
			m_effect   = JSON.parse( obj.@effect );
			
			m_globalID = int( obj.@globalID );
			m_level    = int( obj.@level );
			
			m_ammoList = obj.@ammo_list.split(",");
			
		}
		
		public function get Name( ):String{
			return m_name;
		}
		
		public function get Image( ):String{
			return m_image;
		}
		
		public function get Hint( ):String{
			return m_hint;
		}
		
		public function get Effect( ):Object{
			return m_effect;
		}
		
		public function get GlobalID( ):int{
			return m_globalID;
		}
		
		public function get Level( ):int{
			return m_level;
		}
		
		public function get AmmoList( ):Array{
			return m_ammoList;
		}
		
	}
}