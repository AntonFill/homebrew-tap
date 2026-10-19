class Realdate < Formula
  desc "Set macOS file timestamps from the date in the filename"
  homepage "https://github.com/AntonFill/realdate"
  url "https://github.com/AntonFill/realdate/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "306bbef188bfbc1fe017d612e7acb2dfd274e1f57fdb74ee6bc46b1edbd735ea"
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
