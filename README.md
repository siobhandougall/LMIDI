# LMIDI

A minimalist MIDI I/O library for Swift

## License: MIT

Copyright 2019 Sean Dougall.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## System Requirements

macOS 10.11 or later

Could likely be updated to support iOS; haven't delved into that yet.

## Basic usage

LMIDI's operation is coordinated by a central `LMIDIConfig` class. You can instantiate this with `LMIDIConfig.shared(name:)`. The same config object will be used for subsequent calls that are passed the same `name` parameter.

Get all avaliable inputs and outputs with `config.inputSources` and `config.outputDestinations`. These are instances of `LMIDISource` and `LMIDIDestination`, which roughly wrap Core MIDI's `MIDIEndpointRef`.

Processing input:

    let source: LMIDISource = ...
    let input = try LMIDIInput(source: source, portName: "Input 1") // make sure to keep this instance around somehow
    try input.listen { messages in
        for msg in messages {
            print("\(msg)")
        }
    }

Sending output:

    let destination: LMIDIDestination = ...
    let output = try LMIDIOutput(destination: destination, portName: "Output 1") // keep this instance around too
    output.send(.noteOn(channel: 4, note: 64, velocity: 127)) // note: channel numbers are 0-15, not 1-16

MIDI message types are enumerated by `LMIDIMessage`. This includes SysEx messages, whose associated data is an array of the bytes contained in the message (not including the opening `F0` or the closing `F7`).
