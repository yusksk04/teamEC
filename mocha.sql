set names utf8;
set foreign_key_checks=0;

drop database if exists mocha;
create database if not exists mocha;

use mocha;

create table user_info(
id int primary key not null auto_increment comment "ID",
user_id varchar(16) unique not null comment "ユーザーID",
password varchar(16) not null comment "パスワード",
family_name varchar(32) not null comment "姓",
first_name varchar(32) not null comment "名",
family_name_kana varchar(32) not null comment "姓かな",
first_name_kana varchar(32) not null comment "名かな",
sex tinyint default 0 comment "性別",
email varchar(32) comment "メールアドレス",
status tinyint default 0 comment "ステータス",
logined tinyint not null default 0 comment "ログインフラグ",
regist_date datetime  not null comment"登録日時",
update_date datetime comment "更新日時"
)
default charset=utf8
comment="会員情報テーブル"
;

create table product_info(
id int primary key not null auto_increment comment "ID",
product_id int unique not null comment "商品ID",
product_name varchar(100) unique not null comment "商品名",
product_name_kana varchar(100) unique not null comment "商品名かな",
product_description varchar(255) comment "商品詳細",
category_id int not null comment "カテゴリID",
price int not null comment "値段",
image_file_path varchar(100) not null comment "画像ファイルパス",
image_file_name varchar(50) not null comment "画像ファイル名",
release_date datetime comment "発売年月",
release_company varchar(50) comment "発売会社",
status tinyint default 1 comment "ステータス",
regist_date datetime  not null comment"登録日時",
update_date datetime comment "更新日時",
foreign key(category_id) references m_category(category_id)
)
default charset=utf8
comment="商品情報テーブル";

create table cart_info(
id int primary key not null auto_increment comment "ID",
user_id varchar(16) not null comment "ユーザーID",
product_id int not null comment "商品ID",
product_count int not null comment "個数",
regist_date datetime  not null comment"登録日時",
update_date datetime comment "更新日時",
foreign key(product_id) references product_info(product_id)
)
default charset=utf8
comment="カート情報テーブル"
;

create table purchase_history_info(
id int primary key not null auto_increment comment "ID",
user_id varchar(16) not null comment "ユーザーID",
product_id int not null comment "商品ID",
product_count int not null comment "個数",
price int not null comment "値段",
destination_id int not null comment "宛先情報ID",
regist_date datetime  not null comment"登録日時",
update_date datetime comment "更新日時",
foreign key(user_id) references user_info(user_id),
foreign key(product_id) references product_info(product_id)
)
default charset=utf8
comment="購入履歴情報テーブル"
;

create table destination_info(
id int primary key not null auto_increment comment "ID",
user_id varchar(16) not null comment "ユーザーID",
family_name varchar(32) not null comment "姓",
first_name varchar(32) not null comment "名",
family_name_kana varchar(32) not null comment "姓かな",
first_name_kana varchar(32) not null comment "名かな",
email varchar(32) comment "メールアドレス",
tel_number varchar(13) comment "電話番号",
user_address varchar(50) not null comment "住所",
regist_date datetime  not null comment"登録日時",
update_date datetime comment "更新日時",
foreign key(user_id) references user_info(user_id)
)
default charset=utf8
comment="宛先情報テーブル"
;

create table m_category(
id int primary key not null auto_increment comment "ID",
category_id int not null unique comment "カテゴリID",
category_name varchar(20) not null unique comment "カテゴリ名",
category_description varchar(100) comment "カテゴリ詳細",
regist_date datetime  not null comment"登録日時",
update_date datetime comment "更新日時"
)
default charset=utf8
comment="カテゴリマスタテーブル"
;

insert into user_info(user_id,password,family_name,first_name,family_name_kana,first_name_kana,sex,email,status,logined,regist_date) values(
"guest","guest","山田","太郎","やまだ","たろう",0,"yamada@yamada.com",0,0,now()),
("guest2","guest2","ゲスト","ユーザー2","げすと","ゆーざー2",0,"guest2@guest.com",0,0,now()),
("guest3","guest3","ゲスト","ユーザー3","げすと","ゆーざー3",0,"guest3@guest.com",0,0,now()),
("guest4","guest4","ゲスト","ユーザー4","げすと","ゆーざー4",0,"guest4@guest.com",0,0,now()),
("guest5","guest5","ゲスト","ユーザー5","げすと","ゆーざー5",0,"guest5@guest.com",0,0,now()),
("guest6","guest6","ゲスト","ユーザー6","げすと","ゆーざー6",0,"guest6@guest.com",0,0,now()),
("guest7","guest7","ゲスト","ユーザー7","げすと","ゆーざー7",0,"guest7@guest.com",0,0,now()),
("guest8","guest8","ゲスト","ユーザー8","げすと","ゆーざー8",0,"guest8@guest.com",0,0,now()),
("guest9","guest9","ゲスト","ユーザー9","げすと","ゆーざー9",0,"guest9@guest.com",0,0,now()),
("guest10","guest10","ゲスト","ユーザー10","げすと","ゆーざー10",0,"guest10@guest.com",0,0,now()),
("guest11","guest11","ゲスト","ユーザー11","げすと","ゆーざー11",0,"guest11@guest.com",0,0,now()),
("guest12","guest12","ゲスト","ユーザー12","げすと","ゆーざー12",0,"guest12@guest.com",0,0,now());

insert into m_category(category_id,category_name,regist_date) values(1,"全てのカテゴリー",now()),
(2,"本",now()),
(3,"家電・パソコン",now()),
(4,"おもちゃ・ゲーム",now()),
(5,"CD",now());

insert into product_info(product_id,product_name,product_name_kana,category_id,price,image_file_path,image_file_name,regist_date,product_description,release_company,release_date) values(
1,"マンガ","まんが",2,450,"./images/book/entertainment_comic.png","entertainment_comic.png",now(),"とても面白いマンガ","○○社","2000/01/01 00:00:00"),
(2,"小説","しょうせつ",2,600,"./images/book/entertainment_novel.png","entertainment_novel.png",now(),"泣ける小説","○○社","2000/01/01 00:00:00"),
(3,"雑誌","ざっし",2,600,"./images/book/job_kyuujinshi.png","job_kyuujinshi.png",now(),"役に立つ","○○社","2000/01/01 00:00:00"),
(4,"絵本","えほん",2,800,"./images/book/book_kids_jidousyo.png","book_kids_jidousyo.png",now(),"教育におすすめ","○○社","2000/01/01 00:00:00"),
(5,"辞書","じしょ",2,1600,"./images/book/dictionary2_kanji.png","dictionary2_kanji.png",now(),"一家に一冊","○○社","2000/01/01 00:00:00"),
(6,"MacBook","まっくぶっく",3,119800,"./images/appliance/computer_laptop_note_zabuton.png","computer_laptop_note_zabuton.png",now(),"最新！","Mapple","2000/01/01 00:00:00"),
(7,"Lenovo","れのぼ",3,66600,"./images/appliance/notepc.png","notepc.png",now(),"コンパクトなサイズ","enovo","2000/01/01 00:00:00"),
(8,"洗濯機","せんたくき",3,123600,"./images/appliance/kaden_sentakuki.png","kaden_sentakuki.png",now(),"パワフル洗浄","Pomasonic","2000/01/01 00:00:00"),
(9,"掃除機","そうじき",3,38000,"./images/appliance/kaden_soujiki_cyclone.png","kaden_soujiki_cyclone.png",now(),"おどろきの吸引力","python","2000/01/01 00:00:00"),
(10,"冷蔵庫","れいぞうこ",3,46000,"./images/appliance/kaden_reizouko.png","kaden_reizouko.png",now(),"大容量の収納","Pomasonic","2000/01/01 00:00:00"),
(11,"ぬいぐるみ","ぬいぐるみ",4,2500,"./images/hobby/nuigurumi_bear.png","nuigurumi_bear.png",now(),"かわいさ満点","○○社","2000/01/01 00:00:00"),
(12,"人形","にんぎょう",4,4600,"./images/hobby/toy_france_ningyou.png","toy_france_ningyou.png",now(),"娘のプレゼントに","○○社","2000/01/01 00:00:00"),
(13,"ミニカー","みにかー",4,500,"./images/hobby/car_red.png","car_red.png",now(),"赤い車","○○社","2000/01/01 00:00:00"),
(14,"PS4","ぴーえすふぉー",4,29800,"./images/hobby/omocha_game.png","omocha_game.png",now(),"最新機種","○○社","2000/01/01 00:00:00"),
(15,"ゲームボーイ","げーむぼーい",4,2600,"./images/hobby/portable_game.png","portable_game.png",now(),"お手頃価格で再登場","○○社","2000/01/01 00:00:00"),
(16,"ロック","ろっく",5,1600,"./images/cd/media_disc_blue.png","media_disc_blue.png",now(),"ロックです","○○社","2000/01/01 00:00:00"),
(17,"ジャズ","じゃず",5,1500,"./images/cd/media_disc_black.png","media_disc_black.png",now(),"ジャズです","○○社","2000/01/01 00:00:00"),
(18,"JPOP","じぇいぽっぷ",5,1980,"./images/cd/entertainment_music.png","entertainment_music.png",now(),"JPOPです","○○社","2000/01/01 00:00:00"),
(19,"演歌","えんか",5,1300,"./images/cd/music_gold_disc.png","music_gold_disc.png",now(),"演歌です","○○社","2000/01/01 00:00:00"),
(20,"洋楽","ようがく",5,2100,"./images/cd/media_disc_green.png","media_disc_green.png",now(),"洋楽です","○○社","2000/01/01 00:00:00");


set foreign_key_checks=1;