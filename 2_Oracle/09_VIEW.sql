/*
 VIEW (뷰)
 :SELECT문을 저장해둘 수 있는 객체
 => 자주 사용되는 길고 복잡한 쿼리문을 저장해두면 매번 다시 작성할 필요가 없음
 일종의 임시 테이블 역할 (실제 데이터를 복사해서 저장하는게 아니라, SQL(SELECT)문만 저장함)
*/
-- 테이블 : 직원(EMPLOYEE), 부서정보(DEOARTMENT), 직급(JOB), 지역(LOCATION),국가(NATIONAL), 급여등급SAL_GRADE

--한국에서 근무하는 직원 정보 조회(직원번호, 이름, 부서명, 급여, 근무국가명)

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE 
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
    JOIN NATIONAL USING (NATIONAL_CODE)    
WHERE NATIONAL_NAME = '한국';

-- 러시아에서 근무하는 직원 정보 조회

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE 
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
    JOIN NATIONAL USING (NATIONAL_CODE)    
WHERE NATIONAL_NAME = '러시아';
--------------------------------------------------------------------------------
/*
 VIEW 생성하기
 CREATE [OR REPLACE] VIEW 뷰명
 AS 서브쿼리;
 => VIEW 객체를 생성할 때는 서브쿼리에 괄호()룰 붙이지 않음
*/

-- VW_EMPLOYEE 뷰 객체 생성
 CREATE OR REPLACE VIEW VW_EMPLOYEE
 AS
 SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
 FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
    JOIN NATIONAL USING (NATIONAL_CODE);
--> 처음 뷰 생성 시 권한 부족 오류가 발생할 수 있음
--> 관리자 계정으로 현재 사용자에게 CREATE VIEW 권한 부여
--GRANT CREATE VIEW TO C##KH;

-- 현재 사용자에 생성된 뷰 확인
SELECT *
FROM USER_VIEWS;

--생선된 뷰 직접 조회
SELECT *
FROM VW_EMPLOYEE;

--> 뷰를 가지고 SELECT문을 실행하게 되면, 내부적으로는 인라인 뷰로 변환되어 실행됨
SELECT *
FROM (SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE 
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
    JOIN NATIONAL USING (NATIONAL_CODE)
);

-- 한국에서 근무하는 직원
SELECT *
FROM VW_EMPLOYEE 
WHERE NATIONAL_NAME = '한국';
-- 러시아에서 근무하는 직원

--> 근무년수 : 현재연도 - 입사연도
--> 성별 : 주민번호 8번째 자리 값으로 분류(1, 3:남 / 2, 4:여)
SELECT EMP_ID, EMP_NAME, JOB_NAME, DECODE(SUBSTR (EMP_NO, 8, 1), 1, '남', 2, '여', 3, '남', 4, '여'),
EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
FROM EMPLOYEE
    JOIN JOB USING (JOB_CODE);

-- 뷰 생성 : 직원번호, 이름, 직급명, 성별(남|여), 근무년수 정보를 조회
CREATE OR REPLACE VIEW VW_EMP_JOB
AS
SELECT EMP_ID, EMP_NAME, JOB_NAME, DECODE(SUBSTR (EMP_NO, 8, 1), 1, '남', 2, '여', 3, '남', 4, '여') ,
EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) 
FROM EMPLOYEE
    JOIN JOB USING (JOB_CODE);
--> 오류 발생 -> ORA-00998: 이 식은 열의 별명과 함께 지정해야 합니다. 
--> 함수식이나 연산식이 들어간 컬럼은 반드시 별칭을 부여해야 뷰가 생성됨

-- [1]별칭 부여 : 서브쿼리에 직접 별칭 부여하기
CREATE OR REPLACE VIEW VW_EMP_JOB
AS
SELECT EMP_ID, EMP_NAME, JOB_NAME, DECODE(SUBSTR (EMP_NO, 8, 1), 1, '남', 2, '여', 3, '남', 4, '여') 성별,
EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) 근무년수
FROM EMPLOYEE
    JOIN JOB USING (JOB_CODE);
    
SELECT *
FROM VW_EMP_JOB;

--[2]별칭 부여 : 뷰 이름 선언 시 컬럼명 정의하기
CREATE OR REPLACE VIEW VW_EMP_JOB (직원번호, 이름, 직급명, 성별, 근무년수)
AS
 SELECT EMP_ID, EMP_NAME, JOB_NAME,
DECODE(SUBSTR (EMP_NO, 8, 1), 1, '남', 2, '여', 3, '남', 4, '여'),
EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) 
 FROM EMPLOYEE
    JOIN JOB USING (JOB_CODE);

SELECT *
FROM VW_EMP_JOB;

-- 여직원만 조회
SELECT *
FROM VW_EMP_JOB
WHERE 성별 = '여';
-- 근무년수가 20년 이상인 직원 조회
SELECT *
FROM VW_EMP_JOB
WHERE 근무년수 >= 20;
--------------------------------------------------------------------------------
/*
 생성된 뷰를 통해서 DML(INSERTM,UPDATE,DELETE) 수행하기
 -> 뷰는 가상 테이블이므로, 뷰를 통해 DML을 수행하면 '원본 테이블'의 데이터가 변경됨
*/
-- JOB 테이블을 뷰로 생성
CREATE OR REPLACE VIEW VW_JOB
AS
SELECT JOB_CODE, JOB_NAME
FROM JOB;

--뷰를 통해서 데이터 삽입 --> 원본 데이터에 추가됨
INSERT INTO VW_JOB VALUES ('J8', '인턴');

--뷰를 통해서 데이터 수정 --> 원본 데이터 변경
UPDATE VW_JOB SET JOB_NAME = '알바' WHERE JOB_CODE = 'J8';

--뷰를 통해서 데이터 삭제 -> 원본 데이터가 삭제됨
DELETE 
FROM VW_JOB
WHERE JOB_CODE = 'J8';

SELECT *
FROM VW_JOB;

-- 변경 사항 취소
ROLLBACK;
--------------------------------------------------------------------------------
/*
 뷰를 통한 DML 변경이 불가능한 경우 (제한되는 경우)
 1) 뷰에 포함되지 않는 원본 테이블의 컬럼이 NOT NULL 제약조건을 가질 때 (INSERT 불가)
 2) 산술연산식이나 함수식 만들어진 컬름을 수정하려 할 때
 3) 중복 제거(DISTINCT) 구문이 포함된 경우
 4) GROUP BY/HAVING 등 집계 함수가 사용된 경우
 5) 2개 이상의 테이블을 JOIN 하여 만든 복한 SELECT문인 경우
 
 -> 뷰는 대부분 조회(SELECT) 전용으로 사용하는 것이 안전하고 관례임
*/
--------------------------------------------------------------------------------
/*
 뷰 생성 옵션
 -FORCE : 테이블이 없어도 뷰를 강제로 생성
 -WITH CHECK OPTION : 뷰(서버쿼리)의 조건절에 위배되는 데이터 조작(DML)을 차단
 -WITH READ ONLY : DML 조작을 원천 차단하고 오직 SELECT만 허용
*/
-- FORCE 옵션
CREATE OR REPLACE FORCE VIEW VW_TEST
AS
SELECT TEST_ID, TEST_NAME
FROM TB_TEST; -- 존재하지 않는 테이블(TB_TEST)

SELECT *
FROM VW_TEST;

SELECT *
FROM USER_VIEWS;

-- WITH CHECK OPTION 옵션
-- VW_EMP_SAL (급여가 300만원 이상인 직원 정보 조회)
CREATE OR REPLACE VIEW VW_EMP_SAL
AS
SELECT *
FROM EMPLOYEE
WHERE SALARY >= 3000000
WITH CHECK OPTION;

SELECT *
FROM VW_EMP_SAL;

-- 204번 직원의 급여를 200만원으로 변경 (300만원 미만으로 변경)
-- 위에 만든 WITH CHECK OPTION에 위배된다
UPDATE VW_EMP_SAL
    SET SALARY = 2000000
 WHERE EMP_ID = '204';

-- WITH READ ONLY 옵션
CREATE OR REPLACE VIEW VW_EMP_SAL
AS
SELECT *
FROM EMPLOYEE
WHERE SALARY >= 3000000
WITH READ ONLY;

SELECT * FROM VW_EMP_SAL;

--200번 직원 삭제
DELETE
FROM VW_EMP_SAL
WHERE EMP_ID = '200';



























