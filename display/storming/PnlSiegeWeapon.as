package game.display.storming
{
	
	
	import core.baseObject;
	import core.gui.button.TypeButton;
	import core.gui.button.buttonUpDown;
	import core.gui.button.iconButton;
	import core.gui.progress.ProgressBase;
	import core.gui.progress.ProgressHint;
	import core.utils.TimeToString;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import game.Global;
	import game.Managers.Managers;
	import game.assets.Assets;
	import game.display.ItmConsumed;
	import game.display.Screens.ScreenStorming;
	import game.gameplay.consumed.TypeConsumed;
	import game.gameplay.siegeWeapon.baseSiegeWeapon;
	import game.gameplay.storm.IChangeStormCastle;
	import game.gameplay.storm.StormCastle;
	import game.gameplay.storm.infoSiege;

	/**
	 * панель с осадными орудиями, их докупкой и количесвенным выражением 
	 * @author volk
	 * 
	 */	
	public class PnlSiegeWeapon extends baseObject implements IChangeStormCastle
	{
		private var m_baseSiege:baseSiegeWeapon;
		
		private var m_label:TextField;
		
		private var m_icoSiege:Bitmap;
		
		private var m_icoDamage:Bitmap;
		private var m_damageText:TextField;
		
		private var m_clock1:Bitmap;
		private var m_clock1Text:TextField;
		
		private var m_btnBuild:iconButton;
		
		private var m_progress:ProgressBase;
		
		private var m_connect:StormCastle;
		
		private var m_idSiegeWeapon:int = -1;
		
		private var m_siegeInfo:infoSiege;
		
		private var m_screenStorming:ScreenStorming;
		
		public static var instance:PnlSiegeWeapon;
		
		private namespace CALLBACK;
		
		public function PnlSiegeWeapon( idSiegeWeapon:int, screenStorming:ScreenStorming )
		{
			m_screenStorming = screenStorming;
			
			y = 420;
			m_idSiegeWeapon = idSiegeWeapon;
			m_baseSiege = Managers.siegeWeapons.getSiegeWeaponbyID( idSiegeWeapon.toString() ); 
			if( m_baseSiege == null ) return;
			
			m_label = new TextField( );
			m_label.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000 );
			m_label.mouseEnabled = false;
			m_label.autoSize = TextFieldAutoSize.LEFT;
			m_label.text = m_baseSiege.Name;
			m_label.x = 15;
			addChild( m_label );
			
			fillInfo( );
			fillBuyConsumed( );
			
			instance = this;
			
			this.addEventListener(Event.ADDED_TO_STAGE , onAdd );
		}
		
		private function onAdd( e:Event ):void{
			removeEventListener( Event.ADDED_TO_STAGE , onAdd );
			m_connect = StormCastle.getStormCastleForID( m_screenStorming.CastleID ); 
			if( m_connect != null ){
				m_connect.Connect( this );
				
				m_siegeInfo = m_connect.getInfoSiege( m_idSiegeWeapon );
				if( m_siegeInfo !=null ){
					this.ShowTime();
					this.m_btnBuild.visible = false;
				}
			}
		}
		
		
		private function fillInfo():void{
			m_icoSiege = m_baseSiege.Ico;
			m_icoSiege.x = 76;
			addChild( m_icoSiege );
			
			m_icoDamage = Assets.getBitmap( "icon_castle" );
			m_icoDamage.x = 15;
			m_icoDamage.y = 20;
			addChild( m_icoDamage );
			
			m_damageText = new TextField( );
			m_damageText.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000 );
			m_damageText.mouseEnabled = false;
			m_damageText.autoSize = TextFieldAutoSize.LEFT;
			m_damageText.text = "-"+m_baseSiege.Damage.toString( );
			m_damageText.x = 34;
			m_damageText.y = 18;
			addChild( m_damageText );
			
		    m_clock1 = Assets.getBitmap( "icon_clock" );
			m_clock1.x = 15;
			m_clock1.y = 40;
			addChild( m_clock1 );
			
			m_clock1Text = new TextField( );
			m_clock1Text.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000 );
			m_clock1Text.mouseEnabled = false;
			m_clock1Text.autoSize = TextFieldAutoSize.LEFT;
			m_clock1Text.text = TimeToString.ConvertTimeToString( m_baseSiege.Time, true );
			m_clock1Text.x = 34;
			m_clock1Text.y = 40;
			addChild( m_clock1Text );
			
			for( var key:* in m_baseSiege.Price ){
				
				switch ( TypeConsumed.Convert( key ) ){
					case TypeConsumed.GOLD_COIN:
						m_btnBuild = new iconButton( Assets.getBitmap( "icon_coin_gold_small" ), TypeButton.DIFFICULT_GREEN, 80, "построить за " + m_baseSiege.Price[key]);
						break;
					case TypeConsumed.SILVER_COIN:
						m_btnBuild = new iconButton( Assets.getBitmap( "icon_coin_silver_small" ), TypeButton.DIFFICULT_GREEN, 80, "построить за " + m_baseSiege.Price[key]);
						break;
					case TypeConsumed.COPPER_COIN:
						m_btnBuild = new iconButton( Assets.getBitmap( "icon_coin_copper_small" ), TypeButton.DIFFICULT_GREEN, 80, "построить за " + m_baseSiege.Price[key]);
						break;
					default:
						m_btnBuild = new iconButton( Assets.getBitmap( "unknow" ), TypeButton.DIFFICULT_GREEN, 80, "построить за " + m_baseSiege.Price[key]);
						break;
				}
				
			}
			
			m_btnBuild.x = 35;
			m_btnBuild.y = 62;
			m_btnBuild.Click = onBuild;
			addChild( m_btnBuild );
		}
		
		/**
		 *  построить осадное орудие
		 *  строится мгновенно 
		 */
		private function onBuild( ):void{
			
			var canBuy:Boolean = true;
			
			for( var key:* in m_baseSiege.Price ){
				if ( !Global.player.subConsumed( TypeConsumed.Convert( key ), int(m_baseSiege.Price[key]) ) ) canBuy = false;
			
			}
			for ( key in m_baseSiege.Condition ){
				if ( !Global.player.subConsumed( TypeConsumed.Convert( key ), int(m_baseSiege.Condition[key]) ) ) canBuy = false;
				
			}
			 
			if ( canBuy )
				Global.Server.applySiegeWeapon( Global.player.InternalID, m_screenStorming.CastleID, m_idSiegeWeapon, CALLBACK::onBuildGood, CALLBACK::onBuildBad );
			else
				trace('Нет ресурсов');
		}
		
		CALLBACK function onBuildGood( response:Object ):void{
			m_connect.BuildSiege( m_idSiegeWeapon );
			
			Refresh();
			
			m_siegeInfo = m_connect.getInfoSiege( m_idSiegeWeapon );
			if( m_siegeInfo !=null ){
				this.ShowTime();
				this.m_btnBuild.visible = false;
			}
		}
		
		CALLBACK function onBuildBad( response:Object ):void{
			trace('Не удалось построить');
		}
		
		private var m_listConsumed:Vector.<ItmConsumed> = new Vector.<ItmConsumed>;
		private function fillBuyConsumed( ):void{
						
			var dx:int = 230;
			
			for ( var it:* in m_baseSiege.Condition ){
				var itc:ItmConsumed = new ItmConsumed( it , m_baseSiege.Condition[it], m_screenStorming ); 
				addChild( itc );
				m_listConsumed.push( itc );
				itc.x = dx;
				dx += 68;	
			}
		}
		
		private function Refresh( ):void{
			for( var i:int = 0; i < m_listConsumed.length; i++ ){
				m_listConsumed[i].Refresh();
			}
		}
		
		private var m_clock2:Bitmap;
		private var m_clock2Text:TextField
		private var m_progressDown:ProgressHint;
		private function ShowTime( ):void{
			
			m_progressDown = new ProgressHint( Assets.getBitmap( "vill_list_top_bar" ) );
			m_progressDown.Color = 0x7FFB57;
			m_progressDown.Max = m_siegeInfo.siegeWeapon.Time;
			m_progressDown.Value = m_siegeInfo.CurrentTime; //Global.startTimeGame - outhouse.TimeProduction + Math.floor(getTimer() / 1000);
			m_progressDown.x = 140;
			m_progressDown.y = 25;
			m_progressDown.showLabel(false);
			addChild( m_progressDown ); 
			
			m_clock2 = Assets.getBitmap( "icon_clock" );
			m_clock2.x = 145;
			m_clock2.y = 35;
			addChild( m_clock2 );
			
			m_clock2Text = new TextField( );
			m_clock2Text.defaultTextFormat = new TextFormat( "Candara", 12, 0x000000 );
			m_clock2Text.mouseEnabled = false;
			m_clock2Text.autoSize = TextFieldAutoSize.LEFT;
			m_clock2Text.text = TimeToString.ConvertTimeToString( m_siegeInfo.CurrentTime, true );
			m_clock2Text.x = 160;
			m_clock2Text.y = 30;
			addChild( m_clock2Text );
			
		}
		
		private function HideTime():void{
			if( m_progressDown!=null )
				removeChild( m_progressDown );
			
			if( m_clock2Text!=null)
				removeChild( m_clock2Text );
			
			if ( m_clock2 )
				removeChild( m_clock2 );
		}
		
		
		public function Change( storm:StormCastle ):void{
			
			if( m_siegeInfo == null ) return;
			if( m_siegeInfo!=null && storm.getInfoSiege( m_siegeInfo.ID ) == null){
				this.HideTime();
				m_siegeInfo = null;
				this.m_btnBuild.visible = true;
				return;
			}
			if( m_progressDown ){
				this.m_progressDown.Value = m_siegeInfo.CurrentTime;
				m_clock2Text.text = TimeToString.ConvertTimeToString( m_siegeInfo.CurrentTime, true );
			}
		}
		
		public function Active( flag:Boolean ):void{
			
			m_btnBuild.Enabled = flag;
			
		}

		
		override protected function onDestroy():void{
			if ( m_icoSiege ){
				m_icoSiege.bitmapData.dispose();
				m_icoSiege = null;
			}
			
			if ( m_icoDamage ){
				m_icoDamage.bitmapData.dispose();
				m_icoDamage = null;
			}
			
			if ( m_clock1 ){
				m_clock1.bitmapData.dispose();
				m_clock1 = null;
			}
			
			if ( m_clock2 ){
				m_clock2.bitmapData.dispose();
				m_clock2 = null;
			}
		}
	}
}