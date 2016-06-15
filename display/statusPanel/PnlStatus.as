package game.display.statusPanel
{
	import flash.events.Event;
	import flash.sensors.Accelerometer;
	
	import core.baseObject;
	import core.Events.GeneralDispatcher;
	import core.gui.progress.Progress;
	import core.gui.button.scaleButton;
	
	import game.gameplay.EventGame;

	/**
	 * Панель статуса / во всех скринах
	 * кнопки настроек / аватар / текущие прогрессы чего то там /
	 * 
	 * @author volk
	 * 
	 */	
	public class PnlStatus extends baseObject
	{
		private var m_dispatcher:GeneralDispatcher;
		
		private var m_bSetting:scaleButton;
		
		private var m_pProgressLive:Progress;
		
		public function PnlStatus()
		{
			m_dispatcher = new GeneralDispatcher( );
			m_dispatcher.addEventListener( EventGame.UPDATE.Type , onUpdateState );
		
			m_bSetting = new scaleButton( );
			m_bSetting.Click = onClickSetting;
		}
		
		private function onUpdateState( event:Event ):void{
			
		}
		
		// окно настроек
		private function onClickSetting( ):void{
		
		}
	}
}