class McpWarden < Formula
  desc "Stdio proxy that sanitizes untrusted MCP server output before an agent reads it"
  homepage "https://github.com/AncientiCe/mcp-warden"
  license any_of: ["MIT", "Apache-2.0"]

  # The release workflow in AncientiCe/mcp-warden opens a PR here with the real
  # per-platform URLs and sha256 checksums for every tagged release. Until the
  # first release PR merges, `brew install` fails with a checksum mismatch.

  on_macos do
    on_arm do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.3.3/mcp-warden-0.3.3-aarch64-apple-darwin.tar.gz"
      sha256 "f763c0e8dbaa558e7db623d366b357815d464e1d14dc519f3e8d512e9693aff6"
    end

    on_intel do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.3.3/mcp-warden-0.3.3-x86_64-apple-darwin.tar.gz"
      sha256 "b7ebc24ac484fadab4dd6e4dc381641655b8d8088c1841e9a02f6b983bccbb77"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.3.3/mcp-warden-0.3.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "61ae403f3b44a65fd1ec5bee5d8e383070c478c12787a50ccc35730fa75c7c4c"
    end

    on_intel do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.3.3/mcp-warden-0.3.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "415ea2d8e52dbbb1a89a25ae8f19a135a622b522ad20932c7eefc5a440886ca7"
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
