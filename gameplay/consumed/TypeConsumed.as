package game.gameplay.consumed
{
	public final class TypeConsumed
	{
		private static var list:Object = new Object( );
		
		public static const BRIMSTONE:TypeConsumed = new TypeConsumed( "brimstone" );
		
		public static const COAL:TypeConsumed  = new TypeConsumed( "coal" );
		
		public static const COPPER:TypeConsumed = new TypeConsumed( "copper" );
		
		public static const GEMS:TypeConsumed = new TypeConsumed( "gems" );
		
		public static const GOLD:TypeConsumed = new TypeConsumed( "gold" );
		
		public static const IRON:TypeConsumed = new TypeConsumed( "iron" );
		
		public static const LEATHER:TypeConsumed = new TypeConsumed( "leather" );
		
		public static const STONE:TypeConsumed = new TypeConsumed( "stone" );
		
		public static const TIN:TypeConsumed = new TypeConsumed( "tin" );
		
		public static const WOOD:TypeConsumed = new TypeConsumed( "wood" );
		
		public static const EGG:TypeConsumed = new TypeConsumed( "egg" );
		
		public static const FISH:TypeConsumed = new TypeConsumed( "fish" );
		
		public static const FRUIT:TypeConsumed = new TypeConsumed( "fruit" );
		
		public static const GRAIN:TypeConsumed = new TypeConsumed( "grain" );
		
		public static const GREENS:TypeConsumed = new TypeConsumed( "greens" );
		
		public static const HONEY:TypeConsumed = new TypeConsumed( "honey" );
		
		public static const MEAT:TypeConsumed = new TypeConsumed( "meat" );
		
		public static const SALT:TypeConsumed = new TypeConsumed( "salt" );
		
		public static const SPICE:TypeConsumed = new TypeConsumed( "spice" ); 
		
		public static const VEGETABLES:TypeConsumed = new TypeConsumed( "vegetable" );
		
		public static const GOLD_COIN:TypeConsumed = new TypeConsumed( "gold_coin" );
		
		public static const COPPER_COIN:TypeConsumed = new TypeConsumed( "copper_coin" );
		
		public static const HORSESHOE_COIN:TypeConsumed = new TypeConsumed( "horseshoe_coin" );
		
		public static const SILVER_COIN:TypeConsumed = new TypeConsumed( "silver_coin" );
		
		//РАСТЕНИЯ
		public static const ALOE:TypeConsumed = new TypeConsumed( "aloe" );
		
		public static const CASTIRONSQUARE:TypeConsumed = new TypeConsumed( "castironsquare" );
		
		public static const MANDRAGORA:TypeConsumed = new TypeConsumed( "mandragora" );
		
		public static const CAMOMILE:TypeConsumed = new TypeConsumed( "camomile" );
		
		public static const HOLLY:TypeConsumed = new TypeConsumed( "holly" );
		
		public static const GOOSEGRASS:TypeConsumed = new TypeConsumed( "goosegrass" );
		
		public static const TANSY:TypeConsumed = new TypeConsumed( "tansy" );
		
		public static const SALVIA:TypeConsumed = new TypeConsumed( "salvia" );
		
		//---------------------------------------
		
		public static const POWER:TypeConsumed = new TypeConsumed( "power" );
		
		public static const HEALTH:TypeConsumed = new TypeConsumed( "health" );
		
		public static const EXP:TypeConsumed = new TypeConsumed( "exp" );
		
		public static const AGILITY:TypeConsumed = new TypeConsumed( "agility" );
		
		public static const ATTACK:TypeConsumed = new TypeConsumed( "attack" );
		
		public static const PROTECT:TypeConsumed = new TypeConsumed( "protect" );
		
		public static const HONOR:TypeConsumed = new TypeConsumed( "honor" );
		
		public static const UNKNOW:TypeConsumed = new TypeConsumed( "unknow" );
		
		//Череп Перчатка и свиток
		public static const SKULL:TypeConsumed = new TypeConsumed( "skull" );
		
		public static const CHARTER:TypeConsumed = new TypeConsumed( "charter" );
		
		public static const GLOVE:TypeConsumed = new TypeConsumed( "glove" );

		
		public function TypeConsumed( type:String )
		{
			m_value = type;
			list[type] = this;
		}
		
		public function get Value( ):String{
			return m_value;
		}
		
		public static function Convert(  type:String ):TypeConsumed{
			var t:TypeConsumed = list[type];
			if( t == null ) return TypeConsumed.UNKNOW;
			return t;
		}
		
		private var m_value:String;
	}
}