/*
 GROUP BY 절 : 그룹 기준을 제시할 수 있는 부분
*/
-- 전체 직원의 급여 총 합 조회
SELECT SUM(SALARY)
FROM EMPLOYEE;

-- 부서별 급여 총 합 조회
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 부서별 직원 수 조회
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 부서코드가 D6, D9, D1인 각 부서별 급여 총합, 사원수
SELECT DEPT_CODE, SUM(SALARY), COUNT(*)
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D1', 'D6', 'D9')
GROUP BY DEPT_CODE;

-- 직급 별 총 직원수, 보너스를 받은 직원수, 급여 총합, 평균 급여, 최저 급여, 최고급여(직급코드 오르차순)
SELECT JOB_CODE, COUNT(*), COUNT(BONUS), SUM(SALARY), FLOOR (AVG(SALARY)), MIN(SALARY), MAX(SALARY) 
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE ASC;

-- 부서 내 직급별로 직원 수, 급여 총합 조회
SELECT DEPT_CODE, JOB_CODE, COUNT(*), SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY DEPT_CODE, JOB_CODE ASC;
--------------------------------------------------------------------------------
/*
 HAVING : 그룹에 대한 조건을 제시할 때 사용하는 부분
*/
--부서별 평균 급여 조회
SELECT DEPT_CODE, FLOOR (AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 각 부서별 평균 급여가 300만원 이상인 부서만 조회
SELECT DEPT_CODE, FLOOR (AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING FLOOR (AVG(SALARY)) >= 3000000; -- 전 직원을 부서별로 묶어서 평균 급여가 300만원 이상인 데이터를 추려내서 조회


SELECT DEPT_CODE, FLOOR (AVG(SALARY))
FROM EMPLOYEE
WHERE SALARY >= 3000000  -- 직원의 급여가 300만원 이상인 데이터만 추려내서 조회
GROUP BY DEPT_CODE;

-- 직급 별 급여 총합 조회 (급여 총합이 1000만원 이상인 직급만 조화)
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000; 

-- 보너스를 받는 직원이 없는 부서 정보 조회
SELECT DEPT_CODE, COUNT(BONUS)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0;
--------------------------------------------------------------------------------
/*
 ROLLUP, CUBE : 그룹 별 산출 결과 값의 집계 계산 함수
 -ROLLUP : 전달 받은 그룹 중 가장 먼저 지정한 그룹 별로 추가적 집계 반환
 -CUBE : 전달 받은 그룹들로 가능한 모든 조합 별로 집계 반환
*/

-- 각 부서 내 직급 별 급여 합, 부서 별 급여 합, 전체 직원 급여 총합 조회

SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)"급여 총합"
FROM EMPLOYEE
GROUP BY ROLLUP (DEPT_CODE, JOB_CODE)
ORDER BY 1;

-- 부서별 급여 합, 직급별 급여 합, 부서내 직급별 급여 합, 전체 직원 급여 총합 조회

SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)"급여 총합",

 CASE
    WHEN GROUPING(DEPT_CODE) = 0 AND GROUPING(JOB_CODE) = 1 THEN '부서별 합계'
    WHEN GROUPING(DEPT_CODE) = 1 AND GROUPING(JOB_CODE) = 0 THEN '직급별 합계'
    WHEN GROUPING(DEPT_CODE) = 1 AND GROUPING(JOB_CODE) = 1 THEN '총 합계'
    ELSE '그룹별 합계'
 END "구분"
FROM EMPLOYEE
GROUP BY CUBE (DEPT_CODE, JOB_CODE)
ORDER BY 1;
--------------------------------------------------------------------------------
/*
 집합 연산자 : 여러개의 SQL문을 하나의 SQL문으로 만들어주는 연산자
 -UNION : 합집합(두 SQL문의 결과를 더해줌) -> OR와 유사
 -INTERSECT : 교집합 (두 SQL문을 수행한 결과의 중복되는 부분을 추출해줌) --> AND와 유사
 -UNION ALL : 합집합 + 교집합 형태 (중복되는 데이터는 두 번 조회될 수 있음)
 -MINUS : 차집합(선행 결과에서 후행 결과를 뺀 나머지)
*/

--부서코드가 D5인 사원 또는 급여가 300만원 초과인 사원들의 정보 조회(직원번호, 이름, 부서코드, 급여)
SELECT DEPT_CODE, EMP_NAME, EMP_ID, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' OR SALARY > 3000000

-- 부서코드가 D5 사원 조회
--WHERE DEPT_CODE = 'D5';

-- 급여가 300만원 초과인 사원 조회
--WHERE SALARY > 30000000;

--UNION 합집합

SELECT DEPT_CODE, EMP_NAME, EMP_ID, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT DEPT_CODE, EMP_NAME, EMP_ID, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

--UNION ALL 합집합 + 교집합

SELECT DEPT_CODE, EMP_NAME, EMP_ID, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION ALL
SELECT DEPT_CODE, EMP_NAME, EMP_ID, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- 부서코드가 D5이고 급여가 300만원 초과인 사원들의 정보 조회(직원번호, 이름, 부서코드, 급여)

SELECT DEPT_CODE, EMP_NAME, EMP_ID, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY > 3000000;

-- INTERSECT 교집합

SELECT DEPT_CODE, EMP_NAME, EMP_ID, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT DEPT_CODE, EMP_NAME, EMP_ID, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

--MINUS 차집합

SELECT DEPT_CODE, EMP_NAME, EMP_ID, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
MINUS
SELECT DEPT_CODE, EMP_NAME, EMP_ID, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

/*
 집합 연산자 사용 시 주의 사항
 1. SQL문들의 컬럼 개수가 동일
 2. 컬럼 자리마다 동일한 타입으로 작성
 3. 정렬하고자 한다면 ORDER BY절은 마지막에 작성
*/









