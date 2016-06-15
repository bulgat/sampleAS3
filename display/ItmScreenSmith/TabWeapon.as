package game.display.ItmScreenSmith
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import game.Global;
	import game.Managers.Managers;
	import game.assets.Assets;
	import game.display.Screens.ScreenSmith;
	import game.gameplay.ammunition.baseAmmunition;
	import game.gameplay.consumed.TypeConsumed;
	
	public class TabWeapon extends TabSmith
	{
		
		private var m_panel:Sprite;
		private var m_frame:Bitmap;
		private var m_text:TextField;
		
		private var m_curAmmo:baseAmmunition;
		
		private namespace CALLBACK;
		
		public function TabWeapon(screen:ScreenSmith)
		{
			super(screen);
			
			onFill( );
			
			m_frame = Assets.getBitmap( "frame_smith" );
			m_frame.x = 9;
			m_frame.y = 217;
			addChild( m_frame );
			
			m_text = new TextField( );
			m_text.defaultTextFormat = new TextFormat( "Candara", 18, 0xFFFFFF );
			m_text.mouseEnabled = false;
			m_text.text = "Новые товары доступны с 100 уровня";
			m_text.autoSize = TextFieldAutoSize.LEFT;
			m_text.y = 220;
			m_text.x = 100;
			addChild( m_text );
		}

		private function onFill( ):void{
			
			m_panel = new Sprite( );
			m_panel.x = 7;
			m_panel.y = 250;
			addChild( m_panel );
			
			var dx:int = 0;
			var dy:int = 0;
			var j:uint = 0;
			
							
			for(var i:int = 900; i < 1000; i++){
				
				var weapon:baseAmmunition = Managers.ammunitions.getAmmunitionByGlobalID( i.toString() );
					
				if ( weapon == null ) continue;
				
				if ( Managers.current_ammunitions.getAmmunitionByGlobalID( i.toString() ) ){
					//значит уже есть такой предмет, нужно как-то показать, что он уже куплен
					continue;
				}
				
				/*if ( weapon.Level >= Global.player.Level ){
					m_text.text = "Новые товары доступны с " + weapon.Level + " уровня";
					break;
				}
				*/
				
				var itmWeapon:ItmWeapon = new ItmWeapon( weapon, m_screen, onBuy, onGet, onForce, Refresh );
				itmWeapon.x = dx;
				itmWeapon.y = dy;
				m_panel.addChild( itmWeapon );
					
				dx += itmWeapon.width + 2;
					
				j++;
					
				if ( !(j % 2) ){
						
					dx = 0;
					dy += itmWeapon.height + 2;
				}
				
				weapon = null;
				
			}
			
			
		}
		
		private function onBuy( ammo:baseAmmunition ):void{
			m_curAmmo = ammo;
			
			//также нужно проверить хватает ли свободных слотов для нового предмета
			
			var canBuy:Boolean = true;
			var price:Object = ammo.PriceBuyCoin;
			
			var key:String;
			
			for ( key in ammo.PriceBuyCons ){
				price[key] = ammo.PriceBuyCons[key];
			}
			
			for( key in price ){
				
				if ( Global.player.getConsumed( TypeConsumed.Convert( key ) ) < price[key] ) 
					canBuy = false;
			}
			
			if ( canBuy ){
				for( key in price ){
					Global.player.subConsumed( TypeConsumed.Convert( key ), int( price[key] ) );
				}
				
				Global.Server.CreateWeaponSmithy( Global.player.InternalID, ammo.globalID.toString(), CALLBACK::onBuyGood, CALLBACK::onBuyBad );
				//CALLBACK::onBuyGood( null );
			}
			else trace('Недостаточно ресурсов');
			
		}
		
		CALLBACK function onBuyGood( response:Object ):void{
			Global.player.CreateAmmo( m_curAmmo.CreateTime, m_curAmmo );
			Refresh();
		}
		
		CALLBACK function onBuyBad( response:Object ):void{
			trace('Не удалось выковать аммуницию');
		}
		
		private function onGet( ammo:baseAmmunition ):void{
			m_curAmmo = ammo;
			
			Global.Server.TakeWeaponSmithy( Global.player.InternalID, ammo.globalID.toString(), CALLBACK::onGetGood, CALLBACK::onGetBad );
			//CALLBACK::onGetGood( null );
		}
		
		CALLBACK function onGetGood( response:Object ):void{
			Managers.current_ammunitions.addAmmunitionByGlobalID( m_curAmmo.globalID.toString() );
			Global.player.subAmmoOnCreate( m_curAmmo );
			Refresh();
		}
		
		CALLBACK function onGetBad( ammo:baseAmmunition ):void{
			trace('Не удалось забрать аммуницию');
		}
		
		private function onForce( ammo:baseAmmunition ):void{
			m_curAmmo = ammo;
			
			var canBuy:Boolean = true;
			
			for( var key:* in m_curAmmo.PriceForce ){
				
				if ( Global.player.getConsumed( TypeConsumed.Convert( key ) ) < m_curAmmo.PriceForce[key] ) 
					canBuy = false;
			}
			
			if ( canBuy ){
				for( key in m_curAmmo.PriceForce ){
					Global.player.subConsumed( TypeConsumed.Convert( key ), int( m_curAmmo.PriceForce[key] ) );
				}
				
				Global.Server.ForceCreateWeaponSmithy( Global.player.InternalID, m_curAmmo.globalID.toString(), CALLBACK::onForceGood, CALLBACK::onForceBad );
				//CALLBACK::onForceGood( null );
			}
			
		}
		
		CALLBACK function onForceGood( response:Object ):void{
			
			Global.player.ForceEndCreateAmmo( m_curAmmo );
			
			//m_curAmmo.CreateTimeLeast = m_curAmmo.CreateTime - 1;
			Refresh();
		}
		
		CALLBACK function onForceBad( response:Object ):void{
			trace('Не удалось форсировать');
		}
		
		private function Refresh( ):void{
			
			var child:*;
			
			while ( m_panel.numChildren ){
				
				child = m_panel.getChildAt( 0 )
				
				if ( child is Bitmap ){
					child.bitmapData.dispose();
				}
				
				m_panel.removeChild( child );
				
				child = null;
			}
			
			removeChild( m_panel );
			
			onFill();
			
		}
		
		override protected function onDestroy():void{
			
			if ( m_frame ){
				m_frame.bitmapData.dispose();
				m_frame = null;
			}
			
		}
		
	}
	
}

import core.baseObject;
import core.gui.button.TypeButton;
import core.gui.button.iconButton;
import core.gui.button.stretchButton;
import core.gui.progress.ProgressHint;
import core.utils.TimeToString;

import flash.display.Bitmap;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import game.Global;
import game.assets.Assets;
import game.display.ItmConsumed;
import game.gameplay.ammunition.baseAmmunition;
import game.gameplay.consumed.TypeConsumed;


class ItmWeapon extends baseObject{
	
	private var m_back:Bitmap;
	private var m_ico:Bitmap;
	private var m_sandWatch:Bitmap;
	private var m_strengthImg:Bitmap;
	
	private var m_createTime:TextField;
	private var m_strengthText:TextField;
	
	private var m_progress:ProgressHint;
	
	private var m_createBtn:iconButton;
	private var m_forceBtn:iconButton;
	private var m_getBtn:stretchButton;
	
	private var m_ammo:baseAmmunition;
	
	private var m_onBuy:Function;
	private var m_onGet:Function;
	private var m_onForce:Function;
	private var m_onRefresh:Function;
	
	public function ItmWeapon( ammo:baseAmmunition, screen:DisplayObjectContainer, onBuyF:Function, onGetF:Function, onForceF:Function, onRefreshF:Function ){
		
		m_ammo = ammo;
		m_onBuy = onBuyF;
		m_onGet = onGetF;
		m_onForce = onForceF;
		m_onRefresh = onRefreshF;
		
		m_back = Assets.getBitmap( "back_armsandarmor_smith" );
		addChild( m_back );
		
		m_ico = ammo.Ico;
		m_ico.x = 5;
		m_ico.y = 40;
		addChild( m_ico );
		
		m_strengthImg = Assets.getBitmap( "icon_damage" );
		m_strengthImg.x = 5;
		m_strengthImg.y = 12;
		addChild( m_strengthImg );
		
		m_strengthText = new TextField();
		m_strengthText.defaultTextFormat = new TextFormat( "Candara", 18, 0x000000 );
		m_strengthText.mouseEnabled = false;
		m_strengthText.text = ammo.Attak.toString();
		m_strengthText.autoSize = TextFieldAutoSize.LEFT;
		m_strengthText.y = m_strengthImg.y - m_strengthImg.height / 2;
		m_strengthText.x = m_strengthImg.x + m_strengthImg.width + 2;
		addChild( m_strengthText );
		
		m_sandWatch = Assets.getBitmap( "clock_ico" );
		m_sandWatch.x = 225;
		m_sandWatch.y = 105;
		addChild( m_sandWatch );
		
		m_createTime = new TextField();
		m_createTime.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000 );
		m_createTime.mouseEnabled = false;
		m_createTime.text = TimeToString.ConvertTimeToString( ammo.CreateTime, true );
		m_createTime.autoSize = TextFieldAutoSize.LEFT;
		m_createTime.y = m_sandWatch.y;
		m_createTime.x = m_sandWatch.x + m_sandWatch.width + 2;
		addChild( m_createTime );
		
		var price:Object;		
		var dx:int = 88;
		var icon:Bitmap;
		var cost:int = 0;
		var type:String;
		
		price = ammo.PriceBuyCons;	
		
		for ( type in price ){
			
			var itmCons:ItmConsumed = new ItmConsumed( type, price[type], screen );
			itmCons.x = dx;
			itmCons.y = 6;
			addChild( itmCons );
			dx += 52;
			
		}
		
		if ( !ammo.onCreate ){
			
			price = ammo.PriceBuyCoin;
			
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
			
			m_createBtn = new iconButton( icon, TypeButton.SIMPLE_GREEN, 70, "выковать за " + cost );
			m_createBtn.x = 165;
			m_createBtn.y = m_back.height - m_createBtn.height - 5;
			m_createBtn.Click = onBuy;
			addChild( m_createBtn );
			
		}
		else{
			
			price = ammo.PriceForce;
			
			for ( type in price ){
				
				switch ( TypeConsumed.Convert( type ) ){
					
					case TypeConsumed.GOLD_COIN:
						icon= Assets.getBitmap( "icon_coin_gold_small" );
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
			
			m_forceBtn = new iconButton( icon, TypeButton.SIMPLE_RED, 82, "завершить за " + cost );
			m_forceBtn.x = 165;
			m_forceBtn.y = m_back.height - m_forceBtn.height - 5;
			m_forceBtn.Click = onForce;
			addChild( m_forceBtn );
			
			m_getBtn = new stretchButton( TypeButton.SIMPLE_GREEN, 10, "забрать" );
			m_getBtn.x = 90;
			m_getBtn.y = m_back.height - m_getBtn.height - 5;
			m_getBtn.Click = onGet;
			addChild( m_getBtn );
			
			if ( Global.player.AmmoOnCreate[0].m_time != 0 ){
				m_getBtn.Enabled = false;
				m_progress = new ProgressHint( Assets.getBitmap( "vill_list_top_bar" ) );
				m_progress.Color = 0x00ffd8;
				m_progress.Max = ammo.CreateTime;
				m_progress.Value = Global.player.AmmoOnCreate[0].m_time;
				m_progress.x = 94;
				m_progress.y = 115;
				m_progress.showLabel(false);
				addChild( m_progress );
				
				addEventListener( Event.ENTER_FRAME, onEnterFrame );
				
			}
			else{
				m_createTime.text = "00:00";
				m_forceBtn.Enabled = false;
				
			}
			
		}
		
	}
	
	private function onEnterFrame( e:Event ):void{
		
		m_progress.Value = m_ammo.CreateTime - Global.player.AmmoOnCreate[0].m_time;
			
		m_createTime.text = TimeToString.ConvertTimeToString( Global.player.AmmoOnCreate[0].m_time, true );
			
		if ( m_progress.Value == m_progress.Max ){
			removeEventListener( Event.ENTER_FRAME, onEnterFrame );
			m_onRefresh();
				
		}
			
	}
	
	private function onBuy( ):void{
		m_onBuy( m_ammo );
	}
	
	private function onGet( ):void{
		m_onGet( m_ammo );
	}
	
	private function onForce( ):void{
		removeEventListener( Event.ENTER_FRAME, onEnterFrame );
		m_onForce( m_ammo );
	}
	
	override protected function onDestroy():void{
		
		removeEventListener( Event.ENTER_FRAME, onEnterFrame );
		
		if ( m_back ){
			m_back.bitmapData.dispose();
			m_back = null;
		}
		
		if ( m_ico ){
			m_ico.bitmapData.dispose();
			m_ico = null;
		}
		
		if ( m_sandWatch ){
			m_sandWatch.bitmapData.dispose();
			m_sandWatch = null;
		}
		
		if ( m_strengthImg ){
			m_strengthImg.bitmapData.dispose();
			m_strengthImg = null;
		}
		
	}
	
}