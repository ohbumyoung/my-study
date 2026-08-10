/*
 테이블 생성 : MEMBER 
 ID (숫자, 기본키)
 NAME (문자, 50바이트 가변 길이, NOT NULL)
 EMAIL (문자, 100바이트 가변길이, NOT NULL)
 AGE (숫자)
 
 시퀀스 생성 : SEQ_MEMBER_ID
 시작번호: 1
 증가값: 1
 캐시: X
*/

CREATE TABLE MEMBER (
 ID NUMBER PRIMARY KEY,
 NAME VARCHAR2(50) NOT NULL,
 EMAIL VARCHAR2(100) NOT NULL,
 AGE NUMBER
);

CREATE SEQUENCE SEQ_MEMBER_ID
 START WITH 1
 INCREMENT BY 1
 NOCACHE;
 
 
 SELECT *
 FROM MEMBER;
 
 INSERT INTO MEMBER VALUES (SEQ_MEMBER_ID.NEXTVAL, '오범영', 'dhqjadud@naver.com', 20);
 INSERT INTO MEMBER VALUES (SEQ_MEMBER_ID.NEXTVAL, '육범영', 'dbrqjadud@naver.com', 21);
 INSERT INTO MEMBER VALUES (SEQ_MEMBER_ID.NEXTVAL, '칠범영', 'clfqjadud@naver.com', 22);
 
 commit;
 
 Select *
 FROM MEMBER
 WHERE NAME = '오범영';
 
 Select * FROM MEMBER WHERE NAME = '' or '1' = '1'
 
 
    