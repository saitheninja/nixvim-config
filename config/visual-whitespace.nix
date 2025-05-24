{
  plugins = {
    visual-whitespace = {
      enable = true; # display whitespace characters in visual mode

      # don't know why this doesn't work
      # settings = {
      #   highlight = {
      #     bg = "#3c4048";
      #     fg = "#7b8496";
      #   };
      # };

      luaConfig.post = # lua
        ''
          vim.api.nvim_set_hl(0, "VisualNonText", { fg = "#7b8496", bg = "#3c4048"})
        '';
    };
  };

  #     vim.keymap.set({ 'n', 'v' }, "<leader>tw", require("visual-whitespace").toggle, {})
  # keymaps = [
  #   {
  #     action = "<Cmd>VisualWhitespace toggle<CR>"; # command isn't loaded?
  #     key = "<leader>ww";
  #     mode = [
  #       "n"
  #       "v"
  #     ];
  #     options = {
  #       desc = "visual-whitespace toggle";
  #     };
  #   }
  # ];
}
