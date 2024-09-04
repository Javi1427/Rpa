*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    Collections

*** Variables ***
${URL}                     https://www.roboform.com/es/password-generator
${BROWSER}                 chrome
${BUTTON_LOCATOR}          //*[@id="button-password"]
${TEXT_LOCATOR}            //*[@id="text-password"]
${CHARACTER_INPUT}         //*[@id="number-of-characters"]
${OUTPUT_FILE}             contraseña.txt
${NUM_PASSWORDS}           10
${NEW_LENGTH}              6
${PASSWORD_LIST_LOCATOR}  //*[@id="password-field"]/ul[1]/li

*** Test Cases ***
Generate And Save Passwords
    [documentation]  This test case generates 10 passwords, saves them to a text file, and prints them to the console
    Open Browser    ${URL}    ${BROWSER}
    Set Password Length    ${NEW_LENGTH}
    ${passwords}=    Create List
    FOR    ${i}    IN RANGE    ${NUM_PASSWORDS}
        ${password}=    Generate Password
        Append To List    ${passwords}    ${password}
        Log    Generated password: ${password}
    END
    Save Passwords To File    ${passwords}    ${OUTPUT_FILE}
    Save Password List To File    ${PASSWORD_LIST_LOCATOR}    ${OUTPUT_FILE}
    Close Browser

*** Keywords ***
Generate Password
    [documentation]  Clicks the button to generate a password and returns it
    Scroll Element Into View    ${BUTTON_LOCATOR}
    Wait Until Element Is Visible    ${BUTTON_LOCATOR}    10s
    Wait Until Element Is Enabled    ${BUTTON_LOCATOR}    10s
    Click Element    ${BUTTON_LOCATOR}
    ${password}=    Get Text    ${TEXT_LOCATOR}
    RETURN    ${password}

Set Password Length
    [documentation]  Sets the length of the password to ${NEW_LENGTH}
    [arguments]    ${length}
    Input Text    ${CHARACTER_INPUT}    ${length}
    Press Keys    ${CHARACTER_INPUT}    [Return]

Save Passwords To File
    [documentation]  Saves the list of passwords to a text file
    [arguments]    ${passwords}    ${file_path}
    Create File    ${file_path}
    FOR    ${password}    IN    @{passwords}
        Append To File    ${file_path}    ${password}\n
    END

Save Password List To File
    [documentation]  Saves the list of passwords from the page to a text file
    [arguments]    ${locator}    ${file_path}
    ${elements}=    Get WebElements    ${locator}
    Create File    ${file_path}
    FOR    ${element}    IN    @{elements}
        ${text}=    Get Text    ${element}
        Append To File    ${file_path}    ${text}\n
    END
