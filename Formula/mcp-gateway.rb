class McpGateway < Formula
  desc "MCP 统一网关 - 连接多个 MCP 服务器的统一网关"
  homepage "https://github.com/lpreterite/mcp-gateway"
  version "v1.2.3"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.2.3/mcp-gateway-darwin-arm64"
      sha256 "fcb361eac655ddc6c44c71e2130c7e217dbdc7ef0a928ef29fec73e6d0115253"
    else
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.2.3/mcp-gateway-darwin-amd64"
      sha256 "c7baa74c0b4aeeb91a9dc723f422e13a1fed12d03fe400aa3b77f001f1b0d65e"
    end
  end

  def install
    on_macos do
      if Hardware::CPU.arm?
        bin.install "mcp-gateway-darwin-arm64" => "mcp-gateway"
      else
        bin.install "mcp-gateway-darwin-amd64" => "mcp-gateway"
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
    ohai "🚀 推荐使用内置服务管理功能 (自动检测 PATH 环境变量)："
    ohai "   1. 编辑配置文件 #{etc}/mcp-gateway/config.json"
    ohai "   2. 安装并启动服务："
    ohai "      mcp-gateway service install --config #{etc}/mcp-gateway/config.json"
    ohai "      mcp-gateway service start"
    ohai ""
    ohai "📋 常用命令："
    ohai "   mcp-gateway service status    # 检查服务状态"
    ohai "   mcp-gateway service restart   # 重启服务"
    ohai "   mcp-gateway service uninstall # 卸载服务"
    ohai ""
    ohai "请编辑 #{etc}/mcp-gateway/config.json 添加你的 MCP 服务器"
  end

  test do
    assert_match /version/, shell_output("#{bin}/mcp-gateway --version")
    assert_match /mcp-gateway/, shell_output("#{bin}/mcp-gateway --help")
  end
end
