# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Item.create([
    {name: 'Большое с бордюром коричневое', full: 'Полотенце махровое коричневое 150-75 с бордюром', art: 'BRO-B-150-75', box: 10, num: 1, technic: nil},
    {name: 'Большое с бордюром белое', full: 'Полотенце махровое белое 150-75 с бордюром', art: 'WHI-B-150-75', box: 10, num: 1, technic: nil},
    {name: 'Большое синее', full: 'Полотенце махровое синее 150-75', art: 'BLU-N-150-75', box: 10, num: 1, technic: nil},
    {name: 'Большое красное', full: 'Полотенце махровое красное 150-75', art: 'RED-N-150-75', box: 10, num: 1, technic: nil},
    {name: 'Большое зеленое', full: 'Полотенце махровое зеленое 100-75', art: 'GRE-N-100-75', box: 10, num: 1, technic: nil},
    {name: 'Среднее с бордюром белое', full: 'Полотенце махровое белое 100-50 с бордюром', art: 'WHI-B-100-50', box: 15, num: 1, technic: nil},
    {name: 'Среднее с бордюром коричневое', full: 'Полотенце махровое коричневое 100-50 с бордюром', art: 'BRO-B-100-50', box: 15, num: 1, technic: nil},
    {name: 'Среднее c принтом красное', full: 'Полотенце махровое красное 100-75', art: 'RED-P-100-75', box: 15, num: 1, technic: nil},
    {name: 'Среднее с принтом коричневое', full: 'Полотенце махровое коричневое 100-75', art: 'BRO-P-100-50', box: 15, num: 1, technic: nil},
    {name: 'Среднее с принтом синее', full: 'Полотенце махровое синее 100-75 с принтом', art: 'BLU-P-100-75', box: 15, num: 1, technic: nil},
    {name: 'Среднее красное', full: 'Полотенце махровое красное 100-75', art: 'RED-N-100-75', box: 15, num: 1, technic: nil},
    {name: 'Среднее синее', full: 'Полотенце махровое синее 100-75', art: 'BLU-N-100-75', box: 20, num: 1, technic: nil},
    {name: 'Малое с бордюром коричневое', full: 'Полотенце махровое коричневое 75-50 с бордюром', art: 'BRO-B-75-50', box: 20, num: 1, technic: nil},
    {name: 'Малое с бордюром белое', full: 'Полотенце махровое белое 750х50 с бордюром', art: 'WHI-B-75-50', box: 20, num: 1, technic: nil},
    {name: 'Малое синее', full: 'Полотенце махровое синее 75-50', art: 'BLU-N-75-50', box: 20, num: 1, technic: nil},
    {name: 'Малое красное', full: 'Полотенце махровое красное 75-50', art: 'RED-N-75-50', box: 20, num: 1, technic: nil},
    {name: 'Вафельное малое белое', full: 'Полотенце вафельное белое 100-50', art: 'WHI-V-100-50', box: 30, num: 1, technic: nil},
    {name: 'Салфетка белая', full: 'Салфетка махровая белая 30-30', art: 'WHI-N-30-30', box: 100, num: 1, technic: nil},
    {name: 'Салфетка красная', full: 'Салфетка махровая красная 30-30', art: 'RED-N-30-30', box: 100, num: 1, technic: nil},
    {name: 'Салфетка коричневая', full: 'Салфетка махровая коричневая 30-30', art: 'BRO-N-30-30', box: 100, num: 1, technic: nil},
    {name: 'Салфетка синяя', full: 'Салфетка махровая синяя 30-30', art: 'BLU-N-30-30', box: 100, num: 1, technic: nil},
    {name: 'Простыня махровая коричневая', full: 'Простыня махровая коричневая 175-175', art: 'BRO-B-175-175', box: 2, num: 1, technic: nil}
])
User.create(email: 's@serafimov.ru', password: '7773', region: 1, name: 'Sergey S.', address: 'Thailand, Phuket, Soi Tokdum, 53/41', type_owner: 'admin')
