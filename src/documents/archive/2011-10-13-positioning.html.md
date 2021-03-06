---
title: "Нюансы позиционирования, часть первая"
author: Роман Комаров
tags: [CSS, вёрстка, позиционирование]
---

CSS-Свойство `position` должно быть знакомо всем: оно, со своими наиболее часто используемыми значениями `relative` и `absolute`, используется верстальщиками каждый день. Однако существует довольно много вещей, которые могут быть не очевидны из [спецификаций][1] или которые по тем или иным причинам используются редко. Это первая часть статьи: в ней мы рассмотрим базовые моменты позиционирования, а в следующий раз расскажем о более сложных понятиях.

## Основы

У свойства `position` существует несколько значений, которые заметно отличаются друг от друга:

* `position: relative` — относительное позиционирование; во-первых, оно создаёт контекст для последующего абсолютного позиционирования, во-вторых, в сочетании со свойством `z-index` оно создаёт стековый контекст. Подробнее про `z-index` будет рассказано в следующей статье.

* `position: absolute` — абсолютное позиционирование; делает всё то же, что и относительное, но если добавление относительного позиционирования не влияет на поток, то добавление абсолютного — вырывает блок из потока. При использовании свойств `left`, `top`, `bottom` или `left` блок с абсолютным позиционированием располагается относительно ближайшего блока с заданным контекстом позиционирования.

* `position: fixed` — фиксированное позиционирование; работает аналогично абсолютному, но контекстом позиционирования почти всегда будет viewport браузера.

* `position: static` — позиционирование по умолчанию; по сути, это отсутствие позиционирования, блок не создаёт ни контекст, ни подвергается влиянию свойств, которые работают при других значениях `position`.

## top, bottom, right и left [<sup>пример</sup>][3]

Главные свойства-спутники любого явно заданного позиционирования (так мы будем называть значение свойства `position`, отличное от `static`) — это `top`, `right`, `bottom` и `left`.

Для относительного позиционирования эти свойства задают смещение относительно изначального положения блока, то есть блок остаётся в потоке, продолжает занимать то же место, что и занимал до этого, но визуально смещается в зависимости от заданных свойств. Так, задание `left:10px` сместит блок на 10 пикселей правее.

При относительном позиционировании одновременно может работать только одно свойство из пар `top`/`bottom` и `left`/`right`. Если будут заданы оба свойства из этих пар, то будет применяться только первое, то есть приоритет всегда будет за `top` и `left`, при этом порядок свойств в правиле будет не важен, но если возникнет необходимость в новом правиле использовать, например, `top`, а не `bottom`, это можно будет сделать, задав для `top` значение `auto`.

Для абсолютного позиционирования эти четыре свойства работают совсем иначе — вместо смещения они задают соответствующую «границу» позиционирования, например, задание только `top:10px` расположит блок так, что его верхняя граница будет находиться в десяти пикселях от верхней границы ближайшего блока с заданным контекстом позиционирования.

А вот если у блока нет явно заданной ширины или высоты, то одновременное задание свойств из пар `top`/`bottom` и `left`/`right` «растянет» блок так, что его границы будут находиться на заданных значениях относительно блока с контекстом позиционирования.

Подобное поведение абсолютно позиционированных блоков работает везде, начиная с IE7. Если вы уже не поддерживаете шестую версию IE, то можно безбоязненно использовать это поведение — оно может быть довольно полезно во многих ситуациях, например, его удобно применять для раскладок «веб-приложений», копирующих интерфейс десктопных программ. [Пример такой раскладки][3]

## Контекст позиционирования [<sup>пример</sup>][4]

«Контекст позиционирования» необходим для того, чтобы понимать, относительно чего будут расположены абсолютно позиционируемые блоки.

### Отсутствие контекста позиционирования

Если для блока с абсолютным позиционированием не задано ни одно из свойств пар `top`/`bottom` и `left`/`right`, то блок будет спозиционирован относительно того места, где он должен был быть в потоке, если бы он не был из него изъят. Так, если блок был cо строковым поведением (`display: inline`) и находился в строковом контексте, то он будет спозиционирован на той же строке, где он был бы, если бы не был вырван из потока. А если у этого блока было блочное поведение или же он располагался после блока с блочным поведением, то он будет находиться на новой строке.

Блок, спозиционированный таким образом, можно двигать при помощи свойства `margin`, например, задав `margin-top:-10px` блок будет спозиционирован на 10 пикселей выше того места, где он был бы, если бы не был вырван из потока.

### Позиционирование с контекстом

Если же блок позиционируется с заданием какого-либо из свойств пар `top`/`bottom` и `left`/`right`, то он будет спозиционирован относительно ближайшего блока с контекстом позиционирования, который появляется при явно заданном позиционировании.

Тут важно заметить, что не для всех блоков может существовать контекст: например, для ячеек (и строк) таблицы нельзя задать контекст, то есть если возникнет желание позиционировать что-то внутри таблицы, то придётся добавлять для этого дополнительные элементы.

Кроме того, можно комбинировать позиционирование с контекстом и без. Например, если взять строчный элемент в потоке текста, то задав ему абсолютное позиционирование и свойство `left`, мы спозиционируем его по горизонтали относительно ближайшего контекста, однако по вертикали у него не будет контекста, и он будет расположен на той строке, где должен был быть расположен без позиционирования. 

Пример различных вариантов блока, позиционируемого без задания явных границ позиционирования, можно посмотреть [здесь][4].

## Продолжение следует

В этой статье мы рассмотрели основы позиционирования: возможные свойства и понятие контекста. В следующей статье мы затронем тему `z-index` и практического применения его отрицательных значений, свойство `clip`, а также различные особенности и ошибки браузеров при работе с позиционированием.

Кроме того, если у вас остались какие-либо вопросы по этой статье или пожелания по следующей — оставьте их в комментариях, будем рады ответить или разъяснить что-то дополнительно.

[1]: http://www.w3.org/TR/CSS2/visuren.html#absolute-positioning
[3]: http://yandex-ui.github.com/Examples/positioning/
[4]: http://yandex-ui.github.com/Examples/positioning/context/
