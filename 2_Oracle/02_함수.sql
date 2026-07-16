
/*
 INSTR: 문자열로 부터 특정 문자의 시작 위치를 반환
 
 INSTR(문자열, '특정문자'[, 찾을위치의 시작값, 순번]) => 결과는 숫자 탑입
*/

SELECT INSTR('AABAACAABBAA', 'B')-- 앞에서부터 첫번째 B의 위치: 3 
--(문자열, 특정문자)
FROM DUAL;

SELECT INSTR('AABAACAABBAA', 'B', 1)-- 찾을 위치의 시작값을 1로 지정 => 결과는 위와 동일
--(문자열, 특정문자, 시작위치)
FROM DUAL;

SELECT INSTR('AABAACAABBAA', 'B', -1)-- 음수(-)로 쓰면 맨뒤에 걸 찾음
--(문자열, 특정문자, 뒤에서부터 찾을)
FROM DUAL;

SELECT INSTR('AABAACAABBAA', 'B', 1, 2)-- 앞에서 부터 2번째로 찾은 위치
--(문자열, 특정문자, 시작위치, 특정문자를 2번째로 찾은)
FROM DUAL;

-- 직원 정보 중 이메일의 _의 첫번째 위치, 0의 첫번째 위치 조회(이메일, _의 위치, @의 위치)
SELECT EMAIL, INSTR(EMAIL, '_', 1, 1) , INSTR(EMAIL, '@')
FROM EMPLOYEE;
--------------------------------------------------------------------------------
/*
 SUBSTR: 문자열에서 특정 문자열을 추출해서 반환 => 결과가 문자타입
 
 SUBSTR(문자열, 시작위치[, 길이])
 => 길이를 지정하지 않으면 문자열 끝까지 추출함
*/

SELECT SUBSTR('ORACLE SQL DEVELOPER', 10)
FROM DUAL;

--SQL 부분만 추출
SELECT SUBSTR('ORACLE SQL DEVELOPER', 8, 3)
FROM DUAL;

-- 끝에서 3번째 위치부터 문자열 끝까지 추출
SELECT SUBSTR('ORACLE SQL DEVELOPER', -3)
FROM DUAL;

-- 직원들의 이름, 주빈번호 조회
SELECT EMP_NAME, EMP_NO
FROM EMPLOYEE;

-- 여직원 정보만 조회
SELECT EMP_NAME, EMP_NO
FROM EMPLOYEE
WHERE SUBSTR (EMP_NO, 8, 1) IN('2','4');

-- 남직원 정보만 조회
SELECT EMP_NAME, EMP_NO
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN('1','3')
ORDER BY EMP_NAME ASC;

-- 직원 정보를 조회 (이름, 이메일, 아이디)
-- 함수를 중첩해서 사용
-- 1. 이메일에서 @ 위치를 찾기 -> INSTR
-- 2. 이메일에서 첫번째 위치부터 @ 위치까지만 추출 -> SUBSTR
-- 3.
SELECT EMP_NAME, EMAIL, INSTR(EMAIL, '@') "@ 위치"
FROM EMPLOYEE;

SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')-1 ) "ID"
FROM EMPLOYEE;
--------------------------------------------------------------------------------
/*
 LPAD / RPAD: 문자열을 조회할 때 통일감 있게 조회하고자 할때 사용
              문저열에 덧붙히고자 하는 문자를 왼쪽 또는 오른쪽에 붙여서 최종 길이만큼 문자열을 반환
              => 결과는 문자 타입
 LPAD(문자열, 최종길이[, 덧붙일문자]) => 왼쪽에 덧붙일 문자를 채움
 RPAD(문자열, 최종길이[, 덧붙일문자]) => 오른쪽에 덧붙일 문자를 채움
 => 덧붙일문자가 생략될 경우 공백으로 채움
*/
SELECT EMP_NAME, LPAD(EMP_NAME, 20) 이름
FROM EMPLOYEE;

SELECT EMP_NAME, RPAD(EMP_NAME, 20) 이름
FROM EMPLOYEE;

SELECT EMAIL, LPAD(EMAIL, 20) 이메일
FROM EMPLOYEE;

-- 주민번호 뒷자리를 숨겨서 조회
SELECT RPAD('050706-3', 14, '*')
FROM DUAL;

-- 직원 정보 중 주민번호 뒷자를 *로 표시하며 조회(이름, 주민번호)
-- 주민번호에서 8자리를 추출
-- 나머지 길이만큼은 * 채움
SELECT EMP_NAME, SUBSTR(EMP_NO, 1, 8)
FROM EMPLOYEE

SELECT EMP_NAME, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*')
FROM EMPLOYEE;
--------------------------------------------------------------------------------
/*
 LTRIM / RTRIM: 문자열에서 특정 문자를 제거한 후 나머지를 반환
 
 LTRIM(문자열[,제거하고자하는 문자들]) => 왼쪽에서 제거
 RTRIM(문자열[,제거하고자하는 문자들]) => 오른쪽에서 제거
 => 제거할문자 생략 시 공백을 제거함
 
*/

SELECT LTRIM('       H I') // -> 왼쪽 공백들이 모두 제거 
FROM DUAL;

SELECT RTRIM('       H I       ') // -> 오른쪽 공백들이 모두 제거
FROM DUAL;

SELECT LTRIM('123123H123', '123')// -> 1, 2, 3 하나씩 체크해서 제거함
FROM DUAL;

SELECT RTRIM('123123H123', '123')
FROM DUAL;
/*
 TRIM: 문자열 앞/뒤/양쪽에 있는 지정한 문자들을 제거한 후 반환
                => 결과는 문자 타입
 TRIM(LEADING 또는 TRAILING 또는 BOTH [제거할 문자 FROM] 문자열)
 => 제거할문자 생략 시 공백을 제거
 => 위치 옵션 생략 시 양쪽에서 제거
*/

SELECT TRIM('       H I       ')
FROM DUAL;

SELECT TRIM('L' FROM 'LLLLHLLLLLL')
FROM DUAL;

SELECT TRIM(LEADING 'L' FROM 'LLLLHLLLLLL') // -> LTRIM 과 유사
FROM DUAL;

SELECT TRIM(TRAILING'L' FROM 'LLLLHLLLLLL') // -> RTRIM 과 유사
FROM DUAL;

SELECT TRIM(BOTH'L' FROM 'LLLLHLLLLLL') // -> 양쪽 지정한 특정 문자 다 제거
FROM DUAL;
--------------------------------------------------------------------------------
/*
 LOWER / UPPER / INITCAP
 
 LOWER(문자열) : 알파벳을 모두 소문자로 변환
 UPPER(문자열) : 알파벳을 모두 대문자로 변환
 INITCAP(문자열) : 공백을 기준으로 첫 글자마다 대문자로 변경해서 반환
*/
-- No pain, no Gain
SELECT LOWER('No pain, no Gain') // -> 소문자
FROM DUAL;

SELECT UPPER('No pain, no Gain') // -> 대문자
FROM DUAL;

SELECT INITCAP('No pain, no Gain') // -> No Pain, No Gain
FROM DUAL;
--------------------------------------------------------------------------------
/*
 CONCAT : 문자열 두 개를 하나의 문자열로 합쳐서 반환
 COMCAT(문자열1, 문자열2)
*/
SELECT('KH', || 'D강의장')
FROM DUAL;

SELECT CONCAT('KH', 'C강의장')
FROM DUAL;

-- 2층 KH C강의장
SELECT CONCAT('2층', CONCAT('KH', 'C강의장'))
FROM DUAL;

--직원 정보를 조회(출력형식: 직원번호 직원명)
SELECT CONCAT(EMP_ID, EMP_NAME)
FROM EMPLOYEE;

SELECT CONCAT(CONCAT(EMP_ID, EMP_NAME), '님')
FROM EMPLOYEE;
--------------------------------------------------------------------------------
/*
 REPLACE : 문자열에서 특정 부분을 다른 값으로 교체하여 반환
 REPLACE(문자열, 특정부분(문자열), 교체할값(문자열))
*/
SELECT REPLACE ('서울시 강남구 역삼동', '역삼동', '삼성동')
FROM DUAL;

--직원들의 이메일 '@KH.OR.KR 부분을 '@GMAIL.COM'으로 변경하여 조회(이메일, 변경된 이메일)
SELECT REPLACE (EMAIL, '@kh.or.kr', '@gmail.com')
FROM EMPLOYEE;
--------------------------------------------------------------------------------
/*
 숫자 타입의 데이터 처리 함수
 ABS : 숫자의 절대값(-,+ 없이 숫자만)을 반환한다.
 ABS(숫자)
*/
SELECT ABS(-10)
FROM DUAL;

SELECT ABS(-12.34)
FROM DUAL;
--------------------------------------------------------------------------------
/*
 MOD : 두 수를 나눈 나머지 값을 구해주는 함수 (자바기준 '/' 연산자)
 MOD(숫자1, 숫자2) -> 숫자1 % 숫자2
*/
SELECT MOD(10,3)
FROM DUAL;

SELECT MOD(10.9,3)
FROM DUAL;
--------------------------------------------------------------------------------
/*
 []: 생략가능
 ROUND: 반올림한 결과를 반환
 ROUND(숫자[,위치])
 => 위치 생략 시 소숫점 첫째자리에서 반올림
*/
SELECT ROUND(123.456) -- 값 123
FROM DUAL;

SELECT ROUND(123.456,1) -- 123.5  소수점 첫번째 자리값까지
FROM DUAL;

SELECT ROUND(123.456,2) -- 123.46 소수점 두번째 자리값까지
FROM DUAL;

SELECT ROUND(123.456,-1) -- 120 일의 자리에서 반올림
FROM DUAL;

SELECT ROUND(123.456,-2) -- 120 십의 자리에서 반올림
FROM DUAL;
--------------------------------------------------------------------------------
/*
 CEIL : 올림처리
 CEIL(숫자)
*/
SELECT CEIL(123.456)  -- 124 그냥 올림 (반올림X)
FROM DUAL;
/*
 FLOOR : 버림처리
 FLOOR(숫자)
*/
SELECT FLOOR(123.456)  -- 123 그냥 소수점 다 버림
FROM DUAL;
/*
 TRUNC : 버림처리(위치지정 가능)
 TRUNC(숫자, 위치)
*/
SELECT TRUNC(123.456) -- 123
FROM DUAL;

SELECT TRUNC(123.456, 1) --123.4 소수점 첫번째 자리 빼고 다 버림
FROM DUAL;

SELECT TRUNC(123.456, -1) -- 120 일의 자리에서 버림
FROM DUAL;
--------------------------------------------------------------------------------
/*
 날짜 타입의 데이터 처리 함수
*/

SELECT SYSDATE -- 시스템 기준 현재 날짜 시간 정보(컴터 날짜 바꾸면 바꾼 날짜로 나옴)
FROM DUAL;

/*
 MONTHS_BETWEEN : 두 날짜의 개월 수를 반환
 MONTHS_BETWEEN(날짜1, 날짜2) : 날짜1 - 날짜2 => 개월 수
*/

--직원의 근속 개월 수 조회(이름 ,입사일, 근속 개월 수)
-- 437 -> 437 개월차
SELECT EMP_NAME, HIRE_DATE, CONCAT(CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)),'개월차')
FROM EMPLOYEE;

-- 공부시작한 지 몇 개월차 26/06/11
SELECT CEIL(MONTHS_BETWEEN(SYSDATE, '26/06/11'))
FROM DUAL;

-- 수료까지 몇 개월 남았는지 26/12/16
SELECT FLOOR (MONTHS_BETWEEN('26/12/16', SYSDATE))
FROM DUAL;
--------------------------------------------------------------------------------
/*
 ADD_MONTHS : 특정 날짜에 N개월 수를 더해서 반환
 ADD_MONTHS(날짜, 더할개월수)
*/

-- 현재 날짜 기준으로 3개월 후 조회
SELECT ADD_MONTHS(SYSDATE, 3)
FROM DUAL;

-- 직원들의 수습 종료일 조회(이름, 입사일, 입사일+3개월)
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 3)"수습 종료일"
FROM EMPLOYEE;
--------------------------------------------------------------------------------
/*
 NEXT_DAY : 특정 날짜 이후로 지정한 요일의 가장 가까운 날짜를 반환
 NEXT_DAY(날짜, 요일)
 => 요일 : 문자 또는 숫자
 1: 일 2: 월 3:화 ... 7: 토
*/

-- 현재 날짜 기준으로 가장 가까운 금요일의 날짜 조회
SELECT NEXT_DAY(SYSDATE, 6)
FROM DUAL;

ALTER SESSION SET NLS_LANGUAGE = KOREAN;
SELECT NEXT_DAY(SYSDATE, '금요일')
FROM DUAL;

SELECT NEXT_DAY(SYSDATE, '금')
FROM DUAL;

--ALTER SESSION SET NLS_LANGUAGE = AMERICAN; -- 언어 설정하는 법
SELECT NEXT_DAY(SYSDATE, 'FRIDDAY') -- 언어설정에 따라 실행, 한국어로 설정되어 있어 실행X 
FROM DUAL;
SELECT NEXT_DAY(SYSDATE, 'FRI') 
FROM DUAL;
--------------------------------------------------------------------------------
/*
 LAST_DAY : 해당 월의 마지막 날짜를 구해주는 함수
 LAST_DAY(날짜)
*/
-- 이번 달의 마지막 날짜 조회
SELECT LAST_DAY(SYSDATE)
FROM DUAL;

-- 직원 정보 조회 (이름, 입사일(고용일), 입사한 달의 마지막 날짜, 입사한 달의 근무일수)
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE)"입사한 달의 마지막 날짜" , LAST_DAY(HIRE_DATE) - HIRE_DATE +1 근무일수
FROM EMPLOYEE;
--------------------------------------------------------------------------------
/*
 EXTRACT : 특정 날짜로부터 연도/월/일 값을 추출해서 반환
 EXTRACT(YEAR FROM 날짜) : 연도추출
 EXTRACT(MONTH FROM 날짜) : 월 추출
 EXTRACT(DAY FROM 날짜) : 일 추출
*/
-- 현재날짜를 기준으로 연/월/일 추출
SELECT EXTRACT (YEAR FROM SYSDATE) 연도,
EXTRACT (MONTH FROM SYSDATE) 월,
EXTRACT (DAY FROM SYSDATE) 일
FROM DUAL;

--직원 정보 조회(이름, 입사년도, 입사월, 입사일) 정렬 오름차순 - 입사년도>입사월>입사일
SELECT EMP_NAME, EXTRACT(YEAR FROM HIRE_DATE)입사연, EXTRACT (MONTH FROM HIRE_DATE)입사월, EXTRACT (DAY FROM HIRE_DATE)입사일
FROM EMPLOYEE
--ORDER BY EXTRACT(YEAR FROM HIRE_DATE), EXTRACT (MONTH FROM HIRE_DATE), EXTRACT (DAY FROM HIRE_DATE);
--ORDER BY 입사연, 입사월, 입사일;
ORDER BY 2,3,4;
--------------------------------------------------------------------------------
/*
 형변환 함수 : 데이터 타입을 변환해주는 함수
              - 문자 /숫자 / 날자
              
 TO_CHAR : 숫자 또는 날짜 
 TO_CHAR(데이터, 포맷)
*/

-- 숫자 -> 문자
SELECT 1234 "숫자 타입", TO_CHAR(1234) "문자 타입" 
FROM DUAL;

SELECT TO_CHAR(1234), TO_CHAR(1234, '999999'), 
FROM DUAL;
--> '9' : 개수만큼 자릿수를 확보, 빈칸은 공백으로 채움

SELECT TO_CHAR(1234), TO_CHAR(1234, '000000')
FROM DUAL;
--> '0' : 개숫만큼 자릿수를 확보, 빈칸은 0으로 채움

SELECT TO_CHAR(1234, 'L999999')
FROM DUAL;
--> 'L' : 화폐단위 표시

-- 직원 정보 (이름, 급여, 연봉) 화폐단위 표시
SELECT EMP_NAME, TO_CHAR(SALARY, 'L9,999,999,999'), TO_CHAR(SALARY*12, 'L9,999,999,999')연봉
FROM EMPLOYEE;
--------------------------------------------------------------------------------

-- 날짜 -> 문자

SELECT SYSDATE, TO_CHAR(SYSDATE)
FROM DUAL;

/*
 YYYY : 연도 4글자로 표현(2026)
 YY : 연도 2글자(26)
 MM : 월
 DD : 일
 
 HH : 시 정보 -> 12시간제
 HH24 : 시 정보 -> 24시간제
 MI : 분
 SS : 초  
*/

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24::MI:SS')
FROM DUAL;

/*
 DAY : 요일 정보(X 요일)
 DY : 요일 정보 (X)
*/

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD DAY DY')
FROM DUAL;

/*
 MONTH, MON : 월 정보(X월)
*/
SELECT TO_CHAR(SYSDATE, 'MONTH MON')
FROM DUAL;

-- 직원 정보  조회(이름, 입사일) (입사일 : XXXX년 XX월 XX일)
SELECT  EMP_NAME, TO_CHAR(HIRE_DATE, 'YYYY-MM-DD')
FROM EMPLOYEE
--> 표시할 문자(값 자체)는 큰 따옴표("")로 묶어서 형식을 지정해야 함
-- ('YYYY"년" MM"월" DD"일"')
--------------------------------------------------------------------------------
/*
 TO_NUMBER : 문자 타입의 데이터를 숫자 타입으로 변환
 TO_NUMBER(데이터,포멧)
 => 포멧을 지정하는 경우는 기호가 포함되거나, 화폐단위가 포함된 경우
*/

SELECT TO_NUMBER('0123456789')
FROM DUAL;

SELECT '100000' + '500'
FROM DUAL;

SELECT '10,000' + '500' -- > 오류 발생
FROM DUAL;

SELECT TO_NUMBER ('10,000', '99,999') + ('500')
FROM DUAL;

SELECT TO_NUMBER ('10,000', '99,999') +  TO_NUMBER('500', '999')
FROM DUAL;
--------------------------------------------------------------------------------
/*
 TO_DATE : 숫자 타입 또는 문자 타입을 날짜 타입으로 변환
 TO_DATE(데이터, 포맷)
*/

SELECT TO_DATE (20260706)
FROM DUAL;

SELECT TO_DATE (260706)
FROM DUAL;

SELECT TO_DATE (960706)
FROM DUAL;
-- 현재 연도 기준으로 자동으로 50년 미만 데이터는 2000년대 로 변환 
-- 50년 이상 데이터는 1900년대 로 변환 

SELECT TO_DATE (060706) -- 060706 -> 60706 (숫자 0은 입력되지 않기 때문에) 오류
FROM DUAL;

SELECT TO_DATE ('060706') -- 0으로 시작하는 날짠느 문자 타입으로 제시
FROM DUAL;

SELECT TO_DATE ('260706 143940') --TO_DATE 기본 포멧 : YYYYMMDD 또는 YYMMDD 일것임
FROM DUAL;

SELECT TO_DATE ('260706 143940', 'YYMMDD HH24MISS')
FROM DUAL;
--------------------------------------------------------------------------------
/*
 NULL 처리 함수
*/

/*
 NVL : 해당 컬럼의 값이 NULL인 경우 다른 값으로 대체해주는 함수
 NVL(컬럼명, 대체할값)
 -> 대체할값: 해당 컬럼의 값이 NULL인 경우 사용
*/
--직원 정보 조회(이름, 보너스)
SELECT EMP_NAME, NVL(BONUS, 0)
FROM EMPLOYEE;

SELECT EMP_NAME, (SALARY + (SALARY * NVL(BONUS,0)))*12
FROM EMPLOYEE;

/*
 NVL2 : 해당 컬럼이 NULL일 경우 표시할 값을 지정하고
 NULL이 아닐경우 표시할 값도 지정할 수 있는 함수
 NVL2(컬럼명, NULL이 아닐 경우 대체할 값, NULL일 경우 대체할 값)
*/
-- 직원 정보 조회(이름, 보너스, 보너스 유무)

SELECT EMP_NAME, BONUS, NVL2(BONUS, 'O', 'X')
FROM EMPLOYEE;

-- 이름, 부서코드, 부서배치여부
SELECT EMP_NAME, DEPT_CODE, NVL2(DEPT_CODE, '배정완료', '미배정')
FROM EMPLOYEE;

/*
 NULLIF : E두 값이 일치하면 NULL, 일치하지 않으면 비교 대상1 값을 반환
 NULLIF(비교대상1, 비교대상2)
*/
SELECT NULLIF('999', '999') -- 값이 NULL
FROM DUAL;

SELECT NULLIF('999', '777')
FROM DUAL;
--------------------------------------------------------------------------------
/*
 선택함수
 DECODE(비교대상, 비교값1, 결과값1, 비교값2, 결과값2 ...)
 => 배교대상 : 컬럼명, 연산식, 함수식, ...
 
 => 자바에서 SWITCH와 유사
    
*/
-- 직원 정보 조회(직원번호, 이름, 주민번호, 성별)
SELECT EMP_ID, EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8, 1)성별
FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, EMP_NO, DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여')성별
FROM EMPLOYEE;

-- 이름, 급여, 인상될 급여 조회
/*
 직급이J7이면 10%인상
 직급이J6이면 15%인상
 직급이J5이면 20%인상
 나머지 5%인상
*/
SELECT EMP_NAME, SALARY,
DECODE(JOB_CODE, 'J7', SALARY*1.1, 'J6', SALARY*1.15, 'J5', SALARY*1.2, SALARY*1.05)"인상될 급여"
FROM EMPLOYEE;

/*
 CASE WHEN THEN : 조건식에 따라 결과값을 반환해주는 구문
 CASE WHEN 조건식1: THEN: 결과값1
      WHEN 조건식2: THEN: 결과값2
      WHEN 조건식3: THEN: 결과값3
      ..
      ELSE 결과값
      END
*/
--이름, 급여, 급여에 따른 등급 조회
/*
 급여가 500만원 이상 고급
 급여가 350만원 이상 중급
 나머지 초급
*/
SELECT EMP_NAME, SALARY, CASE WHEN SALARY >= 5000000 THEN'고급'
WHEN SALARY >= 3500000 THEN'중급'
ELSE '초급'
END
FROM EMPLOYEE;
--------------------------------------------------------------------------------
-- 그룹 함수 --
/*
 SUM : 해당 컬럼 값들의 총 합을 반환
 SUM(데이터)
 => 데이터는 숫자 타입
*/
-- 전체 직원들의 총 급여 조회
SELECT SUM(SALARY)
FROM EMPLOYEE;

-- W70,096,240 형식으로 조화
SELECT TO_CHAR(SUM(SALARY),'L999,999,999')
FROM EMPLOYEE;

--남직원들의 총 급여 조회
--조건절 추가

SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('1', '3');

--여직원들의 총 급여

SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('2', '4');

-- 부서코드가 D5인 직원들의 총 급여
SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

--
SELECT SUM(SALARY*12)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

--------------------------------------------------------------------------------
/*
 AVG : 해당 칼럼의 값들의 평균을 반환
 AVG(데이터)
 => 데이터는 숫자 타입
 */
 -- 직원들의 평균 급여 조회
 
 SELECT ROUND(AVG(SALARY))
 FROM EMPLOYEE;
 
 /*
 MIN / MAX : 가장 작은 값 / 가장 큰 값 반환
 MIN(데이터) / MAX(데이터)
 => 데이터는 모든 타입(숫자, 날짜, 문자)
 */
 
 SELECT MIN(EMP_NAME) "문자 타입 최솟값", MIN(SALARY) "숫자 타입 최솟값", MIN(HIRE_DATE) "날짜 타입 최솟값"
 FROM EMPLOYEE;
 
 SELECT MAX(EMP_NAME) "문자 타입 최대값", MAX(SALARY) "숫자 타입 최대값", MAX(HIRE_DATE) "날짜 타입 최대값"
 FROM EMPLOYEE;
 
 /*
 COUNT : 행의 갯수를 반환 (단, 조건이 있을 경우 해당 조건에 맞는 행의 개수 반환)
 COUNT(*) : 조회된 결과의 모든 행 갯수 반환
 COUNT(컬럼) : 해당 컬럼값이 NULL이 아닌 것만 세어서 갯수를 반환
 COUNT(DISTINCT 컬럼) : 해당 컬럼값의 중복을 제거한 후의 갯수 반환
                      -> 중복 제거 시 NULL은 포함하지 않고 세어짐
 */
 -- 전체 사원 수 조회
 SELECT COUNT(*)
 FROM EMPLOYEE;
 
 --남직원 수 조회
 SELECT COUNT(*)
 FROM EMPLOYEE
 WHERE SUBSTR(EMP_NO, 8, 1) IN ('1','3');
 
 --보너스를 받는 직원 수
 SELECT COUNT(BONUS)
 FROM EMPLOYEE;
 
 
 

