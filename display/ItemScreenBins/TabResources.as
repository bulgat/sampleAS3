package game.display.ItemScreenBins
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import game.Managers.Managers;
	import game.assets.Assets;
	import game.display.Screens.ScreenBins;
	import game.gameplay.consumed.baseConsumed;
	import game.gameplay.garden.baseFlower;

	public class TabResources extends TabBins
	{
		
		private var m_bgr_name_resources:Vector.<Bitmap> = new Vector.<Bitmap>;
	
		public function TabResources(screen:ScreenBins )
		{
			super( screen );
						
			fillLine( 'Ресурсы', 0, 48 );
			fillLine( 'Продукты', 100, 185 );
			fillLine( 'Растения', 200, 322 );
		}
		
		private function fillLine( title:String, index:int, offset:int ):void{
			var t:baseConsumed;
			var dx:int = 20;
			var itm:ItmTabResources;
			
			var bgr:Bitmap = Assets.getBitmap( "bgr_name_resources" );
			bgr.y = offset;
			addChild( bgr );
			m_bgr_name_resources.push( bgr );
			
			var resourseName:TextField = new TextField();
			resourseName.defaultTextFormat = new TextFormat( "Candara", 16, 0xFFFFFF );
			resourseName.text = title;
			resourseName.x = 30;
			resourseName.y = bgr.y;
			resourseName.mouseEnabled = false;
			addChild( resourseName );
			
			
			for( var i:int = index; i < index + 100; i++ ){
				t = Managers.consumed.getConsumedByGlobalID( i.toString() );
				if( t!=null ){
					itm = new ItmTabResources( this, t, Refresh );
					addChild( itm );
					itm.x = dx;
					itm.y = bgr.y + 35;
					dx += 60;
				}
			}
		}
		
		private function Refresh():void{
			while ( this.numChildren ){
				
				var child:* = this.getChildAt( 0 )
				
				if ( child is Bitmap ){
					child.bitmapData.dispose();
				}
				
				this.removeChild( child );
				
				child = null;
			}
			
			fillLine( 'Ресурсы', 0, 48 );
			fillLine( 'Продукты', 100, 185 );
			fillLine( 'Растения', 200, 322 );
		}
		
		override protected function onDestroy():void{
			while ( m_bgr_name_resources.length ){
				m_bgr_name_resources.pop().bitmapData.dispose();
			}
			m_bgr_name_resources = null;
		}
		
	}
}

import core.baseObject;
import core.gui.button.TypeButton;
import core.gui.button.stretchButton;

import flash.display.Bitmap;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import game.Global;
import game.Managers.Managers;
import game.assets.Assets;
import game.display.ItemScreenBins.TabResources;
import game.display.ItemScreenBins.WinBuyResources;
import game.gameplay.consumed.baseConsumed;


class ItmTabResources extends baseObject{ 

	private var m_resourse:baseConsumed;
	private var m_label:TextField;
	private var m_btnBuy:stretchButton;
	
	private var m_image:Bitmap;
	private var m_back:Bitmap;
	
	private var m_tab:TabResources;
	private var m_refresh:Function;
	
	public function ItmTabResources( tabRes:TabResources , resourse:baseConsumed, refresh:Function ){
	   m_tab  = tabRes;
	   m_back = Assets.getBitmap( "background_icon" );
       addChild( m_back );
	   m_resourse = resourse;
	   m_image    = m_resourse.Ico;
	   m_image.x = this.width/2 - m_image.width/2;
	   addChild( m_image );
	   
	   m_refresh = refresh;
	   
	   m_label   = new TextField( );
	   m_label.mouseEnabled = false;
	   m_label.width = m_back.width;
	   m_label.height = 25;
	   m_label.autoSize = TextFieldAutoSize.CENTER;
	   m_label.text = "x"+Global.player.getConsumed( m_resourse.Type ).toString();
	   m_label.y = m_back.height - m_label.height;
	   addChild( m_label );
	   
	   m_btnBuy   = new stretchButton( TypeButton.SIMPLE_RED, 1, "Купить" );
	   m_btnBuy.x = width/2 - m_btnBuy.width/2;
	   m_btnBuy.y = height;
	   m_btnBuy.Click = onBuy;
	   addChild( m_btnBuy );
	}
	
	
	private function onBuy( ):void{
		m_tab.m_screen.addChild(  new WinBuyResources( m_resourse, m_refresh ) );
	}
	
	override protected function onDestroy():void{
		if ( m_image ){
			m_image.bitmapData.dispose();
			m_image = null;
		}
	}
}