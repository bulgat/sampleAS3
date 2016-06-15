package game.display.notice
{
	import com.greensock.TweenLite;
	
	import core.baseObject;
	import core.gui.button.baseButton;
	import core.gui.button.buttonUpDown;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import game.Global;
	import game.Managers.Managers;
	import game.assets.Assets;
	import game.display.Screens.ScreenAlchemist;
	import game.display.Screens.ScreenSmith;
	import game.display.Screens.baseScreen;
	import game.gameplay.alchemy.basePotion;
	import game.gameplay.ammunition.Ammunition;
	import game.gameplay.ammunition.baseAmmunition;
	import game.gameplay.consumed.baseConsumed;
	import game.gameplay.village.baseOuthouse;
	

	public class baseNotice extends baseButton
	{
		private var m_data:Object;
		
		private var m_text:TextField;
		
		private var m_root:DisplayObjectContainer;
		
		private var m_ico:Bitmap;
		
		private var m_type:String;
		
		private var m_closeBtn:buttonUpDown;
		
		public function baseNotice( root:DisplayObjectContainer , data:Object )
		{
			super( null );
			m_root = root;
			m_data = data;
						
			this.Click = ClickNotice;
			
			parse( data );
		}
		
		private function parse( data:Object ):void{
			
			Draw();
			
			m_closeBtn = new buttonUpDown( Assets.getBitmap("geton_close_normal_but"), Assets.getBitmap("geton_close_press_but") );
			m_closeBtn.x = this.width  - 20;
			m_closeBtn.y = 5;
			m_closeBtn.Click = CloseNotice;
			addChild( m_closeBtn );
			
			m_type = data['type'];
			
			switch	( data['type'] ){
			
				case TypeNotice.POTION_COMPLETE.Value:
					var bp:basePotion = Managers.potions.getPotionByGlobalID( data['id'] );
					if( bp != null ) {
						m_ico = ( Assets.getBitmap( bp.Image ) );
					}
					break;
				
				case TypeNotice.VILLAGE_COMPLETE_PRODUCTION.Value:
					var bs:baseConsumed = Managers.consumed.getConsumedByGlobalID( data['id'] );
					if( bs != null ) {
						m_ico = bs.Ico;
					}
					break;
				
				case TypeNotice.VILLAGE_UPGRADE.Value:
					var bo:baseOuthouse = Managers.outhouse.getOuthouseByID( data['id'] );
					m_ico = ( Assets.getBitmap( bo.Image ) ); 
					break;
				
				case TypeNotice.REPAIR_COMPLETE.Value:
					var ammo:Ammunition = Managers.current_ammunitions.getAmmunitionByGlobalID( data['id'] );
					m_ico = ammo.BaseAmmunition.Ico;
					break;
				
				case TypeNotice.AMMO_COMPLETE.Value:
					var ba:baseAmmunition = Managers.ammunitions.getAmmunitionByGlobalID( data['id'] );
					m_ico = ba.Ico;
					break;
			
				case TypeNotice.COMPLETE_STORM.Value:
					
					break;
				
				 default:
					 m_ico = Assets.getBitmap( "unknow" ) ; 
					break;
			}
			
			m_ico.smoothing = true;
			m_ico.width = 40;
			m_ico.height = 40;
			if ( m_ico.width > m_ico.height ){
				m_ico.width = 40 * m_ico.width / m_ico.height;
			}
			else{
				m_ico.height = 40 * m_ico.height / m_ico.width;
			}
			
			m_ico.x = 10;
			m_ico.y = 10;
			addChild( m_ico );
			
			try{
				m_text = new TextField();
				m_text.text = data['msg'];
				m_text.defaultTextFormat = new TextFormat( "Candara", 12, 0x000000 );
				m_text.autoSize = TextFieldAutoSize.LEFT;
				m_text.wordWrap = true;
				
				m_text.width = this.width - ( m_ico.x + m_ico.width ) - 15;
				m_text.height = this.height - 5;
			
				m_text.mouseEnabled = false;
				m_text.x = m_ico.x + m_ico.width + 10;
				m_text.y = m_ico.y + m_ico.height / 2  - m_text.height / 2;
				addChild( m_text );
			}
			catch( e:Error ){}
			
		}
		
		private function Draw():void{
			graphics.clear();
			graphics.beginFill( 0xe1ba7e, 0.9);
			graphics.drawRoundRect( 0, 0, 180, 60, 10, 10 );
			graphics.endFill();
		}
		
		public function Show( ):void{
					
			m_root.addChild( this );
			
			this.x = stage.stageWidth - this.width;
			this.y = stage.stageHeight;
			
			TweenLite.to( this , 0.5 , {y:(this.y - this.height) , onComplete:onEndMove } );
		}
		
		private function onEndMove():void{
			TweenLite.to( this , 0.5 , { delay: ManagerNotice.TIME_INTERVAL - 1, alpha:0 , onComplete:onEndShow } );
		}
		
		private function onEndShow( ):void{
			if ( this.parent ) m_root.removeChild( this );
		}
		
		private function ClickNotice( ):void{
			TweenLite.killTweensOf( this, true );
			switch( m_type ){
				case TypeNotice.POTION_COMPLETE.Value:
					Global.screenLobby.ShowScreen( new ScreenAlchemist() );
					break;
				case TypeNotice.REPAIR_COMPLETE.Value:
				case TypeNotice.AMMO_COMPLETE.Value:
					Global.screenLobby.ShowScreen( new ScreenSmith() );
					break;
			}
			
			if ( this.parent ) m_root.removeChild( this );
		}
		
		private function CloseNotice():void{
			TweenLite.killTweensOf( this, true );
			
			m_root.removeChild( this );
		}
	}
}