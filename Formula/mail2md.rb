class Mail2md < Formula
  desc "Convert .eml files to Markdown with YAML frontmatter"
  homepage "https://github.com/AntonFill/mail2md"
  url "https://github.com/AntonFill/mail2md/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "45a4a56175b443b61147299fedbfeef83c91779a61acdbb9efb5161584dff341"
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

    (testpath/"enclosure.eml").write <<~EML
      From: Jane Doe <jane@example.com>
      Subject: With an attachment
      Date: Sun, 15 Jun 2026 09:41:00 +0000
      MIME-Version: 1.0
      Content-Type: multipart/mixed; boundary="b"

      --b
      Content-Type: text/plain; charset=utf-8

      See attached.
      --b
      Content-Type: application/pdf
      Content-Disposition: attachment; filename="Doc.pdf"
      Content-Transfer-Encoding: base64

      JVBERi0xLjQK
      --b--
    EML

    system bin/"mail2md", "--attachments-dir", testpath/"files",
           "--attachment-name", "ENCL {name}", testpath/"enclosure.eml"
    # No {date} here on purpose: it renders in the local zone, so a
    # tester east or west of the fixture would see a different day.
    assert_path_exists testpath/"files/ENCL Doc.pdf"
    assert_match "[[ENCL Doc.pdf|Doc.pdf]]", (testpath/"enclosure.md").read

    assert_match version.to_s, shell_output("#{bin}/mail2md --version")
  end
end
