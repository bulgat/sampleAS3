package game.gameplay.trophy
{
	import core.utils.ImgNameCrop;
	
	/**
	 * описание трофеев
	 * 
	 */	
	public class baseTrophy
	{
				
		private var m_globalID:int = 0;
		private var m_name:String  = 'Unknow';
		private var m_image:String = 'Unknow';
		
		public function baseTrophy( data:Object )
		{
			if( data as XML ){
				parse( data as XML  );
			}
			
		}
		
		private function parse( obj:XML ):void{
			
			m_name            = obj.@name;
			m_globalID        = int( obj.@globalID );
			m_image			  = ImgNameCrop.SplitAlias( obj.@image );
			
		}
		
		public function get GlobalID( ):int{
			return m_globalID;
		}
		
		public function get Name( ):String{
			return m_name;
		}
		
		public function get Image( ):String{
			return m_image;
		}
		
	}
}

