# ffplay.html 英译中 —— 统一规范（所有分块必须遵守）

## 任务本质
把 `D:\Change\WorkspaceInDeepSeek\Translation\ffplay.html` 的**英文正文**翻译成简体中文。
这是 GNU Texinfo 7.2 生成的 HTML 文档。**只翻译可见文本，绝不改动结构。**

## 绝对禁止改动的内容
1. **任何 HTML 标签本身**：标签名、属性名、属性值（`href`、`id`、`name`、`class`、`style`、`align`、`aria-hidden`、`role` 等）一律逐字符保持原样。
   - 不能新增、删除、合并、拆分任何标签。
   - 标签内的换行/缩进/空格保持不变。
2. **`<pre>` 块内的全部内容**（`<pre class="example-preformatted">` 里的命令行、`<pre class="verbatim">` 里的 ASCII 图解）：**一个字符都不许改**。
3. **代码/参数标识符**：`<code>`、`<samp>`、`<var>`、`<kbd>`、`<tt>` 元素内部的内容**不翻译**：
   - `<samp class="option">-L, -license</samp>`、`<var class="var">arg</var>`、`<samp class="file">input_url</samp>` 全部保持英文。
   - `<kbd class="key">q, ESC</kbd>`、`<kbd class="key">/, *</kbd>` 等按键名**不翻译**（q、ESC、SPC、方向键等保持原样）。
4. 文件名、URL、协议名、编解码器名、格式名、滤镜名、选项名保持英文（`ffplay`、`ffmpeg`、`SDL`、`libavfilter`、`pulse` 等）。
5. `<!DOCTYPE ...>`、注释、`<html>`/`<head>` 结构不动。
6. 不要重新格式化、不要重新折行已有标签行、不要删空行、不要加空行。

## 必须翻译的内容（重点，上一轮曾出现遗漏）
- `<title>`：`ffplay Documentation` → `ffplay 文档`；`<h1>` 同理。
- 目录标题 `<h2 class="contents-heading">Table of Contents</h2>` → `目录`。
- **目录里每一个 `<a>` 的可见文字**，例如 `<a id="toc-Synopsis" href="#Synopsis">1 Synopsis</a>` → `1 概要`。编号（1、3.1、3.6 等）保留。
- **所有 `<h2 class="chapter">`、`<h3 class="section">`、`<h4 class="subsection">` 标题的可见文字**（即 `<span class="pull-right">` 之前的文字），例如：
  - `3 Options` → `3 选项`
  - `3.1 Stream specifiers` → `3.1 流标识符`
  - `3.2 Generic options` → `3.2 通用选项`
  - `3.3 AVOptions` → `3.3 AVOptions`（专有名词，保持英文）
  - `3.4 Main options` → `3.4 主要选项`
  - `3.5 Advanced options` → `3.5 高级选项`
  - `3.6 While playing` → `3.6 播放过程中`
  - `4 See Also` → `4 参见`
  - `5 Authors` → `5 作者`
- **关键要求：目录条目与正文章节标题的译法必须完全一致**（正文标题与目录用同一串中文）。
- 所有 `<p>`、`<li>`、`<dt>`、`<dd>` 里的普通英文说明文字。

## 术语表（必须统一使用）
| 英文 | 中文 |
|---|---|
| media player | 媒体播放器 |
| stream | 流 |
| stream specifier | 流标识符 |
| filter | 滤镜 |
| filtergraph | 滤镜图 |
| muxer / demuxer | 复用器 / 解复用器 |
| muxing / demuxing | 复用 / 解复用 |
| codec | 编解码器 |
| encoder / decoder | 编码器 / 解码器 |
| container format | 容器格式 |
| bitstream filter | 比特流滤波器 |
| packet | 数据包 |
| frame | 帧 |
| option | 选项 |
| generic option | 通用选项 |
| main option | 主要选项 |
| advanced option | 高级选项 |
| input file / output file | 输入文件 / 输出文件 |
| sample rate | 采样率 |
| timestamp | 时间戳 |
| bitrate | 码率 |
| volume | 音量 |
| mute | 静音 |
| full screen | 全屏 |
| seek | 定位 / 跳转 |
| toggle | 切换 |
| quit | 退出 |
| cycle | 循环切换 |
| program | 节目 |
| subtitle channel | 字幕轨 |
| audio channel / video channel | 音频轨 / 视频轨 |
| key bindings | 按键 |
| testbed | 测试平台 |
| portable | 可移植 |
| decoding / encoding | 解码 / 编码 |
| transcoding | 转码 |
| preset | 预设 |
| metadata | 元数据 |
| AVOptions / SDL | 保持英文 |

## 语言风格
- 简体中文，技术文档口吻，简洁准确，忠于原文含义，不增删内容、不加译者注。
- 标点使用中文全角标点（，。、：；？！（）），但括号内是纯英文代码时可用半角。
- 句子中夹着 `<code>`/`<samp>`/`<var>`/`<kbd>` 元素时，翻译后这些元素仍要留在句中语义正确的位置；若中文语序导致两个内联元素位置互换（例如 `<code>x</code>` 与 `<samp>y</samp>` 交换先后），**必须保持每个元素带着自己的原文内容**，不能把内容搬到别的标签里。
- HTML 实体（`&quot;` `&rsquo;` `&ndash;` `&lt;` `&gt;` `&amp;`）保持原样；中文里确实不需要时可删掉该实体，但**不得**引入裸的 `<`、`>`、`&` 字符。
- 不要把中文放进 `<pre>`、`<code>`、`<samp>`、`<var>`、`<kbd>` 中。

## 输出
把翻译结果用 `write` 工具写入指定路径（UTF-8，无 BOM），内容是**该行区间的完整翻译结果**，可直接与原文件其他区间拼接。
不要输出任何解释、前言、代码围栏，只写文件。
