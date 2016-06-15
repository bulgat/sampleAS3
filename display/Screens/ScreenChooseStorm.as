package game.display.Screens
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import game.assets.Assets;
	import game.Global;
	import game.display.Lobby.ScreenLobby;

	public class ScreenChooseStorm extends baseScreen
	{
		
		private var m_frame:Bitmap;
		private var m_title:TextField;
		
		private namespace CALLBACK;
		
		public function ScreenChooseStorm( )
		{
			super();
			this.m_internalName = "ScreenChooseStorm";		
		}
		
		override protected function onAdd(event:Event):void{
			super.onAdd( event );
			
			Global.Server.getInfoOwnerCastle( CALLBACK::onResponseGood, CALLBACK::onResponseBad );
			//запрос данных с сервера
			/*
			CALLBACK::onResponseGood(
				{
					list:[
						{castle:"Костяная крепость",castleID:"1",ownerID:"1",health:"50",max_health:"100"},
						{castle:"Костяная крепость",castleID:"2",ownerID:"1",health:"50",max_health:"100"},
						{castle:"Костяная крепость",castleID:"3",ownerID:"1",health:"50",max_health:"100"},
						{castle:"Костяная крепость",castleID:"4",ownerID:"1",health:"50",max_health:"100"},
						{castle:"Костяная крепость",castleID:"5",ownerID:"1",health:"50",max_health:"100"},
						{castle:"Костяная крепость",castleID:"6",ownerID:"1",health:"50",max_health:"100"}
					]
				}
			);*/
		}
		
		CALLBACK function onResponseGood( response:Object ):void{
			
			onFill( response );
			
			m_frame = Assets.getBitmap( "frame_storm" );
			addChild( m_frame );
			
			m_title = new TextField();
			m_title.defaultTextFormat = new TextFormat( "Candara", 18, 0xFFFFFF );
			m_title.mouseEnabled = false;
			m_title.text = "Замки";
			m_title.autoSize = TextFieldAutoSize.LEFT;
			m_title.y = 5;
			m_title.x = m_frame.width / 2 - m_title.width / 2;
			addChild( m_title );
			
		}
		
		CALLBACK function onResponseBad( response:Object ):void{
			
		}
		
		private function onFill( data:Object ):void{
			
			var dx:int = 8;
			var dy:int = 30;
			var index:uint = 1;
			
			for ( var key:* in data ){
				if (index>6)return; //потом удалить, когда с сервера будет приходить корректное количество замков
								
				var castle:ItmCastle = new ItmCastle( key, data[key], onStormCastle );
				castle.x = dx;
				castle.y = dy;
				addChild( castle );
				
				dx += castle.width + 1;				
				
				if ( !(index % 2) ){
					dx = 8;
					dy += castle.height;
				}
				
				index++;
				
			}
			
		}
		
		private function onStormCastle( index:int ):void{
			
			Global.screenLobby.ShowScreen( new ScreenStorming( index ) ); 
			
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
import core.gui.button.stretchButton;

import flash.display.Bitmap;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import game.Global;
import game.Managers.Managers;
import game.assets.Assets;
import game.display.villageList.InfoPlayerItm;
import game.display.storming.baseCastle;

class ItmCastle extends baseObject{
	
	private var m_ico:Bitmap;
	private var m_back:Bitmap;
	private var m_title:TextField;
	private var m_stata:TextField;
	private var m_owner:TextField;
	private var m_name:TextField;
	private var m_player:InfoPlayerItm;
	private var m_stormBtn:stretchButton;
	
	private var m_castle:baseCastle;
	private var m_callBack:Function;
	
	public function ItmCastle( globalID:String, data:Object, callBack:Function ){
		
		m_castle = Managers.castle.getCastleByGlobalID( globalID );
		m_callBack = callBack;
		
		m_ico = Assets.getBitmap( "castle_ico_" + String( m_castle.GlobalID ) );
		m_ico.x = 20;
		m_ico.y = 33;
		addChild( m_ico );
		
		m_back = Assets.getBitmap( "back_storm" );
		addChild( m_back );
		
		m_title = new TextField();
		m_title.defaultTextFormat = new TextFormat( "Candara", 18, 0xFFFFFF );
		m_title.mouseEnabled = false;
		m_title.text = m_castle.Name;
		m_title.autoSize = TextFieldAutoSize.LEFT;
		m_title.y = 0;
		m_title.x = 15;
		addChild( m_title );
		
		m_owner = new TextField();
		m_owner.defaultTextFormat = new TextFormat( "Candara", 16, 0x000000, null, null, null, null, null, "center", null, null, null, -8 );
		m_owner.mouseEnabled = false;
		m_owner.text = "Владелец\nзамка";
		m_owner.autoSize = TextFieldAutoSize.LEFT;
		m_owner.y = 20;
		m_owner.x = 220;
		addChild( m_owner );
		
		/*
		m_stata = new TextField();
		m_stata.defaultTextFormat = new TextFormat( "Candara", 18, 0x000000 );
		m_stata.mouseEnabled = false;
		m_stata.text =  "4500/5000";
		m_stata.autoSize = TextFieldAutoSize.LEFT;
		m_stata.y = 30;
		m_stata.x = 20;
		addChild( m_stata );
		*/
		
		m_stormBtn = new stretchButton( TypeButton.SIMPLE_GREEN, 1, "штурм" );
		m_stormBtn.x = 75;
		m_stormBtn.y = 140;
		m_stormBtn.Click = onStorm;
		addChild( m_stormBtn );
		if ( data["globalID"] == Global.player.SocID )
			m_stormBtn.Enabled = false;
		
		m_player = new InfoPlayerItm( '1', '99', data["globalID"], onLoad );
		m_player.x = 220;
		m_player.y = 50;
		addChild( m_player );
		
	}
	
	private function onLoad( params:Object ):void{
		m_name = new TextField();
		m_name.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000, true, null, null, null, null, "center", null, null, null, -5 );
		m_name.autoSize = TextFieldAutoSize.CENTER;
		m_name.wordWrap = true;
		m_name.text = params['first_name'] +"\n"+ params['last_name'];
		m_name.mouseEnabled = false;
		m_name.x = 210;
		m_name.y = 130;
		addChild( m_name );
	}
	
	private function onStorm():void{
		m_callBack( m_castle.GlobalID );
	}
	
	override protected function onDestroy():void{
		
		if ( m_ico ){
			m_ico.bitmapData.dispose();
			m_ico = null;
		}
		
		if ( m_back ){
			m_back.bitmapData.dispose();
			m_back = null;
		}
		
	}
	
}