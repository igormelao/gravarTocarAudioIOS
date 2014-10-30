//
//  ViewController.m
//  GravarTocarAudio
//
//  Created by igormelao on 13/10/14.
//  Copyright (c) 2014 br.com.company. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(IBAction)comecandoMudarTempo:(id)sender
{
    mudandoTempo = YES;
}


//metodo acionado quando o audio executado pelo AVAudioPlayer terminar
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag
{
    [tocador stop];
    tocador = nil;
    
    //deixando os outros botoes inativos
    btnTocarMusicaFundo.enabled = YES;
    btnTocarMusicaFundo.alpha = 1;
    
    btnGravarParar.enabled = YES;
    btnGravarParar.alpha = 1;
    
    btnTocarParar.enabled = YES;
    btnTocarParar.alpha = 1;
    
    //mudar o texto do botao
    [btnTocarParar setTitle:@"Tocar" forState:UIControlStateNormal];
}

-(IBAction)mudaTempo:(id)sender
{
    if(tocador)
    {
        tocador.currentTime = sldTempo.value;
         mudandoTempo = NO;
    }
}

-(IBAction)mudaVolume:(id)sender
{
    if(tocador)
    {
        tocador.volume = sldVolume.value;
    }
}

-(IBAction)gravarParar:(id)sender
{
    if(gravador == nil)
    {
        path = [NSHomeDirectory() stringByAppendingString:@"/Documents/gravacao.wav"];
        
        url = [NSURL fileURLWithPath:path];
        
        gravador = [[AVAudioRecorder alloc]initWithURL:url settings:nil error:nil];
        
        gravador.meteringEnabled = YES;
        
        [gravador prepareToRecord];
        
        [gravador record];
        
        btnTocarParar.enabled = NO;
        btnTocarParar.alpha = 0.4;
        
        btnTocarMusicaFundo.enabled = NO;
        btnTocarMusicaFundo.alpha = 0.4;
        
        [btnGravarParar setTitle:@"Parar" forState:UIControlStateNormal];
        
    }
    else
    {
        [gravador stop];
        
        gravador = nil;
        
        btnTocarParar.enabled = YES;
        btnTocarParar.alpha = 1;
        
        btnTocarMusicaFundo.enabled = YES;
        btnTocarMusicaFundo.alpha = 1;
        
        [btnGravarParar setTitle:@"Gravar" forState:UIControlStateNormal];
    }
}

-(IBAction)tocarParar:(id)sender
{
    if(!tocador)
    {
        path = [NSHomeDirectory() stringByAppendingString:@"/Documents/gravacao.wav"];
        
        url = [NSURL fileURLWithPath:path];
        
        tocador = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        //indicar para o AVAudioPlayer que nossa classe irá tratar os eventos que ocorrer dentro dele
        tocador.delegate = self;
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback
                            error:nil];
        [audioSession setActive:YES error:nil];

        
        //armazenar o inicio da musica no buffer
        [tocador prepareToPlay];
        
        [tocador play];
        
        tocador.meteringEnabled = YES;
        
        sldTempo.maximumValue = tocador.duration;
        
        //deixando os outros botoes inativos
        btnTocarMusicaFundo.enabled = NO;
        btnTocarMusicaFundo.alpha = 0.4;
        
        btnGravarParar.enabled = NO;
        btnGravarParar.alpha = 0.4;
        
        //mudar o texto do botao
        [btnTocarParar setTitle:@"Parar" forState:UIControlStateNormal];
    }
    else
    {
                sldTempo.value = 0;
        [tocador stop];
        tocador = nil;
        
        //deixando os outros botoes inativos
        btnTocarMusicaFundo.enabled = YES;
        btnTocarMusicaFundo.alpha = 1;
        
        btnGravarParar.enabled = YES;
        btnGravarParar.alpha = 1;
        
        //mudar o texto do botao
        [btnTocarParar setTitle:@"Tocar" forState:UIControlStateNormal];
        
    }
}

-(IBAction)tocarMusicaFundo:(id)sender
{
   if(!tocador)
   {
        path = [[NSBundle mainBundle] pathForResource:@"avioes01" ofType:@"mp3"];
        
        url = [NSURL fileURLWithPath:path];
        
        tocador = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
       
        tocador.delegate = self;
       AVAudioSession *audioSession = [AVAudioSession sharedInstance];
       [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
       [audioSession setActive:YES error:nil];
    
        //armazenar o inicio da musica no buffer
        [tocador prepareToPlay];
        
        [tocador play];
    
        tocador.meteringEnabled = YES;
    
        sldTempo.maximumValue = tocador.duration;

    //deixando os outros botoes inativos
    btnTocarParar.enabled = NO;
    btnTocarParar.alpha = 0.4;
    
    btnGravarParar.enabled = NO;
    btnGravarParar.alpha = 0.4;
    
    //mudar o texto do botao
    [btnTocarMusicaFundo setTitle:@"Parar música fundo" forState:UIControlStateNormal];
   }
    else
    {
        sldTempo.value = 0;
        [tocador stop];
        tocador = nil;
        
        //deixando os outros botoes inativos
        btnTocarParar.enabled = YES;
        btnTocarParar.alpha = 1;
        
        btnGravarParar.enabled = YES;
        btnGravarParar.alpha = 1;
        
        //mudar o texto do botao
        [btnTocarMusicaFundo setTitle:@"Tocar música fundo" forState:UIControlStateNormal];

    }
}

-(void)animarSpeakerComLevel:(float)level
{
    [UIView animateWithDuration:0.5 animations:^{
        
        imgvSpeaker.center = CGPointMake(160, 154);
        
        imgvSpeaker.frame = CGRectMake(imgvSpeaker.frame.origin.x, imgvSpeaker.frame.origin.y, level, level);
    }];
}

-(void)atualizarInterface
{
    if(!mudandoTempo)
    {
        sldTempo.value = tocador.currentTime;
    }
    
    float level;
    
    if(tocador.playing)
    {
        //atualiza o buffer paralelo para tirar uma média da pontência
        [tocador updateMeters];
        
        level = ([tocador averagePowerForChannel:0] + 160) * 1.4;
    }
    else if(gravador.recording)
    {
        [gravador updateMeters];
        
        level = ([gravador averagePowerForChannel:0] + 160) * 1.4;
    }
    else
    {
        level = 160;
        imgvSpeaker.frame = CGRectMake(80, 74, 160, 160);
    }
    
    [self animarSpeakerComLevel:level];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(atualizarInterface) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
