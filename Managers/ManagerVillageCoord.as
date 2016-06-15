package game.Managers
{
	import core.utils.ImgNameCrop;
	
	import flash.display.Bitmap;
	import flash.geom.Point;
	

	/**
	 * затык для сопоставления координат хоз построек на экране
	 * сервер отдает только список домов в деревне / координаты и 
	 * бекграунд деревни конфигится тут 
	 * @author volk
	 * 
	 */	
	public class ManagerVillageCoord extends ManagerBase
	{
		private var m_xml:XML;
				
		public function ManagerVillageCoord( data:Object )
		{
			super( data );
			m_xml = data as XML;
		
		}
		
		
		public function getCoordOuthouse( idVillage:int , idHouse:int ):Point{
			for each ( var xx:* in m_xml.item ){
				if( int(xx.@globalID) == idVillage){ 
					for each ( var yy:* in xx.house ){
						if( int(yy.@ID) == idHouse ){
							return new Point( yy.@x , yy.@y ); 
						}
					}
				}
	     	} 
			return new Point( 0 ,0 );
		}
		
		public function getBackgroundVillage( idVillage:int ):String{
			for each ( var xx:* in m_xml.item ){
				if( int(xx.@globalID) == idVillage){ 
					return ImgNameCrop.SplitAlias( xx.@background );
				}
			} 
			return "Unknow";
		}
		
		public function getName( idVillage:int ):String{
			for each ( var xx:* in m_xml.item ){
				if( int(xx.@globalID) == idVillage){ 
					return xx.@name;
				}
			} 
			return "Unknow";
		}
		
		public function getTrophy( idVillage:int ):Array{
			for each ( var xx:* in m_xml.item ){
				if( int(xx.@globalID) == idVillage){ 
					return String(xx.@trophy).split('#');
				}
			} 
			return null;
		}
	}
}