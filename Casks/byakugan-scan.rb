cask "byakugan-scan" do
  version "1.0.8"
  sha256 "4f460200907c16edf9332cb365aa55bd2d5943b2a4d4602c68853425a8e5da68"

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
