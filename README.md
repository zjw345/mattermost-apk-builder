# Mattermost Android APK Builder (Docker + GitHub Actions)

本项目用于在 GitHub Actions 中使用 Docker 自动构建 Mattermost Android 应用（APK）。

## 📦 用法

### 步骤 1: 添加 GitHub Secrets

在仓库中设置以下 Secret：

- `KEYSTORE_BASE64`：将 `android-apk-signing.keystore` 转为 base64 后粘贴
- `BUILD_CONF_BASE64`：将配置后的 `build.conf` 转为 base64 后粘贴

命令参考：

```bash
base64 -w 0 android-apk-signing.keystore > keystore.b64
base64 -w 0 build.conf > build_conf.b64
```

### 步骤 2: 手动触发构建

进入 GitHub → Actions → 选择 `Build Mattermost APK` → 点击 `Run workflow`

### 构建完成后

APK 文件将打包在 `Actions` → `Artifacts` 中供下载。
