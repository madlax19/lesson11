# Lesson 11 Multithreading, Concurrency

Читаем:
1. 

1. Concurrency Programming Guide https://developer.apple.com/library/ios/documentation/General/Conceptual/ConcurrencyProgrammingGuide/ConcurrencyandApplicationDesign/ConcurrencyandApplicationDesign.html#//apple_ref/doc/uid/TP40008091-CH100-SW1
2. Matt Neuburg - Programming iOS 7, 4th Edition - 2013 Раздел 25 Threads
3. Grand Central Dispatch In-Depth Parts 1,2 http://www.raywenderlich.com/60749/grand-central-dispatch-in-depth-part-1 http://www.raywenderlich.com/63338/grand-central-dispatch-in-depth-part-2
4. Common Background Practices https://www.objc.io/issues/2-concurrency/common-background-practices/

Домашнее задание:
1. 

1. Задача, расчитывать и выводить в таблицу каждое 10-е число Фибоначчи. Расчет чисел Фибоначчи должен происходить в отдельном потоке используя Grand Central Dispatch, добавление значений в таблицу должно происходить в главном потоке с помощью методов UITableView -beginUpdates -insertRowAtIndex: -endUpdates. Для просчета чисел Фибоначчи используйте NSDecimalNumber и метод -decimalNumberByAdding:
2. Скопировать предыдущее задание, но реализовать многопоточность с помощью NSOperation и NSOperationQueue.
3. Создайте массив заполненый ссылками на 10 картинок. Реализуйте с помощью Grand Central Dispatch и [NSData dataWithContentsURL:] последовательную загрузку картинок и выводит их на в UIImageView, после каждой загрузки картинок выводите время загрузки текущей картинки, после загрузки всех картинок выведите суммарное время. С помощью dispatch_get_global_queue загрузите эти картинки многопоточно, выведите суммарное время загрузки используя приоритет очереди DISPATCH_QUEUE_PRIORITY_BACKGROUND и DISPATCH_QUEUE_PRIORITY_HIGH. С помощью NSOperationQueue, NSOperation и [NSOperation addDependency:] реализуйте загрузку картинок из массива с условиями: NSOperationQueue может выполнять только 2 запроса одновременно, парные и непарные картинки зависят друг от друга, тоесть третья картинка может начать загружаться только после загрузки первой, пятая после третьей и тд (1<-3<-5<-7<-9, 0<-2<-4<-6<-8). Выведите суммарное время загрузки картинок.
