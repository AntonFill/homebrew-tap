class Mail2md < Formula
  desc "Convert .eml files to Markdown with YAML frontmatter"
  homepage "https://github.com/AntonFill/mail2md"
  url "https://github.com/AntonFill/mail2md/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "7e4d0e03d054b1bfae78fb909edd33f148bbbb3d7b6785fc5bc0bb435f380503"
  license "MIT"

  depends_on xcode: ["16.0", :build]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/mail2md"
  end

  test do
    (testpath/"mail.eml").write <<~EML
      From: Jane Doe <jane@example.com>
      To: Anton Fillmann <anton@example.com>
      Subject: Homebrew test
      Date: Sun, 15 Jun 2026 09:41:00 +0000
      Content-Type: text/plain; charset=utf-8

      Hello from the formula test.
    EML

    system bin/"mail2md", testpath/"mail.eml"
    assert_match "subject: \"Homebrew test\"", (testpath/"mail.md").read
    assert_match version.to_s, shell_output("#{bin}/mail2md --version")
  end
end
