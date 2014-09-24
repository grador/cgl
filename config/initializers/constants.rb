  ACTIVE = 1
  INACTIVE = 0
  TIME_X = 12
  ADMIN = 'admin'
  USER = 'user'
  EXPEDITOR = 'expeditor'
  TESTER ='tester'
  ALL = 'all'
  FIRM_NAME = 'ООО Удача'
  SITE_URL  = 'http://callgoodluck.com'
  SITE_NAME = 'callgoodluck.com'
  ADMIN_EMAIL = 'ser.serafimov@mail.ru'
  DEPOT_EMAIL = 'ser.serafimov@mail.ru'
  AUTO_EMAIL =  'inbox@callgoodluck.com'
  REPEAT_REQUEST = ' Повторите запрос позже.'
  ALERT_STRING = 'Нарушена структура данных! Сообщите Администратору.'
  # Подсветка полей ввода по цвету изделий
  # для исключения путаницы при выборе изделий
  # типичная ошибка - "Ой я не тот цвет заказала!"
  # определяется по первым трем символам артикула изделия.
  SOME_COLORS = {
  'NON' => 'Gainsboro',   # не определен
  'BRO' => 'BurlyWood',   # коричневый
  'BLU' => 'LightBlue',   # синий
  'RED' => 'pink',        # красный
  'WHI' => 'GhostWhite',  # белый
  'GRE' => 'lightgreen',  # зеленый
  'YEL' => 'yellow',      # желтый
  'ORA' => 'orange',      # оранжевый
  'VIO' => 'violet',      # фиолетовый
  'BIE' => 'papayawhip'   # бежевый
  }
  # размеры тела таблиц по высоте без скроллинга
  TBODY_LONG = 17
  TBODY_SHORT = 10
  TBODY = 5
  # Ограничения на количество коробок в заказе
  # из расчета 1 заказ может быть только в одной машине.
  MAX_Q_ORDER = 210
  # Ограничения на количество коробок одного наименования в заказе
  MAX_Q_LOT = 200
  # размеры полей в формах в символах
  EMAIL_FIELD = 30
  NAME_FIELD = 30
  FULL_FIELD = 50
  ART_FIELD = 12
  BOX_FIELD = 5
  Q_FIELD = 12
  TYPE_USER = [ADMIN, USER, EXPEDITOR, TESTER]
  VERB = { index:'GET', show:'GET', new:'GET', create:'POST', update:'PATCH', edit:'GET', destroy:'DELETE'}
