-- ProbablyEngine Rotations - [url=https://probablyengine.com/]https://probablyengine.com/[/url]
-- Released under modified BSD, see attached LICENSE.

local pels = ProbablyEngine.locale.set

ProbablyEngine.locale.new('ruRU')

-- Buttons
pels('toggle', 'Включить/Выключить')
pels('toggle_tooltip', 'Включить/Выключить ротацию.')
pels('cooldowns', 'Кулдауны')
pels('cooldowns_tooltip', 'Включить/Выключить использование длинных кулдаунов.')
pels('multitarget', 'Мульти-таргет')
pels('multitarget_tooltip', 'Включить/Выключить использование Мульти-таргет способностей.')
pels('interrupt', 'Прерывания')
pels('interrupt_tooltip', 'Включить/Выключить прерывание заклинаний.')
pels('drag_to_position', 'Переместить')

-- Buttons Menu
pels('rtn_default', 'Стандартные Ротации')
pels('rtn_custom', 'Загруженные Ротации')
pels('rtn_switch', 'Ротация переключена на: ')
pels('rtn_nocustom', 'Нет Загруженных Ротаций')

-- General
pels('left_click', 'Левый клик')
pels('right_click', 'Правый клик')
pels('drag', 'Перетащить')
pels('rotation_loaded', ' ротация загружена!')

-- Minimap
pels('open_config', 'открывает меню настроек')
pels('unlock_buttons', 'переключает блокировку фреймов')
pels('move_minimap', 'что бы сдвинуть кнопку у миникарты')

-- Combat Tracker
pels('est', 'Примерно') -- Estimated
pels('na', 'Недоступно') -- not/available
pels('k', 'k') -- Thousands postfix
pels('all_units', 'Все цели')
pels('combat_tracker', 'Трекер боя')
pels('ttd', 'TTD') -- Time To Death shorthand
pels('hpr', 'HPR') -- Health Points Remaining shorthand

-- commands
pels('running_version', 'Вы используете версию')
pels('build', 'версия')
pels('help_cycle', 'Ручной цикл ротации.')
pels('help_toggle', 'Включить/Выключить ротацию.')
pels('help_ct', 'Показать трекер боя.')
pels('help_al', 'Показать историю действий.')
pels('help_version', 'Показать текущую версию.')
pels('help_help', 'Показать это сообщение.')
pels('help_turbo', 'Включить/Выключить Турбо режим.')
pels('unknown_type', 'Неизвестная команда')

pels('turbo_enable', 'Турбо режим Включён!')
pels('turbo_disable', 'Турбо режим Выключен!')

-- classes
pels('arcane_mage', 'Маг Тайная Магия')
pels('fire_mage', 'Маг Огонь')
pels('frost_mage', 'Маг Лед')
pels('holy_paladin', 'Паладин Свет')
pels('protection_paladin', 'Паладин Защита')
pels('retribution_paladin', 'Паладин Воздаяние')
pels('arms_warrior', 'Воин Оружие')
pels('furry_warrior', 'Воин Неистовство')
pels('protection_warrior', 'Воин Защита')
pels('balance_druid', 'Друид Баланс')
pels('feral_combat_druid', 'Друид Сила зверя')
pels('guardian_druid', 'Друид Страж')
pels('restoration_druid', 'Друид Исцеление')
pels('blood_death_knight', 'Рыцарь смерти Кровь')
pels('frost_death_knight', 'Рыцарь смерти Лед')
pels('unholy_death_knight', 'Рыцарь смерти Нечестивость')
pels('beast_mastery_hunter', 'Охотник Повелитель зверей')
pels('marksmanship_hunter', 'Охотник Стрельба')
pels('survival_hunter', 'Охотник Выживание')
pels('discipline_priest', 'Жрец Послушание')
pels('holy_priest', 'Жрец Свет')
pels('shadow_priest', 'Жрец Тьма')
pels('assassination_rogue', 'Разбойник Ликвидация')
pels('combat_rogue', 'Разбойник Бой')
pels('subtlety_rogue', 'Разбойник Скрытность')
pels('elemental_shaman', 'Шаман Стихии')
pels('enhancement_shaman', 'Шаман Совершенствование')
pels('restoration_shaman', 'Шаман Исцеление')
pels('affliction_warlock', 'Чернокнижник Колдовство')
pels('demonology_warlock', 'Чернокнижник Демонология')
pels('destruction_warlock', 'Чернокнижник Разрушение')
pels('brewmaster_monk', 'Монах Хмелевар')
pels('windwalker_monk', 'Монах Танцующий с ветром')
pels('mistweaver_monk', 'Монах Ткач туманов')
