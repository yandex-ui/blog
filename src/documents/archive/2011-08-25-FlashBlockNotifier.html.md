---
title: "Как определить наличие FlashBlock в браузере"
author: Алексей Андросов
tags: [Flash, JavaScript]
---

При вставке флеш-ролика мы, как правило, пользуемся [swfobject][1]. С помощью этого скрипта можно не только правильно вставить на сайт флеш-ролик с учетом браузера, но и определить наличие и версию флеш-плеера. Последнее нужно для того, чтобы интерфейс сайта показывал пользователю уведомление о том, что у него нет флеш-плеера или он устарел.

И все же сейчас этого не достаточно, так как флеш-плеер может быть установлен, но заблокирован flashblock-расширениями. Эти ситуации надо тоже определять и, в зависимости от роли флеш-объекта, либо показывать уведомление, либо автоматически изменять интерфейс (например, если флеш используется в качестве транспорта, то можно деградировать на безфлешевую версию).

Для этих целей был написан [FlashBlockNotifier][2]. Это обертка для метода `swfobject.embedSWF`, которая после вставки флеш-объекта проверяет, не заблокирован ли он. Синтаксис функции `FlashBlockNotifier.embedSWF` идентичен синтаксису `swfobject.embedSWF`.

## Пример использования

Чтобы обработать наличие flashblock, надо в callback-фукнции `FlashBlockNotifier.embedSWF` проверять свойства `success` и `__fbn`.

`success` — стандартное свойство swfobject, означающее удалось ли вставить флеш-объект на страницу. Оно будет равно `true`, если в браузере установлен флеш-плеер необходимой версии и ролик не заблокирован. Во всех остальных случаях будет `false`.

`__fbn` — свойство, добавляемое FlashBlockNotifier и означающее, что вставка флеш-объекта не удалась из-за flashblock.

    <script src="//yandex.st/swfobject/2.2/swfobject.min.js">
    <script src="FlashBlockNotifier.js">
    <p>
        <span id="result" style="padding: 5px;">
            <span>Result:
            <span id="result_text">
        </span>
    </p>
    <div id="flash_is_here" style="width:425px;height:356px;">
    <script>
        FlashBlockNotifier.embedSWF(
                'http://www.youtube.com/v/rctdMX_qlMw?enablejsapi=1&playerapiid=ytplayer',
                'flash_is_here',
                425,
                356,
                '8.0.0',
                null,
                null,
                { allowScriptAccess: "always" },
                { id: "myytplayer" },
                function(e) {
                    var res = '';
                    var color = '';
                    if (e.success) {
                        res = 'no FlashBlock';
                        color = '#BFB';

                    } else if (!e.success && e.__fbn) {
                        res = 'FlashBlock detected';
                        color = '#BBF';

                    } else {
                        res = 'Flash is not installed';
                        color = '#FBB';
                    }
                    document.getElementById('result_text').innerHTML = res;
                    document.getElementById('result').style.background = color;
                }
        );
    </script>

[Попробовать пример][3]

## Как это работает?

Все расширения работают по схожим принципам: видоизменяют вставленный тег `<object>` или оборачивают его. Поэтому, чтобы определить блокировку флеша, надо после вставки проверить, работает ли вставленный флеш-ролик. В разных браузерах это происходит по разному.

- В Opera 11.5 появилась настройка «Включать плагины только по запросу». Opera заменяет флеш на svg-рисунок, при этом сама нода никак не меняется, за исключением маленького момента: у нее есть функция `getSVGDocument`, и она возвращает не-null значение. Эту проверку можно делать сразу после вставки флеш-ролика.

        if (swfNode && swfNode['getSVGDocument'] && swfNode['getSVGDocument']()) {
            // Opera flashblock detected
        }

Чтобы правильно определить flashblock в браузерах Chrome, Firefox и Safari, надо сделать две вещи:

1. Обернуть будущий объект с flash в пустой `div` (FlashBlockNotifier сделает это автоматически). Это нужно, так как некоторые плагины скрывают исходный флеш, а рядом с ним создают новый элемент.
2. После вставки сделать таймаут, чтобы дать возможность отработать расширению.

Рассмотрим, как они работают:

- [Firefox FlashBlock][4] и [Chrome FlashFree][5] заменяют тег `<object>` на свою собственную обертку и удаляют его из DOM-дерева, поэтому его можно легко определить, проверив значение `parentNode`

        if (!swfNode.parentNode) {
            // flashblock
        }

- [Chome FlashBlock от Lex1][6] и [Chome FlashBlock от josorek][7] создают рядом с флеш свои элементы, поэтому они определяются по изменению числа детей у `div`-обертки

        if (wrapperNode.childNodes.length > 1) {
          //flashblock
        }

- [Safari ClickToFlash][8] оборачивает флеш в свою обертку, ее можно определить по классу `CTFnodisplay`

        if (swfNode.parentNode.className.indexOf('CTFnodisplay') > -1) {
          // safari flashblock
        }

## “Fork us on GitHub”

FlashBlockNotifier распространяется под свободными лицензиями GPL и MIT. Посмотреть или скачать код с комментариями можно [в репозитории проекта на Гитхабе][2].

[1]: http://code.google.com/p/swfobject/
[2]: https://github.com/doochik/FlashBlockNotifier
[3]: http://doochik.github.com/FlashBlockNotifier/
[4]: https://addons.mozilla.org/ru/firefox/addon/flashblock/
[5]: https://chrome.google.com/webstore/detail/ebmieckllmmifjjbipnppinpiohpfahm
[6]: https://chrome.google.com/webstore/detail/cdngiadmnkhgemkimkhiilgffbjijcie
[7]: https://chrome.google.com/webstore/detail/gofhjkjmkpinhpoiabjplobcaignabnl
[8]: http://hoyois.github.com/safariextensions/clicktoplugin/
