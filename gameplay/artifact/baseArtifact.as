package game.gameplay.artifact
{
	import core.utils.ImgNameCrop;
	
	import flash.display.Bitmap;
	
	import game.assets.Assets;

	public class baseArtifact
	{
		private var m_globalID:int = 0;
		
		private var m_name:String;
		
		private var m_image:String;
		
		private var m_effect:Object;
		
		private var m_listTrophy:Array;
		//<item { "effect":{"honor":"11","time":"0"}, "globalID":"1" , "list":"[0,1,2,3,4,5,6]"  , "image":"image.png" }/>
		public function baseArtifact( obj:Object )
		{
			m_name		= obj.@name;
			m_effect 	= JSON.parse( obj.@effect );
			m_globalID 	= obj.@globalID;
			m_listTrophy= obj.@list.split(",");
			m_image     = ImgNameCrop.SplitAlias( obj.@image );
		}
		
		
		public function get globalID():int{
			return m_globalID;
		}
		
		public function get Name():String{
			return m_name;
		}
		
		public function get Ico():Bitmap{
			var b:Bitmap = Assets.getBitmap( m_image );
			if( b == null ) b = Assets.getBitmap( "unknow" );
			return b;
		}
		
		public function get ListTrophy():Array{
			return m_listTrophy;
		}
		
		public function get Effect():Object{
			return m_effect;
		}
		
	}
}