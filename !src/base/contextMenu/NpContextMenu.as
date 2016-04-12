﻿/* AS3* Copyright 2008 noponies.*/package base.contextMenu {	import flash.ui.ContextMenu;	import flash.ui.ContextMenuItem;	import flash.ui.ContextMenuBuiltInItems;	import flash.events.ContextMenuEvent;	import flash.display.InteractiveObject;	import flash.events.EventDispatcher;		/**	*	The NpContextMenu Class is a utility class for creating Custom Contextual menus easily. With simple control over the menu items interactivity. Please see the various public methods and	*	properties for useage.	*	@langversion ActionScript 3.0	*	@Flash Player 9.0.28.0	*	@author noponies - 2008	*   @version 1.0	*	@see #addMenuItem()	*	@see #removeMenuItem()	*	@see #hideMenuItem()	*	@see #showMenuItem()	*		*/	public class NpContextMenu extends EventDispatcher {		private var customCM:ContextMenu;//the custom menu		private var target:InteractiveObject;		private var selectedMenuItem:String		/**		*	@langversion ActionScript 3.0		*	@playerversion	Flash 9		 *	Get the current menuitems label which is a string		 *	@return String representing the <code>label</code> value of the current menu item.		 */		public function get selectedMenu():String {			return selectedMenuItem;		}		/**		*	@langversion ActionScript 3.0		*	@playerversion	Flash 9		 *	Get the current menuitems within the entire contextual menu		 *	@return Array representing all of the current contextual menu items.		 */		public function get currentMenuItems():Array {			return customCM.customItems;		}				/**		*	@langversion ActionScript 3.0		*	@playerversion	Flash 9		 *	The NpContextMenu Class requires one parameter to be set via a constructor argument. This is a reference to the DisplayObject you want the contextual menu item to be active on.		 *	@param target InteractiveObject representing the target DisplayObject you want the menu item to be active on.		*	@see #addMenuItem()		*	@see #removeMenuItem()		*	@see #hideMenuItem()		*	@see #showMenuItem()		 *	@return void		 */		public function NpContextMenu(target:InteractiveObject) {			this.target = target			customCM = new ContextMenu();			removeDefaultItems();			target.contextMenu = customCM;		}		//--------------------------------------		// PRIVATE INSTANCE METHODS		//--------------------------------------		//clean out the built in items		private function removeDefaultItems():void {			customCM.hideBuiltInItems();		}		//dispatch the menu select event 		private function dispatchMenuEvent(event:ContextMenuEvent):void{			selectedMenuItem = event.target.caption			dispatchEvent(event)		}		//--------------------------------------		// PUBLIC INSTANCE METHODS		//--------------------------------------		/**		*	@langversion ActionScript 3.0		*	@playerversion	Flash 9		 *	This function creates a new menu item within the current contextual menu. 		 *	@param menuLabel String representing the label of the menu item.		 *	@param separatorBefore Boolean representing whether or not you want a seperator line in the contextual menu before this new menu item.		 *	@return void		 */		public function addMenuItem(menuLabel:String,separatorBefore:Boolean):void{				var newCm:ContextMenuItem = new ContextMenuItem(menuLabel, separatorBefore);				newCm.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, dispatchMenuEvent);				customCM.customItems.push(newCm);		}		/**		*	@langversion ActionScript 3.0		*	@playerversion	Flash 9		 *	This function will remove an item from the current contextual menu.   		 *	@param menuLabel String representing the label of the menu item you would like to remove.		 *	@return void		 */		public function removeMenuItem(menuLabel:String):void{			var currentMenuItemsArray:Array = customCM.customItems				for(var i:Object in currentMenuItemsArray) {			           if(currentMenuItemsArray[i].caption==menuLabel){						currentMenuItemsArray[i].removeEventListener(ContextMenuEvent.MENU_ITEM_SELECT, dispatchMenuEvent);						customCM.customItems.splice(i, 1)						break;					}			    }					}		/**		*	@langversion ActionScript 3.0		*	@playerversion	Flash 9		 *	This function will disable an item in the current contextual menu. The item will still be visible, it just wont be selectable.		 *	@param itemToDisable String representing the label of the menu item you would like to disable.		 *	@return void		 */		public function hideMenuItem(itemToDisable:String):void{				var currentMenuItemsArray:Array = customCM.customItems;				for (var i:Object in currentMenuItemsArray) {					if (currentMenuItemsArray[i].caption==itemToDisable) {						customCM.customItems[i].enabled = false;						break;					}				}		}		/**		*	@langversion ActionScript 3.0		*	@playerversion	Flash 9		 *	This function will enable a disabled item in the current contextual menu.		 *	@param itemToEnable String representing the label of the menu item you would like to enable.		 *	@return void		 */		public function showMenuItem(itemToEnable:String):void {			var currentMenuItemsArray:Array = customCM.customItems;			for (var i:Object in currentMenuItemsArray) {				if (currentMenuItemsArray[i].caption==itemToEnable) {					customCM.customItems[i].enabled = true;					break;				}			}		}	}}