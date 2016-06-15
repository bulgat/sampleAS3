package game.gameplay.garden{
	
	import core.baseObject;
	import core.gui.button.filterButton;
	
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import game.assets.Assets;
	import game.gameplay.consumed.TypeConsumed;
	import game.gameplay.garden.baseFlower;

	public class ItmFlower extends baseObject{
	
		private var m_flowerBtn:filterButton;
		private var m_baseFlower:baseFlower;
		private var m_callBack:Function;
	
		public function ItmFlower( BaseFlower:baseFlower, callBack:Function ){
		
			m_flowerBtn = new filterButton( Assets.getBitmap( BaseFlower.Img ) );
			m_flowerBtn.Click = onClick;
			addChild( m_flowerBtn );
		
			m_baseFlower = BaseFlower;
		
			var pos:flash.geom.Point = BaseFlower.getRandomPosition( );
			x = pos.x;
			y = pos.y;
		
			m_callBack = callBack;
		}
	
		private function onClick( ):void{
			m_callBack( this );
		}
		
		public function get Type( ):TypeConsumed{
			return m_baseFlower.Type;
		}
		
}

}