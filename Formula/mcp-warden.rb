class McpWarden < Formula
  desc "Stdio proxy that sanitizes untrusted MCP server output before an agent reads it"
  homepage "https://github.com/AncientiCe/mcp-warden"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.4.2/mcp-warden-0.4.2-aarch64-apple-darwin.tar.gz"
      sha256 "e16c671f184eba8aa978040ee6921fb01ae17b3796feaddc3d1266286d8b66fa"
    end

    on_intel do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.4.2/mcp-warden-0.4.2-x86_64-apple-darwin.tar.gz"
      sha256 "8a1f328c7c0b0e9abb974f7d794fa711b19ac0fc0eeb28ad00633e521aa93767"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.4.2/mcp-warden-0.4.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cc6facf100cef9bf7ee625a4a7eb8a53af060ea59c56ad57b816a97697681a81"
    end

    on_intel do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.4.2/mcp-warden-0.4.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "61f49c99713b3b1ec14b0014407faef4db94e9ff53ef1a41c5050a823fd04848"
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
