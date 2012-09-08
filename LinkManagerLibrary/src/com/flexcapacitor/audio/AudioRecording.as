




package com.flexcapacitor.audio {
    import com.flexcapacitor.utils.ApplicationUtils;

    import flash.display.Sprite;
    import flash.events.ActivityEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.events.SampleDataEvent;
    import flash.events.StatusEvent;
    import flash.media.Microphone;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundCodec;
    import flash.media.SoundMixer;
    import flash.media.SoundTransform;
    import flash.net.FileReference;
    import flash.system.Security;
    import flash.system.SecurityPanel;
    import flash.utils.ByteArray;
    import flash.utils.getTimer;

    import mx.controls.Alert;
    import mx.core.Application;
    import mx.core.UIComponent;
    import mx.events.CloseEvent;
    import mx.events.FlexEvent;
    import mx.managers.SystemManager;


    /**
     *
     * @author monkeypunch
     */
    /**
     *
     * @author monkeypunch
     */
    /**
     *
     * @author monkeypunch
     */
    public class AudioRecording extends EventDispatcher {

        /**
         * 
         * @default 
         */
        public const MUTE:int = 100;

        /**
         * 
         * @default 
         */
        public const SPEEX:String = SoundCodec.SPEEX;

        /**
         * 
         * @default 
         */
        public const NELLYMOSER:String = SoundCodec.NELLYMOSER;

        /**
         * 
         * @default 
         */
        public const NELLYMOSER_QUALITY:Array = [ 2048, (1024 * 3), (1024 * 4), (1024 * 5), (1024 * 6), (1024 * 7), 8192 ];

        /**
         * 
         * @default 
         */
        public const CHANNEL_LENGTH:int = 256;

        /**
         * 
         * @default 
         */
        public var WIDTH_FACTOR:Number = 0;

        /**
         * 
         * @default 
         */
        public var PLOT_HEIGHT:int = 0;

        [Bindable]
        /**
         * 
         * @default 
         */
        public var audio:ByteArray = new ByteArray();

        [Bindable]
        /**
         * 
         * @default 
         */
        public var audioLength:int = 0;

        [Bindable]
        /**
         * 
         * @default 
         */
        public var audioCompressedLength:int = 0;

        [Bindable]
        /**
         * 
         * @default 
         */
        public var isMicrophoneAvailable:Boolean = false;

        [Bindable]
        /**
         * 
         * @default 
         */
        public var microphone:Microphone;

        [Bindable]
        /**
         * 
         * @default 
         */
        public var isRecording:Boolean = false;

        [Bindable]
        /**
         * 
         * @default 
         */
        public var isPlaying:Boolean = false;

        [Bindable]
        /**
         * 
         * @default 
         */
        public var volume:int = 100;

        [Bindable]
        /**
         * 
         * @default 
         */
        public var range:int = 20;

        [Bindable]
        /**
         * 
         * @default 
         */
        public var recordingTime:Number = 0.0;

        [Bindable]
        /**
         * 
         * @default 
         */
        public var playbackTime:Number = 0.0;

        [Bindable]
        /**
         * 
         * @default 
         */
        public var statusCode:String = "";

        [Bindable]
        /**
         * 
         * @default 
         */
        public var statusMessageLevel:String = "";

        [Bindable]
        /**
         * 
         * @default 
         */
        public var mutedSilenceLevel:uint = 0;

        [Bindable]
        /**
         * 
         * @default 
         */
        public var microphoneMuted:Boolean = false;

        [Bindable]
        /**
         * 
         * @default 
         */
        public var microphoneEnabled:Boolean = false;

        [Bindable]
        /**
         * 
         * @default 
         */
        public var microphoneEncodeQuality:int = 6;

        [Bindable]
        /**
         * 
         * @default 
         */
        public var microphoneSampleRate:int = 44;

        [Bindable]
        /**
         * 
         * @default 
         */
        public var microphoneGain:uint = 0;

        [Bindable]
        /**
         * 
         * @default 
         */
        public var hasData:Boolean = false;

        [Bindable]
        /**
         * 
         * @default 
         */
        public var paused:Boolean = false;

        [Bindable]
        /**
         * 
         * @default 
         */
        public var codecs:Array = [ SPEEX, NELLYMOSER ];

        [Bindable]
        [Inspectable(enumeration="5, 8, 11, 16, 22, 44")]
        /**
         * 
         * @default 
         */
        public var rates:Array = [ 5, 8, 11, 16, 22, 44 ];

        [Bindable]
        /**
         * 
         * @default 
         */
        public var leftPeak:Number = 0;

        [Bindable]
        /**
         * 
         * @default 
         */
        public var rightPeak:Number = 0;

        [Bindable]
        /**
         * 
         * @default 
         */
        public var enableEffectDriver:Boolean = true;

        [Bindable]
        /**
         * 
         * @default 
         */
        public var activating:Boolean = false;

        [Bindable]
        private var sound:Sound;

        [Bindable]
        private var channel:SoundChannel;

        [Bindable]
        /**
         * 
         * @default 
         */
        public var effectDriver:EffectDriver;

        [Bindable]
        /**
         * 
         * @default 
         */
        public var latency:Number = 0;

        [Bindable]
        /**
         * 
         * @default 
         */
        public var activityLevel:int = 0;

        [Bindable]
        /**
         * 
         * @default 
         */
        public var framesPerPacket:int = 0;


        /**
         * 
         * @default 
         */
        public var recordedData:ByteArray = new ByteArray();

        /**
         * 
         * @default 
         */
        public var currentBufferingData:ByteArray = new ByteArray();

        private var bytes:ByteArray = new ByteArray();

        private var isLocked:Boolean = false;

        private var bufferIndex:int = 0;

        private var startRecording:Number = 0;

        private var displayedPrivacySettings:Boolean = false;

        private var displayedMicrophoneSettings:Boolean = false;

        private var outputFile:ByteArray = new ByteArray();

        /**
         * 
         * @default 
         */
        public var spectrum:UIComponent = new UIComponent();

        /**
         *
         * @param target
         */
        public function AudioRecording(target:IEventDispatcher = null) {

            super(target);
            var app:Object;

            if (microphone == null) {
                microphone = Microphone.getMicrophone();
            }
            updateMicrophoneBindings();

            if (effectDriver == null) {
                effectDriver = new EffectDriver();
            }

            spectrum.x = 20;
            spectrum.y = 200;

            if (ApplicationUtils.getInstance() != null) {
                ApplicationUtils.getInstance().addEventListener(FlexEvent.APPLICATION_COMPLETE, applicationComplete);
            }
            //addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

        private var _microphoneName:String = "";

        [Bindable]
        /**
         * 
         * @return 
         */
        public function get microphoneName():String {
            if (microphone)
                return microphone.name;
            return _microphoneName;
        }

        /**
         * 
         * @param value
         */
        public function set microphoneName(value:String):void {

            // it may be that you cannot change the microphone on the same microphone instance after recording
            if (_microphoneName == value) {
                return;
            }
            else {
                _microphoneName = value;
                for (var i:int = 0; i < Microphone.names.length; i++) {
                    if (Microphone.names[i] == value) {
                        microphone = Microphone.getMicrophone(i);
                    }
                }
                updateMicrophoneProperties();
                updateMicrophoneBindings();
            }
        }

        private var _noiseSuppressionLevel:int = -30;

        [Bindable]
        /**
         * 
         * @return 
         */
        public function get noiseSuppressionLevel():int {
            if (microphone && microphone.hasOwnProperty("noiseSuppressionLevel"))
                return microphone["noiseSuppressionLevel"];
            return _noiseSuppressionLevel;
        }

        /**
         * 
         * @param value
         */
        public function set noiseSuppressionLevel(value:int):void {
            _noiseSuppressionLevel = value;
            if (microphone && microphone.hasOwnProperty("noiseSuppressionLevel"))
                microphone["noiseSuppressionLevel"] = value;
        }

        private var _loopback:Boolean = false;

        [Bindable]
        /**
         * 
         * @return 
         */
        public function get loopback():Boolean {
            return _loopback;
        }

        /**
         * 
         * @param value
         */
        public function set loopback(value:Boolean):void {
            _loopback = value;
            if (microphone)
                microphone.setLoopBack(value);
        }

        private var _enableVAD:Boolean = false;

        [Bindable]
        /**
         * 
         * @return 
         */
        public function get enableVAD():Boolean {
            if (microphone && microphone.hasOwnProperty("enableVAD"))
                return microphone["enableVAD"];
            return _enableVAD;
        }

        /**
         * 
         * @param value
         */
        public function set enableVAD(value:Boolean):void {
            _enableVAD = value;
            if (microphone && microphone.hasOwnProperty("enableVAD")) {
                microphone["enableVAD"] = value;
            }
        }

        private var _nellyMoserEncodingQuality:int = 2048;

        [Bindable]
        /**
         * 
         * @return 
         */
        public function get nellyMoserEncodingQuality():int {
            //if (microphone) return microphone;
            return _nellyMoserEncodingQuality;
        }

        /**
         * 
         * @param value
         */
        public function set nellyMoserEncodingQuality(value:int):void {
            _nellyMoserEncodingQuality = value;
        }

        private var _soundTransform:SoundTransform;

        [Bindable]
        /**
         * 
         * @return 
         */
        public function get soundTransform():SoundTransform {
            if (microphone)
                return microphone.soundTransform;
            return null;
        }

        /**
         * 
         * @param value
         */
        public function set soundTransform(value:SoundTransform):void {
            _soundTransform = value;
            if (microphone)
                microphone.soundTransform = value;
        }

        private var _gain:int = 80;

        [Bindable]
        /**
         * 
         * @return 
         */
        public function get gain():int {
            if (microphone)
                return microphone.gain;
            return _gain;
        }

        /**
         * 
         * @param value
         */
        public function set gain(value:int):void {
            _gain = value;
            if (microphone)
                microphone.gain = value;
        }

        private var _silenceLevelTimeout:uint = 1000;

        [Bindable]
        /**
         * 
         * @return 
         */
        public function get silenceLevelTimeout():uint {
            if (microphone)
                return microphone.silenceTimeout;
            return _silenceLevelTimeout;
        }

        /**
         * 
         * @param value
         */
        public function set silenceLevelTimeout(value:uint):void {
            _silenceLevelTimeout = value;
            if (microphone)
                microphone.setSilenceLevel(_silenceLevel, value);
        }

        private var _silenceLevel:uint = 0;

        [Bindable]
        /**
         * 
         * @return 
         */
        public function get silenceLevel():uint {
            if (microphone)
                return microphone.silenceLevel;
            return _silenceLevel;
        }

        /**
         * 
         * @param value
         */
        public function set silenceLevel(value:uint):void {
            _silenceLevel = value;
            if (microphone)
                microphone.setSilenceLevel(value, _silenceLevelTimeout);
        }

        [Bindable]
        /**
         * 
         * @default 
         */
        public var microphoneCodec:String = _codec;

        private var _codec:String = NELLYMOSER;

        private var hasCodecChanged:Boolean = false;

        [Bindable]
        /**
         * 
         * @return 
         */
        public function get codec():String {
            if (microphone)
                return microphone.codec;
            return _codec;
        }

        /**
         * 
         * @param value
         */
        public function set codec(value:String):void {

            // it may be that you cannot change the encoder on the same microphone instance after recording
            if (value == _codec) {
                return;
            }
            else {
                _codec = value;
                microphone = null;
                microphone = Microphone.getMicrophone();
                microphone.codec = value;
                updateMicrophoneProperties();
                updateMicrophoneBindings();
            }
        }

        private var _rate:Number = 44;

        [Bindable]
        /**
         * 
         * @return 
         */
        public function get rate():Number {
            if (microphone) {
                var micRate:int = microphone.rate;
                return micRate;
            }
            return _rate;
        }

        /**
         * 
         * @param value
         */
        public function set rate(value:Number):void {
            _rate = value;
            if (microphone) {
                microphone.rate = value;
                microphoneSampleRate = microphone.rate;
            }
        }

        /**
         * 
         * @param actualRate
         * @return 
         */
        public function getRate(actualRate:Boolean = true):int {

            if (microphone) {
                var micRate:int = microphone.rate;
                if (actualRate) {
                    if (micRate == 44) {
                        micRate = 44100;
                    }
                    else if (micRate == 22) {
                        micRate = 22050;
                    }
                    else if (micRate == 16) {
                        micRate = 16000;
                    }
                    else if (micRate == 11) {
                        micRate = 11025;
                    }
                    else if (micRate == 8) {
                        micRate = 8000;
                    }
                    else if (micRate == 5) {
                        micRate = 5512;
                    }
                }
                return micRate;
            }
            return _rate;
        }
		
		private var _speed:int = 0;
		
		[Bindable]
		/**
		 * 
		 * @return 
		 */
		public function get speed():int {
			return _speed;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set speed(value:int):void {
			_speed = value;
		}
		
		private var _totalTime:int = 0;
		
		[Bindable]
		/**
		 * 
		 * @return 
		 */
		public function get totalTime():Number {
			
			return _totalTime;Math.floor(currentBufferingData.position / getRate() * 10) / 10;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set totalTime(value:Number):void {
			_totalTime = value;
		}

        private var _encodeQuality:int = 6;

        [Bindable]
        /**
         * 
         * @return 
         */
        public function get encodeQuality():int {
            if (microphone)
                return microphone.encodeQuality;
            return _encodeQuality;
        }

        /**
         * 
         * @param value
         */
        public function set encodeQuality(value:int):void {
            _encodeQuality = value;
            if (microphone) {
                microphone.encodeQuality = value;
                microphoneEncodeQuality = microphone.encodeQuality;
            }
        }

        private var _useEchoSuppression:Boolean = false;

        [Bindable]
        /**
         * 
         * @return 
         */
        public function get useEchoSuppression():Boolean {
            if (microphone)
                return microphone.useEchoSuppression;
            return _useEchoSuppression;
        }

        /**
         * 
         * @param value
         */
        public function set useEchoSuppression(value:Boolean):void {
            _useEchoSuppression = value;
            if (microphone) {
                microphone.setUseEchoSuppression(value);
            }
        }

        private var _clips:Array;

        [Bindable]
        /**
         * 
         * @return 
         */
        public function get clips():Array {
            return _clips;
        }

        /**
         * 
         * @param value
         */
        public function set clips(value:Array):void {
            _clips = value;
        }

        /**
         * 
         * @param event
         */
        public function applicationComplete(event:FlexEvent):void {
            spectrum.width = 500;
            spectrum.height = 300;

            event.currentTarget.addElement(spectrum);
        }


        /**
         * 
         */
        public function record():void {

            if (!hasEventListener(Event.ENTER_FRAME)) {
                //addEventListener(Event.ENTER_FRAME, onEnterFrame);
            }

            if (microphone == null) {
                Alert.show("Microphone is not found on your computer. Please attach one and then restart this application.");
                return;
            }

            if (microphone.muted) {
                enableMicrophone();
                return;
            }

            if (isRecording || isPlaying) {
                stop();
            }

            bufferIndex = 0;
            startRecording = getTimer() + 500;
            currentBufferingData = new ByteArray();
            recordedData = new ByteArray();
            audioLength = 0;
            isRecording = true;
            paused = false;
            recordingTime = 0;
            microphoneMuted = false;
            playbackTime = 0;

            //microphone = null;
            if (hasCodecChanged) {
                microphone = Microphone.getMicrophone();
                hasCodecChanged = false;
            }

            updateMicrophoneProperties();

            microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, sampleDataHandler);
            microphone.addEventListener(ActivityEvent.ACTIVITY, activityHandler);

            updateMicrophoneBindings();
        }

        /**
         * 
         */
        public function pause():void {
            paused = true;
        }

        /**
         * 
         */
        public function resume():void {
            paused = false;
        }

        /**
         * 
         */
        public function stop():void {

            if (!microphone) {
                return;
            }

            // recording
            if (currentBufferingData.length > 0) {
                hasData = true;
                //recordedData = currentBufferingData;
				//totalTime = Math.floor(currentBufferingData.position / RECORDED_SAMPLE_RATE * 10) / 10;
            }
            else {
                hasData = false;
            }

            // playback
            if (channel) {
                channel.stop();
            }

            spectrum.graphics.clear();

            microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, sampleDataHandler);
            microphone.removeEventListener(ActivityEvent.ACTIVITY, activityHandler);

            isRecording = false;
            isPlaying = false;
            activating = false;
        }

        /**
         * 
         * @param soundByteArray
         * @param sampleRate
         */
        public function playSound(soundByteArray:ByteArray, sampleRate:int = 44100):void {
            if (soundByteArray != null && soundByteArray.length > 0) {
                currentBufferingData.position = 0;
                currentBufferingData.readBytes(soundByteArray, 0, currentBufferingData.length);

                sound = new Sound();

                sound.addEventListener(SampleDataEvent.SAMPLE_DATA, playHandler);

                channel = sound.play();

                channel.addEventListener(Event.SOUND_COMPLETE, onPlaybackComplete);
            }
        }

        /**
         * 
         */
        public function play():void {

            currentBufferingData.position = 0;
            recordedData.clear();
            currentBufferingData.readBytes(recordedData, 0, currentBufferingData.length);

            /*

               if (!hasEventListener(Event.ENTER_FRAME)) {
               addEventListener(Event.ENTER_FRAME, onEnterFrame);
             }*/

            currentBufferingData.position = 0;
            recordedData.position = 0;

            sound = new Sound();

            sound.addEventListener(SampleDataEvent.SAMPLE_DATA, playHandler);

            channel = sound.play();

            channel.addEventListener(Event.SOUND_COMPLETE, onPlaybackComplete);
        }

        /**
         * 
         */
        public function muteToggle():void {

            // if playing audio we should set the volume to zero
            if (isPlaying) {
                // todo: set volume to zero or restore it
                return
            }

            // effectively turns off the microphone during recording
            // mic is muted - unmute
            if (microphone && microphone.silenceLevel == MUTE) {
                microphone.setSilenceLevel(mutedSilenceLevel, silenceLevelTimeout);
                microphoneMuted = false;
            }
            else if (microphone) {
                mutedSilenceLevel = microphone.silenceLevel;
                microphone.setSilenceLevel(MUTE, silenceLevelTimeout);
                microphoneMuted = true;
            }

        }

        /**
         * 
         */
        public function mute():void {

            if (microphone) {
                mutedSilenceLevel = microphone.silenceLevel;
                microphone.setSilenceLevel(MUTE, silenceLevelTimeout);
            }
            microphoneMuted = true;
        }

        /**
         * 
         */
        public function unMute():void {

            if (microphone && microphone.silenceLevel == MUTE) {
                microphone.setSilenceLevel(mutedSilenceLevel, silenceLevelTimeout);
            }
            microphoneMuted = false;
        }

        /**
         * 
         * @param fileName
         * @param sampleRate
         * @param format
         */
        public function save(fileName:String = "sound.wav", sampleRate:int = 44100, format:String = "wave"):void {
            //var outputFile:File = File.desktopDirectory.resolvePath("recording.wav"); 
            //var outputStream:FileStream = new FileStream();

            var wavWriter:WAVWriter = new WAVWriter();
            var waveFile:ByteArray = new ByteArray();
            currentBufferingData.position = 0; // rewind to the beginning of the sample 

            wavWriter.numOfChannels = 1; // set the inital properties of the Wave Writer 
            wavWriter.sampleBitRate = 16;
            wavWriter.samplingRate = sampleRate;

            wavWriter.processSamples(waveFile, currentBufferingData, sampleRate, 1); // convert our ByteArray to a WAV file.

            outputFile = waveFile;
            var file:FileReference = new FileReference();
            file.save(outputFile, fileName);

            //return waveFile;
            //outputStream.open(outputFile, FileMode.WRITE);  //write out our file to disk. 
            //outputStream.close();
        }

        /**
         * 
         * @param fileName
         * @param sampleRate
         * @param format
         */
        public function saveAndCompress(fileName:String = "sound.wav", sampleRate:int = 44100, format:String = "wave"):void {
            //var outputFile:File = File.desktopDirectory.resolvePath("recording.wav"); 
            //var outputStream:FileStream = new FileStream();

            var wavWriter:WAVWriter = new WAVWriter();
            var waveFile:ByteArray = new ByteArray();
            currentBufferingData.position = 0; // rewind to the beginning of the sample 

            wavWriter.numOfChannels = 1; // set the inital properties of the Wave Writer 
            wavWriter.sampleBitRate = 16;
            wavWriter.samplingRate = sampleRate;
            trace("before ", waveFile.length / 1024);

            wavWriter.processSamples(waveFile, currentBufferingData, sampleRate, 1); // convert our ByteArray to a WAV file.

            outputFile = waveFile;
            trace("before compressed ", outputFile.length / 1024);
            outputFile.compress();
            audioCompressedLength = outputFile.length / 1024;
            trace("after ", outputFile.length / 1024);
            var file:FileReference = new FileReference();
            file.save(outputFile, fileName);

            //return waveFile;
            //outputStream.open(outputFile, FileMode.WRITE);  //write out our file to disk. 
            //outputStream.close();
        }

        private function sampleDataHandler(event:SampleDataEvent):void {
            var isWritten:Boolean = false;

            if (paused)
                return;

            var sampleRate:int = getRate();

            // Lock ByteArray to not read/write over eachother
            while (!isWritten) {


                if (!isLocked) {

                    // what the fuck does this do???
                    /*
                       if (event.position*4 != currentBufferingData.position) {
                       var wlen:int = ((event.position*4)-currentBufferingData.position)/4;
                       for (var i:int = 0;i<wlen;i++)
                       currentBufferingData.writeFloat(0);
                     }*/

                    // get length of recording
                    audioLength = currentBufferingData.length / 1024;

                    // save audio data
                    currentBufferingData.writeBytes(event.data);

                    // get recording time in seconds
					
                    recordingTime = Math.floor(event.position / sampleRate * 10) / 10;
					totalTime = recordingTime;
					playbackTime = recordingTime;

                    isWritten = true;
                }
            }
        }

        /**
         * 
         * @param event
         */
        public function activityHandler(event:ActivityEvent):void {
            activating = event.activating;
        }

        private function playHandler(event:SampleDataEvent):void {
            if (!currentBufferingData.bytesAvailable > 0) {
                return;
			}
            var sampleRate:int = getRate(); //(rate==44) ? 44100 : rate*1000;
            var sampleSize:int = 8192;
            var sample:Number = 0;

            if (channel) {
                latency = Number(((event.position / sampleRate) - channel.position).toFixed(0));
            }

            // may not actually be "encoding quality" seems like 
            sampleSize = int(nellyMoserEncodingQuality); // Change to between 2048 and 8192		

            for (var i:int = 0; i < sampleSize; i++) {

                if (currentBufferingData.bytesAvailable > 0) {

                    // enable effect driver
                    if (enableEffectDriver) {
                        effectDriver.volume = volume;
                        effectDriver.speed = speed;
                        effectDriver.range = range;
                        sample = effectDriver.processEffect(currentBufferingData);
                    }
                    else {
                        sample = currentBufferingData.readFloat();
                    }
                }

                event.data.writeFloat(sample);
                event.data.writeFloat(sample);
            }

            //playbackTime = Number((event.position/sampleRate).toFixed(1));

            if (channel) {
                leftPeak = Number(channel.leftPeak.toFixed(1));
                rightPeak = Number(channel.rightPeak.toFixed(1));
				//playbackTime = Math.floor(channel.position / sampleRate * 10) / 10;
                playbackTime = Number((channel.position / 1000).toFixed(1));
            }

			// this is using processing power - we need to refactor at some point
            SoundMixer.computeSpectrum(bytes, false, 0);
            visualize(bytes);
        }

        /**
         * 
         * @param event
         */
        public function onEnterFrame(event:Event):void {
            var rate:Number = 44.1;

            bytes.clear();
            if (isRecording) {
                var currentTime:Number = getTimer() - startRecording;

                if (currentTime <= 0) {
                    trace("enterframe 1");
                    while (bytes.length < 256 * 4) {
                        bytes.writeFloat(0);
                    }
                    bytes.position = 0;
                }
                else {
                    trace("enterframe 2");
                    //recordingTime = Number(((currentTime-450)/1000).toFixed(1));

                    isLocked = true;
                    var curPos:int = currentBufferingData.position;
                    bufferIndex = int((currentTime * rate) * 4); // Sample position * float size
                    bufferIndex = (bufferIndex - (bufferIndex % 4)); // Make it even so it reads Floats in the right place
                    currentBufferingData.position = bufferIndex;
                    var chunkMin:Number = Math.min(256 * 4, currentBufferingData.bytesAvailable);
                    currentBufferingData.readBytes(bytes, 0, chunkMin);
                    while (bytes.length < 256 * 4) {
                        bytes.writeFloat(0);
                    }
                    bytes.position = 0;
                    currentBufferingData.position = curPos;
                    isLocked = false;
                }
            }
            else {
                //drawPlayhead();
            }
            if (PLOT_HEIGHT == 0) {
                //PLOT_HEIGHT = spectrum.height/2;
            }

            if (WIDTH_FACTOR == 0) {
                //WIDTH_FACTOR = spectrum.width/CHANNEL_LENGTH;
            }
            SoundMixer.computeSpectrum(bytes, false, 0);
            visualize(bytes);
            trace("enterframe 4");
        }

        /**
         * 
         * @param bytes
         */
        public function visualize(bytes:ByteArray):void {
            spectrum.graphics.clear();
            spectrum.graphics.lineStyle(0, 0xFF0000);
            spectrum.graphics.beginFill(0xFF0000);
            spectrum.graphics.moveTo(0, 0);
            var w:uint = 2;
            for (var i:int = 0; i < 512; i += w) {
                var t:Number = bytes.readFloat();
                var n:Number = (t * 100);
                spectrum.graphics.drawRect(i, 0, w, -n);
            }

        }

        private function onPlaybackComplete(event:Event):void {
            removeEventListener(Event.ENTER_FRAME, onEnterFrame);
            if (sound) {
                sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, playHandler);
            }
            sound = null;
            channel = null;
            isPlaying = false;
            recordedData.position = 0;
            currentBufferingData.position = 0;
            leftPeak = 0;
            rightPeak = 0;
            playbackTime = 0;
            latency = 0;
            spectrum.graphics.clear();
        }

        [Bindable]
        /**
         * 
         * @return 
         */
        public function get microphoneNames():Array {
            var names:Array = Microphone.names;
            return names;
        }

        private function set microphoneNames(value:Array):void {
            //
        }

        /**
         * 
         * @return 
         */
        public function getMicrophoneNames():Array {
            var names:Array = Microphone.names;
            return names;
        }

        private var selectedMicrophoneIndex:int = 0;

        /**
         * 
         * @param index
         */
        public function selectMicrophone(index:int):void {

            if (index < Microphone.names.length) {
                selectedMicrophoneIndex = index;
                microphone = Microphone.getMicrophone(index);
                updateMicrophoneProperties();
                updateMicrophoneBindings();
            }
        }

        /**
         * Shows dialog if microphone is not enabled or available. 
		 * You can check if a microphone is enabled by checking the MicrophoneEnabled property
		 * And you can show the microphone settings dialog by calling the showMicrophoneSettingsPanel()
         */
        public function enableMicrophone():void {

            microphone = Microphone.getMicrophone();

            if (microphone == null) {
                Alert.show("You will need to select a microphone and allow this application to access it.", "Help me help you", 4, ApplicationUtils.getInstance() as Sprite, selectMicrophoneHandler);
            }

            if (microphone.muted) {
                Alert.show("You will need to allow access to you microphone to continue. Select Allow.", "Help me help you", 4, ApplicationUtils.getInstance() as Sprite, allowAccessToMicrophoneHandler);
            }

            updateMicrophoneProperties();
            updateMicrophoneBindings();
        }


        /**
         * Show the microphone settings dialog. You may only show this settings once per session. 
		 * This restriction is enforced by the Flash Player. Or it may be a bug.
         */
        public function showMicrophoneSettingsPanel():void {
            Security.showSettings(SecurityPanel.MICROPHONE);
            displayedMicrophoneSettings = true;
        }

        /**
         * 
         * @param event
         */
        public function selectMicrophoneHandler(event:CloseEvent):void {

            // show settings if mic is muted
            if (event.detail == Alert.OK) {
                Security.showSettings(SecurityPanel.MICROPHONE);
                displayedMicrophoneSettings = true;
            }
            else if (event.detail == Alert.CANCEL) {

                if (microphone == null) {
                    Alert.show("If you don't have a microphone or have selected one from the menu you won't be able to record audio...");
                }
            }

            updateMicrophoneBindings();
        }

        /**
         * 
         * @param event
         */
        public function allowAccessToMicrophoneHandler(event:CloseEvent):void {

            // show settings if mic is muted
            if (event.detail == Alert.OK) {
                Security.showSettings(SecurityPanel.PRIVACY);
                displayedPrivacySettings = true;
            }

            // user canceled selection
            else if (event.detail == Alert.CANCEL) {

                // user chose to not allow microphone access
                // may need to reload the app to pop up the security dialog again
                if (microphone.muted) {
                    Alert.show("If you don't enable your microphone you won't be able to record anything...");
                }
            }


            // set mic name and mute status
            if (microphone && !microphone.hasEventListener(StatusEvent.STATUS)) {
                microphone.addEventListener(StatusEvent.STATUS, onMicAccessChange);
            }

            updateMicrophoneBindings();
        }

        // triggered when the user selects a microphone access setting
        /**
         * 
         * @param event
         */
        public function onMicAccessChange(event:StatusEvent):void {
            statusCode = event.code;
            statusMessageLevel = event.level;
            updateMicrophoneBindings();
        }

        /**
         * 
         */
        public function updateMicrophoneProperties():void {
            trace("name " + microphone.name);
            microphone.rate = _rate;
            trace("rate " + microphone.rate);
            microphone.codec = _codec;
            trace("codec " + microphone.codec);
            microphone.encodeQuality = _encodeQuality;
            trace("codec encodeQuality " + microphone.encodeQuality);
            microphone.gain = _gain;
            trace("gain " + microphone.gain);

            if (microphone.hasOwnProperty("enableVAD")) {
                microphone["enableVAD"] = _enableVAD;
            }

            microphone.setSilenceLevel(_silenceLevel, _silenceLevelTimeout);
            trace("silenceLevel " + microphone.silenceLevel);
            trace("silenceTimeout " + microphone.silenceTimeout);
            microphone.setUseEchoSuppression(_useEchoSuppression);
            trace("useEchoSuppression " + microphone.useEchoSuppression);

            if (microphone.hasOwnProperty("noiseSuppressionLevel")) {
                microphone["noiseSuppressionLevel"] = _noiseSuppressionLevel;
            }

            microphone.setLoopBack(_loopback);
            trace("loopback " + _loopback);

        }

        // set mic name and mute status
        /**
         * 
         */
        public function updateMicrophoneBindings():void {
            if (microphone) {
                microphoneName = microphone.name;
                microphoneCodec = microphone.codec;
                microphoneEnabled = !microphone.muted;
                microphoneMuted = microphone.silenceLevel == MUTE;
                microphoneGain = microphone.gain;
                useEchoSuppression = microphone.useEchoSuppression;
                enableVAD = microphone.hasOwnProperty("enableVAD") ? microphone["enableVAD"] : false;
                noiseSuppressionLevel = microphone.hasOwnProperty("noiseSuppressionLevel") ? microphone["noiseSuppressionLevel"] : _noiseSuppressionLevel;
                microphoneEncodeQuality = microphone.encodeQuality;
                microphoneSampleRate = getRate(false);
                silenceLevel = microphone.silenceLevel;
                silenceLevelTimeout = microphone.silenceTimeout;
                activityLevel = microphone.activityLevel;
                framesPerPacket = microphone.hasOwnProperty("framesPerPacket") ? microphone["framesPerPacket"] : 0;
            }
        }


    }
}