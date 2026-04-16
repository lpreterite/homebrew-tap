class McpGateway < Formula
  desc "MCP 统一网关 - 连接多个 MCP 服务器的统一网关"
  homepage "https://github.com/lpreterite/mcp-gateway"
  version "#{VERSION}"
  sha256 "#{SHA256_DARWIN_ARM64}"

  depends_on "go" => :build

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lpreterite/mcp-gateway/releases/download/#{VERSION}/mcp-gateway-darwin-arm64"
      sha256 "#{SHA256_DARWIN_ARM64}"
    else
      url "https://github.com/lpreterite/mcp-gateway/releases/download/#{VERSION}/mcp-gateway-darwin-amd64"
      sha256 "#{SHA256_DARWIN_AMD64}"
    end
  end

  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lpreterite/mcp-gateway/releases/download/#{VERSION}/mcp-gateway-linux-arm64"
      sha256 "#{SHA256_LINUX_ARM64}"
    else
      url "https://github.com/lpreterite/mcp-gateway/releases/download/#{VERSION}/mcp-gateway-linux-amd64"
      sha256 "#{SHA256_LINUX_AMD64}"
    end
  end

  def install
    bin.install "mcp-gateway"
  end

  test do
    system "#{bin}/mcp-gateway", "--version"
  end
end
