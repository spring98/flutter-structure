# 건설공사 안전작업 허가서 작성 및 결재 앱
건설공사현장에서 안전작업 허가서를 작성하고, 결재자를 설정하여 순서대로 전자결재가 이루어지는 모바일앱을 개발하였습니다.

고객사에서 사용중이며, MAU 기준 AOS 460명, iOS 12명 입니다.

다른 플랫폼 모바일 어플리케이션 처럼 로그인, 앱 푸쉬, 공지 뿐만 아니라 유저 권한에 따른 NFC 태깅, 결재자 등록, 결재자 전자서명 등을 구현하였습니다.

해당 레포지토리는 전체코드가 아니며, 사용했던 캐시로직, 암호로직 등을 설명하기 위한 데모 입니다.<br/><br/>

## 캐시로직 구현

간헐적으로 웹 서버가 다운되는 현상이 발생하였습니다.

원인은 서버 인메모리 부족으로 램을 추가 장착하는 것 외에도 클라이언트에서 서버의 부하를 줄일 수 있는 방법에 대해 고민하게 되었고, API 호출 데이터를 일일 단위로 분석해보았습니다.

분석결과 이미지 파일(결재 사인 이미지, 관리자 프로필 사진, 작업자 프로필 사진)을 다운받는 API 호출이 평균 52.21% 로 상당히 많은 비중을 차지합니다.

아래 동영상과 같이 뷰를 스크롤 할 때마다 이미지를 받아왔기 때문입니다.<br/><br/>


https://github.com/spring98/flutter-structure/assets/92755385/e9bedb89-a14a-4457-9485-2d056eb584da

<br/><br/>

해당 문제를 해결하기 위해 서버로 부터 가져온 이미지 데이터에 대한 캐싱 구조를 아래 사진과 같이 설계하였습니다. <br/><br/>

![Sitemap (2)](https://github.com/spring98/flutter-structure/assets/92755385/3a32878a-3c0a-4f56-9cab-c0e676f543d5)

<br/><br/>
초기 뷰에서 MetaImageModel 를 리스트로 받아와 이미지 데이터 없이 리스트 뷰를 구성합니다.

리스트 뷰가 구성된 뒤 비동기적으로 imageId, updateTime 을 가지고 useCase, ImageRepository 로 이동하여 최신의 이미지 데이터를 얻습니다. 

아래 동영상과 같이 랜덤 이미지를 생성하여 firebase 에 읽고 쓰는 데모를 작성하였습니다.



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
현재 모바일에서 데이터를 안전하게 저장하기 위해 KeyStore, KeyChain 에 저장해야 합니다.

하지만 해당 저장소는 이미지와 같이 크기가 큰 데이터들을 저장하기 위한 목적으로 설계되어 있지 않기 때문에 대칭키와 초기벡터만 따로 KeyStore, KeyChain 에 저장하도록 합니다.

1. AES-256 알고리즘에 사용되는 대칭키(32Bytes)와 초기벡터(16Bytes)를 생성
2. 생성된 대칭키와 초기벡터로 이미지 암호화하여 인메모리 및 로컬에 저장
3. 생성된 대칭키와 초기벡터는 Android > KeyStore, iOS > KeyChain 에 저장

<p align="center">  
  <img src="https://github.com/spring98/flutter-structure/assets/92755385/d2f3cb55-a665-47b8-b065-8488e8119802" align="center" width="45%">
  <img src="https://github.com/spring98/flutter-structure/assets/92755385/66aa7ef5-1aec-4702-8919-dac4a36d57a3" align="center" width="45%">  
</p>

좌측은 대칭키와 IV 로 AES, CBC 모드로 ImageByteData (Uint8List) 를 암호화 하는 과정을 나타냅니다.

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
## E2E 테스트 도입

해당 프로젝트의 가장 중요한 기능은 안전작업 허가서 작성과 허가서에 지정된 결재자 순서대로 결재가 정상적으로 처리되는 것입니다. 

프로세스를 요약하면 아래와 같습니다.

1. A 라는 관리자가 결재자 B1 부터 B14 까지 지정하여 허가서를 작성
2. 허가서가 등록되면 B1 에게 알람이 전송되며 결재를 진행
3. B1 이 결재를 마치면 B2 에게 알람이 전송되고 결재를 진행
4. B14 까지 반복

문제는 B1 부터 B14 까지의 인원들이 결재해야하는 화면이 허가서 내 선택한 양식 마다 다르기 때문에 기능이 수정될 때마다 모든 양식에 대해 테스트를 진행해야한다는 점이었습니다. 

모든 양식에 대해 테스트 하려면 25번의 결재과정이 필요 하였고, 결재 마다 1. 로그인 2. 결재 3. 로그아웃 의 프로세스가 강제되었습니다.

배포 때마다 이러한 휴먼에러와 반복작업을 줄일 수 있는 자동 테스트에 대해 고민하게 되었습니다.

Flutter 에서 제공하는 E2E 테스트 패키지인 integration_test 를 사용하였으며, iOS Simulator 를 지정하여 진행하였습니다. 

관심있는 위젯에 Key 를 지정해서 현재 화면에 해당 위젯이 있는 지 확인 할 수 있고, 클릭 하거나 TextField 에 값을 넣는 등 상호작용이 가능하여 정밀한 테스트가 가능하였습니다. 

또한 실제 서버의 API 호출을 사용할 수 있어 라이브 테스트가 가능하였습니다.



<br/><br/>
## 자동배포 도입

Flutter 로 개발을 진행하다보니 배포 시 AOS, iOS 두 플랫폼에 대해 각각 빌드한 후 빌드파일을 PlayStore, AppStore 에 GUI 방식으로 조작하여 배포가 진행되기 때문에 다음 단계로 진행하기 위해 지속적으로 화면을 주시하고 있어야 합니다. 

AOS 의 경우 비교적으로 빌드 시간도 짧고 배포과정도 단순하기 때문에 피로감을 크게 느끼지 않았지만 iOS 의 경우는 빌드 중에 과정마다 클릭해야하는 요소들이 존재하고, 빌드 파일이 AppStore 홈페이지에 반영 되는 시간도 꽤 걸리기 때문에 다소 피로감을 느꼈고, 자동배포에 대해 고민하게 되었습니다.

자동 배포에 github actions, fastlane 2가지 툴을 사용하였는데 AOS 와 iOS 의 사용범위가 약간 다릅니다. 

AOS 의 경우 fastlane 명령 이전에 빌드파일을 생성하지만 iOS 는 fastlane 명령 후 빌드파일을 생성하기 때문입니다. <br/><br/>


### Workflow 요약
- git fetch, branch checkout
- flutter 의존성 설치
- secrets 데이터 복사
    
    AOS
    
    - /android/keystore.properties 에 github actions > secrets > keystore 데이터 복사
    - release.aab 빌드파일 생성
    
    iOS
    
    - pod 의존성 설치
    - /ios/fastlane/.env 에 github actions > secrets > apple fastlane password 데이터 복사
- fastlane beta 실행

마지막으로 fastlane beta 실행이 되면 아래와 같이 작동하게 됩니다.

 - name: Android Beta
        run: cd android && fastlane beta

 - name: iOS Beta
        run: cd ios && fastlane beta

<br/>

이러한 과정으로 두 플랫폼에 대해 내부 테스트 환경으로 배포 되며 


<br/><br/>

참고 코드는 아래와 같습니다.

<br/>

### github actions > workflow.yml

```yaml
name: Flutter CI

on:
  push:
    branches: [ main, release/* ]
  pull_request:
    branches: [ main, release/* ]

jobs:
  build:
    runs-on: springui-Macmini
    
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Set Flutter Version
        run: fvm use 3.10.0

      - name: Clean Packages
        run: fvm flutter clean

      - name: Pub Get Packages
        run: fvm flutter pub get

      - name: Pod 초기화
        run: rm -f ios/Podfile.lock && rm -rf ios/Pods

      - name: Pod repository 업데이트
        run: cd ios && pod install

      - name: Write Android keystore.properties file
        env:
          PROPERTIES_PATH: "./android/keystore.properties"
        run: |
          touch android/keystore.properties
          echo keyPassword=\${{ secrets.KEY_PROPERTY_KEY_PASSWORD }} > ${{env.PROPERTIES_PATH}}
          echo storePassword=\${{ secrets.KEY_PROPERTY_STORE_PASSWORD }} >> ${{env.PROPERTIES_PATH}}
          echo keyAlias=\${{ secrets.KEY_PROPERTY_KEY_ALIAS }} >> ${{env.PROPERTIES_PATH}}
          echo storeFile=\${{ secrets.KEY_PROPERTY_STORE_FILE }} >> ${{env.PROPERTIES_PATH}}

      - name: Decoding Keystore file
        run: echo "${{ secrets.ANDROID_KEYSTORE_BASE64 }}" | base64 --decode > android/app/key.keystore

      - name: Write iOS .env file
        env:
          FASTLANE_ENV_PATH: "./ios/fastlane/.env"
        run: |
          touch ios/fastlane/.env
          echo FASTLANE_USER=\${{ secrets.FASTLANE_USER }} > ${{env.FASTLANE_ENV_PATH}}
          echo FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD=\${{ secrets.FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD }} >> ${{env.FASTLANE_ENV_PATH}}

      - name: build appbundle
        run: fvm flutter build appbundle

      - name: Android Beta
        run: cd android && fastlane beta

      - name: iOS Beta
        run: cd ios && fastlane beta
```

<br/><br/>

### android > fastlane > Fastfile 
```yaml
default_platform(:android)

platform :android do
  desc "Runs all the tests"
  lane :test do
    gradle(task: "test")
  end

  desc "Submit a new Beta Build to Crashlytics Beta"
  lane :beta do
    gradle(task: "clean bundleRelease")
    upload_to_play_store(
        track: 'internal',
        skip_upload_changelogs: true,
        aab: '../build/app/outputs/bundle/release/app-release.aab',
    )
  end

  desc "Deploy a new version to the Google Play"
  lane :deploy do
    gradle(task: "clean assembleRelease")
    upload_to_play_store
  end
end
```

<br/><br/>

### ios > fastlane > Fastfile
```yaml
default_platform(:ios)

platform :ios do
  desc "Push a new beta build to TestFlight"
  lane :beta do
    increment_build_number(xcodeproj: "Runner.xcodeproj")
    build_app(
        workspace: "Runner.xcworkspace",
        scheme: "Runner",
        export_xcargs: "-allowProvisioningUpdates"
    )
    upload_to_testflight
  end
end

```


