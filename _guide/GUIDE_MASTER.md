# FFmpeg 配套文档英译中 —— 主规范（9 份文档通用）

适用文档：`ffmpeg-bitstream-filters.html`、`ffmpeg-codecs.html`、`ffmpeg-devices.html`、`ffmpeg-filters.html`、`ffmpeg-formats.html`、`ffmpeg-protocols.html`、`ffmpeg-resampler.html`、`ffmpeg-scaler.html`、`ffmpeg-utils.html`。
全部为 GNU Texinfo 7.2 生成的 HTML，结构一致。

---

## 一、最高原则

**只把可见英文文本替换成中文。HTML 结构一个字节都不许变。**

具体地说：

1. 不新增、删除、合并、拆分、移动任何标签；不改标签名、属性名、属性值（`href`、`id`、`name`、`class`、`style`、`align`、`aria-hidden`、`role` 等）。
2. 保留原文的换行位置、缩进、空行。**不要重新折行标签行**，不要给段落加空行或删空行。
   - 注意原文里存在 `<a class="anchor hidden-xs"href=` 这种**缺空格**的写法，照抄，不要补空格。
3. `<pre>` 块内部一律不动，包括：
   - `<pre class="example-preformatted">` 里的命令行；
   - ASCII 图表、矩阵、状态图；
   - BNF/语法定义块（如 `<var class="var">INTERVAL</var>  ::= [...]`）；
   - 采样格式列表、像素格式列表等表格化文本。
   - **`<pre>` 块内部即使含有 `<var>`/`<code>` 标签，也整块保持原样。**
4. `<code>`、`<samp>`、`<var>`、`<kbd>`、`<tt>` 元素内部不翻译。选项名、参数名、取值、格式名、编解码器名、滤镜名、协议名、设备名、文件名、URL 一律保持英文。
5. `<!DOCTYPE ...>`、HTML 注释、`<html>`/`<head>`/`<meta>`/`<link>` 不动。
6. 用 `write` 工具输出：UTF-8 **无 BOM**、无 Markdown 代码围栏、无任何解释文字，文件内容就是该行区间的完整翻译结果。

---

## 二、必须翻译的内容

- `<title>` 与 `<h1>`（例如 `ffmpeg-codecs Documentation` → `ffmpeg-codecs 文档`）。
- 目录标题 `Table of Contents` → `目录`。
- 所有 `<h2 class="chapter">`、`<h3 class="section">`、`<h4 class="subsection">`、`<h5 class="subsubsection">` 标题的可见文字（`<span class="pull-right">` 之前的部分）。**编号（3、5.12、8.42.3 等）保留不动。**
- 目录中每个 `<a>` 的可见文字。
- 所有 `<p>`、`<li>`、`<dt>`、`<dd>`、`<em>` 里的普通英文说明文字。
- `<caption>`、表头单元格等其它可见文本。

---

## 三、主术语表（**必须严格统一**，这是全站一致性要求）

| 英文 | 中文 | 英文 | 中文 |
|---|---|---|---|
| stream | 流 | bitstream filter | 比特流滤波器 |
| stream specifier | **流标识符** | packet | **数据包** |
| stream selection | 流选择 | frame | 帧 |
| stream copy | **流复制** | option | 选项 |
| stream handling | 流处理 | generic option | 通用选项 |
| filter | **滤镜** | main option | 主要选项 |
| filtering | **滤镜**（作名词/标题时）| advanced option | 高级选项 |
| filtergraph | 滤镜图 | input file / output file | 输入文件 / 输出文件 |
| simple / complex filtergraph | 简单 / 复杂滤镜图 | sample rate | 采样率 |
| muxer / demuxer | 复用器 / 解复用器 | timestamp | 时间戳 |
| muxing / demuxing | 复用 / 解复用 | timebase | 时基 |
| codec | 编解码器 | bitrate | 码率 |
| encoder / decoder | 编码器 / 解码器 | preset | 预设 |
| encoding / decoding | 编码 / 解码 | grabbing | 采集 |
| transcoding | 转码 | subtitle | 字幕 |
| container / container format | 容器 / 容器格式 | attachment | 附件 |
| metadata | 元数据 | data stream | 数据流 |
| tag | 标签 | raw | 原始 |
| mapping | 映射 | burn in（字幕）| 烧录 |
| See Also | **参见** | Authors | 作者 |
| Video and Audio | **视频和音频** | Synopsis | 概要 |
| Description | 描述 | Options | 选项 |

补充要求：

- **滤镜名、编解码器名、协议名、设备名、格式名、选项名一律不译**（`scale`、`overlay`、`libx264`、`h264_mp4toannexb`、`rtmp`、`v4l2`、`-crf` 等）。
- 交互式滤镜/滤镜图语法、`%` 占位符、正则、转义序列保持原样。
- 中英文之间不加多余空格；标点用中文全角（，。、：；？！（）），括号内是纯英文代码时可用半角。
- HTML 实体（`&quot;` `&rsquo;` `&lsquo;` `&ndash;` `&lt;` `&gt;` `&amp;`）保持原样；中文里确实不需要时可删掉该实体，但**不得**引入裸的 `<`、`>`、`&`。

---

## 四、两个必须避免的坑（上一批真实踩到过）

1. **不要复制内联元素**。
   中文习惯重复主语，很容易把 `<var class="var">xxx</var>` 抄两遍。原文出现一次就必须只出现一次。
   - 错误：`为 <var>media_specifier</var> 所标识的流……，<var>media_specifier</var> 可以取值 <code>a</code>……`
   - 正确：`为 <var>media_specifier</var> 所标识的流……，该参数可以取值 <code>a</code>……`
2. **每个内联元素必须带着自己的内容**。
   中文语序会让元素顺序变化（例如原文「A `<code>x</code>` 与 B `<samp>y</samp>`」译成「B `<samp>y</samp>` 与 A `<code>x</code>`」），顺序可变，但**绝不能把内容搬到别的标签里**（`<code>` 里不能装原本属于 `<samp>` 的内容，反之亦然）。

---

## 五、质量标准

- 简体中文，技术文档口吻，准确、简洁、忠于原文含义。
- 不增删内容，不加译者注，不省略任何段落。
- 长句可拆分、可调整语序以符合中文表达，但信息必须无损。
- 同一分块内同一术语必须统一。

---

## 六、输出

用 `write` 工具写入指定路径，内容为**所给行区间的完整翻译结果**，可直接与其它区间的产物拼接。
文件开头就是该区间第一行的翻译，结尾就是该区间最后一行的翻译，不多不少。
