package game.gameplay.village
{
	import core.utils.ImgNameCrop;
	
	import flash.display.Bitmap;
	
	import game.Global;
	import game.gameplay.consumed.TypeConsumed;

	/**
	 * @author volk
	 * 
	 */	
	public class baseOuthouse
	{
		//глобальный ID
		private var m_globalID:int = 0;
		private var m_name:String  = 'Unknow';
		private var m_image:String = 'Unknow';		
		
		/**
		 * таблица стоимости апгрейдов 
		 */		
		private var m_tableUpgrade:Array;
		

		public function baseOuthouse( data:Object , tb:Array )
		{
			m_tableUpgrade = tb;
			if( tb == null || tb.length == 0 ){
				m_tableUpgrade = new Array( );
				m_tableUpgrade.push( { condition:{unknow:"50",unknow:"10",unknow:"12"}, level:"1",  result:{unknow:"20"}, time:"200" } );
			}

			if( data as XML ){
				parse( data as XML  );
			}

		}
		
		private function parse( obj:XML ):void{
			
			m_name            = obj.@name;
			m_globalID        = int( obj.@globalID );
			m_image			  = ImgNameCrop.SplitAlias( obj.@image );
			
		}
		
		//--get
		
		public function get GlobalID( ):int{
			return m_globalID;
		}
		
		public function get UpgradeTable( ):Array{
			return m_tableUpgrade;
		}
		
		public function get Name( ):String{
			return m_name;
		}
		
		public function get Image( ):String{
			return m_image;
		}		
	
	}
}

