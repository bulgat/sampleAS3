package game.display.FriendBar
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import core.baseObject;
	import core.gui.guiRoot;
	import core.gui.button.buttonUpDown;
	
	import game.Global;
	import game.display.Lobby.ScreenLobby;
	import game.display.Screens.ScreenFriendAmmunition;
	import game.gameplay.Player;
 
	public class PnlFriendBar extends baseObject
	{
		[Embed(source="../../../../ResourcesGame/game/FriendBar/friendBarBack.png")]        
		public static const friendBarBack:Class;
		
		//кнопки прокрутки вправо
		[Embed(source="../../../../ResourcesGame/game/FriendBar/bright_normal.png")]        
		public static const bright_normal:Class;
		
		[Embed(source="../../../../ResourcesGame/game/FriendBar/bright_press.png")]          
		public static const bright_press:Class;
		
		[Embed(source="../../../../ResourcesGame/game/FriendBar/bright_9_normal.png")] 
		public static const bright_9_normal:Class;
		
		[Embed(source="../../../../ResourcesGame/game/FriendBar/bright_9_press.png")]
		public static const bright_9_press:Class;
		
		[Embed(source="../../../../ResourcesGame/game/FriendBar/bright_normal_end.png")]
		public static const bright_normal_end:Class;
		
		[Embed(source="../../../../ResourcesGame/game/FriendBar/bright_press_end.png")]
		public static const bright_press_end:Class;
		
		//кнопки прокрутки влево
		
		[Embed(source="../../../../ResourcesGame/game/FriendBar/bleft_normal.png")]        
		public static const bleft_normal:Class;
		
		[Embed(source="../../../../ResourcesGame/game/FriendBar/bleft_press.png")]        
		public static const bleft_press:Class;
		
		[Embed(source="../../../../ResourcesGame/game/FriendBar/bleft_9_normal.png")]
		public static const bleft_9_normal:Class;
		
		[Embed(source="../../../../ResourcesGame/game/FriendBar/bleft_9_press.png")]
		public static const bleft_9_press:Class;
		
		[Embed(source="../../../../ResourcesGame/game/FriendBar/bleft_normal_end.png")]
		public static const bleft_normal_end:Class;
		
		[Embed(source="../../../../ResourcesGame/game/FriendBar/bleft_press_end.png")]
		public static const bleft_press_end:Class;
		
		private const COUNT_VISIBLE_ITEM:int = 9;
		
		/**
		 * количество друзей в игре, они формируют отряд!!!!
		 */
		private  static var m_countFrendApl:int =0;
		
		private var m_bPrew:buttonUpDown;
		
		private var m_bNext:buttonUpDown;
		
		private var m_bPrew9:buttonUpDown;
		
		private var m_bNext9:buttonUpDown;
		
		private var m_bPrewEnd:buttonUpDown;
		
		private var m_bNextEnd:buttonUpDown;
		
		private var m_listFriends:Vector.<ItmFriendBar>;
		
		private var m_offset:int = 2;
		
		private var m_position:int = 0;
		
		private var m_visibleRect:Rectangle = new Rectangle( 0,0,100,100);
		
		private var m_iBack:Bitmap;
		
		private var m_sBack:Sprite = new Sprite( );
		
		private var m_pos:int = 0;
		
		private var m_scrolls:int = 0;
		
		private var m_pos9:int = 9;
		
		private var m_scrolls10:int = 0;
		
		private var groupLeft:Sprite = new Sprite( );
		private var groupRight:Sprite = new Sprite( );
		//-высота У иконки друзей (портрет рыцаря)
		private var intendIconFriend_x:int=7;
		private var intendIconFriend_y:int=6;
		//расположение кнопок прокрутки друзей по горизонтали
		private var playScrollFriend_far_x:int= 40;
		private var playScrollFriend_near_x:int= 740;
		//расположение кнопок прокрутки друзей по высоте
		private var playScrollFriend_0_y:int = 15;
		private var playScrollFriend_1_y:int = 40;
		private var playScrollFriend_2_y:int = 65;
		
		public function PnlFriendBar( list:Vector.<String> )
		{
			m_iBack = new friendBarBack() as Bitmap;
			addChild( m_iBack ); 
			addChild( m_sBack );
			y = guiRoot.sizeHeight  - m_iBack.height - 2;//*2+10  ;

			m_bNext = new buttonUpDown( new bright_normal() as Bitmap, new bright_press() as Bitmap, "", 2, 2);
			m_bNext.Click = onNext;
			m_bNext.y = playScrollFriend_0_y;
			m_bNext.x = playScrollFriend_near_x;
			groupLeft.addChild( m_bNext );
			
			m_bNext9 = new buttonUpDown( new bright_9_normal() as Bitmap, new bright_9_press() as Bitmap, "", 2, 2);
			m_bNext9.Click = onNext9;
			m_bNext9.y = playScrollFriend_1_y;
			m_bNext9.x = playScrollFriend_near_x;
			groupLeft.addChild( m_bNext9 );
			
			m_bPrew = new buttonUpDown( new bleft_normal() as Bitmap, new bleft_press() as Bitmap, "", -2, 2);
			m_bPrew.Click = onPrew;
			m_bPrew.y = playScrollFriend_0_y;
			m_bPrew.x = playScrollFriend_far_x + 11;
			addChild( m_bPrew );
			
			m_bPrew9 = new buttonUpDown( new bleft_9_normal() as Bitmap, new bleft_9_press() as Bitmap, "", -2, 2 );
			m_bPrew9.Click = onPrew9;
			m_bPrew9.y = playScrollFriend_1_y;
			m_bPrew9.x = playScrollFriend_far_x;
			addChild( m_bPrew9 );
			
			//end
			m_bNextEnd = new buttonUpDown( new bright_normal_end() as Bitmap, new bright_press_end() as Bitmap, "", 2, 2 );
			m_bNextEnd.Click = onNextEnd;
			m_bNextEnd.y = playScrollFriend_2_y;
			m_bNextEnd.x = playScrollFriend_near_x;
			groupLeft.addChild( m_bNextEnd );
			
			m_bPrewEnd = new buttonUpDown( new bleft_normal_end() as Bitmap, new bleft_press_end() as Bitmap, "", -2, 2 );
			m_bPrewEnd.Click = onPrewEnd;
			m_bPrewEnd.y = playScrollFriend_2_y;
			m_bPrewEnd.x = playScrollFriend_far_x + 1;
			addChild( m_bPrewEnd );
			
			m_listFriends = new Vector.<ItmFriendBar>( );
			
			//onFill( [1,2,3,4,102,154,65,2368,1204,1223,644,12455,5454,2665,35452236,525,6545] );
		
			var sh:Shape = new Shape( ); 
			sh.graphics.lineStyle( 10 , 0 );
			sh.graphics.beginFill( 0,1);
			sh.graphics.drawRect( 80,0 , 655 , 100);
			
			m_visibleRect = new Rectangle( 50 ,0,807,90 );
			
			Global.social.GetUserFriends( Global.FlashVars['viewer_id'], onFill ); 
			
			//onFill( [1,2,3,4,102,154,65,2368,1204,1223,644,12455] );
			
			sh.graphics.endFill();
			m_sBack.addChild( sh );
			m_sBack.mask = sh;
			
			addChild(  groupLeft );			
		}
		

		
		private function onFill( listID:Array ):void{
			
			PnlFriendBar.m_countFrendApl = listID.length;
			
			var iter:String;
			var item:ItmFriendBar;
			var tl:Array = listID;
			var i:int;
			if( tl.length <= this.COUNT_VISIBLE_ITEM ){
				for( i = 0; i< this.COUNT_VISIBLE_ITEM - tl.length ; i++ ){
					tl.push( "-1" );
				}
			}else{
				var ost:int = tl.length%this.COUNT_VISIBLE_ITEM;
				if( ost > 0 ) {
					for( var j:int = 0; j< this.COUNT_VISIBLE_ITEM - ost ; j++){
						tl.push( "-1");
					}
				}
			}	
			
			
			
			for ( i = 0; i < listID.length; i++ ){
				item = new ItmFriendBar( this , listID[i] , ShowFriend );
				m_listFriends.push( item );
				item.x+= intendIconFriend_x+item.width/2+ ( item.width+m_offset )*i; 
				
				item.y = item.height/2+intendIconFriend_y;
				m_sBack.addChild( item ); 
				if( isShow( item ) )
					item.loadAvatar();
			}
			
		
			
			if( m_listFriends.length <= this.COUNT_VISIBLE_ITEM ) 
			{
				m_bNext.Click = m_bPrew.Click = null; 
				m_bNext9.Click = m_bPrew9.Click = null;
			}else{
				m_scrolls = m_listFriends.length - this.COUNT_VISIBLE_ITEM;
				var ost:int = m_listFriends.length%this.COUNT_VISIBLE_ITEM;
			 	if( ost > 0 ) ost = 1;
				m_scrolls10 = m_listFriends.length/this.COUNT_VISIBLE_ITEM+ost;
			}
			
		
		}
		
		private function ShowFriend( uid:String ):void{
			Global.Server.user_getInfoSocID( Global.player.SocID, Global.TypeSoc.Value, onShowFriendGood, onShowFriendBad );
			//onShowFriendGood( {"listDress":{"weapon":"900"}} )
		}
		
		private function onShowFriendGood( response:* ):void{
			Global.screenLobby.ShowScreen( new ScreenFriendAmmunition( response ) );
		}
		
		private function onShowFriendBad( response:* ):void{
			trace('Не удалось показать друга - ',response);
		}
		
		private function onPrew( ):void{
			if( m_pos == 0 ) return;
			m_pos--;	
			for ( var i:int = 0; i < m_listFriends.length; i++ ){
				m_listFriends[i].x+=ItmFriendBar.WIDTH+m_offset;	
				if( isShow( m_listFriends[i] ) )
					m_listFriends[i].loadAvatar();
			}
		}
		
		private function onNext( ):void{
			if( m_pos== m_scrolls ) return; 
			m_pos++;
			for ( var i:int = 0; i < m_listFriends.length; i++ ){
				m_listFriends[i].x-= ItmFriendBar.WIDTH+m_offset;	
				if( isShow( m_listFriends[i] ) )
					m_listFriends[i].loadAvatar();
			}
		}
		
		private function onPrew9( ):void{trace("100 " + m_pos) ;
			if( m_pos == 0 ) return;
			
			var t:int =0;
			if( m_pos <= this.COUNT_VISIBLE_ITEM )
				t = m_pos;//this.COUNT_VISIBLE_ITEM - m_pos; 
			
			m_pos = 0;	
			for ( var i:int = 0; i < m_listFriends.length; i++ ){
				m_listFriends[i].x+=(ItmFriendBar.WIDTH+m_offset)*t;	
				if( isShow( m_listFriends[i] ) )
					m_listFriends[i].loadAvatar();
			}
		}
		
		private function onNext9( ):void{ trace( "ffff "+ m_scrolls);
		//	if( ( m_pos+10 ) == m_scrolls ) return;
			var t:int = 0; trace( "ffff fgg");
			if( m_pos + m_pos9 > m_scrolls ){
				t = m_scrolls - m_pos; 
			}else
				t = this.COUNT_VISIBLE_ITEM;
			m_pos+= t;
			
			for ( var i:int = 0; i < m_listFriends.length; i++ ){
				m_listFriends[i].x-= (ItmFriendBar.WIDTH+m_offset)*t;	
				if( isShow( m_listFriends[i] ) )
					m_listFriends[i].loadAvatar();
			}
		}
		
		private function onPrewEnd( ):void{ trace( "10");
			if( m_pos == 0 ) return;
			var t:int = 0;
			t = m_pos;
			m_pos = 0;	
			for ( var i:int = 0; i < m_listFriends.length; i++ ){
				m_listFriends[i].x+=(ItmFriendBar.WIDTH+m_offset)*t;	
				if( isShow( m_listFriends[i] ) )
					m_listFriends[i].loadAvatar();
			}
		}
		
		private function onNextEnd( ):void{
			if( m_pos== m_scrolls ) return;
			var t:int = 0;
			 t = m_scrolls - m_pos;
			m_pos = m_scrolls;
			
			for ( var i:int = 0; i < m_listFriends.length; i++ ){
				m_listFriends[i].x-= (ItmFriendBar.WIDTH+m_offset)*t;	
				if( isShow( m_listFriends[i] ) )
					m_listFriends[i].loadAvatar();
			}
		}
		
		
		/**
		 * достать количество друзей в игре
		 */
		public static function get CountFriendApl():int{
			return PnlFriendBar.m_countFrendApl;
		}
		
		public function get PosMarket( ):int{
			return m_position;
		}
		
		public function isShow( itm:ItmFriendBar ):Boolean{
			if( itm.x > m_visibleRect.x && itm.x < m_visibleRect.width - itm.width ){
				return true;
			}
			return false;
		}
		
		override protected function onDestroy():void{
			m_iBack.bitmapData.dispose();
			m_iBack = null;
		}
	}
}