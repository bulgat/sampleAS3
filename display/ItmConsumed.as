package game.display
{
	import core.baseObject;
	import core.gui.button.TypeButton;
	import core.gui.button.stretchButton;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import game.Global;
	import game.Managers.Managers;
	import game.display.ItemScreenBins.WinBuyResources;
	import game.gameplay.consumed.TypeConsumed;
	import game.gameplay.consumed.baseConsumed;
	import game.gameplay.siegeWeapon.baseSiegeWeapon;
	
	
	public class ItmConsumed extends baseObject {
		
		private var m_consumed:baseConsumed;
		private var m_btnBuy:stretchButton;
		private var m_info:TextField;
		private var m_ico:Bitmap;
		private var m_need:int;
		private var m_screen:DisplayObjectContainer;
		
		public function ItmConsumed( type:String, need:int, screen:DisplayObjectContainer ):void{
			m_consumed = Managers.consumed.getConsumedByTypeString( type ) ;
			if( m_consumed == null ) return;
			
			m_need = need;
			m_screen = screen;
			
			m_ico = m_consumed.Ico;
			addChild( m_ico );
			
			//if(  Global.player.getConsumed( TypeConsumed.Convert( type ) ) < baseSiege.Condition[type] )
			{
				m_btnBuy = new stretchButton(  TypeButton.SIMPLE_RED, 1, "купить" );
				m_btnBuy.x = this.width/2 - m_btnBuy.width/2;
				m_btnBuy.y = m_ico.height +2;
				m_btnBuy.Click = onBuy;
				addChild( m_btnBuy );
			}
			
			m_info = new TextField();
			m_info.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000 );
			m_info.mouseEnabled = false;
			m_info.text = Global.player.getConsumed( TypeConsumed.Convert( type ) ) + "/" + m_need;
			m_info.autoSize = TextFieldAutoSize.LEFT;
			m_info.x = m_ico.width / 2 - m_info.width / 2;
			m_info.y = m_ico.height+25;
			addChild( m_info );
			
		}
		
		private function onBuy( ):void{
			m_screen.addChild( new WinBuyResources( m_consumed, Refresh ) );
		}
		
		public function Refresh():void{
			m_info.text = Global.player.getConsumed( m_consumed.Type ) + "/" + m_need;
		}
		
		override protected function onDestroy():void{
			m_ico.bitmapData.dispose();
			m_ico  = null;
		}
	}
}