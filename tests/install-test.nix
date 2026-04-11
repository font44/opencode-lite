{ pkgs, self }:

let
  package = self.packages.x86_64-linux.default;
in
pkgs.testers.nixosTest {
  name = "opencode-config-install";

  nodes.machine =
    { ... }:
    {
      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        build-users-group = "";
      };
      nix.nixPath = [ ];
      environment.systemPackages = [ package ];
    };

  testScript =
    let
      cfg = "${package}/share/opencode-config";
    in
    ''
      machine.wait_for_unit("multi-user.target")

      machine.succeed("test -f ${cfg}/opencode.jsonc")
      machine.succeed("test -f ${cfg}/AGENTS.md")

      machine.succeed("test -s ${cfg}/agents/build.md")

      machine.succeed("test -s ${cfg}/skills/fetch-website-in-markdown/SKILL.md")

      machine.succeed("test -x ${package}/bin/opencode")

      machine.succeed("grep -q 'OPENCODE_CONFIG_DIR' ${package}/bin/opencode")
    '';
}
