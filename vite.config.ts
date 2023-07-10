import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vitest/config';
import wasmPack from 'vite-plugin-wasm-pack';

export default defineConfig({
	plugins: [sveltekit(), wasmPack(['./halogen'], [])],
	test: {
		include: ['src/**/*.{test,spec}.{js,ts}']
	},
	server: {
		fs: {
			allow: ['src', 'halogen/pkg']
		}
	}
});
