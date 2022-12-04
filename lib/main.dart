import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/trim_audio.dart';
import 'package:flutter_app/wave_form.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wav_io/wav_io.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AudioPlayer _player = AudioPlayer();
  String? audioFilePath;

  @override
  void initState() {
    super.initState();
    getFilePath();
  }


  //almost useless function....
  getFilePath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    var dbPath = join(directory.path, "sample_audio.wav");
    ByteData data = await rootBundle.load("assets/sounds/another_test.wav");
    List<int> _bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // //parsing [RiffChunkId]...
    List<int> _riffChunkId = _bytes.sublist(0, 4);
    String _riff = String.fromCharCodes(_riffChunkId);
    log(_riff, name: _riffChunkId.toString());
    //
    // //parsing [RiffChunkSize]...
    Uint8List _riffChunkSizeList = Uint8List.fromList(_bytes.sublist(4, 8));
    int _riffChunkSize = ByteData.view(_riffChunkSizeList.buffer).getUint32(0, Endian.little);
    log(_riffChunkSize.toString(), name: _riffChunkSizeList.toString());
    //
    // //parsing [Riff] format...
    // List<int> _riffFormatList = _bytes!.sublist(8, 12);
    // String _riffFormat = String.fromCharCodes(_riffFormatList);
    // log(_riffFormat, name: _riffFormatList.toString());
    //
    // //parsing [SubChunk1Id]...
    // List<int> _subChunk1IdList = _bytes!.sublist(12, 16);
    // String _subChunk1Size = String.fromCharCodes(_subChunk1IdList);
    // log(_subChunk1Size, name: _subChunk1IdList.toString());
    //
    // //parsing [SubChunk1Size]...
    // Uint8List _subChunk1SizeList = Uint8List.fromList(_bytes!.sublist(16, 20));
    // int _subChunk1Id = ByteData.view(_subChunk1SizeList.buffer).getUint32(0, Endian.little);
    // log(_subChunk1Id.toString(), name: _subChunk1SizeList.toString());
    //
    // //parsing [SubChunkAudioFormat]...
    // Uint8List _subChunkAudioFormatList = Uint8List.fromList(_bytes!.sublist(20, 22));
    // int _subChunkAudioFormat = ByteData.view(_subChunkAudioFormatList.buffer).getUint16(0, Endian.little);
    // log(_subChunkAudioFormat.toString(), name: _subChunkAudioFormatList.toString());

    //parsing [SubChunk1BitsPerSample]...
    // Uint8List _subChunk1BitsPerSampleList = Uint8List.fromList(_bytes!.sublist(34, 36));
    // int _subChunk1BitsPerSample = ByteData.view(_subChunk1BitsPerSampleList.buffer).getUint16(0, Endian.little);
    // log(_subChunk1BitsPerSample.toString(), name: "SubChunk1BitsPerSample: ${_subChunk1BitsPerSampleList.toString()}");
    //
    // //parsing [SubChunkNumChannel]...
    // Uint8List _subChunkNumChannelList = Uint8List.fromList(_bytes!.sublist(22, 24));
    // int _subChunkNumChannel = ByteData.view(_subChunkNumChannelList.buffer).getUint16(0, Endian.little);
    // log(_subChunkNumChannel.toString(), name: "SubChunkNumChannel: ${_subChunkNumChannelList.toString()}");
    //
    //parsing [data-subChunk]...
    List<int> _subChunk2IdList = _bytes.sublist(36, 40);
    String _subChunk2Id = String.fromCharCodes(_subChunk2IdList);
    log(_subChunk2Id, name: _subChunk2IdList.toString());

    // //parsing [SubChunk2Size]...
    Uint8List _subChunk2SizeList = Uint8List.fromList(_bytes.sublist(40, 44));
    int _subChunk2Size = ByteData.view(_subChunk2SizeList.buffer).getUint32(0, Endian.little);
    log(_subChunk2Size.toString(), name: "SubChunk2Size: ${_subChunk2SizeList.toString()}");

    // log(String.fromCharCodes(_bytes!.sublist(36, 40)), name: "data chunk started");

    // double samples = _subChunk2Size / _subChunkNumChannel / (_subChunk1BitsPerSample / 8);

    // log(_bytes!.length.toString(), name: "file length");
    // List<int> _channelData = [];
    // List<int> byteGather = [];
    // for(int sampleIndex = 45; sampleIndex < _bytes!.length; sampleIndex ++) {
    //   if(byteGather.length == 4) {
    //     int sampleValue = ByteData.view(Uint8List.fromList(byteGather).buffer).getUint16(0, Endian.little);
    //     _channelData.add(sampleValue);
    //     byteGather = [_bytes![sampleIndex]];
    //   } else {
    //     byteGather.add(_bytes![sampleIndex]);
    //   }
    // }
    //
    // Uint8List int16BigEndianBytes(int value) => Uint8List(4)..buffer.asByteData().setInt16(0, value, Endian.little);
    // log(_channelData.length.toString(), name: "_channelData Length");
    // List<int> _parsedData = [];
    // for (var element in _channelData) {
    //   _parsedData.addAll(int16BigEndianBytes(element).toList());
    // }
    // List<int> newAudio = List.from(_bytes!.sublist(0, 44));
    // newAudio.addAll(_parsedData);

    File newFIle = await File(dbPath).writeAsBytes(_bytes);

    setState(() {
      audioFilePath = newFIle.path;
    });
    log("done");
  }

  seekerCallBackEnd(double position, BuildContext context) async {
    // _player.dispose();
    // var f = File(audioFilePath!).openSync();
    // var buf = f.readSync(f.lengthSync());
    // f.closeSync();
    // var wav = WavContent.fromBytes(buf.buffer.asByteData());
    //
    double _fullWidth = MediaQuery.of(context).size.width;
    // int _byteLen = wav.samplesForChannel.length;
    // int _lengthRemove = (_byteLen * (position / _fullWidth)).floor();
    //
    // wav.samplesForChannel.removeRange(_lengthRemove, wav.samplesForChannel.length);
    //
    // f.writeFromSync(wav.toBytes().buffer.asInt8List());
    // f.flushSync();
    // f.closeSync();


    //parsing only data chunk at offset [42]
    // [data] string is supposed to be at 34th bit
    int additionalOffset = 36;
    int currentDataOffset = additionalOffset + 8;
    var f = File(audioFilePath!).openSync();
    var buf = f.readSync(f.lengthSync());

    int nextSubCkFmtSize = buf.buffer.asByteData().getUint32(additionalOffset + 4, Endian.little);
    int samples = nextSubCkFmtSize ~/ (1 * 2);
    log(nextSubCkFmtSize.toString(), name: "nextSubCkFmtSize");
    log(samples.toString(), name: "samples");

    // [2,3,5,6,67,....] (got from readSync as int bytes)
    // [channel 1 -> [1,2,3...], channel 2 -> [34,5,6...]] (sterio)
    // [channel 1 -> [2,3,4,5,6....]] (mono List converted to 16 bit Integer)

    List<Int16List> samplesForChannel = List.generate(1, (index) => Int16List(samples));
    for (int s = 0; s < samples; ++s) {
      for (int ch = 0; ch < 1; ++ch) {
        samplesForChannel[ch][s] = buf.buffer.asByteData().getInt16(currentDataOffset, Endian.little);
        currentDataOffset += 2;
      }
    }

    //trimming...
    int _lengthRemove = (samplesForChannel.first.length * (position / _fullWidth)).floor();
    List<int> newTrimmedList = List.from(samplesForChannel.first);
    // log(_lengthRemove.toString(), name: "length to remove");
    // log(newTrimmedList.length.toString(), name: "length before");
    newTrimmedList.removeRange(_lengthRemove, samplesForChannel.first.length);
    // log(newTrimmedList.length.toString(), name: "length after");


    //stitch back...
    ByteData _headerAddedData = toBytes([Int16List.fromList(newTrimmedList)]);

    Duration? duration = await _player.setAudioSource(MyCustomSource(_headerAddedData.buffer.asUint8List()));
    log(duration?.inSeconds.toString() ?? "N/A");
    _player.play();
  }

  ByteData toBytes(List<Int16List> samples) {
    int bitsPerSample = 16;

    int bytesPerSample = (bitsPerSample + 7) ~/ 8;

    var actualDataInBytes = samples.first.length * 1 * bytesPerSample;
    actualDataInBytes = (actualDataInBytes + 1) & (~1); //we better make it even.

    var data = ByteData(44 + actualDataInBytes);

    data.setUint32(0, RIFF_ID, Endian.big);
    data.setUint32(4, 36 + actualDataInBytes, Endian.little);
    data.setUint32(8, WAVE_ID, Endian.big);
    data.setUint32(12, fmt_ID, Endian.big);
    data.setUint32(16, 16, Endian.little);
    data.setUint16(20, WAVE_FORMAT_PCM, Endian.little);
    data.setUint16(22, 1, Endian.little);
    data.setUint32(24, 16000, Endian.little);
    data.setUint32(28, bytesPerSample * 1 * 16000, Endian.little);
    data.setUint16(32, bytesPerSample * 1, Endian.little);
    data.setUint16(34, bitsPerSample, Endian.little);
    data.setUint32(36, data_ID, Endian.big);
    data.setUint32(40, samples.first.length * 1 * bytesPerSample, Endian.little);
    var currentDataOffset = 44;
    for (int s = 0; s < samples.first.length; ++s) {
      for (int ch = 0; ch < 1; ++ch) {
        data.setInt16(currentDataOffset, samples[ch][s], Endian.little);
        currentDataOffset += 2;
      }
    }
    return data;
  }

  seekerCallBackStart() {
    if(_player.playing) _player.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              audioFilePath == null ? const SizedBox() : Positioned(
                bottom: 0,
                child: AudioFileWaveforms(
                  filePath: audioFilePath!,
                  size: Size(MediaQuery.of(context).size.width, 100),
                  density: 1,
                ),
              ),
              WaveSlider(width: MediaQuery.of(context).size.width, seekerCallBackEnd: seekerCallBackEnd, seekerCallBackStart: seekerCallBackStart),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 54,
                icon: const Icon(
                  Icons.stop
                ),
                onPressed: () {
                  _player.stop();
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}

class MyCustomSource extends StreamAudioSource {
  final Uint8List _buffer;

  MyCustomSource(this._buffer) : super(tag: 'MyAudioSource');

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    // Returning the stream audio response with the parameters
    return StreamAudioResponse(
      sourceLength: _buffer.length,
      contentLength: (start ?? 0) - (end ?? _buffer.length),
      offset: start ?? 0,
      stream: Stream.fromIterable([_buffer.sublist(start ?? 0, end)]),
      contentType: 'audio/wav',
    );
  }
}