-- CREATE SESSION

--테이블 생성
/*
 테이블명 : TEST
 컬럼 : TEST_ID (숫자), TEST_NAME (가변 10)
*/

 CREATE TABLE TEST (
    TEST_ID NUMBER,
    TEST_NAME VARCHAR2(10)
);
--> 관리자 계정으로부터 CREATE TABLE 권환을 부여 받은 후 테이블 생성 성공

SELECT *
FROM TEST;

-- TEST 테이블에 데이터 추가
INSERT INTO TEST VALUES (1,'오범영');

COMMIT;

--> 관리자 계정으로부터 테이블 스페이스 할당 받은 후 데이터 추가 성공














