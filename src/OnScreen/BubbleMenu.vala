//
//  Copyright (C) 2020 Komorebi Team Authors
//  Copyright (C) 2015-2016 Abraham Masri @cheesecakeufo
//
//  This program is free software: you can redistribute it and/or modify it
//  under the terms of the GNU Lesser General Public License version 3, as published
//  by the Free Software Foundation.
//
//  This program is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranties of
//  MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
//  PURPOSE.  See the GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program.  If not, see <http://www.gnu.org/licenses/>

using Clutter;

using Komorebi.Utilities;

namespace Komorebi.OnScreen {

	public enum MenuType {
		DESKTOP,
		ICON

	}

	public class BubbleMenu : Actor {

		BackgroundWindow parent;

		// Horizontal Box Layout
		BoxLayout horizontalBoxLayout = new BoxLayout() {orientation = Orientation.VERTICAL, spacing = 5};

		// Bubble items (Desktop)
		BubbleMenuItem newFolderMenuItem;
		BubbleMenuItem refreshMenuItem;
		BubbleMenuItem pasteMenuItem;
		/*BubbleMenuItem hideAllWindowsMenuItem*/
		BubbleMenuItem changeWallpaperMenuItem;
		BubbleMenuItem preferencesMenuItem;

		// Menu Items (Icon)
		BubbleMenuItem moveToTrashMenuItem;
		BubbleMenuItem copyMenuItem;
		BubbleMenuItem makeAliasMenuItem;
		BubbleMenuItem getInfoMenuItem;

		// Current icon (when right clicked)
		OnScreen.Icon icon;

		// Type of this menu
		MenuType menuType;

		construct {

			// Properties
			opacity = 0;

			layout_manager = horizontalBoxLayout;
			margin_top = 5;
			margin_right = 5;
			margin_left = 20;
			margin_bottom = 5;

		}


		public BubbleMenu (BackgroundWindow parent) {
			this.parent = parent;

			// Desktop items
			newFolderMenuItem = new BubbleMenuItem("新建文件夹");
			refreshMenuItem = new BubbleMenuItem("刷新壁纸");
			pasteMenuItem = new BubbleMenuItem("粘贴");
			changeWallpaperMenuItem = new BubbleMenuItem("更改壁纸");
			preferencesMenuItem = new BubbleMenuItem("桌面设置");

			// icon items
			moveToTrashMenuItem = new BubbleMenuItem("移至回收站");
			copyMenuItem = new BubbleMenuItem("复制路径");
			makeAliasMenuItem = new BubbleMenuItem("创建快捷方式");
			getInfoMenuItem = new BubbleMenuItem("查看信息");

			add_child(moveToTrashMenuItem);
			add_child(copyMenuItem);
			// add_child(makeAliasMenuItem);
			add_child(getInfoMenuItem);
			add_child(newFolderMenuItem);
			add_child(pasteMenuItem);
			add_child(refreshMenuItem);
			add_child(changeWallpaperMenuItem);
			add_child(preferencesMenuItem);

			foreach(Clutter.Actor child in get_children())
				child.visible = false;

			// Signals
			signalsSetup();
		}

		void signalsSetup () {

			newFolderMenuItem.button_press_event.connect(() => {
				parent.desktopIcons.createNewFolder();
				return true;
			});

			pasteMenuItem.button_press_event.connect(() => {
				parent.desktopIcons.copyToDesktop(clipboard.wait_for_text());
				return true;
			});


			refreshMenuItem.button_press_event.connect(() => {

				this.parent.wallpaperFromUrl(webPageUrl);

				return true;
			});

			changeWallpaperMenuItem.button_press_event.connect(() => {

				if(showDesktopIcons)
					parent.desktopIcons.fadeOut();

				fadeOut();

				// Check if preferences window is already visible
				if(canOpenPreferences) {

					canOpenPreferences = false;
					new PreferencesWindow("wallpapers");

				}

				return true;
			});

			preferencesMenuItem.button_press_event.connect(() => {

				// Check if preferences window is already visible
				if(canOpenPreferences) {

					canOpenPreferences = false;
					new PreferencesWindow();

				}
				return true;
			});


			// Icon items
			copyMenuItem.button_press_event.connect(() => {

				// Copy file/folder
				clipboard.set_text(icon.filePath, icon.filePath.length);
				clipboard.store();

				return true;
			});

			moveToTrashMenuItem.button_press_event.connect(() => {

				icon.trash();

				// Move file/folder to trash
				var sourceFile = File.new_for_path(icon.filePath);

				try {
					sourceFile.trash();
				} catch (Error e) {

					print ("Error deleting %s: %s\n", icon.titleName, e.message);
				}

				return true;
			});

			getInfoMenuItem.button_press_event.connect(() => {

				// Display a window with file/directory info
				infoWindow.setInfoFromPath(icon.filePath);
				infoWindow.show_all();

				return true;
			});

		}

		public void setIcon (OnScreen.Icon icon) {

			this.icon = icon;

		}

		public void fadeIn (double x, double y, MenuType menuType) {

			this.menuType = menuType;

			if(menuType == MenuType.ICON) {

				moveToTrashMenuItem.visible = true;
				copyMenuItem.visible = true;
				getInfoMenuItem.visible = true;

			} else {

				// Dim all icons
				foreach (var icon in parent.desktopIcons.iconsList)
					icon.dimIcon();

				// Check if we have anything in the clipboard,
				// if not, disable the 'Paste' menu item
				var clipboardText = clipboard.wait_for_text ();

				if(clipboardText == "" || clipboardText == null) {
					pasteMenuItem.opacity = 10;
					pasteMenuItem.set_reactive(false);
				} else {
					pasteMenuItem.opacity = 255;
					pasteMenuItem.set_reactive(true);
				}

				// Hide 'New Folder' and 'Paste' item if we're not showing icons
				if(showDesktopIcons) {
					newFolderMenuItem.visible = true;
					pasteMenuItem.visible = true;
				}

				// If we have a web page wallpaper, show the 'refresh wallpaper' menu item
				if(wallpaperType == "web_page")
					refreshMenuItem.visible = true;

				changeWallpaperMenuItem.visible = true;
				preferencesMenuItem.visible = true;

			}

			// Make sure we don't display off the screen
			x = double.min(x, screenWidth - (width + 15 * 2));
			y = double.min(y, parent.mainActor.height - (height + 15 * 2));

			opacity = 0;
			this.x = (float)x;
			this.y = (float)y;

			save_easing_state ();
			set_easing_duration (90);
			this.x += 15;
			this.y += 15;
			opacity = 255;
			set_easing_mode (Clutter.AnimationMode.EASE_IN_SINE);
			restore_easing_state ();
		}

		public void fadeOut () {

			save_easing_state ();
			set_easing_duration (90);
			scale_x = 0.9f;
			scale_y = 0.9f;
			opacity = 0;
			set_easing_mode (Clutter.AnimationMode.EASE_IN_SINE);
			restore_easing_state ();

			foreach(Clutter.Actor child in get_children())
				child.visible = false;

			// Undim all icon
			foreach (var icon in parent.desktopIcons.iconsList)
				icon.unDimIcon();

			icon = null;
		}
	}
}
