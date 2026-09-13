# FFmpeg 项目文档英译中 —— 术语增补（在 GUIDE_MASTER.md 之外追加）

适用文档：`developer.html`、`faq.html`、`fate.html`、`general.html`、`git-howto.html`、`platform.html`。

**先读 `_guide/GUIDE_MASTER.md` 并遵守其全部规则**（标签/属性原样、`<pre>` 整块原样、`<code>`/`<samp>`/`<var>`/`<kbd>` 内容不译、不要复制内联元素、每个内联元素带自己的内容）。本文档只补充这批文档特有的术语与风格。

## 一、主术语表仍然适用
stream→流、filter→滤镜、filtergraph→滤镜图、muxer/demuxer→复用器/解复用器、codec→编解码器、
encoder/decoder→编码器/解码器、container→容器、packet→数据包、frame→帧、bitrate→码率、
sample rate→采样率、timestamp→时间戳、metadata→元数据、stream specifier→流标识符、
stream copy→流复制、See Also→参见、Authors→作者、Options→选项、Examples→示例、Commands→命令。

## 二、本项目文档专用术语（必须统一）

| 英文 | 中文 |
|---|---|
| patch | 补丁 |
| patchset | 补丁集 |
| commit | 提交 |
| repository | 仓库 |
| repo | 仓库 |
| branch | 分支 |
| master (branch) | master（保留英文） |
| clone | 克隆 |
| fork | 派生（或保留 fork） |
| merge | 合并 |
| rebase | 变基 |
| cherry-pick | 拣选（或保留 cherry-pick） |
| checkout | 检出 |
| push / pull | 推送 / 拉取 |
| upstream | 上游 |
| remote | 远端 |
| mailing list | 邮件列表 |
| patch review | 补丁评审 |
| reviewer | 评审者 |
| maintainer | 维护者 |
| contributor | 贡献者 |
| author | 作者 |
| commit message | 提交信息 |
| subject line | 标题行 |
| sign-off | 签署 |
| license | 许可证 |
| LGPL / GPL | 保留英文 |
| copyright | 版权 |
| build system | 构建系统 |
| configure script | configure 脚本 |
| compilation | 编译 |
| compiler | 编译器 |
| dependency | 依赖 |
| bug report | 缺陷报告 |
| bug tracker / Trac | 缺陷跟踪系统 / Trac（保留英文） |
| regression test | 回归测试 |
| test suite | 测试套件 |
| FATE | FATE（保留英文，指 FFmpeg Automated Testing Environment） |
| sample | 样本 |
| reference | 参考 |
| benchmark | 基准测试 |
| cross-compilation | 交叉编译 |
| toolchain | 工具链 |
| ABI / API | 保留英文 |
| deprecation | 弃用 |
| wrapping | 回绕 |
| overflow / underflow | 溢出 / 下溢 |
| endianness | 字节序 |
| big endian / little endian | 大端 / 小端 |
| whitespace | 空白字符 |
| indentation | 缩进 |
| tab / space | 制表符 / 空格 |
| line length | 行长 |
| code style | 代码风格 |
| function | 函数 |
| variable | 变量 |
| macro | 宏 |
| header | 头文件 |
| library | 库 |
| subdirectory | 子目录 |
| source tree | 源码树 |
| documentation | 文档 |
| man page | 手册页 |
| FAQ | 常见问题 |
| security | 安全 |
| vulnerability | 漏洞 |
| release | 发布 |
| version | 版本 |
| snapshot | 快照 |
| nightly build | 每日构建 |
| CI | 保留英文 |
| Windows / Linux / macOS / Android / iOS | 保留英文 |

## 三、保持英文不译的内容

- 命令、命令行、shell 片段（全部在 `<pre>` 中，整块不动）
- 文件名、路径、URL、邮件地址
- Git 子命令与选项：`git clone`、`git format-patch`、`--amend`、`git send-email`
- 环境变量：`PATH`、`PKG_CONFIG_PATH`、`CFLAGS` 等
- 配置项：`--enable-*`、`--disable-*`、`--prefix` 等
- 代码标识符、函数名、结构体名（`av_malloc`、`AVFrame`、`avcodec_*`）
- 许可证名：`LGPL`、`GPL`、`MIT`、`BSD`
- 人名、邮件列表名（`ffmpeg-devel`、`ffmpeg-user`）
- FATE、Trac、Git、GCC、Clang、MSVC、MinGW、MSYS2 等专名

## 四、风格

- 简体中文技术文档口吻，准确、简洁、忠于原文。
- 本批文档多为规范/指南类文字，**操作步骤、要求、禁令要译得明确**（should→应当、must→必须、may→可以、must not→不得）。
- 标题照常翻译，编号保留。
- 交叉引用的章节名按主规范译（Examples→示例、See Also→参见等）。
- 不加译者注，不增删内容。
