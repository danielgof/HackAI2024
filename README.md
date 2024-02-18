# See Food App

The See Food App is a mobile application developed using Flutter that utilizes the OpenAI API to detect food items, identify potential allergies, and provide calorie information. This README provides an overview of the application's features, setup instructions, and usage guidelines.

## Features

- **Food Detection**: The app uses the OpenAI API to recognize various food items from images captured by the device's camera or selected from the gallery.
- **Allergy Detection**: It analyzes detected food items to determine potential allergens and alerts the user accordingly.
- **Calorie Information**: The app retrieves calorie information for recognized food items, helping users make informed dietary choices.
- **User-Friendly Interface**: With a clean and intuitive user interface, the app offers a seamless experience for users to interact with.

## Setup

To run the See Food App on your local machine or device, follow these steps:

1. **Clone the Repository**: 
   ```bash
   git clone https://github.com/your-username/see-food-app.git
   ```

2. **Navigate to the Project Directory**:
   ```bash
   cd see-food-app
   ```

3. **Install Dependencies**: 
   ```bash
   flutter pub get
   ```

4. **Configure API Keys**: 
   - Obtain your OpenAI API key and update it in the appropriate configuration file (`secrets.dart` or `constants.dart`).
   - Ensure your OpenAI API key is securely stored and not exposed publicly.

5. **Run the App**:
   ```bash
   flutter run
   ```

6. **Explore the App**: 
   - Use the camera or gallery feature to capture or select images of food items.
   - Wait for the app to analyze the image and provide information about the detected food items, allergies, and calorie content.

## Usage

- Upon launching the app, users can choose to take a photo using the device's camera or select an existing photo from the gallery.
- Once an image is selected, the app processes it using the OpenAI API to recognize food items.
- Users receive instant feedback on potential allergies associated with detected food items and their calorie information.
- The app provides an interactive interface for users to explore additional details and nutritional information about specific food items.

## Contributing

Contributions to the See Food App are welcome! Feel free to submit bug reports, feature requests, or pull requests to help improve the app's functionality and user experience.

## License

This project is licensed under the [MIT License](LICENSE).

