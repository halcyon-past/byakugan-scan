cask "byakugan-scan" do
  version "1.0.11"
  sha256 "77b54840887435e800aeefbc4e9ff63ea0c381e124ffb5d0be01ab051a0ad534"

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
