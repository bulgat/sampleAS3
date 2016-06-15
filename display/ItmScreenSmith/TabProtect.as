package game.display.ItmScreenSmith
{
	import core.utils.ScrollBar;
	import core.utils.Syntax;
	import core.utils.TimeToString;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import game.Global;
	import game.Managers.Managers;
	import game.assets.Assets;
	import game.display.Screens.ScreenSmith;
	import game.gameplay.ammunition.TypeAmmunition;
	import game.gameplay.ammunition.baseAmmoSet;
	import game.gameplay.ammunition.baseAmmunition;
	import game.gameplay.consumed.TypeConsumed;
	
	public class TabProtect extends TabSmith
	{
		private var m_panel:Sprite;
		private var m_scrollBar:ScrollBar;
		private var m_frame:Bitmap;
		private var m_text:TextField;
		
		private var m_curAmmo:baseAmmunition;
		
		private namespace CALLBACK;
		
		public function TabProtect(screen:ScreenSmith)
		{
			super(screen);
			
			onFill( );
			
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			
		}
		
		private function onAddedToStage( e:Event ):void{
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			
			CreateScroll();
			
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
		
		private function CreateScroll():void{
			m_scrollBar = new ScrollBar( m_panel, new Rectangle( 0 , m_panel.y , 618, 320 ) );
			m_scrollBar.Background = Assets.getBitmap( "back_smith_scroll" );
			m_scrollBar.CreateScroll();
			m_scrollBar.x = 6;
			m_scrollBar.y = 250;
			m_scrollBar.Offset = 40;
			addChild( m_scrollBar );
		}
		
		private function onFill( ):void{
			
			m_panel = new Sprite( );
			
			var dx:int = 0;
			var dy:int = 0;
			var i:uint = 0;
			
			var ammunitions:Object = Managers.ammo_set.getAmmoSets();
			
			for each( var ammo_set:baseAmmoSet in ammunitions ){
				
				/*if ( ammo_set.Level >= Global.player.Level ){
					m_text.text = "Новые товары доступны с " + ammo_set.Level + " уровня";
					break;
				}
				*/
				
				var itmAmmoSet:ItmAmmoSet = new ItmAmmoSet( ammo_set );
				itmAmmoSet.x = dx;
				itmAmmoSet.y = dy;
				
				m_panel.addChild( itmAmmoSet );
				
				dx += itmAmmoSet.width + 2;
				
				i++;
				
				for(var j:int = 0; j < ammo_set.AmmoList.length; j++){
					
					var ammo:baseAmmunition = Managers.ammunitions.getAmmunitionByGlobalID( ammo_set.AmmoList[j].toString() );
					
					if ( ammo == null ) continue;
					
					if ( Managers.current_ammunitions.getAmmunitionByGlobalID( ammo.globalID.toString() ) ){
						//значит уже есть такой предмет, нужно как-то показать, что он уже куплен
						continue;
					}
					
					var itmProtect:ItmProtect = new ItmProtect( ammo, m_screen, onBuy, onGet, onForce, Refresh );
					itmProtect.x = dx;
					itmProtect.y = dy;
					m_panel.addChild( itmProtect );
					
					dx += itmProtect.width + 2;
					
					i++;
					
					if ( !(i % 2) ){
						
						dx = 0;
						dy += itmProtect.height + 2;
					}
					
				}
				
				
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
		}
		
		CALLBACK function onGetGood( response:Object ):void{
			
			Managers.current_ammunitions.addAmmunitionByGlobalID( m_curAmmo.globalID.toString() );
			
			Global.player.subAmmoOnCreate( m_curAmmo );
			
			Refresh();
		}
		
		CALLBACK function onGetBad( response:Object ):void{
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
					
			removeChild( m_scrollBar );
			m_scrollBar = null;
			
			onFill();
			
			CreateScroll();
			
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

import flash.display.Bitmap;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import game.assets.Assets;
import game.gameplay.ammunition.baseAmmoSet;

class ItmAmmoSet extends baseObject{
	
	private var m_back:Bitmap;
	private var m_ico:Bitmap;
	private var m_name:TextField;
	private var m_info:TextField;
	
	public function ItmAmmoSet( ammo_set:baseAmmoSet ){
		
		m_back = Assets.getBitmap( "back_set_smith" )
		addChild( m_back );
		
		m_ico = Assets.getBitmap( ammo_set.Image );
		m_ico.x = 2;
		m_ico.y = 40;
		addChild( m_ico );
		
		m_name = new TextField();
		m_name.defaultTextFormat = new TextFormat( "Candara", 16, 0xFFFFFF );
		m_name.mouseEnabled = false;
		m_name.text = ammo_set.Name;
		m_name.autoSize = TextFieldAutoSize.LEFT;
		m_name.x = 100;
		m_name.y = 5;
		addChild( m_name );
		
		m_info = new TextField();
		m_info.defaultTextFormat = new TextFormat( "Candara", 12, 0x000000 );
		m_info.mouseEnabled = false;
		m_info.wordWrap = true;
		//m_info.text = ammo_set.Hint;
		m_info.text = ammo_set.Hint;
		m_info.width = 220;
		m_info.x = 85;
		m_info.y = 35;
		addChild( m_info );
		
	}
	
	override protected function onDestroy():void{
		
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

import flash.display.DisplayObjectContainer;

import game.gameplay.ammunition.baseAmmunition;
import game.display.ItmConsumed;
import game.gameplay.consumed.TypeConsumed;

import core.gui.button.iconButton;
import core.utils.TimeToString;
import core.gui.button.TypeButton;
import core.gui.button.stretchButton;
import core.gui.button.stretchButton;
import core.gui.progress.ProgressHint;
import flash.events.Event;
import game.Global;

class ItmProtect extends baseObject{
	
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
	
	public function ItmProtect( ammo:baseAmmunition, screen:DisplayObjectContainer, onBuyF:Function, onGetF:Function, onForceF:Function, onRefreshF:Function ){
		
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
		
		m_strengthImg = Assets.getBitmap( "icon_shield" );
		m_strengthImg.x = 5;
		m_strengthImg.y = 12;
		addChild( m_strengthImg );
		
		m_strengthText = new TextField();
		m_strengthText.defaultTextFormat = new TextFormat( "Candara", 18, 0x000000 );
		m_strengthText.mouseEnabled = false;
		m_strengthText.text = ammo.Protected.toString();
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
			
			if ( Global.player.AmmoOnCreate[0].m_time != ammo.CreateTime ){
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
		
	}
	
}