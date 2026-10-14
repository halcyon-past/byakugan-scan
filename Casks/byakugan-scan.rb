cask "byakugan-scan" do
  version "1.0.10"
  sha256 "f77579141f46a0b3454fe2d785b800ccdc152ae24b45271c863170afc0ce7699"

  url "https://github.com/halcyon-past/byakugan-scan/releases/download/v#{version}/ByakuganScan-v#{version}.dmg"
  name "Byakugan Scan"
  desc "Instant on-device OCR, QR code, and barcode scanner"
  homepage "https://byakugan-scan.aritro.cloud/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :sonoma

  app "Byakugan Scan.app"

  zap trash: [
    "~/Library/Application Support/ByakuganScan",
    "~/Library/Preferences/cloud.aritro.byakugan-scan.plist",
  ]
end
