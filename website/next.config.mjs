/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  async redirects() {
    return [
      {
        source: "/download",
        destination:
          "https://github.com/halcyon-past/byakugan-scan/releases/latest/download/ByakuganScan.dmg",
        permanent: false,
      },
    ];
  },
};

export default nextConfig;
