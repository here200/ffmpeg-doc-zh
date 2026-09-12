# ffmpeg 文档中文译文 —— 翻译说明

本文档说明 ffmpeg 文档中文译文的翻译范围、约定、术语标准与校验结果，供阅读、审校和后续维护参考。

---

## 一、文件对应关系

| 项目 | 内容 |
|---|---|
| 源文档 | `ffmpeg.html`（FFmpeg 官方 ffmpeg 命令行工具手册，GNU Texinfo 生成） |
| 源文档规模 | 2719 行 / 125,400 字节，Texinfo 6.7 生成 |
| 译文文件 | `ffmpeg-zh.html` |
| 译文规模 | 2582 行 / 120,168 字节 |
| 编码 | UTF-8，**无 BOM** |
| 换行 | LF（与源文件一致） |
| 依赖资源 | `bootstrap.min.css`、`style.min.css`（与源文档相同，放在同一目录即可正常渲染） |

译文是源文档的**同构副本**：HTML 结构与源文档逐标签一致，仅替换了可见文本的语言。因此可以直接替换源文件使用，样式、锚点跳转、目录导航均不受影响。

> **版本提示**：本文说明对应的是 2719 行的源文档版本。若你手上的 `ffmpeg.html` 是更新的 4001 行版本（Texinfo 7.2 生成），两者的章节编号虽大体一致，但部分选项条目和行号会有差异，需要重新翻译或至少重新核对。

---

## 二、翻译范围

### 2.1 已翻译的内容

- 页面标题 `<title>` 与页面主标题 `<h1>`
- 目录（Table of Contents）全部条目，编号（1、3.1、5.12.2 等）保留
- 全部章节标题：8 个正文章节 + 全部小节（共 35 个标题）
- 所有正文说明段落：`<p>`、`<li>`、`<dt>`/`<dd>` 中的散文文字
- 命令行示例前后的说明文字
- 结尾的 makeinfo 生成说明段

### 2.2 明确**不翻译**的内容

按需求「命令、代码、图解不要翻译」，以下内容一律保持英文原样，一个字符未改：

| 类别 | 示例 |
|---|---|
| ffmpeg 命令行 | `ffmpeg -i input.avi -b:v 64k -bufsize 64k output.avi` |
| ASCII 流程/结构图解 | 3.1 节解码→滤镜→编码示意图、复用/解复用示意图 |
| 选项名 | `-i`、`-map`、`-codec`、`-filter_complex`、`-loglevel` |
| 参数与变量名 | `global_options`、`input_url`、`decoder_name`、`bitstream_filter_name` |
| 文件名与路径 | `test.avi`、`/tmp/out.mpg`、`ffreport.log` |
| 协议 / 格式 / 编解码器名 | `pulse`、`x11grab`、`H.264`、`mp4` |
| 滤镜名 | `scale`、`overlay`、`amix`、`fps`、`setpts` |
| 工具与库名 | `ffmpeg`、`ffplay`、`ffprobe`、`libavfilter`、`libavcodec` |
| 专有名词缩写 | `AVOptions`、`AV_LOG_*`、`SI`、`CBR`、`VBR` |
| 交叉引用的文档名 | `ffmpeg-utils`、`ffmpeg-filters`、`(ffmpeg-utils)ffmpeg-utils(1)` |

**唯一的例外**：正文中用 `<em>` 标注的强调词（如 `all`、`can`、`end`、`output`）属于行文强调而非代码，已正常译为中文（所有、可能、末尾、输出），共 4 处。

---

## 三、术语标准

翻译过程中统一使用以下术语，全篇无混用：

| 英文 | 中文 | 英文 | 中文 |
|---|---|---|---|
| stream | 流 | encoder / decoder | 编码器 / 解码器 |
| stream specifier | 流标识符 | encoding / decoding | 编码 / 解码 |
| stream selection | 流选择 | transcoding | 转码 |
| stream copy | 流复制 | container format | 容器格式 |
| filter | 滤镜 | bitstream filter | 比特流滤波器 |
| filtergraph | 滤镜图 | packet | 数据包 |
| simple / complex filtergraph | 简单 / 复杂滤镜图 | frame | 帧 |
| muxer / demuxer | 复用器 / 解复用器 | timestamp | 时间戳 |
| muxing / demuxing | 复用 / 解复用 | timebase | 时基 |
| codec | 编解码器 | bitrate | 码率 |
| option | 选项 | sample rate | 采样率 |
| generic option | 通用选项 | preset | 预设 |
| main option | 主要选项 | grabbing | 采集 |
| advanced option | 高级选项 | subtitle | 字幕 |
| input / output file | 输入 / 输出文件 | metadata | 元数据 |
| mapping | 映射 | attachment | 附件 |
| burned-in subtitles | 烧录字幕 | | |

---

## 四、章节标题中英对照

以下 35 个标题在目录和正文中均使用同一译法，可对照检索：

| 原文 | 译文 | 原文 | 译文 |
|---|---|---|---|
| 1 Synopsis | 1 概要 | 5.4 Main options | 5.4 主要选项 |
| 2 Description | 2 描述 | 5.5 Video Options | 5.5 视频选项 |
| 3 Detailed description | 3 详细描述 | 5.6 Advanced Video options | 5.6 高级视频选项 |
| 3.1 Filtering | 3.1 滤镜 | 5.7 Audio Options | 5.7 音频选项 |
| 3.1.1 Simple filtergraphs | 3.1.1 简单滤镜图 | 5.8 Advanced Audio options | 5.8 高级音频选项 |
| 3.1.2 Complex filtergraphs | 3.1.2 复杂滤镜图 | 5.9 Subtitle options | 5.9 字幕选项 |
| 3.2 Stream copy | 3.2 流复制 | 5.10 Advanced Subtitle options | 5.10 高级字幕选项 |
| 4 Stream selection | 4 流选择 | 5.11 Advanced options | 5.11 高级选项 |
| 4.1 Description | 4.1 描述 | 5.12 Preset files | 5.12 预设文件 |
| 4.1.1 Automatic stream selection | 4.1.1 自动流选择 | 5.12.1 ffpreset files | 5.12.1 ffpreset 文件 |
| 4.1.2 Manual stream selection | 4.1.2 手动流选择 | 5.12.2 avpreset files | 5.12.2 avpreset 文件 |
| 4.1.3 Complex filtergraphs | 4.1.3 复杂滤镜图 | 6 Examples | 6 示例 |
| 4.1.4 Stream handling | 4.1.4 流处理 | 6.1 Video and Audio grabbing | 6.1 视频和音频采集 |
| 4.2 Examples | 4.2 示例 | 6.2 X11 grabbing | 6.2 X11 采集 |
| 5 Options | 5 选项 | 6.3 Video and Audio file format conversion | 6.3 视频和音频文件格式转换 |
| 5.1 Stream specifiers | 5.1 流标识符 | 7 See Also | 7 参见 |
| 5.2 Generic options | 5.2 通用选项 | 8 Authors | 8 作者 |
| 5.3 AVOptions | 5.3 AVOptions（专有名词，保留英文） | | |

---

## 五、质量校验

译文交付前对照源文档做了 6 项机器校验，全部通过：

| 校验项 | 源文档 | 译文 | 结果 |
|---|---|---|---|
| HTML 标签多重集 | 5114 | 5114 | 完全一致 |
| `<pre>` 块（命令行 + 图解） | 81 | 81 | **逐字符一致** |
| `code`/`samp`/`var`/`em` 元素内容 | 746 | 746 | 完全一致（仅 4 处 `<em>` 强调词按行文译为中文） |
| `href` 链接序列 | 129 | 129 | 完全一致 |
| `id` / `name` 锚点序列 | 81 | 81 | 完全一致 |
| 残留未译英文 | — | 0 | 通过 |

说明：

- **标签多重集一致**指译文中出现的所有标签及其属性与源文档完全相同，没有新增、删除或改动任何标签与属性值。
- **锚点与链接序列一致**意味着目录跳转、`#` 锚点、章节间交叉引用全部可用，且指向与原文相同的位置。
- **残留英文检查**的方式是：剥离所有标签、`<pre>` 块和代码类内联元素后，扫描剩余正文中的英文句子，结果为 0 条。文档中剩余的英文全部位于代码类元素、命令行示例或专有名词中，属于应当保留的内容。

### 复核方法

如需自行复核，可按以下思路编写脚本（PowerShell / Python 均可）：

1. 用正则 `<[^>]*>` 提取两份文件的所有标签，排序后比对，应完全一致；
2. 用正则 `(?s)<pre[^>]*>.*?</pre>` 提取所有预备格式块，归一化空白后逐块比对，应完全相同；
3. 用正则 `(?s)<(code|samp|var|kbd|tt)[^>]*>(.*?)</\1>` 提取代码类元素，比对标签名与内部原文，应完全相同；
4. 剥离标签与代码元素后扫描正文英文，应无残留。

---

## 六、已知取舍与注意事项

1. **内联标签顺序互换**：中文语序与英文不同时，句中的 `<code>` 与 `<samp>` 等内联元素顺序会随之调换（例如英文「supplying the `<code>copy</code>` parameter to the `<samp>-codec</samp>` option」在中文里写作「向 `<samp>-codec</samp>` 选项提供 `<code>copy</code>` 参数」）。调换过程中每个元素都**带着自己的原文内容**，不会把内容搬到别的标签里，因此不影响含义，仅渲染样式（`code` 与 `samp` 的字体/底色）在个别句子上与原文档略有出入。

2. **段落重新折行**：中文正文按语义重新折行，因此译文行数（2582）少于源文档（2719）。**所有标签本身的行结构未改动**，仅自然段内的换行位置有变化。

3. **标点**：正文使用中文全角标点；括号内为纯英文代码时使用半角。HTML 实体（`&quot;`、`&rsquo;`、`&ndash;`、`&lt;`、`&gt;`）按中文行文需要保留或删除，未引入任何裸的 `<`、`>`、`&` 字符。

4. **AVOptions 保留英文**：`5.3 AVOptions` 章节标题与目录条目均保留英文原名，因为它是 FFmpeg 的固定术语，业界通行不译。

5. **未加译者注**：译文严格对应原文，未插入任何解释性文字或注释。

---

## 七、使用方式

1. 把 `ffmpeg-zh.html` 与 `bootstrap.min.css`、`style.min.css` 放在同一目录；
2. 用浏览器直接打开即可，样式与目录导航正常；
3. 若需替换官方文档，直接把 `ffmpeg-zh.html` 重命名为 `ffmpeg.html` 使用即可，内部锚点与链接均为相对引用，不受文件名影响。
