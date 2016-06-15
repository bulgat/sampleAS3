package game.display.gui
{
	import flash.display.Bitmap;

	
	import core.gui.checkBox.baseCheckBox;
	
	import game.assets.guiAsset;

	public class UICheckBox extends baseCheckBox
	{
		
		
		public function UICheckBox(  label:String  )
		{
			super( new guiAsset.res_no_ico as Bitmap , new guiAsset.res_yes_ico as Bitmap , label )  

		}
		
		
	}
}