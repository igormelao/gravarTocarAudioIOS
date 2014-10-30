//
//  ViewController.h
//  GravarTocarAudio
//
//  Created by igormelao on 13/10/14.
//  Copyright (c) 2014 br.com.company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ViewController : UIViewController <AVAudioPlayerDelegate>
{
    IBOutlet UIButton *btnGravarParar, *btnTocarParar, *btnTocarMusicaFundo;
    
    IBOutlet UIImageView *imgvSpeaker;
    
    
    AVAudioPlayer *tocador;
    
    AVAudioRecorder *gravador;
    
    NSString *path;
    NSURL *url;
    
    IBOutlet UISlider *sldTempo, *sldVolume;
    
    BOOL mudandoTempo;
    
}

-(IBAction)comecandoMudarTempo:(id)sender;

-(IBAction)mudaTempo:(id)sender;

-(IBAction)mudaVolume:(id)sender;

-(IBAction)gravarParar:(id)sender;

-(IBAction)tocarParar:(id)sender;

-(IBAction)tocarMusicaFundo:(id)sender;

-(void)animarSpeakerComLevel:(float)level;

-(void)atualizarInterface;

@end

