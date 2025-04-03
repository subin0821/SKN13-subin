/* *************************************
SELECT 기본 구문 - 연산자, 컬럼 별칭

  select 컬럼명, 컬럼명 [, .....]  => 조회할 컬럼 지정. *: 모든 컬럼
  from   테이블명                 => 조회할 테이블 지정.

- 컬럼명 [as 별칭] => 컬럼명으로 조회한 것을 별칭으로 보여준다. 
- distinct 컬럼명 => 중복된 결과를 제거한다.

참고: 
- Sql은 대소문자 구분 안함.
- sql문 실행: control+enter
*************************************** */

-- EMP 테이블의 모든 컬럼의 모든 항목을 조회.
use hr; -- db지정
select * from emp;

-- EMP 테이블의 직원 ID(emp_id), 직원 이름(emp_name), 업무(job) 컬럼의 값을 조회.
select emp_id, 
       emp_name, 
       job 
from emp;

-- EMP 테이블의 업무(job) 어떤 값들로 구성되었는지 조회. - 동일한 값은 하나씩만 조회되도록 처리.
select distinct job from emp; -- distinct(중복되는 것을 걸러냄)는 내가 조회하려는 컬럼 앞에 한번만 사용가능.
-- 범주형 컬럼에서 범주값이 어떻게 구성되었는지 확인.
select distinct job, dept_name from emp; -- 둘 항목을 합쳐서 같은것을 하나만 보여줘.

-- EMP 테이블에서 emp_id는 직원ID, emp_name은 직원이름, hire_date는 입사일, salary는 급여, dept_name은 소속부서 별칭으로 조회결과를 출력 한다.
 select emp_id as "직원 ID", -- 조회할 컬럼 as 별칭 (as 생략가능), 특수문자는 '_'만 가능, 띄어쓰기 하고 싶을 경우 " "로 묶어줌
        emp_name as "직원 이름",
        hire_date as "입사일",
        salary as "급여",
        dept_name as "소속부서"
from    emp;


/* **************************************
연산자 조회한 결과에 일괄적으로 적용.
- 산술 연산자 
	- +, -, *, /, %, mod, div (몫 연산) (10 / 2 = 10 div 2)
- 여러개 값을 합쳐 문자열로 반환 (type 상관없이 합쳐줌,)
	- concat(값, 값, ...)
- 피연산자가 null인 경우 결과는 null (10 + null = null)
- 연산은 그 컬럼의 모든 값들에 일률적으로 적용된다.
- 같은 컬럼을 여러번 조회할 수 있다.
************************************** */
-- EMP 테이블에서 직원의 이름(emp_name), 급여(salary), 급여(salary)을 연봉으로 조회. (곱하기 12)
select emp_name,
	   salary,
       salary * 12
from   emp;

select salary as "월급",
       salary*12 as "연봉",
       salary/30 as "일당",
       salary/30/24 as "시급"
from   emp;

-- EMP 테이블에서 직원의 ID(emp_id), 이름(emp_name), 급여(salary), 커미션_PCT(comm_pct), 급여에 커미션_PCT를 곱한 값을 조회.
select emp_id,
       emp_name,
       salary,
       comm_pct,
       salary * comm_pct as "커미션"
from   emp;
-- 행은 1개의 데이터(ex.한사람의 데이터) 컬럼끼리 계산은 같은 행에 있는 값을 계산하여 나온 값.

-- 직원 이름(emp_name)과 salary를 조회. salary앞에 '$' 를 붙여서 출력.
select emp_name,
       concat('$', salary, '달러') as "salary" -- '$' + salary는 불가.+연산자는 숫자만 계산 가능.
from   emp;

/* *************************************
where 절을 이용한 행 선택 (특정 조건의 행만 보고 싶을때 사용)

주의 : mysql은 비교시 대소문자를 가리지 않는다.
      ex) select * from emp where emp_name = 'steven'; Steven 조회된다.
     대소문자 구별해서 비교하게 하려면 컬럼명 앞에 BINARY를 붙인다.
	  ex) where BINARY emp_name = 'Steven' and BINARY job_id='aD_PRES';
************************************* */

-- EMP 테이블에서 직원_ID(emp_id)가 110인 직원의 이름(emp_name)과 부서명(dept_name)을 조회
select emp_id,
       emp_name,
       dept_name
from   emp
where  emp_id = 110;
 
-- EMP 테이블에서 'Sales' 부서에 속하지 않은 직원들의 ID(emp_id), 이름(emp_name),  부서명(dept_name)을 조회.
select emp_id,
       emp_name,
       dept_name
from   emp
where  dept_name <> 'Sales';
-- where  dept_name != 'Sales';

-- EMP 테이블에서 급여(salary)가 $10,000를 초과인 직원의 ID(emp_id), 이름(emp_name)과 급여(salary)를 조회
select emp_id,
       emp_name,
       salary
from   emp
where  salary > 10000;
 
-- EMP 테이블에서 커미션비율(comm_pct)이 0.2~0.3 사이인 직원의 ID(emp_id), 이름(emp_name), 커미션비율(comm_pct)을 조회.
select emp_id,
       emp_name,
       comm_pct
from   emp
where  comm_pct between 0.2 and 0.3;
-- where comm_pct >= 0.2
--  and  comm_pct <= 0.3;

-- EMP 테이블에서 업무(job)가 'IT_PROG' 거나 'ST_MAN' 인 직원의  ID(emp_id), 이름(emp_name), 업무(job)을 조회.
select emp_id,
       emp_name,
       job
from   emp
where  job in ('IT_PROG', 'ST_MAN');
-- where job = 'IT_PROG'
--   or  job = 'ST_MAN';

-- EMP 테이블에서 직원 이름(emp_name)이 S로 시작하는 직원의  ID(emp_id), 이름(emp_name)을 조회.
select emp_id,
	   emp_name
from   emp
where  emp_name like 'S%';
-- % : 0글자 이상의 모든 글자들. 'S%'-S뒤에 어떤게 와도 상관 없어.
-- 'Sha%' - Sha로 시작하는 
-- '%Sha%' - Sha를 포함하는
-- '%Sha' - Sha로 끝나는
-- '_' - 한글자의 모든 글자.
-- '_A__B_C' -무엇이든 한글자가 오고 두번째는 A이고 두글자가 오고 다섯번째는 B 이고 한글자가 오고 마지막은 C

-- EMP 테이블에서 직원 이름(emp_name)의 세 번째 문자가 “e”인 모든 사원의 이름을 조회
select emp_name
from   emp
where emp_name like '__e%';

-- EMP 테이블에서 직원의 이름에 '%' 가 들어가는 직원의 ID(emp_id), 직원이름(emp_name) 조회
--    %나 _ 를 검색하는 값으로 사용할 경우. 
select emp_id,
       emp_name
from   emp
where  emp_name like '%!%%' escape '!'; -- escape : 원래 의미대로 쓰지 말라는 뜻
-- '\n'

-- EMP 테이블에서 부서명(dept_name)이 null인 직원의 ID(emp_id), 이름(emp_name), 부서명(dept_name)을 조회.
select emp_id,
       emp_name,
       dept_name
from   emp
where  dept_name is null;

-- EMP 테이블에서 커미션이 있는(comm_pct가 null이 아닌)  직원들을 모든 컬럼값들을 조회
select *
from   emp
where  comm_pct is not null;

-- EMP 테이블에서 업무(job)가 'IT_PROG'인 직원들의 모든 컬럼값들을 조회. 
select *
from   emp
where  job = 'IT_PROG';

-- EMP 테이블에서 2004년에 입사한 직원들의 ID(emp_id), 이름(emp_name), 입사일(hire_date)을 조회.
-- 참고: date/datatime에서 년도만 추출: year(컬럼명)
-- 2004-01-01 ~ 2004-12-31
select emp_id,
       emp_name,
       hire_date
from   emp
where year(hire_date) = 2004;
-- where  hire_date between '2004-01-01' and '2004-12-31';
-- year(hire_date(날짜))-- date 값에서 년도만 추출

-- EMP 테이블에서 연봉(salary * 12) 이 200,000 이상인 직원들의 모든 정보를 조회.
select *
from   emp
where  salary*12 >= 200000;

/* ******************************************
 WHERE 조건이 여러개인 경우 AND 나 OR 로 조건들을 묶어준다.
 
 AND: 두 조건이 모두 True인 행만 조회
 OR: 두 조건 중 하나이상이 True인 행을 조회
 
 연산 우선순위: AND > OR
 	where 조건1 and 조건2 or 조건3
	  1. 조건 1 and 조건2
	  2. 1결과 or 조건3
 
 or를 먼저 하려면 where 조건1 and (조건2 or 조건3)
 *******************************************/
 
-- EMP 테이블에서 'SA_REP' 업무를 담당하는 직원들 중 급여(salary)가 $9,000인 직원의 직원의 ID(emp_id), 이름(emp_name), 업무(job), 급여(salary)를 조회.
select emp_id,
       emp_name,
	   job,
       salary
from   emp
where  job = 'SA_REP' 
and    salary >= 9000;

-- EMP 테이블에서 업무(job)가 'FI_ACCOUNT' 거나 급여(salary)가 $8,000 이상인 직원의 ID(emp_id), 이름(emp_name), 업무(job), 급여(salary)를 조회.
select emp_id,
       emp_name,
       job,
       salary
from   emp
where  job = 'FI_ACCOUNT'
or     salary >= 8000;

-- EMP 테이블에서  'Sales' 부서 직원 중 업무(job)가 'SA_MAN' 이고 급여가 $13,000 이하인 모든 정보를 조회
select *
from emp
where dept_name = 'Sales'
and   job = 'SA_MAN'
and   salary <= 13000;

-- EMP 테이블에서 업무(job)에 'MAN'이 들어가는 직원들 중에서 부서(dept_name)가 'Shipping' 이고 2005년이후 입사한 
--           직원들의 ID(emp_id), 이름(emp_name), 업무(job), 입사일(hire_date),부서(dept_name)를 조회
select emp_id,
       emp_name,
       job,
       hire_date,
       dept_name
from   emp
where  job like '%MAN%'
and    dept_name = 'Shipping'
and    hire_date >= '2005-01-01';
-- year(hire_date) >= 2005; 

-- EMP 테이블에서 업무(job)에 'MAN'이 들어가는 직원들 중에서 'Marketing' 이나 'Sales' 부서에 소속된 직원들의 ID(emp_id), 이름(emp_name), 업무(job), 부서(dept_name)를 조회
select emp_id,
       emp_name,
       job,
       dept_name
from   emp
where  job like '%MAN'
and    (dept_name = 'Marketing'
or     dept_name = 'Sales');
-- and    dept_name in ('Marketing', 'Sales');


/* *******************************************************************
order by를 이용한 정렬 (대상컬럼을 알려줘야함,정렬방식을 알려줘야함.(오름 or 내림) 방식은 생략가능 default = 오름차순)
- order by절은 select문의 마지막 구문으로 온다.
- order by 정렬기준컬럼 정렬방식 [, ...]
    - 정렬기준컬럼 지정 단위: 컬럼이름, 컬럼의순번(select절의 선언 순서)
     `select salary, hire_date from emp ...` 에서 salary 컬럼 기준 정렬을 설정할 경우. 
     `order by salary 또는 order by 1` 로 작성.
	 
    - 정렬방식
        - ASC : 오름차순, 기본방식(생략가능)
        - DESC : 내림차순
		
문자열 오름차순 : 숫자 -> 대문자 -> 소문자 -> 한글     
Date 오름차순 : 과거 -> 미래
null 오름차순 : null이 먼저 나온다.  GUIDE: 오라클은 반대.

ex)
order by salary asc, emp_id desc
- salary로 전체 정렬을 하고 salary가 같은 행은 emp_id로 정렬.
******************************************************************* */

--  직원들의 전체 정보를 직원 ID(emp_id)가 큰 순서대로 정렬해 조회 (내림차순)
select *
from   emp
order by emp_id desc;
-- order by가 없을때에는 데이터를 가장 빠르게 가져올 수 있는 순으로 가져옴.

--  직원들의 id(emp_id), 이름(emp_name), 업무(job), 급여(salary)를 
--  업무(job) 순서대로 (A -> Z) 조회하고 업무(job)가 같은 직원들은 급여(salary)가 높은 순서대로 2차 정렬해서 조회.
select emp_id,
       emp_name,
       job,
       salary
from   emp
-- order by job asc, salary desc;
order by 3 asc, 4 desc;

-- 부서명을 부서명(dept_name)의 오름차순으로 정렬해 조회하시오.
select dept_name
from   emp
order by dept_name asc;
-- null이 가장 작은값

-- 급여(salary)가 $5,000을 넘는 직원의 ID(emp_id), 이름(emp_name), 급여(salary)를 급여가 높은 순서부터 조회
select emp_id,
       emp_name,
       salary
from   emp
where  salary > 5000
-- order by salary desc;
order by 3 desc; -- select한 컬럼의 몇번째인지 지정.(순번으로 기준 컬럼을 지정.)


