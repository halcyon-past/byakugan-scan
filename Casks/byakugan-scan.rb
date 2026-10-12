cask "byakugan-scan" do
  version "1.0.3"
  sha256 "ffbf062693dab361d0c02e7d9392edfceb2dee258d4d78be14e81820322e7411"

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
