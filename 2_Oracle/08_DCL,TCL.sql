/*
 DCL (DATA CONTROL LANGUAGE, 데이터 제어어)
 : 사용자 계쩡에 시스템 권환 / 객체 권한을 부여(GRANT)하거나, 회수(REVOKE)하는 구문
 
 -시스템 권환 : DB에 접근하는 권한, 객체를 생성하는 권한
 -객체 권환 : 특정 객체들을 조작할  수 있는 권환 
*/
--------------------------------------------------------------------------------
/*
 사용자 계정 생성
 CREATE USER 사용자명 IDENTIFIED BY 비밀번호;
 사용자명 : oracle 12c 버전 이후로 C##이 앞에 붙어야 함
 비밀번호 : 대소문자를 구분하므로 잘 작성해야 함
 
 권한부여
 GRANT 권한종류 TO 사용자명;
        -권한 종류- 
 CREATE SESSION : 접속권한
 CREATE TABLE : 테이블 생성 권한
 CREATE VIEW : 뷰 생성 권한
 CREATE SEQUENCE : 시퀀스 생성 권한
 ..
*/
-- 사용자 계정 생성 : SAMPLE / SAMPLE
CREATE USER C##SAMPLE IDENTIFIED BY SAMPLE;
--> 현재 계정은 사용자 생성 권한이 없으므로, 관리자 계정으로 생성해야 함

--> 접속 시도 시 권환이 부여되어 있지 않아, CREATE SESSION 권한이 없다고 오류 발생
--> SAMPLE 계정에 CREATE SESSION 권한 부여
GRANT CREATE SESSION TO C##SAMPLE;

--> 접속 성공 후 테이블을 생성하려고 했으나, 권한이 불충분하다고 실패 (오류발생)
--> SAMPLE 계정에 CREATE TABLE 권한 부여
GRANT CREATE TABLE TO C##SAMPLE;

--> 테이블 생성 후 데이터를 추가하려고 했으나, 테이블 스페이스 관련 권한이 없다고 실패
--> SAMPLE 계정에 테이블 스페이스 할당
ALTER USER C##SAMPLE QUOTA 2M ON USERS;      --> 2M정도 테이블 스페이스 공간 할당
--------------------------------------------------------------------------------
/*
 객체 권한
 종류        |  접근 객체
 ===========================
 SELECT     | TABEL, VIEW, SEQUENCE   -조회
 INSERT     | TABEL, VIEW             -추가
 UPDATE     | TABEL, VIEW             -수정
 DELETE     | TABEL, VIEW             -삭제
 
 권한부여
 GRANT 권한 종류 ON 특정객체 TO 사용자명;
 예) TEST 계정에 KH계정의 EMPLOYEE 테이블을 조회할 수 있도록 권한 부여
    GRANT SELECT ON KH.EMPLOYEE TO TEST     -Oracle 12c 이전 버전 
    
    GRANT SELECT ON C##KH.EMPLOYEE TO C##TEST;
    
 권한 회수
 REVOKE 회수할권한 FROM 사용자명;        -- 시스템 권한
 REVOKE 종류 ON 객체정보 FROM 사용자명;  -- 객체 접근 권한
 
 예) TEST 계정에 부여했던 KH계정의 EMPLOYEE 테이블 조회 권한 회수
 REVOKE SELECT ON C##KH.EMPLOYEE FROM C##TEST;
*/
--------------------------------------------------------------------------------
/*
 역할(ROLE, 규칙) : 특정 권한들을 하나의 집합으로 모아놓은 것
 
 -CONNECT : 접속 권한 (CREATE SESSIIN)
  RESOURCE : 자원(객체)관리, 특정 객체 생성 권한
            (CREATE TABLE, CREATE SEQUENCE, ...)
*/
-- 역할(ROLE) 조회
SELECT *
FROM ROLE_SYS_PRIVS
WHERE ROLE IN('CONNECT','RESOURCE');
--------------------------------------------------------------------------------
/*
 TCL (TRANSCATION CONTROL LANGUAGE, 트랜잭션 제어어)
 - 트랜잭션 : 데이터베이스의 논리적 연산 다위
             데이터의 변경사항 (DML 사용 시)을 하나의 묶음처럼 트랜잭션에 모아둠
             COMMIT 사용하기 전까지의 변경사항들을 하나의 트랜잭션으로 담게 됨
             -> 트랜잭션에 추가되는 SQL: INSERT / UPDATE / DELETE / MERGE 
             CREATE / ALTER / DROP
             
 - 종류
 -COMMIT (적용) : 트랜잭션에 담겨져있는 변경사항들을 실제 DB에 적용하겠다.
 -ROLLBACK (취소) : 트랜잭션에 담겨져있는 변경사항들을 삭제(취소)하겠다.
                       마지막 COMMIT 시점(위치)로 돌아간다.
 -SAVEPOINT 포인트명 (시점저장) : 현재 시점에 변경사항들을 임시로 저장해두는 것을 의미한다.
                               ROLLBACK 시 시점이름을 같이 입력하면 , 전체 변경 사항을 모두 삭제하지 않고 해당 위치까지만 삭제
*/
-- KH 계정으로 접속 --





































