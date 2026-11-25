import { defineConfig } from "vite";

export default defineConfig({
  root: "preview/pay_am_small_vendor",
  server: { host: "127.0.0.1", port: 5180, strictPort: true },
  preview: { host: "127.0.0.1", port: 4180, strictPort: true },
  build: { outDir: "dist", emptyOutDir: true },
});
