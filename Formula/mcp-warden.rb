class McpWarden < Formula
  desc "Stdio proxy that sanitizes untrusted MCP server output before an agent reads it"
  homepage "https://github.com/AncientiCe/mcp-warden"
  license any_of: ["MIT", "Apache-2.0"]

  # The release workflow in AncientiCe/mcp-warden opens a PR here with the real
  # per-platform URLs and sha256 checksums for every tagged release. Until the
  # first release PR merges, `brew install` fails with a checksum mismatch.

  on_macos do
    on_arm do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.1.0/mcp-warden-0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "4588494ea41780705dbc29fe33e14a60d817f2104afb7c9a465e4f62800c66b8"
    end

    on_intel do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.1.0/mcp-warden-0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "ad3c0cec51ae55f0c38974f2dec2c4ba728b99b1698c0bfee2cf139784a9405e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.1.0/mcp-warden-0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d33c425a9b21d6ab1dfe14d44057bd4cc9d001286dc0ad95b582e4e57cfee80e"
    end

    on_intel do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.1.0/mcp-warden-0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "79480d8627cc9d6901a85cea7ec4e2249c810a53841aaf5c1ebc395a104800ee"
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
