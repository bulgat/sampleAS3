package game.display.FittingRoom.pnl
{
	import core.gui.button.TypeButton;
	import core.gui.button.filterButton;
	import core.gui.button.stretchButton;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import game.assets.Assets;
	import game.gameplay.ammunition.Ammunition;
	import game.gameplay.ammunition.TypeAmmunition;

	public class ItmAmmunition extends filterButton
	{
		[Embed(source="../../../../../ResourcesGame/game/FittingRoom/background_inventory.png")]  
		public static const background_inventory:Class;
		
		[Embed(source="../../../../../ResourcesGame/game/FittingRoom/image_background.png")]  
		public static const buyClass:Class;
		
		private var m_pnl:PnlAmmunition;
		
		private var m_id:String;
		
		public var m_info:Ammunition;
		
		private var m_label:TextField;
		
		private namespace CALLBACK;
		
		private var m_btn:stretchButton;
		
		private var m_img:Bitmap;
		
		private var m_back:Bitmap;
		
		private var m_buy:Bitmap;
		
		private var m_icoDamage:Bitmap;
		
		private var m_isUsed:Boolean = false;
		
		public function ItmAmmunition(  pnl:PnlAmmunition ,  ammunitInfo:Ammunition, free:Boolean = false ) 
		{
			super( null);
			
			m_back = new background_inventory() as Bitmap;
			addChild( m_back );
			
			if ( free ) return;
			
			m_pnl = pnl;
			
			if ( ammunitInfo ){
				m_info = ammunitInfo;
				
				m_icoDamage = Assets.getBitmap( "icon_damage" );
				m_icoDamage.x = 2;
				m_icoDamage.y = 2;
				addChild( m_icoDamage );
			
				m_label = new TextField( );
				m_label.autoSize = TextFieldAutoSize.LEFT;
				m_label.text = String( m_info.Health ) + "/" + String( m_info.BaseAmmunition.Strength );
				m_label.x = m_icoDamage.width;
				addChild( m_label);
			
				m_img = m_info.BaseAmmunition.Ico;
				//m_sprite.scaleX = m_sprite.scaleY = 0.6;
				m_img.x = 0;
				m_img.y = 0;
				addChild( m_img );
			}
			else{
				m_buy = new buyClass() as Bitmap;
				m_buy.x = 5;
				m_buy.y = 20;
				addChild( m_buy );
			}
			
			Click = on_Click;
		}
		
		public function on_Click( send:Boolean = true ):void{
			
			if ( m_info ){
				if ( !m_isUsed ){
					
					m_isUsed = true;
					Click = null;
					
					m_pnl.onSelectItem( m_info , send);
					
					if ( m_info.BaseAmmunition.Type != TypeAmmunition.WEAPON ){
						m_btn   = new stretchButton( TypeButton.SIMPLE_GREEN, 1, "снять" );
						addChild( m_btn ); 
						m_btn.x = 5;
						m_btn.y = m_back.height - m_btn.height;
						m_btn.Click = onButton;
					}
				}
			}
			else{
				//окно покупки нового слота
				m_pnl.parent.addChild( new BuySlotWindow( 5, onBuySlot ) );
			}
		}
		
		private function onBuySlot( price:int ):void{
			m_pnl.onBuySlot( price );
		}
		
		private function onButton( send:Boolean = true ):void{
			if ( m_isUsed ){
				m_isUsed = false;
				
				m_pnl.onTakeOff( m_info , send );
				
				if( m_btn!=null){
					removeChild( m_btn );
					m_btn = null;
				}
			
				Click = on_Click;
			}
		}
		
		public function Refresh( ):void{
			onButton( false );			
		}
		
		/*
		CALLBACK function onEndLoad( ):void{
			addChild( m_sprite );
			m_sprite.x = m_sprite.width/2;
			m_sprite.y = m_sprite.height/2;
			
		}
		*/
		
		override protected function onDestroy():void{
			m_back.bitmapData.dispose();
			m_back = null;
			
			if ( m_icoDamage ){
				m_icoDamage.bitmapData.dispose();
				m_icoDamage = null;
			}
			
			if ( m_buy ){
				m_buy.bitmapData.dispose();
				m_buy = null;
			}
			
			if ( m_img ){
				m_img.bitmapData.dispose();
				m_img = null;
			}
			
		}
		
	}
}