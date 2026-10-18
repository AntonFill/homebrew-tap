class Realdate < Formula
  desc "Set macOS file timestamps from the date in the filename"
  homepage "https://github.com/AntonFill/realdate"
  url "https://github.com/AntonFill/realdate/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "6dc606a9a33dda25e74bccaf537202592e335f7c11637a1d7beb1d25f1dbc615"
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
