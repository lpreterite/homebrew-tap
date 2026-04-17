class McpGateway < Formula
  desc "MCP 统一网关 - 连接多个 MCP 服务器的统一网关"
  homepage "https://github.com/lpreterite/mcp-gateway"
  version "v1.0.1"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.0.1/mcp-gateway-darwin-arm64"
      sha256 "bf26fc7fb1f633c80bc28e184d75a7cecffea8ef0236dac251d9794d746d9a74"
    else
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.0.1/mcp-gateway-darwin-amd64"
      sha256 "1f7cf4d1949324252d960a8a61c10e8240f16d226eff741db842b24d225a3e79"
    end
  end

  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.0.1/mcp-gateway-linux-arm64"
      sha256 "7c67cd209fbc7715d9d59da67c5c8a3077abbc01f2e91ac3857519c65c971c53"
    else
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.0.1/mcp-gateway-linux-amd64"
      sha256 "dfb3a416f488a67c20623219613435a1e10f2b94f0db0854a54cabb0c29f7319"
    end
  end

  def install
    if OS.mac?
      if Hardware::CPU.arm?
        bin.install "mcp-gateway-darwin-arm64" => "mcp-gateway"
      else
        bin.install "mcp-gateway-darwin-amd64" => "mcp-gateway"
      end
    else
      if Hardware::CPU.arm?
        bin.install "mcp-gateway-linux-arm64" => "mcp-gateway"
      else
        bin.install "mcp-gateway-linux-amd64" => "mcp-gateway"
      end
    end

    # 生成示例配置文件
    (etc/"mcp-gateway").mkpath
    (etc/"mcp-gateway/config.json").write <<~JSON
      {
        "gateway": {
          "host": "0.0.0.0",
          "port": 4298,
          "cors": true
        },
        "pool": {
          "minConnections": 1,
          "maxConnections": 5,
          "acquireTimeout": 5000,
          "idleTimeout": 30000
        },
        "servers": [
          {
            "name": "example",
            "type": "local",
            "command": ["echo", "hello"],
            "enabled": true,
            "poolSize": 1
          }
        ],
        "mapping": {}
      }
    JSON
  end

  def post_install
    ohai "MCP Gateway 安装完成！"
    ohai ""
    ohai "配置文件: #{etc}/mcp-gateway/config.json"
    ohai "日志文件: #{var}/log/mcp-gateway.log"
    ohai ""
    ohai "请编辑 #{etc}/mcp-gateway/config.json 添加你的 MCP 服务器"
    ohai ""
    ohai "启动服务: brew services start #{name}"
    ohai "停止服务: brew services stop #{name}"
    ohai "查看日志: tail -f #{var}/log/mcp-gateway.log"
  end

  service do
    run [opt_bin/"mcp-gateway", "--config", etc/"mcp-gateway/config.json"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path "#{var}/log/mcp-gateway.log"
    error_log_path "#{var}/log/mcp-gateway.err.log"
  end

  test do
    system "#{bin}/mcp-gateway", "--version"
  end
end
