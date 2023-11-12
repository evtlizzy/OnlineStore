import sys
from tables import goods_table
sys.path.append('tables')

from project_config import *
from tables.goods_table import *
from tables.pictures_table import *

class Main:

    config = ProjectConfig()
    connection = DbConnection(config)

    def __init__(self):
        DbTable.dbconn = self.connection
        return

    def db_init(self):
        pt = GoodsTable()
        pht = PicturesTable()
        pt.create()
        pht.create()
        return

    def db_insert_somethings(self):
        pt = GoodsTable()
        pht = PicturesTable()
        # pt.insert_one([1 , 1, 1, 1, 1, "Test", "Test"])
        # pt.insert_one([2 , 2, 2, 2, 2, "Test", "Test"])
        # pt.insert_one([3 , 3, 3, 3, 3, "Test", "Test"])


    def db_drop(self):
        pht = PicturesTable()
        pt = GoodsTable()
        pht.drop()
        pt.drop()
        return

    def show_main_menu(self):
        menu = """Добро пожаловать! 
Основное меню (выберите цифру в соответствии с необходимым действием): 
    1 - просмотр товаров;
    2 - сброс и инициализация таблиц;
    9 - выход."""
        print(menu)
        return

    def read_next_step(self):
        return input("=> ").strip()

    def after_main_menu(self, next_step):
        if next_step == "2":
            self.db_drop()
            self.db_init()
            self.db_insert_somethings()
            print("Таблицы созданы заново!")
            return "0"
        elif next_step != "1" and next_step != "3" and next_step != "4" and next_step != "5" and next_step != "6" and next_step != "7"and next_step != "8" and next_step != "9":
            print("Выбрано неверное число! Повторите ввод!")
            return "0"
        else:
            return next_step


    def after_show_goods(self, next_step):
        while True:
            if next_step == "4":
                GT = GoodsTable()
                GT.delete_good()
                return "1"
            if next_step == "1":
                GT = GoodsTable()
                GT.show_goods()
            elif next_step == "3":
                GT = GoodsTable()
                GT.show_add_good()
                next_step = "0"
            elif next_step == "6":
                PT = PicturesTable()
                PT.add_picture()
                next_step = "0"
            elif next_step == "7":
                PT = PicturesTable()
                PT.delete_picture()
                next_step = "0"
            elif next_step == "5":
                PT = PicturesTable()
                PT.show_pictures_by_goods()
                next_step = "0"
            elif next_step != "0" and next_step != "1" and next_step != "3" and next_step != "4" and next_step != "9" and next_step != "6" and next_step != "7" and next_step != "5":
                print("Выбрано неверное число! Повторите ввод!")
                return "1"
            else:
                return next_step


    def main_cycle(self):
            current_menu = "0"
            next_step = None
            while(current_menu != "9"):
                if current_menu == "0":
                    self.show_main_menu()
                    next_step = self.read_next_step()
                    current_menu = self.after_main_menu(next_step)
                elif current_menu == "1":
                    GT = GoodsTable()
                    GT.show_goods()
                    next_step = self.read_next_step()
                    current_menu = self.after_show_goods(next_step)
                elif current_menu == "3":
                    GT = GoodsTable()
                    GT.show_add_good()
                elif current_menu == "4":
                    GT = GoodsTable()
                    GT.delete_good()
                elif current_menu == "5":
                    PT = PicturesTable()
                    PT.show_pictures_by_goods()
                    next_step = self.read_next_step()
                    current_menu = self.after_show_goods(next_step)
                elif current_menu == "6":
                    PT = PicturesTable()
                    PT.add_picture()
                elif current_menu == "7":
                    PT = PicturesTable()
                    PT.delete_picture()
            print("До свидания!")
            return

    def test(self):
        DbTable.dbconn.test()

m = Main()
    #m.test() для теста соединения
m.main_cycle()
    
