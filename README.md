# CatBoost-test

Данное приложение демонстрирует простую работу с форматом coreml. Приложение позволяет определить находится ли в данный момент человек в состоянии хотьбы.

# Примеры работы
В папке ```/examples``` представлено 4 состояния приложения: 1) до нажатия кнопки старт; 2) отсутсвие хотьбы после нажатия кнопки старт; 3) начало хотьбы после нажатия кнопки старт (показания apple API и обученной модели могут отличаться); 4) остановка работы приложения после нажатия кнопки "End".

# Обученная Catboost модель
Для получения модели в формате coreml (```/CatBoost test/WalkingModel.mlmodel```) были получены данные о состоянии хотьбы. Файл, с помощью которого было произведено обучение, и ноутбук с обучением модели CatBoostClassifier и сохранением в формат coreml находится в папке  ```model_train```.

# Логика приложения
Вся логика единственного экрана реализована в ```CatBoost test/ViewController.swift```.
