## Описание

**Today is** — это стратегическая игра, в которой вы выступаете в роли редактора городской газеты. Ваша задача — расставлять сгенерированные искусственным интеллектом заголовки новостей по степени важности: от первой полосы до четвертой. Каждая новость отмечена знаком "+" или "-", показывающим, принесёт ли она положительный или отрицательный эффект для вашей репутации среди фракций города: общественности, полиции, мафии и спецслужб.Отношение каждой фракции к вам отображается в интерфейсе. Если отношение какой-либо фракции опустится до -20, игра завершится. Ваши решения влияют на баланс сил в городе и развитие событий, а каждая партия становится уникальной благодаря процедурной генерации новостей.


<img src="https://s01.pic4net.com/di-MCMD2U.png" width="40%" />
<img src="https://s01.pic4net.com/di-2YYRRM.png" width="40%" />


## Требования

- Windows 10/11
- [Love2D 11.4+](https://love2d.org/) (для запуска .love-файла вручную)
- Python 3.10+
- Установленные Python-библиотеки:  
  `torch`, `transformers`
- Наличие обученной модели в папке `model/trained_model/`  
  (файлы скачиваются через Git LFS)

---

## Установка и запуск

1. **Клонируйте репозиторий с поддержкой Git LFS и файлы из releases:**

   ```sh
   git lfs clone https://github.com/hadder10/today-is-game.git
   ```

2. **Установите Python-зависимости:**

   ```sh
   pip install torch transformers
   ```

3. **Запустите игру:**
   - Перед запуском игры вручную запустите model/server.py
   - Двойным кликом по `game.exe`  
     **или**
   - Откройте `game.love` через Love2D

---

**Приятной игры!**
