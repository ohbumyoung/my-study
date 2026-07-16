/*
 TRIGGER (트리거)
 : 특정 테이블에 DML(INSERT, UPDATE, DELETE)문에 의해 변경 사항이 발생했을 때 (이벤트가 발생했을 때)
   자동으로 매번 실행할 내용을 미리 정의해두는 객체
   
   종류
   [1] 실행 시기에 따른 분류
        BEFORE TRIGGER : 테이블의 데이터가 바뀌기 전 트리거 실행 (데이터 검증용)
        AFTER TRIGGER : 테이블의 데이터가 바뀐 후 트리거 실행 (대부분 비즈니스 로직 처리용)
        
   [2] 영향을 맏는 행에 따른 분류
        문장 트리거 : SQL문이 실행될 때 딱 한번만 트리거 실행
        행 트리거 : SQL문에 의해 영향받는 행의 개수만큼 매번 트리거 실행
                   => 반드시 FOR EACH ROW 옵션을 작성해야 함
                   
    가상 변수(의사 레코드)
        :OLD => 변경 전 데이터 (UPDATE(수정) 전, DELETE(삭제) 전 데이터)
        :NEW => 변경 후 데이터 (INSERT(추가), UPDATE(수정) 후 데이터)
*/

/*
 트리거 생성
 
 CREATE OR REPLACE TRIGGER 트리거명
 BEFOER | AFTER
 INSERT | UPDATE | DELETE ON 테이블명
 [FOR EACH ROW] -> 행 트리거면 반드시 작성
 실행 시킬 내용(PL/SQL)
 DECLARE
 BEGIN
 EXCEPTION
 END;
*/
-- EMPLOYEE 테이블에 데이터가 추가된 후에 작동하는 행 트리거 생성
-- XXX님 환영합니다 ^^ 출력

CREATE OR REPLACE TRIGGER TRG_WELCOME

AFTER 

INSERT ON EMPLOYEE

FOR EACH ROW

BEGIN 
DBMS_OUTPUT.PUT_LINE(:NEW.EMP_NAME||'님 환영합니다.');

END;
/

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
            VALUES (SEQ_ENO.NEXTVAL, '사범영', '980508-1158974', 'J4', SYSDATE);

ROLLBACK;

SELECT *
FROM EMPLOYEE;
--------------------------------------------------------------------------------
-- 상품 입고, 출고 관련 재고 관리 시스템
-- 상품 테이블
CREATE TABLE TB_PRODUCT (
 PNO NUMBER PRIMARY KEY,        --상품번호
 PNAME VARCHAR2(30) NOT NULL,   -- 상품명
 BRAND VARCHAR2(30) NOT NULL,   -- 브랜드명
 PRICE NUMBER DEFAULT 0,        -- 가격
 STOCK NUMBER DEFAULT 0         -- 재고 수량
);

--상품 번호 시퀀스
CREATE SEQUENCE SEQ_PNO
START WITH 200
INCREMENT BY 5
NOCACHE;

-- 샘플 데이터 추가
INSERT INTO TB_PRODUCT (PNO, PNAME, BRAND)
    VALUES (SEQ_PNO.NEXTVAL, '뽕따', '빙그레');
    
INSERT INTO TB_PRODUCT 
    VALUES (SEQ_PNO.NEXTVAL, '빠삐코', '롯데', 1200, 20);
    
INSERT INTO TB_PRODUCT 
    VALUES (SEQ_PNO.NEXTVAL, '토마토마', '해태', 1200, 10);

SELECT *
FROM TB_PRODUCT;

COMMIT;

-- 입출고 내역 테이블
CREATE TABLE TB_PDETAIL (
 DNO NUMBER PRIMARY KEY,                     -- 입출고 내역번호
 PNO NUMBER REFERENCES TB_PRODUCT(PNO),      -- 상품번호 (외래키)
 DDATE DATE DEFAULT SYSDATE,                 -- 입출고일
 AMOUNT NUMBER NOT NULL,                     -- 입출고 수량
 DTYPE CHAR(6) CHECK(DTYPE IN('입고','출고')) -- 입출고 종류
);

-- 입출고 내역번호 시퀀스
CREATE SEQUENCE SEQ_DNO
NOCACHE;

SELECT *
FROM TB_PDETAIL;

-- 트리거를 사용하지 않은 경우
-- 205번 상품이 5개 출고
--1) 입출고내역 테이블에 데이터 추가
INSERT INTO TB_PDETAIL VALUES (SEQ_DNO.NEXTVAL, 205, DEFAULT, 5, '출고');

--2) 상품 테이블의 재고수량 업데이트(수정)
UPDATE TB_PRODUCT
 SET STOCK = STOCK -5
 WHERE PNO = 205;

--200번 상품이 10개 입고
--1) 입출고내역 데이터 추가
INSERT INTO TB_PDETAIL VALUES (SEQ_DNO.NEXTVAL, 200, SYSDATE, 10, '입고');

--2) 상품 테이블의 재고수량 업데이트
UPDATE TB_PRODUCT
 SET STOCK = STOCK + 10
 WHERE PNO = 205;
 
 
--> 매번 유사한 작업을 하나하나 해야하고, 또 실수가 발생되면 롤백 후 다시 실행해야 함 
--------------------------------------------------------------------------------
/*
 트리거 설계(작업 내용 정리)
 TB_PDETAIL(입출고내역) 테이블에 데이터가 1건 추가될 때마다 (INSERT)
 추가된 데이터의 상태(:NEW)에 따라 TB_PRODUCT(상품) 테이블의 재고수량을 수정(UPDATE)
*/
-- 트리거 생성 (TRG_PRODUCT)
CREATE OR REPLACE TRIGGER TRG_PRODUCT
AFTER
INSERT ON TB_PDETAIL
FOR EACH ROW
BEGIN 



 IF --입고인 경우
    :NEW.DTYPE = '입고' THEN 
    UPDATE TB_PRODUCT
    SET STOCK = STOCK + :NEW.AMOUNT
    WHERE PNO = :NEW.PNO;
 ELSE --출고인 경우
    UPDATE TB_PRODUCT
    SET STOCK = STOCK - :NEW.AMOUNT
    WHERE PNO = :NEW.PNO;
    END IF;
END;
/

SELECT *
FROM TB_PRODUCT;

INSERT INTO TB_PDETAIL VALUES (SEQ_DNO.NEXTVAL, 205, SYSDATE, 7, '출고');
INSERT INTO TB_PDETAIL VALUES (SEQ_DNO.NEXTVAL, 210, SYSDATE, 20, '입고');

SELECT *
FROM TB_PDETAIL;

COMMIT;





