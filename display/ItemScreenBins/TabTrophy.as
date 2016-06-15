package game.display.ItemScreenBins
{
	import core.utils.ScrollBar;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import game.Global;
	import game.Managers.Managers;
	import game.Managers.ManagersKingdoms;
	import game.assets.Assets;
	import game.display.Screens.ScreenBins;
	import game.gameplay.artifact.baseArtifact;
	import game.gameplay.trophy.baseTrophy;
	import game.gameplay.village.baseKingdom;
	import game.gameplay.village.baseVillage;
	
	
	public class TabTrophy extends TabBins
	{
		
		private var m_scrollPanel:Sprite;
		private var m_scrollBar:ScrollBar;
		
		private var m_usedArtifact:baseArtifact;
		
		private namespace CALLBACK;
		
		public function TabTrophy( screen:ScreenBins )
		{
			super( screen );
			
			m_scrollPanel = new Sprite();
			m_scrollPanel.x = 7;
			m_scrollPanel.y = 50;
			
			onFill( );
			
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}
		
		private function onAddedToStage( e:Event ):void{
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			
			CreateScroll();
		}
		
		private function CreateScroll():void{
			m_scrollBar = new ScrollBar( m_scrollPanel, new Rectangle( 0 , m_scrollPanel.y , m_scrollPanel.width, 468 ) );
			m_scrollBar.CreateScroll();
			m_scrollBar.Offset = 50;
			addChild(m_scrollBar);
		}
		
		override protected  function onFill( ):void{
			
			var backKingdomName:Bitmap;
			var kingdomName:TextField;
			var backVillageName:Bitmap;
			var villageName:TextField;
			var arrow:Bitmap;
			var dx:int = 0;
			var dy:int = 0;
			var artifactID:int = 1;
			
			for( var i:int = 1; i < Managers.kingdoms.Length; i++){
				backKingdomName = Assets.getBitmap( "storage_trophy_bgr_name" );
				backKingdomName.y = dy;
				m_scrollPanel.addChild( backKingdomName );
				
				var kingdom:baseKingdom = Managers.kingdoms.getKingdomByGlobalID( i.toString() );
				
				kingdomName = new TextField();
				kingdomName.defaultTextFormat = new TextFormat( "Candara", 18, 0xFFFFFF );
				kingdomName.mouseEnabled = false;
				kingdomName.text = "Владения замка <<" + kingdom.Name + ">>";
				kingdomName.autoSize = TextFieldAutoSize.LEFT;
				kingdomName.y = dy;
				kingdomName.x = backKingdomName.width / 2 - kingdomName.width / 2;
				m_scrollPanel.addChild( kingdomName );
				dy += backKingdomName.height + 2;
				
				for( var j:int = 0; j < kingdom.getLengthVillage(); j++ ){
					backVillageName = Assets.getBitmap( "bgr_name_resources" );
					backVillageName.y = dy;
					m_scrollPanel.addChild( backVillageName );
					
					var village:baseVillage = Managers.villages.getVillageByGlobalID( kingdom.getVillageIDByIndex( j ).toString() )
					
					villageName = new TextField();
					villageName.defaultTextFormat = new TextFormat( "Candara", 16, 0xFFFFFF );
					villageName.mouseEnabled = false;
					villageName.text = village.Name;
					villageName.autoSize = TextFieldAutoSize.LEFT;
					villageName.x = 30;
					villageName.y = dy;
					m_scrollPanel.addChild( villageName );
					dy += backVillageName.height + 2;
					
					var trophies:Array = Managers.OuthouseCoord.getTrophy(village.GlobalID);
					
					for( var t:int = 0; t <= trophies.length; t++ ){
						
						var trophy:baseTrophy = Managers.trophy.getTrophyByGlobalID( trophies[t].toString() );
						
						if ( trophy == null ) continue;
						
						var itmTrophy:ItmTrophy = new ItmTrophy( trophy, Global.player.getTrophy( trophy.GlobalID ), onAsk );
						itmTrophy.x = dx;
						itmTrophy.y = dy;
						m_scrollPanel.addChild( itmTrophy );
						dx += itmTrophy.width + 1;
						
					}
					
					arrow = Assets.getBitmap( "arrow_trophy" );
					arrow.x = dx + 1;
					arrow.y = dy + itmTrophy.height / 2 - arrow.height / 2;
					m_scrollPanel.addChild( arrow );
					
					var itmArtifact:ItmArtifact = new ItmArtifact( Managers.artifact.getArtifactByID( artifactID ), onCollect );
					itmArtifact.x = dx + 10;
					itmArtifact.y = dy;
					m_scrollPanel.addChild( itmArtifact );
					
					artifactID++;
					
					dx = 0;
					
					dy += itmTrophy.height + 2;
				}
				
			}
		}
		
		private function onAsk( trophy:baseTrophy ):void{
			//попросить трофей у друга 
		}
		
		private function onCollect( artifact:baseArtifact ):void{
			
			m_usedArtifact = artifact;
			
			var listTrophy:Array = artifact.ListTrophy;
			
			var canCollect:Boolean = true;
			for(var i:int = 0; i < listTrophy.length; i++){
				if ( !Global.player.getTrophy( int(listTrophy[i])) ) canCollect = false;
			}
			
			if ( canCollect ){
				Global.Server.CollectionArtifact( Global.player.InternalID, artifact.globalID, CALLBACK::onCollectGood, CALLBACK::onCollectBad );
			}
			else{
				trace("Не достаточно трофеев");
			}
			
		}
		
		CALLBACK function onCollectGood( response:Object ):void{
			trace("Артефакт собран удачно");
			var listTrophy:Array = m_usedArtifact.ListTrophy;
			
			for(var i:int = 0; i < listTrophy.length; i++) Global.player.setTrophy( int(listTrophy[i]), -1 );
			
			Global.player.setArtifact( m_usedArtifact.globalID, 1 );
			
			Refresh();
		}
		
		CALLBACK function onCollectBad( response:Object ):void{
			trace("Артефакт НЕ собран удачно");
		}
		
		private function Refresh():void{
			
			while ( m_scrollPanel.numChildren ){
				
				var child:* = m_scrollPanel.getChildAt( 0 )
				
				if ( child is Bitmap ){
					child.bitmapData.dispose();
				}
				
				m_scrollPanel.removeChild( child );
				
				child = null;
			}
			
			removeChild( m_scrollBar );
			m_scrollBar = null;
			
			onFill();
			
			CreateScroll();
			
		}
		
	}
}

import core.baseObject;
import core.gui.button.buttonUpDown;

import flash.display.Bitmap;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import game.assets.Assets;
import game.gameplay.trophy.baseTrophy;

class ItmTrophy extends baseObject{
	
	[Embed(source="../../../../ResourcesGame/game/Screens/bins/geton_present_normal_but.png")]    
	public static const geton_present_normal_but:Class
	
	[Embed(source="../../../../ResourcesGame/game/Screens/bins/geton_present_press_but.png")]    
	public static const geton_present_press_but:Class
	
	private var m_back:Bitmap;
	private var m_ico:Bitmap;
	private var m_col:TextField;
	private var m_btn:buttonUpDown;
	private var m_callBack:Function;
	private var m_trophy:baseTrophy;
	
	public function ItmTrophy( trophy:baseTrophy, col:int, callBack:Function ){
		
		m_trophy = trophy;
		m_callBack = callBack;
		
		m_back = Assets.getBitmap( "background_trophy_icon" );
		addChild( m_back );
		
		m_ico = Assets.getBitmap( m_trophy.Image );
		m_ico.y = 5;
		addChild( m_ico );
		
		m_col = new TextField();
		m_col.defaultTextFormat = new TextFormat( "Candara", 18, 0x000000 );
		m_col.mouseEnabled = false;
		m_col.text = "x"+String( col );
		m_col.autoSize = TextFieldAutoSize.LEFT;
		m_col.y = 62;
		m_col.x = 2;
		addChild( m_col );
		
		m_btn = new buttonUpDown( new geton_present_normal_but() as Bitmap, new geton_present_press_but() as Bitmap );
		m_btn.x = 45;
		m_btn.y = 68;
		m_btn.Click = onClick;
		addChild( m_btn );
	}
	
	private function onClick():void{
		m_callBack( m_trophy );
	}
	
	override protected function onDestroy():void{
		if ( m_back ){
			m_back.bitmapData.dispose();
			m_back = null;
		}
		if ( m_ico ){
			m_ico.bitmapData.dispose();
			m_ico = null;
		}
	}
	
}

import core.baseObject;
import core.gui.button.stretchButton;
import core.gui.button.TypeButton;

import flash.display.Bitmap;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import game.assets.Assets;
import game.gameplay.artifact.baseArtifact;

class ItmArtifact extends baseObject{
	
	[Embed(source="../../../../ResourcesGame/game/Screens/bins/back_artifact.png")]    
	public static const back_artifact:Class
	

	
	private var m_back:Bitmap;
	private var m_ico:Bitmap;
	private var m_col:TextField;
	private var m_btn:stretchButton;
	private var m_artifact:baseArtifact;
	private var m_callBack:Function;
	
	public function ItmArtifact( artifact:baseArtifact, callBack:Function ){
		
		m_artifact = artifact;
		m_callBack = callBack;
		
		m_back = new back_artifact() as Bitmap;
		addChild( m_back );
		
		m_ico = artifact.Ico;
		m_ico.y = 5;
		addChild( m_ico );
		
		/*
		m_col = new TextField();
		m_col.defaultTextFormat = new TextFormat( "Candara", 18, 0x000000 );
		m_col.mouseEnabled = false;
		m_col.text = 'x100';
		m_col.autoSize = TextFieldAutoSize.LEFT;
		m_col.y = 62;
		m_col.x = 2;
		addChild( m_col );
		*/
		
		//m_btn = new buttonUpDown( Assets.getBitmap( "geton_collect_normal_but" ), Assets.getBitmap( "geton_collect_press_but"), "собрать" );
		m_btn = new stretchButton( TypeButton.SIMPLE_GREEN, 1, "собрать" );
		m_btn.x = 75;
		m_btn.y = 50;
		m_btn.Click = onClick;
		addChild( m_btn );
	}
	
	private function onClick( ):void{
		m_callBack( m_artifact );
	}
	
	override protected function onDestroy():void{
		if ( m_back ){
			m_back.bitmapData.dispose();
			m_back = null;
		}
		if ( m_ico ){
			m_ico.bitmapData.dispose();
			m_ico = null;
		}
	}
	
}


