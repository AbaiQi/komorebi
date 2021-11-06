//
//  Copyright (C) 2020 Komorebi Team Authors
//  Copyright (C) 2017-2018 Abraham Masri @cheesecakeufo
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

using Gtk;
using Gdk;

namespace WallpaperCreator.OnScreen {

    public class OptionsPage : Box {

        // Contains the wallpaper image with buttons
        Gtk.Box wallpaperBox = new Box(Orientation.VERTICAL, 10);
        Overlay overlay = new Overlay();
        Image wallpaperImage = new Image();
        Box dateTimeBox = new Box(Orientation.VERTICAL, 5);
        Label timeLabel = new Label("");
        Label dateLabel = new Label("");
        Image assetImage = new Image();

        // List of long options
        ScrolledWindow scrolledWindow = new ScrolledWindow(null, null);
        Box optionsBox = new Box(Orientation.VERTICAL, 10);

        Label wallpaperTitleLabel = new Label("");

        ComboBoxText wallpaperParallaxComboBox = new ComboBoxText();

        Label dateTimeTitleLabel = new Label("") {margin_top = 15};

        ComboBoxText dateTimeVisibleComboBox = new ComboBoxText();

        ComboBoxText dateTimeParallaxComboBox = new ComboBoxText();

        Label dateTimeMarginsLabel = new Label("边缘:");
        Grid dateTimeMarginsGrid = new Grid();
        SpinButton  dateTimeMarginLeftEntry = new SpinButton.with_range(0,2000, 5);
        SpinButton dateTimeMarginRightEntry = new SpinButton.with_range(0,2000, 5);
        SpinButton dateTimeMarginTopEntry = new SpinButton.with_range(0,2000, 5);
        SpinButton dateTimeMarginBottomEntry = new SpinButton.with_range(0,2000, 5);

        Label dateTimePositionLabel = new Label("位置:");
        ComboBoxText dateTimePositionComboBox = new ComboBoxText();

        Label dateTimeAlignmentLabel = new Label("对齐:");
        ComboBoxText dateTimeAlignmentComboBox = new ComboBoxText();

        ComboBoxText dateTimeAlwaysOnTopComboBox = new ComboBoxText();

        Label dateTimeColorLabel = new Label("颜色和Alpha:");
        Box dateTimeColorBox = new Box(Orientation.HORIZONTAL, 10);
        ColorButton dateTimeColorButton = new ColorButton.with_rgba({222, 222, 222, 255});
        SpinButton dateTimeAlphaEntry = new SpinButton.with_range(0, 255, 1) { value = 255 };

        Label dateTimeShadowColorLabel = new Label("阴影颜色和Alpha:");
        Box dateTimeShadowColorBox = new Box(Orientation.HORIZONTAL, 10);
        ColorButton dateTimeShadowColorButton = new ColorButton.with_rgba({222, 222, 222, 255});
        SpinButton dateTimeShadowAlphaEntry = new SpinButton.with_range(0, 255, 1) { value = 255 };

        Label timeFontLabel = new Label("时间字体:");
        FontButton timeFontButton = new FontButton.with_font("Lato Light 30") { use_font = true };

        Label dateFontLabel = new Label("日期字体:");
        FontButton dateFontButton = new FontButton.with_font("Lato Light 20") { use_font = true };

        // Asset (Layer)
        Label assetTitleLabel = new Label("") {margin_top = 15};

        ComboBoxText assetVisibleComboBox = new ComboBoxText();

        Label assetAnimationLabel = new Label("动画模式和速度:");
        Box assetAnimationBox = new Box(Orientation.HORIZONTAL, 10);
        ComboBoxText assetModeComboBox = new ComboBoxText();
        SpinButton assetSpeedEntry = new SpinButton.with_range(100, 1000, 1);

        public OptionsPage() {

            spacing = 10;
            orientation = Orientation.HORIZONTAL;
            halign = Align.CENTER;
            valign = Align.CENTER;
            hexpand = true;
            vexpand = true;

            wallpaperBox.margin = 20;
            wallpaperBox.margin_end = 0;
            wallpaperBox.valign = Align.CENTER;
            wallpaperBox.halign = Align.START;

            dateTimeBox.hexpand = true;
            dateTimeBox.vexpand = true;
            dateTimeBox.halign = Align.CENTER;
            dateTimeBox.valign = Align.CENTER;

            scrolledWindow.hscrollbar_policy = PolicyType.NEVER;

            optionsBox.margin = 20;
            optionsBox.margin_start = 0;
            optionsBox.halign = Align.START;
            optionsBox.hexpand = true;

            wallpaperTitleLabel.set_markup("<span font='WenQuanYi Zen Hei 15'>壁纸选项:</span>");

            wallpaperParallaxComboBox.append("enable", "启用视差");
            wallpaperParallaxComboBox.append("disable", "禁用视差");
            wallpaperParallaxComboBox.active = 1;

            dateTimeTitleLabel.set_markup("<span font='WenQuanYi Zen Hei 15'>日期和时间选项:</span>");

            dateTimeVisibleComboBox.append("show", "显示日期和时间");
            dateTimeVisibleComboBox.append("hide", "隐藏日期和时间");
            dateTimeVisibleComboBox.active = 0;

            dateTimeParallaxComboBox.append("enable", "启用视差");
            dateTimeParallaxComboBox.append("disable", "禁用视差");
            dateTimeParallaxComboBox.active = 1;

            dateTimePositionComboBox.append_text("Top Left");
            dateTimePositionComboBox.append_text("Top Center");
            dateTimePositionComboBox.append_text("Top Right");
            dateTimePositionComboBox.append_text("Center Left");
            dateTimePositionComboBox.append_text("Center");
            dateTimePositionComboBox.append_text("Center Right");
            dateTimePositionComboBox.append_text("Bottom Left");
            dateTimePositionComboBox.append_text("Bottom Center");
            dateTimePositionComboBox.append_text("Bottom Right");
            dateTimePositionComboBox.active = 4;

            dateTimeAlignmentComboBox.append_text("Start");
            dateTimeAlignmentComboBox.append_text("Center");
            dateTimeAlignmentComboBox.append_text("End");
            dateTimeAlignmentComboBox.active = 1;

            dateTimeAlwaysOnTopComboBox.append("enable", "始终显示在上面");
            dateTimeAlwaysOnTopComboBox.append("disable", "显示在层下");
            dateTimeAlwaysOnTopComboBox.active = 0;

            assetTitleLabel.set_markup("<span font='WenQuanYi Zen Hei 15'>图层选项:</span>");

            assetVisibleComboBox.append("show", "显示图层");
            assetVisibleComboBox.append("hide", "隐藏图层");
            assetVisibleComboBox.active = 0;


            assetModeComboBox.append("noanimation", "没有动画");
            assetModeComboBox.append("light", "闪亮登场");
            assetModeComboBox.append("clouds", "云层移动");
            assetModeComboBox.active = 0;

            // Signals
            wallpaperParallaxComboBox.changed.connect(() => updateUI());
            dateTimeVisibleComboBox.changed.connect(() => updateUI());
            dateTimeParallaxComboBox.changed.connect(() => updateUI());
            dateTimeMarginTopEntry.changed.connect(() => updateUI());
            dateTimeMarginRightEntry.changed.connect(() => updateUI());
            dateTimeMarginLeftEntry.changed.connect(() => updateUI());
            dateTimeMarginBottomEntry.changed.connect(() => updateUI());
            dateTimePositionComboBox.changed.connect(() => updateUI());
            dateTimeAlignmentComboBox.changed.connect(() => updateUI());
            dateTimeColorButton.color_set.connect(() => updateUI());
            dateTimeAlphaEntry.changed.connect(() => updateUI());
            timeFontButton.font_set.connect(() => updateUI());
            dateFontButton.font_set.connect(() => updateUI());

            // Add widgets
            dateTimeBox.add(timeLabel);
            dateTimeBox.add(dateLabel);

            overlay.add(wallpaperImage);
            overlay.add_overlay(dateTimeBox);
            overlay.add_overlay(assetImage);

            wallpaperBox.add(overlay);

            dateTimeMarginsGrid.attach(dateTimeMarginTopEntry, 0, 0);
            dateTimeMarginsGrid.attach(dateTimeMarginRightEntry, 0, 1);
            dateTimeMarginsGrid.attach(dateTimeMarginLeftEntry, 1, 0);
            dateTimeMarginsGrid.attach(dateTimeMarginBottomEntry, 1, 1);

            if(wallpaperType == "image") {
                optionsBox.add(wallpaperTitleLabel);
                optionsBox.add(wallpaperParallaxComboBox);
            }

            optionsBox.add(dateTimeTitleLabel);

            optionsBox.add(dateTimeVisibleComboBox);
            optionsBox.add(dateTimeParallaxComboBox);

            optionsBox.add(dateTimePositionLabel);
            optionsBox.add(dateTimePositionComboBox);

            optionsBox.add(dateTimeMarginsLabel);
            optionsBox.add(dateTimeMarginsGrid);

            optionsBox.add(dateTimeAlignmentLabel);
            optionsBox.add(dateTimeAlignmentComboBox);

            optionsBox.add(dateTimeAlwaysOnTopComboBox);

            // Date time
            optionsBox.add(dateTimeColorLabel);

            dateTimeColorBox.add(dateTimeColorButton);
            dateTimeColorBox.add(dateTimeAlphaEntry);

            optionsBox.add(dateTimeColorBox);

            // Date time shadow
            optionsBox.add(dateTimeShadowColorLabel);

            dateTimeShadowColorBox.add(dateTimeShadowColorButton);
            dateTimeShadowColorBox.add(dateTimeShadowAlphaEntry);

            optionsBox.add(dateTimeShadowColorBox);

            // Time Font
            optionsBox.add(timeFontLabel);
            optionsBox.add(timeFontButton);

            // Date Font
            optionsBox.add(dateFontLabel);
            optionsBox.add(dateFontButton);



            if(wallpaperType == "image") {

                optionsBox.add(assetTitleLabel);
                optionsBox.add(assetVisibleComboBox);
                optionsBox.add(assetAnimationLabel);
                assetAnimationBox.add(assetModeComboBox);
                assetAnimationBox.add(assetSpeedEntry);
                optionsBox.add(assetAnimationBox);
            }

            scrolledWindow.add(optionsBox);

            pack_start(wallpaperBox);
            pack_start(scrolledWindow);

            // Post-show options
            setDateTimeLabel();

            foreach(var child in optionsBox.get_children())
                child.halign = Align.START;
        }

        public void updateUI () {


            wallpaperParallax = wallpaperParallaxComboBox.get_active_id() == "enable";

            showDateTime = dateTimeVisibleComboBox.get_active_id() == "show";
            dateTimeParallax = dateTimeParallaxComboBox.get_active_id() == "enable";

            marginTop = dateTimeMarginTopEntry.text.to_int();
            marginRight = dateTimeMarginRightEntry.text.to_int();
            marginLeft = dateTimeMarginLeftEntry.text.to_int();
            marginBottom = dateTimeMarginBottomEntry.text.to_int();

            dateTimeBox.opacity = showDateTime ? 255 : 0;
            dateTimeBox.visible = false;

            // Margins
            dateTimeBox.margin_top = marginTop;
            dateTimeBox.margin_end = marginRight;
            dateTimeBox.margin_start = marginLeft;
            dateTimeBox.margin_bottom = marginBottom;

            setPosition();
            setAlignment();

            dateTimeAlwaysOnTop = dateTimeAlwaysOnTopComboBox.get_active_id() == "enable";

            setColor();
            setFonts();
            setOpacity();

            showAsset = assetVisibleComboBox.get_active_id() == "show";
            assetImage.opacity = showAsset ? 255 : 0;

            setAnimationMode();
            animationSpeed = assetSpeedEntry.text.to_int();

            setDateTimeLabel(dateTimeColor, timeFont, dateFont);
            show_all();
        }

        public void setPosition() {

            var active = dateTimePositionComboBox.get_active_text();

            position = active.replace(" ", "_").down();

            switch (active) {

                case "Top Left":
                    dateTimeBox.halign = Align.START;
                    dateTimeBox.valign = Align.START;
                break;
                case "Top Center":
                    dateTimeBox.halign = Align.CENTER;
                    dateTimeBox.valign = Align.START;
                break;
                case "Top Right":
                    dateTimeBox.halign = Align.END;
                    dateTimeBox.valign = Align.START;
                break;
                case "Center Right":
                    dateTimeBox.halign = Align.END;
                    dateTimeBox.valign = Align.CENTER;
                break;

                case "Center":
                    dateTimeBox.halign = Align.CENTER;
                    dateTimeBox.valign = Align.CENTER;
                break;

                case "Center Left":
                    dateTimeBox.halign = Align.START;
                    dateTimeBox.valign = Align.CENTER;
                break;

                case "Bottom Right":
                    dateTimeBox.halign = Align.END;
                    dateTimeBox.valign = Align.END;
                break;

                case "Bottom Center":
                    dateTimeBox.halign = Align.CENTER;
                    dateTimeBox.valign = Align.END;
                break;

                case "Bottom Left":
                    dateTimeBox.halign = Align.START;
                    dateTimeBox.valign = Align.END;
                break;

                default:
                break;
            }
        }


        public void setAlignment() {

            alignment = dateTimeAlignmentComboBox.get_active_text().down();

            if(alignment == "start")
                timeLabel.halign = Align.START;
            else if(alignment == "center")
                timeLabel.halign = Align.CENTER;
            else
                timeLabel.halign = Align.END;
        }

        private void setColor() {

            RGBA rgba = dateTimeColorButton.rgba;
            dateTimeColor = rgbaToHex(rgba);

            rgba = dateTimeShadowColorButton.rgba;
            shadowColor = rgbaToHex(rgba);
        }

        private void setFonts() {

            timeFont = timeFontButton.get_font_name ();
            dateFont = dateFontButton.get_font_name ();
        }

        private void setOpacity() {

            var alpha = dateTimeAlphaEntry.text.to_double();
            timeLabel.opacity = dateLabel.opacity = alpha / 255;
            dateTimeAlpha = (int) alpha;

            alpha = dateTimeShadowAlphaEntry.text.to_int();
            shadowAlpha = (int)alpha;
        }

        public void setImage(string path) {

            wallpaperImage.pixbuf = new Pixbuf.from_file_at_scale(path, 600, 400, true);
        }

        public void setBlank() {

            wallpaperImage.pixbuf = new Pixbuf.from_resource_at_scale("/org/komorebi-team/komorebi/blank.svg", 600, 400, true);
        }

        public void setAsset(string path) {

            assetImage.pixbuf = new Pixbuf.from_file_at_scale(path, 600, 400, true);
        }

        public void setAnimationMode() {

            animationMode = assetModeComboBox.get_active_id();

        }

        private void setDateTimeLabel(string color = "white", string timeFont = "Lato Light 30",
                                      string dateFont = "Lato Light 20") {

            timeLabel.set_markup(@"<span color='$color' font='$timeFont'>10:21 PM</span>");
            dateLabel.set_markup(@"<span color='$color' font='$dateFont'>Sunday, August 22</span>");
        }

        private string rgbaToHex(RGBA rgba) {
            return "#%02x%02x%02x".printf((int)(rgba.red*255), (int)(rgba.green*255), (int)(rgba.blue*255));
        }
    }
}
