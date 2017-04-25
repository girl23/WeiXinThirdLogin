//
//  SendMsgToWeChatViewController.m
//  ApiClient
//
//  Created by Tencent on 12-2-27.
//  Copyright (c) 2012年 Tencent. All rights reserved.
//

#import "SendMsgToWeChatViewController.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "RespForWeChatViewController.h"
#import "Constant.h"
#import "WechatAuthSDK.h"

@interface SendMsgToWeChatViewController ()<WXApiManagerDelegate,UITextViewDelegate, WechatAuthAPIDelegate>

@property (nonatomic) enum WXScene currentScene;
@property (nonatomic, strong) NSString *appId;

@end

@implementation SendMsgToWeChatViewController

@synthesize currentScene = _currentScene;
@synthesize appId = _appId;

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupHeadView];
    [self setupLineView];
    [self setupSceneView];
    [self setupFootView];
    [WXApiManager sharedManager].delegate = self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)dealloc {
    [_appId release];
    [super dealloc];
}

#pragma mark - User Actions
- (void)onSelectSessionScene {
    _currentScene = WXSceneSession;
    
    UILabel *tips = (UILabel *)[self.view viewWithTag:TIPSLABEL_TAG];
    tips.text = @"分享场景:会话";
}

- (void)onSelectTimelineScene {
    _currentScene = WXSceneTimeline;
    
    UILabel *tips = (UILabel *)[self.view viewWithTag:TIPSLABEL_TAG];
    tips.text = @"分享场景:朋友圈";
}

- (void)onSelectFavoriteScene {
    _currentScene = WXSceneFavorite;
    
    UILabel *tips = (UILabel *)[self.view viewWithTag:TIPSLABEL_TAG];
    tips.text = @"分享场景:收藏";
}

- (void)sendTextContent {
    [WXApiRequestHandler sendText:kTextMessage
                          InScene:_currentScene];
}

- (void)sendImageContent {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res1" ofType:@"jpg"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    
    UIImage *thumbImage = [UIImage imageNamed:@"res1thumb.png"];
    [WXApiRequestHandler sendImageData:imageData
                               TagName:kImageTagName
                            MessageExt:kMessageExt
                                Action:kMessageAction
                            ThumbImage:thumbImage
                               InScene:_currentScene];
}

- (void)sendLinkContent {
    UIImage *thumbImage = [UIImage imageNamed:@"res2.png"];
    [WXApiRequestHandler sendLinkURL:kLinkURL
                             TagName:kLinkTagName
                               Title:kLinkTitle
                         Description:kLinkDescription
                          ThumbImage:thumbImage
                             InScene:_currentScene];
}

- (void)sendMusicContent {
    UIImage *thumbImage = [UIImage imageNamed:@"res3.jpg"];
    [WXApiRequestHandler sendMusicURL:kMusicURL
                              dataURL:kMusicDataURL
                                Title:kMusicTitle
                          Description:kMusicDescription
                           ThumbImage:thumbImage
                              InScene:_currentScene];
}

- (void)sendVideoContent {
    UIImage *thumbImage = [UIImage imageNamed:@"res7.jpg"];
    [WXApiRequestHandler sendVideoURL:kVideoURL
                                Title:kVideoTitle
                          Description:kVideoDescription
                           ThumbImage:thumbImage
                              InScene:_currentScene];
}

- (void)sendAppContent {
    Byte* pBuffer = (Byte *)malloc(BUFFER_SIZE);
    memset(pBuffer, 0, BUFFER_SIZE);
    NSData* data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
    free(pBuffer);

    UIImage *thumbImage = [UIImage imageNamed:@"res2.jpg"];
    [WXApiRequestHandler sendAppContentData:data
                                    ExtInfo:kAppContentExInfo
                                     ExtURL:kAppContnetExURL
                                      Title:kAPPContentTitle
                                Description:kAPPContentDescription
                                 MessageExt:kAppMessageExt
                              MessageAction:kAppMessageAction
                                 ThumbImage:thumbImage
                                    InScene:_currentScene];
}

- (void)sendNonGifContent {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res5"
                                                         ofType:@"jpg"];
    NSData *emoticonData = [NSData dataWithContentsOfFile:filePath];
    
    UIImage *thumbImage = [UIImage imageNamed:@"res5thumb.png"];
    [WXApiRequestHandler sendEmotionData:emoticonData
                              ThumbImage:thumbImage
                                 InScene:_currentScene];
}

- (void)sendGifContent {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res6"
                                                         ofType:@"gif"];
    NSData *emoticonData = [NSData dataWithContentsOfFile:filePath];
    
    UIImage *thumbImage = [UIImage imageNamed:@"res6thumb.png"];
    [WXApiRequestHandler sendEmotionData:emoticonData
                              ThumbImage:thumbImage
                                 InScene:_currentScene];
}

- (void)sendAuthRequest {
    [WXApiRequestHandler sendAuthRequestScope: kAuthScope
                                        State:kAuthState
                                       OpenID:kAuthOpenID
                             InViewController:self];
}

- (void)sendFileContent {
    UIImage *thumbImage = [UIImage imageNamed:@"res2.jpg"];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:kFileName
                                                         ofType:kFileExtension];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];

    [WXApiRequestHandler sendFileData:fileData
                        fileExtension:kFileExtension
                                Title:kFileTitle
                          Description:kFileDescription
                           ThumbImage:thumbImage
                              InScene:_currentScene];
}

- (void)openProfile {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请输入appid"
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = kProfileAppIdAlertTag;
    [alertView textFieldAtIndex:0].text = @"gh_877fdb038ace";
    [alertView show];
    [alertView release];
}

- (void)jumpToBizWebview {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请输入appid"
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = kBizWebviewAppIdAlerttag;
    [alertView textFieldAtIndex:0].text = @"wxae3e8056daea8727";
    [alertView show];
    [alertView release];
}

- (void)addCardToWXCardPackage {
    [WXApiRequestHandler addCardsToCardPackage:@[@"pbLatjud4zKvxcCnYCh_7oUhKlMs"]];
}

- (void)batchAddCardToWXCardPackage {
    [WXApiRequestHandler addCardsToCardPackage:@[@"po_2Djks4-yP5PGtgGY4GkbAIIt0",
                                                 @"po_2Djks4-yP5PGtgGY4GkbAIIt0",
                                                 @"po_2DjtUhT_i8Q5Hgc0HLkCegYc8"]];
}

- (void)chooseCard {
    [WXApiRequestHandler chooseCard:@"wxc0b84a53ed8e8d29"
                           cardSign:@"6699285f17e8dcc7ad4e7cfae83421e7f5d7c22f"
                           nonceStr:@"dashdkahsfkjfjakhakfjak"
                           signType:@"SHA1"
                          timestamp:1456926408];
}

- (void)testAuthSDK {
    
    WechatAuthSDK *testSDK = [[WechatAuthSDK alloc] init];
    testSDK.delegate = self;
    
    [testSDK Auth:@"1" nonceStr:@"2" timeStamp:@"3" scope:@"4" signature:@"5" schemeData:@"6"];
}

- (void)testOpenUrl {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请输入URL"
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = kOpenUrlAlertTag;
    [alertView textFieldAtIndex:0].text = @"";
    [alertView textFieldAtIndex:0].placeholder = @"http(s)://";
    [alertView show];
    [alertView release];
}

- (void)openUrl:(NSString *)url
{
    if (url.length <= 0) {
        return;
    }
    [WXApiRequestHandler openUrl:url];
}

#pragma mark -WechatAuthAPIDelegate
//得到二维码
- (void)onAuthGotQrcode:(UIImage *)image
{
    NSLog(@"onAuthGotQrcode");
}

//二维码被扫描
- (void)onQrcodeScanned
{
    NSLog(@"onQrcodeScanned");
}

//成功登录
- (void)onAuthFinish:(int)errCode AuthCode:(NSString *)authCode
{
    NSLog(@"onAuthFinish");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"onAuthFinish"
                                                    message:[NSString stringWithFormat:@"authCode:%@ errCode:%d", authCode, errCode]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex)
        return;
    
    if (alertView.tag == kRecvGetMessageReqAlertTag) {
        RespForWeChatViewController* controller = [[RespForWeChatViewController alloc]autorelease];
        [self presentViewController:controller animated:YES completion:nil];
    } else if(alertView.tag == kProfileAppIdAlertTag
              || alertView.tag == kBizWebviewAppIdAlerttag) {
        _appId = [[alertView textFieldAtIndex:0].text retain];
        
        UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"请输入tousername"
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                            otherButtonTitles:@"确定", nil];
        view.alertViewStyle = UIAlertViewStylePlainTextInput;
        view.tag = (alertView.tag == kProfileAppIdAlertTag) ? kProfileUserNameAlertTag : kBizWebviewTousernameAlertTag;
        [view textFieldAtIndex:0].text = @"gh_877fdb038ace";
        [view show];
        [view release];
    } else if(alertView.tag == kProfileUserNameAlertTag) {
        [WXApiRequestHandler openProfileWithAppID:_appId
                                      Description:@"demo 2.0"
                                         UserName:[alertView textFieldAtIndex:0].text
                                           ExtMsg:kProfileExtMsg];
    } else if(alertView.tag == kBizWebviewTousernameAlertTag) {
        [WXApiRequestHandler jumpToBizWebviewWithAppID:_appId
                                           Description:@"demo 2.0"
                                             tousrname:[alertView textFieldAtIndex:0].text
                                                ExtMsg:kBizWebviewExtMsg];
    } else if(alertView.tag == kOpenUrlAlertTag)
    {
        NSString *url = [alertView textFieldAtIndex:0].text;
        [self openUrl:url];
    }
}

#pragma mark - WXApiManagerDelegate
- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)req {
    // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
    NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
    NSString *strMsg = [NSString stringWithFormat:@"openID: %@", req.openID];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                    message:strMsg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    alert.tag = kRecvGetMessageReqAlertTag;
    [alert show];
    [alert release];
}

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)req {
    WXMediaMessage *msg = req.message;
    
    //显示微信传过来的内容
    NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
    NSString *strMsg = nil;
    
    if ([msg.mediaObject isKindOfClass:[WXAppExtendObject class]]) {
        WXAppExtendObject *obj = msg.mediaObject;
        strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n描述：%@ \n附带信息：%@ \n文件大小:%lu bytes\n附加消息:%@\n", req.openID, msg.title, msg.description, obj.extInfo, (unsigned long)obj.fileData.length, msg.messageExt];
    }
    else if ([msg.mediaObject isKindOfClass:[WXTextObject class]]) {
        WXTextObject *obj = msg.mediaObject;
        strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n描述：%@ \n内容：%@\n", req.openID, msg.title, msg.description, obj.contentText];
    }
    else if ([msg.mediaObject isKindOfClass:[WXImageObject class]]) {
        WXImageObject *obj = msg.mediaObject;
        strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n描述：%@ \n图片大小:%lu bytes\n", req.openID, msg.title, msg.description, (unsigned long)obj.imageData.length];
    }
    else if ([msg.mediaObject isKindOfClass:[WXLocationObject class]]) {
        WXLocationObject *obj = msg.mediaObject;
        strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n描述：%@ \n经纬度：lng:%f_lat:%f\n", req.openID, msg.title, msg.description, obj.lng, obj.lat];
    }
    else if ([msg.mediaObject isKindOfClass:[WXFileObject class]]) {
        WXFileObject *obj = msg.mediaObject;
        strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n描述：%@ \n文件类型：%@ 文件大小:%lu\n", req.openID, msg.title, msg.description, obj.fileExtension, (unsigned long)obj.fileData.length];
    }
    else if ([msg.mediaObject isKindOfClass:[WXWebpageObject class]]) {
        WXWebpageObject *obj = msg.mediaObject;
        strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n描述：%@ \n网页地址：%@\n", req.openID, msg.title, msg.description, obj.webpageUrl];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                    message:strMsg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)req {
    WXMediaMessage *msg = req.message;
    
    //从微信启动App
    NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
    NSString *strMsg = [NSString stringWithFormat:@"openID: %@, messageExt:%@", req.openID, msg.messageExt];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                    message:strMsg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response {
    NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", response.errCode];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                    message:strMsg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response {
        NSMutableString* cardStr = [[[NSMutableString alloc] init] autorelease];
    for (WXCardItem* cardItem in response.cardAry) {
        [cardStr appendString:[NSString stringWithFormat:@"cardid:%@ cardext:%@ cardstate:%u\n",cardItem.cardId,cardItem.extMsg,(unsigned int)cardItem.cardState]];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"add card resp"
                                                    message:cardStr
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (void)managerDidRecvChooseCardResponse:(WXChooseCardResp *)response {
    NSMutableString* cardStr = [[[NSMutableString alloc] init] autorelease];
    for (WXCardItem* cardItem in response.cardAry) {
        [cardStr appendString:[NSString stringWithFormat:@"cardid:%@, encryptCode:%@, appId:%@\n",cardItem.cardId,cardItem.encryptCode,cardItem.appID]];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"choose card resp"
                                                    message:cardStr
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
    NSString *strMsg = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", response.code, response.state, response.errCode];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                    message:strMsg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

#pragma mark - Private Methods
- (void)setupHeadView {
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHeadViewHeight)];
    [headView setBackgroundColor:RGBCOLOR(0xe1, 0xe0, 0xde)];
    UIImage *image = [UIImage imageNamed:@"micro_messenger.png"];
    NSInteger tlx = (headView.frame.size.width -  image.size.width) / 2;
    NSInteger tly = 20;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(tlx, tly, image.size.width, image.size.height)];
    [imageView setImage:image];
    [headView addSubview:imageView];
    [imageView release];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, tly + image.size.height, SCREEN_WIDTH, 40)];
    [title setText:[NSString stringWithFormat:@"微信OpenAPI(%@) Sample Demo",[WXApi getApiVersion]]];
    title.font = [UIFont systemFontOfSize:17];
    title.textColor = RGBCOLOR(0x11, 0x11, 0x11);
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    [headView addSubview:title];
    [title release];
    
    [self.view addSubview:headView];
    [headView release];
}

- (void)setupLineView {
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, kHeadViewHeight, SCREEN_WIDTH, 1)];
    lineView1.backgroundColor = [UIColor blackColor];
    lineView1.alpha = 0.1f;
    [self.view addSubview:lineView1];
    [lineView1 release];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, kHeadViewHeight + 1, SCREEN_WIDTH, 1)];
    lineView2.backgroundColor = [UIColor whiteColor];
    lineView2.alpha = 0.25f;
    [self.view addSubview:lineView2];
    [lineView2 release];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, kHeadViewHeight + 2 + kSceneViewHeight, SCREEN_WIDTH, 1)];
    lineView3.backgroundColor = [UIColor blackColor];
    lineView3.alpha = 0.1f;
    [self.view addSubview:lineView3];
    [lineView3 release];
    
    UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake(0, kHeadViewHeight + 2 + kSceneViewHeight + 1, SCREEN_WIDTH, 1)];
    lineView4.backgroundColor = [UIColor whiteColor];
    lineView4.alpha = 0.25f;
    [self.view addSubview:lineView4];
    [lineView4 release];
}

- (void)setupSceneView {
    UIView *sceceView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeadViewHeight + 2, SCREEN_WIDTH, 100)];
    [sceceView setBackgroundColor:RGBCOLOR(0xef, 0xef, 0xef)];
    
    UILabel *tips = [[UILabel alloc]init];
    tips.tag = TIPSLABEL_TAG;
    tips.text = @"分享场景:会话";
    tips.textColor = [UIColor blackColor];
    tips.backgroundColor = [UIColor clearColor];
    tips.textAlignment = NSTextAlignmentLeft;
    tips.frame = CGRectMake(10, 5, 200, 40);
    [sceceView addSubview:tips];
    [tips release];
    
    UIButton *btn_x = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn_x setTitle:@"会话" forState:UIControlStateNormal];
    btn_x.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn_x setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_x setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [btn_x setFrame:CGRectMake(20, 50, 80, 40)];
    [btn_x addTarget:self action:@selector(onSelectSessionScene) forControlEvents:UIControlEventTouchUpInside];
    [sceceView addSubview:btn_x];
    
    UIButton *btn_y = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn_y setTitle:@"朋友圈" forState:UIControlStateNormal];
    btn_y.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn_y setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_y setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [btn_y setFrame:CGRectMake(120, 50, 80, 40)];
    [btn_y addTarget:self action:@selector(onSelectTimelineScene) forControlEvents:UIControlEventTouchUpInside];
    [sceceView addSubview:btn_y];
    
    UIButton *btn_z = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn_z setTitle:@"收藏" forState:UIControlStateNormal];
    btn_z.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn_z setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_z setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [btn_z setFrame:CGRectMake(220, 50, 80, 40)];
    [btn_z addTarget:self action:@selector(onSelectFavoriteScene) forControlEvents:UIControlEventTouchUpInside];
    [sceceView addSubview:btn_z];
    
    [self.view addSubview:sceceView];
    [sceceView release];
}

- (void)setupFootView {
    UIScrollView *footView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kHeadViewHeight + 2 + kSceneViewHeight + 2, SCREEN_WIDTH, SCREEN_HEIGHT - kHeadViewHeight - 2 - kSceneViewHeight - 2)];
    [footView setBackgroundColor:RGBCOLOR(0xef, 0xef, 0xef)];
    footView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"发送Text消息给微信" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(10, 10, 145, 40)];
    [btn addTarget:self action:@selector(sendTextContent) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn2 setTitle:@"发送Photo消息给微信" forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 setFrame:CGRectMake(165, 10, 145, 40)];
    [btn2 addTarget:self action:@selector(sendImageContent) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn3 setTitle:@"发送Link消息给微信" forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn3 setFrame:CGRectMake(10, 65, 145, 40)];
    [btn3 addTarget:self action:@selector(sendLinkContent) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn4 setTitle:@"发送Music消息给微信" forState:UIControlStateNormal];
    btn4.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn4 setFrame:CGRectMake(165, 65, 145, 40)];
    [btn4 addTarget:self action:@selector(sendMusicContent) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn4];
    
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn5 setTitle:@"发送Video消息给微信" forState:UIControlStateNormal];
    btn5.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn5 setFrame:CGRectMake(10, 120, 145, 40)];
    [btn5 addTarget:self action:@selector(sendVideoContent) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn5];
    
    UIButton *btn6 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn6 setTitle:@"发送App消息给微信" forState:UIControlStateNormal];
    btn6.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn6 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn6 setFrame:CGRectMake(165, 120, 145, 40)];
    [btn6 addTarget:self action:@selector(sendAppContent) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn6];
    
    UIButton *btn7 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn7 setTitle:@"发送非gif表情给微信" forState:UIControlStateNormal];
    btn7.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn7 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn7 setFrame:CGRectMake(10, 175, 145, 40)];
    [btn7 addTarget:self action:@selector(sendNonGifContent) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn7];
    
    UIButton *btn8 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn8 setTitle:@"发送gif表情给微信" forState:UIControlStateNormal];
    btn8.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn8 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn8 setFrame:CGRectMake(165, 175, 145, 40)];
    [btn8 addTarget:self action:@selector(sendGifContent) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn8];
    
    UIButton *btn9 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn9 setTitle:@"微信授权登录" forState:UIControlStateNormal];
    btn9.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn9 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn9 setFrame:CGRectMake(10, 230, 145, 40)];
    [btn9 addTarget:self action:@selector(sendAuthRequest) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn9];
    
    UIButton *btn10 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn10 setTitle:@"发送文件消息给微信" forState:UIControlStateNormal];
    btn10.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn10 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn10 setFrame:CGRectMake(165, 230, 145, 40)];
    [btn10 addTarget:self action:@selector(sendFileContent) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn10];
    
    UIButton *btn12 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn12 setTitle:@"打开Profile" forState:UIControlStateNormal];
    btn12.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn12 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn12 setFrame:CGRectMake(10, 285, 145, 40)];
    [btn12 addTarget:self action:@selector(openProfile) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn12];
    
    UIButton *btn13 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn13 setTitle:@"打开mp网页" forState:UIControlStateNormal];
    btn13.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn13 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn13 setFrame:CGRectMake(165, 285, 145, 40)];
    [btn13 addTarget:self action:@selector(jumpToBizWebview) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn13];
    
    UIButton *btn14 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn14 setTitle:@"添加单张卡券至卡包" forState:UIControlStateNormal];
    btn14.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn14 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn14 setFrame:CGRectMake(10, 330, 145, 40)];
    [btn14 addTarget:self action:@selector(addCardToWXCardPackage) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn14];
    
    UIButton *btn15 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn15 setTitle:@"添加多张卡券至卡包" forState:UIControlStateNormal];
    btn15.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn15 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn15 setFrame:CGRectMake(165, 330, 145, 40)];
    [btn15 addTarget:self action:@selector(batchAddCardToWXCardPackage) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn15];
    
    UIButton *btn16 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn16 setTitle:@"选择卡券" forState:UIControlStateNormal];
    btn16.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn16 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn16 setFrame:CGRectMake(10, 375, 145, 40)];
    [btn16 addTarget:self action:@selector(chooseCard) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn16];
    
    UIButton *btn17 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn17 setTitle:@"TestAuthSDK" forState:UIControlStateNormal];
    btn17.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn17 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn17 setFrame:CGRectMake(165, 375, 145, 40)];
    [btn17 addTarget:self action:@selector(testAuthSDK) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn17];
    
    UIButton *btn18 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn18 setTitle:@"Open Url" forState:UIControlStateNormal];
    btn18.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn18 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn18 setFrame:CGRectMake(10, 420, 145, 40)];
    [btn18 addTarget:self action:@selector(testOpenUrl) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn18];
    
    [self.view addSubview:footView];
    [footView release];
}

@end
