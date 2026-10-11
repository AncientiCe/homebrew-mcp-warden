class McpWarden < Formula
  desc "Stdio proxy that sanitizes untrusted MCP server output before an agent reads it"
  homepage "https://github.com/AncientiCe/mcp-warden"
  license any_of: ["MIT", "Apache-2.0"]

  # The release workflow in AncientiCe/mcp-warden opens a PR here with the real
  # per-platform URLs and sha256 checksums for every tagged release. Until the
  # first release PR merges, `brew install` fails with a checksum mismatch.

  on_macos do
    on_arm do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.3.0/mcp-warden-0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "323081e1f4c8e8412ddc71cc3fa7a5ebf5a431b6f4d24c5e5b53670f57a4824e"
    end

    on_intel do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.3.0/mcp-warden-0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "47f933475b7958a48383a456e189204d02aa6c186364f445dd579cd947d869fe"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.3.0/mcp-warden-0.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0306f2033049322391737463316422c2d67023a9d043f0091f5eb5c36582ff27"
    end

    on_intel do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.3.0/mcp-warden-0.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5033a32779e5308f85b86a0d39b3829d6144bcd524050aea6fa564e88baffa56"
    end
  end

  def install
    # Homebrew auto-extracts and may strip a single top-level directory.
    if File.exist?("mcp-warden")
      bin.install "mcp-warden"
    else
      cd Dir["mcp-warden-*"].first do
        bin.install "mcp-warden"
      end
    end
  end

  def caveats
    <<~EOS
      Wrap the stdio servers in an MCP client configuration (a backup is written first):
        mcp-warden wrap <path/to/mcp-config.json>

      Or wrap a single server by hand:
        mcp-warden --server-id github -- github-mcp-server stdio

      Restart the MCP client afterwards. For more information:
        https://github.com/AncientiCe/mcp-warden
    EOS
  end

  test do
    assert_match "mcp-warden #{version}", shell_output("#{bin}/mcp-warden --version")
    assert_equal "plain text\n", pipe_output("#{bin}/mcp-warden scan", "plain text\n")
  end
end
