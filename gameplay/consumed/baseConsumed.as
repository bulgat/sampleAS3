package game.gameplay.consumed
{

	
	import core.loader.BatchLoader;
	import core.loader.ResourceLoader;
	import core.loader.TypeLoad;
	import core.utils.ImgNameCrop;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import game.Global;
	import game.assets.Assets;

	public class baseConsumed
	{
		/**
		 * 
		 */
		private static const  pathIco:String ='images/consumed/';
		
		private var m_icoImage:Bitmap;
		
		private var m_name:String;
		
		private var m_pathImage:String = 'veksel_ico';
		
		private var m_type:TypeConsumed;
		
		private var m_globalID:int;
		
		private var m_hint:String;
		
		private var m_price:uint = 0;
		
		private var m_negatively:Boolean = false;

		private  namespace CALLBACK;
		
		public function baseConsumed( obj:Object )
		{
			if( obj is XML ){
				m_name         = obj.@name;
				m_pathImage    = ImgNameCrop.SplitAlias( obj.@image );
				m_type         = TypeConsumed.Convert( obj.@type );
				m_hint         = obj.@hint;
				m_globalID     = int( obj.@globalID );
				m_price		   = uint( obj.@price );
				m_negatively   = Boolean( obj.@negatively );
			}
		
			try{
				m_icoImage = Assets.getBitmap( m_pathImage );
			}catch( e:Error){
				Global.ManagerResources.addBacth( new BatchLoader( Global.Host+ pathIco+ m_pathImage+".png" , TypeLoad.BITMAP_DATA , CALLBACK::onEnd  ) );
			}
		}

		CALLBACK function onEnd( bb:Bitmap ):void{
			m_icoImage = bb; 
		}
		
		public function get Ico( ):Bitmap{
			return  new Bitmap( m_icoImage.bitmapData.clone() );
		}
		
		public function get Hint():String{
			return m_hint;
		}
		
		public function get isNegatively( ):Boolean{
			return m_negatively;
		}

		public function get Name( ):String{
			return m_name;
		}
		
		public function get Type( ):TypeConsumed{
			return m_type;
		}
		
		public function get Price( ):uint{
			return m_price;
		}
		
		public function get GlobalID():int{
			return m_globalID;
		}
		
		//дополнить до нормального вывода информации
		public function toString():String{ trace('CONS  '+ m_type.Value );
			return null;
		}
		
		
	}
}