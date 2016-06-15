package game.gameplay.Items
{
	import flash.display.Bitmap;
	
	import core.loader.BatchLoader;
	import core.loader.TypeLoad;
	
	import game.Global;
	import game.assets.Assets;

	/**
	 * регалии - собираются из элементов коллекции
	 * регалия дает привесок в игре чего то  
	 * @author volk
	 * 
	 */	
	public class ItmRegal
	{
		private static const  pathIco:String ='images/regals/';
		
		private var m_icoImage:Bitmap;
		
		private var m_hint:String;
		
		private var m_name:String;
		
		private var m_globalID:int = 0;
		
		private var m_pathImage:String;
		
		private var m_listCollection:Array;
		
		private namespace CALLBACK;
		
		public function ItmRegal( data:Object )
		{
			m_name 		= data.@name;
			m_globalID  = int( data.@globalID );
			m_hint      = data.@hint;
			m_pathImage = data.@image;
			m_listCollection = data.@list;
			
			try{
				m_icoImage = Assets.getBitmap( m_pathImage);
			}catch( e:Error){
				Global.ManagerResources.addBacth( new BatchLoader( Global.Host+ pathIco+ m_pathImage+".png" , TypeLoad.BITMAP_DATA , CALLBACK::onEnd  ) );
			}
		}
		
		CALLBACK function onEnd( bb:Bitmap ):void{
			m_icoImage = bb; 
		}
		
		
		//public static 
		
		private function get Name( ):String{
			return m_name;
		}
		
		private function get Ico( ):Bitmap{
			return  new Bitmap( m_icoImage.bitmapData.clone() );
		}
		
		public function get Hint():String{
			return m_hint;
		}
	}
}