#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
////////////////
#include <Servo.h>
#include "DHT.h"
#include "MQ135.h"

#ifndef LWIP_HAVE_LOOPIF
#define LWIP_HAVE_LOOPIF                1
#endif

#ifndef LWIP_HAVE_SLIPIF
#define LWIP_HAVE_SLIPIF                1
#endif

// WIFI
const char* WIFI_SSID = "SSID";
const char* WIFI_PWD = "PASS";

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

String temperature_str;
String humidity_str;
String ppm_str; 

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  
  delay(100);
  pinMode(DHTPin, INPUT);
  dht.begin();
  
  Serial.println();
  Serial.println(F("Sensors test"));
  bool status;

  /* Сделать тесты подключения датчиков
  status = bme.begin(0x76);  
    if (!status) {
        Serial.println("Could not find a valid BME280 sensor, check wiring!");
        while (1);
        Serial.println("-- Default Test --");
    delayTime = 1000;

    Serial.println();
    }
  */

  // Проверка подключения WI_FI
  WiFi.mode(WIFI_OFF);                                         //Перезапуск точки доступа
  delay(1000);   
  WiFi.mode(WIFI_STA);  
  WiFi.begin(WIFI_SSID, WIFI_PWD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

}

void loop() {
  // Чтение с датчиков раз в 1 секунду и отправка
  delay(500);
  prepareSensorsData();
  delay(30000);
}

void prepareSensorsData() {
  temperature = dht.readTemperature(); // Gets the values of the temperature
  humidity = dht.readHumidity();
  ppm = gasSensor.getPPM();

  temperature_str = String(temperature, 1);
  humidity_str = String(humidity, 1);
  ppm_str = String(ppm, 1);

  Serial.println("Temp:");
  Serial.println(temperature_str);
  Serial.println("Hum:");
  Serial.println(humidity_str);
  Serial.println("PPM:");
  Serial.println(ppm_str);

  transferSensorsDataToServer(temperature_str, humidity_str, ppm_str);
}

void transferSensorsDataToServer(String temperature_str, String humidity_str, String ppm_str) {
  WiFiClient client;
  float pres = 56.0;
  String date = "2023-06-05";
  String current_time = "12:39";
  if(WiFi.status()== WL_CONNECTED){
    HTTPClient http;

    String url = "http://127.0.0.1:5000/postWeatherData?Temp="+temperature_str+"&Hum="+humidity_str+"&Pres="+pres+"&Date="+date+"&Time="+current_time;
    String url2 = "http://127.0.0.1:5000/postWeatherData?Temp="+temperature_str+"&Hum="+humidity_str+"&Pres="+pres+"&Date="+date+"&Time="+current_time;
    String link = "/postWeatherData?Temp="+temperature_str+"&Hum="+humidity_str+"&Pres="+pres+"&Date="+date+"&Time="+current_time;
    String host = "192.168.0.7:5000";
    int port = 8000;
    String data = "/postWeatherData?Temp="+temperature_str+"&Hum="+humidity_str+"&Pres="+pres+"&Date="+date+"&Time="+current_time;
    Serial.println(url);
    
    const int httpPort = 8000;
    if (!client.connect("192.168.0.7", 5000)) {
      Serial.println("connection failed");
      return;
    }

    client.print(String("GET /postWeatherData?Temp="+temperature_str+"&Hum="+humidity_str+"&Pres="+pres+"&Date="+date+"&Time="+current_time) + " HTTP/1.1\r\n" + 
        "Host: " + host + "\r\n" + "Connection: close\r\n\r\n");

    // http.begin(client, url.c_str());
    // http.begin(client, url2);
    // http.begin(client, host, port, data, 0);

    // int httpCode = http.GET();
    // Serial.println(httpCode);
    // http.end();
  }
  else {
    Serial.println("WiFi Disconnected");
  }
  client.stop();
  // delete client;
}
