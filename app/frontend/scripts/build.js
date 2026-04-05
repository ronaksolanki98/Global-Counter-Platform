import { mkdirSync, copyFileSync, cpSync } from 'node:fs';
import { join } from 'node:path';

const PUBLIC_DIR = new URL('../public', import.meta.url).pathname;
const ASSETS_DIR = new URL('../assets', import.meta.url).pathname;
const DIST_DIR = new URL('../dist', import.meta.url).pathname;

mkdirSync(DIST_DIR, { recursive: true });
cpSync(PUBLIC_DIR, DIST_DIR, { recursive: true });
mkdirSync(join(DIST_DIR, 'assets'), { recursive: true });
copyFileSync(join(ASSETS_DIR, 'style.css'), join(DIST_DIR, 'assets', 'style.css'));
copyFileSync(join(ASSETS_DIR, 'app.js'), join(DIST_DIR, 'assets', 'app.js'));
