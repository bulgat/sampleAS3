package game.display.Screens
{
	
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import game.Global;
	import game.Managers.ManagerAmmunition;
	import game.Managers.Managers;
	import game.display.FittingRoom.pnl.PnlAmmunition;
	import game.gameplay.ammunition.Ammunition;
	import game.gameplay.ammunition.TypeAmmunition;
	import game.gameplay.ammunition.baseAmmunition;
	

	/**
	 * наряжалка 
	 * @author volk
	 * 
	 */	
	public class ScreenAmmunition extends baseScreen
	{

		[Embed(source="../../../../ResourcesGame/game/Screens/ammunition/back_ammunit.png")] 
		public static const back:Class;
		
		[Embed(source="../../../../ResourcesGame/game/Screens/ammunition/heroes_ammunition.png")] 
		public static const heroes_ammunition:Class; 
		
		[Embed(source="../../../../ResourcesGame/game/Screens/ammunition/fist.png")]  
		public static const fist:Class; 
		
		private var m_iBack:Bitmap; 
		
		private var m_hBack:Bitmap;
		
		private var m_layerScapular:Sprite;
		
		private var m_layerHelmet:Sprite;
		
		private var m_layerWeapon:Sprite;
		
		private var m_layerShields:Sprite;
		
		private var m_layerBoots:Sprite;
		
		private var m_layerShoes:Sprite;
		
		private var m_layerPants:Sprite;
		
		private var m_layerBib:Sprite;
		
		private var m_layerGloves:Sprite;
		
		private var m_layerSkirt:Sprite;
		
		private var m_layerUndersuits:Sprite;
		
		private var m_layerEpigonation:Sprite;
		
		private var m_layerRerebrace:Sprite;
		
		private var panelAmmunition:PnlAmmunition;
		
		private var m_fist:Bitmap;
		
		private var m_layers:Object;
		
		public function ScreenAmmunition()
		{
			this.m_internalName = "AmmunitionArena";
			
			m_hBack = new back() as Bitmap;
			addChild( m_hBack );
			
			m_iBack = new heroes_ammunition() as Bitmap;
			addChild( m_iBack  );
		
			m_fist = new fist() as Bitmap ;
			m_layerHelmet   = new Sprite( );
			m_layerWeapon   = new Sprite( );
			m_layerShields   = new Sprite( );
			m_layerBoots    = new Sprite( );
			m_layerShoes    = new Sprite( );
			m_layerBib      = new Sprite( );
			m_layerGloves   = new Sprite( );
			m_layerScapular = new Sprite( );
			m_layerSkirt    = new Sprite( );
			m_layerUndersuits = new Sprite( );
			m_layerEpigonation = new Sprite( );
			m_layerRerebrace = new Sprite( );
			m_layers        = new Object( );
			
			m_layers[ TypeAmmunition.BIB.toString()     ]   = m_layerBib;
			m_layers[ TypeAmmunition.BOOTS.toString()   ]   = m_layerBoots;
			m_layers[ TypeAmmunition.GLOVES.toString()  ]   = m_layerGloves;
			m_layers[ TypeAmmunition.HELMET.toString()  ]   = m_layerHelmet;
			m_layers[ TypeAmmunition.SCAPULAR.toString()]   = m_layerScapular;
			m_layers[ TypeAmmunition.SKIRT.toString()   ]   = m_layerSkirt;
			m_layers[ TypeAmmunition.WEAPON .toString() ]   = m_layerWeapon;
			m_layers[ TypeAmmunition.UNDERSUITS.toString()] = m_layerUndersuits;
			m_layers[ TypeAmmunition.EPIGONATION.toString()] = m_layerEpigonation;
			m_layers[ TypeAmmunition.REREBRACE.toString()] = m_layerRerebrace;
			m_layers[ TypeAmmunition.SHIELDS.toString() ]   = m_layerShields;
			
			//-порядок слоев
			addChild( m_layerUndersuits );
			addChild( m_layerRerebrace );
			addChild( m_layerEpigonation);
			addChild( m_layerBoots );
			addChild( m_layerSkirt );
			addChild( m_layerBib );
			addChild( m_layerHelmet );
			addChild( m_layerScapular );
			addChild( m_layerWeapon );
			addChild( m_fist );
			addChild( m_layerGloves );
			addChild( m_layerShields );
			
			panelAmmunition = new PnlAmmunition( this );
			addChild( panelAmmunition );
			
			var undersuits:baseAmmunition = Managers.ammunitions.getAmmunitionByTypeString(TypeAmmunition.UNDERSUITS.toString());
			m_layers[ undersuits.Type.toString() ].addChild( new ImgAmmunition( undersuits ) )
			
		//	addChild( new ScreenWait( "Ждите идет загрузка элементов аммуниции" ) );
			
			//тут наряжаем в то чт имеет юзер /
			//for .....   addAmmunition( Managers.ammunitios.getGlobalID( ) )
			
			m_hBack.x -= 160;
			
			m_fist.x += 56;
			m_fist.y += 280;			
			
			setOffset( 80, 0 );
		}
		
		public function setOffset( offsetX:int = 0, offsetY:int = 0):void{
					
			for (var layer:* in m_layers){
				m_layers[layer].x += offsetX;
				m_layers[layer].y += offsetY;
			}
			
			m_iBack.x += offsetX;
			m_iBack.y += offsetY;
			
			m_hBack.x += offsetX;
			m_hBack.y += offsetY;
			
			m_fist.x += offsetX;
			m_fist.y += offsetY;
		}
		
		/**
		 * одеваем перса 
		 * @param global_uid
		 * 
		 */		
		public function addAmmunition(  itm:Ammunition ):Boolean{
			
			if( itm == null ) return false;
			//ClearLayer( m_layers[ itm.BaseAmmunition.Type.toString()] , itm );
			m_layers[ itm.BaseAmmunition.Type.toString() ].addChild( new ImgAmmunition( itm.BaseAmmunition ) );
			
			m_layerUndersuits.visible = HasMilitia();
			
			return true;
		}
		
		
		/**
		 *снимаем одежду 
		 * @param type
		 * 
		 */		
		public function takeOff( itm:Ammunition  ):void{
			ClearLayer( m_layers[ itm.BaseAmmunition.Type.toString() ] , itm );
		}
		
		private function HasMilitia():Boolean{
			
			if (m_layers[TypeAmmunition.BIB.toString()].numChildren > 0 ||
				m_layers[TypeAmmunition.GLOVES.toString()].numChildren > 0 ||
				m_layers[TypeAmmunition.HELMET.toString()].numChildren > 0 ||
				m_layers[TypeAmmunition.REREBRACE.toString()].numChildren > 0 ||
				m_layers[TypeAmmunition.SCAPULAR.toString()].numChildren > 0
				)
				return true;
			
			return false;
		}
		
		private function ClearLayer( layer:Sprite , itm:Ammunition ):void{
			
			for(var i:int = 0; i < layer.numChildren; i++){
				if ( ImgAmmunition( layer.getChildAt( i ) ).globalID == itm.BaseAmmunition.globalID ){
					layer.removeChildAt( i );
				}
			}
			
			/*
			while( layer.numChildren > 0 ){
				layer.removeChildAt( 0 );
			}*/
			
			m_layerUndersuits.visible = HasMilitia();
		}
		
		
	}
}

import core.baseObject;
import flash.display.Bitmap;
import game.gameplay.ammunition.baseAmmunition;

class ImgAmmunition extends baseObject{
	
	private var m_globalID:int = 0;
	
	public function ImgAmmunition( BaseAmmunition:baseAmmunition ) {
		
		addChild( BaseAmmunition.bigImage );
		
		m_globalID = BaseAmmunition.globalID;
	}
	
	public function get globalID( ):int{
		return m_globalID
	}
}