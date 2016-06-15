package game
{
	import com.junkbyte.console.Cc;
	
	import game.gameplay.Player;

	public final class Console
	{
		public function Console()
		{
			
			Cc.addSlashCommand( "buyAmmunit" , BuyAmmunit );
			Cc.addSlashCommand( "buyPotion" , BuyPotion );
			Cc.addSlashCommand( "addTrophy" , addTrophy );
			Cc.addSlashCommand( "takeOffAmmunit" , TakeOffAmmunit );
			
			//Clans
			Cc.addSlashCommand( "CreateClan", CreateClan );
			Cc.addSlashCommand( "KillClan", KillClan );
			Cc.addSlashCommand( "JoinClan", JoinClan );
			Cc.addSlashCommand( "ExitKlan", ExitClan );
		}
		
		public static function RegFunction( alias:String , callback:Function ):void{
			Cc.addSlashCommand( alias , callback );
		}
		
	
		//---статич функции можно делать тут!!!! 
		
		public static function TakeOffAmmunit( idAmmunit:String ):void{
			Global.Server.player_takeOffAmmunition( Global.player.InternalID , idAmmunit ,onGood , onFailed );
		
			function onGood( e:*):void{
				trace( e );
			}
			
			function onFailed( e:* ):void{
				trace( e );
			}
		
		}
		
		private function BuyAmmunit( idAmmunit:String ):void{
			Global.player.BuyAmmunit( idAmmunit );
		}
		
		private function BuyPotion( idPotion:String ):void{
			Global.player.BuyPotion( idPotion );
		}
		
		private function addTrophy( idTrophy:String ):void{
			Global.player.addTrophy( idTrophy );
		}
		
		private function CreateClan( name:String ):void{
			Global.player.CreateClan( name );
		}
		
		private function KillClan( idClan:String ):void{
			Global.player.KillClan( idClan );
		}
		
		private function JoinClan( idClan:String ):void{
			Global.player.JoinClan( idClan );
		}
		
		private function ExitClan( idClan:String ):void{
			Global.player.ExitClan( idClan );
		}
		
	}
}