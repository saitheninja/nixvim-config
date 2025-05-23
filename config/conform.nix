{ pkgs, ... }:

{
  extraPackages = with pkgs; [
    biome # TypeScript
    gdtoolkit_4 # Godot gdformat, gdlint
    nixfmt-rfc-style
    stylua
  ];

  # formatter
  plugins.conform-nvim = {
    enable = true;

    settings = {
      formatters = {
        biome = {
          append_args = [ "--indent-style=space" ];
        };
      };

      formatters_by_ft = {
        html = {
          __unkeyed-1 = "prettier";
        };

        css = {
          __unkeyed-1 = "biome";
          __unkeyed-2 = "prettier";
          stop_after_first = true;
        };

        javascript = {
          __unkeyed-1 = "biome";
          __unkeyed-2 = "prettier";
          stop_after_first = true;
        };
        javascriptreact = {
          __unkeyed-1 = "biome";
          __unkeyed-2 = "prettier";
          stop_after_first = true;
        };
        typescript = {
          __unkeyed-1 = "biome";
          __unkeyed-2 = "prettier";
          stop_after_first = true;
        };
        typescriptreact = {
          __unkeyed-1 = "biome";
          __unkeyed-2 = "prettier";
          stop_after_first = true;
        };

        svelte = [ "prettier" ];

        json = [ "prettier" ];
        yaml = [ "prettier" ];

        markdown = [ "prettier" ];

        gdscript = [ "gdformat" ];
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
        desc = "Conform: format buffers";
      };
    }

    # format on save setting
    {
      action = "<Cmd>ConformFormatOnSaveDisable!<CR>";
      key = "<leader>cdd";
      mode = "n";
      options = {
        desc = "Conform: disable format on save (buffer)";
      };
    }
    {
      action = "<Cmd>ConformFormatOnSaveDisable<CR>";
      key = "<leader>cdg";
      mode = "n";
      options = {
        desc = "Conform: disable format on save (global)";
      };
    }
    {
      action = "<Cmd>ConformFormatOnSaveEnable!<CR>";
      key = "<leader>cee";
      mode = "n";
      options = {
        desc = "Conform: enable format on save (buffer)";
      };
    }
    {
      action = "<Cmd>ConformFormatOnSaveEnable<CR>";
      key = "<leader>ceg";
      mode = "n";
      options = {
        desc = "Conform: enable format on save (global)";
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
             -- ConformFormatOnSaveDisable! disables formatting just for this buffer
             if args.bang then
               vim.b.disable_format_on_save = true
             else
               vim.g.disable_format_on_save = true
             end
          end
        '';
      desc = "Disable Conform format on save";
    };

    ConformFormatOnSaveEnable = {
      bang = true;
      command.__raw = # lua
        ''
          function()
            if args.bang then
              vim.b.disable_format_on_save = false
            else
              vim.g.disable_format_on_save = false
            end
          end
        '';
      desc = "Enable Conform format on save";
    };
  };
}
