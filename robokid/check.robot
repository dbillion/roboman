*** Settings ***
Library    RPA.HTTP
Library    Collections
Library    OperatingSystem

*** Variables ***
${BASE_URL}    https://restcountries.eu/rest/v2

*** Tasks ***
Get Unique Currencies In Europe
    ${unique_currencies}=    Get Currencies In Europe
    Log To Console    ${unique_currencies}
    ${unique_currencies_json}=    Convert To String    ${unique_currencies}
    Create File    unique_currencies.json    ${unique_currencies_json}
    ${total_currencies}=    Get Length    ${unique_currencies}
    Log To Console    Total number of unique currencies in Europe: ${total_currencies}

*** Keywords ***
Get Currencies In Europe
    Create Session    restcountries    ${BASE_URL}
    ${response}=    GET On Session   restcountries    /region/europe
    ${countries}=    Set Variable    ${response.json()}
    ${currencies}=    Create List
    FOR    ${country}    IN    @{countries}
        ${currencies_dict}=    Get From Dictionary    ${country}    currencies
        ${currency_codes}=    Get Dictionary Values    ${currencies_dict}        
        FOR    ${code}    IN    @{currency_codes}
            ${currency_code}=    Get From Dictionary    ${code}    code
            Append To List    ${currencies}    ${currency_code}
        END
    END
    ${unique_currencies}=    Evaluate    set(${currencies})
    [Return]    ${unique_currencies}
