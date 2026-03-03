/*
 * XIAO Board Compilation Test Template
 *
 * This minimal sketch is used for basic syntax validation
 * during the Arduino CLI compilation verification process.
 *
 * Compatible with all XIAO board variants.
 */

void setup() {
    // Initialize serial communication
    // Note: Some boards may require different baud rates or configurations
    Serial.begin(115200);

    // Wait for serial connection (useful for boards with native USB)
    // Comment out for non-USB boards or production code
    while (!Serial) {
        ; // Wait for serial port to connect
    }

    // Initialize built-in LED (pin varies by board)
    // LED_BUILTIN is defined by the board core
    pinMode(LED_BUILTIN, OUTPUT);

    Serial.println("XIAO Board Test - Setup Complete");
}

void loop() {
    // Basic LED blink test
    digitalWrite(LED_BUILTIN, HIGH);
    delay(500);
    digitalWrite(LED_BUILTIN, LOW);
    delay(500);

    // Serial output test
    Serial.println("XIAO Board Test - Loop Running");
}
