---
title: "yaTouchSlider — слайдер для тач-устройств"
author: "Кирилл Белевич"
tags: [JavaScript, мобильные технологии]
---

На многих известных нам мобильных сайтах для тач-устройств слайдеры (листалки) устроены так, что анимация происходит уже после свайп-жеста, после того как человек убрал палец. Это не так красиво и не так удобно, как в нативных слайдерах, например, на главных экранах iOS-устройств.

[![QR-код на результаты поиска по слову «Погода»][1]][2]

Мы сделали jQuery-плагин, который помогает сделать слайдер похожим на нативный, и хотим поделиться им со всеми заинтересованными. Посмотреть на работу плагина можно, например, в ответе погоды или картинок на [новой странице результатов поиска][2] для iPhone и iPod Touch.

В отличие от обычного CSS3 Transform, «3D» задействует аппаратное GPU ускорение в iOS. Это позволяет добиться очень плавной и приятной анимации. Сама тема аппаратного ускорения анимации достаточно обширна, в будущем на эту тему будет отдельная статья.

Чтобы слайдер ощущался нативным, мы учли множество мелочей:

* если свайп-жест длинный, сразу на несколько пунктов, то слайдер это поймёт;
* если свайпнуть меньше, чем на один шаг, при этом не преодолев заданный порог (по умолчанию 30 пикселей), то слайдер «отпружинит» назад;
* слайдер так же отпружинит назад при попытке свайпнуть за левый или правый предел.

## Зависимость от скорости жеста

Чтобы слайдер вёл себя более живо и соответствовал ожиданиям от жеста, мы научили его понимать ускорение. Оно рассчитывается по следующей формуле (условия и значения для неё подбирались экспериментально):

    accel = speed > 0.3 && speed < 0.6 ? 2 :
    speed >= 0.6 && speed < 1 ? 3 :
    speed >= 1 ? 4 :
    1;

Где speed — расстояние от начала до конца свайп-жеста, делённое на его время (школьные знания «v = s / t» наконец-то пригодились :)

Среднестатистический свайп-жест — примерно <nobr>0.4-0.6</nobr> пикселей в миллисекунду. Есть совсем небольшой, но всё же заметный разброс во времени анимации CSS Transition:

    animationTime = accel >= 3 ? '0.3' : '0.2';

После него шаг умножается на значение акселерации и происходит анимация.

## Внешнее API

При навешивании слайдера на блок можно указать callback-функцию. Она будет вызываться при каждом свайпе с пробрасываемым набором всех необходимых данных — скорость, шаг, пределы, время и прочее. Также слайдер можно подвинуть и без помощи пальца, затриггерив на блок слайдера события `slideLeft([шаг])` или `slideRight([шаг])`.

## “Fork us on GitHub”

Посмотреть или скачать код плагина с комментариями можно [в репозитории проекта на Гитхабе][3].

[1]: http://img-fotki.yandex.ru/get/5112/1076905.1/0_60dfe_1b30ce61_orig
[2]: http://yandex.ru/touchsearch?text=Погода
[3]: https://github.com/yandex-ui/yaTouchSlider