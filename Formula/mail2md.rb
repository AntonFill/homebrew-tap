class Mail2md < Formula
  desc "Convert .eml files to Markdown with YAML frontmatter"
  homepage "https://github.com/AntonFill/mail2md"
  url "https://github.com/AntonFill/mail2md/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "a43af3ee0223c3cdf86f6d51c45b23f74151232ec09fed3488d58425b205362b"
  license "MIT"

  depends_on xcode: ["26.4", :build]

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
