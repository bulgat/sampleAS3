package game.display.FittingRoom.pnl
{
	import core.baseObject;
	import core.gui.button.TypeButton;
	import core.gui.button.buttonUpDown;
	import core.gui.button.stretchButton;
	
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import game.assets.Assets;
	
	public class BuySlotWindow extends baseObject
	{
		
		[Embed(source="../../../../../ResourcesGame/game/Screens/bins/winBuy.png")] 
		public static const back:Class;
		
		private var m_price:int;
		
		private var m_back:Bitmap;
		
		private var m_buyBtn:stretchButton;
		private var m_btnClose:buttonUpDown;
		
		private var m_text:TextField;
		
		private var m_callback:Function;
		
		public function BuySlotWindow( price:int, callback:Function )
		{
			super();
			
			m_price = price;
			m_callback = callback;
			
			Draw();
			
			m_back = new back( )as Bitmap;
			m_back.x = 250;
			m_back.y = 200;
			addChild( m_back );
			
			m_buyBtn = new stretchButton( TypeButton.SIMPLE_RED, 1, "купить" );
			m_buyBtn.x = m_back.x + m_back.width / 2 - m_buyBtn.width / 2;
			m_buyBtn.y = m_back.y + 60;
			m_buyBtn.Click = onBuy;
			addChild( m_buyBtn );
			
			m_btnClose = new buttonUpDown( Assets.getBitmap("geton_close_normal_but") , Assets.getBitmap( "geton_close_press_but") );
			m_btnClose.x = m_back.x + 150;
			m_btnClose.y = m_back.y + 5;
			m_btnClose.Click = onClose;
			addChild( m_btnClose );
			
			m_text = new TextField( );
			m_text.defaultTextFormat = new TextFormat( "Candara", 12, 0xffffff );
			m_text.mouseEnabled = false;
			m_text.autoSize = TextFieldAutoSize.LEFT;
			m_text.text = "Купить слот за \n" + price +  " золотых";
			m_text.x = m_back.x + 40;
			m_text.y = m_back.y + 25;
			addChild( m_text );
			
		}
		
		private function onBuy( ):void{
			m_callback( m_price );
			onClose();
		}
		
		private function onClose( ):void{
			this.parent.removeChild( this );
		}
		
		override protected function onDestroy():void{
			
			graphics.clear();
			
			if ( m_back ){
				m_back.bitmapData.dispose();
				m_back = null;
			}
			
		}
		
		private function Draw( ):void{
			
			graphics.clear();
			graphics.beginFill( 0x000000, 0.5 );
			graphics.drawRect( 0, 0 , 646, 577 );
			graphics.endFill( );
			
		}
		
	}
}