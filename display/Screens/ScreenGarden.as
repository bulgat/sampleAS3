package game.display.Screens
{

	import com.greensock.TweenLite;
	
	import core.baseObject;
	

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.getTimer;
	

	import mx.core.MovieClipAsset;
	
	import core.baseObject;
	import core.gui.button.filterButton; 
	

	import game.Global;

	import game.Managers.Managers;
	import game.assets.Assets;
	import game.gameplay.consumed.TypeConsumed;
	import game.gameplay.garden.ItmFlower;
	import game.gameplay.garden.baseFlower;
	

	public class ScreenGarden extends baseScreen 
	{
		[Embed(source="../../../../ResourcesGame/game/Screens/garden/garden_background.png")]   
		public static const gardenBack:Class
		
		[Embed(source="../../../../ResourcesGame/game/Screens/garden/water.swf", symbol="water_all")]       
		private var waterClass:Class;
		private var m_water:DisplayObject;
		
		[Embed(source="../../../../ResourcesGame/game/Screens/garden/butterfly_animation.swf", symbol="butterfly_all")]
		private var butterflyClass:Class;
		private var m_butterfly:DisplayObject;
		
		private var m_iBack:Bitmap;
		
		private var m_currentFlower:ItmFlower;
		
		private var m_flowersPanel:Vector.<ImgFlower>;
		
		private var m_flowers:Object;
		
		public function ScreenGarden()
		{
			
			Mouse.cursor = MouseCursor.AUTO;
			
			this.m_internalName = "ScreenGarden";
			m_iBack = new gardenBack( ) as Bitmap;
			addChild( m_iBack );
			
			m_water = new waterClass();
			m_water.x = 324;
			m_water.y = 272;
			addChild( m_water );
			
			m_butterfly = new butterflyClass();
			m_butterfly.x = 220;
			m_butterfly.y = 140;
			
			if ( Global.startTimeGame + getTimer()*1000 - Global.player.GardenTime > Global.player.GardenRefresh ){ 
			
				m_flowers = Global.player.getGarden();
			
				var arr:Array = new Array();
			
				for (var flower:* in m_flowers){
				trace(flower, ' = ',m_flowers[flower] );
				arr.push( flower );
				}
				
				if ( arr.length ) onFill( arr );
				else onFillBad( );
			}
			else onGardenBad( null );
		}
		
		private function onFill( flowers:Array ):void{
			
			AddPanel( );
			
			for(var i:int = 0; i < flowers.length; i++){
				
				var itmFlower:ItmFlower = new ItmFlower( Managers.garden.getFlowerByType( TypeConsumed.Convert( flowers[i] ) ), GetFlower );				
				addChild( itmFlower );
			}
			
			addChild( m_butterfly );
		}
		
		private function onFillBad( ):void{
			Global.Server.getInfoGarden( Global.player.InternalID, onGardenGood, onGardenBad );
		}
		
		private function onGardenGood( response:Object ):void{
			
			//onFill( response );
			
			addChild( m_butterfly );
		}
		
		private function onGardenBad( response:Object ):void{
			trace('Нужно подождать');
			addChild( m_butterfly );
		}
		
		private function AddPanel( ):void{
			
			//ещё сюда добавить бэкграунт для панели			
			
			var dx:int = 10;
			var dy:int = 10;
			
			m_flowersPanel = new Vector.<ImgFlower>;
			
			
			for ( var flower:* in m_flowers ){
				
				var imgFlower:ImgFlower = new ImgFlower( Managers.garden.getFlowerByType( TypeConsumed.Convert( flower ) ) );
				imgFlower.x = dx;
				imgFlower.y = dy;
				
				imgFlower.colorTransform( 255 ) ;
				
				addChild( imgFlower );
				
				m_flowersPanel.push( imgFlower );
				
				dy += 70;
				
			}
		}
		
		private function GetFlower( target:ItmFlower ):void{
			m_currentFlower = target;
			
			Global.Server.GetFlower( Global.player.InternalID , m_currentFlower.Type.Value, GetFlowerGood , GetFlowerBad );
			//GetFlowerGood( "true" );
		}
		
		private function GetFlowerGood( response:* ):void{
					
			for( var i:int = 0; i < m_flowersPanel.length; i++ ){
				if ( m_currentFlower.Type == m_flowersPanel[i].Type ){
					
					TweenLite.to( m_currentFlower, 0.25, {x:m_flowersPanel[i].x, y:m_flowersPanel[i].y, onComplete:RemoveFlower, onCompleteParams:[m_currentFlower, m_flowersPanel[i]] } );
					
					Global.player.addConsumed( m_currentFlower.Type,  m_flowers[ m_currentFlower.Type.Value ]);
					
					Global.player.setGarden( m_currentFlower.Type );
					
					delete m_flowers[ m_currentFlower.Type.Value ];
				}
			}
			
			Mouse.cursor = MouseCursor.AUTO;
		}
		
		private function GetFlowerBad( response:* ):void{
			trace( 'Не удалось взять цветок - ', response ); 
		}
		
		private function RemoveFlower( target:ItmFlower, flower:ImgFlower ):void{
			
			flower.colorTransform( 0 );
			
			TweenLite.killTweensOf( target );
			removeChild( target );
		}
		
		override protected function onDestroy():void{
			m_iBack.bitmapData.dispose();
			m_iBack = null;
			
			var noFlower:Boolean = true;
			for (var flower:* in m_flowers) noFlower = false;
			
			if ( noFlower ) Global.player.GardenTime = Global.startTimeGame + getTimer() * 1000;
		}
	}
}

import flash.geom.ColorTransform;
import flash.display.Bitmap;

import core.baseObject;

import game.gameplay.consumed.TypeConsumed;
import game.gameplay.garden.baseFlower;
import game.assets.Assets;

class ImgFlower extends baseObject{
	
	private var m_img:Bitmap;
	private var m_type:TypeConsumed;
	
	public function ImgFlower( BaseFlower:baseFlower ){
		m_img = Assets.getBitmap( BaseFlower.Img );
		addChild(m_img);
		
		m_type = BaseFlower.Type;
	}
	
	public function colorTransform( offset:int ):void{
		var ct:ColorTransform = new ColorTransform();
		ct.redOffset = offset;
		ct.blueOffset = offset;
		ct.greenOffset = offset;
		
		m_img.transform.colorTransform = ct;
	}
	
	public function get Type( ):TypeConsumed{
		return m_type;
	}
	
	override protected function onDestroy():void{
		m_img.bitmapData.dispose();
		m_img = null;
	}
	
}