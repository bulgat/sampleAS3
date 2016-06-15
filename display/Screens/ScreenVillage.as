package game.display.Screens
{
	import core.baseObject;
	import core.gui.guiRoot;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Point;
	
	import game.Managers.Managers;
	import game.Managers.ManagersOuthouse;
	import game.assets.Assets;
	import game.display.village.ItmVillage;
	import game.gameplay.village.Outhouse;
	import game.gameplay.village.baseVillage;

	/**
	 * деревня 
	 * @author volk
	 * 
	 */	
	public class ScreenVillage extends baseScreen
	{
		
		private var m_back:Bitmap;
		
		private var m_list:Vector.<ItmVillage>;
		
		private var m_lastItm:ItmVillage;
		
		public function ScreenVillage( village:baseVillage )
		{
			m_internalName = "sreenVillage";
			m_back = Assets.getBitmap( Managers.OuthouseCoord.getBackgroundVillage( village.GlobalID ) )
			addChild( m_back );
			
			var tp:flash.geom.Point;
			var t_outhouse:Outhouse;
			m_list = new Vector.<ItmVillage>;
			
			for( var i:int = 0; i < village.LengthOuthouse; i++){
				t_outhouse = village.getTableOuthouseByIndex( i );
				var m_current_outhouse:ItmVillage = new ItmVillage ( this ,  t_outhouse );
				tp = Managers.OuthouseCoord.getCoordOuthouse( village.GlobalID , t_outhouse.BaseOuthouse.GlobalID );
				m_current_outhouse.x = tp.x;
				m_current_outhouse.y = tp.y;
				addChild( m_current_outhouse );
				
				m_list.push( m_current_outhouse );
			}
			
			addEventListener( Event.ENTER_FRAME , onFrame , false , 0 , true );
		}
		
		private var m_i:int = 0;
		private var m_miss:int = 0;
		private function onFrame( event:Event ):void{
			m_miss++;
			if( m_miss > 3 ){
				m_miss++;
				for( m_i = 0 ; m_i < m_list.length ; m_i++ ){
					if( m_list[m_i].isOver( guiRoot.MousePosition  ) ){
					
					}
				}
			}
		}
		
		public function Hide():void{
			for( var m_i:int = 0 ; m_i< m_list.length ; m_i++ ){
					m_list[m_i].Hide();
			}
		}
		
		override protected function onDestroy():void{
			removeEventListener( Event.ENTER_FRAME , onFrame );
			m_back.bitmapData.dispose();
			m_back = null;
		}
		
	}
}