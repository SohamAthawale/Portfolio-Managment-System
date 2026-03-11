import { defineConfig, loadEnv } from 'vite';
import react from '@vitejs/plugin-react';

const normalizeBase = (value: string) => {
  if (!value || value === '/') return '/';
  const withSlash = value.startsWith('/') ? value : `/${value}`;
  return withSlash.endsWith('/') ? withSlash : `${withSlash}/`;
};

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), '');
  const base = normalizeBase(env.VITE_BASE_PATH || (mode === 'production' ? '/pmsreports/' : '/'));

  return {
    base,
    plugins: [react()],

    optimizeDeps: {
      exclude: ['lucide-react'],
    },

    server: {
      proxy: {
        '/pmsreports': {
          target: 'http://127.0.0.1:8010',
          changeOrigin: true,
        },
      },
    },

    build: {
      outDir: 'dist',
    },
  };
});
