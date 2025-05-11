{ ... }:

{
  plugins = {
    # completions
    cmp = {
      enable = true;

      settings = {
        mapping = {
          "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item())";
          "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item())";

          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";

          "<C-Space>" = "cmp.mapping.complete()"; # trigger completions
          "<C-e>" = "cmp.mapping.abort()";
          "<C-y>" = "cmp.mapping.confirm({ select = true })";
          "<CR>" = "cmp.mapping.confirm({ select = false })"; # set `select = false` to only confirm explicitly selected items

          # from kickstart.nvim
          # <C-l> move to the right of each of the expansion locations
          # <C-h> is similar, except moving backwards
          "<C-l>" = # lua
            ''
              cmp.mapping(function()
                if luasnip.expand_or_locally_jumpable() then
                  luasnip.expand_or_jump()
                end
              end, { 'i', 's' })
            '';
          "<C-h>" = # lua
            ''
              cmp.mapping(function()
                if luasnip.locally_jumpable(-1) then
                  luasnip.jump(-1)
                end
              end, { 'i', 's' })
            '';
        };

        snippets.expand = # lua
          ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';

        sources = [
          { name = "nvim_lsp_signature_help"; } # display function signature, with current parameter emphasized
          { name = "nvim_lsp"; }
          { name = "nvim_lua"; } # neovim Lua API, only works in lua sections
          { name = "luasnip"; }
          { name = "buffer"; }
          { name = "emoji"; }
        ];

        window = {
          completion = {
            border = "double";
            scrolloff = 5;
            winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,Search:None";
          };

          documentation = {
            border = "double";
            winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,Search:None";
          };
        };
      };
    };

    # snippets
    friendly-snippets.enable = true; # preconfigured snippets
    luasnip.enable = true; # snippet engine (required for completions)
  };
}
