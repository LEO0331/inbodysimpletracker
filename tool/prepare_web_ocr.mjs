import { createHash } from 'node:crypto';
import { mkdir, writeFile } from 'node:fs/promises';

const cdn = 'https://cdn.jsdelivr.net/npm/';
const tesseract = 'tesseract.js@5.1.1';
const core = 'tesseract.js-core@5.1.1';
const english = '@tesseract.js-data/eng@1.0.0/4.0.0_best_int';
const assets = [
  ['tesseract.min.js', `${tesseract}/dist/tesseract.min.js`, 'a8e29918d098b2b06e1012bdaeffb4aec0445c5d5654709023e0bd1f442a80e8'],
  ['worker.min.js', `${tesseract}/dist/worker.min.js`, 'aca1229639fc9907d86f96e825955a2b7c5716d17f3bc3acd71f9c7ab66181fc'],
  ['tesseract-core-lstm.wasm.js', `${core}/tesseract-core-lstm.wasm.js`, '8f04aa0cc81e7bde33f80e92fa01a7a665f0b4884d098acf5de9c7104a11dfaa'],
  ['tesseract-core-simd-lstm.wasm.js', `${core}/tesseract-core-simd-lstm.wasm.js`, 'ce20eda9533cbed1e6c2b4276fbae1e0adc61b6754b5513084be601787b457cf'],
  ['eng.traineddata.gz', `${english}/eng.traineddata.gz`, '45b4cb346724ac1774f1c36f42f182b887bcdb28ebe63e6fff90ac41f3fcff91'],
  ['LICENSE-tesseract-js.md', `${tesseract}/LICENSE.md`, 'b40930bbcf80744c86c46a12bc9da056641d722716c378f5659b9e555ef833e1'],
  ['LICENSE-tesseract-core.txt', `${core}/LICENSE`, 'c6596eb7be8581c18be736c846fb9173b69eccf6ef94c5135893ec56bd92ba08'],
  ['tesseract.min.js.LICENSE.txt', `${tesseract}/dist/tesseract.min.js.LICENSE.txt`, 'cdf963ced7d25a0f98901a547647b4d6e2dbe0197fd78c87a059a87b0e542fe2'],
  ['worker.min.js.LICENSE.txt', `${tesseract}/dist/worker.min.js.LICENSE.txt`, '45f54171aeaa1d10c0c1a66f374b7bba1f02472b1487fbe892eec04f840002ac'],
];

// The LSTM JavaScript builds above embed WASM for SIMD and non-SIMD browsers.
// These digests were computed from the files in the published npm tarballs.
const verified = await Promise.all(assets.map(async ([name, source, expected]) => {
  const response = await fetch(cdn + source, {
    redirect: 'error',
    signal: AbortSignal.timeout(60_000),
  });
  if (!response.ok) throw new Error(`OCR download failed: ${name} (HTTP ${response.status})`);
  const bytes = Buffer.from(await response.arrayBuffer());
  const digest = createHash('sha256').update(bytes).digest('hex');
  if (digest !== expected) throw new Error(`OCR checksum mismatch: ${name}`);
  return [name, bytes];
}));

const destination = new URL('../web/ocr/', import.meta.url);
await mkdir(destination, { recursive: true });
await Promise.all(verified.map(([name, bytes]) => writeFile(new URL(name, destination), bytes)));
console.log(`Prepared ${verified.length} verified Web OCR files.`);
