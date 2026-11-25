import { spawn } from 'node:child_process';
import { createRequire } from 'node:module';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const require = createRequire(import.meta.url);
const wasmFile = require.resolve('@next/swc-wasm-nodejs/wasm.js');
const webRoot = join(dirname(fileURLToPath(import.meta.url)), '..');
const nextPackage = dirname(require.resolve('next/package.json'));
const nextCli = join(nextPackage, 'dist', 'bin', 'next');

const child = spawn(
  process.execPath,
  [nextCli, ...process.argv.slice(2)],
  {
    cwd: webRoot,
    env: {
      ...process.env,
      NEXT_TEST_WASM_DIR: dirname(wasmFile),
    },
    stdio: 'inherit',
  },
);

child.on('error', (error) => {
  process.stderr.write(error.message + '\n');
  process.exitCode = 1;
});
child.on('exit', (code, signal) => {
  process.exitCode = code ?? (signal ? 1 : 0);
});
