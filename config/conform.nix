{ pkgs, ... }:

{
  extraPackages = with pkgs; [
    nixfmt-rfc-style
    stylua
    biome
  ];

  # formatter
  plugins.conform-nvim = {
    enable = true;

    settings = {
      formatters_by_ft = {
        html = {
          __unkeyed-1 = "prettier";
        };

        css = {
          __unkeyed-1 = "prettier";
          __unkeyed-2 = "biome";
          stop_after_first = true;
        };

        javascript = {
          __unkeyed-1 = "prettier";
          __unkeyed-2 = "biome";
          stop_after_first = true;
        };
        javascriptreact = {
          __unkeyed-1 = "prettier";
          __unkeyed-2 = "biome";
          stop_after_first = true;
        };
        typescript = {
          __unkeyed-1 = "prettier";
          __unkeyed-2 = "biome";
          stop_after_first = true;
        };
        typescriptreact = {
          __unkeyed-1 = "prettier";
          __unkeyed-2 = "biome";
          stop_after_first = true;
        };

        svelte = [ "prettier" ];

        json = [ "prettier" ];
        yaml = [ "prettier" ];

        markdown = [ "prettier" ];

        lua = [ "stylua" ];
        nix = [ "nixfmt" ];
        rust = [ "rustfmt" ];
        zig = [ "zigfmt" ];
      };

      format_on_save = # lua
        ''
          function(bufnr)
            if vim.g.disable_format_on_save or vim.b[bufnr].disable_format_on_save then
              return
            end

            return { timeout_ms = 5000, lsp_fallback = true }
           end
        '';

      notify_no_formatters = false;
      notify_on_error = false;
    };
  };

  keymaps = [
    {
      action = "";
      key = "<leader>c";
      mode = [
        "n"
        "v"
      ];
      options = {
        desc = "+Conform format";
      };
    }

    # format
    {
      action = "<Cmd>ConformFormat<CR>";
      key = "<leader>cf";
      mode = [
        "n"
        "v"
      ];
      options = {
        desc = "Conform: format selected text/buffer";
      };
    }
    {
      action = "<Cmd>ConformAsyncFormat<CR>";
      key = "<leader>cc";
      mode = [
        "n"
        "v"
      ];
      options = {
        desc = "Conform: format selected text/buffer";
      };
    }

    # format on save setting
    {
      action = "<Cmd>ConformFormatOnSaveDisable!<CR>";
      key = "<leader>cd";
      mode = "n";
      options = {
        desc = "Conform: disable format on save";
      };
    }
    {
      action = "<Cmd>ConformFormatOnSaveEnable<CR>";
      key = "<leader>ce";
      mode = "n";
      options = {
        desc = "Conform: enable format on save";
      };
    }
  ];

  extraConfigLua = # lua
    ''
      -- from conform docs
      -- make format command
      vim.api.nvim_create_user_command("ConformFormat", function(opts)
        -- for k, v in pairs(opts) do
        --   print(k, v)
        -- end

        local range = nil

        if opts.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, opts.line2 - 1, opts.line2, true)[1]

          range = {
            start = { opts.line1, 0 },
            ["end"] = { opts.line2, end_line:len() },
          }

          -- for a, b in pairs(range) do
          --   print(a)
          --   for x, y in pairs(b) do
          --     print(x, y)
          --   end
          -- end
        end
        require("conform").format({ async = true, lsp_format = "fallback", range = range })
      end, { range = true })
    '';

  userCommands = {
    ConformFormatOnSaveDisable = {
      bang = true;
      command.__raw = # lua
        ''
          function(args)
             if args.bang then
               -- ConformFormatOnSaveDisable! will disable formatting just for this buffer
               vim.b.disable_format_on_save = true
             else
               vim.g.disable_format_on_save = true
             end
          end
        '';
      desc = "Disable Conform format on save";
    };

    ConformFormatOnSaveEnable = {
      command.__raw = # lua
        ''
          function()
            vim.b.disable_format_on_save = false
            vim.g.disable_format_on_save = false
          end
        '';
      desc = "Enable Conform format on save";
    };
  };
}
