### Що таке вектор
У математиці вектор - індексована сукупність чисел або інших математичних обєктів( х1,х2,...xn ), яка має певні властивості, що дозволяють виконувати над вектором різні математичні операції: додавання, віднімання, множення на скаляр тощо. У вигляді вектора можна позначати положення, швидкість, прискорення, і тп. Зручність вектору полягає в можливості оперувати великою кількістю чисел як одним обєктом. В інформатиці вектор прийнято представляти у вигляді одновимірного масиву.

### wVector
wVector - пакет, що реалізує вектор. wVector дозволяє оперувати векторами через обгортки до даних.
Обгортки не містять безпосередньо даних, а лише метадані такі, як наприклад, початок, кінець вектора в масиві, лінк на масив із даними.
Доступ до інтерфейсу для роботи із векторами здійснюється через неймспейс ```wTools.vector``` та ```wTools.avector.```.

### wVector

### Створення обгортки
wTools.vector.from свторює обгортку вектора із масиву.

```javascript
var a1 = [ 1, 2, 3 ];
var v1 = wTools.vector.from( a1 );
console.log( vector );
console.log( vector.toStr() );
```
Змінна ```v1``` стала обгорткою вектора, тепер над нею можна здійснювати векторні операції.
Метод toStr повертає вміст вектора у вигляді стрічки

### Довжина вектора

Довжина вектора міститься в полі length кожної обгортки.

```javascript
var avector = [ 1, 2, 3 ];
var v1 = wTools.vector.from( a1 );
console.log( vector.length )
```
Довжина вектора відповідає кількості елементів у звязаному із ним контейнері.

### Зміна даних

ххх

```javascript
var avector = [ -1, -1, -1 ];
var vector = wTools.vector.from( avector )
wTools.vector.abs( vector );
console.log( avector );
console.log( vector.toStr() );
```

Вивід змінної vector підтверджує, що вона повязана із масивом avector.

Результат виконання операцій над вектором зберігається у контейнері поєднаному із обгорткою.
wTools.vector.abs заміняє відємні значення вектору додатніми.

```javascript
var avector = [ -1, -1, -1 ];
var vector = wTools.vector.from( avector )
wTools.vector.abs( vector );
console.log( vector.toStr() );
console.log( avector );
```
Результат виконання abs зберігається в масиві ```avector```;

### Виконання математичних операцій

Найпростішою операцією над векторами є додавання.
wTools.vector.add додає вектори.

```javascript
var a1 = [ 1, 1, 1 ];
var a2 = [ 1, 1, 1 ];
var v1 = wTools.vector.from( a1 );
var v2 = wTools.vector.from( a2 );
var result = wTools.vector.add( v1, v2 );
console.log( result.toStr() );
```
Результатом виклику add є обгортка що містить результат додавання векторів v1 та v2.
Рутина toStr() повертає вміст контейнеру з яким звязана обгортка у вигляді стрічки.


Першою особливістю рунити add є можливість роботи із безліччю векторів.
wTools.vector.add може додавати два та більше векторів.

```javascript
var a1 = [ 1, 1, 1 ];
var a2 = [ 1, 1, 1 ];
var a3 = [ 1, 1, 1 ];
var v1 = wTools.vector.from( a1 );
var v2 = wTools.vector.from( a2 );
var v3 = wTools.vector.from( a3 );
var result = wTools.vector.add( v1, v2, v3 );
console.log( result.toStr() );
```
Тепер змінна result є вектором що містить суму векторів v1, v2 та v3.


Друга особливість - wTools.vector.add зберігає результат у векторі що переданий першим аргументом.
Збережемо результат додавання у третьому векторі.

```javascript
var a1 = [ 1, 1, 1 ];
var a2 = [ 1, 1, 1 ];
var a3 = [ 1, 1, 1 ];
var v1 = wTools.vector.from( a1 );
var v2 = wTools.vector.from( a2 );
var v3 = wTools.vector.from( a3 );
var result = wTools.vector.add( v3, v1, v2 );
console.log( 'a1: ', a1 );
console.log( 'a2: ', a2 );
console.log( 'a3: ', a3 );

console.log( 'result: ', result.toStr() );
console.log( 'v3: ', v3.toStr() );
console.log( result === v3 );
```
Вектори v1 та v2 залишились без змін, проте v3 тепер зберігає результат додавання,
що підтверджує вивід вмісту контейнерів. Результатом add є посилання на v3.


wTools.vector.add може повертати результат у новому векторі.

```javascript
var a1 = [ 1, 1, 1 ];
var a2 = [ 1, 1, 1 ];
var v1 = wTools.vector.from( a1 );
var v2 = wTools.vector.from( a2 );
var result = wTools.vector.add( null, v1, v2 );
console.log( 'result: ', result.toStr() );

console.log( 'a1: ', a1 );
console.log( 'a2: ', a2 );
```

Виклик add повертає результат у новому векторі, якщо першим аргументом передано null.
Вміст контейнерів a1, a2 не змінюється.


wTools.vector.add окрім векторів приймає скаляри - дійсні числа.

```javascript
var a1 = [ 1, 1 ];
var v1 = wTools.vector.from( a1 );
wTools.vector.add( v1, 3 );
console.log( 'v1: ', result.toStr() );
```
Скаляр переданий в рутину add векторизуються, тобто перетворюються у вектор та заповнюються значенням скаляру до необхідної довжини.
Виклик wTools.vector.add( v1, 3 ) є рівноцінний додаванню векторів ( 1, 1 ) та ( 3, 3 ).

wTools.vector.add працює лише із векторами однакової довжини

```javascript
var a1 = [ 1, 1 ];
var a2 = [ 1, 1, 1 ];
var v1 = wTools.vector.from( a1 );
var v2 = wTools.vector.from( a2 );
wTools.vector.add( v1, v2 );
```
Виклик add завершиться із помилкою, тому всі вектори повинні однакову довжину.

<!-- Використовуючи wVector додавання можна виконати наступним чином:

```javascript
// Підготуємо два масиви, що містять дані векторів
var a1 = [ 1, 0, 1 ];
var a2 = [ 0, 1, 0 ];
// Створимо вектор-обгортку для кожного із масивів
var v1 = wTools.vector.from( a1 );
var v2 = wTools.vector.from( a2 );
// Викликаємо рутину add і передаємо наші обгортки
// В результаті отримуємо вектор-обгортку із результатом обчислення
var vector = wTools.vector.add( v1, v2 );
// Виведемо результат
console.log( 'vector: ', vector.toStr() );
```

Специфіка роботи рунити add є такою, що коли першим аргументом переданим в add є вектор, то він буде використаний розміщення результату обчислення.
Продемонструємо це модифікувавши попередній приклад:

```javascript
// Підготуємо два масиви, що містять дані векторів
var a1 = [ 1, 0, 1 ];
var a2 = [ 0, 1, 0 ];
// Створимо вектор-обгортку для кожного із масивів
var v1 = wTools.vector.from( a1 );
var v2 = wTools.vector.from( a2 );
// Викликаємо рутину add і передаємо наші обгортки
// В результаті отримуємо вектор-обгортку із результатом обчислення
var vector = wTools.vector.add( v1, v2 );
// Виведемо вміст контейнерів, із виводу видно що результат було записано у перший контейнер
console.log( 'vector: ', vector.toStr() );
console.log( 'a1: ', a1 );
console.log( 'a2: ', a2 );
```

Виникає питання, що робити, коли необхідно зберегти початкові значення. Для цього випадку рутина add надає нам можливість створювати нову обгортку, яка і буде містити результат операції. Зробити це дуже просто, необхідно передати першим аргументом null:

```javascript
// Підготуємо два масиви, що містять дані векторів
var a1 = [ 1, 0, 1 ];
var a2 = [ 0, 1, 0 ];
// Створимо вектор-обгортку для кожного із масивів
var v1 = wTools.vector.from( a1 );
var v2 = wTools.vector.from( a2 );
// Викликаємо рутину add і передаємо null першим аргументом для того щоб створити нову обгортку для результату
var vector = wTools.vector.add( null, v1, v2 );
console.log( 'vector: ', vector.toStr() );
// Контейнери вхідних обгорток залишились без змін
console.log( 'a1: ', a1 );
console.log( 'a2: ', a2 );
``` -->







<!-- Вектор може бути представлений у двох видах:

avector - у вигляді одновимірного масиву, який автоматично перетворюється у вектор в момент виконання матем. операцій.
vector - у вигляді обгортки над ```avector```, яка використовує переданий при створенні масив( avector ) як контейнер для зберігання даних.

Виконання базових математичний операцій над векторами з допомогою wVector відобразимо на прикладі операції додавання:

Слід зазначити що для кожного представлення векторів необхідно використовувати окрему реалізація рутини add.
Для векторів у вигляді одновимірного масиву avector - wTools.avector.add.
Для обгортки vector - wTools.vector.add.

Рутина add працює наступним чином - спочатку перевіряє чи передані вектори мають однакову довжину, а далі додає елементи векторів з однаковими індексами та зберігає результат у векторі, який був переданий першим аргументом, якщо такий існує. Якщо перший аргумент є скаляром або був переданий як null, тоді результат буде збережено у новому векторі, для якого буде створено окремий контейнер. За аналогічним принципом працюють рутини: sub,mul та div.

Додавання векторів типу avector та збереження результату у першому векторі:

```javascript
var a1 = [ 1, 2, 3 ];
var a2 = [ 1, 2, 3 ];
var a3 = [ 1, 2, 3 ];
var avector = wTools.avector.add( a1, a2, a3 );
console.log( 'avector: ', avector );
console.log( 'a1:', a1 );
```

Додавання векторів типу avector та скалярів:
Якщо аргументом є скаляр його буде перетворено у вектор, а передане число заповнить його до необхідної довжини.

```javascript
var a1 = [ 0, 0, 0 ];
var a2 = [ 0, 0, 0 ];
var a3 =  5;
var a4 =  7;
var vector = wTools.avector.add( a1, a2, a3, a4 );
console.log( 'avector: ', avector );
console.log( 'a1:', a1 );
```

Додавання авекторів та  скалярів із збереженням результату у новому векторі:
Якщо першим аргументом є скаляр або null, результат додавання буде повернуто у новому векторі:

```javascript
var a1 = [ 0, 0, 0 ];
var a2 = [ 0, 0, 0 ];
var a3 =  5;
var a4 =  7;
var vector = wTools.avector.add( null, a1, a2, a3, a4 );
console.log( 'avector: ', avector );
console.log( 'a1:', a1 );
```

Зручність використання вектора обгортки заключається в можливості використання єдиного масиву як контейнеру що зберігає дані кожного із векторів:
В реалізації даної можливості нам допоможе рутина fromSubArray, яка створює вектор на основі певної частини переданого контейнера.

```javascript
var a = [ 0, 0, 1, 1, 2, 2 ];

var v1Offset = 0;
var v1Length = 3;
var v1 = wTools.vector.fromSubArray( a, v1Offset, v1Length );

var v2Offset = v1Length;
var v2Length = 3;
var v2 = wTools.vector.fromSubArray( a, v2Offset, v2Length );

var vector = wTools.vector.add( v1, v2 );

console.log( 'vector: ', vector );
console.log( 'v1: ', v1 );
console.log( 'a: ', a );
```

Для використання всього масиву як контейнеру використаємо рутину from:
```javascript
var avector = [ 1, 2, 3 ];
var vector = wTools.vector.from( avector );
console.log( vector )
```

Для доступу до даних із обгортки необхідно використати рутини eGet та eSet:

Для отримання значення n-го елементу вектору викликаємо eGet:
```javascript
var avector = [ 1, 2, 3 ];
var vector = wTools.vector.from( avector );
console.log( vector.eGet( 0 ) )
```

Для зміни значення n-го елементу вектору викликаємо eSet:
```javascript
var avector = [ 1, 2, 3 ];
var vector = wTools.vector.from( avector );
vector.eSet( 0, 5 );
console.log( avector )
``` -->