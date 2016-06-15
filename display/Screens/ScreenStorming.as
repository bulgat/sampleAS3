package game.display.Screens
{
	import core.gui.button.TypeButton;
	import core.gui.button.stretchButton;
	import core.utils.TimeToString;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import game.Global;
	import game.Managers.Managers;
	import game.assets.Assets;
	import game.display.Lobby.ProgressPnlTop;
	import game.display.storming.AwardWindow;
	import game.display.storming.PnlActionStorm;
	import game.display.storming.PnlSiegeWeapon;
	import game.display.storming.PnlSuperAttack;
	import game.display.storming.baseCastle;
	import game.gameplay.consumed.TypeConsumed;
	import game.gameplay.storm.IChangeStormCastle;
	import game.gameplay.storm.StormCastle;

	/**
	 * Окно штурма замка 
	 * @author volk
	 * 
	 */	
	public class ScreenStorming extends baseScreen implements IChangeStormCastle
	{
		
		private var m_pnlActionStorm:PnlActionStorm; 
		
		private var m_pnlSiegeWeapon:PnlSiegeWeapon;
		
		private var m_pnlSuperAttack:PnlSuperAttack;
		
		private var m_back:Bitmap;
		
		private var m_castleIco:Bitmap;

		private var m_title:TextField;

		private var m_protectText:TextField;
		
		private var m_castleId:int;

		private var m_connect:StormCastle;

		private var m_startStormBtn:stretchButton;
		private var m_cancelStormBtn:stretchButton;

		private var m_healthBar:ProgressPnlTop;
		
		private var m_sandWatch:Bitmap;
		private var t_textTime:TextField;
		
		private namespace CALLBACK;
		
		public function ScreenStorming( castleId:int = 1 )
		{
			this.m_internalName = "ScreenStorming";
			
			m_castleId = castleId;
			
			var castle:baseCastle = Managers.castle.getCastleByGlobalID( String( castleId ) );
			
			m_castleIco = Assets.getBitmap( castle.Image );
			m_castleIco.y = 40;
			addChild( m_castleIco );
			
			m_back = Assets.getBitmap( "backStrom" ); 
			addChild ( m_back );
			
			m_title = new TextField();
			m_title.defaultTextFormat = new TextFormat( "Candara", 20, 0xffffff );
			m_title.mouseEnabled = false;
			m_title.autoSize = TextFieldAutoSize.LEFT;
			m_title.text = "Штурм замка <<" + castle.Name + ">>";
			m_title.x = 20;
			m_title.y = 8;
			addChild( m_title );
			
			m_startStormBtn = new stretchButton( TypeButton.DIFFICULT_GREEN, 80, "НАЧАТЬ ШТУРМ" );
			m_startStormBtn.x = 350;
			m_startStormBtn.y = 10;
			m_startStormBtn.Click = StartStorm;
			addChild( m_startStormBtn );
			
			m_cancelStormBtn = new stretchButton( TypeButton.DIFFICULT_GREEN, 80, "ОТМЕНИТЬ ШТУРМ" );
			m_cancelStormBtn.x = 490;
			m_cancelStormBtn.y = 10;
			m_cancelStormBtn.Click = CancelStorm;
			addChild( m_cancelStormBtn );
			
			m_pnlSiegeWeapon = new PnlSiegeWeapon( 1, this );
			addChild( m_pnlSiegeWeapon );
			
			m_pnlActionStorm = new PnlActionStorm( this );
			addChild( m_pnlActionStorm );
			
			m_pnlSuperAttack = new PnlSuperAttack( this );
			addChild( m_pnlSuperAttack );
			
			var obj:Object = castle.WeaponPos;
			
			for (var key:* in obj ){
				var siege:ArrowSiege = new ArrowSiege( this, int(key) );
				siege.x = obj[key].x;
				siege.y = obj[key].y;
				addChild( siege );
			}
			
			m_protectText = new TextField();
			m_protectText.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000 );
			m_protectText.mouseEnabled = false;
			m_protectText.autoSize = TextFieldAutoSize.LEFT;
			m_protectText.text = "оборона замка";
			m_protectText.x = 10;
			m_protectText.y = 40;
			addChild( m_protectText );
			
			m_healthBar = new ProgressPnlTop( Assets.getBitmap('emptyhealth_bar'), Assets.getBitmap('health_bar'), Assets.getBitmap( "icon_castle" ) );
			m_healthBar.x = 140;
			m_healthBar.y = 45;
			m_healthBar.Max = castle.Strength;
			m_healthBar.Value = castle.Strength;
			addChild( m_healthBar );
						
			t_textTime = new TextField();
			t_textTime.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000 );
			t_textTime.mouseEnabled = false;
			t_textTime.autoSize = TextFieldAutoSize.LEFT;
			t_textTime.text = "время штурма     " + TimeToString.ConvertTimeToString( castle.TimeStorm, true );
			t_textTime.x = 400;
			t_textTime.y = 42;
			addChild( t_textTime );
			
			m_sandWatch = Assets.getBitmap( "clock_ico" );
			m_sandWatch.x = 490;
			m_sandWatch.y = 45;
			m_sandWatch.smoothing = true;
			m_sandWatch.scaleX = m_sandWatch.scaleY = 0.8
			addChild( m_sandWatch );
		}
		
		override protected function onAdd( e:Event ):void{ 
			removeEventListener( Event.ADDED_TO_STAGE , onAdd );
			m_connect = StormCastle.getStormCastleForID( m_castleId );
			if( m_connect != null ){
				m_connect.Connect( this );
				/*
				if ( m_connect.Award != null ){
					//штурм замка закончился, пока игрок не был в игре, повторная проверка с сервера не требуется
					if ( m_connect.Award['win'] ){ //выиграли
						trace('Победили, наше вознаграждение:');
						for( var award:* in m_connect.Award ) trace(">> ",award," = ",m_connect.Award[award] );
					}
					else{//проиграли
						trace('GAME OVER');  
					}
					
					Global.Tasks.removeTask( m_connect );
				}
				else{
					m_startStormBtn.Enabled = false;
					return;
				}*/
				m_startStormBtn.Enabled = false;
				
				return;
			}
			
			m_cancelStormBtn.Enabled = false;
			m_pnlSiegeWeapon.Active( false );
			m_pnlActionStorm.Active( false );
			m_pnlSuperAttack.Active( false );  
			
		}
		
		/**
		 * отобразить награду за штурм замка 
		 * @param data
		 * 
		 */		
		public function ShowAward( data:Object ):void{
			
			var awardWindow:AwardWindow = new AwardWindow( data, ChangeScreen );
			addChild( awardWindow );
			
		}
		
		private function ChangeScreen( ):void{
			Global.screenLobby.ShowScreen( new ScreenChooseStorm( ) ); 
		}
		
		public function Change( storm:StormCastle ):void{ 
			m_healthBar.Value = storm.Strength;
			
			m_healthBar.Value = storm.Strength;
			t_textTime.text = "конец штурма     " + TimeToString.ConvertTimeToString( storm.LeastTimeStorm, true );
			
			/**
			 * факт окончания осады , методом разрушения
			 */
			if ( storm.Strength <= 0 ){
				
				m_startStormBtn.Enabled = true;
				m_cancelStormBtn.Enabled = false;
				m_pnlSiegeWeapon.Active( false );
				m_pnlActionStorm.Active( false );
				m_pnlSuperAttack.Active( false );
				
				// штурм закончился в тот момент, когда игрок находился в игре, нужно проверить с сервера факт победы или поражения
				Global.Server.getAwardStorm( Global.player.InternalID, CastleID, CALLBACK::onAwardGood, CALLBACK::onAwardBad );
				
				Global.Tasks.removeTask( m_connect );
				
				return;
			}
			/**
			 * время истекло , а замок не взяли
			 */
			if( storm.LeastTimeStorm <= 0 ){
				trace('Истекло время');
				
				var awardWindow:AwardWindow = new AwardWindow( null, ChangeScreen );
				addChild( awardWindow );
				
				Global.Tasks.removeTask( m_connect );
				return;
			}
			
		}
		
		CALLBACK function onAwardGood( response:Object ):void{
			trace('Взяли замок');
			ShowAward( response.award );
			
			//добавить ресурсы игроку
			//"response":{"state":"winner","award":{"sword":{"strength":45,"damage":0,"globalID":"5#1#2"},"consumed":{"exp":6,"copper_coin":38}},"id":"1"}}
			
			for ( var key:* in response.award ){
				switch ( key ){
					case "sword": Managers.current_ammunitions.addAmmunitionByGlobalID( response.award[key]["globalID"] ); break;
					case "consumed":
						for( var type:* in response.award[key] ){
							Global.player.addConsumed( TypeConsumed.Convert(type), int( response.award[key][type] ) );
						}
						break;
				}
			}
		}
		
		CALLBACK function onAwardBad( response:Object ):void{
			trace('Не удалось получить инфу об авардах');
		}
		
		private function StartStorm( ):void{
			Global.Server.StartStorm( Global.player.InternalID, CastleID, CALLBACK::onStartGood, CALLBACK::onStartBad );
		}
		
		CALLBACK function onStartGood( response:Object ):void{
			trace('Штурм начался');
			
			m_connect = new StormCastle( m_castleId );
			
			Global.Tasks.addTask( m_connect );
						
			removeChild( m_pnlSiegeWeapon );
			removeChild( m_pnlActionStorm );
			removeChild( m_pnlSuperAttack );			
			
			m_pnlSiegeWeapon = new PnlSiegeWeapon( 1, this );
			addChild( m_pnlSiegeWeapon );
			
			m_pnlActionStorm = new PnlActionStorm( this );
			addChild( m_pnlActionStorm );
			
			m_pnlSuperAttack = new PnlSuperAttack( this );
			addChild( m_pnlSuperAttack );
			
			m_connect.Connect( this );
			
			m_startStormBtn.Enabled = false;
			m_cancelStormBtn.Enabled = true;
		}
		
		CALLBACK function onStartBad( response:Object ):void{
			trace('Не удалось начать штурм');
		}
		
		private function CancelStorm( ):void{
			Global.Server.CancelStorm( Global.player.InternalID, CastleID, CALLBACK::onCancelGood, CALLBACK::onCancelBad );
		}
		
		CALLBACK function onCancelGood( response:Object ):void{
			trace('Штурм прекращен');
			
			Global.Tasks.removeTask( m_connect );
			
			m_startStormBtn.Enabled = true;
			m_cancelStormBtn.Enabled = false;
			
			m_pnlSiegeWeapon.Active( false );
			m_pnlActionStorm.Active( false );
			m_pnlSuperAttack.Active( false );
		}
		
		CALLBACK function onCancelBad( response:Object ):void{
			trace('Не удалось прекратить штурм замка');
		}
		
		public function onSelected( id:int ):void{
			if ( m_startStormBtn.Enabled ) return;
			
			this.removeChild( m_pnlSiegeWeapon );
			m_pnlSiegeWeapon = new PnlSiegeWeapon( id, this );
			addChild( m_pnlSiegeWeapon );
		}
		
		public function get CastleID( ):int{
			return m_castleId;
		}
		
		override protected function onDestroy():void{
			if( m_connect != null )
				m_connect.Disconnect( this );
			
			m_back.bitmapData.dispose();
			m_back = null;
			
			m_castleIco.bitmapData.dispose();
			m_castleIco = null;
			
			m_sandWatch.bitmapData.dispose();
			m_sandWatch = null;
		}		

	}
}

import flash.display.Bitmap;

import core.gui.button.baseButton;

import game.Managers.Managers;
import game.assets.Assets;
import game.display.Screens.ScreenStorming;
import game.gameplay.siegeWeapon.baseSiegeWeapon;


class ArrowSiege extends baseButton{
	
	private var m_ico:Bitmap;
	
	private var m_id:int = -1;
	
	private var m_screen:ScreenStorming;
	
	public function ArrowSiege( screen:ScreenStorming , idSiege:int  ){
		super( Assets.getBitmap( "arrow_storm" ) );
		m_id = idSiege;
		m_screen = screen;
		var bs:baseSiegeWeapon = Managers.siegeWeapons.getSiegeWeaponbyID( idSiege.toString());
		if( bs!=null){
			m_ico = bs.Ico;
			m_ico.x = 22;
			m_ico.y = 8;
			addChild( m_ico );
		}
		this.Click = onSelected;
	}
	
	override protected function onDestroy():void{
		super.onDestroy();
		m_ico.bitmapData.dispose();
		m_ico = null;
	}
	
	public function get ID():int{
		return m_id;
	}
	
	private function onSelected( ):void{
		m_screen.onSelected( m_id );
	}
}