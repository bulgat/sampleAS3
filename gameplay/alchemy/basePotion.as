package game.gameplay.alchemy
{
	import core.utils.ImgNameCrop;
	
	/**
	 * описание зельев
	 * 
	 */	
	public class basePotion
	{
		/**
		 * необходимый уровень для покупки 
		 */		
		private var m_level:int    = 0;
		
		private var m_globalID:int = 0;
		private var m_name:String  = 'Unknow';
		private var m_mime:String;
		private var m_image:String = 'Unknow';
		private var m_hint:String = "";
		private var m_time:int = 0;
		private var m_createTime:int = 0;
		
		//стоимость ускорения
		private var m_forcePrice:Object;
		
		//стоимость моментальной покупки
		private var m_price:Object;
		
		// список необходимого для покупки
		private var m_createPrice:Object;
		private var m_createPriceCoin:Object;
		
		// то, что даёт нам зелье
		private var m_give:Object;
		
		public function basePotion( data:Object )
		{
			if( data as XML ){
				parse( data as XML  );
			}
			
		}
		
		private function parse( obj:XML ):void{
			
			m_name            = obj.@name;
			m_globalID        = int( obj.@globalID );
			m_image			  = ImgNameCrop.SplitAlias( obj.@image );
			m_mime			  = obj.@mimeType;
			m_hint			  = obj.@hint;
			
			m_give = JSON.parse( obj.@give );
			
			m_createPrice = JSON.parse( obj.@createPrice );
			m_createPriceCoin = JSON.parse( obj.@createPriceCoin );
			m_price = JSON.parse( obj.@price );
			m_forcePrice = JSON.parse( obj.@forcePrice );
			
			m_time = obj.@time;
			m_createTime = obj.@createTime;
		}
		
		public function get GlobalID( ):int{
			return m_globalID;
		}
		
		public function get CreatePriceCons( ):Object{
			return m_createPrice;
		}
		
		public function get CreatePriceCoin( ):Object{
			return m_createPriceCoin;
		}
		
		public function get Price( ):Object{
			return m_price;
		}
		
		public function get forcePrice( ):Object{
			return m_forcePrice;
		}
		
		public function get Level( ):int{
			return m_level;
		}
		
		public function get Name( ):String{
			return m_name;
		}
		
		public function get Image( ):String{
			return m_image;
		}		
		
		public function get Give( ):Object{
			return m_give;
		}
		
		public function get Mime( ):String{
			return m_mime;
		}
		
		public function get Time( ):int{
			return m_time;
		}
	}
}

