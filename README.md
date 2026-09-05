# 日序 Cloudflare 部署包

这是“日序 · Daily Order”的 Cloudflare Workers + D1 版本。手机和电脑访问同一网址，内容保存在云端。

## 部署

1. 安装 Node.js：https://nodejs.org/
2. 解压本部署包。
3. 双击“部署到Cloudflare.bat”。
4. 浏览器弹出时登录 Cloudflare 并授权。
5. 按提示输入日序访问密码。
6. 部署结束后，复制窗口里 https:// 开头的网址到手机。

部署后可在 https://dash.cloudflare.com/ 的 Workers & Pages 中看到 rixu，D1 中看到 rixu-db。

数据存储在 Cloudflare D1，不依赖电脑开机。密码通过 Cloudflare Secret 保存，不会写入源代码。
