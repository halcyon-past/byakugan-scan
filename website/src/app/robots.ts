import type { MetadataRoute } from "next";

export default function robots(): MetadataRoute.Robots {
  const baseUrl = "https://byakugan-scan.aritro.cloud";

  return {
    rules: [
      {
        userAgent: [
          "*",
          "GPTBot",
          "OAI-SearchBot",
          "ChatGPT-User",
          "ClaudeBot",
          "Claude-Web",
          "anthropic-ai",
          "PerplexityBot",
          "Perplexity-User",
          "Google-Extended",
          "Googlebot",
          "Applebot",
          "Applebot-Extended",
          "Amazonbot",
          "YouBot",
          "DuckAssistBot",
          "cohere-ai",
        ],
        allow: ["/", "/llms.txt", "/llms-full.txt", "/support", "/privacy", "/terms"],
      },
    ],
    sitemap: `${baseUrl}/sitemap.xml`,
    host: baseUrl,
  };
}
