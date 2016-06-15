package game.display.Lobby
{
	import com.greensock.TweenLite;
	
	import core.baseObject;
	import core.gui.progress.IProgress;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	public class ProgressPnlTop extends baseObject implements IProgress
	{
		[Embed(source="../../../../ResourcesGame/game/gui/background_for_iconbar.png")]    
		public static const background_for_iconbar:Class
		
		private var m_value:int = 0;
		
		private var m_max:int = 0;
		
		private var m_pr:Sprite;
		
		private var m_mask:Shape;
		
		private var m_len:int = 155;
		
		private var m_koef:Number = 1;
		
		private var m_delay:int = 0;
		
		private var m_label:TextField;
		
		private var m_backIco:Bitmap;
		
		private var m_ico:Bitmap;
		
		private var m_bar:Sprite;
		
		public function ProgressPnlTop( up:Bitmap , down:Bitmap , ico:Bitmap )
		{
			m_pr = new Sprite( );
			addChild( m_pr );
			m_pr.addChild( down );
			m_mask = new Shape( );
			m_pr.addChild( m_mask );
			m_pr.mask = m_mask;
			addChild( up );	
			
			//m_mask.x = 30;
			m_len = up.width - 8;
			
			m_label = new TextField( );
			m_label.defaultTextFormat = new TextFormat( "Candara", 15, 0xffffff );
			m_label.width = this.width;
			m_label.autoSize = TextFieldAutoSize.CENTER;
			m_label.mouseEnabled = false;
			addChild( m_label );
			Draw();
			m_label.text = m_value+"/"+m_max;
			
			m_backIco = new background_for_iconbar() as Bitmap;
			m_backIco.x = -m_backIco.width;
			addChild( m_backIco );
			
			m_ico = ico;
			m_ico.x = -18;
			m_ico.y = 3;
			addChild( ico );
		}
	
		
		public function Draw( ):void{
			var g:Graphics = m_mask.graphics;
			g.clear();
			g.beginFill( 0xff0000 );
			g.drawRect( 0,0, m_len*m_koef , this.height);
			g.endFill();
		}
		
		public function set Max( max:int ):void{
			if( m_value >= max ) m_value = max;
			
			m_max = max;
			
			m_label.text = m_value+"/"+m_max;
			Draw();
		}
		
		public function set Value( value:int ):void{
			
			if ( value < 0 ) value = 0;
			
			if ( m_bar ) onEndDrawBar();
			m_bar = new Sprite();
			DrawBar( Math.min( value, m_max ) );
			addChildAt( m_bar, 1 );
			TweenLite.to( m_bar, 2 , { delay:1, alpha:0 , onComplete:onEndDrawBar} );
			
			m_value = Math.min( value, m_max );
			
			m_koef = m_value/m_max;
			m_label.text = m_value+"/"+m_max;
			Draw();
		}
		
		private function DrawBar( value:int ):void{
			var t_gr:Graphics = m_bar.graphics;
			t_gr.clear();
			t_gr.beginFill( 0xffffff );
			t_gr.drawRect( m_len * m_koef, 0 , m_len*value/m_max - m_len*m_koef, this.height );
			t_gr.endFill();
		}
		
		private function onEndDrawBar():void{
			if ( m_bar ){
				TweenLite.killTweensOf( m_bar );
				removeChild( m_bar );
				m_bar = null;
			}
		}
		
		public function get Value():int{
			return m_value;
		}
		
		
	}
	
}