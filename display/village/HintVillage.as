package game.display.village
{
	import core.baseObject;
	import core.gui.button.TypeButton;
	import core.gui.button.buttonUpDown;
	import core.gui.button.iconButton;
	import core.gui.button.stretchButton;
	import core.gui.progress.ProgressHint;
	import core.utils.TimeToString;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import game.Global;
	import game.Managers.Managers;
	import game.assets.Assets;
	import game.display.Lobby.PnlTop;
	import game.display.Screens.ScreenVillage;
	import game.display.domain.itmInfoVillage;
	import game.gameplay.consumed.TypeConsumed;
	import game.gameplay.village.Outhouse;
	import game.gameplay.village.baseOuthouse;
	
	import mx.core.TextFieldAsset;
	
	public class HintVillage extends baseObject
	{
		[Embed(source="../../../../ResourcesGame/game/Screens/village/hintVillage.png")]    
		public static const hint_back:Class
		
		private var m_back:Bitmap;
	
		private var m_progress:ProgressHint;
		
		private var m_config:Object;
		
		private var m_title:TextField;
		
		private var m_speedProd:TextField;
		
		private var m_timeImg:Bitmap;
		
		private var m_upgradeButton:stretchButton;
		
		private var m_buyButton:iconButton;
		
		private var m_leastTime:LeastTime;
		
		private var m_outhouse:Outhouse;
		
		private var m_timeManager:TimeToString;
		
		private var m_reOpenFun:Function;
		
		private var m_forceEnd:Function;
		
		private namespace CALLBACK;
		
		public function HintVillage(  outhouse:Outhouse, showProgress:Boolean, reOpen:Function, ForceEnd:Function )
		{
			m_outhouse = outhouse;
			m_reOpenFun = reOpen;
			m_forceEnd = ForceEnd;
			
			m_back = new hint_back() as Bitmap;
			addChild( m_back );
			
			//наименование постройки
			m_title = new TextField( );
			m_title.defaultTextFormat = new TextFormat( "Candara", 14, 0xffffff, true);
			m_title.autoSize = TextFieldAutoSize.LEFT;
			m_title.x    = m_back.width / 2;
			m_title.mouseEnabled = false;
			m_title.y    = 10;
			m_title.text = "TITLE";
			addChild( m_title );
			//scaleX = scaleY = 0.45;
			
			if ( showProgress ){
				//кнопка "завершить за xx монет"
				m_buyButton = new iconButton( Assets.getBitmap( "icon_coin_gold_small" ), TypeButton.DIFFICULT_GREEN, 100, "завершить за " + outhouse.TableUpgrade["forcePrice"]);
				m_buyButton.x = 20;
				m_buyButton.y = 235;
				m_buyButton.Click = onForceEnd;
				addChild(m_buyButton);
			
				//прогресс бар
				m_progress = new ProgressHint( Assets.getBitmap( "village_scr_topbar_pro" ) );
				m_progress.Color = 0xff9600;
				m_progress.Max = m_outhouse.Time;
				m_progress.Value = Global.startTimeGame - m_outhouse.TimeProduction + Math.floor(getTimer() / 1000);
				m_progress.x = m_back.width / 2 - m_progress.width / 2;
				m_progress.y = 265;
				m_progress.showLabel(false);
				addChild( m_progress );
				
				//Осталось времени до производства ресурса на текущем уровне
				m_leastTime = new LeastTime( );
				m_leastTime.setTime( "вычисление времени" );
				m_leastTime.x = m_back.width / 2 - m_leastTime.width / 2;
				m_leastTime.y = 285;
				addChild(m_leastTime);
				
				m_timeManager = new TimeToString( (m_progress.Max - m_progress.Value), TimerTik, TimerComplete );
				m_timeManager.Start();
			}
			
			//Данные о текущих производимых ресурсах
			var currentUpgrade:Object = m_outhouse.TableUpgrade;
			var increase:int = 1;
			for ( var key:* in currentUpgrade['result'] ) increase++;
				
			var dx:int = int( m_back.width / increase );
			var dy:int = 320;
						
			for ( key in currentUpgrade['result'] ){
				var itmResult:ItmResult = new ItmResult( key, currentUpgrade['result'][key]);
				itmResult.x = dx - itmResult.width / 2;
				itmResult.y = dy;
				addChild( itmResult );
				
				dx += int( m_back.width / increase );
			}
			
			this.addEventListener(MouseEvent.CLICK , onClick );
			onShow( );
		}
		
		private function TimerTik( ):void{
			m_progress.Value = Global.startTimeGame - m_outhouse.TimeProduction + Math.floor(getTimer() / 1000);
						
			m_leastTime.setTime( m_timeManager.getStringTime() );
		}
		
		private function TimerComplete( ):void{
			m_timeManager.Destroy();
			
			removeChild(m_progress);
			m_progress = null;
			
			removeChild(m_leastTime);
			m_leastTime = null;
		}
		
		//<list>{ "condition":{"wood":"20","stone":"10","grain":"12"} , level:"1", "result":{"grain":"20"},  "time":200 }</list>
		private function onShow( ):void{
			
			var item:ItemInfoHint;
			var requirement:Object = m_outhouse.RequirementToUpgrade;
			
			m_title.text = m_outhouse.BaseOuthouse.Name;
			m_title.x    = m_back.width / 2 - m_title.width / 2;
			
			
			if( requirement == null ){ //значит достигли максимума апгрейдов
				return;	
			}
			
			var increase:int = 1;
			for (key in requirement['condition'] ) increase++;
			
			var dx:int = int( m_back.width / increase );
			var key:*;
			for (key in requirement['condition'] ){
				item    = new ItemInfoHint( TypeConsumed.Convert( key ) , requirement['condition'][key] );
				item.x += dx - item.width / 2;
				dx += int( m_back.width / increase );
				item.y = 75;
				addChild( item );
			}
			
			//кнопка обновления до нового уровня, если возможно
			var levelUp:String = "улучшить до " + String((m_outhouse.Level+1)) + " ур.";
			m_upgradeButton   = new stretchButton( TypeButton.SIMPLE_GREEN, 80, levelUp);
			m_upgradeButton.x = 30;
			m_upgradeButton.y = 40;
			m_upgradeButton.Enabled = m_outhouse.EnabledUpgrade( );
			m_upgradeButton.Click = onUpgrade;
			addChild(m_upgradeButton);
			
			dx = 15;
			var dy:int = 195;
			//Производимый ресурс после апгрейда
			for (key in requirement['result'] ){
				var itmResult:ItmResult = new ItmResult( key, int(requirement['result'][key]) );
				itmResult.x = dx;
				itmResult.y = dy;			
				dx += itmResult.width + 2;
				addChild( itmResult );
			}
			
			//скорость производства ресурса после апгрейда
			m_speedProd = new TextField();
			m_speedProd.autoSize = TextFieldAutoSize.LEFT;
			m_speedProd.text = "за        " + String( requirement['time'] );
			m_speedProd.x = itmResult.x + itmResult.width + 5;
			m_speedProd.y = itmResult.y;
			m_speedProd.mouseEnabled = false;
			addChild( m_speedProd );
			
			//песочные часы
			m_timeImg = Assets.getBitmap( "clock_ico" ) as Bitmap;
			m_timeImg.x = m_speedProd.x + m_timeImg.width / 2 + 10;
			m_timeImg.y = m_speedProd.y;
			addChild(m_timeImg);
			
		}
		
		private function onForceEnd( ):void{
			//мгновенно производить продукцию
			if ( Global.player.subConsumed( TypeConsumed.GOLD_COIN, uint( m_outhouse.TableUpgrade["forcePrice"] ) ) ){
				//Отправить на сервер быстрое завершение постройки
				Global.Server.ForceEndProduction( Global.player.InternalID, m_outhouse.VillageID, m_outhouse.BaseOuthouse.GlobalID, CALLBACK::onForceGood, CALLBACK::onForceBad );
			}
		}
		
		CALLBACK function onForceGood( response:Object ):void{
			TimerComplete();
			m_forceEnd();
			m_reOpenFun();
		}
		
		CALLBACK function onForceBad( response:Object ):void{
			trace("Не удалось форсировать");
		}
		
		private function onUpgrade( ):void{
			//апгрейдить здание
			Global.Server.UpgradeOuthouse( Global.player.InternalID, m_outhouse.VillageID, m_outhouse.BaseOuthouse.GlobalID, CALLBACK::onUpgradeGood, CALLBACK::onUpgradeBad );
		}
		
		CALLBACK function onUpgradeGood( response:* ):void{
			
			var requirement:Object = m_outhouse.RequirementToUpgrade;
						
			var key:*;
			for (key in requirement['condition'] ){
				Global.player.addConsumed( TypeConsumed.Convert( key ) , uint( requirement['condition'][key] ) * -1 );
			}
			
			m_outhouse.Upgrade( );
			m_outhouse.TimeProduction = Global.startTimeGame + Math.floor(getTimer() / 1000);
			
			m_reOpenFun( );
		}
		
		CALLBACK function onUpgradeBad( response:* ):void{
			
		}
		
		private function onClick( event:Event ):void{
			
			this.removeEventListener(MouseEvent.CLICK , onClick );
			
			event.stopImmediatePropagation();
			event.stopPropagation();
			
			ScreenVillage(parent).Hide();
			
		}
		
		override protected function onDestroy():void{
			if ( m_back ){
				m_back.bitmapData.dispose();
				m_back = null;
			}	
			
			if ( m_timeImg ){
				m_timeImg.bitmapData.dispose();
				m_timeImg = null;
			}
			
		}
	}
}


import core.baseObject;
import core.gui.checkBox.baseCheckBox;

import flash.display.Bitmap;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import game.Global;
import game.Managers.Managers;
import game.assets.Assets;
import game.gameplay.consumed.TypeConsumed;

class ItemInfoHint extends baseObject{
	
	private var m_price:TextField;
	private var m_ico:Bitmap;
	private var m_check:baseCheckBox;
	
	public function ItemInfoHint( type:TypeConsumed , price:int ){
		m_ico        = Managers.consumed.getConsumedByType( type ).Ico;
		m_ico.y = 20 - m_ico.height / 2;
		addChild( m_ico );
		
		m_price      = new TextField( );
		m_price.autoSize = TextFieldAutoSize.CENTER;
		m_price.text 	 = price.toString();
		m_price.x 		 = m_ico.width / 2 - m_price.width / 2;
		m_price.y    	 = 42;
		m_price.mouseEnabled = false;
		addChild( m_price );
		
		m_check      = new baseCheckBox( Assets.getBitmap( "res_no_ico" ) , Assets.getBitmap( "res_yes_ico"));
		m_check.x	 = m_ico.width / 2 - m_check.width / 2;
		m_check.y    = m_price.y + 18;
		m_check.mouseChildren = false;
		m_check.mouseEnabled = false;
		if (Global.player.getConsumed(type) > price) m_check.Check = true;
		else m_check.Check = false;
		m_check.Lock = true;
		addChild( m_check );
	}
	

	override protected function onDestroy():void{
		if ( m_ico ){
			m_ico.bitmapData.dispose();
			m_ico = null;
		}
	}
}

class ItmResult extends baseObject{
	
	private var m_text:TextField;
	private var m_img:Bitmap;
	
	public function ItmResult( type:String, count:int ){
		
		m_text = new TextField( );
		m_text.autoSize = TextFieldAutoSize.LEFT;
		m_text.text = "+" + String(count);
		m_text.mouseEnabled = false;
		addChild( m_text );
		
		m_img = Assets.getBitmap( TypeConsumed.Convert( type ).Value + "_ico");
		m_img.x = m_text.x + m_text.width + 2;
		m_img.y = 10 - m_img.height / 2;
		addChild(m_img);
		
	}
	
	override protected function onDestroy():void{
		if ( m_img ){
			m_img.bitmapData.dispose();
			m_img = null;
		}
	}
	
}

import flash.text.TextField;
import flash.text.TextFieldAutoSize; 

class LeastTime extends baseObject{
	
	private var m_sandTime:Bitmap;
	private var m_time:TextField;
	
	public function LeastTime( ){
		
		m_sandTime = Assets.getBitmap( "clock_ico" ) as Bitmap;
		addChild(m_sandTime);
		
		m_time = new TextField( );
		m_time.autoSize = TextFieldAutoSize.LEFT;
		m_time.x = m_sandTime.width + 5;
		m_time.mouseEnabled = false;
		addChild(m_time);
	}
	
	public function setTime( time:String ):void{
		m_time.text = time;
	}
	
	override protected function onDestroy():void{
		if ( m_sandTime ){		
			m_sandTime.bitmapData.dispose();
			m_sandTime = null;
		}
	}
}