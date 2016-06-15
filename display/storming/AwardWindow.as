package game.display.storming
{
	import core.baseObject;
	import core.gui.button.buttonUpDown;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import game.Managers.Managers;
	import game.assets.Assets;
	import game.gameplay.consumed.TypeConsumed;
	
	public class AwardWindow extends baseObject
	{
		
		private var m_back:Bitmap;
		private var m_closeBtn:buttonUpDown;
		
		private var m_awardText:TextField;
		
		private var m_callBack:Function;
		
		public function AwardWindow( data:Object, callback:Function  = null )
		{
			super();
			
			m_callBack = callback;
			
			Draw( );
			
			m_back = Assets.getBitmap("popup_windowwait");
			m_back.x = 200;
			m_back.y = 200;
			addChild( m_back );
			
			m_awardText = new TextField( );
			m_awardText.defaultTextFormat = new TextFormat( "Candara", 16, 0xFFFFFF );
			m_awardText.mouseEnabled = false;
			m_awardText.autoSize = TextFieldAutoSize.LEFT;
			m_awardText.y = m_back.y + 88;
			addChild( m_awardText );
			
			if ( data ){
				
				var i:uint = 0;
				var dx:int = m_back.x + 40;
				var dy:int = m_back.y + 15;
				
				for ( var key:* in data ){
					switch ( key ){
						//case "sword": Managers.current_ammunitions.addAmmunitionByGlobalID( response.award[key]["globalID"] ); break;
						case "consumed":
							for( var type:* in data[key] ){
								var ico:Bitmap;
								switch( TypeConsumed.Convert( type ) ){
									case TypeConsumed.GOLD_COIN: ico = Assets.getBitmap( TypeConsumed.GOLD_COIN.Value + "_ico" ); break;
									case TypeConsumed.SILVER_COIN: ico = Assets.getBitmap( TypeConsumed.SILVER_COIN.Value + "_ico" ); break;
									case TypeConsumed.COPPER_COIN: ico = Assets.getBitmap( TypeConsumed.COPPER_COIN.Value + "_ico" ); break;
									case TypeConsumed.EXP: ico = Assets.getBitmap( "ico_star" ); break;
									default: ico = Assets.getBitmap(type); break;
								}
								
								var award:ItmAward = new ItmAward( ico, int( data[key][type] ) );
								award.x = dx;
								award.y = dy;
								addChild( award );
								
								dx += 80;
								
								if ( i % 3 ){
									dx = m_back.x + 40;
									dy = m_back.y + 15;
								}
								
								i++;
							}
							break;
					}
				}
				m_awardText.text = "Поздравляем";
				m_awardText.x = m_back.x + 40 + m_awardText.width / 2;
			}
			else{
				m_awardText.text = "Штурм не удался";
				m_awardText.x = m_back.x + 65;
			}
			
			
			m_closeBtn = new buttonUpDown( Assets.getBitmap("geton_close_normal_but"), Assets.getBitmap("geton_close_press_but") );
			m_closeBtn.x = m_back.x + 265;
			m_closeBtn.y = m_back.y + 5;
			m_closeBtn.Click = Close;
			addChild( m_closeBtn );
			
		}
		
		private function Draw( ):void{
			var g:Graphics = this.graphics;
			g.clear();
			g.beginFill( 0x444444, 0.4 );
			g.drawRect( 0,0,646,577);
			g.endFill();
		}
		
		private function Close( ):void{			
			if ( m_callBack != null ) m_callBack();
			
			parent.removeChild( this );
		}
		
	}
}


import core.baseObject;

import flash.display.Bitmap;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

class ItmAward extends baseObject{
	
	private var m_img:Bitmap;
	private var m_text:TextField;
	
	public function ItmAward( img:Bitmap, col:int ){
		
		m_img = img;
		addChild( img );
		
		m_text = new TextField( );
		m_text.defaultTextFormat = new TextFormat( "Candara", 18, 0x000000 );
		m_text.mouseEnabled = false;
		m_text.autoSize = TextFieldAutoSize.LEFT;
		m_text.x = m_img.width + 2;
		m_text.text = "x" + col;
		addChild( m_text );
		
	}
	
	override protected function onDestroy():void{
		if ( m_img ){
			m_img.bitmapData.dispose();
			m_img = null;
		}
	}
	
}