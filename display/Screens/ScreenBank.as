package game.display.Screens
{
	import core.baseObject;
	import core.gui.button.glowButton;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import game.Managers.Managers;
	import game.gameplay.bank.baseBank;
	
	import mx.core.MovieClipAsset;

	public class ScreenBank extends baseScreen
	{
		[Embed(source="../../../../ResourcesGame/game/Screens/bank/bank_background.png")]
		private static const bank_background:Class
		
		[Embed(source="../../../../ResourcesGame/game/Screens/bank/copper_coins.png")]
		private static const copper_coins:Class
		
		[Embed(source="../../../../ResourcesGame/game/Screens/bank/gold_coins.png")]
		private static const gold_coins:Class
		
		[Embed(source="../../../../ResourcesGame/game/Screens/bank/horseshoe.png")]
		private static const horseshoe:Class
		
		[Embed(source="../../../../ResourcesGame/game/Screens/bank/libra.png")]
		private static const libra:Class
		
		[Embed(source="../../../../ResourcesGame/game/Screens/bank/silver_coins.png")]
		private static const silver_coins:Class
		
		[Embed(source="../../../../ResourcesGame/game/Screens/bank/lamp_and_butterfly.swf", symbol="lamp_all")]
		private static var lampClass:Class
		private var lampAnimation:DisplayObject;
		
		[Embed(source="../../../../ResourcesGame/game/Screens/bank/glare_animation.swf", symbol="glar_all")]
		private static var glareClass:Class
		private var glareAnimation:MovieClip;
		
		private var m_iBack:Bitmap;
		
		private var m_copper:glowButton;
		private var m_gold:glowButton;
		private var m_horseshoe:glowButton;
		private var m_libra:glowButton;
		private var m_silver:glowButton;
		
		private var m_buyWindow:buyWindow;
		
		public function ScreenBank()
		{
			this.m_internalName = "ScreenBank";
			m_iBack = new bank_background( ) as Bitmap;
			addChild( m_iBack );
			
			var params:Object = { color:0xffffbe, alpha:1, blurX:10, blurY:10, strength:2 };
			
			m_copper    = new glowButton( new copper_coins() as Bitmap, params );
			m_gold      = new glowButton( new gold_coins() as Bitmap, params );
			m_horseshoe = new glowButton( new horseshoe() as Bitmap, params );
			m_libra     = new glowButton( new libra() as Bitmap, params );
			m_silver   = new glowButton( new silver_coins() as Bitmap, params );
			
			m_copper.x    = 530; m_copper.y    = 418; m_copper.Click = CopperClick; m_copper.Hint = " купить медные монеты ";
			m_gold.x      = 370; m_gold.y      = 423; m_gold.Click = GoldClick; m_gold.Hint = " купить золотые монеты ";
			m_horseshoe.x = 285; m_horseshoe.y = 496; m_horseshoe.Click = HorseshoeClick; m_horseshoe.Hint = " купить золотые подковы ";
			m_libra.x     = 206; m_libra.y     = 383; m_libra.Click = LibraClick; m_libra.Hint = " обменник ";
			m_silver.x    = 439; m_silver.y    = 426; m_silver.Click = VekselClick; m_silver.Hint = " купить вексель ";
			
			m_copper.name = "copper";
			m_gold.name = "gold";
			m_horseshoe.name = "horseshoe";
			m_libra.name = "libra";
			m_silver.name = "veksel";
			
			addChild( m_copper );
			addChild( m_gold );
			addChild( m_horseshoe );
			addChild( m_libra );
			addChild( m_silver );
			
			lampAnimation = new lampClass();
			lampAnimation.x = 520;
			lampAnimation.y = 105;
			addChild( lampAnimation );
			
			glareAnimation = new glareClass();
			glareAnimation.x = 190;
			glareAnimation.y = 428;
			glareAnimation.mouseChildren = false;
			glareAnimation.mouseEnabled = false;
			addChild( glareAnimation );
		}
		
		private function CopperClick( ):void{
			onClick( m_copper.name );
		}
		
		private function GoldClick( ):void{
			onClick( m_gold.name );
		}
		
		private function HorseshoeClick( ):void{
			onClick( m_horseshoe.name );
		}
		
		private function LibraClick( ):void{
			onClick( m_libra.name );
		}
		
		private function VekselClick( ):void{
			onClick( m_silver.name );
		}
		
		private function onClick( target:String ):void{
			
			switch ( target ) {
				
				case "gold": ShowBuyWindow( 1 ); break;
				
				case "copper": ShowBuyWindow( 41 ); break;
								
				case "horseshoe": ShowBuyWindow( 91 ); break;
				
				case "veksel": ShowBuyWindow( 131 ); break;
				
				case "libra": ShowExchangeWindow( ); break;
			}
		}
		
		private function ShowExchangeWindow( ):void{
			//окно обменника
		}
		
		private function ShowBuyWindow( startIndex:uint, count:uint = 5 ):void{
			if (m_buyWindow){ removeChild(m_buyWindow); m_buyWindow = null; }
			
			var items:Vector.<baseBank> = new Vector.<baseBank>;
			
			for( var i:uint = startIndex; i < startIndex + count; i++){
				items.push( Managers.bank.getItemByGlobalID( i.toString() ) );
			}
			
			m_buyWindow = new buyWindow( items, Buy );
			m_buyWindow.x = this.width / 2;
			m_buyWindow.y = this.height / 2;
			addChild( m_buyWindow );
			
		}
		
		private function Buy( params:Array ):void{
			trace('id покупки = ', params[0] , '; количество  = ', params[1], '; голосов потрачено - ', params[2] );
		}
		
		override protected function onDestroy():void{
			m_iBack.bitmapData.dispose();
			m_iBack = null;
		}
	}
}

import core.baseObject;
import core.gui.button.TypeButton;
import core.gui.button.stretchButton;

import flash.display.Bitmap;
import flash.text.TextField;

import game.assets.Assets;
import game.gameplay.bank.baseBank;

class buyWindow extends baseObject{
	
	private var m_title:TextField;
	private var m_back:Bitmap;
	private var m_imgs:Vector.<Bitmap>;
	
	public function buyWindow( items:Vector.<baseBank>, Callback:Function ){
		
		m_back = Assets.getBitmap( "" ) as Bitmap;
		addChild( m_back );
		
		m_title = new TextField( );
		m_title.text = "приобрести " + items[0].Name ;
		m_title.x = m_back.width / 2 + m_title.width / 2;
		addChild( m_title );
		
		var dy:int = 20;
		var img:Bitmap;
		var button:stretchButton;
		
		m_imgs = new Vector.<Bitmap>;
		
		for (var i:int = 0; i < items.length; i++){
			img = items[i].Ico;
			img.x = 5;
			img.y = dy;
			addChild( img );
			m_imgs.push( img );
			
			button = new stretchButton( TypeButton.SIMPLE_RED, 50, items[i].Count + " за " + items[i].Price );
			button.Click = Callback;
			button.ReturnParams = new Array( items[i].GlobalID,items[i].Count,items[i].Price );
			button.x = 30;
			button.y = dy;
			addChild(button);
			
			dy += img.height;
		}
	}
	
	override protected function onDestroy():void{
		if ( m_back ) m_back.bitmapData.dispose();
		
		while( m_imgs.length ) ( m_imgs.pop().bitmapData.dispose() ); m_imgs = null;
	}
}