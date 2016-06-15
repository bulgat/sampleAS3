package game.gameplay.bank
{
	import game.gameplay.consumed.TypeConsumed;
	import game.gameplay.consumed.baseConsumed;
	import game.Managers.Managers;
	import flash.display.Bitmap;

	public class baseBank
	{
		private var m_globalID:int = 0; //слобальный id покупки
		private var m_baseConsumed:baseConsumed;
		private var m_count:uint = 0;
		private var m_price:uint = 1;
		
		public function baseBank( data:Object )
		{
			if (data) parse( data );			
		}
		
		private function parse( data:Object ):void{
			
			m_globalID = int( data.@globalID );
			m_baseConsumed = Managers.consumed.getConsumedByTypeString( data.@type );
			m_count = uint( data.@count );
			m_price = uint( data.@price );
		}
		
		public function get GlobalID( ):int{
			return m_globalID;
		}
		
		public function get Ico( ):Bitmap{
			return m_baseConsumed.Ico;
		}
		
		public function get Name( ):String{
			return m_baseConsumed.Name;
		}
		
		public function get Count( ):uint{
			return m_count;
		}
		
		public function get Price( ):uint{
			return m_price;
		}
		
	}
}

