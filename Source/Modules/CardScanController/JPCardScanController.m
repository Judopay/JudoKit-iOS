//
//  JPCardScanController.m
//  JudoKit_iOS
//
//  Copyright (c) 2020 Alternative Payments Ltd
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "JPCardScanController.h"
#import "JPCardNetwork.h"
#import "JPCardScanPreviewLayer.h"
#import "JPCardScanView.h"
#import "NSString+Additions.h"
#import <Vision/Vision.h>

API_AVAILABLE(ios(13.0))
@interface JPCardScanController ()

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDevice *captureDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput;
@property (nonatomic, strong) JPCardScanPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic, strong) JPCardScanView *cardScanView;
@property (nonatomic, strong) VNSequenceRequestHandler *requestHandler;
@property (nonatomic, strong) VNRectangleObservation *rectangleObservation;

@property (nonatomic, strong) NSString *detectedCardNumber;
@property (nonatomic, strong) NSString *detectedExpiryDate;

@end

API_AVAILABLE(ios(13.0))
@implementation JPCardScanController

#pragma mark - Constants

static const CGFloat kScanAreaStartX = 0.0f;
static const CGFloat kScanAreaStartY = 0.3f;
static const CGFloat kScanAreaEndX = 1.0f;
static const CGFloat kScanAreaEndY = 0.4f;
static const CGFloat kCardAspectRatio = 0.682f;
static const CGFloat kMinCardErrorMargin = 0.8f;
static const CGFloat kMaxCardErrorMargin = 1.2f;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareCamera];
    [self setupActions];
    [self.view addSubview:self.cardScanView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.captureSession startRunning];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.captureSession stopRunning];
    [super viewDidDisappear:animated];
}

#pragma mark - User actions

- (void)didTapBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didTapFlashButton {
    AVCaptureTorchMode torchMode = [self.captureDevice isTorchActive] ? AVCaptureTorchModeOff : AVCaptureTorchModeOn;
    if ([self.captureDevice lockForConfiguration:nil]) {
        [self.captureDevice setTorchMode:torchMode];
    }
}

#pragma mark - Setup

- (void)prepareCamera {
    [self.captureSession addInput:self.captureDeviceInput];
    [self.captureSession addOutput:self.videoOutput];
    [self.view.layer addSublayer:self.previewLayer];
    [[self.videoOutput connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:AVCaptureVideoOrientationPortrait];
}

- (void)setupActions {
    [self.cardScanView.backButton addTarget:self
                                     action:@selector(didTapBackButton)
                           forControlEvents:UIControlEventTouchDown];

    [self.cardScanView.flashButton addTarget:self
                                      action:@selector(didTapFlashButton)
                            forControlEvents:UIControlEventTouchDown];
}

#pragma mark - Layout changes

- (void)shouldDisplayCardOverlay:(BOOL)shouldDisplay {
    self.cardScanView.cardTextStackView.hidden = !shouldDisplay;
    self.previewLayer.shouldDimCardBackground = shouldDisplay;
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)output
    didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
           fromConnection:(AVCaptureConnection *)connection {

    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    [self detectRectangleInPixelBuffer:pixelBuffer];
}

#pragma mark - Rectangle detection

- (void)detectRectangleInPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    if (self.rectangleObservation) {
        [self handleObservedPaymentCard:self.rectangleObservation inBuffer:pixelBuffer];
    } else {
        self.rectangleObservation = [self detectPaymentCardForBuffer:pixelBuffer];
    }
}

- (VNRectangleObservation *)detectPaymentCardForBuffer:(CVPixelBufferRef)pixelBuffer {

    VNDetectRectanglesRequest *rectRequest = [VNDetectRectanglesRequest new];
    rectRequest.regionOfInterest = CGRectMake(kScanAreaStartX,
                                              kScanAreaStartY,
                                              kScanAreaEndX,
                                              kScanAreaEndY);

    CGFloat cardAspectRatio = kCardAspectRatio;

    rectRequest.minimumAspectRatio = cardAspectRatio * kMinCardErrorMargin;
    rectRequest.maximumAspectRatio = cardAspectRatio * kMaxCardErrorMargin;

    VNDetectTextRectanglesRequest *textRequest = [VNDetectTextRectanglesRequest new];

    [self.requestHandler performRequests:@[ rectRequest, textRequest ]
                         onCVPixelBuffer:pixelBuffer
                                   error:nil];

    VNRectangleObservation *rectangleObservation;
    VNTextObservation *textObservation;

    for (VNObservation *observation in rectRequest.results) {
        if ([observation isKindOfClass:VNRectangleObservation.class]) {
            rectangleObservation = (VNRectangleObservation *)observation;
            break;
        }
    }

    for (VNObservation *observation in textRequest.results) {
        if ([observation isKindOfClass:VNTextObservation.class]) {
            textObservation = (VNTextObservation *)observation;
            break;
        }
    }

    BOOL isRectangleOverlapping = CGRectContainsRect(rectangleObservation.boundingBox, textObservation.boundingBox);
    if (rectangleObservation && textObservation && isRectangleOverlapping) {
        return rectangleObservation;
    }

    return nil;
}

- (void)handleObservedPaymentCard:(VNRectangleObservation *)observation
                         inBuffer:(CVImageBufferRef)imageBuffer {

    VNRectangleObservation *trackedRect = [self trackPaymentCard:observation inBuffer:imageBuffer];

    if (trackedRect) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self shouldDisplayCardOverlay:NO];
        });
        [self extractCardNumberFromImageBuffer:imageBuffer];
    }
}

- (VNRectangleObservation *)trackPaymentCard:(VNRectangleObservation *)observation
                                    inBuffer:(CVImageBufferRef)imageBuffer {

    VNTrackRectangleRequest *trackRequest = [[VNTrackRectangleRequest alloc] initWithRectangleObservation:observation];
    trackRequest.trackingLevel = VNRequestTrackingLevelFast;

    [self.requestHandler performRequests:@[ trackRequest ] onCVPixelBuffer:imageBuffer error:nil];

    for (VNObservation *observation in trackRequest.results) {
        if ([observation isKindOfClass:VNRectangleObservation.class]) {
            return (VNRectangleObservation *)observation;
        }
    }
    self.rectangleObservation = nil;
    return nil;
}

#pragma mark - Text detection

- (void)extractCardNumberFromImageBuffer:(CVImageBufferRef)imageBuffer {

    CIImage *image = [[CIImage alloc] initWithCVImageBuffer:imageBuffer];

    VNRecognizeTextRequest *textRequest = [VNRecognizeTextRequest new];
    textRequest.recognitionLevel = VNRequestTextRecognitionLevelAccurate;

    if (!textRequest) {
        return;
    }
    
    NSArray<VNRequest *> *textRequests = @[ textRequest ];
    VNImageRequestHandler *requestHandler = [[VNImageRequestHandler alloc] initWithCIImage:image options:@{}];
    [requestHandler performRequests:textRequests error:nil];

    for (VNObservation *observation in textRequest.results) {

        if ([observation isKindOfClass:VNRecognizedTextObservation.class]) {

            VNRecognizedTextObservation *textObservation = (VNRecognizedTextObservation *)observation;
            NSArray<VNRecognizedText *> *recognizedText = [textObservation topCandidates:1];

            for (VNRecognizedText *text in recognizedText) {
                [self handleTextDetection:text.string];
            }
        }
    }
}

- (void)handleTextDetection:(NSString *)detectedText {
    NSString *compactText = [detectedText _jp_stringByRemovingWhitespaces];

    if (compactText._jp_isExpiryDate) {
        self.detectedExpiryDate = [detectedText _jp_sanitizedExpiryDate];
    }

    JPCardNetworkType cardNetwork = [JPCardNetwork cardNetworkForCardNumber:compactText];

    BOOL isNumeric = compactText._jp_isNumeric;
    BOOL isAmex = cardNetwork == JPCardNetworkTypeAMEX;
    BOOL isCorrectLength = isAmex ? compactText.length == 15 : compactText.length == 16;
    BOOL isValid = compactText._jp_isValidCardNumber;

    if (isNumeric && isCorrectLength && isValid) {
        self.detectedCardNumber = detectedText;
    };

    if (self.detectedCardNumber && (self.detectedExpiryDate || isAmex)) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.delegate cardScanController:self
                          didDetectCardNumber:self.detectedCardNumber
                            andExpirationDate:self.detectedExpiryDate];
        });
    }
}

#pragma mark - Lazy initialization

- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        _captureSession = [AVCaptureSession new];
        _captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    }
    return _captureSession;
}

- (JPCardScanPreviewLayer *)previewLayer {
    if (!_previewLayer) {
        _previewLayer = [JPCardScanPreviewLayer layerWithSession:self.captureSession];
        [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [_previewLayer setFrame:self.view.bounds];
        [_previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
    return _previewLayer;
}

- (AVCaptureVideoDataOutput *)videoOutput {
    if (!_videoOutput) {
        _videoOutput = [AVCaptureVideoDataOutput new];
        [_videoOutput setSampleBufferDelegate:self queue:dispatch_queue_create("scan_card_output", nil)];

        NSDictionary *videoSettingsDictionary = @{
            (id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA),
        };

        [_videoOutput setVideoSettings:videoSettingsDictionary];
    }
    return _videoOutput;
}

- (AVCaptureDevice *)captureDevice {
    if (!_captureDevice) {
        _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _captureDevice;
}

- (AVCaptureDeviceInput *)captureDeviceInput {
    if (!_captureDeviceInput) {
        _captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice
                                                                    error:nil];
    }
    return _captureDeviceInput;
}

- (JPCardScanView *)cardScanView {
    if (!_cardScanView) {
        _cardScanView = [JPCardScanView new];
        [_cardScanView setFrame:self.view.frame];
    }
    return _cardScanView;
}

- (VNSequenceRequestHandler *)requestHandler {
    if (!_requestHandler) {
        _requestHandler = [VNSequenceRequestHandler new];
    }
    return _requestHandler;
}

@end
