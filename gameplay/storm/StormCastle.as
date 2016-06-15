package game.gameplay.storm
{
	import com.junkbyte.console.Cc;
	
	import core.task.ITask;
	
	import flash.utils.getTimer;
	
	import game.Global;
	import game.Managers.Managers;
	import game.display.FriendBar.PnlFriendBar;
	import game.display.storming.baseCastle;

	/**
	 * состояния штурма замка 
	 * @author volk
	 * 
	 */	
	public class StormCastle implements ITask
	{
		
		private static var m_listCastle:Vector.<StormCastle> = new Vector.<StormCastle>( );
		
		/**
		 * скорость восстановления энергии отряда на атаку 
		 */		
		public static const  SPEED_RECOVERY_SQUARD:uint = 1;
		
		/**
		 * максимальный уровень энергии отряда , который расходуется на атаки 
		 */
		public static const MAX_POWER_SQUARD:uint = 1500;
		
		/**
		 * энергия отъедаемая отрядом при атаке из своей шкалы MAX_POWER_SQUARD
		 */
		public static const POWER_ATTACK_SQUAD:int = 300;
		
		private var m_damage_attack_squard:int = 0;
		
		private var m_idCastle:int;
		
		/**
		 * энергия для атаки , накапливаемая отрядом при штурме замка
		 */		
		private var m_powerAttackSquad:int = 1500;
		
		private var m_listSiege:Vector.<infoSiege> = new Vector.<infoSiege>();
		
		/**
		 * прочность замка
		 */
		private var m_strength:int = 5000;
		
		private var m_listenerChange:Vector.<IChangeStormCastle>;
		
		/**
		 * время штурма
		 */
		private var m_currentTimeStorm:int = 0;
		
		//damage от осадных орудий
		private var m_damage:int = 0;
		
		/**
		 * дамаг , который наносится одним  другом в отряде
		 */
		private var m_damageOneFriends:int = 0;
		
		
		/**
		 * время выделенное на штурм замка
		 */
		private var m_TimeStorm:int = 0;
		
		
		//"storm":{"1":{"siege":null,"attack":{"time":0,"power":1500},"startStorm":0,"score":"350","damageOne":"10","winner":false},"2":{"siege":null,"attack":{"time":0,"power":1500},"startStorm":0,"score":"5000","damageOne":"10","winner":false}},
		public function StormCastle( idCastle:int , data:Object = null )
		{
			
			if( StormCastle.m_listCastle.length > 0 ){
				trace( 'ШТУРМ МОЖЕТ БЫТЬ ТОЛЬКО ОДИН !!! ');
				 Cc.log( 'ШТУРМ МОЖЕТ БЫТЬ ТОЛЬКО ОДИН !!! ' );
			}
			m_idCastle = idCastle;
			
			var castle:baseCastle = Managers.castle.getCastleByGlobalID( String( m_idCastle ) );
			m_damageOneFriends = castle.DamageOne;
			m_damage_attack_squard = (Global.player.CountFriends+1)*m_damageOneFriends;
			m_strength = castle.Strength;
			m_TimeStorm = castle.TimeStorm;
			
			if ( data ){

				m_damageOneFriends = data.damageOne;
				m_strength = data.score;
				m_powerAttackSquad = Math.min( MAX_POWER_SQUARD, int( data.attack.power ) + ( Global.startTimeGame - int( data.attack.time ) + Math.floor( getTimer() / 1000 ) ) );
				m_currentTimeStorm = Global.startTimeGame - int( data.startStorm ) + Math.floor( getTimer() / 1000 );
				if ( data.siege )			
					for ( var key:* in data.siege ){
						BuildSiege( int(key), int( data.siege[key] ) );
					}
				
			}
			
			m_listenerChange = new Vector.<IChangeStormCastle>( );
			StormCastle.m_listCastle.push( this );
			
		}
		
		public function Connect( ichange:IChangeStormCastle ):Boolean{
		    var index:int = m_listenerChange.indexOf( ichange );
			if( index!=-1 ) return false;
			this.m_listenerChange.push( ichange );
			return true;
		}
		
		public function Disconnect( ichange:IChangeStormCastle ):void{
			var index:int = m_listenerChange.indexOf( ichange );
			if( index!=-1 ) {
				this.m_listenerChange.splice( index, 1 );
			}
		}
		
		/**
		 * атака отрядом 
		 * 
		 */		
		private var iter:IChangeStormCastle;
		public function addAttackSquad( ):void{ 
			
			if( this.m_powerAttackSquad >= StormCastle.POWER_ATTACK_SQUAD ){
				//энергия , отъедаемая атакой
				m_powerAttackSquad -= StormCastle.POWER_ATTACK_SQUAD;
				m_strength -=  this.DamageSquard;   //m_damageOneFriends * Global.player.CountFriends - m_damageOneFriends;   //StormCastle.POWER_ATTACK_SQUAD;
				
				for each( iter in this.m_listenerChange ){
					iter.Change( this );
				}
			}
		}		
		
		/**
		 * постройка осадного орудия
		 */
		public function BuildSiege( id:int, time:int = 0 ):void{
			
			var obj:Object = {"id":id, "time":time };
			if( getInfoSiege( id ) == null ){
				var inf:infoSiege = new infoSiege( this , obj );
				m_listSiege.push( inf );
			}
		}
		
		public function getInfoSiege( id:int ):infoSiege{
			var it:infoSiege;
			for each ( it in m_listSiege ){
				if( it.ID == id  )return it;
			}
			return null;
		}
		
		public function onCompleteSiege( info:infoSiege ):void{
			var index:int = m_listSiege.indexOf( info );
			if ( index!= -1 ){
				m_listSiege.splice( index , 1 );
				m_strength-= info.siegeWeapon.Damage;
			}
			
		}
		
		//set-get
		public function get ID( ):int{
			return m_idCastle;
		}
		
		public function get Strength():int{			
			return m_strength - m_damage;
		}
		
		public function get CurrentTimeStorm():int{
			return this.m_currentTimeStorm;
		}
		
		public function get LeastTimeStorm():int{
			return this.m_TimeStorm - this.m_currentTimeStorm;
		}
		
		/**
		 * Урон, который нанесет отряд 
		 * @return 
		 */		
		public function get DamageSquard():int{
			return m_damage_attack_squard;
		}
		
		/**
		 * накопленная энергия отрядом
		 */
		public function get PowerSquad( ):int{
			return this.m_powerAttackSquad;
		}
		
		public function Start( ):void{
						
		}
		
		public function Update( time:Number ):void{
			
			m_damage = 0;
			for each (var t_iter:infoSiege in m_listSiege ){
				t_iter.Update( time );
				m_damage += t_iter.ItogoDamage;
			}
			
			if( m_powerAttackSquad< StormCastle.MAX_POWER_SQUARD ){
				m_powerAttackSquad += StormCastle.SPEED_RECOVERY_SQUARD;
			}
			
			for each( iter in this.m_listenerChange ){
				iter.Change( this );
			}
			
			m_currentTimeStorm++;
			
			if( this.Strength <= 0 ){
				Global.Tasks.removeTask( this , true );
				var index:int = -1;
				index = StormCastle.m_listCastle.indexOf( this );
				if( index!= -1 ){
					StormCastle.m_listCastle.splice( index, 1 );
				}
			}
			
		}
		
		/**
		 * по сути если таск завершился сам то штурм по идее не удался
		 */
		public function End( ):void{
			var index:int = -1;
			index = StormCastle.m_listCastle.indexOf( this );
			if( index!= -1 ){
				StormCastle.m_listCastle.splice( index, 1 );
			}
			
		}
		
		
		public function forceEnd( ):void{
		
		}
		
		/**
		 * достать штурм замка
		 */
		public static function getStormCastleForID( id:int ):StormCastle{
			var t:StormCastle;
			for each( t in StormCastle.m_listCastle  ){
				if( t.ID == id ){
					return t;
				}
			}
			return null;
		}
		
		public static function isStorm( ):Boolean{
			if( StormCastle.m_listCastle.length>0 ) return true; 
			return false;
			//return StormCastle.m_listCastle.length>0?true:false;
		}
		
		/**
		 * костыль предполагает , что штурмов всегда один в единицу времени
		 */
		public static function getIDCastleStorm( ):int{
			return StormCastle.m_listCastle[0].ID;
		}
	}
}