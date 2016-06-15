package game.gameplay
{
	import core.Events.EditEvent;
	
	import game.display.notice.TypeNotice;

	public class EventNotice extends EditEvent
	{
		public static const EVENT_NOTICE:String = "EVENT_NOTICE";
		
		public function EventNotice( type:TypeNotice , data:Object  )
		{
			var t_object:Object = data;
			t_object['type'] = type.Value;
			super( EVENT_NOTICE , t_object );
		}
		
	}
}