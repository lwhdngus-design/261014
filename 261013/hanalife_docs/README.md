# 하나생명 공시실 상품기초서류 일괄 다운로드 (2026-10-13)

## 1. 목표
하나생명 공시실 > 상품공시실 > **전체상품 목록**에서
- **판매상품** (`allProduct.do?status=on`): 상품요약서 · 사업방법서 · 보험약관
- **판매중지상품** (`allProduct.do?status=off`): 사업방법서 · 보험약관 (상품요약서 열이 있으면 함께)

를 모두 내려받아 아래 위치에 정리합니다.

```
C:\Users\93066\Desktop\AI심화교육_261013\상품기초서류폴더
└─ 2026                                  ← 판매시작 연도
   └─ 2026.04.01                         ← 판매시작일
      └─ (무)하나원큐연금저축보험          ← 상품명
         ├─ [상품요약서] 원본파일명.pdf
         ├─ [사업방법서] 원본파일명.pdf
         └─ [보험약관] 원본파일명.pdf
└─ 2014
   ├─ 2014.02.03\(무)행복디자인연금보험\...
   └─ 2014.04.01\(무)행복디자인연금보험\...   ← 같은 상품이라도 판매기간별로 따로
└─ download_log.csv                      ← 전체 결과 기록(성공/실패/서류없음)
```

## 2. 진행 과정
1. 판매상품·판매중지상품 페이지 화면을 분석함
   - 열 구성: 대상 / 분류 / 상품명 / 판매기간 / (상품요약서) / 사업방법서 / 보험약관
   - 판매중지상품은 상품요약서 열이 없음. 같은 상품명이 판매기간별로 여러 행에 걸쳐 있음(rowspan)
2. 클라우드 작업환경에서 hanalife.co.kr 직접 접속을 시도함 → **네트워크 정책 때문에 차단됨(403)**.
   클라우드에서는 사용자 PC의 `C:\` 드라이브에 저장할 수도 없음
3. 그래서 **사용자 PC에서 실행하는 자동 다운로드 스크립트**(`hanalife_download.py`)를 작성함
   - 실제 브라우저(Playwright/Chromium)로 페이지를 열어 각 「다운로드」 버튼을 순서대로 클릭함
   - 다운로드 방식이 직접 다운로드든, 새 창(PDF 뷰어)이든, "파일 없음" 알림창이든 모두 처리함
   - rowspan을 풀어서 판매기간마다 상품명·대상·분류를 정확히 짝지음
   - 판매시작일 기준으로 `연도\판매일자\상품명\` 폴더를 만들어 저장함
   - 다시 실행하면 이미 받은 파일은 건너뜀(중간에 끊겨도 이어받기 가능)
   - 페이지가 여러 쪽으로 나뉘어 있으면 다음 쪽으로 자동 이동함
4. 화면 구조를 그대로 본뜬 테스트 페이지로 검증함
   (직접 다운로드, 새 창 PDF, 파일 없음 알림, rowspan 판매중지상품, 이어받기 모두 정상)

## 3. 실행 방법 (Windows)
사전 준비: Python 3.9 이상 설치 (설치할 때 "Add python.exe to PATH" 체크)

1. 이 폴더(`261013/hanalife_docs`)를 PC로 내려받습니다
2. **`run_download.bat` 더블클릭** → 패키지 설치, 브라우저 설치, 다운로드가 자동으로 진행됩니다

명령창에서 직접 실행할 때:
```bat
pip install -r requirements.txt
python -m playwright install chromium

python hanalife_download.py --limit 3        :: 먼저 테스트(페이지당 3개 상품)
python hanalife_download.py                  :: 판매 + 판매중지 전체
python hanalife_download.py --status on      :: 판매상품만
python hanalife_download.py --status off     :: 판매중지상품만
python hanalife_download.py --headed         :: 브라우저 창을 보면서 실행
python hanalife_download.py --out "D:\다른폴더"  :: 저장 위치 변경
```
회사 PC에서 `playwright install`이 막혀 있으면, 설치된 크롬을 지정해서 실행합니다:
```bat
python hanalife_download.py --chrome "C:\Program Files\Google\Chrome\Application\chrome.exe"
```

## 4. 결과 확인
- 진행 상황은 화면에 `OK` / `NG`로 표시되고, 끝나면 성공·건너뜀·실패·서류없음 건수를 보여줍니다
- `download_log.csv`(엑셀로 열림)에 상품마다, 서류마다 결과와 저장 경로가 남습니다
- 실패한 건은 스크립트를 한 번 더 실행하면 그 건만 다시 시도합니다

## 5. 파일 목록
| 파일 | 설명 |
|---|---|
| `hanalife_download.py` | 다운로드 스크립트 |
| `run_download.bat` | 더블클릭 실행용(설치와 실행을 한 번에) |
| `requirements.txt` | 필요한 패키지(playwright) |
