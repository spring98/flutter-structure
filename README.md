# 건설공사 안전작업 허가서 작성 및 결재 앱
건설공사현장에서 안전작업 허가서를 작성하고, 결재자를 설정하여 순서대로 전자결재가 이루어지는 모바일앱을 개발하였습니다.<br/>
고객사에서 사용중이며, MAU 기준 AOS 460명, iOS 12명 입니다. <br/>
다른 플랫폼 모바일 어플리케이션 처럼 로그인, 앱 푸쉬, 공지 뿐만 아니라 유저 권한에 따른 NFC 태깅, 결재자 등록, 결재자 전자서명 등을 구현하였습니다.<br/><br/>

해당 레포지토리는 전체코드가 아니며, 사용했던 캐시로직, 암호로직 등을 설명하기 위한 데모 임을 알립니다.<br/><br/>

## 캐시로직 구현

간헐적으로 웹 서버가 다운되는 현상이 발생하였습니다. <br/>
원인은 서버 인메모리 부족으로 램을 추가 장착하는 것 외에도 클라이언트에서 서버의 부하를 줄일 수 있는 방법에 대해 고민하게 되었고, API 호출 데이터를 일일 단위로 분석해보았습니다.<br/><br/>
분석결과 이미지 파일(결재 사인 이미지, 관리자 프로필 사진, 작업자 프로필 사진)을 다운받는 API 호출이 평균 52.21% 로 상당히 많은 비중을 차지합니다. <br/>
아래 동영상과 같이 뷰를 스크롤 할 때마다 이미지를 받아왔기 때문입니다.<br/><br/>


https://github.com/spring98/flutter-structure/assets/92755385/e9bedb89-a14a-4457-9485-2d056eb584da

<br/><br/>

해당 문제를 해결하기 위해 서버로 부터 가져온 이미지 데이터에 대한 캐싱 구조를 아래 사진과 같이 설계하였습니다. <br/><br/>

![Sitemap (2)](https://github.com/spring98/flutter-structure/assets/92755385/3a32878a-3c0a-4f56-9cab-c0e676f543d5)

<br/><br/>
초기 뷰에서 MetaImageModel 를 리스트로 받아와 이미지 데이터 없이 리스트 뷰를 구성합니다.

리스트 뷰가 구성된 뒤 비동기적으로 imageId, updateTime 을 가지고 useCase, ImageRepository 로 이동하여 최신의 이미지 데이터를 얻습니다. 아래 동영상과 같이 랜덤 이미지를 생성하여 firebase 에 읽고 쓰는 데모를 작성하였습니다.



<br/><br/>



https://github.com/spring98/flutter-structure/assets/92755385/490eb91c-c7a9-45cf-8d3e-bfbb654420ed


<br/><br/>


1. 서버에서 데이터를 받아온 뒤 인메모리 및 로컬에 저장합니다. 
2. 이후 접속하게 되면 로컬 데이터를 받아와서 사용합니다. 
3. 화면 리프레쉬가 일어나면 인메모리에 있던 데이터를 사용합니다.
4. 서버에서 데이터가 업데이트 되어(녹색 N) 기존 로컬에 저장되어있던 데이터가 오래된 데이터가 되면 서버에서 새로 데이터를 받아와 최신데이터를 유지합니다.

<br/><br/>

## 캐시 데이터 조회 로직

1. imageId, updateTime 으로 in memory(램) data source 에 데이터가 있는지 조회
    1. 데이터가 있는 경우
        1. updateTime 과 비교하여 최신의 데이터인 경우 > 데이터 반환
        2. 오래된 데이터인 경우 > 2번으로 이동
    2. 데이터가 없는 경우 > 2번으로 이동
2. local(디스크) data source 에 데이터가 있는지 조회
    1. 데이터가 있는 경우
        1. updateTime 과 비교하여 최신의 데이터인 경우
            1. in memory data source 에 저장
            2. 데이터 반환
        2. 오래된 데이터인 경우 > 오래된 데이터를 가지고 3번으로 이동
    2. 데이터가 없는 경우 > 3번으로 이동
3. remote(서버) data source 에 데이터를 요청
    1. 데이터 수신에 성공
        1. in memory data source 에 저장
        2. local data source 에 저장
        3. 데이터 반환
    2. 데이터 수신에 실패
        1. 2번에 오래된 데이터가 있는 경우 > 오래된 데이터 반환
        2. 오래된 데이터도 없는 경우 > 에러 반환

<br/><br/>

## 캐시 데이터 저장 로직
1. in memory data source 에 저장

   <img width="614" alt="스크린샷 2024-05-01 13 06 05" src="https://github.com/spring98/flutter-structure/assets/92755385/d6c566ed-7e1c-4f9d-bb19-ff2cef14f63f">
 
    저장할 수 있는 이미지의 최대 개수를 초과 했거나 저장된 이미지들의 크기가 일정 크기 이상이 되면 가장 오래된 이미지를 삭제하여 저장
    
3. local data source 에 저장
    
   <img width="441" alt="스크린샷 2024-05-01 13 09 01" src="https://github.com/spring98/flutter-structure/assets/92755385/4e1f6088-b309-4439-8c7a-35db70b2cb70">
    
    저장할 수 있는 이미지의 최대 개수를 초과하면 가장 오래된 이미지를 삭제
    

<br/>

상대적으로 디스크보다 램의 자원이 더 한정적이므로 in memory 에 저장할 때는 이미지 개수와 이미지 사이즈로 관리하고 local data source 에 저장할 때 이미지 개수만으로 관리합니다. 

아래 왼쪽 사진은 _maxSize = 5000 이고, 아래 오른쪽 사진은 _maxSize = 8000 일 때 모습이며, 사진 아래 숫자가 이미지 데이터의 사이즈 입니다. 

_maxSize = 5000 일 때는 2개의 데이터만 저장가능하지만, _maxSize = 8000 일 때는 3개까지 저장 가능함을 알 수 있습니다.

<br/>

<p align="center">  
  <img src="https://github.com/spring98/flutter-structure/assets/92755385/971196b7-caf3-4fd2-8df2-dd38f8c8711e" align="center" width="32%">  
  <img width="10%">
  <img src="https://github.com/spring98/flutter-structure/assets/92755385/746df40e-636f-4793-8247-e75c27fc0e79" align="center" width="32%">
</p>


<br/>
추가적으로, 취급하고 있는 이미지 데이터가 결재 사인과 같은 민감한 정보를 포함 하므로 인메모리 및 로컬에 저장할 때 AES-256 알고리즘으로 암호화해서 저장해야합니다.

<br/><br/>
## 이미지 암호화 로직
현재 모바일에서 데이터를 안전하게 저장하기 위해 KeyStore, KeyChain 에 저장해야 합니다. 하지만 해당 저장소는 이미지와 같이 크기가 큰 데이터들을 저장하기 위한 목적으로 설계되어 있지 않기 때문에 대칭키와 초기벡터만 따로 KeyStore, KeyChain 에 저장하도록 합니다.

1. AES-256 알고리즘에 사용되는 대칭키(32Bytes)와 초기벡터(16Bytes)를 생성
2. 생성된 대칭키와 초기벡터로 이미지 암호화하여 인메모리 및 로컬에 저장
3. 생성된 대칭키와 초기벡터는 Android > KeyStore, iOS > KeyChain 에 저장

<p align="center">  
  <img src="https://github.com/spring98/flutter-structure/assets/92755385/d2f3cb55-a665-47b8-b065-8488e8119802" align="center" width="45%">
  <img src="https://github.com/spring98/flutter-structure/assets/92755385/66aa7ef5-1aec-4702-8919-dac4a36d57a3" align="center" width="45%">  
</p>

좌측은 대칭키와 IV 로 AES, CBC 모드로 ImageByteData (Uint8List) 를 암호화 하는 과정을 나타냅니다. <br/>
우측은 대칭키와 IV 로 AES, CBC 모드로 해당 데이터를 복호화 하는 과정을 나타냅니다.

<br/>

아래 사진과 같이 Image Hash 값과 Encrypt Image Hash 값은 다르지만 Image Hash 값과 Decrypt Image Hash 값은 같으므로 암호화와 복호화가 잘 되고 있음을 알 수 있습니다.


<br/>

<p align="center">  
  <img src="https://github.com/spring98/flutter-structure/assets/92755385/6f27b99d-bce4-44e6-9be9-541f148420e5" align="center" width="32%">
  <img width="10%">
  <img src="https://github.com/spring98/flutter-structure/assets/92755385/ac76ab7c-28dd-4565-b54a-0c5a16fffc88" align="center" width="32%">  
</p>

<br/><br/>

캐시로직을 반영한 결과 파일 다운로드 API 일일 평균 호출이 52.21% 에서 48.52% 로 3.69 %p 감소하여 7.06% 를 개선할 수 있었습니다.

<br/><br/>


<br/><br/>


<br/><br/>


<br/><br/>


<br/><br/>
