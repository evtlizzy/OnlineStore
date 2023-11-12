# Таблица товары и особые действия с ней

from dbtable import *

class GoodsTable(DbTable):
    def table_name(self):
        return self.dbconn.prefix + "goods"


    def columns(self):
        return {"good_id": ["serial", "PRIMARY KEY", "CHECK(good_id > '-1')"],
                "name_good": ["varchar(64)", "NOT NULL"],
                "base_price": ["numeric", "NOT NULL", "CHECK(base_price>-1)"],
                "curr_price": ["numeric", "NOT NULL","CHECK(curr_price>-1)"],
                "min_amount": ["integer", "NOT NULL", "CHECK(min_amount>-1)"],
                "sh_desc": ["varchar(256)", "NOT NULL"],
                "long_desc": ["varchar(512)", "NOT NULL"]
                }

    def primary_key(self):
        return ['good_id']

    def sequence(self):
        sql = "CREATE SEQUENCE seq"
        return sql


    def show_goods(self):
            self.good_id = -1
            menu = """Просмотр списка товаров!
    Идентификатор\tНазвание\tБазовая цена\tТекущая цена\tМинимальное количество\tКраткое описание\tПолное описание"""
            print(menu)
            lst = self.all()
            for i in lst:
                print("\t\t" + str(i[0]) + "\t" + str(i[1]) + "\t" + str(i[2]) + "\t" + str(i[3]) + "\t" + str(i[4])
                      + "\t" + str(i[5]) + "\t" + str(i[6]))
            menu = """Дальнейшие операции: 
        0 - возврат в главное меню;
        3 - добавление нового товара;
        4 - удаление товара;
        5 - просмотр изображений товара;
        6 - добавление изображения;
        7 - удаление изображения;
        9 - выход."""
            print(menu)
            return

    def find_by_id(self, id):
        sql = "SELECT * FROM " + self.table_name()
        sql += " WHERE good_id = %s"
        cur = self.dbconn.conn.cursor()
        cur.execute(sql, (id,))
        return cur.fetchone()

    def delete_by_id(self, id):
        sql = "DELETE FROM " + self.table_name()
        sql += " WHERE good_id = %s "
        cur = self.dbconn.conn.cursor()
        cur.execute(sql, (id, ))
        self.dbconn.conn.commit()
        return

    def show_add_good(self):
        data = []
        data.append(input("Введите название товара (-1 - выход): ").strip())
        if data[0] == "-1":
            return "1"
        while len(data[0].strip()) == 0:
            data[0] = input("Название не может быть пустым! Введите название заново (-1 - выход):").strip()
            if data[0] == "-1":
                return "1"
        while len(data[0].strip()) > 64:
            data[0] = input("Название не может быть больше 64-х символов! Введите название заново (-1 - выход):").strip()
            if data[0] == "-1":
                return "1"

        data.append(input("Введите базовую цену товара (-1 - выход):").strip())
        if data[1] == "-1":
            return "1"
        while len(data[1].strip()) == 0:
            data[1] = input("Базовая цена не может быть пустой! Введите базовую цену заново (-1 - выход):").strip()
            if data[1] == "-1":
                return "1"
        while not data[1].isdecimal():
            data[1] = input("Базовая цена имеет формат числа. Введите базовую цену заново(-1 - выход):").strip()
            if data[1] == "-1":
                return "1"

        while int(data[1]) > 2147483647 :
            data[1] = input("Базовая цена слишком большая! Введите базовую цену заново (-1 - выход):").strip()
            if data[1] == "-1":
                return "1"
        while len(data[1].strip()) < 0:
            data[1] = input("Базовая не может быть отрицательной! Введите базовую цену заново (-1 - выход):").strip()
            if data[2] == "-1":
                return "1"

        data.append(input("Введите Текущую цену товара (-1 - выход):").strip())
        if data[2] == "-1":
            return "1"
        while len(data[2].strip()) == 0:
            data[2] = input("Текущая цена не может быть пустой! Введите текущую цену заново (-1 - выход):").strip()
            if data[2] == "-1":
                return "1"
        while not data[2].isdecimal():
            data[2] = input("Текущая цена имеет формат числа. Введите текущую цену заново(-1 - выход):").strip()
            if data[2] == "-1":
                return "1"
        while int(data[2]) > 2147483647 :
            data[2] = input("Текущая цена слишком большая! Введите текущую цену заново (-1 - выход):").strip()
            if data[2] == "-1":
                return "1"
        while len(data[2].strip()) < 0:
            data[2] = input("Текущая не может быть отрицательной! Введите базовую цену заново (-1 - выход):").strip()
            if data[2] == "-1":
                return "1"


        data.append(input("Введите минимальное количество товаров (-1 - выход):").strip())
        if data[3] == "-1":
            return "1"
        while len(data[3].strip()) == 0:
            data[3] = input(
                "Минимальное количество не может быть пустым! Введите минимальное количество заново (-1 - выход):").strip()
            if data[3] == "-1":
                return "1"
        while not data[3].isdecimal():
            data[3] = input(
                "Минимальное количество имеет формат числа. Введите минимальное количество заново(-1 - выход):").strip()
            if data[3] == "-1":
                return "1"
        while int(data[3]) > 2147483647:
            data[3] = input(
                "Минимальное количество слишком большое! Введите минимальное количество заново (-1 - выход):").strip()
            if data[3] == "-1":
                return "1"
        while len(data[3].strip()) < 0:
            data[3] = input(
                "Минимальное количество не может быть отрицательным! Введите минимальное количество заново (-1 - выход):").strip()
            if data[3] == "-1":
                return "1"

        data.append(input("Краткое описание товара (-1 - выход): ").strip())
        if data[4] == "-1":
            return "1"
        while len(data[4].strip()) == 0:
            data[4] = input(
                "Краткое описание не может быть пустым! Введите краткое описание заново (-1 - выход):").strip()
            if data[4] == "-1":
                return
        while len(data[4].strip()) > 256:
            data[4] = input(
                "Краткое описание не может быть больше 256-и символов! Введите краткое описание заново (-1 - выход):").strip()
            if data[4] == "-1":
                return "1"

        data.append(input("Полное описание товара (-1 - выход): ").strip())
        if data[5] == "-1":
            return "1"
        while len(data[5].strip()) == 0:
            data[5] = input(
                "Полное описание не может быть пустым! Введите Полное описание заново (-1 - выход):").strip()
            if data[5] == "-1":
                return
        while len(data[5].strip()) > 512:
            data[5] = input(
                "Полное описание не может быть больше 256-и символов! Введите Полное описание заново (-1 - выход):").strip()
            if data[5] == "-1":
                return
        self.insert_one(data)
        return

    def delete_good(self):
        while True:
            id = input("Укажите идентификатор товара, который Вы хотите удалить(-1 - выход):")
            if id == "-1":
                return "1"
            while len(id.strip()) == 0:
                id = input(
                    "Пустой идентификатор. Повторите ввод! Укажите идентификатор товара, который Вы хотите удалить(-1 - выход):")
            if id == "-1":
                return "1"
            good = self.find_by_id(int(id))
            if not good:
                print("Введено неверное число!")
            else:
                self.good_id = int(good[0])
                self.good_obj = good
                break
        answer = input("Вы уверены, что хотите удалить товар? Y|N:\n")
        if answer == "Y":
           self.delete_by_id(self.good_obj[0])
           print("Успешно удалено")
           self.show_goods()
        else:
            return "1"

    def insert_one(self, vals):
            # for i in range(0, len(vals)):
            #     if type(vals[i]) == str:
            #         vals[i] = "'" + vals[i] + "'"
            #     else:
            #         vals[i] = str(vals[i])
            sql = "INSERT INTO " + self.table_name() + "("
            sql += ", ".join(self.columns()) + ") VALUES(default,%s,%s,%s,%s,%s,%s)"
            cur = self.dbconn.conn.cursor()
            cur.execute(sql,vals)
            self.dbconn.conn.commit()
            return
