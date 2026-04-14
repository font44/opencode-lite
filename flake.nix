{
  description = "OpenCode config + sandboxed binary";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    llm-agents-nix.url = "github:numtide/llm-agents.nix";
    nix-bwrapper.url = "github:Naxdy/nix-bwrapper";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      llm-agents-nix,
      nix-bwrapper,
    }:
    let
      configDrv =
        pkgs:
        pkgs.runCommand "opencode-config" { } ''
          mkdir -p $out/share/opencode-config
          cp -r ${./config}/* $out/share/opencode-config/
        '';

      sandboxedOpenCode =
        system: opencode:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ nix-bwrapper.overlays.default ];
          };
        in
        pkgs.mkBwrapper {
          imports = [
            pkgs.bwrapperPresets.devshell
          ];
          app = {
            package = opencode;
          };
          mounts = {
            read = [
              "/nix/var"
              "$HOME/.aws"
              "$HOME/.ssh"
            ];
          };
        };

      wrapOpenCode =
        pkgs: opencode:
        let
          config = configDrv pkgs;
        in
        pkgs.symlinkJoin {
          name = "opencode-wrapped";
          paths = [ config ];
          nativeBuildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            mkdir -p $out/bin
            makeWrapper ${opencode}/bin/opencode $out/bin/opencode \
              --set OPENCODE_CONFIG_DIR "$out/share/opencode-config"
          '';
        };
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
	    opencode = llm-agents-nix.packages.${system}.opencode;
        pkgs = nixpkgs.legacyPackages.${system};
        isLinux = pkgs.stdenv.isLinux;
      in
      {
        packages = {
          default = wrapOpenCode pkgs opencode;
        }
        // nixpkgs.lib.optionalAttrs isLinux {
          sandbox-opencode = wrapOpenCode pkgs (sandboxedOpenCode system opencode);
        };
      }
    )
    // {
      checks.x86_64-linux.install-test = import ./tests/install-test.nix {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        inherit self;
      };
    };
}
