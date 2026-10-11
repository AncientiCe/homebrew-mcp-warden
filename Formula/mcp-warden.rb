class McpWarden < Formula
  desc "Stdio proxy that sanitizes untrusted MCP server output before an agent reads it"
  homepage "https://github.com/AncientiCe/mcp-warden"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.3.6/mcp-warden-0.3.6-aarch64-apple-darwin.tar.gz"
      sha256 "f08e4b95e8c8aa9e09101c8a9301d24d173cf575b852ebb2c37973c002dd10c1"
    end

    on_intel do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.3.6/mcp-warden-0.3.6-x86_64-apple-darwin.tar.gz"
      sha256 "cdf316cd60826564ead994ec32faf001f229dedd75c8be06ca6b96e460ffc266"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.3.6/mcp-warden-0.3.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bdd3e1dc2c5e32583e9f796722dd8eda98bc4eb7fdb9b66d7256bb6cc261c3d1"
    end

    on_intel do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.3.6/mcp-warden-0.3.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "27607d27aa747eb63d6b5d4411e225107f272b68bfc520f89621bb06d44052ef"
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
