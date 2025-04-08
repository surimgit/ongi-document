# API 설계(명세)서

해당 API 명세서는 ‘프로젝트명’의 REST API를 명세하고 있습니다.

- Domain: 

---

## Auth 모듈

프로젝트명 서비스의 인증 및 인가와 관련된 REST API 모듈입니다. 

로그인,  인증번호 요청 및 검증, 비밀번호 찾기 및 변경 등의 API가 포함되어 있습니다. 

Auth 모듈은 인증 없이 요청할 수 있는 모듈입니다.

- url: /api/v1/auth

 

### 로그인

설명

클라이언트는 사용자 아이디와 평문의 비밀번호를 포함하여 요청하고 아이디와 비밀번호가 일치한다면 인증에 사용될 token과 해당 token의 만료 기간을 응답 데이터로 전달받습니다. 만약 아이디 혹은 비밀번호가 하나라도 일치하지 않으면 로그인 불일치에 해당하는 응답을 받습니다. 서버 에러, 데이터베이스 에러, 유효성 검사 실패 에러가 발생할 수 있습니다.

- method: **POST**

- url: /sign-in

Request

Request Body

| name | type | description | required |
| --- | --- | --- | --- |
| userId | String | 사용자의 아이디 | O |
| userPassword | String | 사용자의 비밀번호 | O |

Example

```bash
curl -v -X POST "" \
	-d "userId=qwer1234" \
	-d "userPassword=qwer1234!"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| acessToken | String | Bearer 인증 방식에 사용될 JWT | O |
| expiration | Integer | accessToken의 만료 기간(초단위) | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success.",
	"accessToken": "${ACCESS_TOKEN}",
	"expiration": 32400
}
```

응답: 실패 (데이터 유효성 검사 실패)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

응답: 실패 (로그인 실패)

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "SF",
  "message": "Sign in Fail."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 아이디 중복 확인

설명

클라이언트는 사용할 아이디를 포함하여 요청하고 중복되지 않는 아이디라면 성공 응답을 받습니다. 만약 사용중인 아이디라면 아이디 중복에 해당하는 응답을 받습니다. 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: **POST**

- url: /id-check

Request

Request Body

| name | type | description | required |
| --- | --- | --- | --- |
| userId | String | 중복확인을 수행할 사용자 아이디 | O |

Example

```bash
curl -v -X POST "" \
	-d "userId=qwer1234"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success."
}
```

응답: 실패 (데이터 유효성 검사 실패)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

응답: 실패 (중복된 아이디)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "EU",
  "message": "Exist User."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 회원가입

설명

클라이언트는 사용자 이름, 사용자 아이디, 사용자 비밀번호, 사용자 전화번호, 사용자 성별, 사용자 생년월일을 포함하여 요청하고 회원가입이 성공적으로 이루어지면 성공에 해당하는 응답을 받습니다. 만약 존재하는 아이디일 경우 중복된 아이디에 대한 응답을 받습니다. 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: **POST**

- url: /sign-up

Request

Request Body

| name | type | description | required |
| --- | --- | --- | --- |
| userName | String | 사용자 이름 (한글로만 이루어진 2자 이상 5자 이하 문자열) | O |
| userId | String | 사용자 아이디 (영문과 숫자로만 이루어진 6자 이상 20자 이하 문자열) | O |
| userPassword | String | 사용자 비밀번호 (영문 숫자 조합으로 이루어진 8자 이상 13자 이하 문자열) | O |
| userPhoneNumber | String | 사용자 전화번호 (011/010 - 0000 - 0000) | O |
| gender | String | 사용자 성별 | O |
| userBirth | String | 사용자 생년월일 (yyyy-MM-dd) | O |
| certificationStatus | boolean | 전화번호 인증 여부 (true/false) | O |

Example

```bash
curl -v -X POST "" \
	-d "userName=홍길동" \
	-d "userId=qwer1234" \
	-d "userPassword=qwer1234!" \
	-d "userPhoneNumber=010-1234-1234" \
	-d "gender=남" \
	-d "userBirth=2000-01-01" \
	-d "certificationStatus=true"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success."
}
```

응답: 실패 (데이터 유효성 검사 실패)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

응답: 실패 (중복된 아이디)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "EU",
  "message": "Exist User."
}
```

응답: 실패 (인증되지 않은 전화번호)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "UP",
  "message": "Unverified Phone Number."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 인증번호 요청

클라이언트는 사용자 전화번호를 포함하여 요청하고 인증번호 요청이 성공적으로 이루어지면 성공에 해당하는 응답을 받습니다. 만약 전화번호에 문제가 있다면 잘못된 전화번호 형식에 대한 응답을 받습니다. 서버에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: **POST**

- url: 

Request

Request Body

| name | type | description | required |
| --- | --- | --- | --- |
| phoneNumber | String | 인증번호를 요청할 사용자 전화번호 (011/010 - 0000 - 0000) | O |

Example

```bash
curl -v -X POST "" \
	-d "phoneNumber=010-1234-1234"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success."
}
```

응답: 실패 (데이터 유효성 검사 실패)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

응답: 실패 (잘못된 전화번호 형식)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "IPF",
  "message": "Invalid Phone Number Format."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 인증번호 검증

클라이언트는 사용자 전화번호, 인증번호를 포함하여 요청하고 인증번호 검증이 성공적으로 이루어지면 성공에 해당하는 응답을 받습니다. 만약 인증번호가 일치하지 않으면 잘못된 인증번호에 대한 응답을 받습니다. 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: **POST**

- url: 

Request

Request Body

| name | type | description | required |
| --- | --- | --- | --- |
| phoneNumber | String | 인증번호를 요청할 사용자 전화번호 (011/010 - 0000 - 0000) | O |
| authenticationNumber | Integer | 인증번호 (6자리 숫자) | O |

Example

```bash
curl -v -X POST "" \
	-d "phoneNumber=010-1234-1234" \
	-d "authenticationNumber=123456"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success."
}
```

응답: 실패 (데이터 유효성 검사 실패)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

응답: 실패 (잘못된 인증번호)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "IA",
  "message": "Invalid Authentication Number."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 아이디 찾기

설명

클라이언트는 가입한 사용자 이름과 전화번호, 인증 여부를 포함하여 요청하고 일치하는 사용자 정보가 존재하면 성공 응답을 받습니다. 만약 일치하는 사용자 정보가 없으면 존재하지 않는 사용자에 해당하는 응답을 받습니다. 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: **POST**

- url: 

Request

Request Body

| name | type | description | required |
| --- | --- | --- | --- |
| userName | String | 가입한 사용자 이름 (한글로만 이루어진 2자 이상 5자 이하 문자열) | O |
| phoneNumber | String | 가입한 사용자 전화번호 (011/010 - 0000 - 0000) | O |
| certificationStatus | boolean | 전화번호 인증 여부 (true/false) | O |

Example

```bash
curl -v -X POST "" \
	-d "user_name=홍길동" \
	-d "phoneNumber=010-1234-1234"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success."
}
```

응답: 실패 (데이터 유효성 검사 실패)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

응답: 실패 (존재하지 않는 사용자)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "EU",
  "message": "Exist User."
}
```

응답: 실패 (인증되지 않은 전화번호)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "UP",
  "message": "Unverified Phone Number."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 비밀번호 찾기

설명

클라이언트는 가입한 사용자 아이디와 전화번호, 인증 여부를 포함하여 요청하고 일치하는 사용자 정보가 존재하면 성공 응답을 받습니다. 만약 일치하는 사용자 정보가 없으면 존재하지 않는 사용자에 해당하는 응답을 받습니다. 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: **POST**

- url: 

Request

Request Body

| name | type | description | required |
| --- | --- | --- | --- |
| userId | String | 가입한 사용자 아이디 | O |
| phoneNumber | String | 가입한 사용자 전화번호 (011/010 - 0000 - 0000) | O |
| certificationStatus | boolean | 전화번호 인증 여부 (true/false) | O |

Example

```bash
curl -v -X POST "" \
	-d "user_id=qwer1234" \
	-d "phoneNumber=010-1234-1234"\
	-d "cerificationStatus=true"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success."
}
```

응답: 실패 (데이터 유효성 검사 실패)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

응답: 실패 (존재하지 않는 사용자)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "EU",
  "message": "Exist User."
}
```

응답: 실패 (인증되지 않은 전화번호)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "UP",
  "message": "Unverified Phone Number."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 비밀번호 재설정

설명

클라이언트는 인증 토큰과 새로운 비밀번호를 포함하여 요청하고 비밀번호 재설정이 성공적으로 이루어지면 성공에 해당하는 응답을 받습니다. 만약 토큰에 문제가 있을 경우 유효하지 않은 토큰에 대한 응답을 받습니다. 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: **PUT**

- url: 

Request

Request Body

| name | type | description | required |
| --- | --- | --- | --- |
| resetToken | String | 전화번호 인증 완료 후 받은 토큰 | O |
| newPassword | String | 새로운 비밀번호 | O |

Example

```bash
curl -v -X PUT "" \
	-d "resetToken=abcd1234" \
	-d "newPassword=asdf1234!"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success."
}
```

응답: 실패 (데이터 유효성 검사 실패)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

응답: 실패 (유효하지 않은 토큰)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "IT",
  "message": "Invalid Token."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

---

## User 모듈

프로젝트명 서비스의 사용자 정보와 관련된 REST API 모듈입니다.

로그인 사용자 계정 설정, 계정 설정 수정, 비밀번호 변경, 회원 탈퇴 등의 API가 포함되어 있습니다.

User 모듈은 모두 인증 후 요청할 수 있는 모듈입니다.

- url: /profile

### 계정 설정 보기

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 요청하고 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 네트워크 에러, 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: **Get**

- url: 

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Baerer 토큰 인증 헤더 | O |

Example

```bash
curl -X GET "" \
	-h "Authorization=Bearer XXXX"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| userName | String | 사용자 이름 | O |
| gender | String | 사용자 성별 | O |
| phoneNumber | String | 사용자 전화번호 | O |
| userBirth | String | 사용자 생년월일 | O |
| address | String | 주소 | O |
| detailAddress | String | 상세 주소 | O |
| zipCode | Integer | 우편번호 (5자 숫자) | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success.",
	"userName": "홍길동",
	"gender": "남",
	"phoneNumber": "010-1234-1234",
	"userBirth": "2000-01-01",
	"address": "부산시 부산진구 중앙대로 668",
	"detailAddress": "에이원플라자 4층 코리아IT아카데미",
	"zipCode": 47296
}
```

응답: 실패 (데이터 유효성 검사 실패)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth Fail."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 계정 설정 수정

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 요청하고 계정 설정 수정이 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 네트워크 에러, 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: **PATCH**

- url: 

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Baerer 토큰 인증 헤더 | O |

Request Body

| name | type | description | required |
| --- | --- | --- | --- |
| userName | String | 사용자 이름 | O |
| gender | String | 사용자 성별 | O |
| phoneNumber | String | 사용자 전화번호 | O |
| userBirth | String | 사용자 생년월일 | O |
| address | String | 주소 | O |
| detailAddress | String | 상세 주소 | O |
| zipCode | Integer | 우편번호 (5자 숫자) | O |

Example

```bash
curl -v-X PATCH "" \
	-h "Authorization=Bearer XXXX" \
	"userName=홍길동" \
	"gender=남" \
	"phoneNumber=010-1234-1234" \
	"userBirth=2000-01-01" \
	"address=부산시 부산진구 중앙대로 668" \
	"detailAddress=에이원플라자 4층 코리아IT아카데미" \
	"zipCode=47296"
	
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success."
}
```

응답: 실패 (데이터 유효성 검사 실패)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth Fail."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 비밀번호 변경

설명

클라이언트는 기존 비밀번호와 새로운 비밀번호를 포함하여 요청하고 비밀번호 재설정이 성공적으로 이루어지면 성공에 해당하는 응답을 받습니다. 만약 기존 비밀번호와 새로운 비밀번호가 일치하지 않으면 기존 비밀번호 불일치에 대한 응답을 받습니다. 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: **PUT**

- url: 

Request

Request Body

| name | type | description | required |
| --- | --- | --- | --- |
| oldPassword | String | 기존 비밀번호 | O |
| newPassword | String | 새로운 비밀번호 | O |

Example

```bash
curl -v -X PUT "" \
	-d "oldPassword=old1234" \
	-d "newPassword=new1234!"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success."
}
```

응답: 실패 (데이터 유효성 검사 실패)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

응답: 실패 (기존 비밀번호 불일치)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "MP",
  "message": "Mismatch Previous Password."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 회원 탈퇴

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰과 비밀번호를 포함하여 요청하고 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 네트워크 에러, 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: POST

- url: 

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

Request Body

| name | type | description | required |
| --- | --- | --- | --- |
| userPassword | String | 사용자 비밀번호 | O |

Example

```bash
curl -v -X POST "" \
	-h "Authorization=Bearer XXXX" \
	-d "userPassword=abcd1234"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success."
}
```

응답: 실패 (데이터 유효성 검사 실패)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

응답: 실패 (비밀번호 불일치)

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "WP",
  "message": "Wrong Password."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

---

## Alarm 모듈

프로젝트명 서비스의 알람과 관련된 REST API 모듈입니다.

알림 리스트 조회, 읽음 처리, 알림 삭제 등의 API가 포함되어 있습니다.

Alarm 모듈은 모두 인증 후 요청할 수 있는 모듈입니다.

- url: 

### 알림 리스트 조회

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 요청하고 조회가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method: **Get**

- url: 

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Baerer 토큰 인증 헤더 | O |

Example

```bash
curl -X GET "" \
	-h "Authorization=Bearer XXXX"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| alarms | Alarm[] | 알림 리스트 | O |

Alarm

Example

| name | type | description | required |
| --- | --- | --- | --- |
| type | String | 알림 유형 | O |
| title | String | 알림 제목 | O |
| content | String | 알림 내용 | O |
| isRead | Boolean | 읽음 여부 | O |
| createdAt | String | 알림 생성일시 (ISO 8601) | O |
- 타입 Enum 설계
    
    ```
    // 공동구매 관련
    DEADLINE_SOON,        // 찜 등록한 공구 상품 마감 임박
    SALE_END,             // 찜 등록한 공구 상품 판매 종료
    DELIVERY_STARTED,     // 구매한 공구 상품 배송 시작
    DELIVERY_COMPLETED,   // 구매한 공구 상품 배송 완료
    
    // 도움 요청/도우미 관련
    HELP_REQUEST_RECEIVED,          // 도움 요청자에게 도우미 신청 도착
    HELP_REQUEST_ACCEPTED,          // 도우미 신청자에게 수락됨 알림
    HELP_REVIEW_RECEIVED,           // 도움 활동 후기 알림
    
    // 포인트
    POINT_EARNED,                   // 포인트 적립
    
    // 커뮤니티
    COMMENT_ON_MY_POST,             // 내가 쓴 글에 댓글
    LIKE_ON_MY_POST,                // 내가 쓴 글에 좋아요
    POST_BECAME_POPULAR,            // 인기글 등극
    
    // 문의
    INQUIRY_ANSWERED,               // 문의 답변 등록
    
    // 달력/정책
    CALENDAR_EVENT_REMINDER,        // 등록한 일정 하루 전 알림
    POLICY_DEADLINE_REMINDER,       // 스크랩한 정책 마감 하루 전
    
    // 이벤트
    EVENT_WINNER_NOTIFICATION,      // 이벤트 당첨 알림
    
    // 채팅
    CHAT_MESSAGE_RECEIVED           // 채팅 메시지 수신
    
    ```
    

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success.",
	"alarms": [
		{
			"type": "DELIVERY_STARTED",
			"title": "배송 시작!",
			"content": "주문하신 '공구상품명'의 배송이 시작되었어요.",
			"isRead": false,
			"createdAt": "2025-04-03T12:30:00"
		}
	]
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth Fail."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 알림 읽음 처리

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하고 URL에 알림 번호를 입력하여 요청하고 알림 읽음 처리가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method: **PUT**

- url: //{id}/read

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Baerer 토큰 인증 헤더 | O |

Example

```bash
curl -v-X PUT "" \
	-h "Authorization=Bearer XXXX"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success."
}
```

응답: 실패 (데이터 유효성 검사 실패)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth Fail."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 전체 알림 읽음 처리

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 요청하고 알림 전체 읽음 처리가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method: **PUT**

- url: //read-all

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Baerer 토큰 인증 헤더 | O |

Example

```bash
curl -v -X PUT "" \
	-h "Authorization=Bearer XXXX"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success."
}
```

응답: 실패 (데이터 유효성 검사 실패)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

응답: 실패 (기존 비밀번호 불일치)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "MP",
  "message": "Mismatch Previous Password."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 알림 삭제

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하고 URL에 알림 번호를 입력하여 요청하고 알림 삭제가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method: DELETE

- url: //{id}

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

```bash
curl -v -X POST "" \
	-h "Authorization=Bearer XXXX"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success."
}
```

응답: 실패 (데이터 유효성 검사 실패)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth Fail."
}
```

응답: 실패 (권한 없음)

```bash
HTTP/1.1 403 Forbidden

{
  "code": "NP",
  "message": "No Permission."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

---

## Mypage 모듈

프로젝트명 서비스의 MyPage에 관련된 REST API 모듈입니다.

로그인 사용자 정보 보기, 사용자 정보 수정, 회원 탈퇴 등의 API가 포함되어 있습니다.

User 모듈은 모두 인증 후 요청할 수 있는 모듈입니다.

- url: /my-page/user

### 프로필 보기

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 요청하고 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 네트워크 에러, 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: **Get**

- url: 

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Baerer 토큰 인증 헤더 | O |

Example

```bash
curl -X GET "" \
	-h "Authorization=Bearer XXXX"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| userNickname | String | 사용자 닉네임 | O |
| gender | String | 사용자 성별 | O |
| age | Integer | 사용자 나이 | O |
| userIsSeller | boolean | 공동구매 판매자 여부 | O |
| profileImage | String | 사용자 프로필 이미지 | X |
| mbti | String | 사용자 MBTI | X |
| userLike | String[] | 관심 키워드 | X |
| job | String | 사용자 직업 | X |
| userSelfIntroduction | String | 자기소개 | X |
| badges | String[] | 보유한 뱃지 | X |
| achievements | String[] | 보유한 업적 | X |
| userRatingList | String[] | 사용자가 다른 사용자로부터 받은 후기 | O |
| userRatingScore | Float | 사용자가 다른 사용자로부터 받은 평점 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success.",
	"userNickname": "민수",
	"gender": "남",
	"age": 25,
	"userIsSeller": "X",
	"profileImage": "http://~",
	"mbti": "ENFP",
	"userLike": ["청소", "운동"],
	"job": "백엔드 개발자",
	"selfIntroduction": "안녕하세요. 청소랑 운동을 좋아하는 백엔드 개발자 입니다.",
	"badges": ["해충 박멸가", "활동왕"],
	"achievements": ["게시글 50개", "댓글 300개"],
	"userRatingList": ["시간 약속을 잘 지켜요.", "친절하고 매너가 좋아요."],
	"userRatingScore": 4.9
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth Fail."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 프로필 작성

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 프로필정보를 입력하여 요청하고 프로필 정보 작성이 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 네트워크 에러, 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: POST

- url: 

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Baerer 토큰 인증 헤더 | O |

Request Body

| name | type | description | required |
| --- | --- | --- | --- |
| userNickname | String | 사용자 닉네임 | O |
| gender | String | 사용자 성별 | O |
| age | Integer | 사용자 나이 | O |
| profileImage | String | 사용자 프로필 이미지 | X |
| mbti | String | 사용자 MBTI | X |
| userLike | String[] | 관심 키워드 | X |
| job | String | 사용자 직업 | X |
| userSelfIntroduction | Stng | 자기소개 | X |

Example

```bash
curl -v-X POST "" \
	-h "Authorization: Bearer XXXX" \
	"userNickname": "민수",
	"gender": "남",
	"age": "24",
	"profileImage": "http://~",
	"mbti": "ENFP",
	"userLike": ["청소", "운동"],
	"job": "백엔드 개발자",
	"selfIntroduction": "안녕하세요. 청소랑 운동을 좋아하는 백엔드 개발자 입니다.",
	
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success."
}
```

응답: 실패 (데이터 유효성 검사 실패)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth Fail."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 프로필 수정

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 url에 사용자 아이디를 포함하여 요청하고 프로필 수정이 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 네트워크 에러, 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: **PATCH**

- url: 

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Baerer 토큰 인증 헤더 | O |

Request Body

| name | type | description | required |
| --- | --- | --- | --- |
| userNickname | String | 사용자 닉네임 | O |
| gender | String | 사용자 성별 | O |
| age | Integer | 사용자 나이 | O |
| profileImage | String | 사용자 프로필 이미지 | X |
| mbti | String | 사용자 MBTI | X |
| userLike | String[] | 관심 키워드 | X |
| job | String | 사용자 직업 | X |
| userSelfIntroduction | Stng | 자기소개 | X |

Example

```bash
curl -v-X PATCH "" \
	-h "Authorization": "Bearer XXXX" \
	"userNickname": "민지",
	"gender": "여",
	"age": "22",
	"profileImage": "http://~",
	"mbti": "ENFP",
	"userLike": ["청소", "운동"],
	"job": "프론트엔드 개발자",
	"selfIntroduction": "안녕하세요. 청소랑 운동을 좋아하는 프론트엔드 개발자 입니다.",
	
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success."
}
```

응답: 실패 (데이터 유효성 검사 실패)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth Fail."
}
```

**응답 : 실패 (존재하지 않는 유저)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "NU",
  "message": "No Exist User."
}
```

**응답 : 실패 (권한 없음)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "NP",
  "message": "No Permission."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 내 활동 보기

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 요청하고 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 네트워크 에러, 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: **Get**

- url: /myActivity

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Baerer 토큰 인증 헤더 | O |

Example

```bash
curl -X GET "" \
	-h "Authorization: Bearer XXXX"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| reviewCount | Integer | 쓴 후기 갯수 | O |
| reviewdCount | Integer | 받은 후기 갯수 | O |
|  |  |  |  |
|  |  |  |  |
| Point | Integer | 포인트 |  |
|  |  |  |  |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success.",
	"userNickname": "민수",
	"gender": "남",
	"age": 25,
	"profileImage": "http://~",
	"mbti": "ENFP",
	"userLike": ["청소", "운동"],
	"job": "백엔드 개발자",
	"selfIntroduction": "안녕하세요. 청소랑 운동을 좋아하는 백엔드 개발자 입니다.",
	"badges": ["해충 박멸가", "활동왕"],
	"achievements": ["게시글 50개", "댓글 300개"],
	"userRatingList": ["시간 약속을 잘 지켜요.", "친절하고 매너가 좋아요."],
	"userRatingScore": 4.9
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth Fail."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 내가 받은 도우미 후기 리스트 보기

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 요청하고 성공적으로 이루어지면 내가 받은 도우미 후기 글 리스트와 성공에 대한 응답을 받습니다. 네트워크 에러, 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: **Get**

- url: 

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Baerer 토큰 인증 헤더 | O |

Example

```bash
curl -X GET "" \
	-h "Authorization=Bearer XXXX"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| reviews | Review[] | 리뷰 | O |

Review

| **name** | type | description | required |
| --- | --- | --- | --- |
| reviewSequence | Integer | 후기 번호 | O |
| reviewdPostTitle | String | 리뷰 대상이 되는 글 제목 | O |
| reviewUserNickname | String | 리뷰 작성자의 닉네임 | O |
| reviewUserProfileImage | String | 리뷰 작성자의 프로필 이미지 | O |
| reviewContent | String | 리뷰 내용 | O |
| reviewRating | String | 리뷰 평점 | O |
| reviewDate | String | 리뷰 작성 시간 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success.",
	"Review": [
		{
			"reviewSequence": 5,
			"reviewdPostTitle": "바퀴벌레 좀 잡아주세요!!!ㅠㅠ",
			"reviewUserNickname": "youngsu",
			"reviewUserProfileImage": "http://~",
			"reviewContent": "친절하게 벌레 잘 잡아주셔서 음료수도 드렸어요~╰(*°▽°*)╯",
			"reviewRating": "2.0",
			"reveiwDate": "2025-05-24 16:40"
		},
		{
			"reviewSequence": 21,
			"reviewdPostTitle": "롤 다이아가는 승급전인데 버스 가능하신분? 마스터 이상 급구",
			"reviewUserNickname": "minsu",
			"reviewUserProfileImage": "http://~",
			"reviewContent": "덕분에 다이아 갔습니다.",
			"reviewRating": "5.0",
			"reveiwDate": "2025-07-12 23:34"
		}
	]
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth Fail."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 내가 작성한 도우미 후기 리스트 보기

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 요청하고 성공적으로 이루어지면 내가 작성한 도우미 후기 글 리스트와 성공에 대한 응답을 받습니다. 네트워크 에러, 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: **Get**

- url: 

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Baerer 토큰 인증 헤더 | O |

Example

```bash
curl -X GET "" \
	-h "Authorization=Bearer XXXX"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| reviews | Review[] | 리뷰 | O |

Review

| **name** | type | description | required |  |
| --- | --- | --- | --- | --- |
| reviewSequence | Integer | 후기 번호 | O |  |
| reviewdPostTitle | String | 리뷰 대상이 되는 글 제목 | O |  |
| reviewUserNickname | String | 리뷰 작성자의 닉네임 | O |  |
| reviewUserProfileImage | String | 리뷰 작성자의 프로필 이미지 | O |  |
| reviewContent | String | 리뷰 내용 | O |  |
| reviewRating | String | 리뷰 평점 | O |  |
| reviewDate | String | 리뷰 작성 시간 | O |  |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success.",
	"Review": [
		{
			"reviewSequence": 20,
			"reviewdPostTitle": "챌린저 가는 승급전 도와주실분",
			"reviewUserNickname": "gildong",
			"reviewUserProfileImage": "http://~",
			"reviewContent": "전직 프로게이머시라는데 진짜인듯. 버스 잘 탔습니다.",
			"reviewRating": "5.0",
			"reveiwDate": "2025-05-24 16:40"
		},
		{
			"reviewSequence": 121,
			"reviewdPostTitle": "키보드 고장났는데 이거 도와주실분",
			"reviewUserNickname": "gildong",
			"reviewUserProfileImage": "http://~",
			"reviewContent": "빨리 도와주셔서 금방 고쳤습니다.",
			"reviewRating": "5.0",
			"reveiwDate": "2025-07-12 23:34"
		}
	]
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth Fail."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 내 공동구매 구매 리스트 보기

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 요청하고 성공적으로 이루어지면 내가 작성한 도우미 후기 글 리스트와 성공에 대한 응답을 받습니다. 네트워크 에러, 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: **Get**

- url: 

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Baerer 토큰 인증 헤더 | O |

Example

```bash
curl -X GET "" \
	-h "Authorization"="Bearer XXXX"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| products | Product[] | 공동구매 글 리스트 | O |

Product

| **name** | type | description | required |  |
| --- | --- | --- | --- | --- |
| productSeqeunce | Integer | 상품 번호 |  |  |
| productTitle | String | 상품 이름 | O |  |
| productContent | String | 상품 설명 내용 | O |  |
| productImage | String | 상품 이미지 | O |  |
| productisSoldOut | boolean | 상품 판매 완료 여부 | O |  |
| productAmount | Integer | 상품 총량 | O |  |
| butAmount | Integer | 상품 구매된 수량 | O |  |
| productDeadline | String | 상품 마감 시간 | O |  |
| productPurchasedUser | Integer | 상품을 구매한 인원수 | O |  |
| productReviewdRating | Integer | 상품의 평점 | O |  |
| comments | Integer | 댓글 수 | O |  |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success.",
	"Product": [
		{
			"productSeqeunce": 4,
			"productTitle": "비타민C",
			"productContent": "이번 비타민C는 진짜 다릅니다 여러분! 3회차 공구!!!",
			"productImage": "http://~",
			"productIsSoldOut": false,
			"productAmount": 200,
			"butAmount": 70, 
			"productDeadline": "2025-05-24 22:00",
			"productPurchasedUser": 120,
			"productReviewdRating": "4.8",
			"comments": 6
		},
	]
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth Fail."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 내 공동구매 판매 리스트 보기

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 요청하고 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 네트워크 에러, 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: **Get**

- url: 

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Baerer 토큰 인증 헤더 | O |

Example

```bash
curl -X GET "" \
	-h "Authorization"="Bearer XXXX"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| products | Product[] | 공동구매 글 리스트 | O |

Product

| **name** | type | description | required |  |
| --- | --- | --- | --- | --- |
| productTitle | String | 상품 이름 | O |  |
| productContent | String | 상품 설명 내용 | O |  |
| productImage | String | 상품 이미지 | O |  |
| productisSoldOut | boolean | 상품 판매 완료 여부 | O |  |
| productAmount | Integer | 상품 총량 | O |  |
| butAmount | Integer | 상품 구매된 수량 | O |  |
| productDeadline | String | 상품 마감 시간 | O |  |
| productPurchasedUser | Integer | 상품을 구매한 인원수 | O |  |
| productReviewdRating | Integer | 상품의 평점 | O |  |
| comments | Integer | 댓글 수 | O |  |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	Product: [
		{
			"code": "SU",
			"message": "Success.",
			"productTitle": "비타민C",
			"productContent": "이번 비타민C는 진짜 다릅니다 여러분! 3회차 공구!!!",
			"productImage": "http://~",
			"productIsSoldOut": false,
			"productAmount": 200,
			"butAmount": 70, 
			"productDeadline": "2025-05-24 22:00",
			"productPurchasedUser": 120,
			"productReviewdRating": "4.8",
			"comments": 6
		},
	]
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth Fail."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 내 공동구매 장바구니 리스트 보기

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 요청하고 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 네트워크 에러, 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: **Get**

- url: 

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Baerer 토큰 인증 헤더 | O |

Request Body

| name | type | description | required |
| --- | --- | --- | --- |
| productNum | Integer | 상품 등록 번호 | O |

Example

```bash
curl -X GET "" \
	-h "Authorization"="Bearer XXXX"
	-d "productNum=5"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| products | Product[] | 공동구매 글 리스트 | O |

Product

| **name** | type | description | required |
| --- | --- | --- | --- |
| productSeqeunce | String | 상품 식별 ID | O |
| productTitle | String | 상품 이름 | O |
| productContent | String | 상품 설명 내용 | O |
| productImage | String | 상품 이미지 | O |
| productisSoldOut | boolean | 상품 판매 완료 여부 | O |
| productAmount | Integer | 상품 총량 | O |
| buyAmount | Integer | 상품 구매된 수량 | O |
| productDeadline | String | 상품 마감 시간 | O |
| productPurchasedUser | Integer | 상품을 구매한 인원수 | O |
| productReviewdRating | Integer | 상품의 평점 | O |
| comments | Integer | 댓글 수 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success.",
	"Product": [
		{
			"productSeqeunce": 4,
			"productTitle": "비타민C",
			"productContent": "이번 비타민C는 진짜 다릅니다 여러분! 3회차 공구!!!",
			"productImage": "http://~",
			"productIsSoldOut": false,
			"productAmount": 200,
			"butAmount": 70, 
			"productDeadline": "2025-05-24 22:00",
			"productPurchasedUser": 120,
			"productReviewdRating": "4.8",
			"comments": 6
		},
	]
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth Fail."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 내 공동구매 찜 목록 리스트 보기

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 요청하고 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 네트워크 에러, 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: **Get**

- url: 

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Baerer 토큰 인증 헤더 | O |

Example

```bash
curl -X GET "" \
	-h "Authorization"="Bearer XXXX"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| products | Product[] | 공동구매 글 리스트 | O |

Product

| **name** | type | description | required |  |
| --- | --- | --- | --- | --- |
| productSequnce | Integer | 상품번호 |  |  |
| productTitle | String | 상품 이름 | O |  |
| productContent | String | 상품 설명 내용 | O |  |
| productImage | String | 상품 이미지 | O |  |
| productisSoldOut | boolean | 상품 판매 완료 여부 | O |  |
| productAmount | Integer | 상품 총량 | O |  |
| buyAmount | Integer | 상품 구매된 수량 | O |  |
| productDeadline | String | 상품 마감 시간 | O |  |
| productPurchasedUser | Integer | 상품을 구매한 인원수 | O |  |
| productReviewdRating | Integer | 상품의 평점 | O |  |
| comments | Integer | 댓글 수  | O |  |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success.",
	"Product": [
		{
			"productSequence": 4,
			"productTitle": "비타민C",
			"productContent": "이번 비타민C는 진짜 다릅니다 여러분! 3회차 공구!!!",
			"productImage": "http://~",
			"productIsSoldOut": false,
			"productAmount": 200,
			"butAmount": 70, 
			"productDeadline": "2025-05-24 22:00",
			"productPurchasedUser": 120,
			"productReviewdRating": "4.8",
			"comments": 6
		},
	]
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth Fail."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 내 도우미 구인 글 리스트 보기

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 요청하고 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 네트워크 에러, 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: **Get**

- url: 

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Baerer 토큰 인증 헤더 | O |

Example

```bash
curl -X GET "" \
	-h "Authorization"="Bearer XXXX"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| needHelperPostList | NeedHelperPost | 내 도우미 구인 요청 글 리스트 | O |

NeedHelperPost

| **name** | type | description | required |
| --- | --- | --- | --- |
| needHelperPostSequence | Integer | 게시물 번호 | O |
| needHelperPostTitle | String | 도우미 구인글 제목 | O |
| needHelperPostContent | String | 도우미 구인글 내용 | O |
| needHelperRemainTime | String | 남은 시간 | O |
| currentApplyUserCount | Integer | 현재 신청 인원 | O |
| comments | Integer | 댓글 수 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success.",
	"NeedHelperPost": 
	[
		{
			"needHelperPostSequence": 2,
			"needHelperPostTitle": "마스터 강등 직전인데 이거 도와주실분, 챌 이상",
			"needHelperPostContent": "겨우 챌린저 갔었는데 떨어지기 직전이에요, 도와주실분",
			"needHelperRemainTime": "3:45:20",
			"currentApplyUserCount": 1,
			"comments": 2
		},
		{
			"needHelperPostSequence": 2,
			"needHelperPostTitle": "어깨 운동 팁 가르쳐 주실분",
			"needHelperPostContent": "어제 어깨하다가 뿌드득 소리났는데 자세 좀 알려주실분",
			"needHelperRemainTime": "1일 5:45:20",
			"currentApplyUserCount": 0,
			"comments": 4
		}	
	]
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth Fail."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 내가 신청한 도우미 글 리스트 보기

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 요청하고 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 네트워크 에러, 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: **Get**

- url: 

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Baerer 토큰 인증 헤더 | O |

Example

```bash
curl -X GET "" \
	-h "Authorization"="Bearer XXXX"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| needHelperPostList | NeedHelperPost | 내가 신청한 도우미 구인 글 리스트 | O |

NeedHelperPost

| **name** | type | description | required |
| --- | --- | --- | --- |
| needHelperPostSequence | Integer | 게시물 번호 | O |
| needHelperPostTitle | String | 도우미 구인글 제목 | O |
| needHelperPostContent | String | 도우미 구인글 내용 | O |
| needHelperRemainTime | String | 남은 시간 | O |
| currentApplyUserCount | Integer | 현재 신청 인원 | O |
| comments | Integer | 댓글 수 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success.",
	"NeedHelperPost": 
	[
		{
			"needHelperPostSequence": 2,
			"needHelperPostTitle": "실버 승급전 도와주실분ㅠㅠ",
			"needHelperPostContent": "저 학교에서 맨날 놀림받아요 형님들 제발 저 실버가게 해주세요ㅠㅠ",
			"needHelperRemainTime": "00:45:20",
			"currentApplyUserCount": 8,
			"comments": 5
		},
		{
			"needHelperPostSequence": 3,
			"needHelperPostTitle": "옷 골라 주실분 계신가용...?",
			"needHelperPostContent": "남자친구랑 데이트 가는데 옷 골라주실 언니 있나요ㅠㅠ",
			"needHelperRemainTime": "2일 10:45:20",
			"currentApplyUserCount": 20,
			"comments": 8
		}	
	]
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth Fail."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 내가 좋아요 한 도우미 글 리스트 보기

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 요청하고 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 네트워크 에러, 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: **Get**

- url: 

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Baerer 토큰 인증 헤더 | O |

Example

```bash
curl -X GET "" \
	-h "Authorization"="Bearer XXXX"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| needHelperPostList | NeedHelperPost | 내가 신청한 도우미 구인 글 리스트 | O |

NeedHelperPost

| **name** | type | description | required |
| --- | --- | --- | --- |
| needHelperPostSequence | Integer | 게시물 번호 | O |
| needHelperPostTitle | String | 도우미 구인글 제목 | O |
| needHelperPostContent | String | 도우미 구인글 내용 | O |
| needHelperRemainTime | String | 남은 시간 | O |
| currentApplyUserCount | Integer | 현재 신청 인원 | O |
| comments | Integer | 댓글 수 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success.",
	"NeedHelperPost": 
	[
		{
			"needHelperPostSequence": 2,
			"needHelperPostTitle": "실버 승급전 도와주실분ㅠㅠ",
			"needHelperPostContent": "저 학교에서 맨날 놀림받아요 형님들 제발 저 실버가게 해주세요ㅠㅠ",
			"needHelperRemainTime": "00:45:20",
			"currentApplyUserCount": 8,
			"comments": 5
		},
		{
			"needHelperPostSequence": 3,
			"needHelperPostTitle": "옷 골라 주실분 계신가용...?",
			"needHelperPostContent": "남자친구랑 데이트 가는데 옷 골라주실 언니 있나요ㅠㅠ",
			"needHelperRemainTime": "2일 10:45:20",
			"currentApplyUserCount": 20,
			"comments": 8
		}	
	]
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth Fail."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 내가 쓴 커뮤니티 글 리스트  보기

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 요청하고 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 네트워크 에러, 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: **Get**

- url: 

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Baerer 토큰 인증 헤더 | O |

Example

```bash
curl -X GET "" \
	-h "Authorization"="Bearer XXXX"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| userWriteList | String[] | 작성한 커뮤니티 게시글 리스트 | O |

userWriteList

| name | type | description | required |
| --- | --- | --- | --- |
| postNum | String | 작성글 번호 | O |
| postTitle | String | 제목 | O |
| postDate | Integer | 작성 일자 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success.",
  "userWriteList": [
    {
      "postNum": "20",
      "postTitle": "오늘의 정보",
      "postDate": "2025-04-07"
    }, ...
  ]
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth Fail."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 내가 쓴 커뮤니티 댓글 리스트 보기

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 요청하고 성공적으로 이루어지면 유저가 작성한 커뮤니티의 댓글 목록을 받습니다. 네트워크 에러, 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: **Get**

- url: 

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Baerer 토큰 인증 헤더 | O |

Example

```bash
curl -X GET "" \
	-h "Authorization"="Bearer XXXX"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| userReplyList | String[] | 사용자가 작성한 커뮤니티 댓글 리스트 | O |

userReplyList

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| commentNum | Integer | 댓글 번호 | O |
| commentContent | String | 댓글 내용 | O |
| commentDate | String | 작성일자 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success.",
  "userReplyList": [
    {
      "commentNum": "24",
      "commentContent": "안녕하세요!",
      "commentDate": "2025-04-07"
    }, ...
  ]
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth Fail."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 내가 좋아요 한 커뮤니티 글 리스트 보기

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 요청하고 성공적으로 이루어지면 유저가 좋아요 한 커뮤니티 글 목록을 받습니다. 네트워크 에러, 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: **Get**

- url: 

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Baerer 토큰 인증 헤더 | O |

Example

```bash
curl -X GET "" \
	-h "Authorization"="Bearer XXXX"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| userLikedList | String[] | 사용자가 좋아요 한 커뮤니티 글 리스트 | O |

userLikedList

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| postNum | Integer | 게시글 번호 | O |
| postTitle | String | 제목 | O |
| postDate | String | 작성일자 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success.",
  "userLikedList": [
    {
      "postNum": "24",
      "postTitle": "오늘의 정보",
      "postDate": "2025-04-07"
    }, ...
  ]
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth Fail."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

---

## Inquiry 모듈

프로젝트명 서비스의 문의 접수에 관련된 REST API 모듈입니다.

문의 작성, 문의 목록 조회, 문의 상세 조회, 답변 작성 등의 API가 포함되어 있습니다.

Inquiry 모듈은 모두 인증 후 요청할 수 있는 모듈입니다.

- url:

### 문의 내역 조회

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 문의 목록을 요청하고, 성공적으로 이루어지면 문의 목록을 반환합니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

 - method: **GET**

 - url:

Request

Header

| **name** | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

Example

```bash
curl -X GET "url" \
	-H "Authorization: Bearer XXXX"
```

Reponse

Response Body

| **name** | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| inquiries | Inquiry[] | 문의 목록 | O |

Inquiry

Example

| **name** | type | description | required |
| --- | --- | --- | --- |
| questionNum | Integer | 문의글 번호 | O |
| writerId | String | 작성자 아이디 | O |
| questionTitle | String | 제목 | O |
| quistionDate | String | 작성일자  | O |
| answerState | String | 상태(접수/답변완료) | O |

응답 성공

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success.",
  "inquiries": [
    {
      "questionNum": 1,
      "writerId": "user123",
      "questionTitle": "배송 문의",
      "questionDate": "2025-04-04",
      "answerState": "접수"
    }
  ]
}
```

응답: **실패(인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

응답: **실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 문의 작성

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 문의를 등록할 수 있습니다. 요청 본문에 제목, 카테고리, 내용을 포함해야 합니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

 - method: **POST**

 - url:

Request

Header

| **name** | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

Request Body

| **name** | description | required |
| --- | --- | --- |
| questionTitle | String | O |
| questionCategory | String | O |
| questionContent | String | O |

Example

```bash
curl -X POST "url" \
	-H "Authorization: Bearer XXXX"
	-d "questionTitle=배송 문의" \
	-d "questionCategory=배송" \
	-d "questionContent=<div>언제 도착하나요?</div>"\
```

Reponse

Response Body

| **name** | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| questiondNum | String | 문의글 번호 | O |

**응답 성공**

```bash
HTTP/1.1 201 Created

{
  "code": "SU",
  "message": "Success.",
  "questionNum": 1
}
```

응답: **실패(데이터 유효성 검사 실패)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

응답: **실패(인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

응답: **실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 문의 답변 등록

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 특정 문의에 대한 답변을 등록할 수 있습니다. 요청 본문에는 답변 내용이 포함되어야 합니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

 - method: **POST**

 - url:

Request

Header

| **name** | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

Request Body

| **name** | type | description | required |
| --- | --- | --- | --- |
| answer | String | 답변 내용 | O |

Example

```bash
curl -X GET "url" \
	-H "Authorizatio: Bearer XXXX"
	-d "answer=<div>안녕하세요 고객님, 상품은 평균 3일에서 7일 이내에 도착합니다.</div>"
```

Reponse

Response Body

| **name** | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

**응답 성공**

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
    }
  ]
}
```

응답: **실패(데이터 유효성 검사 실패)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

응답: **실패(이미 답변이 등록된 문의글)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "AL",
  "message": "Already Left Answer."
}
```

응답: **실패(인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

응답: 실패 (권한 없음)

```bash
HTTP/1.1 403 Forbidden

{
  "code": "NP",
  "message": "No Permission."
}
```

응답: **실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

---

## Report 모듈

() 서비스의 신고 접수와 관련된 REST API 모듈입니다. 

신고 리스트 조회, 신고 내용 상세 조회, 유저 관리 등의 API가 포함되어 있습니다.

Report 모듈은 모두 인증 후 요청할 수 있는 모듈이며, 관리자만 접근 가능합니다.

- url: 

### 신고 작성

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 요청하고 신고하기가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 데이터베이스 에러, 유효성 검증 에러가 발생할 수 있습니다.

- method: POST
- url:

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

Request Body

| name | type | description | required |
| --- | --- | --- | --- |
| reporter_id | String | 신고자 아이디 | O |
| reported_id | String | 신고 대상자 아이디 | O |
| reportCategory | String | 신고 카테고리 | O |
| reportDetailContent | String | 신고 내용 | O |

Example

```bash
curl -X POST "url" \
	-H "Authorization=Bearer XXXX" \
	-d "reporter_id=user123" \
	-d "reported_id=user987" \
	-d "reportCategory=불법 정보를 포함하고 있습니다." \
	-d "reportDetailContent=불법 정보를 포함하고 있습니다."
```

Response

Response Body

| **name** | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

Example

응답: 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success."
}
```

응답: 실패 (데이터 유효성 검증 실패)

```bash
HTTP/1.1 400 Bad Request

{
	"code": "VF",
	"message": "Validation Fail."
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 400 Bad Request

{
	"code": "AF",
	"message": "Auth Fail."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
	"code": "DBE",
	"message": "Database Error."
}
```

### 신고 리스트 조회

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 신고 목록을 요청하고, 성공적으로 이루어지면 신고 목록을 반환합니다. 이때 처리내용이 null이 아닐 시 신고 처리 리스트에서 조회하도록 합니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

 - method: **GET**

 - url:

Request

Header

| **name** | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

Example

```bash
curl -X GET "url" \
	-H "Authorization: Bearer XXXX"
```

Reponse

Response Body

| **name** | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| reports | Report[] | 신고 목록 | O |

Report

Example

| **name** | type | description | required |
| --- | --- | --- | --- |
| reportNum | Integer | 신고 게시글 번호 | O |
| reporterId | String | 신고자 아이디 | O |
| reportCategory | String | 신고 카테고리 | O |
| reportDetailContent | String | 신고 내용 | O |
| reportProcess | String | 처리 내용 | O |

응답 성공

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success.",
  "inquiries": [
    {
      "reportNum": 1,
      "reporterId": "user123"
      "reportCategory": "사기",
      "reportDetailContent": "도와준다고 했는데 안 왔습니다",
      "reportProcess": null     
    }
  ]
}
```

응답: **실패(인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

응답: **실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 신고 내용 상세 조회

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 신고 상세 내역을 요청하고, 성공적으로 이루어지면 신고 상새 내역을 반환합니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

 - method: **GET**

 - url:

Request

Header

| **name** | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

Example

```bash
curl -X GET "url" \
	-H "Authorization: Bearer XXXX"
```

Reponse

Response Body

| **name** | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| reportNum | Integer | 신고 번호 | O |
| reporterId | String | 신고자 아이디 | O |
| reportedId | String | 피신고자 아이디 | O |
| reportedPostNum | Integer | 신고 게시글 번호 | O |
| reportedCommentNum | Integer | 신고 댓글 번호 | O |
| reportedReviewNum | Integer | 신고 후기 번호 | O |
| reportedContent | String | 신고 내용(게시글/댓글/후기/채팅) | O |
| reportedCategory | String | 신고 카테고리 | O |
| reportDetailContent | String | 상세 내용 | O |
| warningCount | Integer | 대상 경고 누적 횟수 | O |

응답 성공

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success.",
  "inquiries": [
    {
      "reportNum": 1,
      "reporterId": "user123",
      "reportedId": "qwer789",
      "reportedPostNum": 10,
      "reportedCommentNum": null,
      "reportedReviewNum" null,
      "reportedContent": "신고하는 내용 받아옴",
      "reportedCategory": "욕설/비방",
      "reportDetailContent": "상대방이 욕설을 했습니다",
      "warningCount": 2
    }
  ]
}
```

응답: **실패(인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

응답: **실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 신고 처리

설명

관리자는 신고된 대상에 대해 처리할 수 있으며, 신고 대상이 사용자일 경우 경고 또는 강제 탈퇴 처리를 할 수 있습니다. 신고 대상이 게시글/댓글/후기일 경우 해당 항목을 삭제할 수 있습니다. 이미 탈퇴한 사용자에게는 경고 및 강제 탈퇴 처리를 수행하지 않으며, 전화번호만 강제 탈퇴자 명단에 저장합니다.

 - method: **POST**

 - url: /reports/{reportNum}/handle

Request

Header

| **name** | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

Request Body

| **name** | type | description | required |
| --- | --- | --- | --- |
| action | String | 처리 작업(”DELETE”, “WARN”, “BAN”) | O |

Example

```bash
curl -X POST "url" \
	-H "Authorization: Bearer XXXX" \
	-d "action": "WARN"
```

Reponse

Response Body

| **name** | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

Example

응답 성공: **경고 처리**

```bash
HTTP/1.1 200 OK
{
  "code": "SU",
  "message": "Warning has been sent to the reported user."
}
```

응답 성공: **삭제 처리**

```bash
HTTP/1.1 200 OK
{
  "code": "SU",
  "message": "Reported content has been deleted."
}
```

응답 성공: **강제 탈퇴 처리**

```bash
HTTP/1.1 200 OK
{
  "code": "SU",
  "message": "User has been forcibly withdrawn and phone number saved."
}
```

응답: **이미 탈퇴한 사용자** 

```bash
HTTP/1.1 200 OK
{
  "code": "SU",
  "message": "User already withdrawn."
}
```

응답: **실패(인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

응답: **실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

---

## Payment 모듈

프로젝트명 서비스의 결제와 관련된 Toss Payment API 모듈입니다.

결제 승인, 결제 조회, 결제 취소, 거래내역 조회 API가 포함되어 있습니다.

Payment 모듈은 모두 인증 후 요청할 수 있는 모듈입니다.

### 결제하기

### 결제하기 흐름

### **1️⃣ 사용자가 결제 요청 (`POST /v1/payments`)**

- 클라이언트가 `orderId`, `amount`, `orderName` 등의 정보를 서버에 요청
- 서버는 Toss 결제 API를 호출하여 결제창을 띄움

### **2️⃣ Toss 결제창에서 결제 진행**

- 사용자가 카드, 계좌이체 등으로 결제 진행

### **3️⃣ 결제 완료 후 `successUrl`로 리디렉션**

- Toss 결제창에서 결제 성공 시, 브라우저를 `successUrl`로 리디렉션
    
    **(이때, `paymentKey`, `orderId`, `amount`을 전달함)**
    
- ex) `https://myshop.com/payment/success?paymentKey=k3g8-abc123&orderId=ORDER_1001&amount=50000`

---

### **📌 결제 승인 API 호출 (이 단계에서 해야 함!)**

✔ `successUrl`에서 서버로 `paymentKey`, `orderId`, `amount`을 전송

✔ 서버가 `POST /v1/payments/confirm` API를 호출하여 결제 승인

✔ 결제 승인 성공 시, 결제가 완료되고 최종 확정됨

---

### **4️⃣ 서버가 결제 승인 성공 후, 클라이언트에 결과 반환**

- 결제 승인 성공 시 → "결제가 완료되었습니다." 메시지 표시
- 결제 승인 실패 시 → "결제 승인에 실패하였습니다." 메시지 표시

### 사용자 결제 요청

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 요청을 보내 요청에 성공하면 성공에 대한 응답을 받습니다. 인증 에러, 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: POST
- url:

Request

Header

| name | type | description | required |
| --- | --- | --- | --- |
| Authorization | String | Bearer 토큰 인증 헤더 | O |
| Content-Type | String | 요청 본문 타입 | O |

Request Body

| name | type | description | required |
| --- | --- | --- | --- |
| customerKey | String | 구매자 식별 고유 아이디 (영문 대소문자, 숫자, 특수문자 -, _, =, ., @ 중 최소 1개를 포함하는 최소 2자 이상 최대 50자 이하의 문자열) | O |
| orderId | String | 주문번호(영문 대소문자, 숫자, 특수문자 ‘-’, ‘_’로 이루어진 6자 이상 64자 이하의 문자열) | O |
| amount | Integer | 결제 금액 | O |
| orderName | String | 주문 상품명(최대 길이 100자의 문자열) | O |
| metadata | Object | 직접 요청한 결제 관련 정보(최대 5개의 키-값, ‘[’ , ‘]’을 제외한 40자 이상 500자 이하의 문자열) | X |
| successUrl | String | 결제 성공 시 리디렉션될 URL | O |
| failUrl | String | 결제 실패 시 리디렉션될 URL | O |

```bash
curl -v -X POST "사이트 url/v1/payments\
	-H "Authorization: Bearer 인증_토큰"\
	-H "Content-Type: application/json"\
  -d '{
	  "customerKey=user_d82f87ac-e127-4cfb-a6c2-2d2b1aa246ff"
	  "orderId=KzpD-L2YtR_dUO9MQn1g"
    "amount=100000"
    "orderName=토스 티셔츠"
    "successUrl=http://사이트url/payment/success"
		"failUrl=http://사이트url/payment/fail"
	}'
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

**응답 성공**

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (중복된 결제)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "EP",
  "message": "Exist Payment."
}
```

**응답 : 실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 결제 승인

설명

Toss 결제창에서 사용자가 결제를 완료하고 succesUrl로 리디렉션된 후 Toss에서 발급한 결제 키, 주문 번호, 결제 금액을 포함하여 서버에서 요청을 보냅니다. 요청에 성공하면 성공에 관련된 응답을 받습니다. 인증 에러, 유효성 검증 에러, 서버 에러가 발생할 수 있습니다.

- method: POST
- url: /confirm

Reuest

Header

| name | type | description | required |
| --- | --- | --- | --- |
| Authorization | String | Basic 인증 헤더 | O |
| Content-Type | String | 반환받을 데이터 형태 | X |
| Idempotency-Key | String | 결제 취소 중복 요청을 막기위한 멱등키(최대 300자의 문자열, 유효기간: 15일) | O |

Request Body

| name | type | description | required |
| --- | --- | --- | --- |
| paymentKey | String | Toss에서 발급한 결제의 키값(영문과 숫자로 이뤄진 200자 이하의 문자열) | O |
| orderId | String | 주문번호(영문, 숫자, 특수문자(’-’, ’_’)로 이뤄진 6자 이상 64자 이하의 문자열) | O |
| amount | Integer | 결제할 금액 | O |

Example

```bash
curl --request POST \
  --url https://api.tosspayments.com/v1/payments/confirm \
  --header 'Authorization: Basic dGVzdF9za18yNHhMZWE1elZBRXlCWDJwNFplMlZRQU1ZTndXOg==' \
  --header 'Content-Type: application/json' \
  --header 'Idempotency-Key: SAAABPQbcqjEXiDL' \
  --data '{"amount":"100","orderId":"KzpD-L2YtR_dUO9MQn1g","paymentKey":"Sfd8vbcXsdGDS9b0v7cxzcV"}'
```

Response

Response Body

성공

| name | type | description | required |
| --- | --- | --- | --- |
| paymentKey | String | Toss에서 발급한 결제의 키값(영문과 숫자로 이뤄진 200자 이하의 문자열) | O |
| orderId | String | 주문번호(영문, 숫자, 특수문자(’-’, ’_’)로 이뤄진 6자 이상 64자 이하의 문자열) | O |
| orderName | String | 주문 상품명 (최대 100자 이하의 문자열) |  |
| amount | Integer | 결제할 금액 | O |
| status | String | 결제 상태(READY: 결제 생성 초기 상태, IN_PROGRESS: 결제수단 소유가 인증 완료 상태, DONE: 결제 승인 상태, CANCLE: 결제 취소 상태, PARTIAL_CANCELED: 결제 부분 취소 상태, ABORTED: 결제 승인 실패, EXPIRED: 결제 유효기간 만료) | O |
| method | String | 결제수단(카드, 간편결제) | O |
| approvedAt | String | 결제 승인 시간(ISO 8601 형식) | O |

실패

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

Example

```bash
HTTP/1.1 200 OK
{
  "paymentKey": "k3g8-abc123",
  "orderId": "KzpD-L2YtR_dUO9MQn1g",
  "amount": 50000,
  "status": "DONE",
  "method": "카드",
  "approvedAt": "2025-04-04T12:34:56+09:00"
}
```

### 응답 실패 Response

응답: 실패(이미 처리된 결제)

```bash
HTTP/1.1 400 Bad Request
{
  "code": "ALREADY_PROCESSED_PAYMENT",
  "message": "이미 처리된 결제 입니다."
}
```

응답: 실패 (일시적인 오류 발생)

```bash
HTTP/1.1 400 Bad Request
{
  "code": "INVALID_PAYMENT_KEY",
  "message": "일시적인 오류가 발생했습니다. 잠시 후 다시 시도해주세요.."
}
```

응답: 실패 (잘못된 요청)

```bash
HTTP/1.1 400 Bad Request
{
  "code": "INVALID_REQUEST",
  "message": "잘못된 요청입니다."
}
```

응답: 실패 (잘못된 시크릿키)

```bash
HTTP/1.1 400 Bad Request
{
  "code": "INVALID_API_KEY",
  "message": "잘못된 시크릿키 연동 정보 입니다.."
}
```

응답: 실패 (정지된 카드)

```bash
HTTP/1.1 400 Bad Request
{
  "code": "INVALID_STOPPED_CARD",
  "message": "정지된 카드 입니다."
}
```

응답: 실패(하루 결제 가능 횟수 초과)

```bash
HTTP/1.1 400 Bad Request
{
  "code": "EXCEED_MAX_DAILY_PAYMENT_COUNT",
  "message": "하루 결제 가능 횟수를 초과했습니다."
}
```

응답: 실패(하루 결제 가능 금액 초과)

```bash
HTTP/1.1 400 Bad Request
{
  "code": "EXCEED_MAX_PAYMENT_AMOUNT",
  "message": "하루 결제 가능 금액을 초과했습니다."
}
```

응답: 실패 (유효하지 않은 인증 방식)

```bash
HTTP/1.1 400 Bad Request
{
  "code": "INVALID_AUTHORIZE_AUTH",
  "message": "유효하지 않은 인증 방식입니다."
}
```

응답: 실패 (카드번호 인증 에러)

```bash
HTTP/1.1 400 Bad Request
{
  "code": "INVALID_CARD_NUMBER",
  "message": "카드번호를 다시 확인해주세요."
}
```

응답: 실패 (결제 불가능 시간대)

```bash
HTTP/1.1 400 Bad Request
{
  "code": "NOT_AVAILABLE_PAYMENT",
  "message": "	결제가 불가능한 시간대입니다."
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 401 Unauthorized
{
  "code": "UNAUTHORIZED_KEY",
  "message": "인증되지 않은 시크릿 키 혹은 클라이언트 키 입니다."
}
```

응답: 실패 (잔액 부족)

```bash
HTTP/1.1 403 Forbidden
{
  "code": "REJECT_ACCOUNT_PAYMENT",
  "message": "잔액부족으로 결제에 실패했습니다."
}
```

응답: 실패 (결제 승인 거절)

```bash
HTTP/1.1 403 Forbidden
{
  "code": "REJECT_CARD_COMPANY",
  "message": "결제 승인이 거절되었습니다."
}
```

응답: 실패 (허용되지 않은 요청)

```bash
HTTP/1.1 403 Forbidden
{
  "code": "FORBIDDEN_REQUEST",
  "message": "허용되지 않은 요청입니다."
}
```

응답: 실패 (결제 비밀번호 불일치)

```bash
HTTP/1.1 403 Forbidden
{
  "code": "INVALID_PASSWORD",
  "message": "결제 비밀번호가 일치하지 않습니다."
}
```

응답: 실패 (존재하지 않는 결제 정보)

```bash
HTTP/1.1 404 Not Found
{
  "code": "NOT_FOUND_PAYMENT",
  "message": "	존재하지 않는 결제 정보 입니다."
}
```

응답: 실패 (내부 시스템 에러)

```bash
HTTP/1.1 500 Internal Server Error
{
  "code": "FAILED_INTERNAL_SYSTEM_PROCESSING",
  "message": "내부 시스템 처리 작업이 실패했습니다. 잠시 후 다시 시도해주세요."
}
```

### 결제 내역 조회

설명

클라이언트는 요청 헤더에 Basic 인증 토큰을 포함하고 paymentKey를 경로변수에 포함하여 요청을 보내 요청에 성공하면 성공에 대한 응답을 받습니다. 인증 에러, 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: GET
- url: /{paymentKey}

Request

Header

| name | type | description | required |
| --- | --- | --- | --- |
| Authorization | String | Basic 인증 토큰 | O |

Path Variable

| name | type | description | required |
| --- | --- | --- | --- |
| paymentKey | String | 결제의 키값(중복되지 않는 고유한 값, 최대 200자의 문자열) | O |

Example

```bash
curl --request GET \
  --url https://api.tosspayments.com/v1/payments/{paymentKey} \
  --header 'Authorization: Basic dGVzdF9za196WExrS0V5cE5BcldtbzUwblgzbG1lYXhZRzVSOg=='
```

Response

Response Body

성공

| name | type | description | required |
| --- | --- | --- | --- |
| paymentKey | String | 결제의 키값(중복되지 않는 고유한 값, 최대 200자의 문자열) | O |
| orderId | String | 주문번호(영문, 숫자, 특수문자(’-’, ’_’)로 이뤄진 6자 이상 64자 이하의 문자열) | O |
| orderName | String | 주문 상품명(최대 길이 100자의 문자열) | O |
| status | String | 결제 상태(READY: 결제 생성 초기 상태, IN_PROGRESS: 결제수단 소유가 인증 완료 상태, DONE: 결제 승인 상태, CANCLE: 결제 취소 상태, PARTIAL_CANCELED: 결제 부분 취소 상태, ABORTED: 결제 승인 실패, EXPIRED: 결제 유효기간 만료) | O |
| method | String | 결제수단(카드, 간편결제) | O |
| totalAmount | Integer | 총 결제 금액 | O |
| approvedAt | String | 결제 승인 시간(ISO 8601 형식) | O |
| metadata | Object | 결제 요청 시 직접 추가한 결제 관련 정보 | X |

실패

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
  "paymentKey": "pay_20250406_abcdef123456",
  "orderId": "KzpD-L2YtR_dUO9MQn1g",
  "orderName": "프리미엄 멤버십 1개월",
  "status": "DONE",
  "method": "카드",
  "totalAmount": 15000,
  "approvedAt": "2025-04-06T13:45:12+09:00",
  "metadata": {
    "userId": "123",
    "productId": "premium-monthly",
    "couponCode": "SPRING25"
  }
}
```

응답: 실패 (인증되지 않은 시크릿 키 or 클라이언트 키)

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "UNAUTHORIZED_KEY",
  "message": "인증되지 않은 시크릿 키 혹은 클라이언트 키 입니다."
}
```

응답: 실패 (반복적인 요청)

```bash
HTTP/1.1 403 Forbidden

{
  "code": "FORBIDDEN_CONSECUTIVE_REQUEST",
  "message": "반복적인 요청은 허용되지 않습니다. 잠시 후 다시 시도해주세요."
}
```

응답: 실패(존재하지 않는 결제 정보)

```bash
HTTP/1.1 404 Not Found

{
  "code": "NOT_FOUND_PAYMENT",
  "message": "존재하지 않는 결제 정보 입니다."
}
```

응답: 실패 (완료되지 않은 결제)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "FAILED_PAYMENT_INTERNAL_SYSTEM_PROCESSING",
  "message": "결제가 완료되지 않았어요. 다시 시도해주세요.."
}
```

### 결제 취소

설명

클라이언트는 결제 취소 이유, 취소할 금액, 취소 통화, 취소할 금액 . 중면세 금액을 포함하여 요청하고 결제 취소가 성공적으로 이뤄지면 성공에 해당하는 응답을 받습니다. 인증 에러, 서버 에러, 유효성 검증 에러가 발생할 수 있습니다.

- method: POST
- url: /{paymentKey}/cancel

Request

Header

| name | type | description | required |
| --- | --- | --- | --- |
| Authorization | String | Basic 인증 토큰(Base64 인코딩) | O |
| Content-Type | String | 반환 데이터 타입 | X |
| Idempotency-Key | String | 결제 취소 중복 요청을 막기위한 멱등키(최대 300자의 문자열, 유효기간: 15일) | X |

Path Variable

| name | type | description | required |
| --- | --- | --- | --- |
| paymentKey | String | 결제의 키값(중복되지 않는 고유한 값, 최대 200자의 문자열) | O |

Request Body 

실제 계좌

| name | type | description | required |
| --- | --- | --- | --- |
| cancelReason | String | 결제 취소 이유(200자 이하의 문자열) | O |
| cancelAmount | Integer | 취소할 금액 | X |
| currency | String | 취소 통화(KRW, USD, JPY) | X |
| taxFreeAmount | Integer | 취소할 금액 중 면세 금액(default: 0) | X |

Example

```bash
curl --request POST \
  --url https://api.tosspayments.com/v1/payments/vzxcvsd3wer/cancel \
  --header 'Authorization: Basic dGVzdF9za18yNHhMZWE1elZBRXlCWDJwNFplMlZRQU1ZTndXOg==' \
  --header 'Content-Type: application/json' \
  --header 'Idempotency-Key: SAAABPQbcqjEXiDL' \
  --data '{"cancelReason":"단순 변심","cancelAmount":"1000","currency":"KRW","taxFreeAmount":"1000"}'
```

Reponse

Response Body

성공

| name | type | description | required |
| --- | --- | --- | --- |
| paymentKey | String | 결제의 키값(중복되지 않는 고유한 값, 최대 200자의 문자열) | O |
| orderId | String | 주문번호(유저 아이디가 포함된 영문 대소문자, 숫자, 특수문자 ‘-’, ‘_’로 이루어진 6자 이상 64자 이하의 문자열) | O |
| orderName | String | 주문 상품명(최대 길이 100자의 문자열) | O |
| status | String | 전체 결제 상태 확인 (READY: 결제 생성 초기 상태, IN_PROGRESS: 결제수단 소유가 인증 완료 상태, DONE: 결제 승인 상태, CANCLE: 결제 취소 상태, PARTIAL_CANCELED: 결제 부분 취소 상태, ABORTED: 결제 승인 실패, EXPIRED: 결제 유효기간 만료) | O |
| approvedAt | String | 최초 결제 시간( `yyyy-MM-dd'T'HH:mm:ss±hh:mm`) | O |
| cancels[].cancelAmount | Intger | 취소된 금액 | O |
| cancels[].cancelReason | String | 취소 사유 | O |
| cancels[].canceledAt | String | 실제 취소된 시간( `yyyy-MM-dd'T'HH:mm:ss±hh:mm`) | O |
| cancels[].cancelStatus | String | 취소 상태 (DONE: 취소 성공) | O |
| currency | String | 결제 시 사용한 통화 |  |
| totalAmount | Integer | 총 결제 금액 | O |

실패

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

Example

응답: 성공

```bash
HTTP/1.1 200 OK

{
  
  "paymentKey": "5EnNZRJGvaBX7zk2yd8ydw26XvwXkLrx9POLqKQjmAw4b0e1",
  "orderId": "a4CWyWY5m89PNh7xJwhk1",
  "orderName": "토스 티셔츠 외 2건",
  "status": "CANCELED",
  "approvedAt": "2024-02-13T12:18:14+09:00",
  "cancels": [
    {
      "transactionKey": "090A796806E726BBB929F4A2CA7DB9A7",
      "cancelReason": "테스트 결제 취소",
      "canceledAt": "2024-02-13T12:20:23+09:00",
      "cancelAmount": 1000,
      "refundableAmount": 0,
      "cancelStatus": "DONE",
    }
  ],
  "currency": "KRW",
  "totalAmount": 1000
}

```

응답: 실패 (이미 취소된 결제)

```bash
{
  "code": "ALREADY_CANCELED_PAYMENT",
  "message": "이미 환불된 결제입니다."
}
```

응답: 실패 (존재하지 않는 결제)

```bash
{
  "code": "NOT_FOUND_PAYMENT",
  "message": "존재하지 않는 결제입니다."
}
```

응답: 실패 (유효하지 않은 API 키)

```bash
{
  "code": "INVALID_API_KEY",
  "message": "유효하지 않은 API 키입니다."
}
```

응답: 실패 (취소할 수 없는 결제)

```bash
{
  "code": "NOT_CANCELABLE_PAYMENT",
  "message": "취소할 수 없는 결제입니다."
}
```

응답: 실패 (Toss 서버 에러)

```bash
{
  "code": "INTERNAL_SERVER_ERROR",
  "message": "내부 오류가 발생했습니다."
}
```

### 거래 내역 조회

설명

클라이언트는 조회 시작 날짜, 조회 마지막 날짜등을 포함하여 요청을 보내고, 요청에 성공하면 조회 시작 날짜부터 마지막 날짜 사이의 거래 내역을 받습니다.  유효성 검증 에러, 인증 에러가 발생할 수 있습니다.

* 주의

거래 조회는 최대 60초가 소요되기 때문에, 타임아웃 값을 최소 60초로 설정해야합니다.

- method: GET
- url: https://api.tosspayments.com/v1/trasactions

Request

Query Parameter

| name | type | description | required |
| --- | --- | --- | --- |
| startDate | String | 조회를 시작하고 싶은 날짜/시간 ( yyyy-MM-dd'T'hh:mm:ss ) | O |
| endDate | String | 조회를 마치고 싶은 날짜/시간 ( yyyy-MM-dd'T'hh:mm:ss ) | O |
| startingAfter | String | transactionKey 값 ( 특정 결제 건 이후의 기록을 조회할 때 사용) | X |
| limit | Integer | 한 번에 응답받을 기록의 개수 | X |

Example

```bash
curl --request GET \
  --url 'https://api.tosspayments.com/v1/transactions?startDate=2022-01-01T00:00:00&endDate=2022-01-02T23:59:59&startingAfter=S345DSscvFcx&limit=100' \
  --header 'Authorization: Basic dGVzdF9za196WExrS0V5cE5BcldtbzUwblgzbG1lYXhZRzVSOg=='
 
```

Response

Response Body

성공

| name | type | description | required |
| --- | --- | --- | --- |
| transactionKey | String | 거래의 키 값 ( 한 결제 건의 승인 거래와 취소 거래를 구분하는데 사용, 최대 64자의 문자열 ) | O |
| paymentKey | String | 결재의 키 값 ( 최대 200자의 문자열 ) | O |
| orderId | String | 주문번호 ( 영문, 숫자, 특수문자, ‘-’, ‘_’로 이뤄진 6자 이상 64자 이하의 문자열 ) | X |
| method | Integer | 결제 수단 | X |
| customerKey | String | 구매자 ID ( 영문, 숫자, 특수문자 (`-`, `_`, `=`, `.`, `@`)를 최소 1개이상 포함한 최소 2자 이상 300자 이하의 UUID 형태의ㅏ문자열) | O |
| status | String | 결제 상태(READY: 결제 생성 초기 상태, IN_PROGRESS: 결제수단 소유가 인증 완료 상태, DONE: 결제 승인 상태, CANCLE: 결제 취소 상태, PARTIAL_CANCELED: 결제 부분 취소 상태, ABORTED: 결제 승인 실패, EXPIRED: 결제 유효기간 만료) | O |
| transactionAt | String | 거래가 처리된 시점의 날짜와 시간 정보( yyyy-MM-dd'T'HH:mm:ss±hh:mm 형태 ) | X |
| currency | String | 결제 시 사용한 통화 | X |
| amount | Integer | 결제한 금액 | X |

실패

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

Example

응답: 성공

```bash
[
  {
    "transactionKey": "AC45CD421C4E49D7B878522128B8D9C6",
    "paymentKey": "lOR1ZwdkQD5GePWvyJnrKXP6nDMRb8gLzN97EoqYA60XKx4a",
    "orderId": "fMgvolnZP6_ZdEYAaWF_1",
    "method": "카드",
    "customerKey": "cG_EdskNV1JgX7Y16S6vo",
    "status": "DONE",
    "transactionAt": "2023-01-02T15:37:45+09:00",
    "currency": "KRW",
    "amount": 1500
  },
]
```

응답: 실패( 잘못된 날짜 입력 )

```bash
HTTP/1.1 400 Bad Request
{
  "code": "INVALID_DATE",
  "message": "날짜 데이터가 잘못 되었습니다."
}
```

응답: 실패 ( 잘못된 페이징 키 )

```bash
HTTP/1.1 400 Bad Request
{
  "code": "INVALID_TRANSACTION_KEY",
  "message": "잘못된 페이징 키 입니다."
}
```

응답: 실패( 잘못된 시크릿 키 혹은 클라이언트 키 ) 

```bash
HTTP/1.1 401 Unauthorized
{
  "code": "UNAUTHORIZED_KEY",
  "message": "인증되지 않은 시크릿 키 혹은 클라이언트 키 입니다."
}
```

 

---

## GroupBuying 모듈

공동 구매 게시판과 관련된 REST API 모듈입니다.

상품 리스트 보기, 상품 상세 보기, 상품 게시물 등록, 공동구매 참여, 공동구매 참여 취소 등의 API가 포함되어 있습니다.

GroupBuying 모듈은 모두 인증 후 요청할 수 있는 모델입니다. 

- url: /v1/product

### 상품 리스트 보기

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 공동 구매 상품 목록을 요청하고, 성공적으로 이루어지면 상품 목록을 반환합니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

 - method: **GET**

 - url: /

Request

Header

| **name** | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

Example

```bash
curl -X GET "url" \
	-H "Authorization: Bearer XXXX"
```

Reponse

Response Body

| **name** | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| products | Product[] | 상품 목록 | O |

Product

| **name** | type | description | required |
| --- | --- | --- | --- |
| productNumber | Integer | 상품 번호 | O |
| productName | String | 상품 이름 | O |
| productPrice | Integer | 상품 가격 | O |
| productRating | Float | 상품 평점 | O |
| productPurchased | Integer | 참여 인원 수 | O |
| productDeadline | String | 마감 기한 | O |
| productRound | Integer | 회차 | O |
| productAmount | Integer | 상품 갯수 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success.",
  "products": [
    {
      "productNum": 1,
      "productName": "비타민C",
      "productPrice": "30,000",
      "productRating": 4.2,
      "productPurchased": 30,
      "productDeadline": "2025-05-05 23:00",
      "productRound": 2,
      "productAmount": 100     
    }
  ]
}
```

응답: **실패(인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

응답: **실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 상품 상세 보기

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하고 URL에 상품번호를 포함하여 요청하고 조회가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 만약 존재하지 않는 상품일 경우 존재하지 않는 상품에 해당하는 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

 - method: **GET**

 - url: /{productNumber}

Request

Header

| **name** | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

Path Variable

| name | type | description | required |
| --- | --- | --- | --- |
| productNumber | Integer | 상품 등록 번호 | O |

Example

```bash
curl -X GET "url/3" \
	-H "Authorization: Bearer XXXX"
```

Reponse

Response Body

| **name** | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| sellerId | String | 판매자 아이디 | O |
| productNumber | Integer | 상품 번호 | O |
| productName | String | 상품 이름 | O |
| productPrice | Integer | 상품 가격 | O |
| productRating | Float | 상품 평점 | O |
| productPurchased | Integer | 참여 인원 수 | O |
| productDeadline | String | 마감 기한 | O |
| productRound | Integer | 회차 | O |
| productAmount | Integer | 상품 갯수 | O |
| productContent | String | 상품 설명 | O |
| reviews | Review[] | 리뷰 목록 | O |

Review

| **name** | type | description | required |
| --- | --- | --- | --- |
| reviewerId | String | 후기 작성자 아이디 | O |
| reviewedId | String | 후기 대상자 아이디 | O |
| reviewType | String | 후기 유형 | O |
| reviewDate | String | 작성 시간 | O |
| reviewRating | Float | 평점 | O |
| reviewContent | String | 내용 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success.",
  "sellerId": "minsu",
  "productNumber": 1,
  "productName": "비타민C",
  "productRating": 4.2,
  "productPrice": "30,000",
  "productPurchased": 30,
  "productDeadline": "2025-05-05 23:00",
  "productRound": 3,
  "productAmount": 100,
  "productContent": "이건 비타민C입니다.",
  reviews: [
	  { 
	  "reviewerId": "gildong",
	  "reviewType": "product",
	  "reviewDate": "2025-03-31 23:00",
	  "reviewRating": 4.6,
	  "reviewContent": "비타민C" 
	  }
  ]
}
```

응답: 실패 (존재하지 않는 상품)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Product Not Found."
}
```

응답: **실패(인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

응답: **실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 상품 게시물 등록

**설명**

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하고 상품명, 가격, 카테고리, 상품 내용, 갯수, 마감 기한, 사진 입력하여 요청하고 게시물 작성이 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method : **POST**
- URL : **/**

**Request**

**Header**

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

**Request Body**

| name | type | description | required |
| --- | --- | --- | --- |
| productName | String | 상품 이름 | O |
| productPrice | Integer | 상품 가격 | O |
| category | String | 카테고리 | O |
| productContent | String | 상품 내용 | O |
| productAmount | Integer | 상품 수량 | O |
| productDeadline | String | 마감 기한 | O |
| productImage  | String | 상품 이미지 | O |
| dueDate | String | 공구 오픈 예정일 | X |

**Example**

```bash
curl -X POST "url" \
 -h "Authorization=Bearer XXXX" \
 -d "productName=비타민C" \
 -d "productPrice=30,000" \
 -d "category=건강"\
 -d "productContent=이건 비타민 C구요 몸에 아주 좋습니다."\
 -d "productAmount=100" \
 -d "productDeadline=2025-05-05" \
 -d "productImage =https://~~"\
```

**Respons**

**Response Body**

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

**Example**

**응답 성공**

```
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (인증 실패)**

```
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

**응답 : 실패 (데이터베이스 에러)**

```
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 상품 게시물 수정

**설명**

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하고 URL에 상품 게시물 번호를, 본문에 상품명, 가격, 카테고리, 상품 내용, 갯수, 마감 기한, 사진을 입력하여 요청하고 상품 게시물 수정이 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method : **PATCH**
- URL : **/{**productNumber**}**
- 

**Request**

**Header**

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

Path Variable

| name | type | description | required |
| --- | --- | --- | --- |
| productNumber | Integer | 상품 등록 번호 | O |

**Request Body**

| name | type | description | required |
| --- | --- | --- | --- |
| productName | String | 상품 이름 | O |
| productPrice | Integer | 상품 가격 | O |
| category | String | 카테고리 | O |
| productContent | String | 상품 내용 | O |
| productAmount | Integer | 상품 수량 | O |
| productDeadline | String | 마감 기한 | O |
| productImage  | String | 상품 이미지 | O |
| dueDate | String | 공구 오픈 예정일 | X |

**Example**

```bash
curl -X Patch "url/3" \
 -h "Authorization=Bearer XXXX" \
 -d "productName=비타민C" \
 -d "productPrice=20,000" \
 -d "category=건강"\
 -d "productContent=이건 비타민 C구요 몸에 아주 좋습니다. 여러분들이 많이 사주셔서 가격 내릴게요^^"\
 -d "productAmount=150" \
 -d "productDeadline=2025-05-10" \
 -d "productImage =https://~~"\
```

**Respons**

**Response Body**

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

**Example**

**응답 성공**

```
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (인증 실패)**

```
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

**응답 : 실패 (존재하지 않는 상품 등록 게시물)**

```
HTTP/1.1 401 Unauthorized

{
  "code": "NP",
  "message": "No Exist Product."
}
```

**응답 : 실패 (권한 없음)**

```
HTTP/1.1 401 Unauthorized

{
  "code": "NP",
  "message": "No Permission."
}
```

**응답 : 실패 (데이터베이스 에러)**

```
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 상품 게시물 삭제

**설명**

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하고 URL에 상품 게시물 번호를 입력하여 요청하고 상품 게시물 삭제가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method : DELETE
- URL : **/{productNumber}**

**Request**

**Header**

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

Path Variable

| name | type | description | required |
| --- | --- | --- | --- |
| productNumber | Integer | 상품 등록 번호 | O |

**Example**

```bash
curl -X DELETE "url/3" \
 -h "Authorization=Bearer XXXX" \
```

**Response**

**Response Body**

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

**Example**

**응답 성공**

```
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (인증 실패)**

```
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

**응답 : 실패 (존재하지 않는 상품 등록 게시물)**

```
HTTP/1.1 401 Unauthorized

{
  "code": "NP",
  "message": "No Exist Product."
}
```

**응답 : 실패 (권한 없음)**

```
HTTP/1.1 401 Unauthorized

{
  "code": "NP",
  "message": "No Permission."
}
```

**응답 : 실패 (데이터베이스 에러)**

```
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 상품 찜하기

**설명**

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하고 URL에 상품 게시물 번호를 포함하여 요청하고 상품 찜하기 가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method : **POST**
- URL : **/**

**Request**

**Header**

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

Request Body

| name | type | description | required |
| --- | --- | --- | --- |
| productNumber | Integer | 상품 등록 번호 | O |

**Example**

```bash
curl -X POST "url" \
 -h "Authorization=Bearer XXXX" \
 -d "productNumber=3"
```

**Response**

**Response Body**

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

**Example**

**응답 성공**

```
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (존재하지 않는 상품 등록 게시물)**

```
HTTP/1.1 401 Unauthorized

{
  "code": "NP",
  "message": "No Exist Product."
}
```

**응답 : 실패 (권한 없음)**

```
HTTP/1.1 401 Unauthorized

{
  "code": "NP",
  "message": "No Permission."
}
```

**응답 : 실패 (인증 실패)**

```
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

**응답 : 실패 (데이터베이스 에러)**

```
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 상품 장바구니 추가

**설명**

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하고 URL에 상품 게시물 번호를 포함하여 요청하고 상품을 장바구니에 추가가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method : **POST**
- URL : **/cart**

**Request**

**Header**

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

**Request Body**

| name | type | description | required |
| --- | --- | --- | --- |
| productNumber | Integer | 상품 등록 번호 | O |
| purchaseAmount | Integer | 갯수 | O |

**Example**

```bash
curl -X POST "url" \
 -h "Authorization=Bearer XXXX" \
 -d "productNumber=3" \
 -d "productAmount=5" \
```

**Response**

**Response Body**

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

**Example**

**응답 성공**

```
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (권한 없음)**

```
HTTP/1.1 401 Unauthorized

{
  "code": "NP",
  "message": "No Permission."
}
```

**응답 : 실패 (존재하지 않는 상품 등록 게시물)**

```
HTTP/1.1 401 Unauthorized

{
  "code": "NP",
  "message": "No Exist Product."
}
```

**응답 : 실패 (인증 실패)**

```
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

**응답 : 실패 (데이터베이스 에러)**

### 공동구매 참여

**설명**

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하고 상품명, 갯수를 입력하여 요청하고 공동 구매 참여가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method : **POST**
- URL : **/**

**Request**

**Header**

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

**Request Body**

| name | type | description | required |
| --- | --- | --- | --- |
| purchaseProductName | String | 상품 이름 | O |
| purchaseProductAmount | Integer | 갯수 | O |

**Example**

```bash
curl -X POST "url" \
 -h "Authorization=Bearer XXXX" \
 -d "productName=비타민C" \
 -d "productAmount=2" \
```

**Response**

**Response Body**

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

**Example**

**응답 성공**

```
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (인증 실패)**

```
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

**응답 : 실패 (데이터베이스 에러)**

### 공동구매 참여 취소

**설명**

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하고 상품명, 갯수를 입력하여 요청하고 공동구매 참여 취소가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method : **DELETE**
- URL : **/**

**Request**

**Header**

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

**Request Body**

| name | type | description | required |
| --- | --- | --- | --- |
| purchaseProductName | String | 상품 이름 | O |
| purchaseProductAmount | Integer | 갯수 | O |

**Example**

```bash
curl -X POST "url" \
 -h "Authorization=Bearer XXXX" \
 -d "productName=비타민C" \
 -d "productAmount=2" \
```

**Response**

**Response Body**

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

**Example**

**응답 성공**

```
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (존재하지 않는 일기)**

```
HTTP/1.1 400 Bad Request

{
  "code": "ND",
  "message": "No Exist Diary."
}
```

**응답 : 실패 (인증 실패)**

```
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

**응답 : 실패 (권한 없음)**

```
HTTP/1.1 403 Forbidden

{
  "code": "NP",
  "message": "No Permission."
}
```

**응답 : 실패 (데이터베이스 에러)**

```
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

---

## HelperService 모듈

() 서비스의 도우미 게시판과 관련된 REST API 모듈입니다.

도움 요청 리스트 불러오기, 도움 요청 작성, 도우미 신청, 도우미 신청 내역 조회 등의 API가 포함되어 있습니다.

HelperService 모듈은 모두 인증 후 요청할 수 있는 모델입니다. 

- url: /v1/product

### 도움 요청 작성

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 도움 요청글을 등록할 수 있습니다.

요청 본문에는 필수 항목(도움명, 날짜/시간, 위치, 업무, 급여, 업무 설명)이 모두 포함되어야 하며, 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

 - method: **POST**

 - url:

Request

Header

| **name** | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

Request Body

| **name** | type | description | required |
| --- | --- | --- | --- |
| requestTitle | String | 요청글 제목 | O |
| requestDate | String | 도움이 필요한 일자 | O |
| requestLocation | String | 도움이 필요한 위치 | X |
| requestCategory | Array | 도움이 필요한 내용 | O |
| requestReward | Integer | 보수 | O |
| requestCondition | Array | 우대사항 | X |
| requestContent | String | 도움 요청 상세글 | O |

Example

```bash
curl -X POST "url" \
  -H "Authorization: Bearer XXXX" \
  -H "Content-Type: application/json" \
  -d '{
    "requestTitle": "이삿짐 정리 도와주세요",
    "requestDate": "2025-04-10 15:00:00",
    "requestLocation": "서울특별시 강남구 역삼동",
    "requestCategory": ["이사", "정리"],
    "requestReward": 30000,
    "requestCondition": ["이사 잘해요", "정리 잘해요"],
    "requestContent": "혼자 하기엔 너무 힘들어서 도와주실 분 구합니다. 간단한 분리수거와 박스 정리 부탁드려요."
  }'

```

Reponse

Response Body

| **name** | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| requestNum | Integer | 요청글 번호 | O |

**응답 성공**

```bash
HTTP/1.1 201 Created

{
  "code": "SU",
  "message": "Success.",
  "requestNum": 1
}
```

응답: **실패(데이터 유효성 검사 실패)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

응답: **실패(인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

응답: **실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 도움 필요 상세 페이지 보기

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 도움 필요 상세 페이지를 요청하고, 성공적으로 이루어지면 상세 페이지를 반환합니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

 - method: **GET**

 - url:

Request

Header

| **name** | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

Example

```bash
curl -X GET "url" \
	-H "Authorization: Bearer XXXX"
```

Reponse

Response Body

| **name** | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| requestNum | Integer | 요청글 번호 | O |
| requesterId | String | 요청자 아이디 | O |
| requestTitle | String | 요청글 제목 | O |
| requestDate | String | 도움이 필요한 일자 | O |
| requestLocation | String | 도움이 필요한 위치 | X |
| requestCategory | Array | 도움이 필요한 내용 | O |
| requestReward | String | 보수 | O |
| requestConditon | Array | 우대사항 | X |
| requestContent | String | 도움 요청 상세글 | O |

응답 성공

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success.",
  "inquiries": [     
    {
      "requestNum": 1,
      "requestId",
      "requestTitle": "벌레 잡아주세요",
      "requestDate": "3일 2시간",
      "requestLocation": "부산광역시 부산진구 부전동",
      "requestCategory": ["대면", "벌레 퇴치"],
      "requestReward": 10000,
      "requestCondition": ["여자", "용감해요"],
      "requestContent": "상세 설명" 
    }
  ]
}
```

응답: **실패(인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

응답: **실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 도우미 신청

설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 특정 도움 요청글에 신청할 수 있습니다.

신청 시 게시자에게 알림이 전송되고, 신청자와 게시자 간의 채팅방이 생성됩니다(수락 시).

 - method: **POST**

 - url:

Request

Header

| **name** | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

Path Parameter

| **name** | type | description | required |
| --- | --- | --- | --- |
| requestNum | Integer | 요청글 번호 | O |

Example

```bash
curl -X POST "url" \
  -H "Authorization: Bearer XXXX" 
```

Reponse

Response Body

| **name** | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| chatRoomSequence | Integer | 채팅방 번호(수락 시 생성) | X |

**응답 성공**

```bash
HTTP/1.1 201 Created

{
  "code": "SU",
  "message": "Success.",
  "chatRoomSequence": null
}
```

응답: **실패(인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

응답: **실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 도우미 신청 취소

도우미는 신청한 도움 요청에 대해 신청을 취소할 수 있습니다.

 - method: **DELETE**

 - url:

Request

Header

| **name** | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

Path Parameter

| **name** | description | required |
| --- | --- | --- |
| requestNum | 요청글 번호 | O |

Example

```bash
curl -X GET "url" \
	-H "Authorization: Bearer XXXX"
```

Reponse

Response Body

| **name** | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

응답 성공

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}

```

응답: **실패(인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

응답: **실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

---

## Chat 모듈

채팅과 관련된 REST API 모듈입니다.

채팅방 개설, 채팅 보내기, 채팅방 들어가기, 채팅 보내기 권한 삭제, 채팅방 나가기 등의 API가 포함되어 있습니다.

Chat 모듈은 모두 인증 후 요청할 수 있는 모델입니다. 

- url: /v1/chat

### 채팅방 개설

**설명**

클라이언트는 요청 헤더에 Bearer 인증 토큰과 도우미 신청을 받은 사용자들중 수락한 사용자의 닉네임과 사용자 자신의 닉네임, 해당 도우미 게시물 번호를 포함하여 요청하고 채팅방 개설이 성공적으로 이루어지면 채팅방 번호를 반환 받습니다. 서버 에러, 인증 실패, 존재하지 않는 사용자, 데이터베이스 에러가 발생할 수 있습니다.

- method : POST
- URL :

**Request**

**Header**

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

**Request Body**

| name | type | description | required |
| --- | --- | --- | --- |
| receiveUserNickname | String | 채팅방 개설 대상 닉네임 | O |
| sendUserNickname | String | 채팅방 개설 닉네임 | O |
| requestPostSeqeunce | Integer | 해당 도우미 요청 게시물 번호 | O |

**Example**

```bash
curl -v -X POST "" \
 -h "Authorization=Bearer XXXX" \
 -d "receiveUserNickname=minsu" \
 -d "sendUserNickname=gildong" \
 -d "requestPostSeqeunce=1" \
```

**Response**

**Response Body**

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| charRoomSeuquence | Integer | 채팅방 번호 | O |

**응답 성공**

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success.",
  "charRoomSeuquence": 1
}
```

**응답 : 실패 (인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

**응답 : 실패 (존재하지 않는 사용자)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "NU",
  "message": "No Exist User."
}
```

**응답 : 실패 (존재하지 않는 도우미 게시물)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "NN",
  "message": "No Exist NeedhelperPost."
}
```

**응답 : 실패 (권한 없음)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "NP",
  "message": "No Permission."
}
```

**응답 : 실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 메시지 전송

**설명**

클라이언트는 요청 헤더에 Bearer 인증 토큰, URL에 채팅방 번호, 메세지 내용을 포함하여 요청하고 메시지 전송 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method : **POST**
- URL : **/**

**Request**

**Header**

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

**Request Body**

| name | type | description | required |
| --- | --- | --- | --- |
| messageContent | String | 제목 | O |
| fileUrl | String | 파일URL | X |

**Example**

```bash
curl -X POST "url" \
 -h "Authorization=Bearer XXXX" \
 -d "messageContent=바퀴벌레가 나와서요ㅠㅠ 진짜 잡아 주실수 있나요...?" \
```

**Respons**

**Response Body**

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

**Example**

**응답 성공**

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

**응답 : 실패(존재하지 않는 채팅방)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "NC",
  "message": "No Exist ChatRoom."
}
```

**응답 : 실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 채팅방 조회

**설명**

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하고 URL에 채팅방 번호를 포함하여 요청하고 조회가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 만약 존재하지 않는 채팅방일경우 존재하지 않는 채팅방에 해당하는 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method : **GET**
- URL : **/{chatRoomSequence}**

**Request**

**Header**

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

**Example**

```bash
curl -v -X GET "" \
 -h "Authorization=Bearer XXXX"
```

**Response**

**Response Body**

| name | type | description | required |
| --- | --- | --- | --- |
| code | St ring | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| charRoomSeuqence | Integer | 채팅방 번호 |  |

**Example**

**응답 성공**

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success.",
  "charRoomSeuqence": 1
 }
```

**응답 : 실패 (존재하지 않는 채팅방)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "NC",
  "message": "No Exist CharRoom."
}
```

**응답 : 실패 (인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

**응답 실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database error."
}
```

### 채팅 보내기 권한 삭제(도우미 업무 완료)

**설명**

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하고 URL에 채팅방 번호를, 채팅 송수신 여부를 포함하여 요청하고 채팅 보내기 권한 삭제가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method : PATCH
- URL : **/{chatRoomNumber}**

**Request**

**Header**

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

**Request Body**

| name | type | description | required |
| --- | --- | --- | --- |
| chatAvailable | boolean | 채팅 송수신 여부 | O |

**Response**

**Example**

```bash
curl -v -X PATCH "{**chatRoomNumber**}" \
 -h "Authorization=Bearer XXXX" \
 -d "chatAvailable="false" \
```

**Example**

**응답 성공**

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
  ]
}
```

**응답 : 실패 (존재하지 않는 채팅방)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "NC",
  "message": "No Exist chatRoom."
}
```

**응답 : 실패 (인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

**응답 실패 (권한 없음)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "NP",
  "message": "No Permission."
}
```

**응답 실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database error."
}
```

### 채팅방 삭제

**설명**

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하고 URL에 채팅방 번호를 포함하여요청하고 커뮤니티 게시물 삭제가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method : DELETE
- URL : **/{chatRoomSequence}**

**Request**

**Header**

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

**Example**

```bash
curl -X DELETE "url" \
 -h "Authorization=Bearer XXXX" \
```

**Respons**

**Response Body**

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

**Example**

**응답 성공**

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

**응답 : 실패 (존재하지 않는 채팅방)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "NC",
  "message": "No Exist chatRoom."
}
```

**응답 : 실패 (권한 없음)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "NP",
  "message": "No Permission."
}
```

**응답 : 실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

---

## Community 모듈

커뮤니티 게시판과 관련된 REST API 모듈입니다.

게시판 목록 조회, 게시글 작성, 게시글 보기, 게시글 수정, 게시글 삭제 등, 게시글 좋아요, 게시글 검색, 댓글 작성, 댓글 수정, 댓글 삭제 등의 API가 포함되어 있습니다.

Community 모듈은 모두 인증 후 요청할 수 있는 모델입니다. 

- url: 

### 게시판 목록 조회

**설명**

클라이언트는 요청 헤더에 Bearer 인증 토큰과 URL에 게시판 카테고리를 포함하여 요청하고 조회가 성공적으로 이루어지면 게시판 목록에 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method : **GET**
- URL : **/{**communityCategory**}**

**Request**

**Header**

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

**Example**

```bash
curl -v -X GET "{communityCategory}" \
 -h "Authorization=Bearer XXXX"
```

**Response**

**Response Body**

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| communityPosts | CommunityPost[] | 게시판 리스트 | O |

CommunityPost

**Example**

| name | type | description | required |
| --- | --- | --- | --- |
| postSequence | Integer | 작성글 번호 | O |
| posterId | String | 작성자 아이디 | O |
| postDate | String | 작성 일자 | O |
| postCategory | String | 카테고리 | O |
| postTitle | String | 제목 | O |
| postLiked | Integer | 좋아요 수 | O |
| postViewCount | Integer | 조회수 | O |
| commentCount | Integer | 댓글 수 | O |

**응답 성공**

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success.",
  "communityPosts": [
    {
      "postSequence": 3,
      "posterId": "gildongpostId",
      "postDate": "2025-03-20 18:50",
      "postCategory": "health"
      "postTitle": "님들 운동하세요"
      "postLiked": 50,
      "postViewCount": 200
      "commentCount": 10
    }, ...
  ]
}
```

**응답 : 실패 (인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

**응답 : 실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 게시글 작성

**설명**

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하고 상품명, 가격, 카테고리, 상품 내용, 갯수, 마감 기한, 사진 입력하여 요청하고 게시물 작성이 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method : **POST**
- URL : **/**

**Request**

**Header**

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

**Request Body**

| name | type | description | required |
| --- | --- | --- | --- |
| postTitle | String | 제목 | O |
| postContenet | String | 내용 | O |

**Example**

```bash
curl -X POST "url" \
 -h "Authorization=Bearer XXXX" \
 -d "postTitle=하루에 3km씩만 뛰어봅시다" \
 -d "postContenet=잠도 잘오고 좋아요~..." \
```

**Respons**

**Response Body**

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

**Example**

**응답 성공**

```
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (인증 실패)**

```
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

**응답 : 실패 (데이터베이스 에러)**

```
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 게시글 보기

**설명**

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하고 URL에 커뮤니티 게시물번호를 포함하여 요청하고 조회가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 만약 존재하지 않는 커뮤니티 게시물일 경우 존재하지 않는 게시물에 해당하는 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method : **GET**
- URL : **/{communtiyPostNumber}**

**Request**

**Header**

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

**Example**

```bash
curl -v -X GET "/{communityPostNumber}" \
 -h "Authorization=Bearer XXXX"
```

**Response**

**Response Body**

| name | type | description | required |
| --- | --- | --- | --- |
| code | St ring | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| communityPosts | CommunityPost[] | 게시판 리스트 | O |

CommunityPost

**Example**

| name | type         | description | required |
| --- | --- | --- | --- |
| postSequence | Integer | 작성글 번호 | O |
| posterId | String | 작성자 아이디 | O |
| postDate | String | 작성 일자 | O |
| postCategory | String | 카테고리 | O |
| postTitle | String | 제목 | O |
| postContent | String | 내용 | O |
| postLiked | Integer | 좋아요    | O |
| postViewCount | Integer | 조회수 | O |
| comments | Comment[] | 댓글 | O |

Comment

**Example**

| name | type | description | required |
| --- | --- | --- | --- |
| commentSequence | Integer | 댓글 번호 | O |
| commentPostSeqeunce | String | 작성된 게시글 번호 | O |
| commenterId | String | 작성자 아이디 | O |
| commentContent | String | 내용 | O |
| commentDate | String | 작성 시간 | O |

**Example**

**응답 성공**

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success.",
  "communityPosts": [
    {
      "postSequence": 3,
      "posterId": "gildongpostId",
      "postDate": "2025-03-20 18:50",
      "postCategory": "health"
      "postTitle": "님들 운동하셈",
      "postContent": "건강해지고 좋음",
      "postLiked": 50,
      "postViewCount": 200
      "comments":[
	      {
		      "commentSequence": 1,
		      "commentPostSeqeunce": "3",
		      "commenterId": "minsuCommentId",
		      "commentContent": "그럼 운동 하나만 추천해주세요!"
		      "commentDate": "2025-03-20 18:50"
		    }
      ]
    }, ...
  ]
}
```

**응답 : 실패 (존재하지 않는 게시물)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "NP",
  "message": "No Exist Post."
}
```

**응답 : 실패 (인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

**응답 실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database error."
}
```

### 게시글 수정

**설명**

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하고 URL에 커뮤니티 게시물 번호를, 본문에 제목, 내용을 입력하여 요청하고 게시물 수정이 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method : PATCH
- URL : **/{communtiyPostNumber}**

**Request**

**Header**

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

**Request Body**

| name | type | description | required |
| --- | --- | --- | --- |
| postTitle | String | 제목 | O |
| postContenet | String | 내용 | O |

**Response**

**Response Body**

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

**Example**

```bash
curl -v -X PATCH "{communtiyPostNumber}" \
 -h "Authorization=Bearer XXXX" \
 -d "postTitle=사실 운동 그냥 안해도 돼요" \
 -d "postContent=그냥 밥 조금 덜 먹고 야식 안 먹는게 나은거 같기도 합니다" \
```

**Example**

**응답 성공**

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
  ]
}
```

**응답 : 실패 (존재하지 않는 게시물)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "NP",
  "message": "No Exist Post."
}
```

**응답 : 실패 (인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

**응답 실패 (권한 없음)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "NP",
  "message": "No Permission."
}
```

**응답 실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database error."
}
```

### 게시글 삭제

**설명**

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하고 URL에 커뮤니티 게시물 번호를 입력하여 요청하고 커뮤니티 게시물 삭제가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method : DELETE
- URL : **/{communtiyPostNumber}**

**Request**

**Header**

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

**Example**

```bash
curl -X DELETE "url" \
 -h "Authorization=Bearer XXXX" \
```

**Respons**

**Response Body**

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

**Example**

**응답 성공**

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

**응답 : 실패 (존재하지 않는 커뮤니티 게시물)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "NP",
  "message": "No Exist Product."
}
```

**응답 : 실패 (권한 없음)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "NP",
  "message": "No Permission."
}
```

**응답 : 실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 게시글 검색

**설명**

클라이언트는 요청 헤더에 Bearer 인증 토큰과 URL에 검색어를 포함하여 요청하고 조회가 성공적으로 이루어지면 게시판 목록에 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method : **GET**
- URL : **/{serach}**

**Request**

**Header**

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

**Example**

```
curl -v -X GET "{serach}" \
 -h "Authorization=Bearer XXXX"
```

**Response**

**Response Body**

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| communityPosts | CommunityPost[] | 게시판 리스트 | O |

CommunityPost

**Example**

| name | type | description | required |
| --- | --- | --- | --- |
| postSequence | Integer | 작성글 번호 | O |
| posterId | String | 작성자 아이디 | O |
| postDate | String | 작성 일자 | O |
| postCategory | String | 카테고리 | O |
| postTitle | String | 제목 | O |
| postLiked | Integer | 좋아요 수 | O |
| postViewCount | Integer | 조회수 | O |
| commentCount | Integer | 댓글 수 | O |

**응답 성공**

```
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success.",
  "communityPosts": [
    {
      "postSequence": 3,
      "posterId": "gildongpostId",
      "postDate": "2025-03-20 18:50",
      "postCategory": "health"
      "postTitle": "님들 운동하세요"
      "postLiked": 50,
      "postViewCount": 200
      "commentCount": 10
    }, ...
  ]
}
```

**응답 : 실패 (인증 실패)**

```
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

**응답 : 실패 (데이터베이스 에러)**

```
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 게시글 좋아요

**설명**

클라이언트는 요청 헤더에 Bearer 인증 토큰을 URL에 커뮤니티 게시물 번호 포함하여 요청하고 게시물 좋아요가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method : POST
- URL : **/{communityPostNumber}**

**Request**

**Header**

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

**Example**

```bash
curl -X POST "url" \
 -h "Authorization=Bearer XXXX" \
```

**Respons**

**Response Body**

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

**Example**

**응답 성공**

```
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (존재하지 않는 커뮤니티 게시물)**

```
HTTP/1.1 401 Unauthorized

{
  "code": "NP",
  "message": "No Exist Post."
}
```

**응답 : 실패 (인증 실패)**

```
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

**응답 : 실패 (데이터베이스 에러)**

```
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 게시글 좋아요 삭제

**설명**

클라이언트는 요청 헤더에 Bearer 인증 토큰을 URL에 커뮤니티 게시물 번호 포함하여 요청하고 게시물 좋아요 삭제가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method : DELETE
- URL : **/{communityPostNumber}**

**Request**

**Header**

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

**Example**

```bash
curl -X DELETE "url" \
 -h "Authorization=Bearer XXXX" \
```

**Respons**

**Response Body**

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

**Example**

**응답 성공**

```
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (존재하지 않는 커뮤니티 게시물)**

```
HTTP/1.1 401 Unauthorized

{
  "code": "NP",
  "message": "No Exist Post."
}
```

**응답 : 실패 (인증 실패)**

```
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

**응답 : 실패 (데이터베이스 에러)**

```
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 인기 게시글 등록

**설명**

특정시간이 되면 게시물의 좋아요를 기준으로 정렬해서 상위 10개의 게시물을 카테고리를 인기 게시판으로 수정합니다. 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method : PATCH
- URL : **/popular**

**Request**

**Request Body**

| name | type | description | required |
| --- | --- | --- | --- |
| category | String | 카테고리 | O |

**Response**

**Response Body**

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

**Example**

```
curl -v -X PATCH "" \
 -d "category="popular" \
```

**Example**

**응답 성공**

```
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
  ]
}
```

**응답 : 실패 (존재하지 않는 게시물)**

```
HTTP/1.1 400 Bad Request

{
  "code": "NP",
  "message": "No Exist Post."
}
```

**응답 실패 (데이터베이스 에러)**

```
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database error."
}
```

### 댓글 작성

**설명**

클라이언트는 요청 헤더에 Bearer 인증 토큰을 URL에 커뮤니티 게시물 번호, 댓글 내용을 포함하여 요청하고 게시물 댓글 작성이 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method : POST
- URL : **/{communityPostNumber}**

**Request**

**Header**

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

**Request Body**

| name | type | description | required |
| --- | --- | --- | --- |
| comment | String | 댓글 | O |

**Example**

```bash
curl -X POST "url" \
 -h "Authorization=Bearer XXXX" \
 -d "comment=이거 괜찮을듯!" \
```

**Respons**

**Response Body**

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

**Example**

**응답 성공**

```
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (존재하지 않는 커뮤니티 게시물)**

```
HTTP/1.1 401 Unauthorized

{
  "code": "NP",
  "message": "No Exist Post."
}
```

**응답 : 실패 (인증 실패)**

```
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

**응답 : 실패 (데이터베이스 에러)**

```
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 댓글 수정

**설명**

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하고 URL에 커뮤니티 게시물 번호, 댓글번호를, 본문에 제목, 내용을 입력하여 요청하고 댓글 수정이 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method : PATCH
- URL : **/{communtiyPostNumber}/{commentSequence}**

**Request**

**Header**

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

**Response**

**Response Body**

| name | type | description | required |
| --- | --- | --- | --- |
| comment | String | 댓글 | O |

**Example**

```
curl -v -X PATCH "{communtiyPostNumber}" \
 -h "Authorization=Bearer XXXX" \
 -d "comment="근데 이 내용은 좀 아닌듯..." \
```

**Example**

**응답 성공**

```
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
  ]
}
```

**응답 : 실패 (존재하지 않는 댓글)**

```
HTTP/1.1 400 Bad Request

{
  "code": "NC",
  "message": "No Exist Comment."
}
```

**응답 : 실패 (인증 실패)**

```
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

**응답 실패 (권한 없음)**

```
HTTP/1.1 500 Internal Server Error

{
  "code": "NP",
  "message": "No Permission."
}
```

**응답 실패 (데이터베이스 에러)**

```
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database error."
}
```

### 댓글 삭제

**설명**

클라이언트는 요청 헤더에 Bearer 인증 토큰을 URL에 커뮤니티 게시물 번호, 댓글 번호를 포함하여 요청하고 댓글 삭제가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method : DELETE
- URL : **/{communtiyPostNumber}/{commentSequence}**

**Request**

**Header**

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

**Example**

```bash
curl -X DELETE "url" \
 -h "Authorization=Bearer XXXX" \
```

**Respons**

**Response Body**

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

**Example**

**응답 성공**

```
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (존재하지 않는 댓글)**

```
HTTP/1.1 401 Unauthorized

{
  "code": "NC",
  "message": "No Exist Comment."
}
```

**응답 : 실패 (인증 실패)**

```
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

**응답 : 실패 (데이터베이스 에러)**

```
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

---

## Calendar 모듈

프로젝트명 서비스의 청년 달력과 관련된 REST API 모듈입니다.

일정 등록, 나의 일정 보기, 일정 상세 보기, 일정 수정, 일정 삭제 등의 API가 포함되어 있습니다.

Calendar 모듈은 모두 인증 후 요청할 수 있는 모듈입니다.

- url: /v1/calendar

### 일정 등록

설명

클라이언트는 요청 헤더에 Baerer 인증 토큰을 포함하고 제목, 날짜, 유형, 내용을 입력하여 요청하고 일정 등록이 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: **POST**

- url: 

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

Request Body

| name | type | description | required |
| --- | --- | --- | --- |
| title | String | 일정 제목 | O |
| startDate | String | 일정 시작 일자 | O |
| endDate | String | 일정 종료 일자 | O |
| type | String | 일정 유형 (지방세, 공과금, 월세, 개인) | O |
| content | String | 일정 내용 | X |

Example

```bash
curl -v -X POST "" \
 -h "Authorization=Bearer XXXX" \
 -d "title": "관리비 납부" \
 -d "startDate": "2025-04-09" \
 -d "endDate": "2025-04-09" \
 -d "type": "월세" \
 -d "content": "관리비 납부 자동이체 10만원"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success."
}
```

응답: 실패 (데이터 유효성 검사 실패)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 401 unauthorized

{
  "code": "AF",
  "message": "Auth Fail."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 나의 일정 보기

설명

클라이언트는 요청 헤더에 Baerer 인증 토큰을 포함하여 요청하고 조회가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method: GET

- url: 

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

Example

```bash
curl -v -X GET "" \
 -h "Authorization=Bearer XXXX"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| schedules | Schedule[] | 일정 리스트 | O |

Schedule

| name | type | description | required |
| --- | --- | --- | --- |
| title | String | 일정 제목 | O |
| startDate | String | 일정 시작 일자 | O |
| endDate | String | 일정 종료 일자 | O |
| type | String | 일정 유형 (지방세, 공과금, 월세, 개인, 지원사업) | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success."
	"schedules": [
		{
			"title": "관리비 납부",
			"startDate": "2025-04-09",
			"endDate": "2025-04-09",
			"type": "월세",
			"source": "user"
		}, ...
	]
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 401 unauthorized

{
  "code": "AF",
  "message": "Auth Fail."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 일정 상세 보기

설명

클라이언트는 요청 헤더에 Baerer 인증 토큰을 포함하고 URL에 일정번호를 포함하여 요청하고 조회가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 만약 존재하지 않는 일정의 경우 존재하지 않는 일정에 해당하는 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method: GET

- url: 

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

Example

```bash
curl -v -X GET "" \
 -h "Authorization=Bearer XXXX"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| title | String | 일정 제목 | O |
| startDate | String | 일정 시작 일자 | O |
| endDate | String | 일정 종료 일자 | O |
| type | String | 일정 유형 (지방세, 공과금, 월세, 개인, 지원사업) | O |
| source | String | 일정 출처 (user / policy) | O |
| content | String | 일정 내용 | X |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success."
	"title": "관리비 납부",
	"startDate": "2025-04-09",
	"endDate": "2025-04-09",
	"type": "월세",
	"source": "user",
	"content": "관리비 납부 자동이체 10만원"
}
```

응답: 실패 (존재하지 않는 일정)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "NS",
  "message": "No Exist Schedule."
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 401 unauthorized

{
  "code": "AF",
  "message": "Auth Fail."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 일정 수정

설명

클라이언트는 요청 헤더에 Baerer 인증 토큰을 포함하고 URL에 일정번호를, 본문에 제목, 시작 일자, 종료 일자, 일정 유형, 내용을 입력하여 요청하고 일정 수정이 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method: PATCH

- url: 

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

Request Body

| name | type | description | required |
| --- | --- | --- | --- |
| title | String | 일정 제목 | O |
| startDate | String | 일정 시작 일자 | O |
| endDate | String | 일정 종료 일자 | O |
| type | String | 일정 유형 (지방세, 공과금, 월세, 개인) | O |
| content | String | 일정 내용 | X |

Example

```bash
curl -v -X PATCH "" \
 -h "Authorization=Bearer XXXX" \
 -d "title": "관리비 납부" \
 -d "startDate": "2025-04-09" \
 -d "endDate": "2025-04-09" \
 -d "type": "월세" \
 -d "content": "관리비 납부 자동이체 10만원"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success."
	"title": "관리비 납부",
	"startDate": "2025-04-09",
	"endDate": "2025-04-09",
	"type": "월세",
	"source": "user",
	"content": "관리비 납부 자동이체 10만원"
}
```

응답: 실패 (데이터 유효성 검사 실패)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

응답: 실패 (존재하지 않는 일정)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "NS",
  "message": "No Exist Schedule."
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 401 unauthorized

{
  "code": "AF",
  "message": "Auth Fail."
}
```

응답: 실패 (권한 없음)

```bash
HTTP/1.1 403 Forbidden

{
  "code": "NP",
  "message": "No Permission."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 일정 삭제

설명

클라이언트는 요청 헤더에 Baerer 인증 토큰을 포함하고 URL에 일정 번호를 입력하여 요청하고 일정 삭제가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method: DELETE

- url: 

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

Example

```bash
curl -v -X DELETE "" \
	-h "Authorization=Bearer XXXX"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success."
}
```

응답: 실패 (데이터 유효성 검사 실패)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

응답: 실패 (존재하지 않는 일정)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "NS",
  "message": "No Exist Schedule."
}
```

응답: 실패 (인증 실패)

```bash
HTTP/1.1 401 unauthorized

{
  "code": "AF",
  "message": "Auth Fail."
}
```

응답: 실패 (권한 없음)

```bash
HTTP/1.1 403 Forbidden

{
  "code": "NP",
  "message": "No Permission."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

---

## SupportProject 모듈

프로젝트명 서비스의 청년 지원사업과 관련된 REST API 모듈입니다.

지원사업 리스트 보기, 지원사업 상세 보기, 지원사업 스크랩 등의 API가 포함되어 있습니다.

PublicProject 모듈 중 일부는 인증 후 요청할 수 있는 모듈입니다.

- url: 

### 지원사업 리스트 보기

설명

클라이언트는 인증 없이 조회가 가능하며, 인증을 받은 경우 스크랩 여부를 포함하여 요청하고 조회가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: GET

- url: 

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

Example

```bash
curl -v -X GET "" \
 -h "Authorization=Bearer XXXX"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| supports | Support[] | 지원사업 리스트 | O |

Support

Example

| name | type | description | required |
| --- | --- | --- | --- |
| region | String | 지역 | O |
| title | String | 지원사업명 | O |
| deadline | String | 신청 마감일 | O |
| sortDesc | String | 지원사업 한 줄 설명 | O |
| isScrapped | Boolean | 스크랩 여부 | X |

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success.",
	"supports": [
		{
			"region": "부산",
			"title": "부산시 청년 월세 지원",
			"deadline": "2025.05.10",
			"sortDesc": "부산시 청년들을 위한 월세 지원 사업입니다...",
			"isScrapped": true
		}, ...
	]
}
```

응답: 실패 (데이터 유효성 검사 실패)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 지원사업 상세 보기

설명

클라이언트는 인증 없이 조회가 가능하며, 인증을 받은 경우 스크랩 여부를 포함하여 요청하고 조회가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method: GET

- url: 

Request

Header

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

Example

```bash
curl -v -X GET "" \
 -h "Authorization=Bearer XXXX"
```

Response

Response Body

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| region | String | 지역 | O |
| title | String | 지원사업명 | O |
| deadline | String | 신청 마감일 | O |
| sortDesc | String | 지원사업 한 줄 설명 | O |
| qualification | String | 신청 자격 | O |
| applyUrl | String | 신청 사이트 URL | O |
| isScrapped | Boolean | 스크랩 여부 | X |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
	"code": "SU",
	"message": "Success.",
	"region": "부산",
	"title": "부산시 신혼부부 전세 지원",
	"deadline": "2025.05.10",
	"sortDesc": "부산시 신혼부부들을 위한 전세 지원 사업입니다...",
	"qualification": "신혼부부 / 예비신혼부부",
	"applyUrl": "https://...",
	"isScrapped": true
}
```

응답: 실패 (데이터 유효성 검사 실패)

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

응답: 실패 (데이터베이스 에러)

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 지원사업 스크랩

**설명**

클라이언트는 요청 헤더에 Bearer 인증 토큰을 URL에 지원사업 번호 포함하여 요청하고 게시물 스크랩이 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

- method : POST
- URL :

**Request**

**Header**

| name | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

**Example**

```bash
curl -X POST "url" \
 -h "Authorization=Bearer XXXX" \
```

**Respons**

**Response Body**

| name | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

**Example**

**응답 성공**

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

**응답 : 실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

---

## Event 모듈

프로젝트명 서비스의 이벤트와 관련된 REST API 모듈입니다.

이벤트 목록 조회, 이벤트 신청, 이벤트 참여자 목록 조회 등의 API가 포함되어 있습니다.

Event 모듈 중 일부는 인증 후 요청할 수 있는 모듈입니다.

- url: /v1/event

### 이벤트 목록 조회

설명

진행 중인 이벤트 목록을 반환합니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

 - method: **GET**

 - url:

Request

| **name** | description | required |
| --- | --- | --- |
| page | 이벤트 페이지 번호 (기본: 1) | X |

Reponse

Response Body

| **name** | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| events | Event[] | 이벤트 Array | O |
| totalCount | Integer | 전체 이벤트 수 | O |

Event

Example

| **name** | type | description |
| --- | --- | --- |
| eventNum | Integer | 이벤트 번호 |
| eventTitle | String | 이벤트 제목 |
| eventDeadline | String | 마감일자 |
| eventNeededPoint | Integer | 필요 포인트 |

응답 성공

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success.",
  "events": [
    {
      "eventNum": 5,
      "eventTitle": "봄맞이 이벤트",
      "eventDeadline": "2025-04-20",
      "eventNeededPoint": 100
    },
    ...
  ],
  "totalCount": 10
}

```

응답: **실패(인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

응답: **실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 이벤트 상세 이미지 조회

설명

진행 중인 이벤트 목록을 반환합니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

 - method: **GET**

 - url:

Request

Path Variable

| **name** | type | description | required |
| --- | --- | --- | --- |
| eventNum | Integer | 이벤트 페이지 번호 (기본: 1) | O |

Reponse

Response Body

| **name** | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| eventImg | String | 상세 사진 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success.",
  "imageUrl": "url/asset/images/event_5.jpg"
}

```

응답: **실패(인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

응답: **실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 이벤트 신청

설명

클라이언트는 요청 헤더에 Baerer 인증 토큰을 포함하고 유저가 이벤트 신청 버튼을 클릭하고 인증에 성공했을 시 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

 - method: **POST**

 - url:

Request

Header

| **name** | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 | O |

Path Variable

| **name** | type | description | required |
| --- | --- | --- | --- |
| eventNum | Integer | 이벤트 번호 | O |

Reponse

Response Body

| **name** | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

응답: **실패(중복 신청)**

```bash
HTTP/1.1 409 Conflict

{
  "code": "AA",
  "message": "Already applied."
}
```

응답: **실패(포인트 부족)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "NP",
  "message": "Not enough Point."
}
```

응답: **실패(인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

응답: **실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 이벤트 작성

설명

클라이언트는 요청 헤더에 Baerer 인증 토큰을 포함하여 이벤트 게시글을 작성할 수 있습니다. 

요청 본문에는 필수 항목(제목, 마감기한, 필요 포인트, 내용, 이미지 url)이 모두 포함되어야 하며, 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

해당 API는 관리자만 접근 가능합니다.

 - method: **POST**

 - url:

Request

Header

| **name** | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

Request Body

| **name** | type | description | required |
| --- | --- | --- | --- |
| eventTitle | String | 제목 | O |
| eventDeadline | String | 마감일 | O |
| eventNeededPoint | String | 차감 포인트 | X |
| eventContent | Array | 내용 | O |
| eventImg | Integer | 상세 사진 | X |

Example

```bash
curl -X POST "url" \
  -H "Authorization: Bearer XXXX" \
  -H "Content-Type: application/json" \
  -d '{
	  "title": "봄맞이 대축제",
	  "deadline": "2025-04-25",
	  "point": 150,
	  "content": "참여자 전원 포인트 증정!",
	  "imageUrl": "https://example.com/event-banner.jpg"
}'

```

Reponse

Response Body

| **name** | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

응답: **실패(인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

응답: **실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 이벤트 삭제

설명

클라이언트는 요청 헤더에 Baerer 인증 토큰을 포함하여 이벤트 게시글을 삭제할 수 있습니다. 

해당 API는 관리자만 접근 가능하며 서버, 데이터베이스, 인증 요청 에러가 발생할 수 있습니다.

 - method: **DELETE**

 - url:

Request

Header

| **name** | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

Path Variable

| **name** | type | description | required |
| --- | --- | --- | --- |
| eventNum | Integer | 이벤트 번호 | O |

Example

```bash
curl -X POST "url" \
  -H "Authorization: Bearer XXXX"
```

Reponse

Response Body

| **name** | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

응답: **실패(인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

응답: **실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

### 참여자 목록 조회

설명

클라이언트는 요청 헤더에 Baerer 인증 토큰을 포함하여 이벤트 번호를 입력받아 해당 이벤트를 신청한 사용자의 목록을 조회할 수 있습니다. 해당 API는 관리자만 접근할 수 있으며 서버 에러, 인증 실패, 데이터베이스 에러가 발생할 수 있습니다.

 - method: **GET**

 - url:

Request

Header

| **name** | description | required |
| --- | --- | --- |
| Authorization | Bearer 토큰 인증 헤더 | O |

Path Variable

| **name** | type | description | required |
| --- | --- | --- | --- |
| eventNum | Integer | 이벤트 번호 | O |

Example

```bash
curl -X POST "url" \
  -H "Authorization: Bearer XXXX"
```

Reponse

Response Body

| **name** | type | description | required |
| --- | --- | --- | --- |
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| applicants | Applicant[] | 신청자 목록 | O |
| totalCount | Integer | 총 신청자 수 | O |

Applicant

| **name** | type | description | required |
| --- | --- | --- | --- |
| userId | String | 유저 ID | O |
| userNickname | String | 닉네임 | O |

Example

응답 성공

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success.",
  "applicants": [
    {
      "userId": "user_001",
      "nickname": "유저12345"
    },
    {
      "userId": "user_002",
      "nickname": "유저67890"
    }
  ],
  "totalCount": 2
}
```

응답: **실패(인증 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

응답: **실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

---

---

---