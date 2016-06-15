package game.display.storming
{
	import core.baseObject;
	import core.gui.progress.ProgressHint;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import game.Global;
	import game.assets.Assets;
	import game.display.Screens.ScreenStorming;
	import game.gameplay.storm.IChangeStormCastle;
	import game.gameplay.storm.StormCastle;

	/**
	 * панель со списком действий -
	 * типа атаковать отрядом 
	 * @author volk
	 * 
	 */	
	public class PnlActionStorm extends baseObject implements IChangeStormCastle
	{
		private var m_label:TextField;
		
		private var m_scoreDamage:TextField;
		
		private var m_listItm:Vector.<ItmActionStorm>  = new Vector.<ItmActionStorm>;
		
		private var m_progressDown:ProgressHint;
		
		private var m_connect:StormCastle;
		
		private var m_screenStorming:ScreenStorming;
		
		private namespace CALLBACK;
		
		public function PnlActionStorm( screenStorming:ScreenStorming )
		{
			m_screenStorming = screenStorming;
			y = 520;
			m_label = new TextField( );
			m_label.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000 );
			m_label.mouseEnabled = false;
			m_label.text = "атака отряда";
			m_label.autoSize = TextFieldAutoSize.LEFT;
			m_label.y = -5;
			m_label.x = 68;
			addChild( m_label );
		
			m_scoreDamage = new TextField( );
			m_scoreDamage.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000 );
			m_scoreDamage.mouseEnabled = false;
			m_scoreDamage.text = "0/" + StormCastle.MAX_POWER_SQUARD;
			m_scoreDamage.autoSize = TextFieldAutoSize.LEFT;
			m_scoreDamage.x = 68;
			m_scoreDamage.y = 25;
			addChild( m_scoreDamage );
		
			m_progressDown = new ProgressHint( Assets.getBitmap( "vill_list_top_bar" ) );
			m_progressDown.Color = 0xe51b1a;
			m_progressDown.Max = StormCastle.MAX_POWER_SQUARD;
			m_progressDown.Value =  0;
			m_progressDown.x = 70;
			m_progressDown.y = 15;
			m_progressDown.showLabel(false);
			addChild( m_progressDown );
			
			addEventListener( Event.ADDED_TO_STAGE , onAdd );
		
		}
		
		private function onAdd( e:Event ):void{
			removeEventListener( Event.ADDED_TO_STAGE , onAdd );
			m_connect = StormCastle.getStormCastleForID( m_screenStorming.CastleID );
			if( m_connect != null )
				m_connect.Connect( this );
			
			fill();
		}
		
		public function Change( storm:StormCastle ):void{
			m_progressDown.Value = storm.PowerSquad;
			m_scoreDamage.text = m_progressDown.Value + "/" + m_progressDown.Max;
			for each ( var it:ItmActionStorm in m_listItm ){
				if( m_connect.PowerSquad < StormCastle.POWER_ATTACK_SQUAD ) 
					it.Active( false );
				else
					it.Active( true );
			}
		}
		
		private function fill():void{
			var itm:ItmActionStorm;
	    	for( var i:int = 0; i< 3; i++){
				
				if ( m_connect ) itm = new ItmActionStorm( Attack, i, m_connect.DamageSquard );
				else
					itm = new ItmActionStorm( Attack, i, 0 );
				itm.x = 280 + i*140; 
				addChild( itm );
				m_listItm.push( itm );
			}
		}
		
		private function Attack( idAction:int ):void{
			
			Global.Server.applyActionSquad( Global.player.InternalID, m_screenStorming.CastleID, CALLBACK::onAttackGood, CALLBACK::onAttackBad );
			
		}
		
		CALLBACK function onAttackGood( response:Object ):void{
			m_connect.addAttackSquad();
		}
		
		CALLBACK function onAttackBad( response:Object ):void{
			trace('Атака не удалась');
		}
		
		public function Active( flag:Boolean ):void{
			
			for(var i:int = 0; i < m_listItm.length; i++)
				m_listItm[i].Active( flag );
			
		}
		
		override protected function onDestroy():void{
			if( m_connect != null )
				m_connect.Disconnect( this );
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

import game.assets.Assets;
import game.display.Screens.ScreenStorming;
import game.display.storming.PnlActionStorm;


class ItmActionStorm extends baseObject{
	
	private var m_callback:Function;
	
	private var m_id:int;
	
	private var m_btnAttack:stretchButton;
	
	private var m_label:TextField;
	
	public function ItmActionStorm( callback:Function, idAction:int, power:int ){
		m_callback = callback;
		
		m_id = idAction;
		
		m_label = new TextField( );
		m_label.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000 );
		m_label.mouseEnabled = false;
		m_label.text = power.toString();
		m_label.autoSize = TextFieldAutoSize.LEFT;
		addChild( m_label );
		
		m_btnAttack = new stretchButton( TypeButton.SIMPLE_GREEN, 10, "атаковать" );
		m_btnAttack.y = 20;
		m_btnAttack.Click = onApply;
		m_btnAttack.Enabled = false;
		addChild( m_btnAttack );
		
		m_label.x = m_btnAttack.width / 2 - m_label.width / 2;
		
	}
	
	public function Active( flag:Boolean ):void{
		m_btnAttack.Enabled = flag;
	}
	
	private function onApply( ):void{
		m_callback( m_id );		
	}
	
}