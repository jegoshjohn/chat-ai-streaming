/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    // Only copy files the server chunk actually needs
    outputFileTracing: 'strict',
    // Anything that matches one of these globs is left out
    outputFileTracingIgnores: [
      '**/.pnpm/**',                       // real packages (pnpm store)
      '**/node_modules/**',                // symlink layer (still follow-links)
      '**/*.map',                          // source maps
      'node_modules/@swc/**',              // big native binaries you excluded
      'node_modules/sharp/**',
      'node_modules/oniguruma/**',
      'node_modules/fsevents/**',
    ],
  },
  // Reduce bundle size
  swcMinify: true,
  compress: true,
  // Optimize images
  images: {
    formats: ['image/webp', 'image/avif'],
    minimumCacheTTL: 60,
  },
  // API routes configuration
  rewrites: async () => {
    return [
      {
        source: "/api/:path*",
        destination:
          process.env.NODE_ENV === "development"
            ? "http://127.0.0.1:8000/api/:path*"
            : "/api/",
      },
      {
        source: "/docs",
        destination:
          process.env.NODE_ENV === "development"
            ? "http://127.0.0.1:8000/docs"
            : "/api/docs",
      },
      {
        source: "/openapi.json",
        destination:
          process.env.NODE_ENV === "development"
            ? "http://127.0.0.1:8000/openapi.json"
            : "/api/openapi.json",
      },
    ];
  },
};

module.exports = nextConfig;
