class McpWarden < Formula
  desc "Stdio proxy that sanitizes untrusted MCP server output before an agent reads it"
  homepage "https://github.com/AncientiCe/mcp-warden"
  license any_of: ["MIT", "Apache-2.0"]

  # The release workflow in AncientiCe/mcp-warden opens a PR here with the real
  # per-platform URLs and sha256 checksums for every tagged release. Until the
  # first release PR merges, `brew install` fails with a checksum mismatch.

  on_macos do
    on_arm do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.2.0/mcp-warden-0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "fcaa1e9d0887f608c5f0c02314bf3cf6bcf326b7353900369d2bd34fe1995d04"
    end

    on_intel do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.2.0/mcp-warden-0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "5b8247a6a93142d832e682b812d30685b6c6175d98015f1527bd8ab7ee39d0d3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.2.0/mcp-warden-0.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "09c4a6dc89dc70b250a5233cbeeb81fe2557039e4fd21059b2be2d8e40247e72"
    end

    on_intel do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.2.0/mcp-warden-0.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1366bd475e1ff8607c22f8ea51a77ed02ebe52c1d1c37ee321dd4bf6e7ab1d19"
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
