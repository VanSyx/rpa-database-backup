*** Settings ***
Documentation     Viết ít nhất 2 test case
Library           SeleniumLibrary

*** Variables ***
${URL}           https://opensource-demo.orangehrmlive.com/web/index.php/auth/login

# Real
${USERNAME}      Admin    
${PASSWORD}      admin123

#Fake
${USERNAME_FAKE}      test
${PASSWORD_FAKE}      123456

*** Test Cases ***    
Valid Login
    # 1. Mở trình duyệt
    Mở trình duyệt    
    # 2. đăng nhập
    Đăng nhập     ${USERNAME}     ${PASSWORD}
    # 3. kiểm tra đăng nhập thành công
    Kiểm tra đăng nhập thành công
    # 4. đóng trình duyệt
    Đóng trình duyệt

Invalid Login
    # 1. Mở trình duyệt
    Mở trình duyệt    
    # 2. đăng nhập
    Đăng nhập     ${USERNAME_FAKE}    ${PASSWORD_FAKE}
    # 3. kiểm tra đăng nhập không thành công
    Kiểm tra đăng nhập thất bại
    # 4. đóng trình duyệt
    Đóng trình duyệt

Empty Login Fields
    # 1. Mở trình duyệt
    Mở trình duyệt    
    # 2. Nhấn button Login
    Nhấn Login  
    # 3. kiểm tra đăng nhập không thành công
    Kiểm tra nhập thông tin
    # 4. đóng trình duyệt
    Đóng trình duyệt

*** Keywords ***
Mở trình duyệt
    Open Browser    ${url}    chrome
    Maximize Browser Window

Đăng nhập
    [Arguments]    ${USERNAME}    ${PASSWORD}
    Wait Until Element Is Visible    name=username    10s
    Input Text    name=username    ${USERNAME}
    Wait Until Element Is Visible    name=password   10s
    Input Text    name=password    ${PASSWORD}
    Click Button  xpath=//*[@id="app"]/div[1]/div/div[1]/div/div[2]/div[2]/form/div[3]/button

Kiểm tra đăng nhập thành công
    Location Should Contain      dashboard/index

Kiểm tra đăng nhập thất bại
    Wait Until Element Is Visible    xpath=//*[@id="app"]/div[1]/div/div[1]/div/div[2]/div[2]/form/div[3]/button    10s
    Page Should Contain      Invalid credentials

Nhấn Login
    Wait Until Element Is Visible   xpath=//*[@id="app"]/div[1]/div/div[1]/div/div[2]/div[2]/form/div[3]/button    10s
    Click Button  xpath=//*[@id="app"]/div[1]/div/div[1]/div/div[2]/div[2]/form/div[3]/button

Kiểm tra nhập thông tin  
    Wait Until Element Is Visible    xpath=(//span[text()="Required"])[1]    5s
    Element Should Be Visible    xpath=(//span[text()="Required"])[1]
    Element Should Be Visible    xpath=(//span[text()="Required"])[2]

Đóng trình duyệt
    Close Browser