package game.gameplay.ammunition
{
	import core.action.ImageLoader;
	import core.baseObject;
	import core.utils.ImgNameCrop;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import game.Global;
	import game.gameplay.consumed.TypeConsumed;

	/**
	 * Аммуниция / надо тз почитать повнимательней /
	 * @author volk
	 * 
	 */	
	public class baseAmmunition extends baseObject
	{
		private var m_pathImage:String;
		
		private var m_price_force:Object;
		
		private var m_price_buy_coin:Object;
		
		private var m_price_buy_cons:Object;
		
		private var m_price_repair_coin:Object;
		
		private var m_price_repair_cons:Object;
		
		private var m_attak:int = 0;
		
		private var m_protected:int = 0;
		
		private var m_strength:int = 0;
		
		private var m_level:int = 0;
		
		private var m_createTime:int = 0;
		
		private var m_repairTime:int = 0;
		
		
		//Время в разработке и триггер является ли щас в разработке
		//private var m_createTimeLeast:int = 0;
		private var m_onCreate:Boolean = false;
		
		private var m_hint:String = "baseAmmunition";
		
		private var m_name:String;
		
		private var m_type:String;
		
		/**
		 * глобальный ID во всем списке аммуниций 
		 */		  
		private var m_globalID:int = -1;
		
		private var m_internalID:int = -1;
		
		/**
		 * Внутренний ID группу/ Например тип  аммуници шлемы , текущий - рогатая каска  может иметь глобальный ID 100 , а внутренний среди всех шлемов  2/ внутри группы шлемов  
		 */		
		private var m_internalGroup:int = -1;
		
		private var m_bigImage:ImageLoader;
		
		private var m_icoImage:ImageLoader;
		
		private namespace CALLBACK;
		
		private var m_pos:Point;
		
		private var m_isComposite:Boolean = false;
		
		private var m_compositeImageBig:Sprite;
		private var m_compositeImageIco:Sprite;
		
		private var m_cLoaderGuard:ImageLoader;
		private var m_cLoaderBlade:ImageLoader;
		private var m_cLoaderBackplate:ImageLoader;
		
		public function baseAmmunition(  obj:Object  )
		{
			
			// локальный распарс
			if( obj is XML ){
				m_name         = obj.@name;
				m_pathImage    = ImgNameCrop.CutExtension( obj.@bigImage );
				m_type         = obj.@type;
				m_hint         = obj.@hint;
				
				m_attak 	   = int( obj.@attak );
				m_protected    = int( obj.@['protected'] );
				m_strength     = int( obj.@strength );
				
				m_level        = int( obj.@level );
				m_createTime   = int( obj.@create_time );
				m_repairTime   = int( obj.@repair_time );
				
				m_price_buy_coin = JSON.parse( obj.@price_buy_coin );
				m_price_buy_cons = JSON.parse( obj.@price_buy_cons );
				m_price_repair_coin = JSON.parse( obj.@price_repair_coin );
				m_price_repair_cons = JSON.parse( obj.@price_repair_cons );
				m_price_force = JSON.parse( obj.@price_force );
				
				m_globalID     = int( obj.@globalID   );
				m_internalID   = int( obj.@internalID );
				m_pos          = new Point( Number( obj.@x ),Number( obj.@y ));
				m_bigImage = new ImageLoader( Global.Host + m_pathImage+".png" , CALLBACK::onPositionBig );	
				m_icoImage = new ImageLoader( Global.Host + m_pathImage+"_ico.png" , CALLBACK::onPositionIco );
			}
			else{
				m_isComposite = true;
				this.m_compositeImageBig = new Sprite( );
				this.m_compositeImageIco = new Sprite( );
			
				if( obj['blade']!=null ) 
					this.m_cLoaderBlade = new ImageLoader( Global.Host+"images/generateWeapon/blade/"+obj['blade'].image , CALLBACK::onLoadBlade );
				
				if( obj['guard']!=null )
					this.m_cLoaderGuard = new ImageLoader( Global.Host+"images/generateWeapon/guard/"+obj['guard'].image , CALLBACK::onLoadGuard );
				
				if( obj['backplate']!=null )
					this.m_cLoaderBackplate = new ImageLoader( Global.Host+"images/generateWeapon/backplate/"+obj['backplate'].image , CALLBACK::onLoadBackplate );
			}
		}
		
		CALLBACK function onLoadBlade( ):void{ 
			m_compositeImageBig.addChild( this.m_cLoaderBlade ); 
			
		}
		
		CALLBACK function onLoadGuard( ):void{ 
			m_compositeImageBig.addChild( this.m_cLoaderGuard );
		}
		
		CALLBACK function onLoadBackplate( ):void{ 
			m_compositeImageBig.addChild( this.m_cLoaderBackplate );
		}
		
		
		CALLBACK function onPositionBig( ):void{ 
			m_bigImage.x = m_pos.x;
			m_bigImage.y = m_pos.y;
		}
		
		CALLBACK function onPositionIco( ):void{ 
			//m_icoImage.x = - m_icoImage.width/2;
			//m_icoImage.y = -m_icoImage.height/2;
		}
		
		private function parseXML( xml:XMLList ):void{
			
		}  
		
		//-- вывести инфу о объекте
		override public  function toString( ):String{
			return "ammunition: "+m_name;
		}
		
		public function get Hint( ):String{
			return m_hint;
		}
		
		//tf.htmlText = '<font face= "arial" color=#ffffff size="24"><p align = "left">' + tf.text + '</p></font>';
		public function get HtmlInfo( ):String{
			var info:String = "<p align ='left'> Наименование:"+m_name+ "</p>"+"<p align ='left'> Цена:"+100+ "</p>"
			var str:String = "<font face='arial' color='#ff0000' size ='24'>" + "<p>ddddgf</p>" + " </font>";
		
			return str;
		}
		
		public function get Ico ():Bitmap{
			if( this.m_isComposite ){
				if( m_compositeImageIco.numChildren==0 ){
					var matrix:Matrix = new Matrix( ); 
					var w:Number =  73/this.m_compositeImageBig.width;
					var h:Number =  115/this.m_compositeImageBig.height;
					matrix.scale(w,h);
					
					var m_bitmapData:BitmapData = new BitmapData( m_compositeImageBig.width, m_compositeImageBig.height, true, 0x00000000 );
					m_bitmapData.draw( m_compositeImageBig , matrix );
				
					//var bitmap:Bitmap = new Bitmap( m_bitmapData , "auto",true);
		
					//m_compositeImageIco.addChildAt( bitmap, 0 );  m_compositeImageIco.x = m_compositeImageIco.y = 200;
				}
				//return m_compositeImageIco;
				return new Bitmap( m_bitmapData.clone() );
			
			}
			
			return new Bitmap( m_icoImage.Image.bitmapData.clone() );
		}
		
		public function get bigImage( ):*{
			if( this.m_isComposite )
				return m_compositeImageBig;
			return m_bigImage;
		}
		
		public function get PriceBuyCoin( ):Object{  
			return m_price_buy_coin;
		}
		
		public function get PriceBuyCons( ):Object{  
			return m_price_buy_cons;
		}
		
		public function get PriceRepairCoin( ):Object{  
			return m_price_repair_coin;
		}
		
		public function get PriceRepairCons( ):Object{  
			return m_price_repair_cons;
		}
		
		public function get PriceForce( ):Object{
			return m_price_force;
		}
		
		public function get Strength( ):int{
			return m_strength;
		}
		
		public function get Attak( ):int{
			return m_attak;
		}
		
		public function get Protected( ):int{
			return m_protected;
		}
		
		public function get Level( ):int{
			return m_level;
		}
		
		public function get CreateTime():int{
			return m_createTime;
		}
		
		public function get RepairTime():int{
			return m_repairTime;
		}
		
//		public function get CreateTimeLeast( ):int{
//			return m_createTimeLeast;
//		}
		
		public function get onCreate( ):Boolean{
			return m_onCreate;
		}
		
		public function get globalID( ):int{
			return m_globalID;
		}
		
		public function get internalID( ):int{
			return m_internalID;
		}
		
		public function get Name( ):String{
			return m_name;
		}
		 
		public function get urlImageIco( ):String{
			if( Global.Online )
				return "";
			else
				return m_pathImage+"_ico.png";
		}
		
		public function get urlImageBig( ):String{
			if( Global.Online )
				return "";
			else
				return m_pathImage+".png";
		}
		
		public function get Type( ):TypeAmmunition{
		
			switch( m_type ){
				
				case TypeAmmunition.HELMET.toString():
					return TypeAmmunition.HELMET;
					break;
				
				case TypeAmmunition.WEAPON.toString():
					return TypeAmmunition.WEAPON;
					break;
				
				case TypeAmmunition.SHIELDS.toString():
					return TypeAmmunition.SHIELDS;
					break;
				
				case TypeAmmunition.BOOTS.toString():
					return TypeAmmunition.BOOTS;
					break;
				
				case TypeAmmunition.GLOVES.toString():
					return TypeAmmunition.GLOVES;
					break;
				
				case TypeAmmunition.SCAPULAR.toString():
					return TypeAmmunition.SCAPULAR;
					break;
				
				case TypeAmmunition.SKIRT.toString():
					return TypeAmmunition.SKIRT;
					break;
				
				case TypeAmmunition.UNDERSUITS.toString():
					return TypeAmmunition.UNDERSUITS;
					break;
				
				case TypeAmmunition.BIB.toString():
					return TypeAmmunition.BIB;
					break;
				
				case TypeAmmunition.EPIGONATION .toString():
					return TypeAmmunition.EPIGONATION;
					break;
				
				case TypeAmmunition.REREBRACE .toString():
					return TypeAmmunition.REREBRACE;
					break;
			}
			return  TypeAmmunition.UNKNOW;
		}
		
		public function set onCreate( flag:Boolean ):void{
			m_onCreate = flag;
		}
		
//		public function set CreateTimeLeast( value:int ):void{
//			m_createTimeLeast = value;
//		}
		
	}
}