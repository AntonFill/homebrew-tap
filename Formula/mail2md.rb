class Mail2md < Formula
  desc "Convert .eml files to Markdown with YAML frontmatter"
  homepage "https://github.com/AntonFill/mail2md"
  url "https://github.com/AntonFill/mail2md/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "c2f9ca010ce7eabca1302ee45b9be3ea25c6796bf42fcc51054d4911be6b513a"
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

    # From stdin to stdout the note is the file, byte for byte.
    note = (testpath/"mail.md").read
    assert_equal note, pipe_output("#{bin}/mail2md -", (testpath/"mail.eml").read, 0)

    # Obsidian's Markdown keeps a hashtag in the text from becoming a tag.
    (testpath/"tag.eml").write <<~EML
      From: Jane Doe <jane@example.com>
      Subject: A hashtag
      Date: Sun, 15 Jun 2026 09:41:00 +0000
      Content-Type: text/plain; charset=utf-8

      Greetings from #TeamExample
    EML

    assert_match "Greetings from \\#TeamExample",
                 pipe_output("#{bin}/mail2md --format obsidian -", (testpath/"tag.eml").read, 0)

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
