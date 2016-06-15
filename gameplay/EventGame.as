package game.gameplay
{
	public final class EventGame
	{
		/**
		 * поднимать событие при получении или изменении состояний или количественных значений
		 * например - вызвали метод забрать ресурс и пришел положительный ответ/ поднимаем это событие
		 * и его слушает например гуй отображающий инфу
		 */
		public static const UPDATE:EventGame = new EventGame( "UPDATE" );
		
		public function EventGame( type:String )
		{
			m_value = type;
		}
		
		public function get Type( ):String{
			return m_value;
		}
		
		private var m_value:String;
	}
}