{ pkgs, self }:

let
  package = self.packages.x86_64-linux.default;
in
pkgs.testers.nixosTest {
  name = "opencode-config-install";

  nodes.machine = { ... }: {
    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
      build-users-group = "";
    };
    nix.nixPath = [];
    environment.systemPackages = [ package ];
  };

  testScript = let
    cfg = "${package}/share/opencode-config";
  in ''
    machine.wait_for_unit("multi-user.target")

    # All expected files exist
    machine.succeed("test -f ${cfg}/opencode.jsonc")
    machine.succeed("test -f ${cfg}/AGENTS.md")
    machine.succeed("test -f ${cfg}/agents/builder.md")
    machine.succeed("test -f ${cfg}/agents/general.md")

    # Command files exist and are non-empty
    machine.succeed("test -s ${cfg}/commands/plan.md")
    machine.succeed("test -s ${cfg}/commands/implement-plan.md")
    machine.succeed("test -s ${cfg}/commands/review-code.md")
    machine.succeed("test -s ${cfg}/commands/review-plan.md")

    # Skill files exist and are non-empty
    machine.succeed("test -s ${cfg}/skills/fetch-website-in-markdown/SKILL.md")
    machine.succeed("test -s ${cfg}/skills/flashcard-content-creator/SKILL.md")

    # opencode.jsonc: default_agent is builder, build and plan disabled
    machine.succeed(
        "${pkgs.jq}/bin/jq -e '.default_agent == \"builder\"' ${cfg}/opencode.jsonc"
    )
    machine.succeed(
        "${pkgs.jq}/bin/jq -e '.agent.build.disable == true' ${cfg}/opencode.jsonc"
    )
    machine.succeed(
        "${pkgs.jq}/bin/jq -e '.agent.plan.disable == true' ${cfg}/opencode.jsonc"
    )

    # Agent files are non-empty
    machine.succeed("test -s ${cfg}/agents/builder.md")
    machine.succeed("test -s ${cfg}/agents/general.md")
  '';
}
