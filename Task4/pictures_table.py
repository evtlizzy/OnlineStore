# Таблица Изображения и особые действия с ней.

from dbtable import *
from tables.goods_table import GoodsTable


class PicturesTable(DbTable):
    def table_name(self):
        return self.dbconn.prefix + "pictures"

    def columns(self):
        return {"picture_id": ["serial", "PRIMARY KEY"],
                "goodp_id": ["integer", "references goods(good_id) ON DELETE CASCADE", "NOT NULL"],
                "picture_article": ["varchar(20)", "NOT NULL"]}

    def primary_key(self):
        return ['picture_id']

    def table_constraints(self):
        return []

    def show_pictures_by_goods(self):
        while True:
            id = input("Укажите идентификатор интересующего Вас товара (-1 - выход):")
            if id == "-1":
                return
            while len(id.strip()) == 0:
                id = input(
                    "Пустой идентификатор. Повторите ввод! Укажите идентификатор интересующего Вас товара (0 - выход):")
            if id == "-1":
                return "0"
            good = GoodsTable().find_by_id(int(id))
            if not good:
                print("Введено число, неудовлетворяющее количеству товаров!")
            else:
                self.good_id = int(good[0])
                self.good_obj = good
                break
        print("Выбран товар: " + str(self.good_obj[0]) + "\t" + str(self.good_obj[1]) + "\t" + str(
            self.good_obj[2]) + "\t" +
              str(self.good_obj[3]) + "\t" + str(self.good_obj[4]) + "\t" + str(self.good_obj[5]) + "\t" +
              str(self.good_obj[6]))
        print("Изображения:")
        lst = PicturesTable().all_by_good_id(self.good_id)
        for i in lst:
            print(i)
        return

    def delete_picture(self):
        while True:
            id = input("Укажите идентификатор изображения, которое Вы хотите удалить(-1 - выход):")
            while not id.isnumeric():
                id = input(
                    "Идентификатор должен быть числом. Повторите ввод! Укажите идентификатор товара, который Вы хотите удалить(-1 - выход):")
            if id == "-1":
                return "0"
            while len(id.strip()) == 0:
                id = input(
                    "Пустой идентификатор. Повторите ввод! Укажите идентификатор товара, который Вы хотите удалить(-1 - выход):")
            if id == "-1":
                return "0"
            while int(id) > 2147483647:
                id = input(
                    "Идентификатор слишком большой. Повторите ввод! Укажите идентификатор товара, который Вы хотите удалить(-1 - выход):")
            if id == "-1":
                return "0"
            picture = PicturesTable().find_by_id(int(id))
            if not picture:
                print("Введено неверное число!")
            else:
                self.picture_id = int(picture[0])
                self.picture_obj = picture
                break
        answer = input("Вы уверены, что хотите удалить изображение? Y|N:\n")
        if answer == "Y":
            self.delete_by_id(self.picture_obj[0])
            print("Успешно удалено")
            return
        else:
            return "4"

    def add_picture(self):
        data = []
        while True:
            menu = """Просмотр списка товаров!
            Идентификатор\tНазвание\tБазовая цена\tТекущая цена\tМинимальное количество\tКраткое описание\tПолное описание"""
            print(menu)
            lst = GoodsTable().all()
            for i in lst:
                print("\t\t" + str(i[0]) + "\t" + str(i[1]) + "\t" + str(i[2]) + "\t" + str(i[3]) + "\t" + str(i[4])
                      + "\t" + str(i[5]) + "\t" + str(i[6]))
            data.append(input("Введите идентификатор товара, для которого вы хотите добавить изображение (-1 - выход): ").strip())
            if data[0] == "-1":
                return "1"
            while not data[0].isnumeric():
                data[0] = input(
                    "Идентификатор должен быть числом. Введите идентификатор повторно (-1 - выход): ").strip()
                if data[0] == "-1":
                    return
            while int(data[0]) > 2147483647 :
                data[0] = input(
                    "Идентификатор слишком большой. Введите идентификатор повторно (-1 - выход): ").strip()
                if data[0] == "-1":
                    return
            while len(data[0].strip()) == 0:
                data[0] = input(
                    "Идентификатор не может быть пустым. Введите идентификатор повторно (-1 - выход): ").strip()
                if data[0] == "-1":
                    return



            data.append(input("Введите артикул изображения (-1 - выход): ").strip())
            if data[1] == "-1":
                return
            while len(data[1].strip()) == 0:
                data[1] = input(
                    "Пустая строка. Повторите ввод! Укажите артикул интересующего Вас изображения (-1 - выход):")
                if data[1] == "-1":
                    return
            while len(data[1].strip()) > 20:
                data[1] = input("Значение артикула слишком большое. Введите артикул повторно (-1 - выход): ").strip()
                if data[1] == "-1":
                    return
            good = GoodsTable().find_by_id(str(data[0]))
            if not good:
                print("Введен неверный идентификатор!")
            else:
                data[0] = good[0]
                self.insert_pic(data)
                print("Изображение добавлено!")
                break
            return

    def find_by_id(self, id):
        sql = "SELECT * FROM " + self.table_name()
        sql += " WHERE picture_id = %s"
        cur = self.dbconn.conn.cursor()
        cur.execute(sql, (id,))
        return cur.fetchone()

    def all_by_good_id(self, gid):
        sql = "SELECT * FROM " + self.table_name()
        sql += " WHERE goodp_id = %s"
        sql += " ORDER BY "
        sql += ", ".join(self.primary_key())
        cur = self.dbconn.conn.cursor()
        cur.execute(sql, (gid,))
        return cur.fetchall()

    def find_by_position(self, num):
        sql = "SELECT * FROM " + self.table_name()
        sql += " ORDER BY "
        sql += ", ".join(self.primary_key())
        sql += " LIMIT 1 OFFSET %(offset)s"
        cur = self.dbconn.conn.cursor()
        cur.execute(sql, {"offset": num - 1})
        return cur.fetchone()

    def delete_by_id(self, pid):
        sql = "DELETE FROM " + self.table_name()
        sql += " WHERE picture_id = %s"
        cur = self.dbconn.conn.cursor()
        cur.execute(sql, (pid,))
        self.dbconn.conn.commit()
        return

    def insert_pic(self, goodp_id):
        sql = "INSERT INTO " + self.table_name() + " VALUES (default,%s,%s)"
        cur = self.dbconn.conn.cursor()
        cur.execute(sql, goodp_id)
        self.dbconn.conn.commit()
        return
