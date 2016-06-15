package game.display.Screens
{
	import core.gui.button.filterButton;
	import core.utils.Rnd;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.sensors.Accelerometer;
	import flash.text.TextField;
	
	import game.Global;
	import game.Managers.Managers;
	import game.assets.Assets;
	import game.display.Lobby.ProgressPnlTop;
	import game.display.villageList.InfoPlayerItm;
	import game.gameplay.ammunition.Ammunition;
	import game.gameplay.ammunition.TypeAmmunition;
	
	import mx.core.MovieClipAsset;

	public class ScreenArena extends baseScreen
	{
		[Embed(source="../../../../ResourcesGame/game/Screens/arena/arena.jpg")]   
		public static const arenaBack:Class
		
		//анимация игрока
		[Embed(source="../../../../ResourcesGame/game/Screens/arena/animations/player/player_animation.swf", symbol="knight")]
		private static var player_animation:Class;
		//------------------------
		
		//анимация соперника
		[Embed(source="../../../../ResourcesGame/game/Screens/arena/animations/enemy/enemy_animation.swf", symbol="knight")]
		private static var enemy_animation:Class;
		//------------------------
		
		[Embed(source="../../../../ResourcesGame/game/Screens/arena/pointer_arrow_attack.png")]   
		public static const pointer_arrow_attack:Class
		
		private var m_player:MovieClip;
		private var m_enemy:MovieClip;
		
		private var m_btn_attack_head:filterButton;
		private var m_btn_attack_top:filterButton;
		private var m_btn_attack_feet:filterButton;
		private var m_attack_btns:Sprite = new Sprite( );
		
		private var m_btn_block_head:filterButton;
		private var m_btn_block_top:filterButton;
		private var m_btn_block_feet:filterButton;
		private var m_block_btns:Sprite = new Sprite( );
		
		private var m_playerAttak:Boolean = true;
		
		private var m_playerIsPlaying:Boolean = false;
		
		private var m_enemyIsPlaying:Boolean = false;
		
		private var m_playerAction:uint = 0;
		
		private var m_enemyAction:uint = 0;
		
		private var m_difficult_head:uint = 80; //сложность паопадания в голову в процентах от 0 до 100
		private var m_difficult_top:uint = 50; //сложность паопадания в торс в процентах от 0 до 100
		private var m_difficult_feet:uint = 30; //сложность паопадания в ноги в процентах от 0 до 100
		
		private var m_iBack:Bitmap;
		
		private var m_playerPos:Point = new Point( 350, 300 );
		private var m_enemyPos:Point = new Point( 350, 300 );
		
		
		//стата игрока
		private var m_playerHealth:int = 0;
		private var m_playerHonor:int = 0;
		private var m_playerLuck:Number = 0; //наверно от 0 до 1 будет
		private var m_playerAgility:int  = 0;
		private var m_playerDressAmmunition:Object = new Object();
		
		//визуальная часть игрока
		private var m_playerStata:InfoPlayerItm;
		
		//стата противника
		private var m_enemyHealth:int = 0;
		private var m_enemyHonor:int = 0;
		private var m_enemyDressAmmunition:Object = new Object();
		
		//визуальная часть противника
		private var m_enemyStata:InfoPlayerItm;
		private var m_enemyHealthStata:ProgressPnlTop;
		private var m_enemyHonorStata:ProgressPnlTop;
		
		private var m_watch:Watch;
		
		public function ScreenArena( enemyData:Object = null)
		{
			this.m_internalName = "ScreenArena";
			m_iBack = new arenaBack( ) as Bitmap;
			addChild( m_iBack );
			
			m_player = new player_animation();
			m_player.gotoAndStop( "idle" );
			m_player.x = m_playerPos.x;
			m_player.y = m_playerPos.y;
			addChild( m_player );
			
			m_enemy = new enemy_animation();
			m_enemy.gotoAndStop( "idle" );
			m_enemy.x = m_enemyPos.x;
			m_enemy.y = m_enemyPos.y;
			addChild( m_enemy );
			
			m_btn_attack_head = new filterButton( new pointer_arrow_attack() as Bitmap ); m_attack_btns.addChild( m_btn_attack_head );
			m_btn_attack_top = new filterButton( new pointer_arrow_attack() as Bitmap ); m_attack_btns.addChild( m_btn_attack_top );
			m_btn_attack_feet = new filterButton( new pointer_arrow_attack() as Bitmap ); m_attack_btns.addChild( m_btn_attack_feet );
			
			m_btn_attack_head.x = 0; m_btn_attack_head.y = -20;
			m_btn_attack_top.x = 0; m_btn_attack_top.y = 30;
			m_btn_attack_feet.x = 0; m_btn_attack_feet.y = 120;
			
			m_btn_attack_head.Click = AttackHead;
			m_btn_attack_top.Click = AttackTop;
			m_btn_attack_feet.Click = AttackFeet;
			
			m_attack_btns.x = 350; m_attack_btns.y = m_iBack.height / 2;
				
			addChild( m_attack_btns );
			
			Global.player.StopIncrease( );
			
			if ( enemyData == null ) Global.Server.FindEnemy( Global.player.InternalID, onFillEnemyGood, onFillEnemyBad );
			else onFillEnemyGood( enemyData );
			
			FillPlayer();
			
			m_watch = new Watch( RandomPlayerAttack );
			m_watch.x = 20;
			m_watch.y = 440;
			addChild( m_watch );
		}
		
		private function FillPlayer( ):void{
			m_playerHealth = Global.player.Health;
			m_playerHonor = Global.player.Honor;
			m_playerLuck = Global.player.Luck;
			m_playerAgility = Global.player.Agility;
			m_playerDressAmmunition = Managers.current_ammunitions.getDressed();
			
			m_playerStata = new InfoPlayerItm( String( Global.player.Level ), String( Global.player.Clan ), Global.player.SocID );
			addChild( m_playerStata );
		}
		
		private function onFillEnemyGood( response:Object ):void{
			trace('TEST0');
			m_enemyHealth = int( response['health'] );
			m_enemyHonor = int( response['honor'] );
			
			m_enemyDressAmmunition = new Object();
			for ( var key:* in response.ammunit.listDress ){
				m_enemyDressAmmunition[ key ] = Managers.current_ammunitions.getAmmunitionByGlobalID( response.ammunit.listDress[key] );
			}
			
			m_enemyHealthStata = new ProgressPnlTop(  Assets.getBitmap('emptyhealth_bar'), Assets.getBitmap('health_bar'), Assets.getBitmap( "ico_heart" ) );
			m_enemyHonorStata = new ProgressPnlTop(  Assets.getBitmap('emptyspirit_bar'), Assets.getBitmap('spirit_bar'), Assets.getBitmap( "ico_flag" ) );
			
			addChild( m_enemyHealthStata );
			addChild( m_enemyHonorStata );
			
			m_enemyHealthStata.Max = 1500;
			m_enemyHealthStata.Value = m_enemyHealth;
			
			m_enemyHonorStata.Max = 1500;
			m_enemyHonorStata.Value = m_enemyHonor;
			
			m_enemyHealthStata.x = 380;
			m_enemyHealthStata.y = 5;
			
			m_enemyHonorStata.x = 380;
			m_enemyHonorStata.y = 30;
			
			m_enemyStata = new InfoPlayerItm( response['level'], response['clan'], response['internalID'] );
			m_enemyStata.x = 570;
			addChild( m_enemyStata );
			
			nextStep( );
		}
		
		private function onFillEnemyBad( response:Object ):void{
			trace('Не удалось загрузить противника');
		}
		
		private function RandomPlayerAttack( ):void{
			switch (Rnd.integer(1,3)){
				case 1: AttackHead(); break;
				case 2: AttackTop(); break;
				case 3: AttackFeet(); break;
			}
		}
		
		private function nextStep( ):void{
			if ( m_playerAttak ) {
				m_attack_btns.visible = true;
				m_watch.StartWatch();
			}
			else{
				
				m_attack_btns.visible = false;
				
				m_enemyAction = RandomEnemyAttak( );
				
				m_playerAction = RandomPlayerBlock( );
				
				CalculateDamage( );
				
				PlayAnimation( );
			}
		}
		
		private function AttackTop():void
		{
			m_watch.StopWatch();
			m_attack_btns.visible = false;
			
			m_playerAction = Action.ATTAK_TOP;
			
			m_enemyAction = RandomEnemyBlock( );
			
			CalculateDamage( );
			
			PlayAnimation( );
		}
		
		private function AttackHead():void
		{
			m_watch.StopWatch();
			m_attack_btns.visible = false;
			
			m_playerAction = Action.ATTAK_HEAD;
			
			m_enemyAction = RandomEnemyBlock( );
			
			CalculateDamage( );
			
			PlayAnimation( );
		}
		
		private function AttackFeet():void
		{
			m_watch.StopWatch();
			m_attack_btns.visible = false;
			
			m_playerAction = Action.ATTAK_FEET;
			
			m_enemyAction = RandomEnemyBlock( );
			
			CalculateDamage( );
			
			PlayAnimation( );
		}
				
		private function RandomEnemyAttak( ):uint{
			
			var rndAttak:int = Rnd.integer( 0, 100 );
			
			if ( rndAttak > m_difficult_head ) return Action.ATTAK_HEAD;
			else if
				( rndAttak > m_difficult_top ) return Action.ATTAK_TOP;
			else return Action.ATTAK_FEET;
		}
		
		private function RandomEnemyBlock( ):uint{
			
			var min:int = 50;
			
			min -= Math.round( m_playerLuck * 50 );
			min -= m_playerAgility;
				
			var rndBlock:int = Rnd.integer( min, 150 - min ) ;
			
			var difficult:uint;
			
			switch ( m_playerAction ){
				case Action.ATTAK_HEAD: difficult = 100 - m_difficult_head; break;
				case Action.ATTAK_TOP: difficult = 100 - m_difficult_top; break;
				case Action.ATTAK_FEET: difficult = 100 - m_difficult_feet; break;
			}
			
			if ( rndBlock > difficult ) return m_playerAction + 3;
			else return Action.BLOCK_NONE;
		}
		
		private function RandomPlayerBlock( ):uint{
			
			var max:int = 0;
			
			max += Math.round( m_playerLuck * 50 );
			max += m_playerAgility;
			
			var rndBlock:int = Rnd.integer( max, 50 + max ) ;
			
			var difficult:uint;
			
			switch ( m_enemyAction ){
				case Action.ATTAK_HEAD: difficult = 100 - m_difficult_head; break;
				case Action.ATTAK_TOP: difficult = 100 - m_difficult_top; break;
				case Action.ATTAK_FEET: difficult = 100 - m_difficult_feet; break;
			}
			
			if ( rndBlock > difficult ) return m_enemyAction + 3;
			else return Action.BLOCK_NONE;
			
		}
		
		/*
		private function RandomAction( ):uint{
			
			var attak:int = m_playerAttak ? 3 : -3;
			
			var difficult:int; // секущая сложность, зависит от того, куда бьём и от удачи и ловкости
			
			switch ( m_playerAction ){
				case Action.ATTAK_HEAD: difficult = m_difficult_head; break;
				case Action.ATTAK_TOP: difficult = m_difficult_top; break;
				case Action.ATTAK_FEET: difficult = m_difficult_feet; break;
				case Action.BLOCK_HEAD: difficult = 100 - m_difficult_head; break;
				case Action.BLOCK_TOP: difficult = 100 - m_difficult_top; break;
				case Action.BLOCK_FEET: difficult = 100 - m_difficult_feet; break;
			}
			
			if ( Math.ceil( Math.random() * 100 ) <= difficult ) return m_playerAction + attak;
			else{
				var attak2:uint = m_playerAttak ? 3 : 0;
				var action:uint = Math.ceil (Math.random() * 3) + attak2;
				
				while ( action == m_playerAction + attak ){
					action = Math.ceil (Math.random() * 3) + attak2;
				}
				return action;
			}
		}*/
		
		private function PlayAnimation( ):void{
			
			var playerAnima:String = getActionByType( m_playerAction );
			var enemyAnima:String = getActionByType( m_enemyAction );
						
			if  ( Math.abs( m_enemyAction -  m_playerAction ) == 3 ){ //отбил
				if ( m_playerAttak ) playerAnima = getActionByType( m_playerAction ) + "_fail";
				else enemyAnima = getActionByType( m_enemyAction ) + "_fail";
			}
			else{
				if ( m_playerAttak ) enemyAnima = getActionByType( m_playerAction + 3 ) + "_fail";
				else playerAnima = getActionByType( m_enemyAction + 3 ) + "_fail";
			}
			
			Swap( playerAnima, enemyAnima );
			
			m_player.gotoAndStop( playerAnima );
			m_enemy.gotoAndStop( enemyAnima );
			
			m_playerIsPlaying = true;
			m_enemyIsPlaying = true;
			
			addEventListener( Event.ENTER_FRAME, CheckAnimation );
		}
		
		private function CheckAnimation( event:Event ):void{
			if ( m_player.anima.totalFrames == m_player.anima.currentFrame ){
				m_player.stop();
				m_playerIsPlaying = false;
			}
			
			if ( m_enemy.anima.totalFrames == m_enemy.anima.currentFrame ){
				m_enemy.anima.stop();
				m_enemyIsPlaying = false;
			}
			
			if ( !m_enemyIsPlaying && !m_playerIsPlaying ){
				removeEventListener( Event.ENTER_FRAME, CheckAnimation );
				/*				
				if ( m_playerHealth == 0 || m_playerHonor == 0 ){
					m_player.gotoAndStop( 'death' );
				}
				else if ( m_enemyHealth == 0 || m_enemyHonor == 0 ){
					m_enemy.gotoAndStop( 'death' );
				}
				else{
				*/
					m_playerAttak = !m_playerAttak;
				
					m_player.gotoAndStop( "idle" );				
					m_enemy.gotoAndStop( "idle" );
				
					nextStep();
				//}
			}
		}
		
		private function getActionByType( type:uint ):String{
			switch ( type ) {
				case Action.ATTAK_FEET: return "attack_feet";
				case Action.ATTAK_HEAD: return "attack_head";
				case Action.ATTAK_TOP: return "attack_top";
				case Action.BLOCK_FEET: return "block_feet";
				case Action.BLOCK_HEAD: return "block_head";
				case Action.BLOCK_TOP: return "block_top";
				
				case Action.BLOCK_NONE: return "";
					
				default: return ""; 
			}
		}
		
		private function Swap( playerAction:String, enemyAction:String ):void{
			
			if ( m_playerAttak ){
				if ( getChildIndex(m_player) > getChildIndex(m_enemy) ){
					if ( playerAction == "attack_head_fail" || playerAction == "attack_feet")
						swapChildren( m_player, m_enemy );
				}
				else if ( playerAction != "attack_head_fail" && playerAction != "attack_feet") swapChildren( m_player, m_enemy );
			}
			else{
				if ( getChildIndex(m_enemy) > getChildIndex(m_player) ){
					if ( enemyAction == "attack_head_fail" || enemyAction == "attack_feet" )
						swapChildren( m_enemy, m_player );
				}
				else if ( enemyAction != "attack_head_fail" && enemyAction != "attack_feet" ) swapChildren( m_enemy, m_player );
			}
		}
		
		private function CalculateDamage( ):void{
			
			var damage:int = 0;
			var protect:int = 0;
			
			var koef:int = 10;
			
			if ( m_playerAttak ){ //если атакует игрок
				m_playerHonor -= m_playerDressAmmunition[ TypeAmmunition.WEAPON.toString() ].BaseAmmunition.Attak;
				if ( m_playerHonor < 0 ) m_playerHonor = 0;
				Global.player.Honor = m_playerHonor;
				//отправить игроку инфу о том что у него убавился боевой дух
				
				m_playerDressAmmunition[ TypeAmmunition.WEAPON.toString() ].Health -= 5; //пока фиксированная величина, не знаю какая формула
				if ( m_playerDressAmmunition[ TypeAmmunition.WEAPON.toString() ].Health < 0)
					m_playerDressAmmunition[ TypeAmmunition.WEAPON.toString() ].Health = 0;
				//Global.Server.DamageAmmunition( Global.player.InternalID, m_playerDressAmmunition[ TypeAmmunition.WEAPON.toString() ].BaseAmmunition.globalID, null, null );
				
				if  ( Math.abs( m_enemyAction -  m_playerAction ) != 3 ){ //враг не смог отбить удар игрока
											
					switch ( m_playerAction ){
						case Action.ATTAK_HEAD: 
							//рассчитывать damage
							if ( CheckAmmunition( m_enemyDressAmmunition, TypeAmmunition.HELMET) ){
								damage = Math.ceil( m_playerDressAmmunition[ TypeAmmunition.WEAPON.toString() ].BaseAmmunition.Attack / m_enemyDressAmmunition[ TypeAmmunition.WEAPON.toString() ].BaseAmmunition.Protected * koef);
							}
							else
								damage = m_playerDressAmmunition[ TypeAmmunition.WEAPON.toString() ].BaseAmmunition.Attak;
							break;
						case Action.ATTAK_TOP:
							//рассчитывать damage
							
							//Нагрудник
							if ( CheckAmmunition( m_enemyDressAmmunition, TypeAmmunition.BIB ) ){
								protect += m_enemyDressAmmunition[ TypeAmmunition.BIB.toString() ].BaseAmmunition.Protected; 
							}
							
							//Перчатки
							if ( CheckAmmunition( m_enemyDressAmmunition, TypeAmmunition.GLOVES ) ){
								protect = m_enemyDressAmmunition[ TypeAmmunition.GLOVES.toString() ].BaseAmmunition.Protected; 
							}
							
							//Наплечники
							if ( CheckAmmunition( m_enemyDressAmmunition, TypeAmmunition.SCAPULAR ) ){
								protect = m_enemyDressAmmunition[ TypeAmmunition.SCAPULAR.toString() ].BaseAmmunition.Protected; 
							}
							
							//Рукав
							if ( CheckAmmunition( m_enemyDressAmmunition, TypeAmmunition.REREBRACE ) ){
								protect = m_enemyDressAmmunition[ TypeAmmunition.REREBRACE.toString() ].BaseAmmunition.Protected; 
							}
							
							if ( protect == 0 ) damage = m_playerDressAmmunition[ TypeAmmunition.WEAPON.toString() ].BaseAmmunition.Attak; 
							else damage = m_playerDressAmmunition[ TypeAmmunition.WEAPON.toString() ].BaseAmmunition.Attak / protect * koef;
							
							break;
						case Action.ATTAK_FEET:
							//рассчитывать damage
							
							//Ботинки
							if ( CheckAmmunition( m_enemyDressAmmunition, TypeAmmunition.BOOTS ) ){
								protect = m_enemyDressAmmunition[ TypeAmmunition.BOOTS.toString() ].BaseAmmunition.Protected; 
							}
							
							//Юбка
							if ( CheckAmmunition( m_enemyDressAmmunition, TypeAmmunition.SKIRT ) ){
								protect = m_enemyDressAmmunition[ TypeAmmunition.SKIRT.toString() ].BaseAmmunition.Protected; 
							}
							
							//Набедренник
							if ( CheckAmmunition( m_enemyDressAmmunition, TypeAmmunition.EPIGONATION ) ){
								protect = m_enemyDressAmmunition[ TypeAmmunition.EPIGONATION.toString() ].BaseAmmunition.Protected; 
							}
							
							if ( protect == 0 ) damage = m_playerDressAmmunition[ TypeAmmunition.WEAPON.toString() ].BaseAmmunition.Attak; 
							else damage = m_playerDressAmmunition[ TypeAmmunition.WEAPON.toString() ].BaseAmmunition.Attak / protect * koef;
							
							break;
					}
					m_enemyHealth -= damage;
					
					if ( m_enemyHealth < 0 ) m_enemyHealth = 0;
					
					m_enemyHealthStata.Value = m_enemyHealth;
				
				}
			}
			else{ //если атакует враг
				
				m_enemyHonor -= m_enemyDressAmmunition[ TypeAmmunition.WEAPON.toString() ].BaseAmmunition.Attak;
				if ( m_enemyHonor < 0 ) m_enemyHonor = 0;
				m_enemyHonorStata.Value = m_enemyHonor;				
				
				if  ( Math.abs( m_enemyAction -  m_playerAction ) != 3 ){ //игрок не смог отбить удар врага
					
					switch ( m_enemyAction ){
						case Action.ATTAK_HEAD: 
							//рассчитывать damage и портить аммуницию
							if ( CheckAmmunition( m_playerDressAmmunition, TypeAmmunition.HELMET ) ){
								damage = Math.ceil( m_enemyDressAmmunition[ TypeAmmunition.WEAPON.toString() ].BaseAmmunition.Attak / m_playerDressAmmunition[ TypeAmmunition.WEAPON.toString() ].BaseAmmunition.Protected * koef);
								
								m_playerDressAmmunition[ TypeAmmunition.HELMET.toString() ].Health -= m_enemyDressAmmunition[ TypeAmmunition.WEAPON.toString() ].BaseAmmunition.Attak;
								if ( m_playerDressAmmunition[ TypeAmmunition.HELMET.toString() ].Health < 0)
									m_playerDressAmmunition[ TypeAmmunition.HELMET.toString() ].Health = 0;
								//Global.Server.DamageAmmunition( Global.player.InternalID, m_playerDressAmmunition[ TypeAmmunition.HELMET.toString() ].BaseAmmunition.globalID, null, null );
							}
							else
								damage = m_enemyDressAmmunition[ TypeAmmunition.WEAPON.toString() ].BaseAmmunition.Attak;
							break;
						case Action.ATTAK_TOP:
							//рассчитывать damage и портить аммуницию
							
							//Нагрудник
							if ( CheckAmmunition( m_playerDressAmmunition, TypeAmmunition.BIB ) ){
								protect += m_playerDressAmmunition[ TypeAmmunition.BIB.toString() ].BaseAmmunition.Protected;
								
								m_playerDressAmmunition[ TypeAmmunition.BIB.toString() ].Health -= m_enemyDressAmmunition[ TypeAmmunition.WEAPON.toString() ].BaseAmmunition.Attak;
								if ( m_playerDressAmmunition[ TypeAmmunition.BIB.toString() ].Health < 0)
									m_playerDressAmmunition[ TypeAmmunition.BIB.toString() ].Health = 0;								
							}
							
							//Перчатки
							if ( CheckAmmunition( m_playerDressAmmunition, TypeAmmunition.GLOVES ) ){
								protect = m_playerDressAmmunition[ TypeAmmunition.GLOVES.toString() ].BaseAmmunition.Protected;
								
								m_playerDressAmmunition[ TypeAmmunition.GLOVES.toString() ].Health -= m_enemyDressAmmunition[ TypeAmmunition.WEAPON.toString() ].BaseAmmunition.Attak;
								if ( m_playerDressAmmunition[ TypeAmmunition.GLOVES.toString() ].Health < 0)
									m_playerDressAmmunition[ TypeAmmunition.GLOVES.toString() ].Health = 0;
							}
							
							//Наплечники
							if ( CheckAmmunition( m_playerDressAmmunition, TypeAmmunition.SCAPULAR ) ){
								protect = m_playerDressAmmunition[ TypeAmmunition.SCAPULAR.toString() ].BaseAmmunition.Protected;
								
								m_playerDressAmmunition[ TypeAmmunition.SCAPULAR.toString() ].Health -= m_enemyDressAmmunition[ TypeAmmunition.WEAPON.toString() ].BaseAmmunition.Attak;
								if ( m_playerDressAmmunition[ TypeAmmunition.SCAPULAR.toString() ].Health < 0)
									m_playerDressAmmunition[ TypeAmmunition.SCAPULAR.toString() ].Health = 0;
							}
							
							//Рукав
							if ( CheckAmmunition( m_playerDressAmmunition, TypeAmmunition.REREBRACE ) ){
								protect = m_playerDressAmmunition[ TypeAmmunition.REREBRACE.toString() ].BaseAmmunition.Protected;
								
								m_playerDressAmmunition[ TypeAmmunition.REREBRACE.toString() ].Health -= m_enemyDressAmmunition[ TypeAmmunition.WEAPON.toString() ].BaseAmmunition.Attak;
								if ( m_playerDressAmmunition[ TypeAmmunition.REREBRACE.toString() ].Health < 0)
									m_playerDressAmmunition[ TypeAmmunition.REREBRACE.toString() ].Health = 0;
							}
							
							if ( protect == 0 ) damage = m_playerDressAmmunition[ TypeAmmunition.WEAPON.toString() ].BaseAmmunition.Attak; 
							else damage = m_playerDressAmmunition[ TypeAmmunition.WEAPON.toString() ].BaseAmmunition.Attak / protect * koef;
							
							break;
						case Action.ATTAK_FEET:
							//рассчитывать damage и портить аммуницию
							
							//Ботинки
							if ( CheckAmmunition( m_playerDressAmmunition, TypeAmmunition.BOOTS ) ){
								protect = m_playerDressAmmunition[ TypeAmmunition.BOOTS.toString() ].BaseAmmunition.Protected;
								
								m_playerDressAmmunition[ TypeAmmunition.BOOTS.toString() ].Health -= m_enemyDressAmmunition[ TypeAmmunition.WEAPON.toString() ].BaseAmmunition.Attak;
								if ( m_playerDressAmmunition[ TypeAmmunition.BOOTS.toString() ].Health < 0)
									m_playerDressAmmunition[ TypeAmmunition.BOOTS.toString() ].Health = 0;
							}
							
							//Юбка
							if ( CheckAmmunition( m_playerDressAmmunition, TypeAmmunition.SKIRT ) ){
								protect = m_playerDressAmmunition[ TypeAmmunition.SKIRT.toString() ].BaseAmmunition.Protected;
								
								m_playerDressAmmunition[ TypeAmmunition.SKIRT.toString() ].Health -= m_enemyDressAmmunition[ TypeAmmunition.WEAPON.toString() ].BaseAmmunition.Attak;
								if ( m_playerDressAmmunition[ TypeAmmunition.SKIRT.toString() ].Health < 0)
									m_playerDressAmmunition[ TypeAmmunition.SKIRT.toString() ].Health = 0;
							}
							
							//Набедренник
							if ( CheckAmmunition( m_playerDressAmmunition, TypeAmmunition.EPIGONATION ) ){
								protect = m_playerDressAmmunition[ TypeAmmunition.EPIGONATION.toString() ].BaseAmmunition.Protected;
								
								m_playerDressAmmunition[ TypeAmmunition.EPIGONATION.toString() ].Health -= m_enemyDressAmmunition[ TypeAmmunition.WEAPON.toString() ].BaseAmmunition.Attak;
								if ( m_playerDressAmmunition[ TypeAmmunition.EPIGONATION.toString() ].Health < 0)
									m_playerDressAmmunition[ TypeAmmunition.EPIGONATION.toString() ].Health = 0;
							}
							
							if ( protect == 0 ) damage = m_enemyDressAmmunition[ TypeAmmunition.WEAPON.toString() ].BaseAmmunition.Attak; 
							else damage = m_enemyDressAmmunition[ TypeAmmunition.WEAPON.toString() ].BaseAmmunition.Attak / protect * koef;
							
							break;
					}
					
					m_playerHealth -= damage;
					
					if ( m_playerHealth < 0 ) m_playerHealth = 0;
					Global.player.Health = m_playerHealth;
					
				}
				else{//Игрок отбил удар врага
					
					//если у игрока есть щит
					if ( CheckAmmunition( m_playerDressAmmunition, TypeAmmunition.SHIELDS ) ){
						
						m_playerDressAmmunition[ TypeAmmunition.SHIELDS.toString() ].Health -= m_enemyDressAmmunition[ TypeAmmunition.WEAPON.toString() ].BaseAmmunition.Attak;
						if ( m_playerDressAmmunition[ TypeAmmunition.SHIELDS.toString() ].Health < 0)
							m_playerDressAmmunition[ TypeAmmunition.SHIELDS.toString() ].Health = 0;
					}
					else{
						//Что будет если мечь развалится в бою????
						m_playerDressAmmunition[ TypeAmmunition.WEAPON.toString() ].Health -= m_enemyDressAmmunition[ TypeAmmunition.WEAPON.toString() ].BaseAmmunition.Attak;
					}
				}
			}
		}
		
		private function CheckAmmunition( layers:Object ,ammunition:TypeAmmunition ):Boolean{
			if ( layers[ ammunition.toString() ] ){
				if ( layers[ ammunition.toString() ].Health > 0 ) return true;
				else return false;
			}
			return false;
		}
		
		override protected function onDestroy():void{
			m_iBack.bitmapData.dispose();
			m_iBack = null;
			
			Global.player.StartIncrease( );
			
			removeEventListener( Event.ENTER_FRAME, CheckAnimation );
		}
	}
}


import com.greensock.TweenLite;
import com.greensock.easing.Expo;

import core.baseObject;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.utils.Timer;

class Watch extends baseObject{
	
	[Embed(source="../../../../ResourcesGame/game/Screens/arena/icon_time_rotates.png")]   
	public static const icon_time:Class;
	
	//часы
	private var m_timer:Timer = new Timer( 1000, 60 );
	private var m_sandSprite:Sprite;
	private var m_sandWatch:Bitmap;
	private var m_textTime:TextField;
	private var m_callBack:Function;
	
	public function Watch( callBack:Function ):void{
		
		m_callBack = callBack;
		
		visible = false;
		
		m_sandWatch = new icon_time() as Bitmap;
		m_sandWatch.x -= m_sandWatch.width / 2;
		m_sandWatch.y -= m_sandWatch.height / 2;
		
		m_sandSprite = new Sprite();
		m_sandSprite.addChild( m_sandWatch );
		m_sandSprite.x += m_sandWatch.width / 2;
		m_sandSprite.y += m_sandWatch.height / 2;
		addChild(m_sandSprite);
		
		m_textTime = new TextField();
		m_textTime.mouseEnabled = false;
		m_textTime.text = String( m_timer.repeatCount );
		m_textTime.x = 30;
		addChild( m_textTime );
	}
	
	public function StartWatch( ):void{
		m_timer.addEventListener(TimerEvent.TIMER, onTimer );
		m_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete );
		m_timer.start();
		visible = true;
	}
	
	public function StopWatch( ):void{
		visible = false;
		
		m_textTime.text = String( m_timer.repeatCount );
		
		m_timer.reset();
		m_timer.removeEventListener(TimerEvent.TIMER, onTimer );
		m_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete );
	}
	
	private function onTimer( e:TimerEvent ):void{
		TweenLite.to( m_sandSprite, 1, {rotationZ:m_sandSprite.rotationZ+180, ease:Expo.easeInOut} );
		
		m_textTime.text = String( m_timer.repeatCount - m_timer.currentCount );
	}
	
	private function onTimerComplete( e:TimerEvent ):void{
		visible = false;
		
		m_textTime.text = String( m_timer.repeatCount );
		
		m_timer.removeEventListener(TimerEvent.TIMER, onTimer );
		m_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete );
		
		m_callBack();
	}
	
	override protected function onDestroy():void{
		if ( m_sandWatch ){
			m_sandWatch.bitmapData.dispose();
			m_sandWatch = null;
		}
		
		if ( m_timer.running ){
			m_timer.removeEventListener(TimerEvent.TIMER, onTimer );
			m_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete );
		}
		
		TweenLite.killTweensOf( m_sandSprite, true );
	}
}

class Action 
{ 
	public static const ATTAK_HEAD:uint = 1; 
	public static const ATTAK_TOP:uint = 2;
	public static const ATTAK_FEET:uint = 3;
	
	public static const BLOCK_HEAD:uint = 4; 
	public static const BLOCK_TOP:uint = 5;
	public static const BLOCK_FEET:uint = 6;
	
	public static const BLOCK_NONE:uint = 10;
}