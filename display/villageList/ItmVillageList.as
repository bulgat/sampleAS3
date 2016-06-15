package game.display.villageList
{
	import core.baseObject;
	import core.gui.button.TypeButton;
	import core.gui.button.filterButton;
	import core.gui.button.stretchButton;
	
	import flash.display.Bitmap;
	import flash.sensors.Accelerometer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import game.Managers.Managers;
	import game.assets.Assets;
	import game.display.Lobby.PnlRightLobby;
	import game.display.Lobby.ScreenLobby;
	import game.display.Screens.ScreenVillage;
	import game.display.font.Font;
	import game.gameplay.village.Outhouse;
	import game.gameplay.village.baseOuthouse;
	import game.gameplay.village.baseVillage;

	/**
	 * элемент экрана со списком деревень 
	 * @author volk
	 * 
	 */	
	public class ItmVillageList extends baseObject
	{
		private var m_village:baseVillage;
		
		private var m_imgVillageBG:Bitmap;
		
		private var m_imgVillage:Bitmap;
		
		private var m_imgVillageFrame:Bitmap;
		
		private var m_title:TextField;
		
		private var m_btnCollectTribute:filterButton;
		 
		private var m_infoSatrap:infoVillain;
		
		private var m_infoPublican:infoVillain;
		
		private var m_infoVillage:infoVillage;
		
		private var m_buttonGet:stretchButton;
		
		private var m_powerIndicator:PowerIndicator;
		
		private var m_screenLobby:ScreenLobby; 
		
		public function ItmVillageList( villageImg:Bitmap, village:baseVillage , screenLobby:ScreenLobby )
		{
			
			m_village = village;
			m_screenLobby = screenLobby;
			
			m_imgVillageBG = Assets.getBitmap( 'vill_list_bgr' );
			addChild( m_imgVillageBG );
			
			m_imgVillage = villageImg; 
			m_imgVillage.x = 20;
			m_imgVillage.y = 30;
			addChild( m_imgVillage );
			
			m_imgVillageFrame = Assets.getBitmap( "frame" );
			m_imgVillageFrame.x = 10;
			m_imgVillageFrame.y = 20;
			addChild( m_imgVillageFrame );
			
			m_buttonGet = new stretchButton( TypeButton.DIFFICULT_GREEN, 80, "собрать дань");
			m_buttonGet.x = 20;
			m_buttonGet.y = 132;
			m_buttonGet.Click = ShowVillage;
			addChild( m_buttonGet );
			
			m_title = new TextField( );
			m_title.defaultTextFormat = new TextFormat( "Candara", 14, 0xffffff, true );
			m_title.autoSize = TextFieldAutoSize.LEFT;
			m_title.text = m_village.Name;
			m_title.width = 150;
			m_title.x = 20;
			m_title.y = 4;
			m_title.mouseEnabled = false;
			addChild( m_title );
			
			m_powerIndicator = new PowerIndicator( 2345 );
			m_powerIndicator.x = 380;
			m_powerIndicator.y = 85;
			addChild( m_powerIndicator );
	
			parse( village );
		}
		
		private function parse( village:baseVillage ):void{
			
			m_infoSatrap = new infoVillain( null , "Сатрап" );
			m_infoSatrap.x = 480;
			m_infoSatrap.y = 0;
			
			m_infoPublican = new infoVillain( null , "Мытарь" );
			m_infoPublican.x = 480;
			m_infoPublican.y = 80;
			
			
			var dx:int = 180;
			var dy:int = 0;
			for ( var i:int = 0; i < village.LengthOuthouse; i++){
				var tableOuthouse:Outhouse = village.getTableOuthouseByIndex( i );
				
				m_infoVillage = new infoVillage( tableOuthouse );
				m_infoVillage.x = dx;
				m_infoVillage.y = dy;
				
				dx += 100;
				if (i == 2){
					dx = 180;
					dy = 82;
				}
				
				addChild( m_infoVillage );
			}
			
			addChild( m_infoSatrap );
			addChild( m_infoPublican );
		}
		
		private function ShowVillage( ):void{
			m_screenLobby.ShowScreen( new  ScreenVillage( m_village ) ); //передаём деревню
		}
		
		override protected function onDestroy():void{
			if ( m_imgVillageBG ){
				m_imgVillageBG.bitmapData.dispose();
				m_imgVillageBG = null
			}
			
			if ( m_imgVillage ){
				m_imgVillage.bitmapData.dispose();
				m_imgVillage = null
			}
			
			if ( m_imgVillageFrame ){
				m_imgVillageFrame.bitmapData.dispose();
				m_imgVillageFrame = null
			}
		}
		
	}
}



import core.action.ImageLoader;
import core.baseObject;

import flash.display.Bitmap;
import flash.text.TextField;

import game.assets.Assets;
import game.display.font.Font;
import game.display.villageList.InfoPlayerItm;

/**
 * инфа о чижыках которые ломились на эти деревни / мытарь или сатрап/ 
 * @author volk
 * 
 */
class infoVillain extends baseObject{
	
	private var m_name		  :TextField; //Имя игрока
	private var m_imgStatus	  :Bitmap; //Корона или бочка
	private var m_uid:String;
	private var m_title:TextField;
	private var m_stata:TextField;
	private var m_infoPlayerItm:InfoPlayerItm;
	
	//private var format:TextFormat = Font.Candara;
	
	public function infoVillain( data:Object , type:String){
		
		m_infoPlayerItm = new InfoPlayerItm( '1', '99', '1' );
		addChild( m_infoPlayerItm );
		
		m_title = new TextField( );
		m_title.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000, true );
		m_title.autoSize = TextFieldAutoSize.CENTER;
		m_title.text = type + " дня";
		m_title.x = 75;
		m_title.y = 0;
		m_title.mouseEnabled = false;
		addChild( m_title );
		
		m_name = new TextField( );
		m_name.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000 );
		m_name.autoSize = TextFieldAutoSize.CENTER;
		m_name.text = "Имя \n игрока"
		m_name.x = 90;
		m_name.y = 15;
		m_name.mouseEnabled = false;
		addChild( m_name );
		
		if (type == "Сатрап") m_imgStatus = Assets.getBitmap( "power_ico" );
		else m_imgStatus = Assets.getBitmap( "prod_icon_img" );
		m_imgStatus.x = 80;
		m_imgStatus.y = 50;
		addChild( m_imgStatus );
		
		m_stata = new TextField( );
		m_stata.defaultTextFormat = new TextFormat( "Candara", 14, 0x000000 );
		m_stata.autoSize = TextFieldAutoSize.LEFT;
		m_stata.text = "15987";
		m_stata.x = 115;
		m_stata.y = 60;
		m_stata.mouseEnabled = false;
		addChild(m_stata);
		
	}
	
}

import core.gui.button.txtButton;
import core.gui.progress.ProgressHint;

import flash.text.TextFieldAutoSize;
import flash.utils.getTimer;

import game.Global;
import game.Managers.Managers;
import game.gameplay.village.baseOuthouse;
import game.gameplay.village.Outhouse;
import game.gameplay.village.StateOuthouse;

class infoVillage extends baseObject{
	
	private var m_level:int = 0;
	
	private var m_state:StateOuthouse;
	
	private var m_levelImg:txtButton;
	
	private var m_villageImg:Bitmap;
	
	private var m_indicator:Bitmap;
	
	private var m_progressUp:ProgressHint;
	
	private var m_progressDown:ProgressHint;
	
	public function infoVillage( outhouse:Outhouse ){
		m_level = outhouse.Level;
		
		m_villageImg = Assets.getBitmap( outhouse.Image + "_ico" );
		m_villageImg.smoothing = true;
		m_villageImg.x = 0;
		m_villageImg.y = 0;
		addChild( m_villageImg );
		
		DrawVProgress( m_level , 78, 70);
		
		/*
		m_progressUp = new ProgressHint( Assets.getBitmap( "vill_list_top_bar" ) );
		m_progressUp.Color = 0x00aa00;
		m_progressUp.Max = 100;
		m_progressUp.Value = 50;
		m_progressUp.x = 0;
		m_progressUp.y = 5;
		m_progressUp.showLabel(false);
		addChild( m_progressUp );
		*/
		
		m_progressDown = new ProgressHint( Assets.getBitmap( "vill_list_top_bar" ) );
		m_progressDown.Color = 0xff9600;
		m_progressDown.Max = outhouse.Time;
		m_progressDown.Value = Global.startTimeGame - outhouse.TimeProduction + Math.floor(getTimer() / 1000);
		m_progressDown.x = 10;
		m_progressDown.y = 70;
		m_progressDown.showLabel(false);
		addChild( m_progressDown );
		
		m_levelImg = new txtButton( Assets.getBitmap( "upgr_bgr_level" ), String( m_level ) );
		m_levelImg.x = 55;
		m_levelImg.y = 5;
		m_levelImg.Lock = true;
		addChild(m_levelImg);
		
		if ( m_progressDown.Max == m_progressDown.Value ) m_indicator = Assets.getBitmap( "prod_icon_on" );
		else m_indicator = Assets.getBitmap( "prod_icon_off" );
		m_indicator.x = 0;
		m_indicator.y = 60;
		addChild( m_indicator );
		
	}
	
	private var cubiks:Vector.<Bitmap> = new Vector.<Bitmap>;
	private function DrawVProgress( col:int , startX:int = 0, startY:int = 0):void{
		var cubik:Bitmap;
		for(var i:int = 0; i < 8; i++){
			if (i >= col)  cubik = Assets.getBitmap( "upgr_level_off" );
			else cubik = Assets.getBitmap( "upgr_level_on" );
			cubik.x = startX;
			cubik.y = startY;
			addChild( cubik );
			startY -= cubik.height;
			cubiks.push( cubik );
		}
	}
	
	override protected function onDestroy( ):void{
		while (cubiks.length) cubiks.pop().bitmapData.dispose();
		m_villageImg.bitmapData.dispose();
	}
}

import flash.text.TextFormat;
import game.display.font.Font;
import flash.text.Font;

class PowerIndicator extends baseObject{
	
	private var m_title:TextField;
	private var m_crown:Bitmap;
	
	public function PowerIndicator( power:int ){
		var format:TextFormat = new TextFormat("myCandara");
		format.bold = false;
		format.italic = true;
		format.size = 20;
		format.leading = 32;
		/*
		var _arr :Array	= flash.text.Font.enumerateFonts();
		for each( var i:flash.text.Font in _arr){
			trace(i.fontName, " - ",  i.fontStyle , " - ", i.fontType);
		}
		*/
		m_title = new TextField( );
		m_title.autoSize = TextFieldAutoSize.CENTER;
		m_title.defaultTextFormat = new TextFormat( "Candara", 18, 0xffffff, true, null, null, null, null, null, null, null, null, 35 );
		m_title.text = "Власть\n " + String( power );
		m_title.x = 5;
		m_title.y = -5;
		m_title.mouseEnabled = false;
		addChild( m_title );
		
		m_crown = Assets.getBitmap( "power_bigicon" );
		m_crown.x = 13;
		m_crown.y = 20;
		addChild( m_crown );
	}
	
	override protected function onDestroy( ):void{
		m_crown.bitmapData.dispose();
	}
}