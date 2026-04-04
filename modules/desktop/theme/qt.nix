{
  nixosModule = { lib, user, ... }: {
    environment.overlay.users.${user}.qt6ct_conf = {
      target = lib.c "qt6ct/qt6ct.conf";
      text = lib.generators.toINI {} {
        Appearance = {
          custom_palette = false;
          icon_theme = "Tela-blue";
          standard_dialogs = "default";
        };

        Fonts = {
          fixed = ''"Source Han Mono SC,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
          general = ''"Source Han Sans SC,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
        };

        Interface = {
          activate_item_on_single_click = 1;
          buttonbox_layout = 2;
          cursor_flash_time = 1000;
          dialog_buttons_have_icons = 0;
          double_click_interval = 400;
          gui_effects = "General, FadeMenu, AnimateCombo, FadeTooltip, AnimateToolBox";
          keyboard_scheme = 3;
          menus_have_icons = true;
          show_shortcuts_in_context_menus = true;
          toolbutton_style = 4;
          underline_shortcut = 1;
          wheel_scroll_lines = 3;
        };
      };
    };
  };

  homeModule = { home, pkgs, ... }: {
    home.packages = with pkgs; [
      kdePackages.qt6ct
      kdePackages.qtstyleplugin-kvantum
    ];

    home.sessionVariables = {
      QT_QPA_PLATFORMTHEME = "qt6ct";
      QT_QPA_PLATFORM = "wayland";
    };
  };
}
