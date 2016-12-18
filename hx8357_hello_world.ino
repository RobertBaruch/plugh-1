#include <Adafruit_GFX.h>
#include <gfxfont.h>
#include <Adafruit_HX8357.h>

// These are 'flexible' lines that can be changed
#define TFT_CS 10
#define TFT_DC 9
#define TFT_RST -1 // RST can be set to -1 if you tie it to Arduino's reset

// Use hardware SPI (on Uno, #13, #12, #11) and the above for CS/DC
Adafruit_HX8357 tft = Adafruit_HX8357(TFT_CS, TFT_DC, TFT_RST);

void setup() {
  tft.begin(HX8357D);
  tft.fillScreen(HX8357_BLACK);
  for (int pin = 22; pin <= 32; pin++) {
    pinMode(pin, INPUT_PULLUP);
  }
  tft.setRotation(1);
  tft.setTextColor(HX8357_WHITE, HX8357_BLACK);  
  tft.setTextSize(3);
}

void loop() {
  tft.setCursor(0, 0);
  print_uint16(getAddr());
}

uint16_t getAddr() {
  uint16_t data = 0;
  
  // pin 22 = A10, pin 32 = A0.
  for (int pin = 22; pin <= 32; pin++) {
    data <<= 1;
    if (digitalRead(pin) == HIGH) {
      data |= 1;
    }
  }
  return data;
}

void print_uint16(uint16_t v) {
  uint16_t n;

  for (int i = 0; i < 4; i++) {
    n = v >> 12;
    v <<= 4;
    tft.print(n, 16);
  }
}

