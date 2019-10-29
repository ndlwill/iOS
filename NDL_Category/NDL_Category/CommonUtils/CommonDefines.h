//
//  CommonDefines.h
//  NDL_Category
//
//  Created by ndl on 2018/1/30.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// 命名神器
// https://unbug.github.io/codelf/

// PS: 混合模式
// https://helpx.adobe.com/cn/photoshop/using/blending-modes.html

// core animation
// https://blog.csdn.net/u013282174/article/category/6014571

// meituan
// https://tech.meituan.com/
// https://juejin.im/user/593fb40eda2f6000673bdc61/posts

// Alibaba
// https://github.com/alibaba/wax

// bash
// http://www.reddragonfly.org/abscn/index.html

// Protobuf
// http://www.52im.net/thread-1510-1-1.html

// 即时通讯大牛http
// https://www.jianshu.com/u/a240b0ea61be
// TCP/IP详解 卷1：协议
// http://www.52im.net/topic-tcpipvol1.html?mobile=no

// [组件化]
// https://blog.csdn.net/zramals/article/details/81875458

/*
 传统路由方式JLRouter:
 保存一个全局的Map，key是url，value是对应存放block的数组，url和block都会常驻在内存中，当打开一个URL时，JLRoutes就可以遍历 , 这个全局的map，通过url来执行对应的block
 
 CTMediator:
 */

/*
 通信技术直面的是网络通信物理层 （交换机、路由器、天线等）
 */

// 网口（interface）

// URL (Uniform Resource Locator，统一资源定位符)

// WebRTC（网页实时通信Web Real-Time Communication）


// https://blog.csdn.net/whgtheone/article/category/7778545
// https://www.imooc.com/article/29367
// https://www.imooc.com/article/29368
/*
 ##建连接时SYN超时##
 
 如果server端接到了clien发的SYN后回了SYN-ACK后client掉线了，server端没有收到client回来的ACK，那么，这个连接处于一个中间状态，即没成功，也没失败。于是，server端如果在一定时间内没有收到的TCP会重发SYN-ACK。在Linux下，默认重试次数为5次，重试的间隔时间从1s开始每次都翻售，5次的重试时间间隔为1s, 2s, 4s, 8s, 16s，总共31s，第5次发出后还要等32s都知道第5次也超时了，所以，总共需要 1s + 2s + 4s+ 8s+ 16s + 32s = 2^6 -1 = 63s，TCP才会把断开这个连接
 */

/*
 ##关于ISN的初始化##
 
 ISN是不能hard code的，不然会出问题的——比如：如果连接建好后始终用1来做ISN，如果client发了30个segment过去，但是网络断了，于是 client重连，又用了1做ISN，但是之前连接的那些包到了，于是就被当成了新连接的包，此时，client的Sequence Number 可能是3，而Server端认为client端的这个号是30了
 
 RFC793中说,ISN会和一个假的时钟绑在一起，这个时钟会在每4微秒对ISN做加一操作，直到超过2^32，又从0开始。这样，一个ISN的周期大约是4.55个小时。因为，我们假设我们的TCP Segment在网络上的存活时间不会超过Maximum Segment Lifetime（缩写为MSL），所以，只要MSL的值小于4.55小时，那么，我们就不会重用到ISN
 
 MSL就是maximium segment lifetime——最长报文寿命
 */

/*
 ###MSL 和 TIME_WAIT###
 
 从TIME_WAIT状态到CLOSED状态，有一个超时设置，这个超时设置是 2*MSL（RFC793定义了MSL为2分钟，Linux设置成了30s）
 
 1）TIME_WAIT确保有足够的时间让对端收到了ACK，如果被动关闭的那方没有收到Ack，就会触发被动端重发Fin，一来一去正好2个MSL
 2）有足够的时间让这个连接不会跟后面的连接混在一起
 */

/*
 MARK:###TCP的RTT算法###
 好像就是在发送端发包时记下t0，然后接收端再把这个ack回来时再记一个t1，于是RTT = t1 – t0。没那么简单，这只是一个采样，不能代表普遍情况
 
 1.经典算法
 1）首先，先采样RTT，记下最近好几次的RTT值。
 2）然后做平滑计算SRTT（ Smoothed RTT），公式为：（其中的 α 取值在0.8 到 0.9之间，这个算法英文叫Exponential weighted moving average，中文叫：加权移动平均）
 SRTT = ( α * SRTT ) + ((1- α) * RTT)
 3）开始计算RTO。公式如下：
 RTO = min [ UBOUND,  max [ LBOUND,   (β * SRTT) ]  ]
 
 其中：
 UBOUND是最大的timeout时间，上限值
 LBOUND是最小的timeout时间，下限值
 β 值一般在1.3到2.0之间
 
 2.Karn / Partridge 算法
 上面的这个算法在重传的时候会出有一个终极问题——你是用第一次发数据的时间和ack回来的时间做RTT样本值，还是用重传的时间和ACK回来的时间做RTT样本值
 
 这个算法的最大特点是——忽略重传，不把重传的RTT做采样
 这样一来，又会引发一个大BUG——如果在某一时间，网络闪动，突然变慢了，产生了比较大的延时，这个延时导致要重转所有的包（因为之前的RTO很小），于是，因为重转的不算，所以，RTO就不会被更新，这是一个灾难。 于是Karn算法用了一个取巧的方式——只要一发生重传，就对现有的RTO值翻倍（这就是所谓的 Exponential backoff），很明显，这种死规矩对于一个需要估计比较准确的RTT也不靠谱
 
 3.Jacobson / Karels 算法
 前面两种算法用的都是“加权移动平均”，这种方法最大的毛病就是如果RTT有一个大的波动的话，很难被发现，因为被平滑掉了
 
 这个算法引入了最新的RTT的采样和平滑过的SRTT的差距做因子来计算。
 公式如下：（其中的DevRTT是Deviation RTT的意思）
 SRTT = SRTT + α (RTT – SRTT) ：计算平滑RTT；
 DevRTT = (1-β)*DevRTT + β*(|RTT-SRTT|) ：计算平滑RTT和真实的差距（加权移动平均）；
 RTO= μ * SRTT + ∂ *DevRTT ： 神一样的公式
 在Linux下，α = 0.125，β = 0.25， μ = 1，∂ = 4 ——这就是算法中的“调得一手好参数”
 这个算法在被用在今天的TCP协议中
 */

/*
 MARK:###TCP 的滑动窗口协议###
 TCP必需要解决的可靠传输以及包乱序（reordering）的问题，所以，TCP必需要知道网络实际的数据处理带宽或是数据处理速度，这样才不会引起网络拥塞，导致丢包
 
 Sliding Window,TCP 头里有一个字段叫 Window，又叫 Advertised-Window，这个字段是接收端告诉发送端自己还有多少缓冲区可以接收数据。于是发送端就可以根据这个接收端的处理能力来发送数据，而不会导致接收端处理不过来
 TCP通过Sliding Window来做流控（Flow Control）
 
 TCP缓冲区:
 接收端LastByteRead指向了TCP缓冲区中读到的位置，NextByteExpected指向的地方是收到的连续包的最后一个位置，LastByteRcved指向的是收到的包的最后一个位置，我们可以看到中间有些数据还没有到达，所以有数据空白区
 发送端的LastByteAcked指向了被接收端Ack过的位置（表示成功发送确认），LastByteSent表示发出去了，但还没有收到成功确认的Ack，LastByteWritten指向的是上层应用正在写的地方
 
 接收端在给发送端回ACK中会汇报自己的AdvertisedWindow = MaxRcvBuffer – LastByteRcvd – 1
 而发送方会根据这个窗口来控制发送数据的大小，以保证接收方可以处理
 
 见图:
 黑模型就是滑动窗口
 #1 已收到ack确认的数据。
 #2 发还没收到ack的。
 #3 在窗口中还没有发出的（接收方还有空间）。
 #4 窗口以外的数据（接收方没空间）

 Zero Window:
 如果Window变成0了，发送端就不发数据了
 接收方一会儿Window size 可用了，怎么通知发送端

 TCP使用了Zero Window Probe技术，缩写为ZWP
 发送端在窗口变成0后，会发ZWP的包给接收方，让接收方来ack他的Window尺寸，一般这个值会设置成3次，第次大约30-60秒
 如果3次过后还是0的话，有的TCP实现就会发RST把链接断了
 
 最大传输单元（Maximum Transmission Unit，MTU）
 对于以太网来说，MTU是1500字节，除去TCP+IP头的40个字节，真正的数据传输可以有1460，这就是所谓的MSS（Max Segment Size）
 
 Silly Window Syndrome就是“糊涂窗口综合症”:
 如果我们的接收方太忙了，来不及取走Receive Windows里的数据，那么，就会导致发送方越来越小。到最后，如果接收方腾出几个字节并告诉发送方现在有几个字节的window，而我们的发送方会义无反顾地发送这几个字节
 为了几个字节，要达上这么大的开销，这太不经济了
 避免对小的window size做出响应，直到有足够大的window size再响应，这个思路可以同时实现在sender和receiver两端
 在receiver端，如果收到的数据导致window size小于某个值，可以直接ack(0)回sender，这样就把window给关闭了，也阻止了sender再发数据过来，等到receiver端处理了一些数据后windows size 大于等于了MSS，或者，receiver buffer有一半为空，就可以把window打开让send 发送数据过来
 由Sender端引起,思路也是延时处理，他有两个主要的条件：1）要等到 Window Size>=MSS 或是 Data Size >=MSS，2）收到之前发送数据的ack回包，他才会发数据，否则就是在攒数据。
 */

/*
 MARK:###拥塞控制###
 拥塞处理 – Congestion Handling
 Sliding Window需要依赖于连接的发送端和接收端，其并不知道网络中间发生了什么
 TCP通过一个timer采样了RTT并计算RTO
 TCP不能忽略网络上发生的事情，而无脑地一个劲地重发数据
 
 TCP 的拥塞控制相关过程:
 TCP 的拥塞控制主要是四个算法：1）慢启动；2）拥塞避免；3）拥塞发生；4）快速恢复
 cwnd 全称 Congestion Window
 RTT(Round-Trip Time):往返时延。是指数据从网络一端传到另一端所需的时间
 
 慢启动算法:Slow Start
 慢启动的意思是，刚刚加入网络的连接，一点一点地提速
 TCP在连接过程的三次握手完成后，开始传数据，并不是一开始向网络通道中发送大量的数据包，这样很容易导致网络中路由器缓存空间耗尽，从而发生拥塞
 TCP使用了一个叫慢启动门限(ssthresh)的变量，一旦cwnd>=ssthresh（大多数TCP的实现，通常大小都是65536），慢启动过程结束，拥塞避免阶段开始
 1）连接建好的开始先初始化 cwnd = 1，表明可以传一个 MSS（Max Segment Size）大小的数据。
 2）每当收到一个 ACK，cwnd++; 呈线性上升。
 3）每当过了一个 RTT，cwnd = cwnd*2; 呈指数上升。
 4）还有一个 ssthresh（slow start threshold），是一个上限，当 cwnd >= ssthresh 时，就会进入「拥塞避免算法」。
 所以，我们可以看到，如果网速很快的话，ACK 也会返回得快，RTT 也会短，那么，这个慢启动就一点也不慢
 
 拥塞避免算法:
 拥塞避免：cwnd的值不再指数级往上升，开始加法增加。此时当窗口中所有的报文段都被确认时，cwnd的大小加1，cwnd的值就随着RTT开始线性增加，这样就可以避免增长过快导致网络拥塞，慢慢的增加调整到网络的最佳值
 一般来说 ssthresh 的值是 65535 字节，当 cwnd 达到这个值时后，算法如下：
 1）收到一个 ACK 时，cwnd = cwnd + 1/cwnd。
 2）当每过一个 RTT 时，cwnd = cwnd + 1。
 这样就可以避免增长过快导致网络拥塞，慢慢的增加调整到网络的最佳值。很明显，是一个线性上升的算法
 
 拥塞状态时的算法:
 当丢包的时候，会有以下两种情况
 1）等到RTO超时，重传数据包
 sshthresh =  cwnd /2
 cwnd 重置为 1
 进入慢启动过程
 2）Fast Retransmit快速重传算法，也就是在收到3个duplicate(完全一样的) ACK时就开启重传，而不用等到RTO超时
 TCP Tahoe的实现和RTO超时一样。
 TCP Reno的实现是:
 cwnd = cwnd /2
 sshthresh = cwnd
 进入快速恢复算法——Fast Recovery
 
 4.快速恢复算法 – Fast Recovery:
 快速重传和快速恢复算法一般同时使用
 
 进入Fast Recovery之前，cwnd 和 sshthresh已被更新：
 cwnd = cwnd /2
 sshthresh = cwnd
 
 真正的Fast Recovery算法如下：
 cwnd = sshthresh  + 3 * MSS （3的意思是确认有3个数据包被收到了）
 重传Duplicated ACKs指定的数据包
 如果再收到 duplicated Acks，那么cwnd = cwnd +1
 如果收到了新的Ack，那么，cwnd = sshthresh ，然后就进入了拥塞避免的算法了。

 TCP New Reno:
 当sender这边收到了3个Duplicated Acks，进入Fast Retransimit模式，开发重传重复Acks指示的那个包。如果只有这一个包丢了，那么，重传这个包后回来的Ack会把整个已经被sender传输出去的数据ack回来。如果没有的话，说明有多个包丢了。我们叫这个ACK为Partial ACK。
 一旦Sender这边发现了Partial ACK出现，那么，sender就可以推理出来有多个包被丢了，于是乎继续重传sliding window里未被ack的第一个包。直到再也收不到了Partial Ack，才真正结束Fast Recovery这个过程
 */

/*
 MARK:###TCP重传机制###
 TCP重传机制我们知道Timeout的设置对于重传非常重要
 设长了，重发就慢，丢了老半天才重发，没有效率，性能差；
 设短了，会导致可能并没有丢就重发。于是重发的就快，会增加网络拥塞，导致更多的超时，更多的超时导致更多的重发
 
 这个超时时间在不同的网络的情况下，根本没有办法设置一个死的值。只能动态地设置。 为了动态地设置，TCP引入了RTT——Round Trip Time，也就是一个数据包从发出去到回来的时间。这样发送端就大约知道需要多少的时间，从而可以方便地设置Timeout——RTO（Retransmission TimeOut），以让我们的重传机制更高效

 TCP要保证所有的数据包都可以到达，所以，必需要有重传机制
 ##TCP通过在发送数据时设置一个重传定时器来监控数据的丢失状态，如果重传定时器溢出时还没收到确认信号，则重传该数据##
 RTT(Round Trip Time)：一个连接的往返时间，即数据发送时刻到接收到确认的时刻的差值；
 RTO(Retransmission Time Out)：重传超时时间，即从数据发送时刻算起，超过这个时间便执行重传。
 RTT和RTO 的关系是：由于网络波动的不确定性，每个RTT都是动态变化的，所以RTO也应随着RTT动态变化
 
 
 ##接收端给发送端的Ack确认只会确认最后一个连续的包，比如，发送端发了1,2,3,4,5一共五份数据，接收端收到了1，2，于是回ack 3(对2的ack)，然后收到了4（注意此时3没收到），此时的TCP会怎么办？我们要知道，因为正如前面所说的，SeqNum和Ack是以字节数为单位，所以ack的时候，不能跳着确认，只能确认最大的连续收到的包，不然，发送端就以为之前的都收到了##
 1.超时重传机制
 一种是不回ack，死等3，当发送方发现收不到3的ack超时后，会重传3。一旦接收方收到3后，会ack 回 4——意味着3和4都收到了
 这种方式会有比较严重的问题，那就是因为要死等3，所以会导致4和5即便已经收到了，而发送方也完全不知道发生了什么事，因为没有收到Ack，所以，发送方可能会悲观地认为也丢了，所以有可能也会导致4和5的重传
 对此有两种选择：
 一种是仅重传timeout的包。也就是第3份数据。
 另一种是重传timeout后所有的数据，也就是第3，4，5这三份数据
 这两种方式有好也有不好。第一种会节省带宽，但是慢，第二种会快一点，但是会浪费带宽，也可能会有无用功。但总体来说都不好。因为都在等timeout，timeout可能会很长
 2.快速重传机制
 TCP引入了一种叫Fast Retransmit 的算法，不以时间驱动，而以数据驱动重传。也就是说，如果，包没有连续到达，就ack最后那个可能被丢了的包，如果发送方连续收到3次相同的ack，就重传。Fast Retransmit的好处是不用等timeout了再重传
 比如：如果发送方发出了1，2，3，4，5份数据，第一份先到送了，于是就ack回2，结果2因为某些原因没收到，3到达了，于是还是ack回2，后面的4和5都到了，但是还是ack回2，因为2还是没有收到，于是发送端收到了三个ack=2的确认，知道了2还没有到，于是就马上重转2。然后，接收端收到了2，此时因为3，4，5都收到了，于是ack回6
 Fast Retransmit只解决了一个问题，就是timeout的问题，它依然面临一个艰难的选择，就是，是重传之前的一个还是重传所有的问题
 3.SACK 方法
 另外一种更好的方式叫：Selective Acknowledgment (SACK)
 这种方式需要在TCP头里加一个SACK的东西，ACK还是Fast Retransmit的ACK,SACK则是汇报收到的数据碎版
 
 在发送端就可以根据回传的SACK来知道哪些数据到了，哪些没有到。于是就优化了Fast Retransmit的算法
 这里还需要注意一个问题——接收方Reneging，所谓Reneging的意思就是接收方有权把已经报给发送端SACK里的数据给丢了。这样干是不被鼓励的，因为这个事会把问题复杂化了，但是，接收方这么做可能会有些极端情况，比如要把内存给别的更重要的东西。所以，发送方也不能完全依赖SACK，还是要依赖ACK，并维护Time-Out，如果后续的ACK没有增长，那么还是要把SACK的东西重传
 
 4.Duplicate SACK – 重复收到数据的问题
 Duplicate SACK又称D-SACK，其主要使用了SACK来告诉发送方有哪些数据被重复接收了
 
 D-SACK使用了SACK的第一个段来做标志：
 如果SACK的第一个段的范围被ACK所覆盖，那么就是D-SACK
 如果SACK的第一个段的范围被SACK的第二个段覆盖，那么就是D-SACK
 
 ACK丢包:
 发送端重传了第一个数据包（3000-3499），于是接收端发现重复收到，于是回了一个SACK=3000-3500，因为ACK都到了4000意味着收到了4000之前的所有数据，所以这个SACK就是D-SACK--旨在告诉发送端我收到了重复的数据，而且我们的发送端还知道，数据包没有丢，丢的是ACK包
 
 网络延误:
 网络包（1000-1499）被网络给延误了，导致发送方没有收到ACK，而后面到达的三个包触发了“Fast Retransmit算法”，所以重传，但重传时，被延误的包又到了，所以，回了一个SACK=1000-1500，因为ACK已到了3000，所以，这个SACK是D-SACK——标识收到了重复的包
 发送端知道之前因为“Fast Retransmit算法”触发的重传不是因为发出去的包丢了，也不是因为回应的ACK包丢了，而是因为网络延时了
 
 
 引入了D-SACK，有这么几个好处：
 1）可以让发送方知道，是发出去的包丢了，还是回来的ACK包丢了。
 2）是不是自己的timeout太小了，导致重传。
 3）网络上出现了先发的包后到的情况（又称reordering）
 4）网络上是不是把我的数据包给复制了
 */

/*
 ##网络通信协议##
 
 网络层的责任是提供点到点(hop by hop)的服务，而传输层（TCP/UDP）则提供端到端(end to end)的服务
 
 第四层——Transport层，IP在第三层——Network层，ARP在第二层——Data Link层，在第二层上的数据，我们叫Frame，在第三层上的数据叫Packet，第四层的数据叫Segment
 
 TCP为传输控制层协议，为面向连接、可靠的、点到点的通信；
 UDP为用户数据报协议，非连接的不可靠的点到多点的通信；
 TCP侧重可靠传输，UDP侧重快速传输
 
 TCP的包是没有IP地址的，那是IP层上的事，但是有源端口和目标端口
 
 Sequence Number：是包的序号，用来解决网络包乱序（reordering）问题。
 SeqNum的增加是和传输的字节数相关的
 
 Acknowledgement Number：就是ACK——用于确认收到，用来解决不丢包的问题。
 Window：又叫Advertised-Window，也就是著名的滑动窗口（Sliding Window），用于解决流控的。
 TCP Flag ：也就是包的类型，主要是用于操控TCP的状态机的
 
 对于建链接的3次握手：主要是要初始化Sequence Number 的初始值。通信的双方要互相通知对方自己的初始化的Sequence Number（缩写为ISN：Inital Sequence Number）——所以叫SYN，全称Synchronize Sequence Numbers
 

 TCP所谓的“连接”，其实只不过是在通讯的双方维护一个“连接状态”，让它看上去好像有连接一样。所以，TCP的状态变换是非常重要的
 
 HTTP协议是基于TCP连接的，是应用层协议，主要解决如何包装数据。Socket是对TCP/IP协议的封装，Socket本身并不是协议，而是一个调用接口（API），通过Socket，我们才能使用TCP/IP协议
 Socket包含进行网络通信必须的五种信息：连接使用的协议，本地主机的IP地址，本地进程的协议端口，远地主机的IP地址，远地进程的协议端口
 建立Socket连接至少需要一对套接字，其中一个运行于客户端，称为ClientSocket，另一个运行于服务器端，称为ServerSocket
 套接字之间的连接过程分为三个步骤：服务器监听，客户端请求，连接确认
 服务器监听：服务器端套接字并不定位具体的客户端套接字，而是处于等待连接的状态，实时监控网络状态，等待客户端的连接请求。
 客户端请求：指客户端的套接字提出连接请求，要连接的目标是服务器端的套接字。为此，客户端的套接字必须首先描述它要连接的服务器的套接字，指出服务器端套接字的地址和端口号，然后就向服务器端套接字提出连接请求
 连 接确认：当服务器端套接字监听到或者说接收到客户端套接字的连接请求时，就响应客户端套接字的请求，建立一个新的线程，把服务器端套接字的描述发给客户 端，一旦客户端确认了此描述，双方就正式建立连接。而服务器端套接字继续处于监听状态，继续接收其他客户端套接字的连接请求。
 
 
 互联网的核心是一系列协议
 MARK:"实体层":
 它就是把电脑连接起来的物理手段(把电脑连起来，可以用光缆、电缆、双绞线、无线电波等方式)
 它主要规定了网络的一些电气特性，作用是负责传送0和1的电信号
 
 MARK:链接层:
 单纯的0和1没有任何意义，必须规定解读方式
 这就是"链接层"的功能，它在"实体层"的上方，确定了0和1的分组方式
 (1)以太网协议(Ethernet):
 ###以太网协议解决了局域网的点对点通信###
 以太网规定，一组电信号构成一个数据包，叫做"帧"（Frame）。每一帧分成两个部分：标头（Head）和数据（Data）
 "标头"包含数据包的一些说明项，比如发送者、接受者、数据类型等等；"数据"则是数据包的具体内容。
 "标头"的长度，固定为18字节。"数据"的长度，最短为46字节，最长为1500字节。因此，整个"帧"最短为64字节，最长为1518字节。如果数据很长，就必须分割成多个帧进行发送。
 (2)MAC地址:
 以太网规定，连入网络的所有设备，都必须具有"网卡"接口。数据包必须是从一块网卡，传送到另一块网卡。网卡的地址，就是数据包的发送地址和接收地址，这叫做MAC地址。
 每块网卡出厂的时候，都有一个全世界独一无二的MAC地址，长度是48个二进制位，通常用12个十六进制数表示。
 前6个十六进制数是厂商编号，后6个是该厂商的网卡流水号。有了MAC地址，就可以定位网卡和数据包的路径了
 (3)广播:
 以太网数据包必须知道接收方的MAC地址，然后才能发送
 1.一块网卡怎么会知道另一块网卡的MAC地址？
 ##ARP协议 ARP(Address Resolution Protocol)是地址解析协议,ARP是一种将IP地址转化成物理地址的协议##
 2.就算有了MAC地址，系统怎样才能把数据包准确送到接收方？
 以太网它不是把数据包准确送到接收方，而是向本网络内所有计算机发送，让每台计算机自己判断，是否为接收方。
 它们读取这个包的"标头"，找到接收方的MAC地址，然后与自身的MAC地址相比较，如果两者相同，就接受这个包，做进一步处理，否则就丢弃这个包。这种发送方式就叫做"广播"（broadcasting）。
 有了数据包的定义、网卡的MAC地址、广播的发送方式，"链接层"就可以在多台计算机之间传送数据了。

 MARK:网络层:
 以太网协议，依靠MAC地址发送数据。理论上，单单依靠MAC地址，上海的网卡就可以找到洛杉矶的网卡了，技术上是可以实现的。
 但是，这样做有一个重大的缺点。以太网采用广播方式发送数据包，所有成员人手一"包"，不仅效率低，而且局限在发送者所在的子网络。也就是说，如果两台计算机不在同一个子网络，广播是传不过去的。这种设计是合理的，否则互联网上每一台计算机都会收到所有包，那会引起灾难。
 互联网是无数子网络共同组成的一个巨型网络，很难想象上海和洛杉矶的电脑会在同一个子网络，这几乎是不可能的。
 必须找到一种方法，能够区分哪些MAC地址属于同一个子网络，哪些不是。如果是同一个子网络，就采用广播方式发送，否则就采用"路由"方式发送。（"路由"的意思，就是指如何向不同的子网络分发数据包).遗憾的是，MAC地址本身无法做到这一点。它只与厂商有关，与所处网络无关。
 这就导致了"网络层"的诞生。它的作用是引进一套新的地址，使得我们能够区分不同的计算机是否属于同一个子网络。这套地址就叫做"网络地址"，简称"网址"。
 "网络层"出现以后，每台计算机有了两种地址，一种是MAC地址，另一种是网络地址。两种地址之间没有任何联系，MAC地址是绑定在网卡上的，网络地址则是管理员分配的，它们只是随机组合在一起。
 网络地址帮助我们确定计算机所在的子网络，MAC地址则将数据包送到该子网络中的目标网卡。因此，从逻辑上可以推断，必定是先处理网络地址，然后再处理MAC地址。
 (1)IP协议:
 ###IP 协议可以连接多个局域网,解决多个局域网如何互通###
 只有IP而没有对应的MAC地址在这种局域网内是不能上网的，于是解决了IP盗用问题
 IP 协议定义了一套自己的地址规则，称为 IP 地址。它实现了路由功能，允许某个局域网的 A 主机，向另一个局域网的 B 主机发送消息
 规定网络地址的协议，叫做IP协议。
 IPv4网络地址由32个二进制位组成
 我们用分成四段的十进制数表示IP地址，从0.0.0.0一直到255.255.255.255。
 互联网上的每一台计算机，都会分配到一个IP地址。这个地址分成两个部分，前一部分代表网络，后一部分代表主机。比如，IP地址172.16.254.1，这是一个32位的地址，假定它的网络部分是前24位（172.16.254），那么主机部分就是后8位（最后的那个1）。处于同一个子网络的电脑，它们IP地址的网络部分必定是相同的，也就是说172.16.254.2应该与172.16.254.1处在同一个子网络。
 问题在于单单从IP地址，我们无法判断网络部分。还是以172.16.254.1为例，它的网络部分，到底是前24位，还是前16位，甚至前28位，从IP地址上是看不出来的。
 怎样才能从IP地址，判断两台计算机是否属于同一个子网络呢？这就要用到另一个参数"子网掩码"（subnet mask）
 所谓"子网掩码"，就是表示子网络特征的一个参数。它在形式上等同于IP地址，也是一个32位二进制数字，它的网络部分全部为1，主机部分全部为0。比如，IP地址172.16.254.1，如果已知网络部分是前24位，主机部分是后8位，那么子网络掩码就是11111111.11111111.11111111.00000000，写成十进制就是255.255.255.0。
 知道"子网掩码"，我们就能判断，任意两个IP地址是否处在同一个子网络。方法是将两个IP地址与子网掩码分别进行AND运算（两个数位都为1，运算结果为1，否则为0），然后比较结果是否相同，如果是的话，就表明它们在同一个子网络中，否则就不是。
 已知IP地址172.16.254.1和172.16.254.233的子网掩码都是255.255.255.0，请问它们是否在同一个子网络？两者与子网掩码分别进行AND运算，结果都是172.16.254.0，因此它们在同一个子网络。
 ###IP协议的作用主要有两个，一个是为每一台计算机分配IP地址，另一个是确定哪些地址在同一个子网络。###
 (2)IP数据包:
 根据IP协议发送的数据，就叫做IP数据包。不难想象，其中必定包括IP地址信息。但是前面说过，以太网数据包只包含MAC地址，并没有IP地址的栏位。那么是否需要修改数据定义，再添加一个栏位呢？
 回答是不需要，我们可以把IP数据包直接放进以太网数据包的"数据"部分，因此完全不用修改以太网的规格。这就是互联网分层结构的好处：上层的变动完全不涉及下层的结构。
 IP数据包也分为"标头"和"数据"两个部分:
 "标头"部分主要包括版本、长度、IP地址等信息，"数据"部分则是IP数据包的具体内容。它放进以太网数据包
 IP数据包的"标头"部分的长度为20到60字节，整个数据包的总长度最大为65,535字节。因此，理论上，一个IP数据包的"数据"部分，最长为65,515字节。前面说过，以太网数据包的"数据"部分，最长只有1500字节。因此，如果IP数据包超过了1500字节，它就需要分割成几个以太网数据包，分开发送了
 (3)ARP协议:
 因为IP数据包是放在以太网数据包里发送的，所以我们必须同时知道两个地址，一个是对方的MAC地址，另一个是对方的IP地址。通常情况下，对方的IP地址是已知的，但是我们不知道它的MAC地址
 
 我们需要一种机制，能够从IP地址得到MAC地址
 这里又可以分成两种情况:
 第一种情况：如果两台主机不在同一个子网络，那么事实上没有办法得到对方的MAC地址，只能把数据包传送到两个子网络连接处的"网关"（gateway），让网关去处理
 如果两台电脑不在同一个子网络，就无法知道对方的MAC地址，必须通过网关（gateway）转发
 1号电脑要向4号电脑发送一个数据包。它先判断4号电脑是否在同一个子网络，结果发现不是，于是就把这个数据包发到网关A。网关A通过路由协议，发现4号电脑位于子网络B，又把数据包发给网关B，网关B再转发到4号电脑
 1号电脑把数据包发到网关A，必须知道网关A的MAC地址。所以，数据包的目标地址，实际上分成两种情况:
 场景    数据包地址
 同一个子网络    对方的MAC地址，对方的IP地址
 非同一个子网络    网关的MAC地址，对方的IP地址
 发送数据包之前，电脑必须判断对方是否在同一个子网络，然后选择相应的MAC地址
 第二种情况：如果两台主机在同一个子网络，那么我们可以用ARP协议，得到对方的MAC地址。ARP协议也是发出一个数据包（包含在以太网数据包中），其中包含它所要查询主机的IP地址，在对方的MAC地址这一栏，填的是FF:FF:FF:FF:FF:FF，表示这是一个"广播"地址。它所在子网络的每一台主机，都会收到这个数据包，从中取出IP地址，与自身的IP地址进行比较。如果两者相同，都做出回复，向对方报告自己的MAC地址，否则就丢弃这个包。
 有了ARP协议之后，我们就可以得到同一个子网络内的主机MAC地址，可以把数据包发送到任意一台主机之上了
 
 ARP原理：要向主机B发送报文，会查询本地的ARP缓存表，找到B的IP地址对应的MAC地址后就会进行数据传输。如果未找到，则广播A一个 ARP请求报文（携带主机A的IP地址Ia——物理地址Pa），请求IP地址为Ib的主机B回答物理地址Pb。网上所有主机包括B都收到ARP请求，但只有主机B识别自己的IP地址，于是向A主机发回一个ARP响应报文。其中就包含有B的MAC地址，A接收到B的应答后，就会更新本地的ARP缓存。接着使用这个MAC地址发送数据（由网卡附加MAC地址）。因此，本地高速缓存的这个ARP表是本地网络流通的基础，而且这个缓存是动态的。ARP表：为了回忆通信的速度，最近常用的MAC地址与IP的转换不用依靠交换机来进行，而是在本机上建立一个用来记录常用主机IP－MAC映射表，即ARP表
 
 MARK:传输层:
 有了MAC地址和IP地址，我们已经可以在互联网上任意两台主机上建立通信
 同一台主机上有许多程序都需要用到网络，比如，你一边浏览网页，一边与朋友在线聊天。当一个数据包从互联网上发来的时候，你怎么知道，它是表示网页的内容，还是表示在线聊天的内容？
 我们还需要一个参数，表示这个数据包到底供哪个程序（进程）使用。这个参数就叫做"端口"（port），它其实是每一个使用网卡的程序的编号。每个数据包都发到主机的特定端口，所以不同的程序就能取到自己所需要的数据。
 "端口"是0到65535之间的一个整数，正好16个二进制位。0到1023的端口被系统占用，用户只能选用大于1023的端口。不管是浏览网页还是在线聊天，应用程序会随机选用一个端口，然后与服务器的相应端口联系。
 "传输层"的功能，就是建立"端口到端口"的通信。相比之下，"网络层"的功能是建立"主机到主机"的通信。只要确定主机和端口，我们就能实现程序之间的交流。因此，Unix系统就把主机+端口，叫做"套接字"（socket）。有了它，就可以进行网络应用程序开发了
 (1)UDP协议:
 在数据包中加入端口信息，这就需要新的协议。最简单的实现叫做UDP协议
 由"标头"和"数据"两部分组成
 "标头"部分主要定义了发出端口和接收端口，"数据"部分就是具体的内容。然后，把整个UDP数据包放入IP数据包的"数据"部分，而前面说过，IP数据包又是放在以太网数据包之中的
 "标头"部分一共只有8个字节，总长度不超过65,535字节，正好放进一个IP数据包
 (2)TCP协议:
 UDP协议的优点是比较简单，容易实现，但是缺点是可靠性较差，一旦数据包发出，无法知道对方是否收到。为了解决这个问题，提高网络可靠性，TCP协议就诞生了。这个协议非常复杂，但可以近似认为，它就是有确认机制的UDP协议，每发出一个数据包都要求确认。如果有一个数据包遗失，就收不到确认，发出方就知道有必要重发这个数据包了
 TCP协议能够确保数据不会遗失。它的缺点是过程复杂、实现困难、消耗较多的资源
 TCP数据包和UDP数据包一样，都是内嵌在IP数据包的"数据"部分。TCP数据包没有长度限制，理论上可以无限长，但是为了保证网络的效率，通常TCP数据包的长度不会超过IP数据包的长度，以确保单个TCP数据包不必再分割
 IP协议只是一个地址协议，并不保证数据包的完整。如果路由器丢包（比如缓存满了，新进来的数据包就会丢失），就需要发现丢了哪一个包，以及如何重新发送这个包。这就要依靠 TCP 协议。
 简单说，TCP 协议的作用是，保证数据通信的完整性和可靠性，防止丢包。
 
 应用层:
 应用程序收到"传输层"的数据，接下来就要进行解读。由于互联网是开放架构，数据来源五花八门，必须事先规定好格式，否则根本无法解读。"应用层"的作用，就是规定应用程序的数据格式。
 举例来说，TCP协议可以为各种各样的程序传递数据，比如Email、WWW、FTP等等。那么，必须有不同协议规定电子邮件、网页、FTP数据的格式，这些应用程序协议就构成了"应用层"。这是最高的一层，直接面对用户。它的数据就放在TCP数据包的"数据"部分
 ====================================================================
 不管是"静态IP地址"还是"动态IP地址"，电脑上网的首要步骤，是确定四个参数
 
 静态IP地址:
 管理员（或者ISP(互联网服务提供商)）会告诉你下面四个参数，你把它们填入操作系统，计算机就能连上网了：
 * 本机的IP地址；
 * 子网掩码；
 * 网关的IP地址；
 * DNS的IP地址。
 
 动态IP地址:
 所谓"动态IP地址"，指计算机开机后，会自动分配到一个IP地址，不用人为设定。它使用的协议叫做DHCP协议。
 这个协议规定，每一个子网络中，有一台计算机负责管理本网络的所有IP地址，它叫做"DHCP服务器"。新的计算机加入网络，必须向"DHCP服务器"发送一个"DHCP请求"数据包，申请IP地址和相关的网络参数
 如果两台计算机在同一个子网络，必须知道对方的MAC地址和IP地址，才能发送数据包。但是，新加入的计算机不知道这两个地址，怎么发送数据包呢？DHCP协议做了一些巧妙的规定
 
 DHCP协议:
 它是一种应用层协议，建立在UDP协议之上
 1）最前面的"以太网标头"：设置发出方（本机）的MAC地址和接收方（DHCP服务器）的MAC地址。前者就是本机网卡的MAC地址，后者这时不知道，就填入一个广播地址：FF-FF-FF-FF-FF-FF。
 2）后面的"IP标头"：设置发出方的IP地址和接收方的IP地址。这时，对于这两者，本机都不知道。于是，发出方的IP地址就设为0.0.0.0，接收方的IP地址设为255.255.255.255。
 3）最后的"UDP标头"：设置发出方的端口和接收方的端口。这一部分是DHCP协议规定好的，发出方是68端口，接收方是67端口。
 
 这个数据包构造完成后，就可以发出了。以太网是广播发送，同一个子网络的每台计算机都收到了这个包。因为接收方的MAC地址是FF-FF-FF-FF-FF-FF，看不出是发给谁的，所以每台收到这个包的计算机，还必须分析这个包的IP地址，才能确定是不是发给自己的。当看到发出方IP地址是0.0.0.0，接收方是255.255.255.255，于是DHCP服务器知道"这个包是发给我的"，而其他计算机就可以丢弃这个包。
 接下来，DHCP服务器读出这个包的数据内容，分配好IP地址，发送回去一个"DHCP响应"数据包。这个响应包的结构也是类似的，以太网标头的MAC地址是双方的网卡地址，IP标头的IP地址是DHCP服务器的IP地址（发出方）和255.255.255.255（接收方），UDP标头的端口是67（发出方）和68（接收方），分配给请求端的IP地址和本网络的具体参数则包含在Data部分
 新加入的计算机收到这个响应包，于是就知道了自己的IP地址、子网掩码、网关地址、DNS服务器等等参数。
 
 
 :
 发送数据包，必须要知道对方的IP地址。但是，现在，我们只知道网址www.google.com，不知道它的IP地址。DNS协议可以帮助我们，将这个网址转换成IP地址。已知DNS服务器为8.8.8.8，于是我们向这个地址发送一个DNS数据包（53端口）
 然后，DNS服务器做出响应，告诉我们Google的IP地址是172.194.72.105。于是，我们知道了对方的IP地址。
 
 HTTP端口默认是80
 
 总长度为5000字节
 以太网数据包的数据部分，最大长度为1500字节，而现在的IP数据包长度为5000字节。因此，IP数据包必须分割成四个包。因为每个包都有自己的IP标头（20字节），所以四个包的IP数据包的长度分别为1500、1500、1500、560 (???)
 */

/*
 TCP:
 TCP 数据包的编号（SEQ）:
 一个包1400字节，那么一次性发送大量数据，就必须分成多个包。比如，一个 10MB 的文件，需要发送7100多个包。发送的时候，TCP 协议为每个包编号（sequence number，简称 SEQ），以便接收的一方按照顺序还原。万一发生丢包，也可以知道丢失的是哪一个包。
 
 第一个包的编号是一个随机数
 为了便于理解，这里就把它称为1号包。假定这个包的负载长度是100字节，那么可以推算出下一个包的编号应该是101。这就是说，每个数据包都可以得到两个编号：自身的编号，以及下一个包的编号。接收方由此知道，应该按照什么顺序将它们还原成原始文件。
 
 收到 TCP 数据包以后，组装还原是操作系统完成的。应用程序不会直接处理 TCP 数据包。
 
 TCP 并没有提供任何机制，表示原始文件的大小，这由应用层的协议来规定。比如，HTTP 协议就有一个头信息Content-Length，表示信息体的大小。对于操作系统来说，就是持续地接收 TCP 数据包，将它们按照顺序组装好，一个包都不少。
 
 慢启动和 ACK:
 服务器发送数据包，当然越快越好，最好一次性全发出去。但是，发得太快，就有可能丢包。带宽小、路由器过热、缓存溢出等许多因素都会导致丢包。线路不好的话，发得越快，丢得越多。
 
 最理想的状态是，在线路允许的情况下，达到最高速率。但是我们怎么知道，对方线路的理想速率是多少呢？答案就是慢慢试。
 
 TCP 协议为了做到效率与可靠性的统一，设计了一个慢启动（slow start）机制。开始的时候，发送得较慢，然后根据丢包的情况，调整速率：如果不丢包，就加快发送速度；如果丢包，就降低发送速度。
 
 CWnd是计算机网络中拥塞窗口（congestion window）的简写
 Linux 内核里面设定了（常量TCP_INIT_CWND），刚开始通信的时候，发送方一次性发送10个数据包，即"发送窗口"的大小为10。然后停下来，等待接收方的确认，再继续发送。默认情况下，接收方每收到两个 TCP 数据包，就要发送一个确认消息。"确认"的英语是 acknowledgement，所以这个确认消息就简称 ACK
 
 ACK 携带两个信息：
 1）期待要收到下一个数据包的编号；
 2）接收方的接收窗口的剩余容量。
 
 发送方有了这两个信息，再加上自己已经发出的数据包的最新编号，就会推测出接收方大概的接收速度，从而降低或增加发送速率。这被称为"发送窗口"，这个窗口的大小是可变的

 由于 TCP 通信是双向的，所以双方都需要发送 ACK
 而且 ACK 只是很简单的几个字段，通常与数据合并在一个数据包里面发送
 
 即使对于带宽很大、线路很好的连接，TCP 也总是从10个数据包开始慢慢试，过了一段时间以后，才达到最高的传输速率。这就是 TCP 的慢启动
 
 每一个数据包都带有下一个数据包的编号。如果下一个数据包没有收到，那么 ACK 的编号就不会发生变化。
 
 如果发送方发现收到三个连续的重复 ACK，或者超时了还没有收到任何 ACK，就会确认丢包，即5号包遗失了，从而再次发送这个包。通过这种机制，TCP 保证了不会有数据包丢失
 
 
 三次握手和四次挥手:
 TCP 通过“三次握手”来建立连接，再通过“四次挥手”断开一个连接。
 
 当 TCP 试图建立连接时，三次握手指的是客户端主动触发了两次，服务端触发了一次
 
 TCP 建立连接并且初始化的目标:
 1）初始化资源；
 2）告诉对方我的序列号。
 
 SYN同步序列编号（Synchronize Sequence Numbers）
 三次握手的次序是这样子的:
 1）client端首先发送一个SYN包告诉Server端我的初始序列号是X；
 2）Server端收到SYN包后回复给client一个ACK确认包，告诉client说我收到了；
 3）接着Server端也需要告诉client端自己的初始序列号，于是Server也发送一个SYN包告诉client我的初始序列号是Y；
 4）Client收到后，回复Server一个ACK确认包说我知道了。
 其中的 2 、3 步骤可以简化为一步，也就是说将 ACK 确认包和 SYN 序列化包一同发送给 Client 端
 
 四次挥手:
 有一个非常特殊的状态time_wait，它是主动关闭的一方在回复完对方的挥手后进入的一个长期状态，这个状态标准的持续时间是4分钟，4分钟后才会进入到closed状态，释放套接字资源。不过在具体实现上这个时间是可以调整的。
 */

/*
 UDP:
 
 我们都知道 TCP 是面向连接的、可靠的、有序的传输层协议，而 UDP 是面向数据报的、不可靠的、无序的传输协议，所以 UDP 压根不会建立什么连接
 
 ###如果再使用应用层重传，能够完全确保传输的可靠性###
 */

/*
 TCP、UDP 之间的差异:
 
 1.数据发送方式的差异:
 TCP：
 由于 TCP 是建立在两端连接之上的协议，所以理论上发送的数据流不存在大小的限制。但是由于缓冲区有大小限制，所以你如果用 TCP 发送一段很大的数据，可能会截断成好几段，接收方依次的接收。
 UDP：
 由于 UDP 本身发送的就是一份一份的数据报，所以自然而然的就有一个上限的大小
 
 每次 UDP 发送的数据报大小由哪些因素共同决定:
 (1)UDP协议本身，UDP协议中有16位的UDP报文长度，那么UDP报文长度不能超过2^16=65536；
 (2)以太网(Ethernet)数据帧的长度，数据链路层的MTU(最大传输单元)；
 (3)socket的UDP发送缓存区大小
 
 UDP 本身协议的报文长度为 2^16 - 1，UDP 包头占 8 个字节，IP 协议本身封装后包头占 20 个字节，所以最终长度为： 2^16 - 1 - 20 - 8 = 65507 字节
 因为 UDP 属于不可靠协议，我们应该尽量避免在传输过程中，数据包被分割。所以这里有一个非常重要的概念 MTU -- 也就是最大传输单元
 在 Internet 下 MTU 的值为 576 字节，所以在 internet 下使用 UDP 协议，每个数据报最大的字节数为： 576 - 20 - 8 = 548
 
 ###UDP中一个包的大小最大能多大###
 结论1：局域网环境下，建议将UDP数据控制在1472字节以下
 以太网(Ethernet)数据帧的长度必须在46-1500字节之间,这是由以太网的物理特性决定的，这个1500字节被称为链路层的MTU(最大传输单元)。但这并不是指链路层的长度被限制在1500字节，其实这这个MTU指的是链路层的数据区，并不包括链路层的首部和尾部的18个字节。
 
 所以，事实上这个1500字节就是网络层IP数据报的长度限制。因为IP数据报的首部为20字节，所以IP数据报的数据区长度最大为1480字节。而这个1480字节就是用来放TCP传来的TCP报文段或UDP传来的UDP数据报的。
 
 又因为UDP数据报的首部8字节，所以UDP数据报的数据区最大长度为1472字节。这个1472字节就是我们可以使用的字节数。
 当我们发送的UDP数据大于1472的时候会怎样呢？ 这也就是说IP数据报大于1500字节，大于MTU，这个时候发送方IP层就需要分片(fragmentation)。把数据报分成若干片，使每一片都小于MTU，而接收方IP层则需要进行数据报的重组。这样就会多做许多事情，而更严重的是，由于UDP的特性，当某一片数据传送中丢失时，接收方无法重组数据报，将导致丢弃整个UDP数据报。
 因此，在普通的局域网环境下，我建议将UDP的数据控制在1472字节以下为好。
 
 结论2：Internet编程时，建议将UDP数据控制在548字节以下
 进行Internet编程时则不同，因为Internet上的路由器可能会将MTU设为不同的值。如果我们假定MTU为1500来发送数据，而途经的某个网络的MTU值小于1500字节，那么系统将会使用一系列的机制来调整MTU值，使数据报能够顺利到达目的地，这样就会做许多不必要的操作。
 
 鉴于Internet上的标准MTU值为576字节，所以我建议在进行Internet的UDP编程时， 最好将UDP的数据长度控件在548字节(576-8-20)以内。
 unix网络编程第一卷里说：ipv4协议规定ip层的最小重组缓冲区大小为576！所以，建议udp包不要超过这个大小，而不是因为internet的标准MTU是576！
 
 2.数据有序性的差异:
 TCP:
 对于 TCP 来说，本身 TCP 有着超时重传、错误重传、还有等等一系列复杂的算法保证了 TCP 的数据是有序的，假设你发送了数据 1、2、3，则只要发送端和接收端保持连接时，接收端收到的数据始终都是 1、2、3
 UDP:
 而 UDP 协议则要奔放的多，无论 server 端无论缓冲池的大小有多大，接收 client 端发来的消息总是一个一个的接收。并且由于 UDP 本身的不可靠性以及无序性，如果 client 发送了 1、2、3 这三个数据报过来，server 端接收到的可能是任意顺序、任意个数三个数据报的排列组合。
 
 3.可靠性的差异:
 TCP 本身是可靠的协议，而 UDP 是不可靠的协议
 TCP:
 TCP 内部的很多算法机制让他保持连接的过程中是很可靠的。比如：TCP 的超时重传、错误重传、TCP 的流量控制、阻塞控制、慢热启动算法、拥塞避免算法、快速恢复算法 等等。所以 TCP 是一个内部原理复杂，但是使用起来比较简单的这么一个协议。
 
 UDP:
 UDP 是一个面向非连接的协议，UDP 发送的每个数据报带有自己的 IP 地址和接收方的 IP 地址，它本身对这个数据报是否出错，是否到达不关心，只要发出去了就好了
 
 什么情况会导致 UDP 丢包:
 数据报分片重组丢失：UDP 的每个数据报大小多少最合适，事实上 UDP 协议本身规定的大小是 64kb，但是在数据链路层有 MTU 的限制，大小大概在 5kb，所以当你发送一个很大的 UDP 包的时候，这个包会在 IP 层进行分片，然后重组。这个过程就有可能导致分片的包丢失。UDP 本身有 CRC 检测机制，会抛弃掉丢失的 UDP 包；
 UDP 缓冲区填满：当 UDP 的缓冲区已经被填满的时候，接收方还没有处理这部分的 UDP 数据报，这个时候再过来的数据报就没有地方可以存了，自然就都被丢弃了
 
 使用场景:
  UDP 与 TCP 相比，在性能速度上是占优势的
 因为 UDP 并不用保持一个持续的连接，也不需要对收发包进行确认。但事实上经过这么多年的发展 TCP 已经拥有足够多的算法和优化，在网络状态不错的情况下，TCP 的整体性能是优于 UDP 的
 
 非用 UDP 不可:
 对实时性要求高：比如实时会议，实时视频这种情况下，如果使用 TCP，当网络不好发生重传时，画面肯定会有延时，甚至越堆越多。如果使用 UDP 的话，即使偶尔丢了几个包，但是也不会影响什么，这种情况下使用 UDP 比较好；
 多点通信：TCP 需要保持一个长连接，那么在涉及多点通讯的时候，肯定需要和多个通信节点建立其双向连接，然后有时在NAT环境下，两个通信节点建立其直接的 TCP 连接不是一个容易的事情，而 UDP 可以无需保持连接，直接发就可以了，所以成本会很低，而且穿透性好。这种情况下使用 UDP 也是没错的。
 */

/*
 QQ:
 腾讯采用了上层协议来保证可靠传输：如果客户端使用UDP协议发出消息后，服务器收到该包，需要使用UDP协议发回一个应答包。如此来保证消息可以无遗漏传输。之所以会发生在客户端明明看到“消息发送失败”但对方又收到了这个消息的情况，就是因为客户端发出的消息服务器已经收到并转发成功，但客户端由于网络原因没有收到服务器的应答包引起的。
 */

/*
 Router即路由器、Switch即交换机、Hub即集线器
 
 集线器（Hub）:
 集线器起到了一个将网线集结起来的作用，实现最初级的网络互通
 集线器是通过网线直接传送数据的，我们说他工作在物理层
 然而集线器有一个问题，由于和每台设备相连，他不能分辨出具体信息是发送给谁的，只能广泛地广播出去
 
 交换机:
 由于交换机是根据网口地址传送信息，比网线直接传送多了一个步骤，我们也说交换机工作在数据链路层
 在交换机内部通过“表”的方式把MAC地址和IP地址一一对应，也就是所说的IP、MAC绑定
 
 路由器:
 在这套协议中，每个机器都被赋予了一个IP地址，相当于一个门牌号一样。路由器通过IP地址寻址，我们说它工作在计算机的网络层
 这一套协议便是TCP/IP协议簇
 */

/*
 HTTP通信机制是在一次完整的 HTTP 通信过程中，客户端与服务器之间将完成下列7个步骤:
 1）建立 TCP 连接：在HTTP工作开始之前，客户端首先要通过网络与服务器建立连接，该连接是通过 TCP 来完成的，该协议与 IP 协议共同构建 Internet，即著名的 TCP/IP 协议族，因此 Internet 又被称作是 TCP/IP 网络。HTTP 是比 TCP 更高层次的应用层协议，根据规则，只有低层协议建立之后，才能进行高层协议的连接，因此，首先要建立 TCP 连接，一般 TCP 连接的端口号是80；
 2）客户端向服务器发送请求命令：一旦建立了TCP连接，客户端就会向服务器发送请求命令；
 例如：GET/sample/hello.jsp HTTP/1.1；
 3）客户端发送请求头信息：客户端发送其请求命令之后，还要以头信息的形式向服务器发送一些别的信息，之后客户端发送了一空白行来通知服务器，它已经结束了该头信息的发送；
 4）服务器应答：客户端向服务器发出请求后，服务器会客户端返回响应；
 例如： HTTP/1.1 200 OK
 响应的第一部分是协议的版本号和响应状态码；
 5）服务器返回响应头信息：正如客户端会随同请求发送关于自身的信息一样，服务器也会随同响应向用户发送关于它自己的数据及被请求的文档；
 6）服务器向客户端发送数据：服务器向客户端发送头信息后，它会发送一个空白行来表示头信息的发送到此为结束，接着，它就以 Content-Type 响应头信息所描述的格式发送用户所请求的实际数据；
 7）服务器关闭 TCP 连接：一般情况下，一旦服务器向客户端返回了请求数据，它就要关闭 TCP 连接，然后如果客户端或者服务器在其头信息加入了这行代码 Connection:keep-alive ，TCP 连接在发送后将仍然保持打开状态，于是，客户端可以继续通过相同的连接发送请求。保持连接节省了为每个请求建立新连接所需的时间，还节约了网络带宽
 */

// invoke 调用

// 索引的作用是为了提高查询速度

// 对象关系映射 Object Relational Mapping，简称ORM

// xcode配置
/*
 main()函数之前总共使用的时间
 Run->Arguments 环境变量设置:
 DYLD_PRINT_STATISTICS YES
 
 main()函数之前耗时的影响因素:
 动态库加载越多，启动越慢
 ObjC类越多，启动越慢
 C的constructor函数(即__attribute__((constructor)))越多，启动越慢
 C++静态对象越多，启动越慢
 ObjC的+load越多，启动越慢
 */

/*
 ===优化===
 压缩资源图片:
 https://tinypng.com/
 */

//CGRectOffset(CGRectMake(0, 0, 100, 100), 0, 10) // {0, 10, 100, 100}
//CGRectInset(CGRectMake(0, 0, 100, 100), 0, 10) // {0, 10, 100, 80}

// #用来把参数转换成字符串
#define CString(value) #value
// __VA_ARGS__ 是一个可变参数的宏
// ##__VA_ARGS__ 宏前面加上##的作用在于，当可变参数的个数为0时，这里的##起到把前面多余的","去掉的作用,否则会编译出错
#define CLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);

// 父视图layoutSubViews然后子视图layoutSubViews


// NSLog他会做两件事情：1.把日志写到Apple System Log(asl)里面。2.把日志展示到Xcode的控制台上面
// NSLog耗性能的一个原因也是因为需要把日志数据写到Apple System Log数据库
// Swift的print方法就不会把日志写到数据库中.Swift对NSLog方法做了优化，只有在模拟器环境下才会将日志写入Apple System Log
#ifdef DEBUG
#define NDLLog(...) NSLog(__VA_ARGS__)
#else
#define NDLLog(...)
#endif

// 主线程异步队列
#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

#define IsMainThread [NSThread isMainThread]
#define MainThreadAssert() NSAssert([NSThread isMainThread], @"needs to be accessed on the main thread.");

// 归一化:把数据映射到[0,1]或者[-1, 1]区间内
#define NDLNormalization(value) MAX(0, MIN(1, value))

#define NDLScreenW [UIScreen mainScreen].bounds.size.width
#define NDLScreenH [UIScreen mainScreen].bounds.size.height
#define ScreenScale ([[UIScreen mainScreen] scale])

// UIColorFromHex(0xffffff)
#define UIColorFromHex(hex) [UIColor colorWithRed:((hex & 0xFF0000) >> 16) / 255.0 green:((hex & 0x00FF00) >> 8) / 255.0 blue:(hex & 0x0000FF) / 255.0 alpha:1.0]

// 4舍5入 两位小数
#define RoundTwoDecimalPlace(value) (floor(value * 100 + 0.5) / 100)

#define NDLRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define NDLRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define WhiteColor [UIColor whiteColor]


#define Application [UIApplication sharedApplication]
// [UIApplication sharedApplication].windows.firstObject
#define KeyWindow Application.delegate.window
//#define KeyWindow [UIApplication sharedApplication].keyWindow
#define RootViewController KeyWindow.rootViewController

//#define kBaseURL @""

// 弱引用
#define WEAK_REF(obj) \
__weak typeof(obj) weak_##obj = obj; \
// 强引用
#define STRONG_REF(obj) __strong typeof(obj) strong_##obj = weak_##obj;

#define WeakSelf(instance) __weak typeof(self) instance = self;
#define StrongSelf(instance, weakSelf) __strong typeof(self) instance = weakSelf;

// 系统单例宏
// 用户偏好设置
#define UserPreferences [NSUserDefaults standardUserDefaults]
#define NotificationCenter [NSNotificationCenter defaultCenter]
#define CurrentDevice [UIDevice currentDevice]
// 发通知
#define PostNotification(name, obj) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];

/// 判断当前编译使用的SDK版本是否为 iOS 11.0 及以上
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
#define IOS11_SDK_ALLOWED YES
#endif

// iOS系统版本
#define SystemVersion [[UIDevice currentDevice].systemVersion doubleValue]
#define iOS9Later (SystemVersion >= 9.0f)

// ## 把两个语言符号组合成单个语言符号  ...省略号只能代替最后面的宏参数
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

// ui适配
// 资源按照iphone6设计
#define ReferToIphone6WidthRatio (NDLScreenW / 375.0)
#define RealWidthValueReferToIphone6(value) (value * ReferToIphone6WidthRatio)
#define ReferToIphone6HeightRatio (NDLScreenH / 667.0)
#define RealHeightValueReferToIphone6(value) (value * ReferToIphone6HeightRatio)

// 机型小于等于4英寸
#define IS_LESS_THAN_OR_EQUAL_TO_4INCH (NDLScreenW < 375.0)

// 适配iphoneX || iphoneXS
#define iPhoneX_XS (NDLScreenW == 375.f && NDLScreenH == 812.f ? YES : NO)
#define iPhoneX (NDLScreenW == 375.f && NDLScreenH == 812.f ? YES : NO)
// 适配iphoneXR || iphoneXS_MAX
#define iPhoneXR_XSMAX (NDLScreenW == 414.f && NDLScreenH == 896.f ? YES : NO)
// 全面屏
#define FullScreenIphone (iPhoneX_XS || iPhoneXR_XSMAX)

// 视频通话statusBarH会有变化,所以写死20或者44
//#define NDLStatusBarH [UIApplication sharedApplication].statusBarFrame.size.height
//#define NDLNavigationBarH self.navigationController.navigationBar.frame.size.height
#define NavigationBarH 44.0
#define AdditionaliPhoneXTopSafeH 44.0
#define AdditionaliPhoneXBottomSafeH 34.0

#define StatusBarH (FullScreenIphone ? AdditionaliPhoneXTopSafeH : 20.0)

#define TopSafeH (FullScreenIphone ? AdditionaliPhoneXTopSafeH : 0.0)
#define BottomSafeH (FullScreenIphone ? AdditionaliPhoneXBottomSafeH : 0.0)

#define TopExtendedLayoutH (StatusBarH + NavigationBarH)
#define BottomExtendedLayoutH self.tabBarController.tabBar.frame.size.height

// Font
#define UISystemFontMake(size) [UIFont systemFontOfSize:size]
#define UIBoldSystemFontMake(size) [UIFont boldSystemFontOfSize:size]
#define UIFontWithName(nameStr, sizeFloat) [UIFont fontWithName:nameStr size:sizeFloat]

// Image
#define UIImageNamed(nameStr) [UIImage imageNamed:nameStr]

// 自动提示宏
// 宏里面的#，会自动把后面的参数变成C语言的字符串  // 逗号表达式，只取最右边的值
#define keyPath(objc,keyPath) @(((void)objc.keyPath,#keyPath))
// 宏的操作原理，每输入一个字母就会直接把宏右边的拷贝，
// 并且会自动补齐前面的内容。

// #符号用作一个预处理运算符   该过程称为字符串化
/*
 如果x是一个宏参量，那么#x可以把参数名转化成相应的字符串
 PSQR(x) printf("the square of" #x "is %d./n",(x)*(x))
 int y =4;
 PSQR(y);
 PSQR(2+4);
 the square of y is 16
 the square of 2+4 is 36
 */

// 单例
#define SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define SINGLETON_FOR_IMPLEMENT(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

// 获取一段时间间隔
#define StartTime CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define EndTime NDLLog(@"TimeDelta: %lf", CFAbsoluteTimeGetCurrent() - start);


#pragma mark - App

#define MainBundle [NSBundle mainBundle]
// 获取App当前版本号
#define App_Bundle_Version [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
// 获取App当前build版本号
#define App_Build_Version [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
// 获取App当前版本identifier
#define App_Bundle_Identifier [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]
// 获取App当前名字
#define App_Name [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
// 返回dic dic[@"CFBundleURLSchemes"] 返回URLScheme数组
#define App_URLTypes [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"]
// app icon
#define App_Icon_File [[[MainBundle infoDictionary] valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];

// 检查APPStore版本
// http://itunes.apple.com/cn/lookup?id=1071516426

#pragma mark - Device
// 获取当前设备的UUID ?
#define Device_UUID [[[UIDevice currentDevice] identifierForVendor] UUIDString]
// 获取当前设备的系统版本
#define Device_System_Version [[[UIDevice currentDevice] systemVersion] floatValue]


// ====================ignore clang warning====================
#pragma mark - ignore clang warning
//warning 列表参考：https://clang.llvm.org/docs/DiagnosticsReference.html
/*
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wunused-variable"
 #pragma clang diagnostic ignored "-Wundeclared-selector"
 // 这里是会报警告的代码
 #pragma clang diagnostic pop
 */

#define BeginIgnoreDeprecatedWarning _Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"")
#define EndIgnoreDeprecatedWarning _Pragma("clang diagnostic pop")

#define IGNORE_PERFORM_SELECTOR_LEAK_WARNING(code) _Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
code; \
_Pragma("clang diagnostic pop")

// 角度转弧度
#define DEGREE2RADIAN(angle) ((angle) / 180.0 * M_PI)
// 弧度转角度
#define RADIAN2DEGREE(radian) ((radian) * (180.0 / M_PI))
// 是否是有效字符串
#define ValidStringFlag(str) (str && ![str isEqualToString:@""])


// ====================deprecated====================
#pragma mark - deprecated
/*
 NS_DEPRECATED_IOS(2_0, 4_0)
 __attribute((deprecated("不建议使用")))
 */


// @property (nonatomic, strong, nonnull) dispatch_semaphore_t lock;
#define NDLLOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#define NDLUNLOCK(lock) dispatch_semaphore_signal(lock);


#pragma mark - Navigation_BigTitle
#define BigTitleFont [UIFont fontWithName:@"PingFangSC-Medium" size:28]
#define BigTitleTextColor UIColorFromHex(0x343434)
#define TextFieldBigTitleFont [UIFont fontWithName:@"PingFangSC-Medium" size:22];
// TextField光标颜色
#define TextFieldCursorColor UIColorFromHex(0x02C6DC)

// 高德行政区域查询
// https://lbs.amap.com/api/webservice/guide/api/district

// math
// https://blog.csdn.net/u013282174/article/details/80311284 矩阵变换
/*
 向量:
 平面向量是在二维平面内既有方向(direction)又有大小(magnitude)的量，物理学中也称作矢量
 与之相对的是只有大小、没有方向的数量（标量）
 我们可以声明一个向量a⃗  = (2,3)，那么实际上向量a⃗ 就表示起点位于原点，终点位于坐标系中(2,3)的向量
 一旦两个向量的方向和大小相等，那么这两个向量就是相等的向量。
 比如起点位于(1,1)终点位于(3,4)的向量和我们上面的向量a就是方向相同，大小相等的向量，它们两个是相等的向量
 
 向量的标准表达式，也就是我们在上一部分讲到的使用一个坐标点来表示一个向量，该表达式是以起点为原点，取终点的值来表示一个向量
 一个向量a⃗ ，起始点为(x1,y1)，终止点为(x2,y2)，那么它的坐标表达式就是：
 a⃗ =(x2−x1,y2−y1)
 若两个向量的坐标表达式一样，那么它们就是相等的向量
 向量的长度又叫做向量的模 使用勾股定理计算出斜边长度也就是向量的模
 |a⃗ |=开根号((x2−x1)平方+(y2−y1)平方)
 
 向量的夹角表示的是两个向量的起始点相同时所形成的弧度小于π的角的大小
 若有两个向量a⃗ =(x1,y1)和b⃗ =(x2,y2)，则它们的夹角α满足：
 
 cosα=a⃗ ⋅b⃗ / |a⃗ ||b⃗ |
 
 向量的到角指的是两个向量起点相同的情况下，其中一个向量按照一个方向（顺时针或逆时针）旋转后与另一个向量共线所需旋转的角度。
 所以到角有两种情况：顺时针到角和逆时针到角，很容易得到的是，顺时针到角 = 2π - 逆时针到角，其中小于π的那个到角就是夹角
 
 向量的坐标表达式：a⃗ =(x,y)，它实际上类似一条一次曲线（线性曲线，或者说，一次函数图像）：y=kx。
 那么曲线的方向实际上是由斜率决定的，也就是斜率 k=y/x
 那么我们的向量在改变向量的坐标表达式的时候，只要保证斜率不变就可以使向量的长度改变的同时，方向不变
 或者根据相似三角形定理
 我们设向量a⃗ =(x,y)的终点为A，那么A点的坐标就是(x,y)，x和y的几何意义就是点A在x轴和y轴的投影大小，我们画出其中一个投影，也就是从A点向x轴作垂线，垂足为D1，若原点为O。
 那么很明显△AD1O是一个直角三角形，两条直角边的长度分别是OD1=x和AD1=y，斜边长就是向量的模
 接下来，我们要将向量a⃗ =(x,y)的长度设置为l，也就是移动点A，使得向量a⃗ =(x,y)的长度为l而向量的方向不变。
 我们设移动后的终止点为A′(x′,y′)，按照同样的方式作垂线，垂足为D2，那么得到新的直角三角形△AD2O，两条直角边的长度分别是OD2=x′和AD2=y′，
 显然，我们最终是要解出x′和y′的值，也就可以转换成几何问题，解OD2和AD2的长度。
 
 由于OAA′三点共线，那么△AD2O和△AD1O就是相似三角形，那么由相似三角形的边长比值关系，我们可以得到：
 |a⃗ |/l=x/x′=y/y′
 
 向量加法:
 a⃗ =(x1,y1)、b⃗ =(x2,y2)、c⃗ =a⃗ +b⃗
 那么
 c⃗ =(x1+x2,y1+y2)
 向量的加法其实可以简单理解为：参与加法的向量全部收尾相连后，最初的起点和最后的终点即为和向量的起点和终点
 
 向量减法:
 a⃗ =(x1,y1)、b⃗ =(x2,y2)、c⃗ =a⃗ −b⃗
 那么
 c⃗ =(x1−x2,y1−y2)
 
 向量数量积:
 虽然向量不能加减一个自然数，但是可以乘以一个自然数
 若有a⃗ =(x,y)，那么a⃗ ⋅2就表示a⃗ +a⃗ =(2x,2y)，所以向量的数量积就是把向量的坐标表达式的x和y分别乘以这个自然数，
 即对于任意向量a⃗ =(x,y)和任意自然数d：
 a⃗ ⋅d=(d⋅x,d⋅y)
 
 向量内积:
 a⃗ =(x1,y1)、b⃗ =(x2,y2)
 那么
 a⃗ ⋅b⃗ =x1⋅x2+y1⋅y2
 这是线性代数中的矩阵乘法公式（一维矩阵即向量）
 
 向量的平移指的是向量方向和大小不变，仅改变向量起始点的一种操作
 对于一个向量a⃗ =(x,y)，若将其起始点平移至(x1,y1)，，那么此时向量a⃗ 的终止点就是(x+x1,y+y1)
 
 向量的旋转指的是向量以自己的起始点为圆心，按某个方向（顺时针或者逆时针）旋转某个角度。若要沿任意点进行旋转，就涉及到矩阵计算了
 若有向量a⃗ =(x,y)，沿原点顺时针旋转θ后的坐标表达式为(x′,y′)，则有
 x′=x⋅cosθ+y⋅sinθ
 y′=−x⋅sinθ+y⋅cosθ
 
 坐标系转换:
 我们在上面讨论的平面向量的各种公式坐标系都是笛卡尔坐标系，也就是y轴正方向向上，而我们绘图的坐标系是UIKit坐标系，y轴正方向向下
 所以我们如果要在UIKit坐标系下使用笛卡尔向量，只需要在使用公式的时候把旋转方向取反就行了
 */

