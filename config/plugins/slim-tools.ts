import type { PluginModule } from "opencode/plugin";

const MAX_DESC_LENGTH = 500;

export default {
  id: "slim-tools",
  server: async () => ({
    "tool.definition": async (
      _input: { toolID: string },
      output: { description: string; parameters: any },
    ) => {
      if (output.description.length > MAX_DESC_LENGTH) {
        output.description = output.description.slice(0, MAX_DESC_LENGTH) + "...";
      }
    },
  }),
} satisfies PluginModule;
