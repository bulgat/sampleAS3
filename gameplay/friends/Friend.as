package game.gameplay.friends
{
	/**
	 * описалово друга / в сетке / в клане / в игре / 
	 * @author volk
	 * расширить по мере освоения тз
	 */	
	public class Friend
	{
		private var m_Id:String;
		
		private var m_type:TypeFriend;
		
		private var m_name:String;
		
		
		public function Friend( obj:Object )
		{
			
		}
		
		public function get ID( ):void{
			return m_Id;
		}
		
		public function get Type( ):TypeFriend{
			return m_type;
		}
	}
}