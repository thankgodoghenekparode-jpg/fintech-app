import { defineConfig } from "vite";

export default defineConfig({
  appType: "spa",
  clearScreen: false,
  root: decodeURIComponent(new URL(".", import.meta.url).pathname).replace(
    /^\/([A-Za-z]:\/)/,
    "$1",
  ),
  server: { strictPort: true },
});
