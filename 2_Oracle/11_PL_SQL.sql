/*
 PL/SQL : PROCEDURE LANGUAGE EXTENSION TO SQL
 
 - 오라클 자체에 내장되어 있는 절차적 언어
 - SQL(PL/SQL) 문자 냉에 변수 정의, 조건문, 반복문 등을 지원
 
 표기법
    [선언부]       : DECLARE 로 시작. 변수나 상수를 선언하고 초기화 하는 부분.(생략 가능)
    실행부         : BEGIN 으로 시작. SQL문 또는 제어문(조거문, 반복문) 등의 로직을 작성하는 부분. (필수 항목!)
    [예외처리부]   : EXCEPTION 으로 시작. 실행 중 예외(오류) 발생 시 해결하기 위한 부분. (생략 가능)
*/

-- 화면에 출력하기 위한 설정 (DBMS_OUTPUT)
--> 접속할 때마다, 새로운 워크시트 창을 열 때 실행해야 함
SET SERVEROUTPUT ON;

-- HELLO ORACLE 출력
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO ORACLE'); --> 자바의 Sysetm.out.println();
END;
/
--------------------------------------------------------------------------------
/*
    선언부 (DECRLARE)
    : 변수 또는 상수를 선언하는 부분 (선언과 동시에 초기화도 가능)
*/

/*
 일반 타입 변수
 변수명 CONSTANT 데이터 타입 -> 상수
 변수명 데이터타입 -> 선언
 변수명 데이어타입 := 값 -> 선언과 동시에 초기화
 
 자바와의 차이점
 1) 자바 : 데이터타입 변수명;
    PL/SQL : 변수명 데이터타입;
 2)대입 연산자 (자바) :  =
   대입 연산자 (PL/SQL) : := , SQLL에서는 =는 비교연산자
 3) 상수 선언 (자바) : final
    상수 선언 (PL/SQL) : CONSTANT
*/

DECLARE
    NAME VARCHAR2(10);
    AGE NUMBER;
    CLASS CONSTANT CHAR(1) := 'C';
BEGIN
    NAME := '오범영';
    AGE := 29;
    
    DBMS_OUTPUT.PUT_LINE('이름 : ' || NAME);
    DBMS_OUTPUT.PUT_LINE('나이 : ' || AGE);
    DBMS_OUTPUT.PUT_LINE('강의장 : ' || CLASS);
END;
/

--값을 입력 받아 변수에 대입
-- => &
DECLARE
    EID NUMBER;
    ENAME VARCHAR2(10);
BEGIN
--    ENAME := '오범영';
    ENAME := '&이름';
    --> 만약 입력받을 값이 문자타입의 변수에 저장된다면, '&이름' 처럼 작은 따옴표로 감싸주어야 한다.
    
--    EID := &직원번호;
    EID := 999;
    
    DBMS_OUTPUT.PUT_LINE('이름 : '||ENAME);
    DBMS_OUTPUT.PUT_LINE('직원번호 : '||EID);
END;
/
--------------------------------------------------------------------------------
/*
 참조(래퍼런스) 타입 변수
 &TYPE
 : 특정 테이블의 특정 컬럼 데이터 타입을 그대로 가져와서 변수로 선언
 -> 컬럼 타입이 나중에 바뀌어도 코드 수정이 필요 없음
 
 변수명 테이블명.컬럼명%TYPE;
*/
-- EMPLOYEE 테이블의 EMP_ID 컬럼, EMP_NAME컬럼, SALARY 컬럼을 참조하여 EID, ENAME, SAL 변수 선언
DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO EID, ENAME, SAL
    FROM EMPLOYEE
    WHERE EMP_ID = '&직원번호';
    
    DBMS_OUTPUT.PUT_LINE('직원번호 : '||EID);
    DBMS_OUTPUT.PUT_LINE('직원이름 : '||ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : '||SAL);
END;
/

-- 직원 번호를 입력 받아, 해당 직원의 직원번호, 이름 , 직급코드, 급여, 부서명을 출력해보기
--> 출력 형식 (210번 예) : 210, 윤은혜, J7, 2000000, 해외영업1부

DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    JOB EMPLOYEE.JOB_CODE%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE
    INTO EID, ENAME, JOB, SAL, DTITLE
FROM EMPLOYEE 
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE EMP_ID = '&직원번호';

    DBMS_OUTPUT.PUT_LINE('직원번호 : '||EID);
    DBMS_OUTPUT.PUT_LINE('직원이름 : '||ENAME);
    DBMS_OUTPUT.PUT_LINE('직급코드 : '||JOB);
    DBMS_OUTPUT.PUT_LINE('급여 : '||SAL);
    DBMS_OUTPUT.PUT_LINE('부서명 : '||DTITLE);

END;
/
--------------------------------------------------------------------------------
/*
 ROW 타입 변수
 %ROWTYPE
 : 테이블의 한 행 전체를 통째로 담을 수 있는 변수 (자바의 참조변수와 유사)
 
 변수명 테이블명%ROWTYPE
*/

DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = '&직원번호';

    DBMS_OUTPUT.PUT_LINE('이름 : ' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || E.SALARY);
    
    DBMS_OUTPUT.PUT_LINE('보너스 : ' || NVL(E.BONUS,0));
END;
/
--------------------------------------------------------------------------------
/*
 실행부 (BEGIN)
 제어문 - 조건문
 
 -단일 IF문
 IF 조건식 THEN 실행할 내용
 END IF;

 -IF/ELSE문
 IF 조건식 THEN 만족할 때 실행할 내용
 ELSE 만족하지 않을 때 실행할 내용 
 END IF;

 -IF/ELSIF문
 IF 조건식 THEN 실행1
 ELSIF 조건식2 THEN 실행2
 ELSE 모든 조건을 만족하지 않을 때 실행할 내용
 END IF;
*/

DECLARE
    SCOER NUMBER;
    GRADE CHAR(1);
BEGIN
    SCOER := &점수;
    IF SCOER >=90 THEN GRADE :='A';
    ELSIF SCOER >=80 THEN GRADE := 'B';
    ELSIF SCOER >=70 THEN GRADE := 'C';
    ELSIF SCOER >=60 THEN GRADE := 'D';
    ELSE GRADE := 'F';
    --ELSIF SCOER >=0 THEN GRADE := 'F';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('점수는 ' || SCOER || '이고 ' || '등급은 ' || GRADE || '입니다.');
    --DBMS_OUTPUT.PUT_LINE('등급 : '||GRADE);

    IF GRADE = 'F' THEN DBMS_OUTPUT.PUT_LINE('재평가 대상입니다.');
    END IF;
END;
/

-- 직원 번호, 이름, 급여, 보너스 정보를 출력
-- 보너스를 받지 않는 경우 '보너스를 받지 않는 직원입니다.' 출력
-- 보너스를 받는 경우 해당 값을 출력

DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
 SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS,0)
 INTO EID, ENAME, SAL, BONUS
 FROM EMPLOYEE
 WHERE EMP_ID = '&직원번호';
 
 DBMS_OUTPUT.PUT_LINE('직원번호: '||EID);
 DBMS_OUTPUT.PUT_LINE('이름: '||ENAME);
 DBMS_OUTPUT.PUT_LINE('급여: '||SAL);
 
 IF BONUS = 0 THEN DBMS_OUTPUT.PUT_LINE('보너스를 받지 않는 직원입니다.');
 ELSE DBMS_OUTPUT.PUT_LINE('보너스 :'||BONUS);
 END IF;

END;
/
--------------------------------------------------------------------------------
/*
 반복문 
 FOR LOOP 문 (자바의 FOR문과 유사)
 FOR 변수명 IN [REVERSE] 초기값...끝값
 LOOP
    반복할 내용
 END LOOP;
*/
-- TEST 테이블, SEQ_TNO시퀀스 (기존에 존재하는 경우 제거 후 생성)
-- TEST 테이블 : TNO(PK, 숫자), TDATE(날짜)
-- SEQ_TNO 시퀀스 : 1부터 시작, 1000까지만 증가 2씩 증가, 순환X, 캐시X
 
 CREATE TABLE TEST(
 TNO NUMBER PRIMARY KEY,
 TDATE DATE
 
 );

CREATE SEQUENCE SEQ_TNO
 START WITH 1
 INCREMENT BY 2
 MAXVALUE 1000
 NOCYCLE
 NOCACHE;

-- TEST 테이블에 100개의 테이터를 추가
BEGIN
    FOR I IN 1..100
    LOOP
    INSERT INTO TEST VALUES (SEQ_TNO .NEXTVAL, SYSDATE);
    END LOOP;
    
    COMMIT;

END;
/

SELECT COUNT(*)
FROM TEST;
--------------------------------------------------------------------------------
/*
 비비디 바비디 부~
 예외처리부 (EXCEPTION)
  : 자바의 try ~ catch 블로과 유사한 부분
  EXCEPTION
        WHEN 예외명1 THEM 처리구문1;
        WHEN 예외명2 THEM 처리구문2;
        WHEN OTHERS THEM 그외의 모든예외에 대한 처리구문;
        
        자주 만나는 예외들
 NO_DATA_FOUND : SELECT INTO 결과가 단 한 행도 없을 때 발생
 TOO_MANY_ROWS : SELECT INTO 결과가 여러 행일 때 발생
 ZERO_DIVIDE : 연산 수행시 0으로 숫자르 나누려고 할 때 발생
 DUP_VAL_ON_INDEX : PRIMARY KEY(기본키), UNIQUE 등 중복된 값을 저장하려고 할 때 발생   
*/

-- 직원 번호를 입력받아 ,노옹철 직원의 번호를 변경
BEGIN
    UPDATE EMPLOYEE 
    SET EMP_ID = '&변경할직원번호'
    WHERE EMP_NAME = '노옹철';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('ERROR! 이미 존재하는 번호입니다. 다른번호를 입력하세요.');
END;
/
SELECT *
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철';
ROLLBACK;
--------------------------------------------------------------------------------
/*
 PL/SQL 프로시저
 : 특정 비즈니스 로직을 처리하는 PL/SQL 코드를 DB에 저장해둘 수 있는 객체
 
 -매개변수 종류-
  IN : 자바 메소드의 매개변수처럼, 외부에서 프로시저 내부로 값을 가지고 올 때 사용
  OUT : 반환값처럼 프로시저가 처리한 결과를 외부로 줄 때 사용
*/

-- INSERT_TEST_DATA 라는 이름의 프로시저 객체 생성 => 전달된 개수(COUNT)만큼 TEST 테이블에 데이터 추가
CREATE OR REPLACE PROCEDURE INSERT_TEST_DATA
(
    DCOUNT IN NUMBER
)
IS
BEGIN
    
    FOR I IN 1..DCOUNT
    LOOP
        -- 데이터 추가(INSERT)
        INSERT INTO TEST VALUES (SEQ_TNO.NEXTVAL, SYSDATE);
    END LOOP;

    COMMIT;     -- DCOUNT(전달된 개수) 만큼 데이터 추가 완료 후 적용(COMMIT)

    DBMS_OUTPUT.PUT_LINE(DCOUNT || '개의 데이터가 추가되었습니다.');
END;
/


-- * 생성된 프로시저를 사용(실행)
CALL INSERT_TEST_DATA(50);

BEGIN
    INSERT_TEST_DATA(20);
END;
/

SELECT COUNT(*) FROM TEST;


SELECT *
FROM USER_SEQUENCES;


