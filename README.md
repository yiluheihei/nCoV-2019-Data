# nCoV-2019-Data

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/yiluheihei/nCoV-2019-Data/blob/master/LICENSE)
![CI](https://github.com/yiluheihei/nCoV-2019-Data/workflows/CI/badge.svg)

## 数据怎么来的

数据来自于[DXY-COVID-19-Data](https://github.com/BlankerL/DXY-COVID-19-Data)。

包括两种数据:

1. csv
  - 全部时间序列数据[ncov.csv](ncov.csv)
  - 最新一次更新的数据[ncov_latest.csv](ncov_latest.csv)

2. RDS，保存了相应`ncov`类数据供[ncovmap](https://github.com/yiluheihei/ncovmap)直接读取
  - 全部时间序列数据[ncov.RDS](nov.RDS)
  - 最新一次更新的数据[ncov_latest.RDS](ncov_latest.RDS)

所有时间序列数据,最新的数据以`_latest`表示

## 致谢

- [DXY-COVID-19-Crawler](https://github.com/BlankerL/DXY-COVID-19-Crawler)
- [DXY-COVID-19-Data](https://github.com/BlankerL/DXY-COVID-19-Data)