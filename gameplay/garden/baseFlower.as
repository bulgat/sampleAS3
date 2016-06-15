package game.gameplay.garden
{
	import core.utils.ImgNameCrop;
	
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import game.assets.Assets;
	import game.gameplay.consumed.TypeConsumed;
	
	public class baseFlower
	{
		private var m_globalID:int = 0; //слобальный id цветка
		private var m_img:String;
		private var m_type:TypeConsumed;
		private var m_position:Vector.<Point>;
		
		public function baseFlower( data:Object )
		{
			if (data) parse( data );			
		}
		
		private function parse( data:Object ):void{
			
			m_globalID = int( data.@globalID );
			m_img = ImgNameCrop.SplitAlias( data.@image );
			m_type = TypeConsumed.Convert( data.@type );
			m_position = new Vector.<Point>;
			
			for each ( var xx:* in data.position ){
				m_position.push( new Point( xx.@x, xx.@y ) );
			}
		}
		
		public function get Img( ):String{
			return m_img;
		}
		
		public function get Type( ):TypeConsumed{
			return m_type;
		}
		
		public function getRandomPosition( ):Point{
			//возвращаем рандомную позицию из имеющихся
			return m_position[ Math.round( Math.random() * (m_position.length - 1) ) ];
		}
		
	}
}

