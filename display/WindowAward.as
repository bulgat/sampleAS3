package game.display
{
	import core.baseObject;
	import core.gui.button.baseButton;
	
	import game.gameplay.bank.baseBank;

	/**
	 * окно с уведомлением о награде 
	 * @author volk
	 * 
	 */	
	public class WindowAward extends baseObject
	{
		private var m_btnOk:baseButton;
		
		public function WindowAward( )
		{
			
		}
		
		override protected function onDestroy():void{
		
		}
	}
}