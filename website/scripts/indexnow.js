#!/usr/bin/env node
/**
 * IndexNow Instant Push Script for Byakugan Scan
 * Submits updated URLs directly to Microsoft Bing, ChatGPT Search, and participating search engines.
 */

const HOST = "byakugan-scan.aritro.cloud";
const KEY = "bbb1a623984c8d7af9ff1ade96c213fb";
const KEY_LOCATION = `https://${HOST}/byakugan-scan-indexnow-key.txt`;

const URL_LIST = [
  `https://${HOST}/`,
  `https://${HOST}/support`,
  `https://${HOST}/privacy`,
  `https://${HOST}/terms`,
  `https://${HOST}/llms.txt`,
  `https://${HOST}/llms-full.txt`,
  `https://${HOST}/ai.txt`,
  `https://${HOST}/.well-known/ai.txt`,
];

async function submitIndexNow() {
  const payload = {
    host: HOST,
    key: KEY,
    keyLocation: KEY_LOCATION,
    urlList: URL_LIST,
  };

  try {
    console.log(`📡 [IndexNow] Submitting ${URL_LIST.length} URLs to https://api.indexnow.org/indexnow...`);
    const res = await fetch("https://api.indexnow.org/indexnow", {
      method: "POST",
      headers: {
        "Content-Type": "application/json; charset=utf-8",
      },
      body: JSON.stringify(payload),
    });

    if (res.ok || res.status === 200 || res.status === 202) {
      console.log(`✅ [IndexNow] Successfully submitted URLs! Status: ${res.status}`);
    } else {
      const text = await res.text().catch(() => "");
      console.warn(`⚠️ [IndexNow] Submission returned status ${res.status}: ${text}`);
    }
  } catch (err) {
    console.warn(`⚠️ [IndexNow] Ping skipped or offline: ${err.message || err}`);
  }
}

submitIndexNow();
