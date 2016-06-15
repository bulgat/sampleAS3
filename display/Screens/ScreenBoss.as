package game.display.Screens
{
	import core.utils.ScrollBar;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import game.Global;
	import game.assets.Assets;
	import game.gameplay.consumed.TypeConsumed;
	
	public class ScreenBoss extends baseScreen
	{
		
		private var m_frame:Bitmap;
		private var m_title:TextField;
		
		private var m_scrollPanel:Sprite;
		private var m_scrollBar:ScrollBar;
		
		private var m_curData:Object;
		
		private namespace CALLBACK;
		
		public function ScreenBoss()
		{
			super();
			this.m_internalName = "ScreenBoss";
			
		}
		
		override protected function onAdd(event:Event):void{
			super.onAdd( event );
			
			//запрос данных с сервера
			CALLBACK::onResponseGood(
				{
					list:[
						{castle:"Костяная крепость",lord_name:"Имя лорда",guard_name:"Имя",price:10,winner_lord:1,winner_guard:1},
						{castle:"Костяная крепость",lord_name:"Имя лорда",guard_name:"Имя",price:10,winner_lord:1,winner_guard:1},
						{castle:"Костяная крепость",lord_name:"Имя лорда",guard_name:"Имя",price:10,winner_lord:1,winner_guard:1},
						{castle:"Костяная крепость",lord_name:"Имя лорда",guard_name:"Имя",price:10,winner_lord:1,winner_guard:1},
						{castle:"Костяная крепость",lord_name:"Имя лорда",guard_name:"Имя",price:10,winner_lord:1,winner_guard:1},
						{castle:"Костяная крепость",lord_name:"Имя лорда",guard_name:"Имя",price:10,winner_lord:1,winner_guard:1}
					]
				}
			);
		}
		
		CALLBACK function onResponseGood( response:Object ):void{
			
			onFill( response.list );
			
			CreateScroll();
			
			m_frame = Assets.getBitmap( "frame_boss" );
			addChild( m_frame );
			
			m_title = new TextField();
			m_title.defaultTextFormat = new TextFormat( "Candara", 18, 0xffffff );
			m_title.autoSize = TextFieldAutoSize.LEFT;
			m_title.text = "Лорды замков";
			m_title.mouseEnabled = false;
			m_title.x = 270;
			m_title.y = 5;
			addChild( m_title );
		}
		
		CALLBACK function onResponseBad( response:Object ):void{
			
		}
		
		private function CreateScroll():void{
						
			m_scrollBar = new ScrollBar( m_scrollPanel, new Rectangle( 0 , m_scrollPanel.y, 620, 505 ) );
			m_scrollBar.CreateScroll();
			m_scrollBar.x = 10;
			m_scrollBar.Offset = 50;
			addChild( m_scrollBar );
		}
		
		private function onFill( data:Object ):void{
			m_scrollPanel = new Sprite( );
			m_scrollPanel.y = 35;
			m_scrollPanel.x = 0;
			
			var dx:int = 0;
			var dy:int = 0;
			var index:uint = 1;
			for each( var obj:Object in data ){
				
				var itmBossWindow:ItmBossWindow = new ItmBossWindow( index, obj, AttackBoss, AttackGuard );
				itmBossWindow.x = dx;
				itmBossWindow.y = dy;
				m_scrollPanel.addChild( itmBossWindow );
				
				dy += itmBossWindow.height - 1;
				
				index++;
			}
			
		}
		
		private function AttackBoss( data:Object ):void{
			
			m_curData = data;
			
			if ( Global.player.subConsumed( TypeConsumed.SKULL, 1 ) ){
				//Серверный метод проверки хватает ли у нас ресурсов Global.Server
				CALLBACK::AttackBossGood( null );
			}
			else trace('Не хватает ресурсов');
			
		}
		
		CALLBACK function AttackBossGood( response:Object ):void{
			trace( 'Произвести атаку босса' );
			
			Global.screenLobby.ShowScreen( new ScreenAttackBoss( m_curData ) );
		}
		
		CALLBACK function AttackBossBad( response:Object ):void{
			trace("Сервер сказал, что у вас недостаточно ресурсов (черепов)");
		}
		
		private function AttackGuard( index:uint ):void{
			trace( 'Произвести атаку телохранителя с индексом - ' + index );
		}
		
		override protected function onDestroy():void{
			if ( m_frame ){
				m_frame.bitmapData.dispose();
				m_frame = null;
			}
		}
	}
}


import flash.display.Bitmap;
import flash.display.MovieClip;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import core.baseObject;
import core.gui.button.TypeButton;
import core.gui.button.iconButton;
import core.gui.button.stretchButton;

import game.Global;
import game.assets.Assets;
import game.display.villageList.InfoPlayerItm;

class ItmBossWindow extends baseObject{
	
	//анимация боссов
	[Embed(source="../../../../ResourcesGame/game/Screens/boss/animation/boss_1.swf")]
	private var boss_1:Class;
	
	[Embed(source="../../../../ResourcesGame/game/Screens/boss/animation/boss_2.swf")]
	private var boss_2:Class;
	
	[Embed(source="../../../../ResourcesGame/game/Screens/boss/animation/boss_3.swf")]
	private var boss_3:Class;
	
	[Embed(source="../../../../ResourcesGame/game/Screens/boss/animation/boss_4.swf")]
	private var boss_4:Class;
	
	[Embed(source="../../../../ResourcesGame/game/Screens/boss/animation/boss_5.swf")]
	private var boss_5:Class;
	
	[Embed(source="../../../../ResourcesGame/game/Screens/boss/animation/boss_6.swf")]
	private var boss_6:Class;
	
	private var m_boss:MovieClip;
	private var m_guard:Bitmap;
	
	private var m_back:Bitmap;
	
	private var m_castleTitle:TextField;
	private var m_nameBoss:TextField;
	private var m_nameGuard:TextField;
	private var m_winnerBossText:TextField;
	private var m_winnerGuardText:TextField;
	
	private var m_attackBoss:iconButton;
	private var m_attackGuard:stretchButton;
	
	private var m_winnerBoss:InfoPlayerItm;
	private var m_winnerGuard:InfoPlayerItm;
	
	private var m_data:Object;
	private var m_onAttackBoss:Function;
	private var m_onAttackGuard:Function;
	
	private namespace CALLBACK;
	public function ItmBossWindow( index:uint, data:Object, onAttackBoss:Function, onAttackGuard:Function ):void{
		
		m_data = new Object();
		m_data['index'] = index;
		m_data['price'] = data["price"];
		m_data['lord_name'] = data['lord_name'];
		
		m_onAttackBoss = onAttackBoss;
		m_onAttackGuard = onAttackGuard;
		
		m_back = Assets.getBitmap( "back_boss" );
		addChild( m_back );
		
		m_castleTitle = new TextField();
		m_castleTitle.defaultTextFormat = new TextFormat( "Candara", 18, 0xffffff );
		m_castleTitle.autoSize = TextFieldAutoSize.LEFT;
		m_castleTitle.text = data['castle'];
		m_castleTitle.mouseEnabled = false;
		m_castleTitle.x = 30;
		m_castleTitle.y = -1;
		addChild( m_castleTitle );
		
		//Лорд
		m_boss = new this[ "boss_" + String(index) ]();
		m_boss.x = 21;
		m_boss.y = 50;
		addChildAt( m_boss, 0 );
		
		m_data['lord'] = m_boss;
		
		m_nameBoss = new TextField();
		m_nameBoss.defaultTextFormat = new TextFormat( "Candara", 18, 0x000000 );
		m_nameBoss.autoSize = TextFieldAutoSize.LEFT;
		m_nameBoss.text = "Лорд " + data['lord_name'];
		m_nameBoss.mouseEnabled = false;
		m_nameBoss.x = 30;
		m_nameBoss.y = 22;
		addChild( m_nameBoss );
		
		m_attackBoss = new iconButton( Assets.getBitmap( "icon_skull" ), TypeButton.DIFFICULT_GREEN, 110, "вызвать на бой " + data["price"] );
		m_attackBoss.x = 28;
		m_attackBoss.y = 235;
		m_attackBoss.Click = BossClick;
		addChild( m_attackBoss );
		
		//Телохранитель
		m_guard = Assets.getBitmap( "bodyguard_"+String(index) );
		m_guard.x = 233;
		m_guard.y = 113;
		addChildAt( m_guard, 0);
		
		m_nameGuard = new TextField();
		m_nameGuard.defaultTextFormat = new TextFormat( "Candara", 18, 0x000000, null, null, null, null, null, "center", null, null, null, 0 );
		m_nameGuard.autoSize = TextFieldAutoSize.CENTER;
		m_nameGuard.width = 125;
		m_nameGuard.wordWrap = true;
		m_nameGuard.text = "Телохранитель" + data['guard_name'];
		m_nameGuard.mouseEnabled = false;
		m_nameGuard.x = 232;
		m_nameGuard.y = 62;
		addChild( m_nameGuard );
		
		m_attackGuard = new stretchButton( TypeButton.SIMPLE_GREEN, 10, "атаковать" );
		m_attackGuard.x = 255;
		m_attackGuard.y = 238;
		m_attackGuard.Click = GuardClick;
		addChild( m_attackGuard );
		//------------
		
		m_winnerBoss = new InfoPlayerItm( '1', '99', data['winner_lord'], onWinnerBossComplete );
		m_winnerBoss.x = 405;
		m_winnerBoss.y = 25;
		addChild( m_winnerBoss );
		
		m_winnerBossText = new TextField();
		m_winnerBossText.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000, null, null, null, null, null, "center", null, null, null, -2 );
		m_winnerBossText.autoSize = TextFieldAutoSize.CENTER;
		m_winnerBossText.wordWrap = true;
		m_winnerBossText.text = "Победитель лорда";
		m_winnerBossText.mouseEnabled = false;
		m_winnerBossText.x = 495;
		m_winnerBossText.y = 25;
		addChild( m_winnerBossText );
		
		m_winnerGuard = new InfoPlayerItm( '1', '99', data['winner_guard'], onWinnerGuardComplete );
		m_winnerGuard.x = 405;
		m_winnerGuard.y = 158;
		addChild( m_winnerGuard );
		
		m_winnerGuardText = new TextField();
		m_winnerGuardText.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000, null, null, null, null, null, "center", null, null, null, -2 );
		m_winnerGuardText.autoSize = TextFieldAutoSize.CENTER;
		m_winnerGuardText.wordWrap = true;
		m_winnerGuardText.text = "Победитель телохранителя";
		m_winnerGuardText.mouseEnabled = false;
		m_winnerGuardText.x = 495;
		m_winnerGuardText.y = 155;
		addChild( m_winnerGuardText );
		
	}
	
	private function onWinnerBossComplete( params:Object ):void{
		var name:TextField = new TextField();
		name.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000, true, null, null, null, null, "center", null, null, null, 0 );
		name.autoSize = TextFieldAutoSize.CENTER;
		name.wordWrap = true;
		name.text = params['first_name'] +"\n"+ params['last_name'];
		name.mouseEnabled = false;
		name.x = 495;
		name.y = 65;
		addChild( name );
	}
	
	private function onWinnerGuardComplete( params:Object ):void{
		var name:TextField = new TextField();
		name.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000, true, null, null, null, null, "center", null, null, null, 0 );
		name.autoSize = TextFieldAutoSize.CENTER;
		name.wordWrap = true;
		name.text = params['first_name'] +"\n"+ params['last_name'];
		name.mouseEnabled = false;
		name.x = 495;
		name.y = 195;
		addChild( name );
	}
	
	private function BossClick():void{
		Global.Server.StartBattleBoss( Global.player.InternalID , "1", CALLBACK::onGoodCall , CALLBACK::onFailedCall );
		
		
	}
	
	CALLBACK function onGoodCall( e:Object ):void{
		m_onAttackBoss( m_data );
	}
	
	CALLBACK function onFailedCall( e:Object ):void{
	
	}
	
	private function GuardClick():void{
		m_onAttackGuard( int( m_data['index'] ) );
	}
	
	protected override function onDestroy():void{
		
		if ( m_guard ){
			m_guard.bitmapData.dispose();
			m_guard = null;
		}
		
		if ( m_back ){
			m_back.bitmapData.dispose();
			m_back = null;
		}
		
		m_boss = null;
	}
	
}