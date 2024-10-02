# BabyPod

This repository is for the hardware and initial setup. For the CircuitPython code that runs on the hardware, see the [`babypod-software`](https://github.com/skjdghsdjgsdj/babypod-software/) repository.

## What is it?

BabyPod is a remote control for [Baby Buddy](https://github.com/babybuddy/babybuddy). It's named that because it connects to Baby Buddy and has a click wheel like an old iPod.

Why use BabyPod instead of just your phone or something else, or even Baby Buddy in general?

* **Simplicity:** instead of finding your phone and keeping it charged, launching an app (and there's no iOS app), etc., just use a dedicated device that you can make whatever color you want to find easily and that stays charged a long time. It does one thing only. Deliberately, not all features of Baby Buddy exist in BabyPod, just the most commonly used ones.
* **Full control of your data:** you have total privacy over your data because BabyPod talks directly to your Baby Buddy instance's API.
* **Quick access:** the most commonly used things are shown first, and extra data can be added later. For example, if you record a diaper change, you can log if it was wet and/or dry, but it doesn't ask for color because usually it'll be the same and you can just add it later directly in Baby Buddy if not. Print and build multiple BabyPods if you want and leave them in places you frequent, like your baby's nursery, a place where you feed, etc. For multiple children, you can print and build multiple BabyPods and assign each one to a specific child.
* **Open source:** change it to do what you want. As long as you don't sell it, I don't care what you do with it. Contributing back would be nice!

## Hardware

To build a BabyPod, you 3D print some parts, stuff it with some electronics with easy soldering, and load the software.

### Parts, tools, and software needed

Here's what you need to build a BabyPod. Prices are USD at the time of authoring and you can possibly find parts cheaper elsewhere, but this is to give you a nominal idea of how much the project costs.

Note that you can get most of these parts from the manufacturer directly like [Adafruit](https://www.adafruit.com/) and [Sparkfun](https://www.sparkfun.com/), and also resellers like [Digikey](https://www.digikey.com/), [Mouser](https://www.mouser.com/), and if you're lucky, [Micro Center](https://www.microcenter.com/) locally. The prices on Amazon are usually inflated.

Deviate from the parts list at your own risk, but _do not get a different battery!_ Adafruit batteries have polarities that match their own boards, and using a battery off Amazon or elsewhere may not match and destroy your board or even start a fire!

| Part                                                                                                         | Quantity | Price  |
|--------------------------------------------------------------------------------------------------------------|----------|--------|
| [Adafruit ESP32-S3 Feather with 4MB Flash 2MB PSRAM](https://www.adafruit.com/product/5477)                  | 1        | $17.50 |
| [Sparkfun 20x4 SerLCD](https://www.sparkfun.com/products/16398)                                              | 1        | $26.95 |
| [Adafruit ANO Rotary Navigation Encoder to I2C Stemma QT Adapter](https://www.adafruit.com/product/5740)     | 1        | $4.95  |
| [ANO Directional Navigation and Scroll Wheel Rotary Encoder](https://www.adafruit.com/product/5001)          | 1        | $8.95  |
| [Lithium Ion Polymer Battery - 3.7v 2500mAh](https://www.adafruit.com/product/328)                           | 1        | $14.95 |
| [STEMMA QT / Qwiic JST SH 4-pin Cable - 100mm Long](https://www.adafruit.com/product/4210)                   | 2        | $0.95  |
| [STEMMA QT / Qwiic JST SH 4-pin Cable - 50mm Long](https://www.adafruit.com/product/4210)                    | 1        | $0.95  |
| [Small Enclosed Piezo w/Wires](https://www.adafruit.com/product/1740)                                        | 1        | $0.95  |
| [Adafruit SPI Flash SD Card - XTSD 512 MB](https://www.adafruit.com/product/4899)                            | 1        | $9.50  |
| [Adafruit PCF8523 Real Time Clock Breakout Board - STEMMA QT / Qwiic](https://www.adafruit.com/product/5189) | 1        | $4.95  |
| [Short Feather Male Headers - 12-pin and 16-pin Male Header Set](https://www.adafruit.com/product/3002)      | 1        | $0.50  |
| [Short Headers Kit for Feather - 12-pin + 16-pin Female Headers](https://www.adafruit.com/product/2940)      | 1        | $1.50  |
| [FeatherWing Proto - Prototyping Add-on For All Feather Boards](https://www.adafruit.com/product/2884)       | 1        | $4.95  |

Note the headers are the *short headers* that Adafruit sells, not the full height ones that come with most boards. Do not use full height headers or the boards won't fit in the enclosure!

You will also need the following supplies. The manufacturer doesn't matter but some examples are linked below:

* A [CR1220 button cell battery](https://www.adafruit.com/product/380)	
* Screws:
  * [M2](https://www.amazon.com/dp/B0B6HVS3SJ)x4, quantity 2
  * [M2.5](https://www.amazon.com/dp/B0BC9294PD)x6, quantity 4
  * M2.5x4, quantity 8
  * [M3](https://www.amazon.com/dp/B0CSX4L42C)x4, quantity 4
  * [Self-tapping countersunk M2](https://www.amazon.com/dp/B09DB5SMCZ)x4, quantity 6
* [22AWG solid core hookup wire](https://www.adafruit.com/product/1311)
* 3D printing filament of your choice; PETG works nicely
* A USB C cable capable of both data and charging
* Solder
* 1.75mm *transparent* 3D printing filament, ~6mm worth; this acts as a light pipe and you won't actually print using it

And lastly, tools:
* Screwdriver that works with the screws you picked
* Wire cutters/strippers
* Soldering iron
* A 3D printer
* A computer with a USB C port

## Printing the enclosure

You can print the enclosure in either one or two colors. Whichever you choose:

* Infill amount and style doesn't matter much because there isn't much to infill.
* Don't use supports.
* 0.2mm layer height is best. You can probably print taller layers, but it'll lower the resolution of the USB C ports and light pipe guide.
* If you set the bottom infill pattern to "Archimedian Chords" on both parts, it'll look prettier. Same if you use PETG and print on a textured plate.

### One color

Print `Case.stl` upside-down and `Baseplate.stl` as-is.

### Two colors

Printing in two colors requires a printer that supports multiple filaments or [clever use of GCODE](https://old.reddit.com/r/prusa3d/comments/nt3oau/2_colors_on_the_same_layer/h0q4s6e/).

Print `Case.stl` and `Faceplate inlays.stl` as a multipart object upside-down (top of the faceplate and inlays facing the bed) and `Bottom case.stl` as-is.

If you're editing `BabyPod.scad`, your system needs the font "SignPainter" installed.

## Assembly

### CircuitPython setup

[Install CircuitPython 9.1.4 onto the Feather](https://learn.adafruit.com/adafruit-esp32-s3-feather/circuitpython), even though it was probably preinstalled. You want to get the right version and erase any unnecessary files.

1. [Download CircuitPython 9.1.4](https://circuitpython.org/downloads) for your specific board. Get the `.bin` version, not `.uf2`.
2. Connect the Feather to your computer via USB C.
3. Press and hold the Boot button, briefly press Reset, and then release the Boot button. This puts the board in a bootloader mode.
4. In Google Chrome, go to [Adafruit's ESPTool](https://adafruit.github.io/Adafruit_WebSerial_ESPTool/).
5. Click "Connect" and select the Feather. The device's name will vary, but ultimately you should see a successful connection message.
6. Click Erase and wait about 15 seconds until you get a success message.
7. Click the first "Choose a file..." button and select the `.bin` CircuitPython image you downloaded, then click "Program."
8. When prompted to do so, press the Reset button on the Feather. A few moments later, a drive named `CIRCUITPY` should mount itself on your computer.

### Load the BabyPod software

1. Download the [latest release of the BabyPod software](https://github.com/skjdghsdjgsdj/babypod-software/releases).
2. Extract the release zip or tarball.
3. Copy everything from the extracted release release to the `CIRCUITPY` drive, overwriting anything already on the drive.

Even though there isn't much to copy, it might take a few minutes.

### Create `settings.toml`

1. Rename `settings.toml.example` on the `CIRCUITPY` to `settings.toml`. Make sure your OS doesn't sneak a `.txt` extension onto it.
2. Open `settings.toml` in a text editor and modify it as comments in the file show, then save it.
3. Wait a few seconds, then unplug the Feather from your computer.

### Soldering

Before soldering, orient yourself to where everything mounts to the 3D printed parts. You want to use just enough wire to reach, but
not too much excess or you won't be able to fit everything inside the enclosure.

It may help to keep [Adafruit's pinout documentation of the Feather](https://learn.adafruit.com/adafruit-esp32-s3-feather/pinouts) open while you're soldering. Pay very close attention to soldering wires to the FeatherWing proto. Always be aware of which side has the shorter or longer header, and if you're looking at it upside down or rightside up. Triple check which pin you're soldering to before you actually do it!

There are a few important points to keep in mind when using the FeatherWing Proto:

* Look at the [pinout](https://learn.adafruit.com/featherwing-proto-and-doubler/proto-pinout). The headers get soldered to the outermost set of pins in the white bordered areas.
* The leftmost column of pins that has a white border around it is the 3.3V bus. You can use any of those solder points to get 3.3V power.
* Similarly, the column of pins immediately to the right of the 3.3V bus are all ground pins. Solder to any of them for a ground connection.
* The rows of pins immediately below the top header and immediately above the bottom header share connections with the Feather's underlying pins. For example, the top-right pin goes to `SDA` via the male header into the Feather's female header, and the pin on the FeatherWing immediately below that one is shared with that pin, so it too goes with `SDA`.
* The pins between the headers in the middle of the board aren't connected to anything and are meant for prototyping, hence the name of the product. More pointedly, they *do not connect to the Feather and you should not solder to them for assembling the BabyPod!*

Many of the devices ship with headers included. Don't solder those!

#### Solder rotary encoder

Solder the rotary encoder dial to its breakout board. It only fits one way. Be careful not to skip any connections.

#### Solder headers

1. Solder the short female headers to the top of the Feather (i.e., the side with all the components on it).
2. [Solder the short male headers to the bottom of the FeatherWing Proto.](https://learn.adafruit.com/featherwing-proto-and-doubler/assembly). The printed text on the FeatherWing must be on top and the headers on the bottom.

#### Solder connections to the FeatherWing Proto

Solder the following connections from the respective devices to the FeatherWing Proto:

| Device               | Pin/Wire   | To    |
|----------------------|------------|-------|
| Piezo                | Black wire | `GND` |
| Piezo                | Red wire   | `A3`  |
| Flash SD card        | `VIN`      | `3V`  |
| Flash SD card        | `GND`      | `GND` |
| Flash SD card        | `SCK`      | `SCK` |
| Flash SD card        | `MISO`     | `MI`  |
| Flash SD card        | `MOSI`     | `MO`  |
| Flash SD card        | `CS`       | `10 ` |
| Rotary encoder board | `INT`      | `11`  |

The piezo wires are very thin, so be careful. Less solder is best.

You will not solder any wires to the LCD nor to the RTC, and only one wire gets soldered to the rotary encoder.

### Mount components

When screwing in components, use just enough force to keep things in place. Don't over-tighten the screws or you'll strip
the non-existent threads in the 3D printed parts and need to print them again.

The plugs on STEMMA QT cables only fit one way. Don't use a lot of force or you can easily bend one of the thin pins in their ports.

1. Connect the LCD to the rotary encoder using one of the 100mm STEMMA QT cables. It doesn't matter which port on the rotary encoder you use. On the other STEMMA QT port on the rotary encoder, plug in another 100mm STEMMA QT cable. It'll later connect to other components, but not yet.
2. Screw the rotary encoder into place with four M2.5x4 screws. The set of pins on it, including where you soldered the `INT` wire, should face towards the cutout for the LCD and the star with the Adafruit logo by the outer edge of the case with the STEMMA QT connectors pointing to the top and bottom of the case.
3. Use four M2.5x6 screws to screw the LCD into place into the case. The "QWIIC" connector (what Adafruit calls "STEMMA QT") should point towards the rotary encoder and the LCD screen faces out towards the cutout for it.
4. Set aside the case for now.
5. Press the piezo into place in its circle on the baseplate with the hole facing down and the wire protruding through the cutout in the circle. You can keep the white bit of tape on.
6. Screw the Flash SD board into place above the piezo with two M2.5x4 screws with the components facing up.
7. Put the CR1220 battery into the RTC; note the polarity. Screw the RTC into place with four M3x4 screws with the battery facing up. The direction doesn't matter.
8. Screw the Feather into place with the USB C port facing towards the cutout in the case and the female headers facing up. Use two M2.5x4 screws for the larger holes and two M2x4 screws for the smaller ones.
9. Plug the 50mm STEMMA QT cable into the Feather's port and into the nearest port on the RTC, then connect the STEMMA QT cable from the assembled case with the rotary encoder into the other port on the RTC.
10. Press the battery into its retainer with the cable by the bottom-left, assuming the Feather's USB C port is facing you. Don't plug in the battery into the Feather yet.
11. Press the FeatherWing Proto into the Feather's female headers. Be careful the pins are aligned and you're not off-by-one.

### Testing before final assembly

At this point, you should have all the connections made, except the battery. You can test the BabyPod by plugging in the USB C cable and seeing if it starts up. If you get to the main menu, all your connections are good. You should also hear the piezo beep when it starts up.

### Final assembly

If the test passed, continue on:

1. Plug the battery into the Feather. It will boot up the BabyPod, so be careful as the Feather and other components are now live.
2. Carefully press together the two 3D printed parts, being sure to align the USB C hole to the Feather.
3. Screw them together with the countersunk self-tapping M2 screws. Be especially careful not to overtighten!
4. Shove the little bit of transparent 1.75mm filament into the hole next to the USB C connector until it is flush with the outside of the case. It acts as a light pipe for the Feather's charge LED.

## Troubleshooting

### Power-related

- Most obviously, check all your solder connections. It's easy to accidentally solder the wrong pin, or common mistakes like too little or too much solder.
- Is the battery charged? The battery is 2500mAh and the Feather's charging speed means it can take a long time to fully charge from 0%. Even with a dead battery, the BabyPod should still function when powered by USB.
- Is the battery plugged into the Feather completely? Be careful removing the battery connector; it's an extremely tight fit, so gently work it out with pliers or a screwdriver and _never pull on the battery wires!_
- Did you use an Adafruit battery and Adafruit Feather? If you didn't, then you may have reversed the battery polarity and destroyed the Feather. Smoke may have been another clue.

### Software-related

- Did you install CircuitPython 9 and load all the code, including the relevant libraries? Have you tried an older version of CircuitPython (still 9.x.x) in case there was a breaking change?
- Is the code crashing? [Connect to a serial console and watch the output.](https://learn.adafruit.com/welcome-to-circuitpython/kattni-connecting-to-the-serial-console) Note the code disables the auto-reload when you write a file which is different from CircuitPython's default operation. In a serial console, you can press `Ctrl-C` to stop the code and then `Ctrl-D` to reboot which will capture all the output from the moment it boots up. If you're using macOS, then [tio](https://formulae.brew.sh/formula/tio) makes it easy to use serial consoles in the terminal; the device is `/dev/tty.usbmodem*`.
- Does the menu show up but you get various errors when you actually try to _do_ something, like recording a feeding or changing? Your `settings.toml` is probably wrong, either for the Wi-Fi credentials, Wi-Fi channel if you specified one, or Baby Buddy's URL or authorization token. The serial console should help you here.
- Are you using a recent version of Baby Buddy for your server? Or perhaps your version is _too_ new and there's an API-breaking change?

### Other things to check

- Is the LCD contrast adjusted? The Sparkfun LCD contrast is adjusted through code.
- When plugging in a USB C cable, is it snapping fully into the port on the Feather, or is the enclosure preventing it from going all the way in?
- Are all the relevant STEMMA QT connections in use? Every available STEMMA QT port (or QWIIC in the case of the LCD) should be in use. Technically speaking the order of the connections doesn't matter, but do be sure everything is connected in a chain and there are no empty STEMMA QT ports.