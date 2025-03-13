{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    nodejs_22
    vscode-js-debug # Node debugging
  ];

  # debug adapter protocol
  plugins = {
    dap-ui.enable = true;
    dap-virtual-text.enable = true;

    dap = {
      enable = true;

      adapters = {
        servers = {
          # pwa-node = {
          #   host = "localhost";
          #   port = ''''${port}'';
          #   executable = {
          #     command = "node";
          #     args = [
          #       "${pkgs.vscode-js-debug}/bin/js-debug"
          #       ''''${port}''
          #     ];
          #   };
          # };
          pwa-node = {
            host = "localhost";
            port = 9229;
            executable = {
              command = "node";
              args = [
                "${pkgs.vscode-js-debug}/bin/js-debug"
                "9229"
              ];
            };
          };
        };
      };

      configurations = {
        # svelte = [
        #   {
        #     name = "Node launch file";
        #     type = "pwa-node"; # adapter name
        #     request = "launch"; # "attach" or "launch"
        #     program = ''''${file}'';
        #     cwd = ''''${workspaceFolder}'';
        #   }
        #   {
        #     name = "Node attach to process";
        #     type = "pwa-node";
        #     request = "attach";
        #     processId = # lua
        #       ''
        #         require("dap.utils").pick_process;
        #       '';
        #     cwd = ''''${workspaceFolder}'';
        #   }
        # ];

        typescriptreact = [
          {
            name = "Node launch file";
            type = "pwa-node";
            request = "launch";
            program = ''''${file}'';
            cwd = ''''${workspaceFolder}'';
          }
          {
            name = "Node attach to process";
            type = "pwa-node";
            request = "attach";
            processId = # lua
              ''
                require("dap.utils").pick_process
              '';
            cwd = ".";
          }
        ];
      };
    };
  };

  # extraConfigLua = # lua
  #   ''
  #     require("dap").adapters["pwa-node"] = {
  #       type = "server",
  #       host = "localhost",
  #       port = "8123",
  #       executable = {
  #         command = "node",
  #         args = {"${pkgs.vscode-js-debug}/bin/js-debug", "8123"},
  #       }
  #     }
  #   '';
}
