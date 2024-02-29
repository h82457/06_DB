/*
    * SUBQUERY (서브쿼리)
    - 하나의 SQL문 안에 포함된 또다른 SQL문
    - 메인쿼리(기존쿼리)를 위해 보조 역할을 하는 쿼리문
    -- SELECT, FROM, WHERE, HAVGIN 절에서 사용가능

*/  

-- 서브쿼리 예시 1.
-- 부서코드가 노옹철사원과 같은 소속의 직원의 
-- 이름, 부서코드 조회하기

-- 1) 사원명이 노옹철인 사람의 부서코드 조회
SELECT DEPT_CODE  
FROM EMPLOYEE e 
WHERE EMP_NAME = '노옹철';

-- 2) 부서코드가 D9인 직원을 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- 3) 부서코드가 노옹철사원과 같은 소속의 직원 명단 조회   
--> 위의 2개의 단계를 하나의 쿼리로!!! --> 1) 쿼리문을 서브쿼리로!!
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE  
									FROM EMPLOYEE e 
									WHERE EMP_NAME = '노옹철');
-- ㄴ> 메인쿼리      -- ㄴ>D9, 서브쿼리, 괄호 안에 작성되어 메인쿼리보다 먼저 처리됨
                   
                   
-- 서브쿼리 예시 2.
-- 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의 
-- 사번, 이름, 직급코드, 급여 조회

-- 1) 전 직원의 평균 급여 조회하기
SELECT AVG(SALARY)
FROM EMPLOYEE;

-- 2) 직원들중 급여가 3047663원 이상인 사원들의 사번, 이름, 직급코드, 급여 조회
SELECT EMP_ID 사번, EMP_NAME 이름, JOB_CODE 직급코드, SALARY 급여
FROM EMPLOYEE
WHERE SALARY >= 3047662 ; -- <-  1의 결과값

-- 3) 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원 조회
--> 위의 2단계를 하나의 쿼리로 가능하다!! --> 1) 쿼리문을 서브쿼리로!!
SELECT EMP_ID 사번, EMP_NAME 이름, JOB_CODE 직급코드, SALARY 급여
FROM EMPLOYEE
WHERE SALARY >= (SELECT AVG(SALARY) FROM EMPLOYEE);
                 


-------------------------------------------------------------------

/*  서브쿼리 유형

    - 단일행 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 1개일 때 (1행 1열)
    
    - 다중행 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 여러개일 때 (N행 1열)
    
    - 다중열 서브쿼리 : 서브쿼리의 SELECT 절에 자열된 항목수가 여러개 일 때 (1행 N열)
    
    - 다중행 다중열 서브쿼리 : 조회 결과 행 수와 열 수가 여러개일 때 (N행 N열)
    
    - 상관 서브쿼리 : 서브쿼리가 만든 결과 값을 메인 쿼리가 비교 연산할 때 
                     메인 쿼리 테이블의 값이 변경되면 서브쿼리의 결과값도 바뀌는 서브쿼리
                     
    - 스칼라 서브쿼리 : 상관 쿼리이면서 결과 값이 하나인 서브쿼리
    
   * 서브쿼리 유형에 따라 서브쿼리 앞에 붙은 연산자가 다름
    
*/


-- 1. 단일행 서브쿼리 (SINGLE ROW SUBQUERY)
--    서브쿼리의 조회 결과 값의 개수가 1개인 서브쿼리
--    단일행 서브쿼리 앞에는 비교 연산자 사용
--    <, >, <=, >=, =, !=/^=/<>


-- 전 직원의 급여 평균보다 많은 급여를 받는 직원의 
-- 이름, 직급, 부서, 급여를 직급 순으로 정렬하여 조회
SELECT EMP_NAME 이름, JOB_NAME 직급명, DEPT_TITLE 부서명, SALARY 급여
FROM EMPLOYEE E, JOB J, DEPARTMENT
WHERE E.JOB_CODE  = J.JOB_CODE
AND DEPT_CODE = DEPT_ID(+)
AND SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE)
ORDER BY J.JOB_CODE;


-- 가장 적은 급여를 받는 직원의
-- 사번, 이름, 직급, 부서코드, 급여, 입사일을 조회
SELECT EMP_ID 사번, EMP_NAME 이름, JOB_NAME 직급, DEPT_CODE 부서코드, SALARY 급여, HIRE_DATE 입사일
FROM EMPLOYEE
NATURAL JOIN JOB -- 자연 조인 (컬럼명, 타입 일치하는 컬럼끼리 연결)
WHERE SALARY = (SELECT MIN(SALARY) FROM EMPLOYEE);


                 
-- 노옹철 사원의 급여보다 많이 받는 직원의 
-- 사번, 이름, 부서, 직급, 급여를 조회
SELECT EMP_ID 사번, EMP_NAME 이름, DEPT_TITLE 부서, JOB_NAME 직급, SALARY 급여
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE SALARY > 
	(SELECT SALARY
	FROM EMPLOYEE
	WHERE EMP_NAME = '노옹철');
        
 
-- 부서별(부서가 없는 사람 포함) 급여의 합계 중 가장 큰 부서의
-- 부서명, 급여 합계를 조회 

-- 1) 부서별 급여 합 중 가장 큰값 조회
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 2) 부서별 급여합이 17700000인 부서의 부서명과 급여 합 조회
SELECT DEPT_TITLE 부서명, SUM(SALARY) 급여합
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) = 17700000;

-- 3) >> 위의 두 서브쿼리 합쳐 부서별 급여 합이 큰 부서의 부서명, 급여 합 조회
SELECT DEPT_TITLE 부서명, SUM(SALARY) "급여 합"
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) =
	(SELECT MAX(SUM(SALARY))
	FROM EMPLOYEE
	GROUP BY DEPT_CODE);


-- 부서별 인원수가 3명 이상인 부서의
-- 부서명, 인원수 조회 (서브쿼리X)
SELECT NVL(DEPT_TITLE, '없음') 부서명, COUNT(*) "인원 수"
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
GROUP BY DEPT_TITLE
HAVING COUNT(*) >= 3;

                      
-- 부서별 인원수가 가장 적은 부서의
-- 부서명, 인원 수 조회 (서브쿼리O)               
SELECT 
	NVL(DEPT_TITLE, '없음') "부서명", 
	COUNT(*) "인원 수"
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
GROUP BY DEPT_TITLE
HAVING COUNT(*) = 
	(SELECT MIN(COUNT(*))
	FROM EMPLOYEE
	GROUP BY DEPT_CODE);
	


-------------------------------------------------------------------------

-- 2. 다중행 서브쿼리 (MULTI ROW SUBQUERY) <- N행 1열
--    서브쿼리의 조회 결과 값의 개수가 여러행일 때 

/*
    >> 다중행 서브쿼리 앞에는 일반 비교연산자 사용 x
    
    - IN / NOT IN : 여러 개의 결과값 중에서 한 개라도 일치하는 값이 있다면
                    혹은 없다면 이라는 의미(가장 많이 사용!)
    - > ANY, < ANY : 여러개의 결과값 중에서 한개라도 큰 / 작은 경우
                     가장 작은 값보다 큰가? / 가장 큰 값 보다 작은가?
    - > ALL, < ALL : 여러개의 결과값의 모든 값보다 큰 / 작은 경우
                     가장 큰 값 보다 큰가? / 가장 작은 값 보다 작은가?
    - EXISTS / NOT EXISTS : 값이 존재하는가? / 존재하지 않는가?
    
*/

-- 부서별 최고 급여를 받는 직원의 
-- 이름, 직급, 부서, 급여를 부서 순으로 정렬하여 조회
--1) 부서별 최고 급여 조회
SELECT MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 2)
SELECT EMP_NAME 이름, JOB_CODE 직급, DEPT_CODE 부서, SALARY 급여
FROM EMPLOYEE
WHERE SALARY IN
	(SELECT MAX(SALARY)
	FROM EMPLOYEE
	GROUP BY DEPT_CODE); --> IN 내부 서부쿼리 결과 7행, 다중형 서브쿼리

	
-- 사수에 해당하는 직원에 대해 조회 
--  사번, 이름, 부서명, 직급명, 구분(사수 / 직원)

-- 1) 사수에 해당하는 사원 번호 조회
SELECT DISTINCT MANAGER_ID
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL;

-- 2) 직원의 사번, 이름, 부서명, 직급 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
JOIN JOB USING (JOB_CODE);

-- 3) 사수에 해당하는 직원에 대한 정보 추출 조회 (이때, 구분은 '사수'로)
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '사수' "구분"
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
JOIN JOB USING (JOB_CODE)
WHERE EMP_ID IN (
	SELECT DISTINCT MANAGER_ID
	FROM EMPLOYEE
	WHERE MANAGER_ID IS NOT NULL);

-- 4) 일반 직원에 해당하는 사원들 정보 조회 (이때, 구분은 '사원'으로)
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '사원' "구분"
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
JOIN JOB USING (JOB_CODE)
WHERE EMP_ID NOT IN (
	SELECT DISTINCT MANAGER_ID
	FROM EMPLOYEE
	WHERE MANAGER_ID IS NOT NULL);
            
-- 5) 3, 4의 조회 결과를 하나로 합침 -> SELECT절 SUBQUERY
-- * SELECT 절에도 서브쿼리 사용할 수 있음
-- * 집합 연산자 (UNION, NUION ALL)
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '사수' "구분"
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
JOIN JOB USING (JOB_CODE)
WHERE EMP_ID IN (
	SELECT DISTINCT MANAGER_ID
	FROM EMPLOYEE
	WHERE MANAGER_ID IS NOT NULL)

UNION

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '사원' "구분"
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
JOIN JOB USING (JOB_CODE)
WHERE EMP_ID NOT IN (
	SELECT DISTINCT MANAGER_ID
	FROM EMPLOYEE
	WHERE MANAGER_ID IS NOT NULL);


-- * 선택함수(DECODE, CASE) 이용 *

SELECT 
	EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME,
	CASE 
		WHEN EMP_ID IN (
			SELECT DISTINCT MANAGER_ID
			FROM EMPLOYEE
			WHERE MANAGER_ID IS NOT NULL
		)
		THEN '사수'
		ELSE '사원'
	END "구분"
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
JOIN JOB USING (JOB_CODE)
ORDER BY EMP_ID;


-- 대리 직급의 직원들 중에서 과장 직급의 최소 급여보다 많이 받는 직원의
-- 사번, 이름, 직급, 급여를 조회하세요
-- 단, > ANY 혹은 < ANY 연산자를 사용하세요

-- > ANY, < ANY : 여러개의 결과값 중에서 하나라도 큰 / 작은 경우
--                     가장 작은 값보다 큰가? / 가장 큰 값 보다 작은가?

-- 1) 직급이 대리인 직원들의 사번, 이름, 직급명, 급여 조회
SELECT EMP_ID 사번, EMP_NAME 이름, JOB_NAME 직급명, SALARY 급여
FROM EMPLOYEE
NATURAL JOIN JOB
WHERE JOB_NAME = '대리';

-- 2) 직급이 과장인 직원들 급여 조회
SELECT SALARY 급여
FROM EMPLOYEE
NATURAL JOIN JOB
WHERE JOB_NAME = '과장';

-- 3) 대리 직급의 직원들 중에서 과장 직급의 최소 급여보다 많이 받는 직원
-- 3-1) MIN을 이용하여 단일행 서브쿼리를 만듦.
SELECT EMP_ID 사번, EMP_NAME 이름, JOB_NAME 직급명, SALARY 급여
FROM EMPLOYEE
NATURAL JOIN JOB
WHERE JOB_NAME = '대리'
AND SALARY > (
	SELECT MIN(SALARY) -- 220만,250만,375만<- 서브쿼리 1개, 행 1개 ~> 비교 불가, MIN사용
	FROM EMPLOYEE
	NATURAL JOIN JOB
	WHERE JOB_NAME = '과장'
); --2200000

-- 3-2) ANY를 이용하여 과장 중 가장 급여가 적은 직원 초과하는 대리를 조회
SELECT EMP_ID 사번, EMP_NAME 이름, JOB_NAME 직급명, SALARY 급여
FROM EMPLOYEE
NATURAL JOIN JOB
WHERE JOB_NAME = '대리'
AND SALARY > ANY ( -- 하나라도 더 크다고 판별시 결과에 포함
	SELECT SALARY
	FROM EMPLOYEE
	NATURAL JOIN JOB
	WHERE JOB_NAME = '과장'
); 



-- 차장 직급의 급여의 가장 큰 값보다 많이 받는 과장 직급의 직원
-- 사번, 이름, 직급, 급여를 조회하세요
-- 단, > ALL 혹은 < ALL 연산자를 사용하세요

-- > ALL, < ALL : 여러개의 결과값의 모든 값보다 큰 / 작은 경우
--                     가장 큰 값 보다 크냐? / 가장 작은 값 보다 작냐?
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE  JOB_NAME = '과장'
AND SALARY  > ALL (
	SELECT SALARY 
	FROM EMPLOYEE JOIN JOB USING (JOB_CODE)
	WHERE JOB_NAME = '차장'
) ;


                      
                      
-- 서브쿼리 중첩 사용(응용편!)


-- LOCATION 테이블에서 NATIONAL_CODE가 KO인 경우의 LOCAL_CODE와
-- DEPARTMENT 테이블의 LOCATION_ID와 동일한 DEPT_ID가 
-- EMPLOYEE테이블의 DEPT_CODE와 동일한 사원을 구하시오.

-- 1) LOCATION 테이블을 통해 NATIONAL_CODE가 KO인 LOCAL_CODE 조회
SELECT LOCAL_CODE 
FROM LOCATION
WHERE NATIONAL_CODE = 'KO'; -- L1 (단일행 서브쿼리)

-- 2)DEPARTMENT 테이블에서 위의 결과와 동일한 LOCATION_ID를 가지고 있는 DEPT_ID를 조회
SELECT DEPT_ID
FROM DEPARTMENT
WHERE LOCATION_ID = (
	SELECT LOCAL_CODE 
	FROM LOCATION
	WHERE NATIONAL_CODE = 'KO' -- 5행 (다중행 서브쿼리)
);

-- 3) 최종적으로 EMPLOYEE 테이블에서 위의 결과들과 동일한 DEPT_CODE를 가지는 사원을 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE IN (
	SELECT DEPT_ID
	FROM DEPARTMENT
	WHERE LOCATION_ID = (
		SELECT LOCAL_CODE 
		FROM LOCATION
		WHERE NATIONAL_CODE = 'KO'
	)
);
                      


-----------------------------------------------------------------------

-- 3. 다중열 서브쿼리 (단일행 = 결과값은 한 행) <- N행 N열
--    서브쿼리 SELECT 절에 나열된 컬럼 수가 여러개 일 때

-- 퇴사한 여직원과 같은 부서, 같은 직급에 해당하는
-- 사원의 이름, 직급, 부서, 입사일을 조회        

-- 1) 퇴사한 여직원 조회
SELECT EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE ENT_YN = 'Y'
AND SUBSTR(EMP_NO, 8, 1) = '2'; -- 여직원
--> D8 J6

-- 2) 퇴사한 여직원과 같은 부서, 같은 직급 (다중 열 서브쿼리)

-- 단일열 서브쿼리
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE 
FROM EMPLOYEE
WHERE DEPT_CODE = (
	SELECT DEPT_CODE
	FROM EMPLOYEE
	WHERE ENT_YN = 'Y' -- 퇴사 여부 'Y'
	AND SUBSTR(EMP_NO,8,1) = '2'
)
AND JOB_CODE = (
	SELECT JOB_CODE
	FROM EMPLOYEE
	WHERE ENT_YN = 'Y' -- 퇴사 여부 'Y'
	AND SUBSTR(EMP_NO,8,1) = '2'
);

-- 다중열 서브쿼리
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE 
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = ( --'D8', 'J6'
SELECT DEPT_CODE, JOB_CODE
	FROM EMPLOYEE
	WHERE ENT_YN = 'Y'
	AND SUBSTR(EMP_NO, 8, 1) = '2'
);
--> 값 하나씩 비교 X -> 묶음 전체의 값이 같은지 비교 O


-------------------------- 연습문제 -------------------------------
-- 1. 노옹철 사원과 같은 부서, 같은 직급인 사원을 조회하시오. (단, 노옹철 사원은 제외)
--    사번, 이름, 부서코드, 직급코드, 부서명, 직급명

SELECT EMP_NO 사번, EMP_NAME 이름, DEPT_CODE 부서코드, JOB_CODE 직급코드, DEPT_TITLE 부서명, JOB_NAME 직급명
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
JOIN JOB USING (JOB_CODE)
WHERE (DEPT_CODE, JOB_CODE) = (

SELECT DEPT_CODE 부서코드, JOB_CODE 직급코드
	FROM EMPLOYEE e 
	WHERE EMP_NAME = '노옹철' -- D9, J2
)
AND EMP_NAME != '노옹철';


-- 2. 2000년도에 입사한 사원의 부서와 직급이 같은 사원을 조회하시오
--    사번, 이름, 부서코드, 직급코드, 고용일
SELECT EMP_ID 사번, EMP_NAME 이름, DEPT_CODE 부서코드, JOB_CODE 직급코드, HIRE_DATE 고용일
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (

	SELECT DEPT_CODE, JOB_CODE
	FROM EMPLOYEE
	WHERE EXTRACT(YEAR FROM HIRE_DATE) = 2000 -- 204
);



-- 3. 77년생 여자 사원과 동일한 부서이면서 동일한 사수를 가지고 있는 사원을 조회하시오
--    사번, 이름, 부서코드, 사수번호, 주민번호, 고용일     
SELECT EMP_ID 사번, EMP_NAME 이름, DEPT_CODE 부서코드, MANAGER_ID 사수번호, EMP_ID 주민번호, HIRE_DATE 고용일
FROM EMPLOYEE
WHERE (DEPT_CODE, MANAGER_ID) = (

	SELECT DEPT_CODE, MANAGER_ID 
	FROM EMPLOYEE
		WHERE SUBSTR(EMP_NO,1,2) = '77'
		AND   SUBSTR(EMP_NO,8,1) = '2'
);


----------------------------------------------------------------------
--(IN, ANY, ALL)	((col,col) IN)
-- 4. 다중행 			다중열 서브쿼리
--    서브쿼리 조회 결과 행 수와 열 수가 여러개 일 때

-- 본인 직급의 평균 급여를 받고 있는 직원의
-- 사번, 이름, 직급, 급여를 조회하세요
-- 단, 급여와 급여 평균은 만원단위로 계산하세요 TRUNC(컬럼명, -4)    

-- 1) 급여를 200, 600만 받는 직원 (200만, 600만이 평균급여라 생각 할 경우)
SELECT EMP_ID 사번, EMP_NAME 이름, JOB_CODE 직급, SALARY 급여
FROM EMPLOYEE
WHERE SALARY IN (2000000, 6000000); 

-- 2) 직급별 평균 급여
SELECT JOB_CODE, TRUNC(AVG(SALARY),-4)
FROM EMPLOYEE
GROUP BY JOB_CODE; -- 결과: 7행

-- 3) 본인 직급의 평균 급여를 받고 있는 직원
SELECT EMP_ID 사번, EMP_NAME 이름, JOB_CODE 직급, SALARY 급여
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (

	SELECT JOB_CODE, TRUNC(AVG(SALARY),-4)
	FROM EMPLOYEE
	GROUP BY JOB_CODE
); 
                  
                
-------------------------------------------------------------------------------

-- 5. 상[호연]관 서브쿼리
--    상관 쿼리는 메인쿼리가 사용하는 테이블값을 서브쿼리가 이용해서 결과를 만듦
--    메인쿼리의 테이블값이 변경되면 서브쿼리의 결과값도 바뀌게 되는 구조임


-- ***************************************************************
-- 상관쿼리는 먼저 메인쿼리 한 행을 조회하고
-- 해당 행이 서브쿼리의 조건을 충족하는지 확인하여 SELECT를 진행함
-- ***************************************************************



-- 직급별 급여 평균보다 급여를 많이 받는 직원의 
-- 이름, 직급코드, 급여 조회
SELECT JOB_CODE, AVG(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE; -- J5 - 282만 ....

SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE MAIN -- 메인 쿼리 테이블 별칭: MAIN
WHERE SALARY > (

		SELECT AVG(SALARY)
		FROM EMPLOYEE SUB -- 서브 쿼리 테이블 별칭: SUB
		WHERE SUB.JOB_CODE = MAIN.JOB_CODE  /*메인에서 전달 받은 행의 값*/
--		ㄴ> MAIN에서 전달 받은 JOB_CODE 직급의 평균 급여 조회
);

/* 1) 메인 쿼리 한 행의 값을 서브쿼리로 전달
 * 2) 서브쿼리에서 전달 받은 값을 이용해서 SELECT 수행
 * 		ㄴ> SELECT 결과를 다시 메인 쿼리로 반환
 * 3) 메인 쿼리에서 반환 받은 값을 이용해 해당 행의 결과 포함 여부 결정
 * */


-- 부서별 입사일이 가장 빠른 사원의
--    사번, 이름, 부서명(NULL이면 '소속없음'), 직급명, 입사일을 조회하고
--    입사일이 빠른 순으로 조회하세요
--    단, 퇴사한 직원은 제외하고 조회하세요

-- (특정 부서에서)
-- 'D1'  부서에서 가장 입사일이 빠른 사람
SELECT MIN(HIRE_DATE)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';


SELECT EMP_ID, EMP_NAME, DEPT_CODE,
	NVL(DEPT_TITLE, '소속없음'), JOB_NAME, HIRE_DATE
FROM EMPLOYEE "MAIN"
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)

WHERE HIRE_DATE = (

	/* 메인 쿼리에서 전달 받은 행의 컬럼 값 중 DEPT_CODE 값을 이용,
	 * 해당 부서에서 가장 빠른 입사일을 조회 */
	SELECT MIN(HIRE_DATE)
	FROM EMPLOYEE "SUB"
	WHERE NVL("SUB".DEPT_CODE, '소속없음') = NVL("MAIN".DEPT_CODE, '소속없음')
--	ㄴ> NULL은 비교가 불가 - NULL이 아닌 비교 가능한 값으로 변경 필요 => NVL
	
	AND ENT_YN != 'Y' --> 해당사항만 제거를 위해 서브쿼리에 작성
)
--AND ENT_YN != 'Y' <- 메인 쿼리에서 제외사항 작성시 결과에서 컬럼이 제거됨
ORDER BY HIRE_DATE;


-- 사수가 있는 직원의 사번, 이름, 부서명, 사수사번 조회
SELECT EMP_ID 사번, EMP_NAME 이름, DEPT_TITLE 부서명, MANAGER_ID 사수사번
FROM EMPLOYEE "MAIN"
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE EXISTS (
	SELECT EMP_ID
	FROM EMPLOYEE "SUB"
	WHERE "SUB".EMP_ID = "MAIN".MANAGER_ID
);


-- EXISTS (서브쿼리) : 서브쿼리 결과(RESULT SET)에 행이 존재한다면 TRUE, 없으면 FLASE
--	(WHERE 1 = 0) -- <- FLASE 메인으로 보내주는 값 X

----------------------------------------------------------------------------------

-- 6. 스칼라 서브쿼리 (SELECT절 작성하는 단일행 서브쿼리)
--    SELECT절에 사용되는 서브쿼리 결과로 1행만 반환
--    SQL에서 단일 값을 가르켜 '스칼라'라고 함

-- 각 직원들이 속한 직급의 급여 평균 조회
SELECT EMP_NAME, JOB_CODE, JOB_CODE || '의 평균 급여',
	(SELECT FLOOR(AVG(SALARY))
	FROM EMPLOYEE "SUB"
	WHERE "SUB".JOB_CODE = "SUB".JOB_CODE) "평균 급여"
	
FROM EMPLOYEE "MAIN";


-- 모든 사원의 사번, 이름, 관리자사번, 관리자명을 조회
-- 단 관리자가 없는 경우 '없음'으로 표시
-- (스칼라 + 상관 쿼리)
SELECT EMP_NAME 사번, EMP_NAME 이름, MANAGER_ID 관리자사번,
	
	NVL(( SELECT EMP_NAME
		FROM EMPLOYEE "SUB"
		WHERE SUB.EMP_ID = MAIN.MANAGER_ID
	), '없음') "관리자명" -- NVL((서브쿼리), '없음')

	FROM EMPLOYEE "MAIN";




-----------------------------------------------------------------------


-- 7. 인라인 뷰(INLINE-VIEW)
--    FROM 절에서 서브쿼리를 사용하는 경우로
--    서브쿼리가 만든 결과의 집합(RESULT SET)을 테이블 대신에 사용한다.

-- (VIEW : 조회만 가능한 가상 테이블)

-- 인라인뷰를 활용한 TOP-N분석
-- 전 직원 중 급여가 높은 상위 5명의
-- 순위, 이름, 급여 조회

--1) 전 직원 급여 내림차순으로 조회
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC;

--2_ ROWNUM : 행 번호를 나타내는 가상 컬럼
	--> SELECT절 해석되는 당시의 행 번호를 기입!

SELECT ROWNUM, EMP_NAME
FROM EMPLOYEE
WHERE ROWNUM <= 5;

--3) ROWNUM을 이용해서 급여 상위 5위 조회
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
--WHERE ROWNUM <= 5
ORDER BY SALARY DESC;
--[문제 발생]--
-- ㄴ> SELECT 절이 ORDER BY 보다 먼저 해석되어 ROWNUM 순서가 급여 순서가 아닌 ,조회된 행 순서로 지정됨

/*인라인 뷰 이용 + 문제 해결*/
SELECT ROWNUM, EMP_NAME, SALARY
FROM (
	/* 급여 내림차순으로 정렬된 EMPLOYEE 테이블 조회 */
	SELECT EMP_NAME, SALARY
	FROM EMPLOYEE
	ORDER BY SALARY DESC --> 조회 결과가 메인 쿼리의 테이블 역할!!
)
WHERE ROWNUM <= 5;


-- * ROWNUM 사용 시 주의사항 *
-- ROWNUM을 WHERE절에 사용할 때
-- 항상 범위에 1부터 연속적인 범위가 포함되어야 한다
SELECT ROWNUM, EMP_NAME, SALARY 
FROM  (SELECT EMP_NAME, SALARY
	   FROM EMPLOYEE
	   ORDER BY SALARY DESC)
--WHERE ROWNUM = 1; -- 1행만 조회 **
--WHERE ROWNUM = 2; -- 2행만 조회 --> 실패
WHERE ROWNUM BETWEEN 1 AND 10; --> 1부터 포함해야된다!




-- 급여 평균이 3위 안에 드는 부서의 부서코드와 부서명, 평균급여를 조회
SELECT ROWNUM, DEPT_CODE, DEPT_TITLE, "평균 급여" --인라인뷰에 표시된 컬럼명 사용
FROM(
	/*인라인뷰*/
	SELECT DEPT_CODE, DEPT_TITLE, FLOOR(AVG(SALARY)) "평균 급여"
	FROM EMPLOYEE
	LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
	GROUP BY DEPT_CODE, DEPT_TITLE
	ORDER BY "평균 급여" DESC
)
WHERE ROWNUM <=3; 
------------------------------------------------------------------------

-- 8. WITH
--    서브쿼리에 이름을 붙여주고 사용시 이름을 사용하게 함
--    인라인뷰로 사용될 서브쿼리에 주로 사용됨
--    실행 속도도 빨라진다는 장점이 있다. 

-- 
-- 전 직원의 급여 순위 
-- 순위, 이름, 급여 조회, 단 10위까지만 조회

SELECT ROWNUM, EMP_NAME, SALARY
FROM(

	SELECT EMP_NAME, SALARY 
	FROM EMPLOYEE
	ORDER BY SALARY DESC
)
WHERE ROWNUM <= 10;


WITH TOP_SALARY -- 서브쿼리 이름 지정
AS (
	SELECT EMP_NAME 이름, SALARY 급여
	FROM EMPLOYEE
	ORDER BY SALARY DESC
)

SELECT ROWNUM 순위, 이름, 급여
FROM TOP_SALARY
WHERE ROWNUM <= 10;

--------------------------------------------------------------------------


-- 9. RANK() OVER / DENSE_RANK() OVER
-- 급여를 많이 받는 순서대로 조회
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC;



-- RANK() OVER : 동일한 순위 이후의 등수를 동일한 인원 수 만큼 건너뛰고 순위 계산
--               EX) 공동 1위가 2명이면 다음 순위는 2위가 아니라 3위

SELECT EMP_NAME, SALARY,
	RANK() OVER(ORDER BY SALARY DESC)
FROM EMPLOYEE;



-- DENSE_RANK() OVER : 동일한 순위 이후의 등수를 이후의 순위로 계산
--                     EX) 공동 1위가 2명이어도 다음 순위는 2위



-----------------------------------------------------------------------

-- SELECT 관련 KEY POINT !! --

/* 1. 테이블 구조 파악
 * 
 * 2. SELECT 해석 순서
 *   + 별칭 사용이 가능한 부분
 *    EX) ORDER BY 절에서는 SELECT절에서 해석된 별칭 사용 가능
 * 	  EX) 인라인뷰에서 지정된 별칭을 메인쿼리에서도 똑같이 사용해야된다
 * 
 * 3. 여러 테이블을 이용한 SELECT 진행 시
 *    컬럼명이 겹치는 경우 이를 해결하는 방법
 * 	
 *    EX) 셀프 조인->텡블별로 별칭 지정
 *    EX) 상관 쿼리-> 테이블별 별 칭 지정
 *    EX) 다른 테이블이여도 컬럼명이 같을 때 -> 테이블별 별칭 지정, 테이브명.커럼명 지정
 * 
 *  4. 조회하려는 데이터 (목적, 요구사항)을 확실하게 파악
 * 
 * 
 * */

-- 1. 전지연 사원이 속해있는 부서원들을 조회하시오 (단, 전지연은 제외) 
-- 사번, 사원명, 전화번호, 고용일, 부서명
SELECT EMP_ID 사번, EMP_NAME 사원명, PHONE 전화번호, HIRE_DATE 고용일, DEPT_TITLE 부서명
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
--WHERE EMP_NAME = '전지연'; --> D1
WHERE DEPT_CODE = (
	SELECT DEPT_CODE
	FROM EMPLOYEE
	WHERE EMP_NAME = '전지연'
)
AND EMP_NAME != '전지연';


-- 2. 고용일이 2000년도 이후인 사원들 중 급여가 가장 높은 사원의  
-- 사번, 사원명, 전화번호, 급여, 직급명을 조회하시오. 
SELECT EMP_ID 사번, EMP_NAME 사원명, PHONE 전화번호, SALARY 급여, DEPT_TITLE 직급명
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE (SALARY, DEPT_ID) IN (

	SELECT MAX(SALARY), DEPT_ID
	FROM EMPLOYEE
	WHERE EXTRACT (YEAR FROM HIRE_DATE) > 2000
);

-- 3. 노옹철 사원과 같은 부서, 같은 직급인 사원을 조회하시오. (단, 노옹철 사원은 제외) 
-- 사번, 이름, 부서코드, 직급코드, 부서명, 직급명
SELECT EMP_ID 사번, EMP_NAME 이름, DEPT_CODE 부서코드, JOB_CODE 직급코드, DEPT_TITLE 부서명, JOB_NAME 직급명
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
NATURAL JOIN JOB
WHERE (DEPT_CODE, JOB_CODE) IN (

	SELECT DEPT_CODE, JOB_CODE 
	FROM EMPLOYEE
	WHERE EMP_NAME = '노옹철'
)
AND EMP_NAME != '노옹철';


-- 4. 2000년도에 입사한 사원과 부서와 직급이 같은 사원을 조회하시오 --    
-- 사번, 이름, 부서코드, 직급코드, 고용일 


SELECT EMP_ID 사번, EMP_NAME 이름, DEPT_CODE 부서코드, JOB_CODE 직급코드, HIRE_DATE 고용일
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) IN (
	SELECT DEPT_CODE, JOB_CODE
	FROM EMPLOYEE
	WHERE EXTRACT (YEAR FROM HIRE_DATE) = 2000 -- D6, J3
);

-- 5. 77년생 여자 사원과 동일한 부서이면서 동일한 사수를 가지고 있는 사원을 조회하시오 --    
-- 사번, 이름, 부서코드, 사수번호, 주민번호, 고용일 
SELECT EMP_ID 사번, EMP_NAME 이름, DEPT_CODE 부서코드, MANAGER_ID 사수번호, EMP_NO 주민번호, HIRE_DATE 고용일
FROM EMPLOYEE
WHERE (DEPT_CODE, MANAGER_ID) IN (

	SELECT DEPT_CODE, MANAGER_ID
	FROM EMPLOYEE
	WHERE SUBSTR(EMP_NO, 1, 2) = '77'
	AND SUBSTR(EMP_NO, 8, 1) = '2'
);


-- 6. 부서별 입사일이 가장 빠른 사원의           
--사번, 이름, 부서명(NULL이면 '소속없음'), 직급명, 입사일을 조회하고 
--입사일이 빠른 순으로 조회하시오 
--단, 퇴사한 직원은 제외하고 조회.. 
SELECT EMP_ID 사번, EMP_NAME 이름, NVL(DEPT_CODE, '소속없음') 부서명, DEPT_TITLE 직급명, HIRE_DATE 입사일
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE HIRE_DATE IN (
	
	SELECT MIN(HIRE_DATE)
	FROM EMPLOYEE
	WHERE ENT_YN = 'N'
	GROUP BY DEPT_CODE
)
ORDER BY HIRE_DATE;

-- 7. 직급별 나이가 가장 어린 직원의 
-- 사번, 이름, 직급명, 나이, 보너스 포함 연봉을 조회하고 
-- 나이순으로 내림차순 정렬하세요 
-- 단 연봉은 \124,800,000 으로 출력되게 하세요. (\ : 원 단위 기호)
SELECT EMP_ID 사번, EMP_NAME 이름, DEPT_TITLE 직급명, EMP_NO 나이, SALARY * BONUS * 12 "보너스 포함 연봉"
FROM EMPLOYEE
--LEFT JOIN DEPARTMENT (DEPT_CODE = DEPT_ID);


















