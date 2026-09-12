# ffprobe.html 英译中 —— 统一规范（所有分块必须遵守）

## 任务本质
把 `D:\Change\WorkspaceInDeepSeek\Translation\ffprobe.html` 的**英文正文**翻译成简体中文。
这是 GNU Texinfo 7.2 生成的 HTML 文档。**只翻译可见文本，绝不改动结构。**

## 绝对禁止改动的内容
1. **任何 HTML 标签本身**：标签名、属性名、属性值（`href`、`id`、`name`、`class`、`style`、`align`、`aria-hidden`、`role` 等）一律逐字符保持原样。
   - 不能新增、删除、合并、拆分任何标签。
   - 标签内的换行/缩进/空格保持不变（注意原文中 `<a class="anchor hidden-xs"href=` 这种缺空格的写法也要照抄）。
2. **`<pre>` 块内的全部内容一个字都不许改**，包括：
   - `<pre class="example-preformatted">` 里的 ffprobe/ffmpeg 命令行；
   - 第 3.4 节的 **BNF 语法定义块**（如 `<var class="var">LOCAL_SECTION_ENTRIES</var> :`、`<var class="var">INTERVAL</var>  ::= [...]`）——这些块内部虽然有 `<var>` 标签，也**整块保持原样**，不翻译、不改标签；
   - 第 4 节的各 writer 输出示例（`[SECTION]`、`section|key1=val1| ... |keyN=valN`、JSON/XML 示例等）。
3. **代码/参数标识符**：`<code>`、`<samp>`、`<var>`、`<kbd>`、`<tt>` 元素内部的内容**不翻译**：
   - `<samp class="option">-show_streams</samp>`、`<var class="var">key</var>`、`<samp class="file">input_url</samp>` 全部保持英文。
   - `<samp class="samp">fail</samp>`、`<samp class="samp">replace</samp>` 等取值也保持英文。
4. 文件名、URL、协议名、格式名、writer 名、选项名保持英文（`ffprobe`、`ffmpeg`、`json`、`xml`、`ini`、`csv`、`flat`、`pulse`、`compact` 等）。
5. `<!DOCTYPE ...>`、注释、`<html>`/`<head>` 结构不动。
6. 不要重新格式化、不要重新折行已有标签行、不要删空行、不要加空行。

## 必须翻译的内容
- `<title>`：`ffprobe Documentation` → `ffprobe 文档`；`<h1>` 同理。
- 目录标题 `<h2 class="contents-heading">Table of Contents</h2>` → `目录`。
- **目录里每一个 `<a>` 的可见文字**，编号（1、3.1、4.6 等）保留。
- **所有章节/小节标题**（即 `<span class="pull-right">` 之前的文字）。**必须严格按下面这张表翻译**，目录条目与正文标题要用完全相同的中文，不允许自由发挥：

| 原文标题 | 规定译法 |
|---|---|
| 1 Synopsis | 1 概要 |
| 2 Description | 2 描述 |
| 3 Options | 3 选项 |
| 3.1 Stream specifiers | 3.1 流标识符 |
| 3.2 Generic options | 3.2 通用选项 |
| 3.3 AVOptions | 3.3 AVOptions（专有名词，保持英文） |
| 3.4 Main options | 3.4 主要选项 |
| 4 Writers | 4 写出器 |
| 4.1 default | 4.1 default（writer 名称，保持英文） |
| 4.2 compact, csv | 4.2 compact, csv（writer 名称，保持英文） |
| 4.3 flat | 4.3 flat（writer 名称，保持英文） |
| 4.4 ini | 4.4 ini（writer 名称，保持英文） |
| 4.5 json | 4.5 json（writer 名称，保持英文） |
| 4.6 xml | 4.6 xml（writer 名称，保持英文） |
| 5 Timecode | 5 时间码 |
| 6 See Also | 6 参见 |
| 7 Authors | 7 作者 |

- 所有 `<p>`、`<li>`、`<dt>`、`<dd>` 里的普通英文说明文字。

## 术语表（必须统一使用）
| 英文 | 中文 |
|---|---|
| writer | 写出器 |
| output format | 输出格式 |
| stream | 流 |
| stream specifier | 流标识符 |
| filter | 滤镜 |
| muxer / demuxer | 复用器 / 解复用器 |
| codec | 编解码器 |
| encoder / decoder | 编码器 / 解码器 |
| container / container format | 容器 / 容器格式 |
| packet | 数据包 |
| frame | 帧 |
| option | 选项 |
| generic option | 通用选项 |
| main option | 主要选项 |
| input file | 输入文件 |
| sample rate | 采样率 |
| timestamp | 时间戳 |
| timecode | 时间码 |
| bitrate | 码率 |
| metadata | 元数据 |
| tag | 标签 |
| section | 节 |
| key/value pair | 键=值 对 |
| separator | 分隔符 |
| escaping / escaped | 转义 / 转义后的 |
| validation | 校验 |
| interval | 区间 |
| syntax | 语法 |
| default value | 默认值 |
| decimal | 十进制 |
| position / positional | 位置 / 按位置 |
| raw | 原始 |
| AVOptions / BNF / JSON / XML / CSV / INI / UTF-8 | 保持英文 |

## 语言风格
- 简体中文，技术文档口吻，简洁准确，忠于原文含义，不增删内容、不加译者注。
- 标点使用中文全角标点（，。、：；？！（）），但括号内是纯英文代码时可用半角。
- 句子中夹着 `<code>`/`<samp>`/`<var>` 元素时，翻译后这些元素仍要留在句中语义正确的位置；若中文语序导致两个内联元素位置互换，**必须保持每个元素带着自己的原文内容**，不能把内容搬到别的标签里。
- HTML 实体（`&quot;` `&rsquo;` `&lsquo;` `&ndash;` `&lt;` `&gt;` `&amp;`）保持原样；中文里确实不需要时可删掉该实体，但**不得**引入裸的 `<`、`>`、`&` 字符。
- 不要把中文放进 `<pre>`、`<code>`、`<samp>`、`<var>`、`<kbd>` 中。

## 输出
把翻译结果用 `write` 工具写入指定路径（UTF-8，无 BOM），内容是**该行区间的完整翻译结果**，可直接与原文件其他区间拼接。
不要输出任何解释、前言、代码围栏，只写文件。
