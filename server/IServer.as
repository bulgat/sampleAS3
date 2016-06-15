package game.server
{
	import core.social.TypeSocial;

	public interface IServer
	{
		
		/**
		 * инит игрока при подключении 
		 * @param uid     - id из соц сети
		 * @param typeSoc - тип соц сети
		 * @param friends - спислк друзей из соц сети
		 * @param callback - сюда прокинем ответ
		 * @return 
		 * 
		 */		
		function player_init ( uid:String , typeSoc:TypeSocial , friends:Array , callback:Function , failedCallback:Function ):void;
		
		/**
		 * узнать , есть ли у игрока в текущий момент активное действие... штур замка.. атака босса  и тд 
		 * @param uid
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function getInfoActiveAction( uid:String ,  callback:Function , failedCallback:Function ):void;
		
		//   AMMUNITION=====================
		

		/**
		 * продать аммуницию 
		 * @param uid
		 * @param idAmmunit
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function sellAmmunition( uid:String , idAmmunit:String , callback:Function  , failedCallback:Function ):void;
		
		/**
		 * купить слот для аммуниции 
		 * @param uid
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function BuySlot( uid:String ,  callback:Function , failedCallback:Function ):void;
		
		/**
		 * достать список аммуниции игрока по его uid 
		 * @param uid   - id игрока в игре
		 * @param callback 
		 * 
		 */		
		function player_Ammunition  ( uid:String , callback:Function ):void;
		
		/**
		 * Одеваем аммуницию на перса - античит должен работать на серваке/ если чижик читит то тупо не сохраняем результат на самом серваке
		 * @param uid 
		 * @param callback
		 * 
		 */		
		function player_dressAmmunition(  uid:String , ammunitGlobalID:String , callback:Function  , failedCallback:Function ):void;
		
		/**
		 * снимаем аммуницию с игрока 
		 * @param uid
		 * @param ammunitGlobalID
		 * @param callback
		 * 
		 */		
		function player_takeOffAmmunition( uid:String , ammunitGlobalID:String , callback:Function , failedCallback:Function ):void;
		
		
		/**
		 * достать инфу о юзвере по его UID 
		 * @param uid
		 * @param field
		 * 
		 */		
		function user_getInfo( uid:String , field:Array , callback:Function  , failedCallback:Function ):void;
		
		/**
		 * достать инфу по ид из социалки + типу социалки/ справделиво для быстрого доставания инфы о игровых друзьях 
		 * @param uid - ид соц сети
		 * @param typeSoc - тип социалки
		 * @param callback 
		 * @param failedCallback
		 * 
		 */		
		function user_getInfoSocID( uid:String , typeSoc:String , callback:Function  , failedCallback:Function  ) :void;
		
		/**
		 * Забрать ресурсы с хоз постройки 
		 * @param uid  		 - внутренний ID игрока
		 * @param idVillage  - id деревни
		 * @param idOuthouse - id хозпостройки 
		 * 
		 */		
		function TakeResources( uid:String , idVillage:int , idOuthouse:int , callback:Function  , failedCallback:Function ):void;
		
		//Закончить производство немедленно
		function ForceEndProduction( uid:String , idVillage:int , idOuthouse:int, callback:Function  , failedCallback:Function ):void;
		
		/**
		 * Обновить хоз постройку 
		 * @param uid        - внутренний ид игрока
		 * @param idVillage  - ид деревни
		 * @param idOuthouse - ид хозпостройки 
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function UpgradeOuthouse( uid:String , idVillage:int , idOuthouse:int ,  callback:Function  , failedCallback:Function ):void;
		
		/**
		 * Покупка какой либо шмотки 
		 * @param uid - ид юзера
		 * @param idAmmunition - ид аммуниции
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function BuyAmmunition( uid:String , idAmmunition:int ,  callback:Function  , failedCallback:Function):void;
		
		//сорвать цветок в саду
		function GetFlower( uid:String, typeFlower:String, callback:Function, failedCallback:Function ):void;
		
		
		//повреждение и ремонт оружия!!!!
		//команда повредения оружия на клиенте сейчас реализованна только для теста!!! В релизе на клиенте она работать не будет!!!!!!!
		//сейчас все оружие ровреждается на 5 единиц
		
		/**
		 * Повредить оружие 
		 * @param uid - ид игрока которому хотим повредить
		 * @param idAmmunit - ид аммуниции , подлежащей порче
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function DamageAmmunition( uid:String , idAmmunit:String ,callback:Function, failedCallback:Function ):void;
		
		/**
		 * отремонтировать оружие / перед ремонтом проверяется а есть ли у игрока необходимые ресрсы
		 * @param uid - ид игрока которому хотим повредить
		 * @param idAmmunit - ид аммуниции , подлежащей ремонту
		 * @param callback
		 * @param failedCallback
		 * 
		 */	
		function RepairAmmunition( uid:String , idAmmunit:String ,callback:Function, failedCallback:Function ):void;
		
		/**
		 * Купить ресурс 
		 * @param uid - внутренний ид игрока
		 * @param idConsumed - ид ресурса
		 * @param count - количество ресурса к покупке
		 * 
		 */		
		function BuyConsumed( uid:String , idConsumed:int , count:int ,callback:Function, failedCallback:Function):void;
		
		/**
		 * получить информацию о саде игрока 
		 * @param uid - внутренний ид игрока
		 * 
		 */		
		function getInfoGarden( uid:String ,callback:Function, failedCallback:Function):void;
		
		/**
		 * найти противника для игрока  
		 * @param uid - внутренний ид игрока для которого ищем противника
		 * 
		 */		
		function FindEnemy( uid:String , callback:Function , failedCallback:Function ):void;
	
		
		/**
		 * применить трофей 
		 * @param uid  - ид игрока , которому применяем трофей
		 * @param trophyId - ид (глобальный ) трофея
		 * @param callback 
		 * @param failedCallback
		 * 
		 */		
		function applyTrophy( uid:String , trophyId:int , callback:Function , failedCallback:Function ):void; 
		
		/**
		 * применить зелье длительного действия для игрока!!! Вызывать только из окна сос писком зельев
		 * для применние зельев из боевки с босом другой вызов без подъема окна соединения с сервером 
		 * @param uid - ид игрока , который применяет зелье
		 * @param idPotion - ид зелья
		 * @param callback 
		 * @param failedCallback
		 * 
		 */		
		function UsePotionForHeroes( uid:String , idPotion:int ,  callback:Function , failedCallback:Function ):void;
		
		/**
		 * покупка игрокаом зелья 
		 * @param uid - ид игрока, который покупает зелье
		 * @param idPotion - ид зелья
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function BuyPotion( uid:String , idPotion:int ,  callback:Function , failedCallback:Function ):void;
		
		/**
		 * собрать артифакт из трофеев 
		 * @param uid  ид юзера , который хочет собрать
		 * @param artifact_id - ид артифакта , который собирает
		 * @param callback 
		 * @param failedCallback
		 * 
		 */		
		function CollectionArtifact( uid:String , artifact_id:int , callback:Function , failedCallback:Function ):void;
		
		/**
		 * создать зелье 
		 * @param uid - юзер который создает зелье
		 * @param potionID - ид зелья
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function createPotion( uid:String , potionID:int , callback:Function , failedCallback:Function ):void;
		
		
		/**
		 * получить информацию о состоянии зельев игрока 
		 * @param uid - ид игрока
		 * @param callback 
		 * @param failedCallback
		 * 
		 */		
	    function getInfoPotion( uid:String  , callback:Function , failedCallback:Function ):void;
		
		
		
		/**
		 * добавить трофей игроку!!! ФУНКЦИЯ ТОЛЬКО ДЛЯ РУЧНОГО ДОБАВЛЕНИЯ ЧЕРЕЗ КОНСОЛЬ!!!!!!! 
		 * @param uid - ид игрока , которому добавить надо трофей
		 * @param idTrophy - ид трофея
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function addTrophy( uid:String , idTrophy:int , callback:Function , failedCallback:Function ):void;
		
		/**
		 * Форсировать приготовление зелья 
		 * @param uid - ид игрока , который форсирует приготовление зелья
		 * @param idPotion - ид зелья, производство которого хотим завершить
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function ForceCompletePotion( uid:String , idPotion:int , callback:Function , failedCallback:Function ):void;
		
		/**
		 *  Игрок хочет забрать , то что произвел алхимик 
		 * @param uid - ид игрока  , который забирает
		 * @param idPotion - ид зелья , которое надо забрать
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function TakePotion( uid:String , idPotion:int , callback:Function , failedCallback:Function ):void;
		//==================CLANS
		/**
		 * создать клан / игрок хочет создать клан / за это снимутся деньги
		 * @param uid - ид игрока , который создает клан
		 * @param nameClan - имя клана
		 * @callback  - при удачном создании клана в callback вернется {"idClan":x , "gold_coin":100}
		 * где X ид клана , который присвоится клану при создании
		 * gold_coin - стоимость создания клана
		 */		
		function CreateClan( uid:String , nameClan:String , callback:Function , failedCallback:Function ):void;
		
		
		/**
		 * Удалить клан / Клан расспустить может только игрок , который его создал 
		 * @param uid - ид игрока , владельца клана
		 * @param idClan - ид клана
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function KillClan( uid:String , idClan:int , callback:Function , failedCallback:Function ):void;
		
		/**
		 * Вступить в клан 
		 * @param uid    - ид игрока , который хочет вступить в клан
		 * @param idClan - ид клана, в который вступает
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function JoinClan( uid:String , idClan:int , callback:Function , failedCallback:Function ):void;
		
		
		/**
		 * Выйти из клана 
		 * @param uid - ид игрока , который хочет выйти из клана
		 * @param idClan  - ид клана из которого выходят
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function ExitKlan(  uid:String , idClan:int , callback:Function , failedCallback:Function ):void;
		
		//=================storm==============
		
		/**
		 * применить супер атаку к замку 
		 * @param uid - ид игрока , который штурмует
		 * @param idCastle - ид замка, который атакуют
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function applySuperAttack( uid:String , idCastle:int , callback:Function , failedCallback:Function ):void;
		
		/**
		 * применить асадное орудие 
		 * @param uid - ид игрока
		 * @param idCastle - ид замка
		 * @param idSiegeWeapon - ид осадного орудия
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function applySiegeWeapon( uid:String , idCastle:int , idSiegeWeapon:int , callback:Function , failedCallback:Function ):void;
		
		/**
		 * применить активное действие отрядом , в лоб , сзади с флангов
		 * @param uid
		 * @param idCastle
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function applyActionSquad( uid:String , idCastle:int ,  callback:Function , failedCallback:Function ):void;
		
		/**
		 *  достать информацию , о владельцах замка. те которые успели их  нагнуть
		 * @return 
		 * 
		 */		
		function getInfoOwnerCastle(   callback:Function , failedCallback:Function):void;
		
		/**
		 * достать информацию, о штурмах игрока 
		 * @param uid ид игрока
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		//function getInfoStorm ( uid:String  ,  callback:Function , failedCallback:Function ):void;
		
		/**
		 * снять осаду с замка 
		 * @param uid - ид игрока
		 * @param idCastle - ид замка
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function CancelStorm( uid:String , idCastle:int ,   callback:Function , failedCallback:Function ):void;
		
		/**
		 * начало штурма замка 
		 * @param uid - ид юзера
		 * @param idCastle - ид замка
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function StartStorm( uid:String , idCastle:int ,   callback:Function , failedCallback:Function ):void;
		
		/**
		 * Достать информацию о штурме замка. Есть ли награда / загнул ли его 
		 * @param uid
		 * @param idCastle
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function getInfoStateCastle( uid:String , idCastle:int ,   callback:Function , failedCallback:Function ):void;
		
		
		/**
		 * попросить награду за штурм замка 
		 * @param uid
		 * @param idCastle
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function getAwardStorm( uid:String , idCastle:int ,   callback:Function , failedCallback:Function ):void;
		
		//GENERATE WEAPON
		function getInfoGenerateWeapon(  callback:Function , failedCallback:Function):void;
		
		
		
		///РЫНОК
		/**
		 * забрать с рынка , определенное количество монет 
		 * @param uid - ид юзера
		 * @param countCoin - количество монет , которое собирает
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function TakeCoinRialto(uid:String , countCoin:int ,   callback:Function , failedCallback:Function ):void;
		
		/**
		 * Достать информацию, есть ли что на рынке. Метод нуден , когда юзер в игре , а время на генерацию вышло
		 * дергаем сервер , и он скажет что мы там на генерели юзеру
		 * клиент уведомлялку показывает , о том что есть что то  
		 * @param uid -ид юзера
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function getInfoRialto( uid:String ,  callback:Function , failedCallback:Function ):void;
		
		
		//======BATTLE с босом и телохранителями
		
		function getInfoBoss( callback:Function , failedCallback:Function ):void;
		
		/**
		 *  покинуть поединок с босом
		 * @param uid - ид игрока
		 * @param callback
		 * @param failedCallback
		 * 
		 */
		function leaveBattleBoss( uid:String  ):void;
		
		/**
		 * получить информацию о поединках с босом для игрока 
		 * @param uid - ид игрока
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function getInfoBattle ( uid:String , callback:Function , failedCallback:Function ):void;
		
		/**
		 * начать битву с боссом 
		 * @param uid - ид юзера
		 * @param bossID - ид боса с которым будем биться
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function StartBattleBoss( uid:String , bossID:String , callback:Function , failedCallback:Function ):void;
		
		/**
		 * нанести урон боссу оружием 
		 * @param uid - ид  юзера
		 * @param callback
		 * @param failedCallback
		 */		
		function HarmWeaponsBoss( uid:String , callback:Function , failedCallback:Function ):void;
		
		
		//===================SMITHY==================
		
		/**
		 * Заказать оружие у кузнеце 
		 * @param uid - ид игрока
		 * @param idAmmunit - ид аммуниции к изготовлению
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function CreateWeaponSmithy( uid:String , idAmmunit:String , callback:Function , failedCallback:Function ):void;
		
		/**
		 * забрать оружие у кузнеца 
		 * @param uid
		 * @param idAmmunit
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function TakeWeaponSmithy( uid:String , idAmmunit:String ,  callback:Function , failedCallback:Function ):void;
		
		/**
		 * форсировать изготовление  jhe;bz e repytwf
		 * @param uid
		 * @param idAmmunit
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function ForceCreateWeaponSmithy( uid:String , idAmmunit:String ,  callback:Function , failedCallback:Function ):void;
		
		/**
		 * ремонт оружия в кузне!!! Этот ремонт не мгновенный!!!!!! 
		 * @param uid - ид юзера
		 * @param idAmmunit
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function RepairAmmunitionSmithy( uid:String , idAmmunit:String ,  callback:Function , failedCallback:Function ):void;
		
		/**
		 * Забрать из ремонта у кузнеца оружие которое ложили на ремонт 
		 * @param uid
		 * @param idAmmunit
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function TakeReapirSmithy ( uid:String , idAmmunit:String ,  callback:Function , failedCallback:Function ):void;
		
		/**
		 * Форсировать ремонт у кузнеца 
		 * @param uid
		 * @param idAmmunit
		 * @param callback
		 * @param failedCallback
		 * 
		 */		
		function ForceRepairWeaponSmity( uid:String , idAmmunit:String ,  callback:Function , failedCallback:Function ):void;
		
	}
}