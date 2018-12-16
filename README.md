# HighDAX CryptoExchange

English version can be found [here](README_en.md).

领先的加密数字交易平台

![DEMO](https://github.com/michaelliao/cryptoexchange-release/raw/master/highdax.png)

功能：

- 完全面向AWS的生产环境；
- 多币种与多交易对支持，新增币种与交易对无需停机；
- 支持REST API并集成Swagger；
- 全部专业订单类型，包括限价单、市价单、止损单、限价止损单、移动止损单、FOK订单、IOC订单、Hidden订单、PostOnly订单等；
- 高性能内存撮合引擎，速度高达每秒1万单；
- 高性能实时清算，100%无误差；
- 实时监控并收集所有性能指标；
- 实时财务审计，可实时探测数据库非法修改；
- 内置币种支持包括：BTC、BCH、USDT、ETH、ETC、ERC20；
- 高度安全的冷热分离钱包，使用标准的HD钱包机制；
- 集成工业级别的安全存储引擎[Vault](https://www.vaultproject.io/)用以存储冷钱包密钥；
- 允许对Maker/Taker设置不同费率；
- 允许对Maker设置负费率；
- 允许对买方收取计价货币作为手续费；
- 可定制预处理/后处理订单（例如，白名单检查，交易挖矿，手续费返还等）；
- 内置国际化支持，包括英文、中文、日文、韩文等；
- 内置完整的后台管理。

## 高性能架构设计

HighDAX交易系统采用高性能模块化架构设计：

![Arch](https://github.com/michaelliao/cryptoexchange-release/raw/master/design.png)

核心交易系统模块包括：

- account：为每个用户提供各币种的可用/冻结/锁定账户模型，不但可支持高速交易，还可为钱包系统提供锁定功能（例如，ERC代币锁定）；
- sequence：32路高性能定序系统，可并发32路定序；
- match：为每个交易对提供高达每秒1万单的内存撮合，定期持久化快照，并可从任意时间点恢复；
- clearing：实时异步高性能清算系统，可实现并行清算、多次清算但完全确保最终清算结果的一致性；
- notification：基于Vertx的高性能WebSocket推送，可实时推送市场信息与用户订单成交信息；

HighDAX交易系统采用RocketMQ作为高性能/高可靠的消息系统。为充分提高系统性能，HighDAX尽可能对多个消息进行批处理。此外，HighDAX在消息发送方/接收方实现了消息重复检测、消息遗漏检测，可100%完全确保有序消息不乱序、不丢消息，极大地降低了运维成本。

## 超高安全性冷钱包设计

HighDAX冷钱包使用(Vault)[https://www.vaultproject.io/]作为加密存储引擎存储HD钱包的HD扩展根密钥。Vault是一款工业级的开源加密存储引擎，具有非常高的安全性。

在冷钱包初始化阶段，初始化程序会自动创建*随机*助记词和*随机*口令，并立刻写入Vault，然后通过Vault的3/5分散密钥将口令分散至5个人。整个过程无人可见助记词和口令，启动冷钱包的唯一途径是通过3/5分散密钥。

此方案保证了任何人（包括系统管理员）也不可见钱包根密钥。在部分分散密钥丢失、疑似泄漏、需要密钥交接时，可更换分散密钥，原有的分散密钥作废。唯一需要安全备份的是Vault加密文件。

除冷钱包外，HighDAX交易系统、UI系统、热钱包以及数据库均*不存储*任何私钥，极大地保障了钱包的安全性。

### 术语

- 分散密钥：一组M/N分散密钥是指由一个主密钥通过Shamir算法将密钥分成N份，满足M份即可恢复主密钥。例如，Vault默认使用3/5分散密钥，对于这5个分散密钥，任意3个密钥组合即可恢复主密钥。

- HD助记词和HD口令：由BIP39规定的一组HD助记词（最多24个）和一个特定的HD口令（长度任意）可唯一确定一个扩展根私钥（xprv），使用此扩展根私钥可根据BIP44规范为所有币种创建不同的确定性地址。

## 实时审计系统

HighDAX系统内置实时财务审计系统，时刻自动对每一笔订单、清算记录及账户更改进行审计对账。无需对账务进行离线对账，实时审计系统确保系统任意时刻的资产负债表总额为0。一旦出现任何账务错误，系统将自动暂停并停止接受任何订单与提币请求。

任何对数据库的直接非法修改都将导致实时审计系统报警并暂停整个交易系统。

## 软件运行平台

HighDAX运行平台：

### OS

64bit Linux，推荐AWS官方Ubuntu Server x64镜像。

### Software

JDK 1.8，推荐通过APT安装`openjdk-8-jre-headless`。

MySQL 5.7，推荐使用AWS托管的RDS/Aurora。

Redis 4.x，推荐使用AWS托管的ElasticCache。

OpenResty 1.11；

RocketMQ 4.2；

NodeJS 10.x。

## 部署

HighDAX采用符合行业标准，基于Jenkins和Ansible的完全自动化构建与部署方案，可在几分钟内实现一键部署。

### 安全防护

为AWS定制的安全防护，并可直接接入CloudFlare CDN，可自定义限速、DDoS防护、高性能分发并完全隐藏服务器IP。
