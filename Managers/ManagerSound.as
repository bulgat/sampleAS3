package game.Managers
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	
	import game.Global;
	import game.assets.SoundAssets;
	
	public class ManagerSound
	{
		private static var m_isSound:Boolean = true;
		
		private static var m_isMusic:Boolean = true;
		
		private static var m_sounds:Dictionary;
		
		public function ManagerSound()
		{
			m_isSound = Global.settings.getAttribute( "SOUND" );
			m_isMusic = Global.settings.getAttribute( "MUSIC" ); 
			m_sounds  = new Dictionary( );
			
			m_music = getSound( "Christmas" );
			if( m_isMusic ){
				var st:SoundTransform = new SoundTransform( 0.1 );
				m_channel = m_music.play( 0 , 10000 ,st );
				
			}
		}
		
		
		public function  PlaySound( sound:String ):void{
			
			if( m_isSound ){
				var s:Sound; 
				if( m_sounds[sound] == null ){
				 s = getSound( sound );
				 m_sounds[sound] = s;
				 s.play();
				}else{
					s = m_sounds[sound];
					s.play( );
				}
			}
		}
		
		
		private function getSound( sound:String ):Sound{
			var s:Sound;
			s = new SoundAssets[sound] as Sound;
			return s;
		}
		
		public static function get isSound( ):Boolean{
			return m_isSound;
		}
		
		public static  function  get isMusic( ):Boolean{
			return m_isMusic;
		}
		
		
		public static function set isSound( f:Boolean ):void{
			Global.settings.setAttribute( "SOUND" , f );
			m_isSound = f;
		}
		
		public static  function  set isMusic( f:Boolean ):void{
			if( !f ) 
				m_channel.stop();
			else
				m_channel = m_music.play( 0 , 10000 );
			m_isMusic = f;
			Global.settings.setAttribute( "MUSIC" , f );
		}
		
		private static var m_music:Sound;
		private static var m_channel:SoundChannel;
		
		
	}
}