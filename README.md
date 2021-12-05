# README

# 🌱 프로젝트 소개

![image](https://user-images.githubusercontent.com/79497422/144741756-7bdaeaff-9c4c-4095-9e7c-0ab16d2760bc.png)

# 🌱 기능 소개

<img src = "https://user-images.githubusercontent.com/79497422/144741764-02ae269e-418c-45a0-bf1e-77312dbcf88f.png" width = "300"> &nbsp;&nbsp;&nbsp;&nbsp;
<img src = "https://user-images.githubusercontent.com/79497422/144741778-d68e761d-b5df-473e-a194-c418bdb71a9a.png" width = "300">

<img src = "https://user-images.githubusercontent.com/79497422/144742092-d036187e-ad1a-4858-89a4-08b93dbdd988.png" width = "300"> &nbsp;&nbsp;&nbsp;&nbsp;
<img src = "https://user-images.githubusercontent.com/79497422/144741786-1710d3a8-5f69-4586-be9d-5ca86f476403.png" width = "300">

<img src = "https://user-images.githubusercontent.com/79497422/144741796-c4bc518d-4eef-45d7-9f03-143bcc58e193.png" width = "300"> &nbsp;&nbsp;&nbsp;&nbsp;
<img src = "https://user-images.githubusercontent.com/79497422/144741802-b86d099b-26ca-4b42-80d3-ea0bd5b38000.png" width = "300">

<img src = "https://user-images.githubusercontent.com/79497422/144741809-3f0668ad-ca55-4908-9e6e-d5aedbafa979.png" width = "300"> &nbsp;&nbsp;&nbsp;&nbsp;
<img src = "https://user-images.githubusercontent.com/79497422/144741831-fd3a0ed3-6fcf-45bd-94d0-8e072fffd511.png" width = "300">

# 🌱 기술 특장점

### MVVM-C

![image](https://user-images.githubusercontent.com/79497422/144741844-877c6ee4-4e33-4d51-bcd4-d594fe579f6f.png)

- ViewModel을 구현해서 UIKit에 의존적이지 않은 `View 단위테스트`가 가능해졌습니다.
- `Clean Architecture 기반`으로 기능 별로 Usecase와 Entity를 구성함으로 써 각 모듈마다 독립적인 역할을 수행합니다.
- `Repository를 사용`하여 Database 요청이나 ImageCache, UserDefaults 등을 처리하는 하나의 인터페이스를 구성했습니다.
- `Combine을 사용`하여 ViewModel에서 받은 액션을 바인딩하여 ViewController의 Event와 데이터들을 처리했습니다.
- `Coordinator에서 화면 전환을 처리`하여 ViewController의 책임을 덜고 유지보수가 용이해 졌습니다.
- 각 Scene별로 Coordinator를 구성하여 `상위부터 하위 모듈까지 필요한 모듈(Repository, Usecase, ViewModel, ViewController)을 생성하여 주입`하였습니다.

### 이미지 처리 구현

챌린지 대표 이미지, 챌린지 인증샷 예시 이미지 등록에 필요한 이미지를 처리하기 위해 아래와 같은 기능을 구현하였습니다.  

`Kingfisher를 모방한 이미지 캐시 구현`

- 캐시 디렉토리에 이미지가 있을 경우 네트워크 요청없이 해당 이미지를 사용하고, 이미지가 없을 경우에만 네트워크를 요청하여 리소스를 최소화하였습니다.

`이미지 업로드시 다운사이징 구현`

- 앨범과 카메라를 통해 이미를 가져오면, 고화질의 고용량 이미지를 그대로 가져오게 되어 캐시와 Storage에 큰 부담이 됩니다. 이미지를 업로드하는 과정에서 이미지를 다운사이징하는 로직을 구현하였습니다.

`이미지 업로드시 다운사이징된 원본 이미지와 썸네일 이미지 구분 저장`

- 다운사이징을 하더라도 상세 화면에서 보여주는 이미지와 목록에서 보여주는 썸네일 이미지를 구분할 필요가 있다고 생각했습니다.
- 유저가 사진을 등록할 때 원본과 썸네일 이미지로 분리하여 별도로 저장/관리하는 로직을 구현하였습니다.

### StoryBoard 없이 개발

`StoryBoard를 사용하지 않는 이유` 

- View가 늘어날수록 StoryBoard를 여는데 걸리는 시간이 점점 길어져 작업하는데 비효율적이라는 생각이 들어 스토리보드를 사용하지 않고 개발하기로 결정 했습니다.
- 보통 스토리보드 없이 개발하면 SnapKit을 많이 사용하지만, 저희 조는 SnapKit을 사용하지않고 UIView에 Extension을 추가하여 함수로 짧고 간편하고 깔끔하게 사용했습니다.

`StoryBoard 없이 개발한 결과` 

- 충돌이 확연하게 줄어들었고, 충돌이 난 경우에도 어렵지 않게 해결이 가능했습니다.
- View와 AutoLayout에 대한 이해도가 높아졌고, iPod Touch와 같이 작은 화면 크기에 대응하는 법도 터득할 수 있었습니다.

### 외부 라이브러리 사용하지 않고 개발

`RoutinusDatabase 모듈 구현` 

- Firebase SDK를 import하여 사용하지 않고 REST API 모듈을 만들어 구현하였습니다.

`RoutinusImageManger 모듈 구현`

- Kingfisher 대신 이미지 처리 모듈 구현하였습니다.

`SnapKit 대신 AutoLayout 지정한 공통 메소드 구현` 

- SnapKit 대신 AutoLayout을 Constraint로 지정 해주는 방식으로 구현하였습니다.
- AutoLayout을 지정 해 주는 코드가 길어지는 문제와 사람마다 통일성이 떨어지는 문제를 해결하기 위해 UIView의 Extension으로 공통 메소드를 생성하여 사용하고 있습니다.

# 🌱 팀원 소개

|사진|내용|
|:---:|:---|
|<img src = "https://user-images.githubusercontent.com/79497422/144742156-4ecf4d93-c07d-402b-949a-56a3bab82098.png" width = "100">|[S006 **김민서**](https://github.com/mingso) <br> 초기 View 관련 컨벤션 코드 작성, 캘린더 기능 구현 <br> 발표자료 정리하기, 디자인 리소스 담당 |
|<img src = "https://user-images.githubusercontent.com/79497422/144742166-2cd31bba-a455-4622-a1b9-fd6c62802cb4.png" width = "100">|[S016 **박상우**](https://github.com/motosw3600) <br> 전반적인 아키텍처 구성, 테스트 코드 작성, 데이터 동기화 <br> 리더, 팀 내 분위기 메이커 담당 |
|<img src = "https://user-images.githubusercontent.com/79497422/144742170-eec0da85-3d33-4d8a-ad6f-56b6bdde353a.png" width = "100">|[S022 **백지현**](https://github.com/bhyun) <br> 생성, 추가, 인증과 관련된 비즈니스 로직 <br> 발표 영상 편집, 서기 담당 |
|<img src = "https://user-images.githubusercontent.com/79497422/144742177-38999041-411d-4767-93ad-0c83a18400ff.png" width = "100">|[S032 **유석환**](https://github.com/youseokhwan) <br> 이미지 다운사이징 및 캐싱, 데이터 모델링, Firebase 구축, 전반적인 리팩토링 <br> wiki 작성, 팀 내 스피커 담당 |
