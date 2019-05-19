# CatBoost-test

Данное приложение демонстрирует простую работу с форматом coreml. Приложение позволяет определить находится ли в данный момент человек в состоянии ходьбы.

# Примеры работы
В папке ```/examples``` представлено 4 состояния приложения: 1) до нажатия кнопки старт; 2) отсутствие ходьбы после нажатия кнопки старт; 3) начало ходьбы после нажатия кнопки старт (показания apple API и обученной модели могут отличаться); 4) остановка работы приложения после нажатия кнопки "End".

# Обученная Catboost модель
Для получения модели в формате coreml (```/CatBoost test/WalkingModel.mlmodel```) были получены данные о состоянии ходьбы. Файл, с помощью которого было произведено обучение, и ноутбук с обучением модели CatBoostClassifier и сохранением в формат coreml находятся в папке  ```model_train```.

# Логика приложения
Вся логика единственного экрана реализована в ```/CatBoost test/ViewController.swift```.
