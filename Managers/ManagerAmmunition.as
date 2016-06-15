package game.Managers
{
	
	import flash.net.URLRequest;
	
	import game.Global;
	import game.gameplay.ammunition.baseAmmunition;

	
	
	public class ManagerAmmunition  extends ManagerBase
	{
		private var m_list:Object = new Object( );
		
		private var m_guard:Object;
		
		private var m_blade:Object;
		
		private var m_backplate:Object;
		
		private namespace CALLBACK;
		
		public function ManagerAmmunition( data:Object )
		{
			super( data );
			
			if( Global.Online )
				parseLocal( data );
			else
				parseLocal( data );
			 
		}
		
		private function parseLocal( data:Object ):void{ 
			var xml:XML = data as XML;
		
			for each ( var xx:XML in xml.item ){
					var b:baseAmmunition = new baseAmmunition( xx );
					m_list[xx.@globalID] = b; 
			}
			
			Global.Server.getInfoGenerateWeapon(  CALLBACK::onGood , CALLBACK::onFall  );
		}
		
		CALLBACK function onFall( e:Object ):void{

		}
		
		//{"guard":{"globalID":"3","image":null,"damage_min":"1","damage_max":"100"},"blade":{"globalID":"4","image":null,"damage_min":"1","damage_max":"100"},"backplate":{"globalID":"2","image":null,"damage_min":"1","damage_max":"100"}}}
		//<item  globalID ='900' internalID= "0" name ="Мечь" price_consumed="wood#gold#coal" price="10#10#10" level="1" strength="10" attak="1" protected="0" bigImage ="images/ammunitions/weapon/weapon_1"  type = "weapon" x='42' y ='274' hint="bla bla"/>
			
		CALLBACK function onGood( e:Object ):void{ 
			this.m_guard = e.guard;
			this.m_backplate = e.backplate;
			this.m_blade = e.blade;
			//this.getAmmunitionByGlobalID("1#2#1");
		}

		public function getGuard( idGuard:int ):Object{
			for each ( var i:Object in m_guard ){ 
				if( i['globalID'] == idGuard ){
					return i;
				}
			}
			return null;
		}
		
		public function getBlade( idBlade:int ):Object{
			for each ( var i:Object in m_blade ){
				if( i.globalID == idBlade ){
					return i;
				}
			}
			return null; 
		}
		
		public function getBackplate( idBackplate:int ):Object{
			for each ( var i:Object in m_backplate ){
				if( i.globalID == idBackplate ){
					return i;
				}
			}
			return null;
		}
		
		private function parseOnline( data:Object ):void{
			trace( "ParseGLobal");
		}
		
		
		/**
		 * ищем аммуницию по глобальному ID / если пришло с сипоратором , то это генерированное оружие/ клеим его на ходу
		 * @param globalID - глобальный id
		 * @return 
		 * 
		 */		
		public function getAmmunitionByGlobalID( globalID:String ):baseAmmunition{ 
			
			if ( m_list[globalID] ){
			
				if( globalID.indexOf( "#" ) != -1 ){
					return createAmmunition( globalID );
				}
				return m_list[globalID];
			
			}
			
			return null;
		}

		
		/**
		 * собираем оружие , которое сгененрированно 
		 * @param globalID
		 * @return 
		 * 
		 */		
		private function createAmmunition( globalID:String ):baseAmmunition{
			var list:Array = globalID.split( "#" );
			var ba:baseAmmunition;
			var collect:Object = new Object();
			for ( var i:int = 0; i<list.length ; i++){
				if( list[i]!=-1 ){
					switch(i){
						case 0:
								collect['guard'] =  this.getGuard( list[i]) ;
							break;
						case 1:
								collect['blade'] =  this.getBlade( list[i]) ;
							break;
						case 2:
								collect['backplate'] =   this.getBackplate( list[i]) ;
							break;
					}
		
				}
			}
		
			ba = new baseAmmunition( collect );
			if( ba!=null ) m_list[globalID] = ba;
			return ba;
			
			return null;
		}
		
		
		public function getAmmunitionByTypeString( type:String ):baseAmmunition{
			var it:baseAmmunition;
			for each ( it in m_list ){
				if( it.Type.toString() == type )
					return it;
			}
			return null;
		}
		 
	}
}