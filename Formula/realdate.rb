class Realdate < Formula
  desc "Set macOS file timestamps from the date in the filename"
  homepage "https://github.com/AntonFill/RealDate"
  url "https://github.com/AntonFill/RealDate/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "24f5c6eea99c4b6efedc74ced402cb4157dd95d0bf331bc013d34cb023afbfc3"
  license "MIT"

  depends_on xcode: ["16.0", :build]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/realdate"
  end

  test do
    (testpath/"2020.01.02 note.txt").write "content"

    system bin/"realdate", "--rename", testpath

    assert_path_exists testpath/"note.txt"
    assert_equal 2020, File.birthtime(testpath/"note.txt").year
  end
end
