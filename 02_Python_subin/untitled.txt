import requests
from bs4 import BeautifulSoup
import pandas as pd
import mysql

# 1. URL과 헤더 설정
url = "https://taas.koroad.or.kr/sta/acs/gus/selectSidoTfcacd.do?menuId=WEB_KMP_OVT_MVT_TAG_SDT"
headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
}

# 2. GET 요청 및 응답 받기
response = requests.get(url, headers=headers)
response.encoding = 'utf-8'  # 인코딩 설정
soup = BeautifulSoup(response.text, "lxml")

# 3. 데이터가 포함된 테이블 찾기
table = soup.find("table", class_="table01")
if not table:
    print("테이블을 찾을 수 없습니다.")
    exit()

# 4. 테이블의 각 행을 순회하며 데이터 추출 (헤더 제외)
data = []
rows = table.find_all("tr")
for row in rows[1:]:  # 첫 번째 행은 헤더
    cols = row.find_all("td")
    if len(cols) < 4:
        continue
    sido = cols[0].get_text(strip=True)
    accident_text = cols[1].get_text(strip=True).replace(',', '')
    death_text = cols[2].get_text(strip=True).replace(',', '')
    injury_text = cols[3].get_text(strip=True).replace(',', '')
    try:
        accidents = int(accident_text)
        deaths = int(death_text)
        injuries = int(injury_text)
    except ValueError:
        continue  # 숫자 변환에 실패하면 건너뜀
    data.append({
        "시도": sido,
        "사고건수": accidents,
        "사망자수": deaths,
        "부상자수": injuries
    })

# 5. DataFrame으로 정리 및 출력
df = pd.DataFrame(data)
print(df)

# 6. CSV 파일로 저장 (옵션)
df.to_csv("sido_accident_stats.csv", index=False, encoding="utf-8-sig")
print("CSV 파일로 저장되었습니다: sido_accident_stats.csv")

# 7. MySQL 데이터베이스에 저장 (옵션)
import pymysql

connection = pymysql.connect(host="127.0.0.1",
                           port=3306,
                           user="root",
                           password="1111",
                           db="SKNProjectTest",
                           charset="utf8",
                           cursorclass=pymysql.cursors.DictCursor)

try:
    # 테이블 생성
    with connection.cursor() as cursor:
        create_table_sql = """
        create table if not exists sido_accident_stats (
            id INT AUTO_INCREMENT PRIMARY KEY,
            sido VARCHAR(50),
            accident_count INT,
            death_count INT,
            injury_count INT
        );
        """
        cursor.execute(create_table_sql)
    connection.commit()

finally:
    connection.close()







