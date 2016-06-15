package game.gameplay
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import core.Events.GeneralDispatcher;
	import core.task.TaskAmmo;
	import core.task.TaskPotion;
	import core.task.TaskRepair;
	
	import game.Global;
	import game.Managers.ManagerCurrentAmmunition;
	import game.Managers.Managers;
	import game.Managers.ManagersVillage;
	import game.display.notice.TypeNotice;
	import game.display.notice.baseNotice;
	import game.gameplay.alchemy.basePotion;
	import game.gameplay.ammunition.Ammunition;
	import game.gameplay.ammunition.baseAmmunition;
	import game.gameplay.consumed.TypeConsumed;
	import game.gameplay.storm.StormCastle;
	import game.gameplay.trophy.baseTrophy;

	public class Player
	{
		public static const MAX_HEALTH:int = 1500;
		public static const MAX_HONOR:int = 1500;
		public static const MAX_EXP:int = 2500;
		
		private var m_countFriends:int = 0;
		
		private var m_name:String = 'Unknow';
		
		private var m_level:int = 1;
		
		private var m_clan:int = 1;
		
		private var m_clanId:uint = 0;
		
		private var m_consumed:Object; //Все ресурсы игрока 
		
		private var m_garden:Object; // Данные о саде на текущий день
		private var m_gardenRefresh:int = 0; //Время обновления сада
		private var m_gardenTime:int = 0; //Когда последний раз в саду собрали всё
		
		private var m_ammoOnRepair:Vector.<ItmAmmoRepair> = new Vector.<ItmAmmoRepair>; //аммуниция на ремонте
		private var m_ammoOnCreate:Vector.<ItmAmmoCreate> = new Vector.<ItmAmmoCreate>; //аммуниция на изготовлении
		
		private var m_potions:Object; //зелья в наличии
		private var m_potionsCreate:Vector.<ItmPotionCreate> = new Vector.<ItmPotionCreate>; //зелья в разработке
 		private var m_trophies:Object; //трофеи в наличии
		private var m_artifact:Object; //артифакты в наличии
		
		private var m_taskPotion:TaskPotion; //таска о зельe, которое в процессе создания
		private var m_taskAmmo:TaskAmmo; //таска об аммуниции, которая на изготовлении
		private var m_taskRepair:TaskRepair; //таска об аммуниции, которая на починке
		
		private var m_soc_uid:String = "1";
		
		private var m_internalID:String ="-1";
		
		//стата
		private var m_health:Number = 1000;
		private var m_honor:Number = 1000;
		private var m_exp:Number = 1000;
		//очередь с зельями , влияющимим на скорость восстановления здоровья/храбрости/бла бла 
		private var m_turnPotion:Vector.<basePotion> = new Vector.<basePotion>( );
		//скорость восстановления статы
		private var m_healthIncrease:int = 0;
		private var m_honorIncrease:int = 0;
		private var m_timerStata:Timer = new Timer( 1000, 0 );
		
		private var m_luck:Number = 0;
		private var m_agility:int = 0;
		
		private var m_friends:Array;
		
		private var m_friendsApp:Array;
		
		private var UpdateEvent:Event = new Event( EventGame.UPDATE.Type );
		
		private namespace CALLBACK;
		
		public function Player( soc_uid:String , data:Object )
		{
			
			m_soc_uid = soc_uid;
			
			if( Global.Online )
				parseOnline( data );
			else
				parseLocal( data );
			
			init( );
		}
		
		private function init(  ):void{
			Global.social.GetUserFriends( m_soc_uid, CALLBACK::onFill ); 
		//	Global.Server.player_init( m_soc_uid , Global.TypeSoc , new Array() , CALLBACK::onInit  , CALLBACK::onFailedInit );
		
		//CALLBACK::onFill( [10,14,122,3323] );
		
		}
		
		CALLBACK  function onFill( listID:Array ):void{
			Global.Server.player_init( m_soc_uid , Global.TypeSoc , listID , CALLBACK::onInit  , CALLBACK::onFailedInit );
		}
		
		CALLBACK function onInit(  response:Object ):void{
			Managers.villages = new ManagersVillage( response );
			//время старта игры
			Global.startTimeGame = int(response['time']);
			m_gardenTime = int(response['gardenCollection']);
			m_gardenRefresh = int(response['second_day']);
			//m_level = uint( response['level'] );
			this.m_internalID    = response['internalID'];
			this.m_level = response['level'];
			this.m_clan = response['clan'];
			
			this.m_countFriends =  response.data.count_friends;
			
			FillConsumed( response.data.consumed );
			FillGarden( response.garden );
			FillPotion( response.potion );
			FillAmmo( response );
			FillTrophy( response.trophys );
			FillArtifact( null );
			FillStorm( response.storm );
			m_healthIncrease = Managers.player.HealthInc;
			m_honorIncrease = Managers.player.HonorInc;
			
			StartIncrease( );
			
			Global.Chat.Connect( );
		}
		
		private function FillStorm( data:Object ):void{
			trace( "Штурм замка ==>"+ JSON.stringify( data  ));
		    if ( data == null ) return;
			
			var notice:baseNotice;			
			if( data.state == "looser" ){
				trace( 'Хлопец... не хера не взял ты замок.. '+data.id );
				notice = new baseNotice( Global.Root, { type:TypeNotice.COMPLETE_STORM, id:data.id, msg:"Вы не смогли захватить замок " } );
				Global.Notice.addNotice( notice );
				return;
			}
			
			if( data.state == "winner" ){
				trace( "Завалил замок .... на тебе плюшку");
				notice = new baseNotice( Global.Root, { type:TypeNotice.COMPLETE_STORM, id:data.id, msg:"Красава.. завалил замок " } );
				Global.Notice.addNotice( notice );
				return;
			}
			
			for( var it:* in data ){
				trace( "idCastle  "+ it);
				
				if ( int( data[it].startStorm ) > 0 )
					Global.Tasks.addTask( new StormCastle( int( it ), data[it] ) );
			}
		}
		
		private function FillConsumed( data:Object ):void{
			m_consumed = new Object;
			
			for (var xx:* in data){
				m_consumed[xx] = int( data[xx] );
				
				switch ( xx ){
					case "health": m_health = int( data[xx] ); break;
					case "honor": m_honor = int( data[xx] ); break;
					case "exp": m_exp = int( data[xx] ); break;
				}
			}
		}
		
		private function FillGarden( data:Object ):void{
			m_garden = new Object;
			
			for (var xx:* in data){
				if ( int( data[xx] ) > 0 )
				m_garden[xx] = int( data[xx] );
			}
		}
		
		private function FillAmmo( data:Object ):void{
			trace( "Ammuni  => "+ JSON.stringify( data.ammunit ) );
			Managers.current_ammunitions = new ManagerCurrentAmmunition( data.ammunit );
			
			var key:String;
			
			for( key in data.ammunit.listRepair ){
				RepairAmmo( Managers.ammunitions.getAmmunitionByGlobalID( key ).RepairTime - ( Global.startTimeGame - int( data.ammunit.listRepair[key] ) ), Managers.current_ammunitions.getAmmunitionByGlobalID( key ) );
			}
			
			for ( key in data.ammunit.listProduction ){       
				CreateAmmo( Managers.ammunitions.getAmmunitionByGlobalID( key ).CreateTime - ( Global.startTimeGame - int( data.ammunit.listProduction[key] ) ), Managers.ammunitions.getAmmunitionByGlobalID( key ) );					
			}
			
		}
		
		private function FillPotion( data:Object ):void{
			m_potions = new Object( );
			
			for(var i:int = 1; i <= 1000; i++){
				var potion:basePotion = Managers.potions.getPotionByGlobalID( i.toString() );
				if (potion) m_potions[ potion.GlobalID ] = 0;
			}
			
			if ( data ){
			
				var key:*;
				
				if ( data.list )
					for( key in data.list ){
						m_potions[ key ] = int( data.list[key] );
					}
			
				if ( data.use_list )
					for( key in data.use_list ){
						ApplyPotion( Managers.potions.getPotionByGlobalID( key ).Time - ( Global.startTimeGame - int( data.use_list[key] ) ) , key );
					}
				
				if ( data.create_list )
					for( key in data.create_list ){
						CreatePotion( Managers.potions.getPotionByGlobalID( key ).Time - ( Global.startTimeGame - int( data.create_list[key] ) ), Managers.potions.getPotionByGlobalID( key ) );
					}
			
			}
		}
		
		private function FillTrophy( data:Object ):void{
			m_trophies = new Object();
			
			for(var i:int = 1; i <= Managers.trophy.Length; i++){
				m_trophies[i] = 0;
			}
			
			if ( data ){
				for( var key:* in data ) m_trophies[ key ] = int( data[key] );
			}
		}
		
		private function FillArtifact( data:Object ):void{
			m_artifact = new Object();
			for( var i:int = 1; i <= 21; i++ ) m_artifact[ i ] = 0;
		}
		
		private var t_incrementHealth:Number = 0;
		private var t_incrementHonor:Number = 0;
		private var t_potion:basePotion;
		
		private function onIncreaseStata( e:TimerEvent ):void{
			t_incrementHonor = 0;
			t_incrementHealth = 0;
			for each ( t_potion in this.m_turnPotion ){
				if( t_potion.Give[TypeConsumed.HEALTH.Value]>0 )
					t_incrementHealth=(m_healthIncrease/100)*t_potion.Give[TypeConsumed.HEALTH.Value];
				if( t_potion.Give[TypeConsumed.HONOR.Value]>0 )
					t_incrementHonor=(m_honorIncrease/100)*t_potion.Give[TypeConsumed.HONOR.Value];
			}
			
			m_health += m_healthIncrease+t_incrementHealth;
			m_honor += m_honorIncrease+t_incrementHonor;
			
			if ( m_health + m_healthIncrease > MAX_HEALTH ) m_health = MAX_HEALTH;
			if ( m_honor + m_honorIncrease > MAX_HONOR ) m_honor = MAX_HONOR;
			
			GeneralDispatcher.DispatchEvent( UpdateEvent );
		}
		
		public function StartIncrease( ):void{
			m_timerStata.addEventListener( TimerEvent.TIMER, onIncreaseStata );
			m_timerStata.start( );
		}
		
		public function StopIncrease( ):void{
			m_timerStata.stop( );
			m_timerStata.removeEventListener( TimerEvent.TIMER, onIncreaseStata );
		}
		
		private function parseLocal( data:Object ):void{
			
		}
		
		private function parseOnline( data:Object ):void{
			
		}
		
		
		CALLBACK function onFailedInit( error:Object ):void{
			trace(  "response error" + JSON.stringify( error )  );
		}
		
		//хранит глобальный id покупки аммуниции
		private var m_idAmmunit:String;
		public function BuyAmmunit( idAmmunit:String ):void{
			m_idAmmunit = idAmmunit;
			
			if ( Managers.current_ammunitions.getAmmunitionByGlobalID( m_idAmmunit ) == null)			
			Global.Server.BuyAmmunition( InternalID , int(idAmmunit) , CALLBACK::BuyAmmunitionGood , CALLBACK::BuyAmmunitionBad );
		}
		
		CALLBACK function BuyAmmunitionGood( response:* ):void{
			trace("Покупка удалась - ", response );
			
			Managers.current_ammunitions.addAmmunitionByGlobalID( m_idAmmunit );
		}
		
		CALLBACK function BuyAmmunitionBad( response:* ):void{
			trace("Покупка НЕ удалась -", response);
			
		}
		
		private var m_curPotion:basePotion;
		public function BuyPotion ( idPotion:String ):void{
			m_curPotion = Managers.potions.getPotionByGlobalID( idPotion );
			if ( m_curPotion != null)			
				Global.Server.BuyPotion( InternalID , int(idPotion) , CALLBACK::BuyPotionGood , CALLBACK::BuyPotionBad );
		}
		
		CALLBACK function BuyPotionGood( response:* ):void{
			trace("Покупка удалась - ", response );
			m_potions[m_curPotion.GlobalID] += 1;
		}
		
		CALLBACK function BuyPotionBad( response:* ):void{
			trace("Покупка НЕ удалась -", response);
			
		}
		
		private var m_curTrophy:baseTrophy;
		public function addTrophy( idTrophy:String ):void{
			m_curTrophy = Managers.trophy.getTrophyByGlobalID( idTrophy );
			
			if ( m_curTrophy != null)
				Global.Server.addTrophy( InternalID , m_curTrophy.GlobalID, CALLBACK::BuyTrophyGood , CALLBACK::BuyTrophyBad );
		}
		
		CALLBACK function BuyTrophyGood( response:* ):void{
			trace("Покупка удалась - ", response );
			m_trophies[m_curTrophy.GlobalID] += 1; 
			
		}
		
		CALLBACK function BuyTrophyBad( response:* ):void{
			trace("Покупка НЕ удалась -", response);
			
		}
		
		//Clans
		public function CreateClan( name:String ):void{
			Global.Server.CreateClan( InternalID, name, CALLBACK::CreateClanGood, CALLBACK::CreateClanBad  );
		}
		
		CALLBACK function CreateClanGood( response:Object ):void{
			m_clanId = uint( response.idClan );
			subConsumed( TypeConsumed.GOLD_COIN, response.gold_coin ); 
			trace( 'Вступили в клан id = ',response.idClan, ', золота потрачено - ', response.gold_coin );
		}
		
		CALLBACK function CreateClanBad( response:Object ):void{
			trace('Не удалось вступить в клан');
		}
		
		public function KillClan( idClan:String ):void{
			
			if ( m_clanId == uint(idClan) )
				Global.Server.KillClan( InternalID, m_clanId, CALLBACK::KillClanGood, CALLBACK::KillClanBad );
		}
		
		CALLBACK function KillClanGood( response:Object ):void{
			trace('Клан уничтожен');
		}
		
		CALLBACK function KillClanBad( response:Object ):void{
			trace('Не удалось уничтожить клан');
		}
		
		public function JoinClan( idClan:String ):void{
			Global.Server.JoinClan( InternalID, int( idClan ), CALLBACK::JoinClanGood, CALLBACK::JoinClanBad ); 
		}
		
		CALLBACK function JoinClanGood( response:Object ):void{
			trace('Успешно вступили в клан');
		}
		
		CALLBACK function JoinClanBad( response:Object ):void{
			trace('Не удалось вступить в клан');
		}
		
		public function ExitClan( idClan:String ):void{
			Global.Server.ExitKlan( InternalID, int( idClan ), CALLBACK::ExitClanGood, CALLBACK::ExitClanBad ); 
		}
		
		CALLBACK function ExitClanGood( response:Object ):void{
			trace('Успешно вышли из клана');
		}
		
		CALLBACK function ExitClanBad( response:Object ):void{
			trace('Не удалось выйти из клана');
		}
		//End
		
		/**
		 * применить зелье
		 */
		public function ApplyPotion( time:Number , idPotion:int ):void{
			if ( time > 0 ){
				var p:basePotion = Managers.potions.getPotionByGlobalID( idPotion.toString() );
				if( p == null ) return;
				var tp:TaskPotion = new TaskPotion( time , p ); 
				tp.onComplete = onCompletePotion;
				this.m_turnPotion.push( p );
				Global.Tasks.addTask( tp );
			
				setPotion( idPotion, -1 );
			}
		}
		
		private function onCompletePotion( _potion:TaskPotion ):void{
			var index:int = this.m_turnPotion.indexOf( _potion.Potion );
			if (index >-1){
				this.m_turnPotion.splice( index, 1 );
			}
		}
		
		//Поставить аммуницию в очередь на изготовление
		public function CreateAmmo( time:Number, ammo:baseAmmunition ):void{
			
			ammo.onCreate = true;
			
			trace('id = ',ammo.globalID,'; time =  ', time);
			
			if ( time < 0 && !m_ammoOnCreate.length ){
				m_ammoOnCreate.push( new ItmAmmoCreate( ammo , 0 ) );
				var notice:baseNotice = new baseNotice( Global.Root, { type:TypeNotice.AMMO_COMPLETE.Value, id:ammo.globalID, msg:"Аммуниция готова "+ammo.Name } );
				Global.Notice.addNotice( notice );
			}
			else{
				
				if ( !m_ammoOnCreate.length && m_taskAmmo == null ){
					var tp:TaskAmmo = new TaskAmmo( time - 1 , ammo ); 
					tp.onComplete = onCompleteCreateAmmo;
					tp.onUpdate = updateAmmoOnCreate;
					Global.Tasks.addTask( tp );
					
					m_taskAmmo = tp;
					
					m_ammoOnCreate.push( new ItmAmmoCreate( ammo , time - 1 ) );
				}
				else{
					m_ammoOnCreate.push( new ItmAmmoCreate( ammo , ammo.RepairTime ) );
				}
			}
			
		}
		
		public function ForceEndCreateAmmo( ammo:baseAmmunition ):void{
			Global.Tasks.removeTask( m_taskAmmo ,true);
			updateAmmoOnCreate( 0 );
		}
		
		private function onCompleteCreateAmmo( _ammo:TaskAmmo ):void{
			if ( m_ammoOnCreate.length ) m_ammoOnCreate[0].m_time = 0;
			
			Global.Tasks.removeTask( m_taskAmmo );
			
			m_taskAmmo = null;
			
			var notice:baseNotice = new baseNotice( Global.Root, { type:TypeNotice.AMMO_COMPLETE.Value, id:_ammo.Ammo.globalID, msg:"Аммуниция готова "+_ammo.Ammo.Name } );
			Global.Notice.addNotice( notice );
		}
		
		public function subAmmoOnCreate( ammo:baseAmmunition ):void{
			ammo.onCreate = false;
			
			m_ammoOnCreate.shift();
			
			if ( m_ammoOnCreate.length ){
				m_ammoOnCreate[0].m_time -= 1;
				var tp:TaskAmmo = new TaskAmmo( m_ammoOnCreate[0].m_time, m_ammoOnCreate[0].m_ammunition ); 
				tp.onComplete = onCompleteCreateAmmo;
				tp.onUpdate = updateAmmoOnCreate;
				Global.Tasks.addTask( tp );
				
				m_taskAmmo = tp;
			}
			
		}
		
		public function updateAmmoOnCreate( time:Number ):void{
			m_ammoOnCreate[0].m_time = time;
		}
		
		public function get AmmoOnCreate():Vector.<ItmAmmoCreate>{
			return m_ammoOnCreate;
		}
		//------------------------------
		
		//Поставить аммуницию в очередь на ремонт
		public function RepairAmmo( time:Number, ammo:Ammunition ):void{
			
			ammo.Repair = true;
			
			if ( time < 0 && !m_ammoOnRepair.length ){
				m_ammoOnRepair.push( new ItmAmmoRepair( ammo , 0 ) );
				var notice:baseNotice = new baseNotice( Global.Root, { type:TypeNotice.REPAIR_COMPLETE.Value, id:ammo.BaseAmmunition.globalID, msg:"Аммуниция отремонтирована "+ammo.BaseAmmunition.Name } );
				Global.Notice.addNotice( notice );
			}
			else{
				
				if ( !m_ammoOnRepair.length && m_taskRepair == null ){
					var tp:TaskRepair = new TaskRepair( time - 1 , ammo ); 
					tp.onComplete = onCompleteRepairAmmo;
					tp.onUpdate = updateAmmoOnRepair;
					Global.Tasks.addTask( tp );
					
					m_taskRepair = tp;
					
					m_ammoOnRepair.push( new ItmAmmoRepair( ammo , time - 1 ) );
				}
				else{
					m_ammoOnRepair.push( new ItmAmmoRepair( ammo , ammo.BaseAmmunition.RepairTime ) );
				}
			}
			
		}
		
		public function ForceEndRepairAmmo( ammo:Ammunition ):void{
			Global.Tasks.removeTask( m_taskRepair ,true);
			updateAmmoOnRepair( 0 );
		}
		
		private function onCompleteRepairAmmo( _ammo:TaskRepair ):void{
			if ( m_ammoOnRepair.length ) m_ammoOnRepair[0].m_time = 0;
			
			Global.Tasks.removeTask( m_taskRepair );
			
			m_taskRepair = null;
			
			var notice:baseNotice = new baseNotice( Global.Root, { type:TypeNotice.REPAIR_COMPLETE.Value, id:_ammo.Ammo.BaseAmmunition.globalID, msg:"Аммуниция отремонтирована "+_ammo.Ammo.BaseAmmunition.Name } );
			Global.Notice.addNotice( notice );
		}
		
		public function subAmmoOnRepair( ammo:Ammunition ):void{
			
			m_ammoOnRepair.shift();
			
			if ( m_ammoOnRepair.length ){
				m_ammoOnRepair[0].m_time -= 1;
				var tp:TaskRepair = new TaskRepair( m_ammoOnRepair[0].m_time, m_ammoOnRepair[0].m_ammunition ); 
				tp.onComplete = onCompleteRepairAmmo;
				tp.onUpdate = updateAmmoOnRepair;
				Global.Tasks.addTask( tp );
				
				m_taskRepair = tp;
			}
			
		}
		
		public function updateAmmoOnRepair( time:Number ):void{
			m_ammoOnRepair[0].m_time = time;
		}
		
		public function get AmmoOnRepair():Vector.<ItmAmmoRepair>{
			return m_ammoOnRepair;
		}
		//------------------------------
		
		//Поставить зелье в очередь на изготовление
		public function CreatePotion( time:Number, potion:basePotion ):void{
			
			if ( time < 0 && !m_potionsCreate.length ){
				m_potionsCreate.push( new ItmPotionCreate( potion , 0 ) );
				var notice:baseNotice = new baseNotice( Global.Root, { type:TypeNotice.POTION_COMPLETE.Value, id:potion.GlobalID, msg:"Готово зелье "+potion.Name } );
				Global.Notice.addNotice( notice );
			}
			else{
				
				if ( !m_potionsCreate.length && m_taskPotion == null ){
					var tp:TaskPotion = new TaskPotion( time - 1 , potion ); 
					tp.onComplete = onCompleteCreatePotion;
					tp.onUpdate = updatePotionInCreate;
					Global.Tasks.addTask( tp );
					
					m_taskPotion = tp;
					
					m_potionsCreate.push( new ItmPotionCreate( potion , time - 1 ) );
				}
				else{
					m_potionsCreate.push( new ItmPotionCreate( potion , potion.Time ) );
				}
			}
			
		}
		
		public function ForceEndCreatePotion( potion:basePotion ):void{
			Global.Tasks.removeTask( m_taskPotion ,true);
			updatePotionInCreate( 0 );
		}
		
		private function onCompleteCreatePotion( _potion:TaskPotion ):void{
			if ( m_potionsCreate.length ) m_potionsCreate[0].m_time = 0;
			
			Global.Tasks.removeTask( m_taskPotion );
			
			m_taskPotion = null;
			
			var notice:baseNotice = new baseNotice( Global.Root, { type:TypeNotice.POTION_COMPLETE.Value, id:_potion.Potion.GlobalID, msg:"Готово зелье "+_potion.Potion.Name } );
			Global.Notice.addNotice( notice );
		}
		
		public function subPotionInCreate( potion:basePotion ):void{
			setPotion( potion.GlobalID, 1 );
			m_potionsCreate.shift();
			
			if ( m_potionsCreate.length ){
				m_potionsCreate[0].m_time -= 1;
				var tp:TaskPotion = new TaskPotion( m_potionsCreate[0].m_time, m_potionsCreate[0].m_potion ); 
				tp.onComplete = onCompleteCreatePotion;
				tp.onUpdate = updatePotionInCreate;
				Global.Tasks.addTask( tp );
				
				m_taskPotion = tp;
			}
				
		}
				
		public function updatePotionInCreate( time:Number ):void{
			m_potionsCreate[0].m_time = time;
		}
		
		public function get PotionInCreate():Vector.<ItmPotionCreate>{
			return m_potionsCreate;
		}
		
		/**
		 * узнать сколько единиц данного ресурса у игрока
		 */
		public function getConsumed( type:TypeConsumed ):int{
			try{
				return m_consumed[ type.Value ];
			}
			catch(err:Error) {  }
			
			return 0;
		}
				
		
		public function addConsumed( type:TypeConsumed , value:int ):void{
			m_consumed[ type.Value ]+=value;
			Managers.sounds.PlaySound( "getCoin" );
			GeneralDispatcher.DispatchEvent( UpdateEvent );
		}
		
		public function getPotion( globalID:int ):int{
			return m_potions[ globalID ];		
		}
		
		public function setPotion( globalID:int, value:int ):void{
			m_potions[ globalID ] += value;
			
			if ( m_potions[ globalID ] < 0 ) m_potions[ globalID ] = 0;
		}
		
		public function getTrophy( globalID:int ):int{
			return m_trophies[ globalID ];
		}
		
		public function setTrophy( globalID:int, value:int ):void{
			m_trophies[ globalID ] += value;
			
			if ( m_trophies[ globalID ] < 0 ) m_trophies[ globalID ] = 0;
		}
		
		public function getArtifact( globalID:int ):int{
			return m_artifact[ globalID ];		
		}
		
		public function setArtifact( globalID:int, value:int ):void{
			m_artifact[ globalID ] += value;
			
			if ( m_artifact[ globalID ] < 0 ) m_artifact[ globalID ] = 0;
		}
		
		public function getGarden( ):Object{
			return m_garden;
		}
		
		public function setGarden( type:TypeConsumed ):void{
			
			delete m_garden[ type.Value ];
		}
		
		/**
		 * вычитаем ресурс из запасников 
		 * @param type - тип ресурса
		 * @param value - количество
		 * @param force - проталкивать ли уменьшение, если force то ресурс может в количестве стать отрицательным 
		 * не знаю пока для чего / может для кармы или популярности
		 * @return 
		 * 
		 */		

		public function subConsumed( type:TypeConsumed , value:int , force:Boolean = false ):Boolean{ //trace( "CCCC  "+ type.Value +  JSON.stringify(m_consumed) );
			if( m_consumed[ type.Value ]<value  && force!=true ){ return false;}
			Managers.sounds.PlaySound( "getCoin" );
			m_consumed[ type.Value ]-= value;
			GeneralDispatcher.DispatchEvent( UpdateEvent );
			return true;
		}
		
		public function get InternalID( ):String{
			return m_internalID;
		}
		
		public function get SocID( ):String{
			return m_soc_uid;
		}
		
		public function get Name( ):String{
			return m_name;
		}
		
		public function get Level( ):int{
			return m_level;
		}
		
		public function get Clan( ):int{
			return m_clan;
		}
		
		public function get Health():Number{
			return m_health;
		}
		
		public function get Honor():Number{
			return m_honor;
		}
		
		public function get Exp():Number{
			return m_exp;
		}
		
		public function get Luck():Number{
			return m_luck;
		}
		
		public function get Agility():int{
			return m_agility;
		}
		
		public function get GardenTime():int{
			return m_gardenTime;
		}
		
		public function get GardenRefresh():int{
			return m_gardenRefresh;
		}
		
		public function set GardenTime( value:int ):void{
			m_gardenTime = value;
		}
		
		public function set Level( value:int ):void{
			m_level = value;
		}
		
		public function set Health( value:Number ):void{
			m_health = value;
			
			GeneralDispatcher.DispatchEvent( UpdateEvent );
		}
		
		public function set Honor( value:Number ):void{
			m_honor = value;
			
			GeneralDispatcher.DispatchEvent( UpdateEvent );
		}
		
		public function set Exp( value:Number ):void{
			m_exp = value;
			
			GeneralDispatcher.DispatchEvent( UpdateEvent );
		}
		
		/**
		 * количесво друзей  игрока, необходимо для вычисления урона от отряда
		 */
		public function get CountFriends():int{
			return this.m_countFriends;
		}

	}
}


import game.gameplay.alchemy.basePotion;
class ItmPotionCreate{
	
	public var m_potion:basePotion;
	public var m_time:Number;
	
	public function ItmPotionCreate( potion:basePotion, time:Number ):void{
		m_potion = potion;
		m_time = time;
	}
	
}

import game.gameplay.ammunition.Ammunition;
class ItmAmmoRepair{
	
	public var m_ammunition:Ammunition;
	public var m_time:Number;
	
	public function ItmAmmoRepair( ammo:Ammunition, time:Number ):void{
		m_ammunition = ammo;
		m_time = time;
	}
	
}

import game.gameplay.ammunition.baseAmmunition;
class ItmAmmoCreate{
	
	public var m_ammunition:baseAmmunition;
	public var m_time:Number;
	
	public function ItmAmmoCreate( ammo:baseAmmunition, time:Number ):void{
		m_ammunition = ammo;
		m_time = time;
	}
	
}