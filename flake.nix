{
  description = "OpenCode config";

  outputs = { self, nixpkgs }: let
    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    eachSystem = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
  in {
    packages = eachSystem (pkgs: {
      default = pkgs.runCommand "opencode-config" {} ''
        mkdir -p $out/share/opencode-config
        cp -r ${./config}/* $out/share/opencode-config/
      '';
    });

    checks.x86_64-linux.install-test = import ./tests/install-test.nix {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      inherit self;
    };
  };
}
