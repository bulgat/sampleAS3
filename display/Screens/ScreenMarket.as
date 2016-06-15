package game.display.Screens
{
	import core.gui.button.filterButton;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import game.Global;
	import game.assets.Assets;
	import game.gameplay.consumed.TypeConsumed;

	public class ScreenMarket extends baseScreen
	{
		[Embed(source="../../../../ResourcesGame/game/Screens/market/market.jpg")]   
		public static const marketBack:Class
		
		private var m_iBack:Bitmap;
		
		private var m_points:Vector.<flash.geom.Point>;
		
		private var m_curCoin:filterButton;
		
		private namespace CALLBACK;
		
		public function ScreenMarket( )
		{
			Mouse.cursor = MouseCursor.AUTO;
			
			this.m_internalName = "ScreenMarket";
			m_iBack = new marketBack( ) as Bitmap;
			addChild( m_iBack );
			
			m_points= new Vector.<flash.geom.Point>;
			m_points.push( new flash.geom.Point(50,50),
						   new flash.geom.Point(80,80),
						   new flash.geom.Point(110,110),
						   new flash.geom.Point(140,140),
						   new flash.geom.Point(170,170),
						   new flash.geom.Point(200,200),
						   new flash.geom.Point(230,230),
						   new flash.geom.Point(260,260),
						   new flash.geom.Point(290,290),
						   new flash.geom.Point(320,320)
			);
			
			Global.Server.getInfoRialto( Global.player.InternalID, CALLBACK::onInfoGood, CALLBACK::onInfoBad );
		}
		
		CALLBACK function onInfoGood( response:Object ):void{
			//"response":{"count_coin":"0","time_take":"0","time_generate":"1397112424"}}
			onFill( response );
		}
		
		CALLBACK function onInfoBad( response:Object ):void{
			trace('Не удалось получить инфу о монетах');
		}
		
		private function onFill( data:Object ):void{
			
			for ( var i:int = 0; i < int( data.count_coin );  i++ ){
				
				var coin:filterButton = new filterButton( Assets.getBitmap( "gold_coin_ico" ) );
				coin.ReturnParams = new Array( coin );
				coin.Click = GetCoin;
				
				coin.x = m_points[0].x;
				coin.y = m_points[0].y;
				
				m_points.shift();
				
				addChild( coin );
			}
			
		}
		
		private function GetCoin( params:Array ):void{
			m_curCoin = params[0];
			Mouse.cursor = MouseCursor.AUTO;
			
			//отправить на сервер результаты
			Global.Server.TakeCoinRialto( Global.player.InternalID, 1, CALLBACK::onTakeGood, CALLBACK::onTakeBad );
		}
		
		CALLBACK function onTakeGood( response:Object ):void{
			Global.player.addConsumed( TypeConsumed.GOLD_COIN, 1 );
			removeChild( m_curCoin );
		}
		
		CALLBACK function onTakeBad( response:Object ):void{
			trace('Не удалось собрать монету');
		}
		
		override protected function onDestroy():void{
			m_iBack.bitmapData.dispose();
			m_iBack = null;
		}
	}
}