#include <Adafruit_GFX.h>
#include <gfxfont.h>
#include <Adafruit_HX8357.h>

// These are 'flexible' lines that can be changed
#define TFT_CS 10
#define TFT_DC 9
#define TFT_RST -1 // RST can be set to -1 if you tie it to Arduino's reset

#define FPGA_RST 3
#define FPGA_CLK 2
#define FPGA_CMD1 1
#define FPGA_CMD0 0

// Use hardware SPI (on Uno, #13, #12, #11) and the above for CS/DC
Adafruit_HX8357 tft = Adafruit_HX8357(TFT_CS, TFT_DC, TFT_RST);

void setup() {
  for (int pin = 22; pin <= 32; pin++) {
    pinMode(pin, INPUT_PULLUP);
  }
  
  pinMode(FPGA_RST, OUTPUT);
  digitalWrite(FPGA_RST, LOW);
  pinMode(FPGA_CLK, OUTPUT);
  digitalWrite(FPGA_CLK, LOW);
  pinMode(FPGA_CMD1, OUTPUT);
  digitalWrite(FPGA_CMD1, LOW);
  pinMode(FPGA_CMD0, OUTPUT);
  digitalWrite(FPGA_CMD0, LOW);
  
  tft.begin(HX8357D);
  tft.fillScreen(HX8357_BLACK);  
  tft.setRotation(1);
  tft.setTextColor(HX8357_WHITE, HX8357_BLACK);  
  tft.setTextSize(3);

  digitalWrite(FPGA_RST, HIGH);
  digitalWrite(FPGA_CLK, HIGH);
  digitalWrite(FPGA_CLK, LOW);
  digitalWrite(FPGA_RST, LOW);
}

void loop() {
  tft.setCursor(0, 0);
  print_uint16(getAddr());
  
  digitalWrite(FPGA_CMD1, LOW);
  digitalWrite(FPGA_CMD0, HIGH);
  delay(10);
  digitalWrite(FPGA_CLK, HIGH);
  delay(10);
  digitalWrite(FPGA_CLK, LOW);
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

