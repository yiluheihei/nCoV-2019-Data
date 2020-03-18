# nCoV-2019-Data

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/yiluheihei/nCoV-2019-Data/blob/master/LICENSE)
![CI](https://github.com/yiluheihei/nCoV-2019-Data/workflows/CI/badge.svg)

## 数据怎么来的

数据通过[DXY-COVID-19-Crawler](https://github.com/BlankerL/DXY-COVID-19-Crawler)
提供的 API 接口下载。

目前只包含 area 数据，包括了所有数据。

## 产生这个数据的原因

见[这个issue](https://github.com/BlankerL/DXY-COVID-19-Data/issues/39)。

与数据仓库[DXY-COVID-19-Data](https://github.com/BlankerL/DXY-COVID-19-Data)提供
的 DXYArea.csv 文件的区别是：

- 包含了国外数据
- 数据是每一行`province`的数据与`city`的数据放在一起，用`province_`和`city_`前缀
辨别；我做的数据是把`province`的数据单独放置在一行，省去了`province_`和`city_`前
缀，直接用api中变量名表示。

剩下的 Overall/News/Rumors直接从
[DXY-COVID-19-Data](https://github.com/BlankerL/DXY-COVID-19-Data/csv)下载

## 致谢

- [DXY-COVID-19-Crawler](https://github.com/BlankerL/DXY-COVID-19-Crawler)
- [DXY-COVID-19-Data](https://github.com/BlankerL/DXY-COVID-19-Data)