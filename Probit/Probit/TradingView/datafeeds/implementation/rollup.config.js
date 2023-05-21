/* globals process */

import { terser } from 'rollup-plugin-terser';
import { nodeResolve } from '@rollup/plugin-node-resolve';

const environment = process.env.ENV || 'development';
const isDevelopmentEnv = (environment === 'development');

export default [
	{
		input: 'src/datafeed.js',
		output: {
			name: 'Datafeeds',
			format: 'umd',
			file: 'dist/bundle.js',
		},
		plugins: [
			nodeResolve(),
			!isDevelopmentEnv && terser({
				ecma: 2018,
				output: { inline_script: true },
			}),
		],
	},
	{
		input: 'src/helpers.js',
		output: {
			name: 'Helpers',
			format: 'umd',
			file: 'dist/helpers.js',
		},
		plugins: [
			nodeResolve(),
			!isDevelopmentEnv && terser({
				ecma: 2018,
				output: { inline_script: true },
			}),
		],
	},
];
