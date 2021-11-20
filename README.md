# users_api_on_rails

API веб приложение для работы с данными
пользователей. Поддерживает функционал получения, создания,
редактирования и удаления данных.
Предметная область
Пользователь может создавать, редактировать, удалять,
запрашивать информацию о контактах.
Контакт состоит из:
1) Номер телефона (phone)
2) Фамилия (first_name)
3) Имя (last_name)
4) Дата рождения (date_of_birth)
5) Комментарий (comment)
При любом запросе к данным должна производится проверка
на специальном сервисе. Проверяющий сервис должен получить
номер телефона и тип запроса пользователя. Проверяющий
сервис может одобрить или запретить выполнение запроса. В
случае одобрения, приложение продолжает выполнение
обработки запроса пользователя. В случае отказа, обработка не
продолжается, пользователь получает сообщение об ошибке
доступа.


