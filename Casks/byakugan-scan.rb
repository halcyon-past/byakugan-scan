cask "byakugan-scan" do
  version "1.0.4"
  sha256 "c3276c99abec68ddf176dde5e2493737451da42cf5b896844bcf6919b1115e20"

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
