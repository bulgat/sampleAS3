package game.assets
{
	import flash.display.Bitmap;

	public class gardenAsset
	{
		
		[Embed(source="../../../ResourcesGame/game/Screens/garden/flower_aloe.png")]    
		public static const flower_aloe:Class
		
		[Embed(source="../../../ResourcesGame/game/Screens/garden/flower_camomile.png")]    
		public static const flower_camomile:Class
		
		[Embed(source="../../../ResourcesGame/game/Screens/garden/flower_castironsquare.png")]    
		public static const flower_castironsquare:Class
		
		[Embed(source="../../../ResourcesGame/game/Screens/garden/flower_goosegrass.png")]    
		public static const flower_goosegrass:Class
		
		[Embed(source="../../../ResourcesGame/game/Screens/garden/flower_holly.png")]    
		public static const flower_holly:Class
		
		[Embed(source="../../../ResourcesGame/game/Screens/garden/flower_mandragora.png")]    
		public static const flower_mandragora:Class
		
		[Embed(source="../../../ResourcesGame/game/Screens/garden/flower_salvia.png")]    
		public static const flower_salvia:Class
		
		[Embed(source="../../../ResourcesGame/game/Screens/garden/flower_tansy.png")]    
		public static const flower_tansy:Class
				
		public static function getBitmap( _name:String ):Bitmap {
			return new ( guiAsset[_name]() ) as Bitmap
			//return   new guiAsset[name]() as Bitmap;   //new Bitmap( (new guiAsset[ name ]() as Bitmap).bitmapData.clone() );
		}
	}
}