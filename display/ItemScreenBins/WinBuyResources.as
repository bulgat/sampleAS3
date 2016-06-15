package game.display.ItemScreenBins
{
	import core.baseObject;
	
	import flash.display.Graphics;
	import game.gameplay.consumed.baseConsumed;

	public class WinBuyResources extends baseObject
	{
		private var m_buy:BuyResources;
		
		public function WinBuyResources( consumed:baseConsumed, refresh:Function )
		{
			Draw( );
			m_buy   = new BuyResources( this, consumed, refresh );
			m_buy.x = width/2 - m_buy.width/2;
			m_buy.y = height/2 - m_buy.height/2;
			addChild( m_buy );
		}
		
		private function Draw( ):void{
			var g:Graphics = this.graphics;
			g.clear();
			g.beginFill( 0x444444, 0.4 );
			g.drawRect( 0,0,646,577);
			g.endFill();
		}
		
		public function onClose():void{
			parent.removeChild( this );
		}
	}
}