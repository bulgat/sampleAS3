package game.Managers
{
	import game.gameplay.artifact.baseArtifact;
	import game.gameplay.trophy.baseTrophy;

	public class ManagerArtifact extends ManagerBase
	{
		private var m_list:Object;
		
		public function ManagerArtifact( data:Object ) 
		{
			super( data );
			parseLocal( data );
		}
		
		private function parseLocal( data:Object ):void{
		
			m_list = new Object( );
			for each ( var xx:XML in data.item ){
				var b:baseArtifact = new baseArtifact( xx );
				m_list[b.globalID] = b;  
			}
		}
		
		public function getArtifactByID( id:int ):baseArtifact{
			return m_list[id];
		}
		
	}
}