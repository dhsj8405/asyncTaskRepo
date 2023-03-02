CREATE DATABASE asyncTask

create table BBS(
	num int primary key,
	id varchar(40),
	sub varchar(50) default '제목없음',
	content text,
	cnt int default 0 not null,
	ref int default 0 not null,		-- 한 게시물(3번게시물)에 대한 것들 게시물 번호로 묶기 위함
	seq int default 0 not null,		-- 3번 게시물과 관련된 게시물,답글들의 순서 
	lvl int default 0 not null,		-- 깊이
	reg_date DATETIME default CURRENT_TIMESTAMP not null
);

create table board(
	num int primary key,
	id varchar(40),
	sub varchar(50) default '제목없음',
	content text,
	cnt int default 0 not null,
	reg_date DATETIME default CURRENT_TIMESTAMP not null
);

create table reply(
	num int primary key,
	board_num int,  
	id varchar(40),
	content text,
	ref int default 0 not null,		-- 한 게시물(3번게시물)에 대한 것들 게시물 번호로 묶기 위함
	seq int default 0 not null,		-- 3번 게시물과 관련된 게시물,답글들의 순서 
	lvl int default 0 not null,		-- 깊이
	reg_date DATETIME default CURRENT_TIMESTAMP not null,
	foreign key (board_num) references board(num)
);



insert into BBS values ((select IFNULL(max(num),0)+1 from BBS a),'admin1','admin1의 게시물 제목','admin1의 게시물 내용...',0,(select IFNULL(max(num),0)+1 from BBS a),0,0,now());
insert into BBS values ((select IFNULL(max(num),0)+1 from BBS a),'user1','user1의 게시물 제목','user1의게시물내용...',0,(select IFNULL(max(num),0)+1 from BBS a),0,0,now());
insert into BBS values ( (select max(num)+1 from BBS a),'user1','re:user1의 게시물 제목','test1답글',0,2,1,1,now());
insert into BBS values ((select IFNULL(max(num),0)+1 from BBS a),'test1','sub1','content1',0,(select IFNULL(max(num),0)+1 from BBS a),0,0,now());
insert into BBS values ((select IFNULL(max(num),0)+1 from BBS a),'test2','sub2','content2',0,(select IFNULL(max(num),0)+1 from BBS a),0,0,now());
insert into BBS values ((select IFNULL(max(num),0)+1 from BBS a),'test3','sub2','content3',0,(select IFNULL(max(num),0)+1 from BBS a),0,0,now());
insert into BBS values ((select IFNULL(max(num),0)+1 from BBS a),'test4','sub2','content4',0,(select IFNULL(max(num),0)+1 from BBS a),0,0,now());
insert into BBS values ((select IFNULL(max(num),0)+1 from BBS a),'test5','sub2','content5',0,(select IFNULL(max(num),0)+1 from BBS a),0,0,now());
insert into BBS values ((select IFNULL(max(num),0)+1 from BBS a),'test6','sub2','content6',0,(select IFNULL(max(num),0)+1 from BBS a),0,0,now());
insert into BBS values ((select IFNULL(max(num),0)+1 from BBS a),'test7','sub2','content7',0,(select IFNULL(max(num),0)+1 from BBS a),0,0,now());
insert into BBS values ((select IFNULL(max(num),0)+1 from BBS a),'test8','sub2','content8',0,(select IFNULL(max(num),0)+1 from BBS a),0,0,now());
commit;



insert into board values ((select IFNULL(max(num),0)+1 from board a),'test1','test1','test1',0,now());
insert into board values ((select IFNULL(max(num),0)+1 from board a),'test2','test1','test1',0,now());
insert into board values ((select IFNULL(max(num),0)+1 from board a),'test3','test1','test1',0,now());
insert into board values ((select IFNULL(max(num),0)+1 from board a),'test4','test1','test1',0,now());
insert into board values ((select IFNULL(max(num),0)+1 from board a),'test5','test1','test1',0,now());


insert into reply values ((select IFNULL(max(num),0)+1 from reply a),1,'re:test1','test1',(select IFNULL(max(num),0)+1 from BBS a),1,0,now());
insert into reply values ((select IFNULL(max(num),0)+1 from reply a),1,'re:test1','test1',(select IFNULL(max(num),0)+1 from BBS a),2,1,now());
insert into reply values ((select IFNULL(max(num),0)+1 from reply a),2,'re:test2','test1',(select IFNULL(max(num),0)+1 from BBS a),0,0,now());