package game.display.ItmScreenSmith
{
	import core.utils.ScrollBar;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import game.Global;
	import game.Managers.Managers;
	import game.assets.Assets;
	import game.display.Screens.ScreenSmith;
	import game.gameplay.ammunition.Ammunition;
	import game.gameplay.ammunition.TypeAmmunition;
	import game.gameplay.consumed.TypeConsumed;
	
	public class TabRepair extends TabSmith
	{
		
		private var m_scrollPanelLeft:Sprite;
		private var m_scrollPanelRight:Sprite;
		private var m_scrollBarLeft:ScrollBar;
		private var m_scrollBarRight:ScrollBar;
		
		private var m_curAmmo:Ammunition;
		
		private namespace CALLBACK;
		
		public function TabRepair(screen:ScreenSmith)
		{
			super(screen);
			
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
			
			if (m_scrollPanelRight.numChildren){
				m_scrollBarRight = new ScrollBar( m_scrollPanelRight, new Rectangle( 0 , m_scrollPanelRight.y , 458, 345 ) );
				m_scrollBarRight.Background = Assets.getBitmap( "back_scroll_alchemist" );
				m_scrollBarRight.CreateScroll();
				m_scrollBarRight.x = 167;
				m_scrollBarRight.y = 223;
				m_scrollBarRight.Offset = 20;
				addChild(m_scrollBarRight);
			}
		}
		
		private function onFill( ):void{
			m_scrollPanelLeft = new Sprite();
			m_scrollPanelRight = new Sprite();
			
			var dx:int = 229;
			var dy:int = 0;
			var count:uint = 0;
			
			var ammunitions:Object = Managers.current_ammunitions.getAmmunitions();
			
			for each ( var ammo:Ammunition in ammunitions ){
				
				if ( ammo.BaseAmmunition.Type == Managers.ammunitions.getAmmunitionByTypeString(TypeAmmunition.UNDERSUITS.toString()).Type ) continue;
				if ( ammo.Health == ammo.BaseAmmunition.Strength ) continue;
				if ( ammo.Repair ) continue;
				
				var itmAmmo:ItmAmmo = new ItmAmmo( ammo, m_screen, onRepair );
				itmAmmo.x = dx;
				itmAmmo.y = dy;
				m_scrollPanelRight.addChild( itmAmmo );
					
				dx -= 229;
					
				count++;
					
				if ( count == 2 ){
					count = 0;
					dx = 229;
					dy += 117;
				}
				
			}
			
			dy = 0;
			
			for( var i:int = 0; i < Global.player.AmmoOnRepair.length; i++ ){
				var itmRepair:ItmRepair = new ItmRepair( Global.player.AmmoOnRepair[i].m_ammunition, Global.player.AmmoOnRepair[i].m_time, onForce, onGetAmmo, Refresh );
				itmRepair.y = dy
				m_scrollPanelLeft.addChild( itmRepair );
				
				dy += itmRepair.height;
			}
		}
		
		private function onForce( ammunition:Ammunition ):void{
			
			m_curAmmo = ammunition;
			
			var canBuy:Boolean = true;
			
			for( var key:* in m_curAmmo.BaseAmmunition.PriceForce ){
				
				if ( Global.player.getConsumed( TypeConsumed.Convert( key ) ) < m_curAmmo.BaseAmmunition.PriceForce[key] ) 
					canBuy = false;
			}
			
			if ( canBuy ){
				for( key in m_curAmmo.BaseAmmunition.PriceForce ){
					Global.player.subConsumed( TypeConsumed.Convert( key ), int( m_curAmmo.BaseAmmunition.PriceForce[key] ) );
				}
				
				Global.Server.ForceRepairWeaponSmity( Global.player.InternalID, m_curAmmo.BaseAmmunition.globalID.toString(), CALLBACK::onForceGood, CALLBACK::onForceBad );
			}
			
		}
		
		CALLBACK function onForceGood( response:Object ):void{
			trace( 'Удалось ускорить' );
			
			Global.player.ForceEndRepairAmmo( m_curAmmo );
			
			Refresh();
		}
		
		CALLBACK function onForceBad( reponse:Object ):void{
			trace( 'Не удалось ускорить' );
		}
		
		private function onGetAmmo( ammunition:Ammunition ):void{
			m_curAmmo = ammunition;
			
			Global.Server.TakeReapirSmithy( Global.player.InternalID, m_curAmmo.BaseAmmunition.globalID.toString(), CALLBACK::onGetGood, CALLBACK::onGetBad );
		}
		
		CALLBACK function onGetGood( response:Object ):void{
			trace( 'Забрали аммуницию' );
			
			m_curAmmo.Repair = false;
			
			Global.player.subAmmoOnRepair( m_curAmmo );
			
			Refresh();
		}
		
		CALLBACK function onGetBad( reponse:Object ):void{
			trace( 'Не удалось забрать' );
		}
		
		private function onRepair( ammunition:Ammunition ):void{
			
			m_curAmmo = ammunition;
			
			var canBuy:Boolean = true;
			var price:Object = ammunition.BaseAmmunition.PriceRepairCoin;
			
			var key:String;
			
			for ( key in ammunition.BaseAmmunition.PriceRepairCons ){
				price[key] = ammunition.BaseAmmunition.PriceRepairCons[key];
			}
			
			for( key in price ){
				
				if ( Global.player.getConsumed( TypeConsumed.Convert( key ) ) < price[key] ) 
					canBuy = false;
			}
			
			if ( canBuy ){
				for( key in price ){
					Global.player.subConsumed( TypeConsumed.Convert( key ), int( price[key] ) );
				}
				Global.Server.RepairAmmunitionSmithy( Global.player.InternalID, ammunition.BaseAmmunition.globalID.toString(), CALLBACK::onRepairGood, CALLBACK::onRepairBad );
				//Global.Server.RepairAmmunition( Global.player.InternalID, ammunition.BaseAmmunition.globalID.toString(), CALLBACK::onRepairGood, CALLBACK::onRepairBad );
			}
			else trace('Недостаточно ресурсов');
			
		}
		
		CALLBACK function onRepairGood( response:Object ):void{
			trace('Удалось');
			
			m_curAmmo.Repair = true;
			
			Global.player.RepairAmmo( m_curAmmo.BaseAmmunition.RepairTime, m_curAmmo );
			
			Refresh( );
		}
		
		CALLBACK function onRepairBad( response:Object ):void{
			trace('Не удалось');
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
			if( m_scrollBarRight != null )
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
import core.utils.TimeToString;

import flash.display.Bitmap;
import flash.display.DisplayObjectContainer;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import game.assets.Assets;
import game.display.ItmConsumed;
import game.gameplay.ammunition.Ammunition;
import game.gameplay.consumed.TypeConsumed;

class ItmAmmo extends baseObject{
	
	private var m_back:Bitmap;
	private var m_damageIco:Bitmap;
	private var m_sandWatch:Bitmap;
	private var m_ico:Bitmap;
	
	private var m_damage:TextField;
	private var m_time:TextField;
	
	private var m_repairBtn:iconButton;
	
	private var m_ammunition:Ammunition;
	private var m_callback:Function;
	
	public function ItmAmmo( ammunition:Ammunition, screen:DisplayObjectContainer, callback:Function ){
		
		m_ammunition = ammunition;
		m_callback = callback;
		
		m_back = Assets.getBitmap( "back_smith_itm_01" );
		addChild( m_back );
		
		m_ico = ammunition.BaseAmmunition.Ico;
		m_ico.smoothing = true;
		m_ico.scaleX = m_ico.scaleY = 0.85;
		m_ico.x = 6;
		addChild( m_ico );
		
		m_damageIco = Assets.getBitmap( "icon_damage" );
		addChild( m_damageIco );
		
		m_damage = new TextField();
		m_damage.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000 );
		m_damage.mouseEnabled = false;
		m_damage.text = ammunition.Health + "/" + ammunition.BaseAmmunition.Strength;
		m_damage.autoSize = TextFieldAutoSize.LEFT;
		m_damage.x = 20;
		addChild( m_damage );
		
		m_sandWatch = Assets.getBitmap( "clock_ico" );
		m_sandWatch.x = 2;
		m_sandWatch.y = m_back.height - m_sandWatch.height - 1;
		addChild( m_sandWatch );
		
		m_time = new TextField();
		m_time.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000 );
		m_time.mouseEnabled = false;
		m_time.text = TimeToString.ConvertTimeToString( ammunition.BaseAmmunition.RepairTime, true );
		m_time.autoSize = TextFieldAutoSize.LEFT;
		m_time.y = 95;
		m_time.x = m_sandWatch.x + m_sandWatch.width + 2;
		addChild( m_time );
				
		var price:Object = ammunition.BaseAmmunition.PriceRepairCons;		
		var dx:int = 72;
		var icon:Bitmap;
		var cost:int = 0;
		var type:String 
		
		for ( type in price ){
			
			var itmCons:ItmConsumed = new ItmConsumed( type, price[type], screen );
			itmCons.x = dx;
			itmCons.y = 1;
			addChild( itmCons );
			dx += 52;
			
		}
		
		price = ammunition.BaseAmmunition.PriceRepairCoin;
		
		for ( type in price ){
			
			switch ( TypeConsumed.Convert( type ) ){
				
				case TypeConsumed.GOLD_COIN:
					icon = Assets.getBitmap( "icon_coin_gold_small" );
					cost = price[type];
					break;
				
				case TypeConsumed.SILVER_COIN:
					icon = Assets.getBitmap( "icon_coin_silver_small" );
					cost = price[type];
					break;
				
				case TypeConsumed.COPPER_COIN:
					icon = Assets.getBitmap( "icon_coin_copper_small" );
					cost = price[type];
					break;
			}	
		}
		
		m_repairBtn = new iconButton( icon, TypeButton.SIMPLE_GREEN, 60, "ремонт за " + cost );
		m_repairBtn.x = 92;
		m_repairBtn.y = m_back.height - m_repairBtn.height - 1;
		m_repairBtn.Click = onRepair;
		addChild( m_repairBtn );
		
	}
	
	private function onRepair( ):void{
		
		m_callback( m_ammunition );
		
	}
	
	override protected function onDestroy():void{
		
		if ( m_back ){
			m_back.bitmapData.dispose();
			m_back = null;
		}
		
		if ( m_damageIco ){
			m_damageIco.bitmapData.dispose();
			m_damageIco = null;
		}
		
		if ( m_sandWatch ){
			m_sandWatch.bitmapData.dispose();
			m_sandWatch = null;
		}
		
		if ( m_ico ){
			m_ico.bitmapData.dispose();
			m_ico = null;
		}
		
	}
	
}


import core.gui.button.stretchButton;
import core.gui.progress.ProgressHint;
import flash.events.Event;
import game.Global;

class ItmRepair extends baseObject{
	
	private var m_back:Bitmap;
	private var m_img:Bitmap;
	private var m_sandWatch:Bitmap;
	private var m_text:TextField;
	private var m_leastTime:TextField;
	private var m_forceBtn:iconButton;
	private var m_getBtn:stretchButton;
	private var m_progress:ProgressHint;
	
	private var m_ammo:Ammunition;
	private var m_onForce:Function;
	private var m_onGet:Function;
	private var m_onRefresh:Function;
	
	public function ItmRepair( ammo:Ammunition, time:int, onForce:Function, onGet:Function, onRefresh:Function ){
		
		m_onForce = onForce;
		m_onGet = onGet;
		m_onRefresh = onRefresh;
		
		m_ammo = ammo;
		
		m_back = Assets.getBitmap( "back_smith_itm_02" );
		addChild( m_back );
		
		m_img = m_ammo.BaseAmmunition.Ico;
		addChild( m_img );
		m_img.smoothing = true;
		m_img.scaleX = m_img.scaleY = 0.85;
		m_img.x = 2;
		m_img.y = 20;
		
		if ( time == 0 ){
			m_getBtn = new stretchButton( TypeButton.SIMPLE_GREEN, 10, "забрать" );
			m_getBtn.x = 35;
			m_getBtn.y = 15;
			m_getBtn.Click = GetClick;
			addChild( m_getBtn );
		}
		else{
			
			if ( time != m_ammo.BaseAmmunition.RepairTime ){
				
				var icon:Bitmap;
				var cost:int = 0;
			
				for(var type:* in m_ammo.BaseAmmunition.PriceForce ){
					
					switch ( TypeConsumed.Convert( type ) ){
						
						case TypeConsumed.GOLD_COIN:
							icon = Assets.getBitmap( "icon_coin_gold_small" );
							cost = m_ammo.BaseAmmunition.PriceForce[type];
							break;
						
						case TypeConsumed.SILVER_COIN:
							icon = Assets.getBitmap( "icon_coin_silver_small" );
							cost = m_ammo.BaseAmmunition.PriceForce[type];
							break;
						
						case TypeConsumed.COPPER_COIN:
							icon = Assets.getBitmap( "icon_coin_copper_small" );
							cost = m_ammo.BaseAmmunition.PriceForce[type];
							break;
					}
					
					m_forceBtn = new iconButton( icon, TypeButton.DIFFICULT_GREEN, 70, "закончить за "+cost );
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
			m_text.x = 75;
			m_text.y = 30;
			addChild( m_text );
			
			m_sandWatch = Assets.getBitmap( "icon_clock" );
			m_sandWatch.x = 75;
			m_sandWatch.y = 45;
			addChild( m_sandWatch );
			
			m_leastTime = new TextField();
			m_leastTime.defaultTextFormat = new TextFormat( "Candara", 18, 0x000000 );
			m_leastTime.autoSize = TextFieldAutoSize.LEFT;
			m_leastTime.text = String(time);
			m_leastTime.mouseEnabled = false;
			m_leastTime.x = 90;
			m_leastTime.y = 40;
			addChild( m_leastTime );
			
			m_progress = new ProgressHint( Assets.getBitmap( "vill_list_top_bar" ) );
			m_progress.Color = 0x00ffd8;
			m_progress.Max = m_ammo.BaseAmmunition.RepairTime;
			m_progress.Value = m_ammo.BaseAmmunition.RepairTime - time;
			m_progress.x = 75;
			m_progress.y = 65;
			m_progress.showLabel(false);
			addChild( m_progress );
		}
		
	}
	
	private function onEnterFrame( e:Event ):void{
		if ( Global.player.AmmoOnRepair[0].m_time != ( m_ammo.BaseAmmunition.RepairTime - m_progress.Value ) ){
			m_progress.Value = m_ammo.BaseAmmunition.RepairTime - Global.player.AmmoOnRepair[0].m_time;
			m_leastTime.text = String( Global.player.AmmoOnRepair[0].m_time );
			
			if ( m_progress.Value == m_progress.Max ){
				removeEventListener( Event.ENTER_FRAME, onEnterFrame );
				
				m_onRefresh();
				
			}
		}
	}
	
	private function GetClick():void{
		m_onGet( m_ammo );
	}
	
	private function ForceClick():void{
		
		removeEventListener( Event.ENTER_FRAME, onEnterFrame );
		
		m_onForce( m_ammo );
	}
	
	override protected function onDestroy():void{
		
		removeEventListener( Event.ENTER_FRAME, onEnterFrame );
		
		if ( m_back ){
			m_back.bitmapData.dispose();
			m_back = null;
		}
		
		if ( m_sandWatch ){
			m_sandWatch.bitmapData.dispose();
			m_sandWatch = null;
		}
		
		if ( m_img ){
			m_img.bitmapData.dispose();
			m_img = null;
		}
		
	}
	
}
