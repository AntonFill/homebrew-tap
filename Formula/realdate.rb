class Realdate < Formula
  desc "A Swift CLI tool that extracts dates from filenames, sets macOS file timestamps, and cleans up filenames for better file system sorting."
  homepage "https://github.com/AntonFill/RealDate"
  url "https://github.com/AntonFill/RealDate/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "7c4f0101f37e7053b6918803496abd249a923a6141a653e89e153b8752615628"
  license "MIT"

  depends_on :xcode => ["13.0", :build]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/realdate"
  end

  test do
    system "#{bin}/realdate", "--version"
  end
end
|
