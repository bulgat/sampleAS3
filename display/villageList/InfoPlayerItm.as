package game.display.villageList{

import core.action.ImageLoader;
import core.baseObject;

import flash.display.Bitmap;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;

import game.Global;
import game.assets.Assets;
import game.display.font.Font;

public class InfoPlayerItm extends baseObject{
	
	private var m_level		  :TextField = null; //Уровень игрока, тот, что в зелёном поле
	private var m_levelClan   :TextField = null; //Уровень клана, тот, что на щите
	private var m_avatar	  :ImageLoader;
	private var m_bgrAvatar   :Bitmap;
	private var m_shield:Bitmap; //Щит
	private var m_uid:String;
	private var m_onComplete:Function;
	//private var format:TextFormat = Font.Candara;
	
	public function InfoPlayerItm( level:String, clan:String, uid:String, onComplete:Function = null ){
		
		m_onComplete = onComplete;
		
		m_bgrAvatar = Assets.getBitmap( 'gamer_bgr' );
		addChild( m_bgrAvatar );
		
		//format.color = 0xffffff;
		
		m_level = new TextField( );
		m_level.defaultTextFormat = new TextFormat( "Candara", 14, 0xFFFFFF );
		m_level.autoSize = TextFieldAutoSize.CENTER;
		m_level.mouseEnabled = false;
		m_level.text = level;
		m_level.x = 32;
		m_level.y = -4;
		addChild( m_level );
		
		m_shield = Assets.getBitmap( "gamer_clan_level_bgr" );
		m_shield.x = 0;
		m_shield.y = 50;
		addChild( m_shield );
		
		m_levelClan = new TextField( );
		m_levelClan.defaultTextFormat = new TextFormat( "Candara", 14, 0xFFFFFF, true );
		m_levelClan.autoSize = TextFieldAutoSize.CENTER;
		m_levelClan.mouseEnabled = false;
		m_levelClan.text = clan;
		m_levelClan.x = 6;
		m_levelClan.y = 55;
		addChild( m_levelClan );
		
		Global.social.GetUserInfo( [uid], ["photo_50"] , onInfo );
		
	}
	
	private function onInfo( response:Object ):void{
		
		if ( m_onComplete != null ) m_onComplete( response[0] );
		
		m_avatar = new ImageLoader( response[0]['photo_50'] , onAvatarLoad );
	}
	
	private function onAvatarLoad( ):void{
		m_avatar.x = 13;
		m_avatar.y = 17;
		addChild( m_avatar );
		setChildIndex( m_avatar, getChildIndex( m_shield ) );
	}
	
}

}