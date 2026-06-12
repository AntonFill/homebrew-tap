class Realdate < Formula
  desc "A Swift CLI tool that extracts dates from filenames, sets macOS file timestamps, and cleans up filenames for better file system sorting."
  homepage "https://github.com/AntonFill/RealDate"
  url "https://github.com/AntonFill/RealDate/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "08f1391e653a8af6b8c25bd5f6355b58abed96dd782b50c22355edaccb032f0b"
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
