package game.display.domain
{
	import flash.text.TextField;
	
	import core.baseObject;
	import core.action.ImageLoader;

	public class InfoLooser extends baseObject
	{
		private var m_txtLevel:TextField;
		
		private var m_txtProtected:TextField;
		
		private var m_Avatar:ImageLoader;
		
		public function InfoLooser( data:Object )
		{
			m_txtLevel      = new TextField( );
			m_txtProtected  = new TextField( );
			addChild( m_txtLevel );
			addChild( m_txtProtected );
		} 
		
		
	}
}