#!/usr/bin/env node
/**
 * IndexNow Instant Push Script for Byakugan Scan
 * Submits updated URLs directly to Microsoft Bing, IndexNow API, and participating engines.
 */

const HOST = "byakugan-scan.aritro.cloud";
const KEY = "bbb1a623984c8d7af9ff1ade96c213fb";
const KEY_LOCATION = `https://${HOST}/${KEY}.txt`;

const URL_LIST = [
  `https://${HOST}/`,
  `https://${HOST}/support`,
  `https://${HOST}/privacy`,
  `https://${HOST}/terms`,
  `https://${HOST}/llms.txt`,
  `https://${HOST}/llms-full.txt`,
  `https://${HOST}/ai.txt`,
  `https://${HOST}/.well-known/ai.txt`,
  `https://${HOST}/sitemap.xml`,
];

const ENDPOINTS = [
  "https://api.indexnow.org/indexnow",
  "https://www.bing.com/indexnow",
];

async function submitIndexNow() {
  const payload = {
    host: HOST,
    key: KEY,
    keyLocation: KEY_LOCATION,
    urlList: URL_LIST,
  };

  console.log(`📡 [IndexNow] Submitting ${URL_LIST.length} URLs for ${HOST}...`);
  console.log(`🔑 [IndexNow] Key Location: ${KEY_LOCATION}`);

  for (const endpoint of ENDPOINTS) {
    try {
      const res = await fetch(endpoint, {
        method: "POST",
        headers: {
          "Content-Type": "application/json; charset=utf-8",
        },
        body: JSON.stringify(payload),
      });

      if (res.ok || res.status === 200 || res.status === 202) {
        console.log(`✅ [IndexNow] Successfully submitted to ${endpoint} (Status: ${res.status})`);
      } else {
        const text = await res.text().catch(() => "");
        console.warn(`⚠️ [IndexNow] ${endpoint} returned status ${res.status}: ${text}`);
      }
    } catch (err) {
      console.warn(`⚠️ [IndexNow] Could not reach ${endpoint}: ${err.message || err}`);
    }
  }
}

submitIndexNow();
