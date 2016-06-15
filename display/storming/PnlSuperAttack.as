package game.display.storming
{
	import core.baseObject;
	import core.gui.button.TypeButton;
	import core.gui.button.buttonUpDown;
	import core.gui.button.iconButton;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import game.Global;
	import game.gameplay.storm.StormCastle;
	import game.assets.Assets;
	import game.display.Screens.ScreenStorming;

	/**
	 * супер нахлобучка
	 * @author volk
	 * 
	 */	
	public class PnlSuperAttack extends baseObject
	{
		private var m_btnBuild:buttonUpDown;
		
		private var m_ico:Bitmap;
		
		private var m_screenStorming:ScreenStorming;
		
		private var m_connect:StormCastle;
		
		private namespace CALLBACK;
		
		public function PnlSuperAttack( screenStorming:ScreenStorming )
		{
			m_screenStorming = screenStorming;
			x = 427;
			y = 400;
			m_btnBuild = new iconButton( Assets.getBitmap( "icon_coin_silver_small" ), TypeButton.DIFFICULT_GREEN, 80, "атаковать за 10");
			m_btnBuild.x = 60;
			m_btnBuild.y = 82;
			m_btnBuild.Click = onAttack;
			addChild( m_btnBuild );
			
			m_ico = Assets.getBitmap( "unknow" );
			addChild( m_ico );
			
			addEventListener( Event.ADDED_TO_STAGE , onAdd );
		}
				
		private function onAdd( e:Event ):void{
			removeEventListener( Event.ADDED_TO_STAGE , onAdd );
			m_connect = StormCastle.getStormCastleForID( m_screenStorming.CastleID );
		}
		
		private function onAttack():void{
			//Ещё нужно проверить хватает ли ресурсов
			Global.Server.applySuperAttack( Global.player.InternalID, m_screenStorming.CastleID, CALLBACK::onAttackGood, CALLBACK::onAttackBad );
		}
		
		CALLBACK function onAttackGood( response:Object ):void{
			trace('Супер атака удалась');
		}
		
		CALLBACK function onAttackBad( response:Object ):void{
			trace('Супер атака не прошла');
		}
		
		public function Active( flag:Boolean ):void{
			m_btnBuild.Enabled = flag;
		}
		
		override protected  function onDestroy():void{
			m_ico.bitmapData.dispose();
			m_ico = null;
		}
	}
}