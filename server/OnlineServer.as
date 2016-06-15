package game.server
{
	import core.net.Net;
	import core.net.netCommand;
	import core.social.TypeSocial;
	
	import game.Global;

	public class OnlineServer implements IServer
	{
		private var m_host:String;
		
		private var m_net:Net;
		
		public function OnlineServer( host:String  )
		{
			m_host = host;
			m_net = new Net( host );
		}
		//http://test1.ru/MiddleAges/index.php?type=player&action=init&soc_id=24&type_soc=vk&friends=10
		public function player_init ( uid:String , typeSoc:TypeSocial , friends:Array , callback:Function  , failedCallback:Function ):void{
			var comd:netCommand = new netCommand( "player_init" , ["type","player","action","init","soc_id",uid,"type_soc",Global.TypeSoc.Value,"friends",friends ] , callback , failedCallback );
			m_net.Execute( comd ); 
		}
		//http://test1.ru/MiddleAges/index.php?type=player&action=getActiveAction&UserId=103
		public function getInfoActiveAction( uid:String ,  callback:Function , failedCallback:Function ):void{
			var comd:netCommand = new netCommand( "player_getActiveAction" , ["type","player","action","getActiveAction","UserId",uid ] , callback , failedCallback );
			m_net.Execute( comd ); 
		}
		
		//http://test1.ru/MiddleAges/index.php?type=player&action=TakeResource&UserId=10&idVillage=0&idOuthouse=1
		public 	function TakeResources( uid:String , idVillage:int , idOuthouse:int , callback:Function  , failedCallback:Function ):void{
			var comd:netCommand = new netCommand( "player_TakeResource" , ["type","player","action","TakeResource","UserId",uid,"idVillage",idVillage,"idOuthouse",idOuthouse] , callback , failedCallback );
			m_net.Execute( comd ); 
		}
		
		public 	function ForceEndProduction( uid:String , idVillage:int , idOuthouse:int , callback:Function, failedCallback:Function ):void{
			var comd:netCommand = new netCommand( "player_ForceEnd" , ["type","player","action","ForceEnd","UserId",uid,"idVillage",idVillage,"idOuthouse",idOuthouse] , callback , failedCallback );
			m_net.Execute( comd ); 
		}
		
		//http://test1.ru/MiddleAges/index.php?type=player&action=UpgradeOuthouse&UserId=9&idVillage=0&idOuthouse=1
		public  function UpgradeOuthouse( uid:String , idVillage:int , idOuthouse:int ,  callback:Function  , failedCallback:Function ):void{
			var comd:netCommand = new netCommand( "player_UpgradeOuthouse" , ["type","player","action","UpgradeOuthouse","UserId",uid,"idVillage",idVillage,"idOuthouse",idOuthouse ] , callback , failedCallback );
			 m_net.Execute( comd ); 
		}	
	
		//http://test1.ru/MiddleAges/index.php?type=player&action=BuyAmmunition&UserId=15&ammunition_id=4
		public 	function BuyAmmunition( uid:String , idAmmunition:int ,  callback:Function  , failedCallback:Function):void{
			var comd:netCommand = new netCommand( "player_BuyAmmunition" , ["type","player","action","BuyAmmunition","UserId",uid,"ammunition_id",idAmmunition ] , callback , failedCallback );
			m_net.Execute( comd ); 
		}
		
		public function player_Ammunition( uid:String , callback:Function ):void{
		
		}
		
		public function GetFlower( uid:String, typeFlower:String , callback:Function, failedCallback:Function ):void{
			var comd:netCommand = new netCommand( "player_CollectionFlower" , ["type","player","action","CollectionFlower","UserId",uid,"flower_type",typeFlower ] , callback , failedCallback );
			m_net.Execute( comd ); 
		}
		
		//http://test1.ru/MiddleAges/index.php?type=Ammunition&action=BuySlot&UserId=98
		public function BuySlot( uid:String ,  callback:Function , failedCallback:Function ):void{
			var comd:netCommand = new netCommand( "Ammunition_BuySlot" , ["type","Ammunition","action","BuySlot","UserId",uid] , callback , failedCallback );
			m_net.Execute( comd );
		}
		
		//http://test1.ru/MiddleAges/index.php?type=player&action=DressAmmunition&UserId=15&ammunition_id=4
		public function player_dressAmmunition( uid:String , ammunitGlobalID:String , callback:Function  , failedCallback:Function):void{
			var comd:netCommand = new netCommand( "player_DressAmmunition" , ["type","player","action","DressAmmunition","UserId",uid,"ammunition_id",ammunitGlobalID ] , callback , failedCallback );
			m_net.Execute( comd );
		}
		
		//http://test1.ru/MiddleAges/index.php?type=player&action=TakeOffAmmunition&UserId=15&ammunition_id=4
		public function player_takeOffAmmunition( uid:String , ammunitGlobalID:String , callback:Function, failedCallback:Function ):void{
			var comd:netCommand = new netCommand( "player_TakeOffAmmunition" , ["type","player","action","TakeOffAmmunition","UserId",uid,"ammunition_id",ammunitGlobalID ] , callback , failedCallback );
			m_net.Execute( comd );
		}
		
		//http://test1.ru/MiddleAges/index.php?type=Ammunition&action=SellAmmunition&UserId=102&ammunition_id=902
		public function sellAmmunition( uid:String , idAmmunit:String , callback:Function  , failedCallback:Function ):void{
			var comd:netCommand = new netCommand( "Ammunition_SellAmmunition" , ["type","Ammunition","action","SellAmmunition","UserId",uid,"ammunition_id",idAmmunit ] , callback , failedCallback );
			m_net.Execute( comd );
		}
		
		//http://test1.ru/MiddleAges/index.php?type=InfoGame&action=getInfoUserID&UserId=22
		public function user_getInfo( uid:String , field:Array , callback:Function  , failedCallback:Function  ):void{
			var comd:netCommand = new netCommand( "InfoGame_getInfoUserID" , ["type","InfoGame","action","getInfoUserID","UserId",uid ] , callback , failedCallback );
			m_net.Execute( comd );
		}
		
		//http://test1.ru/MiddleAges/index.php?type=InfoGame&action=getInfoUser&soc_id=30&type_soc=vk
		public function user_getInfoSocID( uid:String , typeSoc:String , callback:Function  , failedCallback:Function  ) :void{
			var comd:netCommand = new netCommand( "InfoGame_getInfoUser" , ["type","InfoGame","action","getInfoUser","soc_id",uid,"type_soc", Global.TypeSoc.Value ] , callback , failedCallback );
			m_net.Execute( comd );
		}
		
		//http://test1.ru/MiddleAges/index.php?type=player&action=DamageAmmunition&UserId=22&ammunition_id=1
		public function DamageAmmunition( uid:String , idAmmunit:String ,callback:Function, failedCallback:Function ):void{
			var comd:netCommand = new netCommand( "player_DamageAmmunition" , ["type","player","action","DamageAmmunition","UserId",uid,"ammunition_id",idAmmunit ] , callback , failedCallback );
			m_net.Execute( comd ); 
		}
		
		//http://test1.ru/MiddleAges/index.php?type=player&action=RepairAmmunition&UserId=22&ammunition_id=1
		public function RepairAmmunition( uid:String , idAmmunit:String ,callback:Function, failedCallback:Function ):void{
			var comd:netCommand = new netCommand( "Ammunition_RepairAmmunition" , ["type","Ammunition","action","RepairAmmunition","UserId",uid,"ammunition_id",idAmmunit ] , callback , failedCallback );
			m_net.Execute( comd );
		}
		
		//http://test1.ru/MiddleAges/index.php?type=player&action=buyConsumed&UserId=36&consumed_id=6&count=10
		public function BuyConsumed( uid:String , idConsumed:int , count:int ,callback:Function, failedCallback:Function ):void{
			var comd:netCommand = new netCommand( "player_BuyConsumed" , ["type","player","action","BuyConsumed","UserId",uid,"consumed_id",idConsumed,"count",count ] , callback , failedCallback );
			m_net.Execute( comd );
		}
		
		//http://test1.ru/MiddleAges/index.php?type=player&action=getInfoGarden&UserId=35
		public function getInfoGarden( uid:String , callback:Function , failedCallback:Function):void{
			var comd:netCommand = new netCommand( "player_getInfoGarden" , ["type","player","action","getInfoGarden","UserId",uid ] , callback , failedCallback );
			m_net.Execute( comd );
		}
		
		//http://test1.ru/MiddleAges/index.php?type=singleCombat&action=findEnemy&UserId=36
		public function FindEnemy( uid:String , callback:Function , failedCallback:Function):void{
			var comd:netCommand = new netCommand( "SingleCombat_findEnemy" , ["type","singleCombat","action","findEnemy","UserId",uid ] , callback , failedCallback );
			m_net.Execute( comd );
		}
		
		//http://test1.ru/MiddleAges/index.php?type=trophys&action=applyTrophy&UserId=39&trophy_id=4
		public function applyTrophy( uid:String , trophyId:int , callback:Function , failedCallback:Function ):void{
			var comd:netCommand = new netCommand( "trophys_applyTrophy" , ["type","trophys","action","applyTrophy","UserId",uid ,"trophy_id" , trophyId ] , callback , failedCallback );
			m_net.Execute( comd ); 
		}
		
		//http://test1.ru/MiddleAges/index.php?type=fichas&action=applyFicha&UserId=45&ficha_id=0
		public function UsePotionForHeroes( uid:String , idPotion:int ,  callback:Function , failedCallback:Function ):void{
			var comd:netCommand = new netCommand( "fichas_applyFicha" , ["type","fichas","action","applyFicha","UserId",uid ,"ficha_id" , idPotion ] , callback , failedCallback );
			m_net.Execute( comd ); 
		}
		
		//http://test1.ru/MiddleAges/index.php?type=fichas&action=buyFicha&UserId=45&ficha_id=1
		public function BuyPotion( uid:String , idPotion:int ,  callback:Function , failedCallback:Function ):void{
			var comd:netCommand = new netCommand( "fichas_buyFicha" , ["type","fichas","action","buyFicha","UserId",uid ,"ficha_id" , idPotion ] , callback , failedCallback );
			m_net.Execute( comd ); 
		}
		
		////http://test1.ru/MiddleAges/index.php?type=trophys&action=CollectArtifact&UserId=45&artifact_id=1
		public function CollectionArtifact( uid:String , artifactId:int , callback:Function , failedCallback:Function ):void{
			var comd:netCommand = new netCommand( "trophys_CollectArtifact" , ["type","trophys","action","CollectArtifact","UserId",uid ,"artifact_id" , artifactId ] , callback , failedCallback );
			m_net.Execute( comd ); 
		}
		
		//http://test1.ru/MiddleAges/index.php?type=fichas&action=createFicha&UserId=45&artifact_id=1
		public function createPotion( uid:String , idPotion:int , callback:Function , failedCallback:Function ):void{
			var comd:netCommand = new netCommand( "fichas_createFicha" , ["type","fichas","action","createFicha","UserId",uid ,"ficha_id" , idPotion ] , callback , failedCallback );
			m_net.Execute( comd ); 
		}
		
		//http://test1.ru/MiddleAges/index.php?type=fichas&action=getInfoPotion&UserId=45
		public function getInfoPotion( uid:String  , callback:Function , failedCallback:Function ):void{
			var comd:netCommand = new netCommand( "fichas_getInfoPotion" , ["type","fichas","action","getInfoPotion","UserId",uid ] , callback , failedCallback );
			m_net.Execute( comd ); 
		}
		
		//http://test1.ru/MiddleAges/index.php?type=trophys&action=addTrophy&UserId=45&artifact_id=1
		public function addTrophy( uid:String , idTrophy:int , callback:Function , failedCallback:Function ):void{
			var comd:netCommand = new netCommand( "trophys_addTrophy" , ["type","trophys","action","addTrophy","UserId",uid ,"trophy_id",idTrophy ] , callback , failedCallback );
			m_net.Execute( comd );
		}
		
		
		//http://test1.ru/MiddleAges/index.php?type=fichas&action=ForceCompletePotion&UserId=45&ficha_id=1
		public function ForceCompletePotion( uid:String , idPotion:int , callback:Function , failedCallback:Function ):void{
			var comd:netCommand = new netCommand( "fichas_ForceCompletePotion" , ["type","fichas","action","ForceCompletePotion","UserId",uid ,"ficha_id" , idPotion ] , callback , failedCallback );
			m_net.Execute( comd ); 
		}
		
		//http://test1.ru/MiddleAges/index.php?type=fichas&action=TakeFicha&UserId=45&ficha_id=1
		public function TakePotion( uid:String , idPotion:int , callback:Function , failedCallback:Function ):void{
			var comd:netCommand = new netCommand( "fichas_TakeFicha" , ["type","fichas","action","TakeFicha","UserId",uid ,"ficha_id" , idPotion ] , callback , failedCallback );
			m_net.Execute( comd ); 
		}
		
		//=====================CALNS===========================
		//http://test1.ru/MiddleAges/index.php?type=clans&action=CreateClan&UserId=47
		public function CreateClan( uid:String , nameClan:String , callback:Function , failedCallback:Function ):void{
			var comd:netCommand = new netCommand( "clans_CreateClan" , ["type","clans","action","CreateClan","UserId",uid ,"nameClan",nameClan ] , callback , failedCallback );
			m_net.Execute( comd );
		}
		
		//http://test1.ru/MiddleAges/index.php?type=clans&action=KIllClan&UserId=47&clan_id=3
	   public function KillClan( uid:String , idClan:int , callback:Function , failedCallback:Function ):void{
		   var comd:netCommand = new netCommand( "clans_KillClan" , ["type","clans","action","KillClan","UserId" , uid , "clan_id" , idClan ] , callback , failedCallback );
		   m_net.Execute( comd );
	   }
	   
	   //http://test1.ru/MiddleAges/index.php?type=clans&action=JoinClan&clan_id=4&UserId=48
	   public function JoinClan( uid:String , idClan:int , callback:Function , failedCallback:Function ):void{
		   var comd:netCommand = new netCommand( "clans_JoinClan" , ["type","clans","action","JoinClan","UserId" , uid , "clan_id" , idClan ] , callback , failedCallback );
		   m_net.Execute( comd );
	   }
	   
	   //http://test1.ru/MiddleAges/index.php?type=clans&action=ExitClan&clan_id=4&UserId=48
	   public function ExitKlan(  uid:String , idClan:int , callback:Function , failedCallback:Function ):void{
		   var comd:netCommand = new netCommand( "clans_ExitClan" , ["type","clans","action","ExitClan","UserId" , uid , "clan_id" , idClan ] , callback , failedCallback );
		   m_net.Execute( comd );
	   }
	
	   //=====================STORM==========================================
	   //http://test1.ru/MiddleAges/index.php?type=storm&action=applySuperAttack&castle_id=1&UserId=57
	   public function applySuperAttack( uid:String , idCastle:int , callback:Function , failedCallback:Function ):void{
		   var comd:netCommand = new netCommand( "storm_applySuperAttack" , ["type","storm","action","applySuperAttack","UserId" , uid , "castle_id" , idCastle ] , callback , failedCallback );
		   m_net.Execute( comd );
	   }
	   
	   
	   public function applySiegeWeapon( uid:String , idCastle:int , idSiegeWeapon:int , callback:Function , failedCallback:Function ):void{
		   var comd:netCommand = new netCommand( "storm_applySiegeWeapon" , ["type","storm","action","applySiegeWeapon","UserId" , uid , "castle_id" , idCastle ,"siege_wepon_id" , idSiegeWeapon ] , callback , failedCallback );
		   m_net.Execute( comd );
	   }
	   
	  // http://test1.ru/MiddleAges/index.php?type=storm&action=applyActieAction&castle_id=1&UserId=55
	   public function applyActionSquad( uid:String , idCastle:int ,  callback:Function , failedCallback:Function ):void{
		   var comd:netCommand = new netCommand( "storm_applyActieAction" , ["type","storm","action","applyActieAction","UserId" , uid , "castle_id" , idCastle ] , callback , failedCallback );
		   m_net.Execute( comd );
	   }
	   
	   // http://test1.ru/MiddleAges/index.php?type=OwnerCastles&action=getInfo
	   public function getInfoOwnerCastle(   callback:Function , failedCallback:Function ):void{
		   var comd:netCommand = new netCommand( "OwnerCastles_getInfo" , ["type","OwnerCastles","action","getInfo"] , callback , failedCallback );
		   m_net.Execute( comd );
	   }
	   
	   // http://test1.ru/MiddleAges/index.php?type=OwnerCastles&action=getInfoStorm&UserId=55
	//   public function getInfoStorm ( uid:String  ,  callback:Function , failedCallback:Function ):void{
	//	   var comd:netCommand = new netCommand( "OwnerCastles_getInfoStorm" , ["type","OwnerCastles","action","getInfoStorm","UserId" , uid ] , callback , failedCallback );
	//	   m_net.Execute( comd );
	 //  }
	   
	   // http://test1.ru/MiddleAges/index.php?type=storm&action=CancelStorm&UserId=55&castle_id=1
	   public function CancelStorm( uid:String , idCastle:int ,   callback:Function , failedCallback:Function ):void{
		   var comd:netCommand = new netCommand( "storm_CancelStorm" , ["type","storm","action","CancelStorm","UserId" , uid , "castle_id" , idCastle ] , callback , failedCallback );
		   m_net.Execute( comd );
	   }
	   
	   //http://test1.ru/MiddleAges/index.php?type=storm&action=StartStorm&UserId=55&castle_id=1
	   public function StartStorm( uid:String , idCastle:int ,   callback:Function , failedCallback:Function ):void{
		   var comd:netCommand = new netCommand( "storm_StartStorm" , ["type","storm","action","StartStorm" , "UserId" , uid , "castle_id" , idCastle ] , callback , failedCallback );
		   m_net.Execute( comd );
	   }
	   
	   //http://test1.ru/MiddleAges/index.php?type=storm&action=getInfoStateCastle&UserId=102&castle_id=1
	   public function getInfoStateCastle( uid:String , idCastle:int ,   callback:Function , failedCallback:Function ):void{
		   var comd:netCommand = new netCommand( "storm_getInfoStateCastle" , ["type","storm","action","getInfoStateCastle" , "UserId" , uid , "castle_id" , idCastle ] , callback , failedCallback );
		   m_net.Execute( comd );
	   }
	   
	   //http://test1.ru/MiddleAges/index.php?type=storm&action=getAwardStorm&UserId=103
	   public function getAwardStorm( uid:String , idCastle:int ,   callback:Function , failedCallback:Function ):void{
		   var comd:netCommand = new netCommand( "storm_getAwardStorm" , ["type","storm","action","getAwardStorm" , "UserId" , uid ] , callback , failedCallback );
		   m_net.Execute( comd );
	   }
	   //==================GENERATE WEAPON
	  // http://test1.ru/MiddleAges/index.php?type=generateWeapon&action=getInfoGenerate
	   //http://test1.ru/MiddleAges/index.php?type=generateWeapon&action=getInfoGenerate
	   public function getInfoGenerateWeapon(  callback:Function , failedCallback:Function):void{
		   var comd:netCommand = new netCommand( "generateWeapon_getInfoGenerate" , ["type","generateWeapon","action","getInfoGenerate"] , callback , failedCallback );
		   m_net.Execute( comd ); 
	   }
	   
	   
	   //=РЫНОК
	   //http://test1.ru/MiddleAges/index.php?type=rialto&action=TakeCoin&UserId=97&count_coin=1
	   public function TakeCoinRialto( uid:String , countCoin:int ,   callback:Function , failedCallback:Function ):void{
		   var comd:netCommand = new netCommand( "rialto_TakeCoin" , [ "type" , "rialto" , "action" , "TakeCoin" , "UserId" , uid , "count_coin" , countCoin ] , callback , failedCallback );
		   m_net.Execute( comd ); 
	   }
	 //  http://test1.ru/MiddleAges/index.php?type=rialto&action=getInfoRialto&UserId=97
	   public function getInfoRialto( uid:String ,  callback:Function , failedCallback:Function ):void{
		   var comd:netCommand = new netCommand( "rialto_getInfoRialto" , [ "type" , "rialto" , "action" , "getInfoRialto" , "UserId" , uid ] , callback , failedCallback );
		   m_net.Execute( comd ); 
	   }
	   
	   
	   //=======BATTLE  boss
	  // http://test1.ru/MiddleAges/index.php?type=battleBoss&action=getInfoBoss
	   public function getInfoBoss(callback:Function , failedCallback:Function  ):void{
		   var comd:netCommand = new netCommand( "battleBoss_getInfoBoss" , [ "type" , "battleBoss" , "action" , "getInfoBoss" ] , callback , failedCallback );
		   m_net.Execute( comd ); 
	   }
	   
	   //http://test1.ru/MiddleAges/index.php?type=battleBoss&action=LeaveBattle&UserId=97
	   public function leaveBattleBoss( uid:String  ):void{
		   var comd:netCommand = new netCommand( "battleBoss_LeaveBattle" , [ "type" , "battleBoss" , "action" , "LeaveBattle" , "UserId" , uid ] , null , null );
		   m_net.Execute( comd ); 
	   }
	   
	   //http://test1.ru/MiddleAges/index.php?type=battleBoss&action=getBattleInfo&UserId=102
	   public function getInfoBattle ( uid:String , callback:Function , failedCallback:Function ):void{
		   var comd:netCommand = new netCommand( "battleBoss_getBattleInfo" , [ "type" , "battleBoss" , "action" , "getBattleInfo" , "UserId" , uid ] , callback , failedCallback );
		   m_net.Execute( comd ); 
	   }
	   
	   //http://test1.ru/MiddleAges/index.php?type=battleBoss&action=StartBattle&UserId=102&boss_id=1
	   public function StartBattleBoss( uid:String , bossID:String , callback:Function , failedCallback:Function ):void{
		   var comd:netCommand = new netCommand( "battleBoss_StartBattle" , [ "type" , "battleBoss" , "action" , "StartBattle" , "UserId" , uid , "boss_id", bossID] , callback , failedCallback );
		   m_net.Execute( comd ); 
	   }
	   
	   //http://test1.ru/MiddleAges/index.php?type=battleBoss&action=TakeDamage&UserId=102
	   public function HarmWeaponsBoss( uid:String , callback:Function , failedCallback:Function ):void{
		   var comd:netCommand = new netCommand( "battleBoss_TakeDamage" , [ "type" , "battleBoss" , "action" , "TakeDamage" , "UserId" , uid ] , callback , failedCallback );
		   m_net.Execute( comd );
	   }
	   
	   
	   
	   //===================SMITHY====================
	  // http://test1.ru/MiddleAges/index.php?type=Ammunition&action=CreateWeapon&UserId=102&ammunition_id=902
	   public function CreateWeaponSmithy( uid:String , idAmmunit:String , callback:Function , failedCallback:Function ):void{
		   var comd:netCommand = new netCommand( "Ammunition_CreateWeapon" , [ "type" , "Ammunition" , "action" , "CreateWeapon" , "UserId" , uid , "ammunition_id" , idAmmunit ] , callback , failedCallback );
		   m_net.Execute( comd );
	   }
	   
	  // http://test1.ru/MiddleAges/index.php?type=Ammunition&action=TakeSwordSmithy&UserId=102&ammunition_id=902
	   public function TakeWeaponSmithy( uid:String , idAmmunit:String ,  callback:Function , failedCallback:Function ):void{
		   var comd:netCommand = new netCommand( "Ammunition_TakeSwordSmithy" , [ "type" , "Ammunition" , "action" , "TakeSwordSmithy" , "UserId" , uid , "ammunition_id" , idAmmunit ] , callback , failedCallback );
		   m_net.Execute( comd );
	   }
	   
	   // http://test1.ru/MiddleAges/index.php?type=Ammunition&action=ForceCreateWeaponSmithy&UserId=102&ammunition_id=902
	   public function ForceCreateWeaponSmithy( uid:String , idAmmunit:String ,  callback:Function , failedCallback:Function ):void{
		   var comd:netCommand = new netCommand( "Ammunition_ForceCreateWeaponSmithy" , [ "type" , "Ammunition" , "action" , "ForceCreateWeaponSmithy" , "UserId" , uid , "ammunition_id" , idAmmunit ] , callback , failedCallback );
		   m_net.Execute( comd );
	   }
	   
	   // http://test1.ru/MiddleAges/index.php?type=Ammunition&action=RepairAmmunitionSmithy&UserId=102&ammunition_id=900
	   public function RepairAmmunitionSmithy( uid:String , idAmmunit:String ,  callback:Function , failedCallback:Function ):void{
		   var comd:netCommand = new netCommand( "Ammunition_RepairAmmunitionSmithy" , [ "type" , "Ammunition" , "action" , "RepairAmmunitionSmithy" , "UserId" , uid , "ammunition_id" , idAmmunit ] , callback , failedCallback );
		   m_net.Execute( comd );
	   }
	   
	   // http://test1.ru/MiddleAges/index.php?type=Ammunition&action=TakeReapirSmithy&UserId=103&ammunition_id=900
	   public function TakeReapirSmithy ( uid:String , idAmmunit:String ,  callback:Function , failedCallback:Function ):void{
		   var comd:netCommand = new netCommand( "Ammunition_TakeReapirSmithy" , [ "type" , "Ammunition" , "action" , "TakeReapirSmithy" , "UserId" , uid , "ammunition_id" , idAmmunit ] , callback , failedCallback );
		   m_net.Execute( comd );
	   }
	   
	   // http://test1.ru/MiddleAges/index.php?type=Ammunition&action=ForceRepairWeaponSmity&UserId=103&ammunition_id=900
	   public function ForceRepairWeaponSmity( uid:String , idAmmunit:String ,  callback:Function , failedCallback:Function ):void{
		   var comd:netCommand = new netCommand( "Ammunition_ForceRepairWeaponSmity" , [ "type" , "Ammunition" , "action" , "ForceRepairWeaponSmity" , "UserId" , uid , "ammunition_id" , idAmmunit ] , callback , failedCallback );
		   m_net.Execute( comd );
	   }
	   
	}
} 