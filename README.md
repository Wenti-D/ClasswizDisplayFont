# CASIO Classwiz 屏幕显示字体

**来自卡西欧计算器屏幕上的像素字体！**

![ClassWizDisplay](readme_assets/ClassWizDisplay.svg)

## 食用方法

字体分为四部分：X Display、CW Display、Math X 与 Math CW。带有「Display」的字体用作普通文本，提供 OTF、TTF 与 WOFF2（自 v3.001 起）格式；带有「Math」的字体由 Opentype MATH 表强力驱动，用作数学公式输入，仅提供 OTF 格式。

打包好的字体可以到 [Release 页面](https://github.com/Wenti-D/ClasswizDisplayFont/releases)获取。本文只是关于字体的一个粗略说明，而**压缩包内除字体外还有自述文件（`README.pdf` 之类的文档），使用前请一定、务必、绝对要认真、仔细、用心阅读！**

如果觉得本项目对你有帮助，不妨点一下页面右上角的 ☆。

## 构建字体

### Display 部分

Display 部分的字体源文件以[统一字体对象 3（UFO 3）](https://unifiedfontobject.org/versions/ufo3/index.html)格式提供，看起来像一个以 `.ufo` 结尾的文件夹。很多字体设计软件都可以读取 UFO 字体，例如 [Fontforge](https://fontforge.org/)，欲编辑字体，可以下载它。但若只是想构建字体，则 Google 的 [`fontmake`](https://github.com/googlefonts/fontmake) 工具集也可以处理，它依赖 Python 工作，所以记得预先安装 Python 与 `pip`。

此存储库为 Windows 系统用户制作了一个构建脚本，Windows 用户可以做至以下第 1 步，然后直接双击 `build.bat`即可。接下来是利用 `fontmake` 构建字体的详细流程：

0. 安装 Python，以及 `pip`。
1. 将本项目克隆到一个合适的位置。
    ```shell
    git clone https://github.com/Wenti-D/ClasswizDisplayFont
    ```

2. 建议创建一个 Python 虚拟环境：
    ```shell
    python -m venv <your_venv_name>
    ```
    
    Windows 平台使用以下命令激活：
    ```batchfile
    ./<your_venv_name>/Script/activate
    ```
        
    Linux 平台使用以下命令激活：
    ```shell
    source <your_venv_name>/bin/activate
    ```

3. 安装依赖：
    ```shell
    python -m pip install -r requirements.txt
    ```

4. 构建字体：

    OTF 与 TTF 格式使用 `fontmake` 构建：
    ```shell
    fontmake -u ClassWizXDisplay-Regular.ufo --output-dir output
    fontmake -u ClassWizCWDisplay-Regular.ufo --output-dir output
    ```

    WOFF2 格式使用 `fonttools` 构建，可以使用 Python 脚本（推荐）：
    ```python
    # python script
    from fontTools.ttLib.woff2 import compress
    compress('output/ClassWizXDisplay-Regular.otf', 'output/ClassWizXDisplay-Regular.woff2')
    compress('output/ClassWizXDisplay-Regular.otf', 'output/ClassWizXDisplay-Regular.woff2')
    ```
    
    或者 Shell 命令（不推荐）：
    ```shell
    python -c "from fontTools.ttLib.woff2 import compress; compress('output/ClassWizXDisplay-Regular.otf', 'output/ClassWizXDisplay-Regular.woff2')"
    python -c "from fontTools.ttLib.woff2 import compress; compress('output/ClassWizCWDisplay-Regular.otf', 'output/ClassWizCWDisplay-Regular.woff2')"
    ```

    构建好的字体将会位于 `output` 文件夹内。

### Math 部分

Math 部分的字体源文件以 [Fontforge](https://fontforge.org/) 源文件格式提供，是一个扩展名为 `.sfd` 的文件。欲编辑、构建字体，请下载 Fontforge。

## 贡献与反馈

如有任何问题或建议，还请开启一个议题（issue）。

