#include <Servo.h>
#include "DHT.h"
#include "MQ135.h"
#include <ESP8266WiFi.h>

#define DHTTYPE DHT11   // DHT 11

static const uint8_t D1   = 5;
static const uint8_t DHTPin = 2; 

Servo servo;
DHT dht(DHTPin, DHTTYPE);
MQ135 gasSensor = MQ135(A0);
// DTH11
float temperature = 0.0;
float humidity = 0.0;
// MQ135
float ppm = 0.0;
// WIFI
const char* ssid     = "Skynet2_4";
const char* password = "MoyaOborona2023!";
 
void setup() {
    Serial.begin(115200);
    delay(100);
    pinMode(DHTPin, INPUT);
    dht.begin();

    WiFi.begin(ssid, password);
  
    while (WiFi.status() != WL_CONNECTED) {
      delay(500);
      Serial.print(".");
    }

    Serial.println("");
    Serial.println("WiFi connected");  
    Serial.println("IP address: ");
    Serial.println(WiFi.localIP());

    servo.attach(D1);
    servo.write(0); 
    delay(2000);
}
 
void loop() {
    temperature = dht.readTemperature(); // Gets the values of the temperature
    humidity = dht.readHumidity();
    ppm = gasSensor.getPPM();
    servo.write(0);

    if (ppm > 50000) {
      Serial.println("AHTUNG GORIM");
      servo_save();
    }
    else {
      Serial.println("Temp:");
      Serial.println(temperature);
      Serial.println("Hum:");
      Serial.println(humidity);
      Serial.println("PPM:");
      Serial.println(ppm);
    }

    Serial.println("WiFi connected");  
    Serial.println("IP address: ");
    Serial.println(WiFi.localIP());

    delay(900);
}

void servo_save() {
    servo.write(90);
    delay(900);
}