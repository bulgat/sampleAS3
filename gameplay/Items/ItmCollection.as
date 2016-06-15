package game.gameplay.Items
{
	import flash.display.Bitmap;
	
	import core.loader.BatchLoader;
	import core.loader.TypeLoad;
	
	import game.Global;
	import game.assets.Assets;

	/**
	 * элементы коллекции с которых собираются регалии 
	 * @author volk
	 * 
	 */	
	public class ItmCollection
	{
		private static const  pathIco:String ='images/collections/';
	
		private var m_icoImage:Bitmap;
		
		private var m_hint:String;
		
		private var m_name:String;
		
		private var m_regalID:int = 0;
		
		private var m_globalID:int = 0;
		
		private var m_pathImage:String;
		
		private namespace CALLBACK;
		
		public function ItmCollection( data:Object )
		{
    		m_name 		= data.@name;
			m_regalID 	= int( data.@regalID );
			m_globalID  = int( data.@internalID );
			m_hint      = data.@hint;
			m_pathImage = data.@image;
			
			try{
				m_icoImage = Assets.getBitmap( m_pathImage);
			}catch( e:Error){
				Global.ManagerResources.addBacth( new BatchLoader( Global.Host+ pathIco+ m_pathImage+".png" , TypeLoad.BITMAP_DATA , CALLBACK::onEnd  ) );
			}
		}
		
		CALLBACK function onEnd( bb:Bitmap ):void{
			m_icoImage = bb; 
		}
		
		private function get Name( ):String{
			return m_name;
		}
		
		private function get RegalID( ):int{
			return m_regalID;
		}
		
		private function get Ico( ):Bitmap{
			return  new Bitmap( m_icoImage.bitmapData.clone() );
		}
		
		public function get Hint():String{
			return m_hint;
		}

		
	
	}
}