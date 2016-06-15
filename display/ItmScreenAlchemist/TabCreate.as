package game.display.ItmScreenAlchemist
{
	import core.utils.ScrollBar;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import game.Global;
	import game.Managers.Managers;
	import game.assets.Assets;
	import game.display.ItmScreenAlchemist.TabAlchemist;
	import game.display.Screens.ScreenAlchemist;
	import game.gameplay.alchemy.basePotion;
	import game.gameplay.consumed.TypeConsumed;

	public class TabCreate extends TabAlchemist
	{
		private var m_scrollPanelLeft:Sprite;
		private var m_scrollPanelRight:Sprite;
		private var m_scrollBarLeft:ScrollBar;
		private var m_scrollBarRight:ScrollBar;
		
		private var m_usedPotion:basePotion;
		
		private namespace CALLBACK;
		
		public function TabCreate( screen:ScreenAlchemist )
		{
			super( screen );
			
			onFill( );
			
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}
		
		private function onAddedToStage( e:Event ):void{
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			
			CreateScrolls();
		}
		
		private function CreateScrolls():void{
			if (m_scrollPanelLeft.numChildren){
				m_scrollBarLeft = new ScrollBar( m_scrollPanelLeft, new Rectangle( 0 , m_scrollPanelLeft.y , 143, 345 ) );
				m_scrollBarLeft.Background = Assets.getBitmap( "back_scroll_alchemist" );
				m_scrollBarLeft.CreateScroll();
				m_scrollBarLeft.x = 8;
				m_scrollBarLeft.y = 223;
				m_scrollBarLeft.Offset = 20;
				addChild(m_scrollBarLeft);
			}
			
			m_scrollBarRight = new ScrollBar( m_scrollPanelRight, new Rectangle( 0 , m_scrollPanelRight.y , m_scrollPanelRight.width, 345 ) );
			m_scrollBarRight.Background = Assets.getBitmap( "back_scroll_alchemist" );
			m_scrollBarRight.CreateScroll();
			m_scrollBarRight.x = 167;
			m_scrollBarRight.y = 223;
			m_scrollBarRight.Offset = 20;
			addChild(m_scrollBarRight);
		}
		
		private function onFill( ):void{
			m_scrollPanelLeft = new Sprite();
			m_scrollPanelRight = new Sprite();
			
			var dx:int = 0;
			var dy:int = 0;
			var count:uint = 0;
			
			for(var i:int = 1; i < 1000; i++){
				var potion:basePotion = Managers.potions.getPotionByGlobalID( i.toString() );
				
				if ( potion ){
					var itmPotion:ItmPotion = new ItmPotion( potion, onCreate );
					itmPotion.x = dx;
					itmPotion.y = dy;
					m_scrollPanelRight.addChild( itmPotion );
					
					dx += itmPotion.width;
					
					count++;
					
					if ( count == 2 ){
						count = 0;
						dx = 0;
						dy += itmPotion.height;
					}
				}
			}
			
			dy = 0;
						
			for( i = 0; i < Global.player.PotionInCreate.length; i++ ){
				var itmCreate:ItmCreate = new ItmCreate( Global.player.PotionInCreate[i].m_potion, Global.player.PotionInCreate[i].m_time, onForce, onGetPotion, Refresh );
				itmCreate.y = dy
				m_scrollPanelLeft.addChild( itmCreate );
				
				dy += itmCreate.height;
			}
		}
		
		private function onForce( potion:basePotion ):void{
			m_usedPotion = potion;
			
			var canBuy:Boolean = true;
			
			for( var key:* in potion.forcePrice ){
				
				if ( Global.player.getConsumed( TypeConsumed.Convert( key ) ) < potion.forcePrice[key] ) 
					canBuy = false;
			}
			
			if ( canBuy ){
				for( key in potion.forcePrice ){
					Global.player.subConsumed( TypeConsumed.Convert( key ), int( potion.forcePrice[key] ) );
				}
				
				Global.Server.ForceCompletePotion( Global.player.InternalID, potion.GlobalID, CALLBACK::onForceGood, CALLBACK::onForceBad );
			}
			
		}
		
		CALLBACK function onForceGood( response:Object ):void{
			trace( 'Удалось ускорить' );
			
			Global.player.ForceEndCreatePotion( m_usedPotion );
			
			Refresh();
		}
		
		CALLBACK function onForceBad( reponse:Object ):void{
			trace( 'Не удалось ускорить' );
		}
		
		private function onGetPotion( potion:basePotion ):void{
			m_usedPotion = potion;
			//отправить на сервер запрос на взятие зельe
			Global.Server.TakePotion( Global.player.InternalID, potion.GlobalID, CALLBACK::onGetGood, CALLBACK::onGetBad );
		}
		
		CALLBACK function onGetGood( response:Object ):void{
			trace( 'Забрали зелье' );
			
			Global.player.subPotionInCreate( m_usedPotion );
			
			Refresh();
		}
		
		CALLBACK function onGetBad( reponse:Object ):void{
			trace( 'Не удалось забрать зелье' );
		}
		
		private function onCreate( potion:basePotion ):void{
			m_usedPotion = potion;
			
			var canBuy:Boolean = true;
			var price:Object = potion.CreatePriceCoin;
			
			var key:String;
			
			for ( key in potion.CreatePriceCons ){
				price[key] = potion.CreatePriceCons[key];
			}
			
			for( key in price ){
				
				if ( Global.player.getConsumed( TypeConsumed.Convert( key ) ) < price[key] ) 
					canBuy = false;
			}
			
			if ( canBuy ){
				for( key in price ){
					Global.player.subConsumed( TypeConsumed.Convert( key ), int( price[key] ) );
				}
				
				Global.Server.createPotion( Global.player.InternalID, potion.GlobalID, CALLBACK::onCreateGood, CALLBACK::onCreateBad );
			}
			else trace('Не достаточно ресурсов');
		}
		
		CALLBACK function onCreateGood( response:Object ):void{
			trace('Удалось создать зелье');
			
			Global.player.CreatePotion( m_usedPotion.Time, m_usedPotion );
			
			Refresh( );
		}
		
		CALLBACK function onCreateBad( response:Object ):void{
			trace('Не удалось создать зелье');
		}
		
		private function Refresh( ):void{
			var child:*;
			
			while ( m_scrollPanelLeft.numChildren ){
				
				child = m_scrollPanelLeft.getChildAt( 0 )
				
				if ( child is Bitmap ){
					child.bitmapData.dispose();
				}
				
				m_scrollPanelLeft.removeChild( child );
				
				child = null;
			}
			
			while ( m_scrollPanelRight.numChildren ){
				
				child = m_scrollPanelRight.getChildAt( 0 )
				
				if ( child is Bitmap ){
					child.bitmapData.dispose();
				}
				
				m_scrollPanelRight.removeChild( child );
				
				child = null;
			}
			
			if (m_scrollBarLeft){
				removeChild( m_scrollBarLeft );
				m_scrollBarLeft = null;
			}
			
			removeChild( m_scrollBarRight );
			m_scrollBarRight = null;
			
			onFill();
			
			CreateScrolls();
		}
		
	}
}

import core.baseObject;
import core.gui.button.TypeButton;
import core.gui.button.iconButton;
import core.gui.progress.ProgressHint;

import flash.display.Bitmap;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.utils.Timer;

import game.Global;
import game.Managers.Managers;
import game.assets.Assets;
import game.gameplay.alchemy.basePotion;
import game.gameplay.consumed.TypeConsumed;
import game.gameplay.garden.baseFlower;

class ItmPotion extends baseObject{
	
	private var m_potion:basePotion;
	private var m_back:Bitmap;
	private var m_img:Bitmap;
	private var m_title:TextField;
	private var m_recept:TextField;	
	private var m_col:TextField;
	private var m_createBtn:iconButton;
	private var m_icon:Bitmap;
	private var m_iconText:TextField = new TextField();
	private var m_callBack:Function;
	private var m_iconVector:Vector.<Bitmap> = new Vector.<Bitmap>;
	
	public function ItmPotion( potion:basePotion, callBack:Function ) {
		
		m_potion = potion;
		m_callBack = callBack;
		
		m_back = Assets.getBitmap( "back_alchemist_icons" );
		addChild( m_back );
		
		m_title = new TextField();
		m_title.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000 );
		m_title.autoSize = TextFieldAutoSize.LEFT;
		m_title.text = potion.Name;
		m_title.mouseEnabled = false;
		m_title.x = 100;
		m_title.y = 2;
		addChild( m_title );
		
		m_recept = new TextField();
		m_recept.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000 );
		m_recept.autoSize = TextFieldAutoSize.LEFT;
		m_recept.text = "рецепт";
		m_recept.mouseEnabled = false;
		m_recept.rotationZ -= 90;
		m_recept.x = 0;
		m_recept.y = 150;
		addChild( m_recept );
		
		m_img = Assets.getBitmap( m_potion.Image );
		m_img.x = 4;
		m_img.y = 2;
		addChild( m_img );
		
		m_col = new TextField();
		m_col.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000 );
		m_col.autoSize = TextFieldAutoSize.LEFT;
		m_col.text = "x"+Global.player.getPotion( m_potion.GlobalID );
		m_col.mouseEnabled = false;
		m_col.x = m_img.x + m_img.width / 2  - m_col.width / 2;
		m_col.y = 65;
		addChild( m_col );
		
		var key:*;
		
		for( key in m_potion.CreatePriceCoin ){
			switch ( TypeConsumed.Convert( key ) ){
				case TypeConsumed.GOLD_COIN:
					m_createBtn = new iconButton( Assets.getBitmap( "icon_coin_gold_small" ), TypeButton.DIFFICULT_GREEN, 80, " сварить за "+m_potion.CreatePriceCoin[key] );
					break;
				
				case TypeConsumed.SILVER_COIN:
					m_createBtn = new iconButton( Assets.getBitmap( "icon_coin_silver_small" ), TypeButton.DIFFICULT_GREEN, 80, " сварить за "+m_potion.CreatePriceCoin[key] );
					break;
				
				case TypeConsumed.COPPER_COIN:
					m_createBtn = new iconButton( Assets.getBitmap( "icon_coin_copper_small" ), TypeButton.DIFFICULT_GREEN, 80, " сварить за "+m_potion.CreatePriceCoin[key] );
					break;
			}
		}
		
		var dx:int = 20;
		for( key in m_potion.CreatePriceCons ){
			
			var flower:baseFlower = Managers.garden.getFlowerByType( TypeConsumed.Convert( key ) );
					
			if ( flower ){
				var	itmFlower:ItmFlower = new ItmFlower( flower, m_potion.CreatePriceCons[key] );
				itmFlower.x = dx;
				itmFlower.y = 90;
				addChild( itmFlower );
						
				dx += itmFlower.width + 5;
			}
			
		}
		
		dx = 80;
		var dy:int = 40;
		var count:uint = 0;
		for( key in m_potion.Give ){
			
			var icon:Bitmap;
			
			switch( TypeConsumed.Convert(key) ){
				case TypeConsumed.HEALTH:
					icon = Assets.getBitmap("ico_heart");
					break;
				case TypeConsumed.HONOR:
					icon = Assets.getBitmap("ico_flag");
					break;
				case TypeConsumed.EXP:
					icon = Assets.getBitmap("ico_star");
					break;
				case TypeConsumed.ATTACK:
					icon = Assets.getBitmap("icon_damage");
					break;
				case TypeConsumed.PROTECT:
					icon = Assets.getBitmap("icon_shield");
					break;
			}
			
			icon.x = dx;
			icon.y = dy;
			addChild( icon );
			
			var text:TextField = new TextField(); 
			text.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000 );
			text.autoSize = TextFieldAutoSize.LEFT;
			text.text = "+" + m_potion.Give[key];
			text.mouseEnabled = false;
			text.x = icon.x + 20;
			text.y = dy - 5;
			addChild( text );
			
			m_iconVector.push( icon );
			
			dx += 70;
			
			count++;
			
			if ( count == 2 ){
				count = 0;
				
				dx = 80;
				dy += icon.height + 5;
			}
		}
		
		m_createBtn.x = 75;
		m_createBtn.y = 5;
		m_createBtn.Click = onClick;
		addChild( m_createBtn );
		
	}
	
	private function onClick( ):void{
		m_callBack( m_potion );
	}
	
	override protected function onDestroy():void{
		if ( m_back ){
			m_back.bitmapData.dispose();
			m_back = null;
		}
		if ( m_img ){
			m_img.bitmapData.dispose();
			m_img = null;
		}
		
		while(m_iconVector.length){
			m_iconVector.pop().bitmapData.dispose();
		}
		m_iconVector = null;
	}
	
}

class ItmFlower extends baseObject{
	
	private var m_img:Bitmap;
	private var m_col:TextField;
	
	public function ItmFlower( flower:baseFlower, col:String ){
		
		m_img = Assets.getBitmap( flower.Img );
		addChild( m_img );
		
		m_col = new TextField();
		m_col.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000 );
		m_col.autoSize = TextFieldAutoSize.LEFT;
		m_col.text = col + "/" + Global.player.getConsumed( flower.Type );
		m_col.mouseEnabled = false;
		m_col.x = m_img.width / 2 - m_col.width / 2;
		m_col.y = 60;
		addChild( m_col );
		
	}
	
	override protected function onDestroy():void{
		
		if ( m_img ){
			m_img.bitmapData.dispose();
			m_img = null;
		}
		
	}
	
}

import flash.events.Event;
import core.gui.button.stretchButton;
import core.utils.TimeToString;

class ItmCreate extends baseObject{
	
	private var m_back:Bitmap;
	private var m_img:Bitmap;
	private var m_sandWath:Bitmap;
	private var m_text:TextField;
	private var m_leastTime:TextField;
	private var m_forceBtn:iconButton;
	private var m_getBtn:stretchButton;
	private var m_progress:ProgressHint;
	
	private var m_potion:basePotion;
	private var m_onForce:Function;
	private var m_onGet:Function;
	private var m_onRefresh:Function;
	
	public function ItmCreate( potion:basePotion, time:int, onForce:Function, onGet:Function, onRefresh:Function ){
		
		m_onForce = onForce;
		m_onGet = onGet;
		m_onRefresh = onRefresh;
		
		m_potion = potion;
		
		m_back = Assets.getBitmap( "back_alchemist_create" );
		addChild( m_back );
		
		m_img = Assets.getBitmap( potion.Image );
		addChild( m_img );
		m_img.x = 2;
		m_img.y = 30;
		
		if ( time == 0 ){
			m_getBtn = new stretchButton( TypeButton.SIMPLE_GREEN, 10, "забрать" );
			m_getBtn.x = 60;
			m_getBtn.y = 50;
			m_getBtn.Click = GetClick;
			addChild( m_getBtn );
		}
		else{
			
			if ( time != potion.Time ){
				for(var key:* in potion.forcePrice ){
					if ( TypeConsumed.Convert( key ) == TypeConsumed.GOLD_COIN )
						m_forceBtn = new iconButton( Assets.getBitmap( "icon_coin_gold_small" ), TypeButton.DIFFICULT_GREEN, 70, "закончить за "+potion.forcePrice[key] );
					else
						m_forceBtn = new iconButton( Assets.getBitmap( "icon_coin_silver_small" ), TypeButton.DIFFICULT_GREEN, 70, "закончить за "+potion.forcePrice[key] );
			
					m_forceBtn.x = 5;
					m_forceBtn.y = 2;
					m_forceBtn.Click = ForceClick;
					addChild( m_forceBtn );
				
					addEventListener( Event.ENTER_FRAME, onEnterFrame );
				}
			}
			
			m_text = new TextField();
			m_text.defaultTextFormat = new TextFormat( "Candara", 12, 0x000000 );
			m_text.autoSize = TextFieldAutoSize.LEFT;
			m_text.text = "осталось";
			m_text.mouseEnabled = false;
			m_text.x = 70;
			m_text.y = 25;
			addChild( m_text );
			
			m_sandWath = Assets.getBitmap( "icon_clock" );
			m_sandWath.x = 70;
			m_sandWath.y = 45;
			addChild( m_sandWath );
			
			m_leastTime = new TextField();
			m_leastTime.defaultTextFormat = new TextFormat( "Candara", 18, 0x000000 );
			m_leastTime.autoSize = TextFieldAutoSize.LEFT;
			m_leastTime.text = TimeToString.ConvertTimeToString( time, true );
			m_leastTime.mouseEnabled = false;
			m_leastTime.x = 85;
			m_leastTime.y = 40;
			addChild( m_leastTime );
			
			m_progress = new ProgressHint( Assets.getBitmap( "vill_list_top_bar" ) );
			m_progress.Color = 0x00ffd8;
			m_progress.Max = potion.Time;
			m_progress.Value = potion.Time - time;
			m_progress.x = 70;
			m_progress.y = 65;
			m_progress.showLabel(false);
			addChild( m_progress );
		}
		
	}
	
	private function onEnterFrame( e:Event ):void{
		if ( Global.player.PotionInCreate[0].m_time != ( m_potion.Time - m_progress.Value ) ){
			m_progress.Value = m_potion.Time - Global.player.PotionInCreate[0].m_time;
			m_leastTime.text = TimeToString.ConvertTimeToString( Global.player.PotionInCreate[0].m_time, true );
			
			if ( m_progress.Value == m_progress.Max ){
				removeEventListener( Event.ENTER_FRAME, onEnterFrame );
				
				m_onRefresh();
				
			}
		}
	}
	
	private function GetClick():void{
		m_onGet( m_potion );
	}
	
	private function ForceClick():void{
		
		removeEventListener( Event.ENTER_FRAME, onEnterFrame );
		
		m_onForce( m_potion );
	}
	
	override protected function onDestroy():void{
		
		removeEventListener( Event.ENTER_FRAME, onEnterFrame );
		
		if ( m_back ){
			m_back.bitmapData.dispose();
			m_back = null;
		}
		
		if ( m_img ){
			m_img.bitmapData.dispose();
			m_img = null;
		}
		
		if ( m_sandWath ){
			m_sandWath.bitmapData.dispose();
			m_sandWath = null;
		}
	}
	
}