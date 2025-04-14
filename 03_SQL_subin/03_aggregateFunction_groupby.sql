/* **************************************************************************
집계(Aggregation) 함수와 GROUP BY, HAVING
************************************************************************** */

/*******************************************************************************************
# 집계함수, 그룹함수, 다중행 함수

- 인수(argument)는 컬럼. => (null값을 무시하고 계산.)
  - sum(): 전체합계
  - avg(): 평균 = 전체 데이터가 아니라 값이 있는 것들의 평균  (평균만으로는 값의 분포를 정확히 파악하기 어려우므로 표준편차와 분산을 같이 봄)
  - min(): 최소값
  - max(): 최대값
  - stddev(): 표준편차 (표준편차, 분산은 값의 분포를 보여줌. 표준편차가 적으면 평균 근처에 있다는 의미. 반대는 평균보다 멀다.)
  - variance(): 분산
  - count(): 개수   (null을 제외한 실제값이 몇개가 있는지)
        - 인수: 
            - 컬럼명: null을 제외한 값들의 개수.
            -  *: 총 행수 - null과 관계 없이 센다.
  - count(distinct 컬럼명): 고유값의 개수. (몇개의 값으로 구성되어있는지)
  
- count(*) 를 제외한 모든 집계함수들은 null을 제외하고 집계한다. 
	- (avg, stddev, variance는 주의)
	- avg(), variance(), stddev()은 전체 개수가 아니라 null을 제외한 값들의 평균, 분산, 표준편차값이 된다.=>avg(ifnull(컬럼, 0))
- 문자타입/일시타입: max(), min(), count()에만 사용가능
	- 문자열 컬럼의 max(): 사전식 배열에서 가장 마지막 문자열, min()은 첫번째 문자열. 
	 - 특수문자 < 숫자 < 대문자 < 소문자 < 한글
	- 일시타입 컬럼은 오래된 값일 수록 작은 값이다. (어제가 더 작은 값 오늘이 더 큰 값)

******************************************************************************************* */
-- '10000' - min 
-- '600' - max (문자열로 정렬할때에는 1과 6이라는 숫자의 순서에 따라 비교. 값의 크기의 순서가 아님. 앞의 숫자가 같으면 다음 값을 비교)

-- EMP 테이블에서 급여(salary)의 총합계, 평균, 최소값, 최대값, 표준편차, 분산, 총직원수를 조회 
select sum(salary),
       round(avg(salary), 2), -- 반올림 round( , )
       min(salary),
       max(salary),
       round(stddev(salary), 2),
       round(variance(salary),2)
from   emp;

select count(*) from emp; -- 총 직원수

-- EMP 테이블에서 가장 최근 입사일(hire_date)과 가장 오래된 입사일을 조회
select max(hire_date) as "최근입사일",
       min(hire_date) as "가장 오래된 입사일"
from   emp;

-- EMP 테이블의 부서(dept_name) 의 개수를 조회
select count(dept_name)   -- 부서테이블의 결측치 없는 값.= 부서가 있는 직원수
from   emp;
-- 부서가 몇개
select count(distinct dept_name) 
from emp;
-- null 포함한 부서 수
select count(distinct ifnull(dept_name, 'a')) 
from emp;
--  커미션 비율(comm_pct)이 있는 직원의 수를 조회
select count(comm_pct)
from   emp;

--  최고 급여액과 최저 급여액 그리고 그 둘의 차액을 출력
select max(salary), as "a"
       min(salary), as "b"
       a -b
from   emp;  -- emp테이블엔 a,b가 없으므로 계산 불가 컬럼끼리 계산할때는 실제 컬러안에 있는 값을 가지고만 계산가능.

select max(salary) as "max salary",
       min(salary) as "min salary",
       max(salary) - min(salary) as "차액"
from   emp;  

-- 가장 긴 직원 이름(emp_name)이 몇글자 인지 조회.
select max(char_length(emp_name))
from emp;

select emp_name, max(char_length(emp_name)) -- 표는 사각형이여야 하는데 행기준 모든 행은 컬럼이 같아야함. 모든열은 행 수가 같아야함.
from   emp;                                -- 행은 하나의 데이터이므로 데이터 형식의 정확성이 떨어지므로 집계한 결과에 일반컬럼을 붙여서 확인할 수 없음.


/* **************
group by 절
- 특정 컬럼(들)의 값별로 행들을 나누어 집계할 때 기준컬럼을 지정하는 구문. (~~별 ~~에대한 집계)
	- 예) 업무별 급여평균. 부서-업무별 급여 합계. 성별 나이평균 (범주형 컬럼 사용(그룹으로 나눌때 사용하는 컬럼)ex.혈액형,업무)
- 구문
  - group by 컬럼명 [, 컬럼명] ex. group by A(A안에 같은값끼리 그룹), gruop by A,B(A,B컬럼 각각의 값을 합쳐서 같은 것끼리 그룹)- 대분류,중분류,소분류
    - 컬럼명
      - 집계를 위해 group으로 묶어줄 기준 컬럼명을 지정한다.
      - select절에 기준컬럼을 지정한 경우 컬럼 순번(1부터 시작)으로 지정할 수있다. -- select 절에 group by로 지정한 컬럼이 있으면 같이 올 수 있다.
      - 지정한 기준 컬럼(들)이 같은 값을 가지는 행들이 같은 그룹으로 묶인다.
      - 같은 그룹으로 묶인 행들의 값을 기준으로 집계한다.
      - 기준 컬럼은 범주형 컬럼을 사용한다. 부서별 급여 평균 => 부서컬럼, 성별 급여 합계 => 성별컬럼
	- group by 절은 select의 where 절 다음에 기술한다.
	- select 절의 컬럼은 group by 에서 선언한 기준 컬럼들만 집계함수와 같이 올 수 있다.
	
****************/

-- 업무(job)별 급여의 총합계, 평균, 최소값, 최대값, 표준편차, 분산, -- 직원수를 조회
select job, -- 어떤 업무인지에 대해서 보여주기 위해 group by한것을 select에 넣어줌.
       sum(salary),
       avg(salary),
       min(salary),
       max(salary),
       stddev(salary),
       variance(salary)
from emp
group by job;
 -- 직원수를 조회
 select job,
        count(*)
 from emp
 group by job
 order by 2;
 
-- 입사연도 별 직원들의 급여 평균.
select year(hire_date),
       avg(salary)
from emp
group by year(hire_date)-- 함수가 처리한 결과가 같은 행끼리 group으로 묶는다.
order by 1; 

-- 부서명(dept_name) 이 'Sales'이거나 'Purchasing' 인 직원들의 업무별 (job) 직원수를 조회. 직원수가 많은 순서대로 정렬.
select job,
       count(*) as "직원수"
from emp
where dept_name in ('Sales', 'Purchasing')
group by job;

-- 부서(dept_name), 업무(job) 별 최대, 평균급여(salary)를 조회.
select dept_name,
	   job,
       max(salary) as "최대급여",
       avg(salary) as "평균급여"
from   emp
group by dept_name,
         job;

-- 급여(salary) 범위별 직원수를 출력. 급여 범위는 10000 미만,  10000이상 두 범주.
select if (salary < 10000, '만 미만', '만 이상'),
       count(*) as "직원수"
from   emp
group by if(salary < 10000, '만 미만', '만 이상');

-- 부서명(dept_name), 업무(job)별 직원수, 최고급여(salary)를 조회. 부서이름으로 오름차순 정렬.
select dept_name,
	   job,
	   count(*),
	   max(salary) 
from   emp
group by dept_name,
		 job
order by 1;

-- 입사년도와(hire_date) 업무(job)가 같은 직원들의 평균 급여(salary)을 조회
select year(hire_date),
       job,
       avg(salary)
from   emp
group by year(hire_date),
         job
order by 1; -- 년도 기준

-- 부서별(dept_name) 직원수 조회하는데 부서명(dept_name)이 null인 것은 제외하고 조회.
select dept_name,
       count(*)
from   emp
where dept_name is not null
group by dept_name;


/* **************************************************************
having 절
- group by 로 나뉜 그룹을 filtering 하기 위한 조건을 정의하는 구문.
- group by 다음 order by 전에 온다.
- 구문
    having 제약조건  
		- 연산자는 where절의 연산자를 사용한다. 
		- 피연산자는 집계함수(의 결과)
		
-  where절은 행을 filtering한다.
   having절은 group by 로 묶인 그룹들을 filtering한다.		
************************************************************** */

-- 직원수가 10명 이상인 부서의 부서명과 그 부서 직원들의 평균 급여를 조회.
select dept_name,
       avg(salary)
from   emp
group by dept_name
having count(*) >=10;

-- 20명 이상이 입사한 년도와 (그 해에) 입사한 직원수를 조회.
select year(hire_date) as "입사년도",
       count(*) as "직원수"
from  emp
group by year(hire_date)
having count(*) >= 20
order by 1;

-- 평균 급여가(salary) $5000 이상인 부서의 이름(dept_name)과 평균 급여(salary), 직원수를 조회
select dept_name,
       avg(salary),
       count(*)
from   emp
group by dept_name
having avg(salary) >= 5000;

-- 평균급여가 $5,000 이상이고 총급여가 $50,000 이상인 부서의 부서명(dept_name), 평균급여와 총급여를 조회
select dept_name, 
       avg(salary) as "평균급여",
	   sum(salary) as "총급여"
from   emp
group by dept_name
having avg(salary) >= 5000 and sum(salary) >=50000;

--  커미션이 있는 직원들의 입사년도별 평균 급여를 조회. 단 평균 급여가 $9,000 이상인 년도분만 조회.
select year(hire_date),
       avg(salary)
from   emp
where comm_pct is not null
group by year(hire_date)
having avg(salary) >= 9000
order by 2; -- 평균 salary가 작은 순으로.
-- 실행 순서 1.from 2.where(행) 3.group by 4.having 5.select 6.order by(정렬)


