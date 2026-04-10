{
  description = "OpenCode config + sandboxed binary";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    llm-agents-nix = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-bwrapper = {
      url = "github:Naxdy/nix-bwrapper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      llm-agents-nix,
      nix-bwrapper,
    }:
    let
      linuxSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      darwinSystems = [
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      allSystems = linuxSystems ++ darwinSystems;

      eachSystem = systems: f: nixpkgs.lib.genAttrs systems (system: f system);

      configDrv =
        pkgs:
        pkgs.runCommand "opencode-config" { } ''
          mkdir -p $out/share/opencode-config
          cp -r ${./config}/* $out/share/opencode-config/
        '';

      sandboxedOpenCode =
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ nix-bwrapper.overlays.default ];
          };
          opencode = llm-agents-nix.packages.${system}.opencode;
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

      wrappedPackage =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          config = configDrv pkgs;
          isLinux = builtins.elem system linuxSystems;
          opencode = if isLinux then sandboxedOpenCode system else llm-agents-nix.packages.${system}.opencode;
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
    {
      packages = eachSystem allSystems (system: {
        default = wrappedPackage system;
      });

      checks.x86_64-linux.install-test = import ./tests/install-test.nix {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        inherit self;
      };
    };
}
