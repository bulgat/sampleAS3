package game.assets
{
	import flash.display.Bitmap;

	/**
	 * 
	 * @author volk
	 * 
	 */	
	public class Assets 
	{

    	public function Assets( )
		{
			
		}
		
		public static function getBitmap( _name:String ):Bitmap{
			if( guiAsset[_name]!=null )
				return new guiAsset[_name]() as Bitmap;
			
			if( villageAsset[_name]!=null )
				return new villageAsset[_name]() as Bitmap;
			
			if( listVillageAsset[_name]!=null )
				return new listVillageAsset[_name]() as Bitmap;
			
			if( gardenAsset[_name]!=null )
				return new gardenAsset[_name]() as Bitmap;
			
			if( alchemistAsset[_name]!=null )
				return new alchemistAsset[_name]() as Bitmap;
			
			if( stormAsset[_name]!=null )
				return new stormAsset[_name]() as Bitmap;
			
			if( bossAsset[_name]!=null )
				return new bossAsset[_name]() as Bitmap;
			
			if( smithAsset[_name]!=null )
				return new smithAsset[_name]() as Bitmap;
			
			if( ammoAsset[_name]!=null )
				return new ammoAsset[_name]() as Bitmap;
			
			if( chatAsset[_name]!=null )
				return new chatAsset[_name]() as Bitmap;
			
			return  new guiAsset['Unknow'] as Bitmap;
		}
	}
}