//
//  AppDelegate.h
//  TestAVFoundation
//
//  Created by youdun on 2023/11/1.
//

// MARK: - 音频的采样与编码
/**
 音频采样:
 当我们听到声音时，其实是声波通过一定介质传播过来的振动。
 声波的三要素,是频率,振幅,波形.频率代表音阶的高低,振幅代表响度,波形则代表音色。
 每一种声音都是特定频率和振幅的振动。声音总可以被分解为不同频率不同强度的叠加。
 这种变换（或分解）的过程，称为傅里叶变换。因此，一般的声音总是包含一定的频率范围。
 人类可以听到的音频范围是 20 Hz ~ 20 kHz。

 音频数字化过程中采样或测量一个固定的音频信号，过程的周期率被称为采样率。
 由于低采样率的数字信号无法很好表示原始数据，根据采样定理，
 按比声音最高频率高2倍以上的频率（我们称为奈奎斯特频率），对声音进行采样，这个过程称为AD转换。
 
 音频量化:
 音频量化是指将连续的模拟音频信号转换为离散的数字表示的过程。
 
 采样（Sampling） 采样是将连续的模拟音频信号转化为离散的时间点的过程。
 在采样过程中，音频信号的振幅值在一系列离散时间点上进行测量。
 采样频率决定了在一秒内采样的次数，常用的采样频率包括 44.1kHz（用于 CD 音频）和 48kHz（用于数字音频）等。
 更高的采样频率通常会产生更高质量的数字音频。

 量化（Quantization） 量化是将每个采样点的连续振幅值转化为离散的数字值的过程。
 这个数字化过程涉及到将连续振幅范围分成一系列离散的级别，通常以二进制形式表示。
 每个采样点的振幅值将舍入到最接近的离散级别。
 量化级别的数量通常由位深度（bit depth）来表示，例如 16 位或 24 位。
 
 例如，一个 16 位的音频采样通常会有 2^16（65536）个不同的量化级别。
 位深度决定了每个采样点的精确度，更高的位深度提供更精确的表示，但也会占用更多的存储空间。
 
 通过采样和量化，模拟音频信号被转化为数字音频表示，这使得计算机和数字音频设备能够处理、存储和传输音频信息。
 然后，数字音频可以进行各种音频处理操作，如混音、音频效果应用、压缩和解码，最终用于音乐播放、语音通信和多媒体应用中。
 音频量化的位深度通常决定了数字音频的动态范围和音频质量，更高的位深度通常会提供更好的音质。
 
 音频编码:
 常见音频编解码格式
 MP3
 AAC（Advanced Audio Coding）
 WAV（Waveform Audio File Format）和 AIFF（Audio Interchange File Format） 是无损音频格式
 PCM
 
 PCM（脉冲编码调制）是一种常见的无损音频编码格式，通常用于数字音频存储和传输。
 PCM 格式的音频可以在不损失质量的情况下进行各种音频处理操作，如混音、音频效果应用和压缩。
 PCM 音频通常以文件格式（如 WAV、AIFF）进行存储，其中包括音频数据、位深度、采样率和其他元数据。这些文件格式允许以原始 PCM 格式存储音频数据。
 
 如果想要描述一份 PCM 数据，需要从如下几个方向出发:
 量化格式(sampleFormat)
 采样率(sampleRate)
 声道数(channel)
 比特率表示每秒的数据传输速度，通常以位每秒（bps）为单位。以下是计算PCM音频比特率的简单公式
 比特率（bps）= 采样率（Hz） × 位深度（位） × 声道数
 以 CD 音频为例，量化格式为 16 Bit，采样率为 44.1 kHz，声道数为 2
 比特率 = 44,100 Hz × 16 位 × 2 = 1,411,200 bps 或 1.4112 Mbps（兆比特每秒）
 
 "码率" 和 "比特率" 是相同的概念
 
 音频编解码器压缩:
 大部分音频都是使用编解码器来压缩的，有损音频编解码器为这一形式的压缩使用基于人类可感知的高级压缩算法。
 比如即使人类可以理论上听见介于 20 Hz ~ 20 kHz 之间的声音，但我们可能真正敏感的频率区间是 1kHz ~ 5kHz。

 我们可以利用过滤技术减少或消除特定频率，只突出记录了人耳朵较为敏感的中频段声音，
 而对于较高和较低的频率的声音则简略记录，从而大大压缩了所需的存储空间，这只是众多方法中的一种，目的是消除冗余的信号。
 冗余信号就是指不能被人耳感知的信号，包括人耳听觉范围之外的音频信号以及被掩盖掉的音频信号。
 
 WAV编码：
 就是在源 PCM 数据格式的前面加上 44 个字节，分别用来描述 PCM 的采样率，声道数，数据格式等信息.
 特点：音质非常好,大量软件都支持其播放
 适合场合：多媒体开发的中间文件,保存音乐和音效素材

 MP3编码:
 特点：音质在 128Kbit/s 以上表现不错，压缩比比较高，大量软件和硬件都支持，兼容性高。
 适合场合：高比特率下对兼容性有要求的音乐欣赏。
 Core Audio 仅支持对 MP3数据解码的支持，不支持对其进行编码。
 
 AAC编码:
 AAC 是目前比较热门的有损压缩编码技术，并且衍生了 LC-AAC、HE-AAC、HE-AAC v2 三种主要编码格式。
 是 H.264 标准相应的处理方式，这种格式相对比 MP3 有着显著的提升，可以在低比特率的前提下提供更高质量的音频。
 
 LC-AAC 是比较传统的 AAC，主要应用于中高码率的场景编码(>= 80Kbit/s)
 HE-AAC 主要应用于低码率场景的编码(<= 48Kbit/s)
 特点：在小于 128Kbit/s 的码率下表现优异,并且多用于视频中的音频编码
 适合场景：于 128Kbit/s 以下的音频编码,多用于视频中的音频轨的编码

 */

// MARK: - 视频的压缩与文件格式
/**
 视频文件是由一系列称为”帧“的图片组成的，在视频文件的时间轴线上每一帧代表一个场景。
 要创建连续运动的动画，我们要在短时间间隔内提供特定数量的帧。
 视频文件一秒钟内所能展现的帧数称为视频的帧率，并用 FPS 作为单位进行测量。
 
 一般图像是有红（R）、绿（G）、蓝（B)三个通道，每个通道由（0-255）不同的值组成，这就构成了多彩的图像，这称为图像的颜色空间。
 在图像处理中，还有另外的颜色空间，这些更具有可分离性和可操作性。所以很多的图像算法需要将图像从 RGB 转换为其他空间。
 视频数据就是使用 RGB 转换的 Y'CbCr 色彩空间的典型案例。
 
 Y'CbCr 也常称为 YUV，是一种颜色编码方法。
 常使用在各个影像处理组件中。Y'UV、 YUV、YCbCr、YPbPr 等专有名词都可以称为 YUV，彼此有重叠。
 
 “Y” 表示明亮度（Luminance、Luma），“U” 和 “V” 则是色度、浓度（Chrominance、Chroma）。
 这种编码系统非常有用，YUV在对照片或视频编码时，考虑到人类的感知能力，允许降低色度的带宽，因为人眼对亮度差异的敏感度高于色彩变化.
 在此前提下可以设计更加高效压缩图像的编码器（encoder）。

 Y′UV、YUV 、YCbCr、 YPbPr 所指涉的范围，常有混淆或重叠的情况。
 其中 YUV 和 Y'UV 通常用来编码电视的模拟信号，
 而 YCbCr 则是用来描述数字的影像信号，适合视频与图片压缩以及传输，例如 MPEG、JPEG。
 但在现今，YUV 通常已经在电脑系统上广泛使用。
 
 “U” 和 “V” 组件可以被表示成原始的 R、G、和B
 Y=0.299R'+0.587G'+0.114B'
 U=-0.147R'-0.289G'+0.436B'
 V=0.615R'-0.515G'-0.100B'
 
 因为人的眼睛对亮度的敏感度要高于色彩，因此我们可以大幅减少存储在每个像素中的颜色信息，而不至于图片的质量严重受损。
 这个减少颜色数据的过程就成为色彩二次抽样。
 而 4:4:4 、4:2:2 及 4:2:0 这些值的含义就是色彩二次抽样的参数，
 根据这些值按如下格式将亮度比例表示为色度值，这个格式写作 J :a :b，具体含义如下：
 J：几个关联色款中所包含的像素数
 a：用来保存位于第一行中的每个 J像素的色度像素个数
 b：用来保存位于第二行中的每个 J像素的附加像素个数
 
 视频编解码器:
 视频编解码的过程是指对数字视频进行压缩或解压缩的一个过程。通常这种压缩属于有损数据压缩。
 用来表示视频所需要的数据量（通常称之为码率）
 
 视频的码率（bitrate）指的是视频编码中的每秒传输的数据位数。
 它表示视频的数据传输速度，通常以位（bit）每秒（bps）为单位。
 视频的码率决定了视频的质量和文件大小，更高的码率通常会提供更好的质量，但会产生更大的文件。
 
 常用的视频编解码器:
 H.26X 系列，由国际电传视讯联盟远程通信标准化组织(ITU-T)主导，包括 H.261、H.262、H.263、H.264、H.265
 H.261，主要用于老的视频会议和视频电话系统。
 是第一个使用的数字视频压缩标准。实质上说，之后的所有的标准视频编解码器都是基于它设计的。
 H.262，等同于 MPEG-2 第二部分，使用在 DVD、SVCD 和大多数数字视频广播系统和有线分布系统中。
 H.263，主要用于视频会议、视频电话和网络视频相关产品。
 在对逐行扫描的视频源进行压缩的方面，H.263 比它之前的视频编码标准在性能上有了较大的提升。
 尤其是在低码率端，它可以在保证一定质量的前提下大大的节约码率。
 H.264，等同于 MPEG-4 第十部分，也被称为高级视频编码(Advanced Video Coding，简称 AVC)，
 是一种视频压缩标准，一种被广泛使用的高精度视频的录制、压缩和发布格式。
 该标准引入了一系列新的能够大大提高压缩性能的技术，并能够同时在高码率端和低码率端大大超越以前的诸标准。
 H.265，被称为高效率视频编码(High Efficiency Video Coding，简称 HEVC)是一种视频压缩标准，是 H.264 的继任者。
 HEVC 被认为不仅提升图像质量，同时也能达到 H.264 两倍的压缩率（等同于同样画面质量下比特率减少了 50%），
 可支持 4K 分辨率甚至到超高画质电视，最高分辨率可达到 8192×4320（8K 分辨率），这是目前发展的趋势。


 MPEG 系列，由国际标准组织机构(ISO)下属的运动图象专家组(MPEG)开发。
 MPEG格式，它的英文全称为Moving Picture Expert Group，即运动图像专家组格式，家里常看的VCD、SVCD、DVD就是这种格式。
 
 容器格式：
 比如.mov、.avi、.mpg、.vob、.mkv、.rm、.rmvb,这些类型都是文件的容器格式。
 容器格式被认为是源文件格式，它里面包含了封装视频文件所需要的视频信息、音频信息和相关的配置信息(比如：视频和音频的关联信息、如何解码等等)。
 
 在使用 AV Foundation 时，我们将遇到两类主要的格式，它们分别是:
 QuickTime
 对应的文件格式是 .mov，是 Apple 公司开发的一种视频格式，默认的播放器是苹果的 QuickTime。
 这种封装格式具有较高的压缩比率和较完美的视频清晰度等特点，并可以保存 alpha 通道。

 MPEG-4
 对应的文件扩展名是 .mp4，但也有很多不同的变化扩展名也在使用，它为了播放流式媒体的高质量视频而专门设计的，
 以求使用最少的数据获得最佳的图像质量。
 */

// MARK: - AVAsset
/**
 AVAsset 是一个抽象类和不可变类，定义了媒体资源混合呈现的方式，
 将媒体资源的静态属于模块化一个整体，比如标题、时长和元数据等。

 苹果使用类簇设计AVAsset ，用其具体的子类 AVURLAsset和 NSURL实例化，
 这个地址可能是本地的 URL，也可能是远程服务器的 URL。
 
 AVAsset还可以插入到 AVMutableCompositions中，通过多个 AVAsset 组装成一个音视频
 
 AVAssetTrack （轨道）:
 AVAsset 本身并不是媒体资源，作为时基媒体的容器，AVAsset包含旨在一起呈现或处理的轨道（track）集合，
 轨道由AVAssetTrack的实例表示，AVAsset 可以通过 tracks 属性进行访问轨道的集合，
 其集合中每个轨道都具有统一的媒体类型，包括（但不限于）音频、视频、文本、隐藏式字幕，
 而 AVAsset 对象提供有关整个资源的信息，例如持续时间或标题。

 在一个典型的简单情况下，一个轨道代表音频分量，另一个轨道代表视频分量；在复杂的合成中，可能存在多个重叠的音频和视频轨道。
 
 由于 AVAsset 是一个抽象类，意味着它不能直接被实例化，可以通过 URL 来对它进行初始化来实现。
 NSURL *url = <#标识视听资产的 URL，例如电影文件#>；
 AVAsset *asset = [AVAsset assetWithURL:url];
 当它使用 assetWithURL: 方法创建实例时，实际上是创建了它 AVURLAsset子类的一个实例
 
 AVURLAsset 提供了通过传递字典参数选项调整资源的创建方式，字典中可配置选项如下:
 AVURLAssetAllowsCellularAccessKey
 一个布尔值，指示系统是否允许蜂窝网络请求资源，最低使用版本 iOS 10.0

 AVURLAssetAllowsConstrainedNetworkAccessKey
 一个布尔值，指示系统是否允许受约束（开启低数据模式时生效，用户可设置）的网络请求资源，最低使用版本 iOS 13.0

 AVURLAssetAllowsExpensiveNetworkAccessKey
 一个布尔值，指示系统是否允许昂贵的网络（连接蜂窝数据、个人热点或低数据模式时生效，系统自动判断）请求资源，比如蜂窝网络、受约束的网络，最低使用版本 iOS 13.0

 AVURLAssetPreferPreciseDurationAndTimingKey
 一个布尔值，指示资产是否应按时间提供准确的持续时间访问。

 AVURLAssetHTTPCookiesKey
 随 HTTP 请求一起发送的 HTTP cookie，最低使用版本 iOS 8.0

 AVURLAssetReferenceRestrictionsKey
 一个 AVAssetReferenceRestrictions 枚举值，表示在解析对外部媒体数据的引用时资产使用的限制

 AVURLAssetURLRequestAttributionKey
 一个 NSURLRequestAttribution 值，用于指定此资产请求的 URL 的属性，最低使用版本 iOS 15.0

 例如，希望获取更准确的时长信息可以使用 AVURLAssetPreferPreciseDurationAndTimingKey
 NSURL *url = <#标识视听资产的 URL，例如电影文件#>；
 AVURLAsset *anAsset = [[AVURLAsset alloc] initWithURL:url options:@{AVURLAssetPreferPreciseDurationAndTimingKey:@true}];
 
 异步加载:
 VAsset 具有多种有用的方法和属性，可以提供有关资源的信息。
 在创建时，资源就是对基础媒体文件的处理。
 AVAsset使用一种高效的设计方法，即延长载入资源的属性，直到请求时才载入 ，这样就可以快速地创建资源。
 
 AVAsset 和 AVAssetTrack 都遵守了 AVAsynchronousKeyValueLoading 协议
 开发者可以在调用资产的方法之前先查询给定属性的状态AVKeyValueStatus，如果状态不是AVKeyValueStatusLoaded ，则需要先异步加载属性值。
 
 loadValuesAsynchronouslyForKeys:completionHandler:duration 加载资产的属性:
 NSURL *url = <#A URL that identifies an audiovisual asset such as a movie file#>;
 AVURLAsset *anAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
 NSArray *keys = @[@"duration"];

 [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^() {

   NSError *error = nil;
   AVKeyValueStatus tracksStatus = [asset statusOfValueForKey:@"duration" error:&error];
   switch (tracksStatus) {
       case AVKeyValueStatusLoaded:
           [self updateUserInterfaceForDuration];
           break;
       case AVKeyValueStatusFailed:
           [self reportError:error forAsset:asset];
           break;
       case AVKeyValueStatusCancelled:
           // Do whatever is appropriate for cancelation.
           break;
  }
 }];

 由于 loadValuesAsynchronouslyForKeys:completionHandler:duration 可能会因为某种原因失败、或者被取消，因此，在回调中需要检查当前状态。

 一次加载多个属性可以使 AV Foundation 通过批量加载请求来优化性能。
 */

// MARK: - 元数据（AVMetadataItem）
/**
 媒体容器格式会存储有关其媒体的描述性元数据。
 对于开发人员来说，使用元数据具有一定的挑战性，因为每种容器格式都有自己独特的元数据格式，
 需要对相应格式读写操作的底层技术有所了解。
 不过 AV Foundation 让这一切变得简单，它提供了 AVMetadataItem 类用于统一处理媒体元数据，
 使得开发者不需要考虑大多数特定格式的细节。

 加载资产的元数据:
 AVAsset 和 AVAssetTrack 提供了三种方法可以获取相关的元数据，要了解这三种方法的适用范围，首先要了解 keySpace 的含义。
 AV Foundation 使用 AVMetadataKeySpace 将各个键组合在一起的方法，可以实现对 AVMetadataItem 实例集合的筛选。

 CommonMetadata:
 每个资源至少有一个 AVMetadataKeySpaceCommon 通用键空间供从中获取元数据。AVMetadataKeySpaceCommon 用来定义所有支持的媒体类型的键，包括诸如名称，作者，描述等常见元素，
 这提供了一种对所有支持的媒体格式进行一定级别的元数据标准化的过程。
 开发者可以通过查询 AVAsset 或者 AVAssetTrack 的 commonMetadata 属性获取元数据。
 NSArray *keys = @[@"commonMetadata"];
 [anAsset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
     NSLog(@"CommonMetadata:%ld\n",anAsset.commonMetadata.count);
     for (AVMetadataItem *item in anAsset.commonMetadata) {
         NSLog(@"CommonMetadata，%@:%@\n",item.key,item.value);
     }
 }];
 
 metadataForFormat:
 访问指定格式的元数据需要在 AVAsset 或者 AVAssetTrack 上调用 metadataForFormat方法。
 这个方法包含一个用于定义数据格式的 NSString 对象返回一个包含所有相关元数据信息的 NSArray。
 AVMetadataFormat.h 文件为不同的元数据格式提供对应的字符串常量。与硬编码某个具体的元数据格式字符串不同，
 可以通过 availableMetadataFormats 获取包含的所有元数据格式。
 NSArray *keys = @[@"availableMetadataFormats"];
 [anAsset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
     AVKeyValueStatus status = [anAsset statusOfValueForKey:@"availableMetadataFormats" error:&error];
     if(statuc == AVKeyValueStatusLoaded){
       NSMutableArray *availableMetadatas = [NSMutableArray array];
       for (NSString *format in anAsset.availableMetadataFormats) {
           [availableMetadatas addObjectsFromArray:[anAsset metadataForFormat:format]];

       }
       NSLog(@"availablemetadatas.count:%ld\n",availableMetadatas.count);
       for (AVMetadataItem *item in availableMetadatas) {
           NSLog(@"availablemetadatas，%@:%@:%@\n",item.keySpace,item.key,item.value);
       }
     }
 }];
 注意： 调用 metadataForFormat: 时要确保 availableMetadataFormats 已经加载
 
 metadata:
 AV Foundation 在 iOS 8.0 提供了 metadata 方法查询 AVAsset 所有可用的元数据数组。
 NSArray *keys = @[@"metadata"];
 [anAsset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
    NSError *error;
    AVKeyValueStatus status = [anAsset statusOfValueForKey:@"metadata" error:&error];
    if(status == AVKeyValueStatusLoaded){
        NSLog(@"metadata:%ld\n",anAsset.metadata.count);
        for (AVMetadataItem *item in anAsset.metadata) {
            NSLog(@"metadatas，%@:%@\n",item.key,item.value);
        }
    }
}];
 
 查找元数据:
 当我们得到一个包含元数据项的数组时，通常希望找到所需的具体元数据值。
 一个特别有效的方法是使用 AVMetadataItem 提供的便利方法，获取结果集合并对其进行筛选。
 AVMetadataItem 在早期通过metadataItemsFromArray:metadatawithKey:keySpace: 过滤指定的元数据，
 例如，如果开发者希望获得一个 .MOV 视频文件的标题，需要按如下方法获取
 NSArray *metadata = <#AVMetadataItem 的集合#>；
 NSString * keySpace = AVMetadataKeySpaceCommon;
 NSString *titleKey = AVMetadataCommonKeyTitle;
 NSArray *titleMetadata = [AVMetadataItem metadataItemsFromArray:metadatawithKey:AVMetadataCommonKeyTitle keySpace:AVMetadataKeySpaceCommon];
 
 后来，上述方法已经不建议使用。提供了新的方法用于查找指定的元数据:
 metadataItemsFromArray:filteredAndSortedAccordingToPreferredLanguages:
 metadataItemsFromArray:filteredByIdentifier:
 metadataItemsFromArray:filteredByMetadataItemFilter:
 例如，查找特定元数据项的最简单方法是按 AVMetadataIdentifier（标识符）过滤，它将键空间和键组合成一个单元。
 NSArray *metadata = <#AVMetadataItem 的集合#>；
 NSArray *metadatas = [AVMetadataItem metadataItemsFromArray:availableMetadatas filteredByIdentifier:AVMetadataCommonIdentifierTitle];
 
 使用元数据:
 AVMetadataItem 最基本的形式其实是一个封装键值对的容器。
 可通过它定义的 AVMetadataKey commonKey，查询其是否存在于公共键空间内，
 而 key 和 value 都被定义成 id <NSObject, NSCopying> 形式，它可能是 NSString， NSNumber等情况。
 如果开发者已经提前知道 value 的类型，AVMetadataItem 提供三个类型强制属性stringValue、numberValue 和 dataValue。

 由于 AVMetadataItem 的 key 是泛类型，我们在使用时可能存在获取错误的情况，因此可以在 AVMetadataItem 上添加一个名为 keyString 的分类方法从而获取 key 的字符串

 - (NSString *)keyString {
     if ([self.key isKindOfClass:[NSString class]]) {                        // 1
         return (NSString *)self.key;
     }
     else if ([self.key isKindOfClass:[NSNumber class]]) {

         UInt32 keyValue = [(NSNumber *) self.key unsignedIntValue];         // 2
         
         // Most, but not all, keys are 4 characters ID3v2.2 keys are
         // only be 3 characters long.  Adjust the length if necessary.
         
         size_t length = sizeof(UInt32);                                     // 3
         if ((keyValue >> 24) == 0) --length;
         if ((keyValue >> 16) == 0) --length;
         if ((keyValue >> 8) == 0) --length;
         if ((keyValue >> 0) == 0) --length;
         
         long address = (unsigned long)&keyValue;
         address += (sizeof(UInt32) - length);

         // keys are stored in big-endian format, swap
         keyValue = CFSwapInt32BigToHost(keyValue);                          // 4

         char cstring[length];                                               // 5
         strncpy(cstring, (char *) address, length);
         cstring[length] = '\0';

         // Replace '©' with '@' to match constants in AVMetadataFormat.h
         if (cstring[0] == '\xA9') {                                         // 6
             cstring[0] = '@';
         }

         return [NSString stringWithCString:(char *) cstring                 // 7
                                   encoding:NSUTF8StringEncoding];

     }
     else {
         return @"<<unknown>>";
     }
 }
 */

// MARK: - 资源导出（AVAssetExportSession）
/**
 AVAssetExportSession 用于将 AVAsset 内容根据导出预设条件进行转码，并将导出资源写到磁盘中。
 其提供了多个功能来实现将一种格式转换为另一种格式、修订资源的内容、修改资源的音频和视频行为，以及写入新的元数据。
 
 AVAsset *anAsset = <#获取资产#>;
 NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:anAsset];
 if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality]) {
     AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]
         initWithAsset:anAsset presetName:AVAssetExportPresetLowQuality];
     // 执行继续。
 }
 
 导出预设:
 AVAssetExportSession提供了一个方法 allExportPresets，可以查看当前系统设备所有可用的导出预设名称，在 iOS 系统中大致分为 5 类
 质量预设
 AVAssetExportPresetHighestQuality,
 AVAssetExportPresetLowQuality,
 AVAssetExportPresetMediumQuality

 尺寸预设
 AVAssetExportPreset640x480,
 AVAssetExportPreset960x540,
 AVAssetExportPreset1280x720,
 AVAssetExportPreset1920x1080,
 AVAssetExportPreset3840x2160

 HEVC 尺寸预设
 AVAssetExportPresetHEVC1920x1080,
 AVAssetExportPresetHEVC1920x1080WithAlpha,
 AVAssetExportPresetHEVC3840x2160,
 AVAssetExportPresetHEVC3840x2160WithAlpha,
 AVAssetExportPresetHEVCHighestQuality,
 AVAssetExportPresetHEVCHighestQualityWithAlpha

 纯音频预设
 AVAssetExportPresetAppleM4A
 
 直通预设
 AVAssetExportPresetPassthrouge
 
 
 配置输出 URL：
 创建一个导出会话后，需要指定一个 outputURL 用于声明导出内容将要写入的地址，AVAssetExportSession 可以从 URL 路径的扩展名设置输出文件类型，但是通常直接使用 outputFileType 值来表示将要写入的导出格式。
 还可以指定其他属性，例如时间范围、输出文件长度的限制、导出的文件是否应针对网络使用进行优化以及视频合成。
 使用 timeRange属性修剪影片：
 exportSession.outputURL = <#A file URL#>;
 exportSession.outputFileType = AVFileTypeQuickTimeMovie;

 CMTime start = CMTimeMakeWithSeconds(1.0, 600);
 CMTime duration = CMTimeMakeWithSeconds(3.0, 600);
 CMTimeRange range = CMTimeRangeMake(start, duration);
 exportSession.timeRange = range;
 */

// MARK: - 音频会话（Audio Session）
/**
 使用iPhone打开一首歌曲，音频从内置扬声器中播放出来，此时有电话拨入，音乐会立即停止并处于暂停状态。
 此时听到的是手机呼叫的铃声，当我们挂掉电话后，刚才的音乐再次响起。在这一过程中 iOS 提供了一个可管理的音频环境，通过 音频会话（Audio Session）来管理应用程序、应用程序间和设备级别的音频行为。

 音频会话：
 音频会话在应用程序和操作系统之间扮演者中间人的角色，它提供了一种简单实用的方法使得系统得知应用程序应该如何与 iOS 音频环境进行交互。
 
 所有 iOS 应用程序启动后，都具有一个默认音频会话，无论是否使用。默认音频会话来自于以下一些预配置：
 支持音频播放，但不允许录音。
 在 iOS 中，将响铃/静音开关设置为静音模式会使应用程序正在播放的任何音频静音。
 在 iOS 中，当设备被锁定时，应用程序的音频会静音。
 当应用程序播放音频时，任何其他后台音频（例如音乐应用程序正在播放的音频）都会被静音。

 音频会话类别：
 类别    作用    是否允许混音    音频的输入与输出    由响铃/静音开关和屏幕锁定静音
 AVAudioSessionCategoryAmbient    游戏、效率应用程序    Yes    仅输出    Yes
 AVAudioSessionCategorySoloAmbient (默认)    游戏、效率应用程序    No    仅输出    Yes
 AVAudioSessionCategoryPlayback    音频和视频播放器    可选    仅输出    No
 AVAudioSessionCategoryRecord    录音机、音频捕捉    No    仅输入    No
 AVAudioSessionCategoryPlayAndRecord    Voip、语言聊天    可选    输入和输出    No
 AVAudioSessionCategoryMultiRoute    使用外部硬件的高级 A/V应用程序    No    输入和输出    No

 AVAudioSession *session = [AVAudioSession sharedInstance];

 NSError *error;
 if (![session setCategory:AVAudioSessionCategoryPlayback error:&error]) {
     NSLog(@"Category Error: %@", [error localizedDescription]);
 }

 if (![session setActive:YES error:&error]) {
     NSLog(@"Activation Error: %@", [error localizedDescription]);
 }
 
 音频中断及处理：
 音频中断是应用程序音频会话的停用——它会立即停止音频。
 当来自其它应用程序的音频会话被激活并且该会话未被系统分类以与我们的应用程序的音频混合时，就会发生中断。
 在会话处于非活动状态后，系统会发送一条“被中断”消息，可以通过保存状态、更新用户界面等来响应该消息。

 首先需要得到中断出现的通知
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
 
 在系统发送通知调用 handlerInterruption: 时传递的NSNotification 实例包含一个 userInfo 提供中断详细信息的填充字典。可以通过从字典中检索 AVAudioSessionInterruptionType 值来确定中断的类型，中断类型指示中断是已经开始还是已经结束。

 typedef NS_ENUM(NSUInteger, AVAudioSessionInterruptionType) {
     AVAudioSessionInterruptionTypeBegan = 1, ///< the system has interrupted your audio session
     AVAudioSessionInterruptionTypeEnded = 0, ///< the interruption has ended
 };
 
 当中断出现时，类型为 AVAudioSessionInterruptionTypeBegan，需要采取的动作就是暂停音频播放以及 UI 界面的处理。

 当中断结束时，类型为 AVAudioSessionInterruptionTypeEnded，userInfo 中可能包含一个AVAudioSessionInterruptionOptions 值，指示音频会话是否以及重新激活以及它是否可以再次播放。如果选项值为 AVAudioSessionInterruptionOptionShouldResume，则可以继续播放。

 
 响应路由的变化：
 当应用程序运行时，用户可能会插入或拔出耳机，或使用带有音频连接的扩展坞。
 https://developer.apple.com/design/human-interface-guidelines/playing-audio
 
 音频硬件路由是音频信号的有线电子通路。当设备的用户插入或拔出耳机时，系统会发生线路改变， AVAudioSession 会广播一个描述该变化的通知AVAudioSessionRouteChangeNotification 给所有相关的监听者。

 需要注册 AVAudioSession 发送的通知AVAudioSessionRouteChangeNotification，该通知包含一个 userInfo 字典，携带了通知发送的原因及前一个路由的描述。
 [[NSNotificationCenter defaultCenter] addObserver:self
              selector:@selector(handleRouteChange:)
                  name:AVAudioSessionRouteChangeNotification
                object:[AVAudioSession sharedInstance]];
 
 收到通知后查看保存在userInfo 字典中 AVAudioSessionRouteChangeReasonKey 判断路由变更的原因：

 AVAudioSessionRouteChangeReasonNewDeviceAvailable，连接新设备
 AVAudioSessionRouteChangeReasonOldDeviceUnavailable，移除设备

 当有设备断开时，获取 userInfo 中描述前一个路由信息 的AVAudioSessionRouteChangePreviousRouteKey，其整合在一个输入 NSArray 和一个输出 NSArray 中，判断其中第一个是否为 AVAudioSessionPortHeadphones （耳机接口）。
 - (void)handleRouteChange:(NSNotification *)notification {

     NSDictionary *info = notification.userInfo;

     AVAudioSessionRouteChangeReason reason =
         [info[AVAudioSessionRouteChangeReasonKey] unsignedIntValue];

     if (reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {

         AVAudioSessionRouteDescription *previousRoute =
             info[AVAudioSessionRouteChangePreviousRouteKey];

         AVAudioSessionPortDescription *previousOutput = previousRoute.outputs[0];
         NSString *portType = previousOutput.portType;

         if ([portType isEqualToString:AVAudioSessionPortHeadphones]) {
             //暂停
         }
     }
 }
 */


// MARK: - AVFoundation 使用高帧率捕捉的目的
/**
 帧率捕捉（High Frame Rate Capture）
 
 1. 实现慢动作回放（Slow Motion Playback）
 这是高帧率捕捉最常见、最核心的用途：
 比如 iPhone 支持以 120 fps 或 240 fps 捕捉视频；
 播放时仍以 正常的 30 fps 播放，从而形成 慢动作效果。
 
 举例：
 用 240 fps 拍摄 2 秒，生成了 480 帧；
 以 30 fps 播放时，视频长度变为 16 秒慢动作回放。
 
 2. 拍摄快速运动物体时减少运动模糊
 比如拍摄：
 体育比赛中的快速移动
 宠物奔跑
 飞溅的水、火花等高动态画面

 高帧率意味着每帧的 曝光时间更短，从而更清晰，降低运动模糊。
 
 3. 提高后期剪辑的灵活性
 高帧率可以：
 在剪辑时任意挑选关键帧，画面更平滑
 支持从视频中提取高质量的图片序列（类似 burst 模式）
 实现变速视频（如从正常 → 慢动作 → 恢复正常）
 
 4. 视觉增强体验（AR / 游戏 / 特效）
 高帧率可以用于捕捉手势、头部动作等微小变化
 对于 AR 应用、增强现实交互、游戏直播等场景，可以更准确捕捉用户动作
 
 CMTimeMake(1, 240)
 CMTimeMake(value, timescale)
 value: 分子（时间的数值）
 timescale: 分母（每秒的单位刻度数）
 也就是 每帧持续时间为 1/240 秒，也就是frameDuration，对应的帧率就是 240 fps（帧每秒）。
 fps（frames per second，帧每秒）越高，表示单位时间内显示或捕捉的画面越多，画面越“流畅”或“细腻”。
 */


#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@end

