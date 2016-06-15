package game.display.drop
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import core.gui.button.filterButton;
	import core.gui.guiRoot;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Point;

	public class dropVillaga extends filterButton
	{
	
		private var m_or:int = 1;
		
		private var m_speed:int = 1;
		
		private var m_path:Number = 10; 
		
		private var m_len:Number = 0;
		
		private var m_fail:int = 0;
		
		private var m_callback:Function;
		
		public function dropVillaga( bitmap:Bitmap , xx:Number = 0 , yy:Number =0 , _heightFail:int = 0, or:int = 1 , callback:Function = null ) 
		{	
			super( bitmap );//new guiAsset.ico_gold() as Bitmap );
			m_callback = callback
			m_fail = _heightFail;
			x = xx;
			y = yy;
		
			addEventListener( Event.ENTER_FRAME , onFrame );
			this.Click = onSelect;
		}
		
		private function onFrame( event:Event ):void{
			m_len+= m_speed*m_or;
			y+=m_speed*m_or;
			if( m_path < Math.abs( m_len ) ){
				m_len = 0;
				m_or*=-1; 
			}
		}  
		  
		private function onEnd( ):void{
			parent.removeChild( this );
			//TweenLite.to( this , 2 , { alpha:0.1 , onComplete:onEndAlpha }); 
		}
		
		
		private function onEndAlpha( ):void{
			parent.removeChild( this );
		}
		
		private function onSelect( ):void{
			this.Click = null;
			if( m_callback != null ) m_callback() ;
			removeEventListener( Event.ENTER_FRAME , onFrame );
			var oo:int = 1; 
			if( x > guiRoot.sizeWidth/2 ) oo  = -1;
			var p1:Point = new Point( x + 50*oo  , y-50 );
			//var p2:Point = new Point( x + 100*oo , m_fail- this.height/*y+50*/ );
			var p2:Point = new Point( 50, 0 );
			TweenMax.to( this , 1.0 , {bezier:{curviness:0.8, values:[{x:p1.x, y:p1.y}, {x:p2.x, y:p2.y}]}, scaleX:0.1, scaleY:0.1, alpha:0.1, onComplete:onEnd });
		}
		
		override protected function onDestroy():void{
			TweenLite.killTweensOf( this ,true );
			this.m_image.bitmapData.dispose();
			m_image = null;
		}
	}
}

