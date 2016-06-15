package game.display.village
{

	
	import core.gui.Hint;
	import core.gui.TextTooltip;
	import core.gui.button.filterButton;
	import core.gui.guiRoot;
	import core.gui.progress.ProgressBase;
	import core.gui.progress.ProgressTime;
	import core.utils.Rnd;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.getTimer;
	
	import game.Global;
	import game.Managers.Managers;
	import game.assets.Assets;
	import game.assets.guiAsset;
	import game.display.Screens.ScreenVillage;
	import game.display.drop.dropVillaga;
	import game.gameplay.consumed.TypeConsumed;
	import game.gameplay.village.Outhouse;
	import game.types.TypeResources;

	
	
	public class ItmVillage extends  filterButton
	{
		private var m_over:Boolean = false;
	
		private var m_screen:ScreenVillage;
		
		private var m_drop:dropVillaga;
		
		private var m_her:HintVillage;
		
		private var pb:ProgressTime;
		
		private var m_outhouse:Outhouse;
		
		private var m_result:Object = new Object();
		
		public function ItmVillage(  screen:ScreenVillage , outhouse:Outhouse )
		{ 
			super( Assets.getBitmap( outhouse.Image ) );
			m_outhouse 	= outhouse;
			m_screen 	= screen;
			m_filter 	= [ m_colorMatrix ];
			
			var result:Object = m_outhouse.Result;
			for ( var key:* in result ){
				m_result[key] = uint( result[key] );
			}
			
			Click = onSelect;
			addEventListener(Event.ADDED_TO_STAGE , onAdd );
		}
		 
		/*
		private var m_i:int = 0;
		private var m_miss:int = 0;
		private function onFrame( event:Event ):void{
			m_miss++;
			if( m_miss > 3 ){
				m_miss++;
				if(isOver( guiRoot.MousePosition  ) ){
						
				}
			}
		}
		*/
		
		private function onCompleteProgress( event:Event = null ):void{
			
			var drop:Sprite = new Sprite();
			var bitmap:Bitmap;
			var dx:int = 0;
			for( var key:* in m_result ){
				bitmap = Assets.getBitmap( TypeConsumed.Convert( key ).Value + "_ico");
				bitmap.x = dx;
				
				drop.addChild( bitmap );
				
				dx += bitmap.width - 5;
			}
			//Assets.getBitmap( TypeConsumed.Convert( key ).Value + "_ico")
			Hide();
			bitmap = new Bitmap();
			bitmap.bitmapData = new BitmapData( drop.width, drop.height, true, 0x00000000 );
			bitmap.bitmapData.draw( drop );
			
			m_drop = new dropVillaga( bitmap , x+this.width/2 , y-this.height/4 , y+this.height , -1 , onResetTimer  );
			parent.addChild( m_drop );
			
			if (pb){
				pb.removeEventListener( ProgressBase.COMPLETE_PROGRESS_BAR , onCompleteProgress );
				removeChild( pb );
				pb = null;
			}
		}
		
		private function onResetTimer( ):void{
			m_outhouse.TimeProduction = Global.startTimeGame + Math.floor(getTimer() / 1000);
			Global.Server.TakeResources( Global.player.InternalID, m_outhouse.VillageID, m_outhouse.BaseOuthouse.GlobalID , onTakeGood, onTakeBad );
			//Global.Server.TakeResources( Global.player.InternalID, 0, 1, onTakeGood, onTakeBad );
			//onTakeGood( null );
		}
		
		private function onTakeGood( response:* ):void{
			trace('Удалось собрать ресурсы');
			
			for( var key:* in m_result ){
				Global.player.addConsumed( TypeConsumed.Convert(key), m_result[key] );
			}
			
			m_outhouse.TimeProduction = Global.startTimeGame + Math.floor(getTimer() / 1000);
			
			pb = new ProgressTime( m_outhouse.Time , Global.startTimeGame - m_outhouse.TimeProduction + Math.floor(getTimer() / 1000) ); 
			pb.addEventListener( ProgressBase.COMPLETE_PROGRESS_BAR , onCompleteProgress );
			addChild( pb  );
			
			if ( m_outhouse.BaseOuthouse.GlobalID > 99 ){
				try{
					Global.player.setTrophy( int( response.idTrophy ), 1 );
					parent.addChild( new TrophyWindow( response.idTrophy ) );
				}
				catch(err:Error){}
			}
			
			Hide();
		}
		
		private function onTakeBad( response:* ):void{
			trace( 'Не удалось собрать ресурсы - ', response );
		}
		
		private function onAdd( event:Event ):void{
			removeEventListener(Event.ADDED_TO_STAGE , onAdd );
			
			if ( Global.startTimeGame - m_outhouse.TimeProduction + Math.floor(getTimer() / 1000) <= m_outhouse.Time ){
				
				pb = new ProgressTime( m_outhouse.Time , Global.startTimeGame - m_outhouse.TimeProduction + Math.floor(getTimer() / 1000) ); 
				pb.addEventListener( ProgressBase.COMPLETE_PROGRESS_BAR , onCompleteProgress );
				
				addChild( pb  );
			}
			else{
				onCompleteProgress( );
			}
			
		}
		
		private function reOpen( ):void{
			Hide( );
			onSelect( );
		}
		
		public function Hide( ):void{
			if( m_her!=null && m_her.parent!=null ){
				m_her.parent.removeChild( m_her );
				this.Enabled = true;
			}
		}
		
		private function onSelect( ):void{
			m_screen.Hide();
			m_her = new HintVillage( m_outhouse, Boolean(pb != null), reOpen, ForceEnd );
			
			m_her.x = this.x;
			m_her.y = this.y;
			
			if ( m_her.x + m_her.width > parent.width ) m_her.x = parent.width - m_her.width - 10;
			else
				if ( m_her.x < 0 ) m_her.x = 10;
			
			if ( m_her.y + m_her.height > parent.height ) m_her.y = parent.height - m_her.height - 10;
			else
				if ( m_her.y < 0 ) m_her.y = 10;
			
			parent.addChild( m_her );
			
			this.Enabled = false;
		}
		
		private function ForceEnd( ):void{
			pb.Value = pb.Max;
		}
		
		private var m_pos:Point = new Point( );
		public function isOver( pos:Point ):Boolean{
			
			if ( !this.Enabled ) return false;
			
			m_pos.setTo( pos.x , pos.y );
			m_pos = globalToLocal( m_pos );
			
			if( m_image.bitmapData.getPixel( m_pos.x , m_pos.y )!=0){ 
				OVER( );
				return true;
			}
			OUT( );
			return false;
		}
		
		
		public function OUT( ):void{
			if( !m_over ) return;
			m_over = false;	
			Mouse.cursor = MouseCursor.AUTO;    
			filters = null;
		}
		
		public function OVER( ):void{
			if( m_over ) return;
			m_over = true;
			Mouse.cursor = MouseCursor.BUTTON;  
			filters  = m_filter;
		}
		
		override protected function onOut(event:MouseEvent):void{}
		
		override protected function onOver(event:MouseEvent):void{}
		
		override protected function onDestroy():void{
			//removeEventListener( Event.ENTER_FRAME , onFrame  );
		}
	}
}


import core.baseObject;
import core.gui.button.TypeButton;
import core.gui.button.stretchButton;

import flash.display.Bitmap;
import flash.text.TextField;

import game.Managers.Managers;
import game.assets.Assets;
import game.gameplay.trophy.baseTrophy;

class TrophyWindow extends baseObject{
	
	private var m_back:Bitmap;
	private var m_closeBtn:stretchButton;
	private var m_ico:Bitmap;
	private var m_text:TextField;
	
	public function TrophyWindow( idTrophy:String ){
		
		graphics.beginFill( 0x000000, 0.7 );
		graphics.drawRect( 0,0,646,577);
		graphics.endFill();
		
		var trophy:baseTrophy = Managers.trophy.getTrophyByGlobalID( idTrophy );
		
		m_ico = Assets.getBitmap( trophy.Image );
		m_ico.x = 323;
		m_ico.y = 288;
		addChild( m_ico );
		
		m_text = new TextField();
		m_text.text = "Вы получили " + trophy.Name;
		m_text.width = 200;
		m_text.textColor = 0xffffff;
		m_text.mouseEnabled = false;
		m_text.x = m_ico.x;
		m_text.y = m_ico.y + 50;
		addChild( m_text );
		
		m_closeBtn = new stretchButton( TypeButton.SIMPLE_RED, 1, "ОК" );
		m_closeBtn.x = m_text.x;
		m_closeBtn.y = m_text.y + 15;
		m_closeBtn.Click = Close;
		addChild( m_closeBtn );
		
	}
	
	private function Close():void{
		parent.removeChild(this);
	}
	
	override protected function onDestroy():void{
		graphics.clear();
		
		if ( m_back ){
			m_back.bitmapData.dispose();
			m_back = null;
		}
		
		if ( m_ico ){
			m_ico.bitmapData.dispose();
			m_ico = null;
		}
		
	}
	
}